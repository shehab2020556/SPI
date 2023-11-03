module serializer #(
    parameter  bus_width=8
) (
    input  wire clk,enable,rst,data_valid,
    input  wire [bus_width-1:0] p_data,
    output wire s_data
);

// reg [bus_width-1:0] reg_p_data;
wire [bus_width-1:0] shr_out;
wire [bus_width-2:0] mux_out;

// always @(posedge clk or negedge rst) begin
//     if (!rst) begin
//         reg_p_data<= {bus_width{1'b0}};        
//     end
//     else if(data_valid) begin
//         reg_p_data<= p_data;
//     end
// end


genvar i;

generate
    for (i=1; i<=(bus_width-1); i=i+1) begin
        MUX #(.bus_width(1)) mux_0(.in1(shr_out[i-1]),.in2(p_data[i]),.sel_line(data_valid),.out(mux_out[i-1]));
    end
endgenerate


register #(.bus_width(1)) d0 (.d(p_data[0]),.rst(rst),.clk(clk),.enable(enable||data_valid),.q(shr_out[0]));
generate
    for (i=1; i<=(bus_width-1); i=i+1) begin
        register #(.bus_width(1)) d1 (.d(mux_out[i-1]),.clk(clk),.rst(rst),.enable(enable||data_valid),.q(shr_out[i])); 
    end
endgenerate

register #(.bus_width(1)) d3 (.d(shr_out[bus_width-1]),.clk(clk),.rst(rst),.enable(enable),.q(s_data));

    
endmodule