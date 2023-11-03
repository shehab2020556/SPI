module SPI_signal_gen #(
    parameter reg_number=3,
    parameter num_of_bits=6
) (
    input  wire   clk,rst,i_cpol,i_tx_valid,
    output wire    out_clk,o_tx_rdy,
    output reg    o_leading_edge,o_trailing_edge
);


wire [reg_number-1:0] c_i;
wire [num_of_bits-1:0] c_i_1;
wire i_tx_valid_delayed;
wire enable_extended,pulse_enable;
reg tx_pre_ready;



assign i_tx_valid_delayed=i_tx_valid;


clk_divider #(.reg_number(reg_number)) clk_divider_1(.clk(clk),.rst((~o_tx_rdy)&rst),
                                                 .enable(enable_extended),.i_cpol(i_cpol),
                                                 .out_clk(out_clk),.c_i(c_i));



always @(posedge clk or negedge rst) begin
    if (!rst)
    o_leading_edge<=0;
    else if (c_i==2)
    o_leading_edge<=1;
    else
    o_leading_edge<=0;
end

always @(posedge clk or negedge rst) begin
    if (!rst)
    o_trailing_edge<=0;
    else if (c_i==6)
    o_trailing_edge<=1;
    else
    o_trailing_edge<=0;
end

counter #(.reg_number(num_of_bits)) counter_1(.clk(clk),.rst((~o_tx_rdy)&rst),
                                                 .enable(enable_extended),.c_i(c_i_1));

always @(posedge clk or negedge rst) begin
    if (!rst)
    tx_pre_ready<=0;
    else if (c_i_1==62)
    tx_pre_ready<=1;
    else
    tx_pre_ready<=0;
end
reg x,y;

always @(*) begin
    x= i_tx_valid_delayed | enable_extended;
    y= ~tx_pre_ready & x;
    
end


register #(.bus_width(1)) d1 (.d(y),.clk(clk),.rst(rst),.enable(1'b1),.q(enable_extended)); 

register #(.bus_width(1)) d2 (.d(tx_pre_ready),.clk(clk),.rst(rst),.enable(1'b1),.q(o_tx_rdy)); 

// pulse_gen pulse_gen_0 (.clk(clk),.in(enable_extended),.rst(rst),.out(pulse_enable));



endmodule
