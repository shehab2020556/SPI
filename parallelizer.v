module prallelizer #(
    parameter bus_width=8,
    parameter counter_reg=$clog2(bus_width)
) (
    input  wire                          clk,rst,enable,s_data,
    output wire [bus_width-1:0]          p_data 
);

wire [bus_width-1:0] q;
reg [counter_reg-1:0] counter;
// wire read;
genvar i;

 register #(.bus_width(1)) d0 (.d(s_data),.clk(clk),.rst(rst),.enable(enable),.q(q[0])); 

generate
    for (i = 1 ; i<= bus_width-1 ;i= i+1 ) begin
        register #(.bus_width(1)) d1 (.d(q[i-1]),.clk(clk),.rst(rst),.enable(enable),.q(q[i])); 
    end
endgenerate


 assign p_data[bus_width-1:0]=q[bus_width-1:0];
//  register #(.bus_width(bus_width)) d2 (.d(q),.clk(clk),.rst(rst),.enable(read),.q(p_data)); 

// always @(posedge clk or negedge rst) begin
//     if (!rst) begin
//         counter <= {counter_reg{1'b0}};
//     end
//     else if (enable==1 && counter != (bus_width))  begin
//         counter <= counter +1;
//     end
//     else if (counter == (bus_width)) begin
//         counter <= 0;
//     end
//     else begin
//         counter <= counter;
//     end
    
// end

// assign read = (counter == (bus_width))? 1'b1:1'b0;
    
endmodule