module clk_divider #(
    parameter reg_number=3
) (
    input  wire   clk,rst,enable,i_cpol,
    output reg    out_clk,
    output wire [reg_number-1:0] c_i
);

genvar i;

register #(.bus_width(1)) d1 (.d(!c_i[0]),.clk(clk),.rst(rst),.enable(enable),.q(c_i[0])); 
generate
    for (i = 1 ; i< reg_number ; i=i+1 ) begin
        register #(.bus_width(1)) d2 (.d(!c_i[i]),.clk(!c_i[i-1]),.rst(rst),.enable(enable),.q(c_i[i])); 
    end
endgenerate

always @(*) begin
    if (i_cpol==1 && enable==1)
    out_clk<=~c_i[reg_number-1];
    else if(i_cpol==0 && enable==1)
    out_clk<=c_i[reg_number-1 ];
    else if(i_cpol==1 && enable==0)
    out_clk<=1;
    else if(i_cpol==0 && enable==0)
    out_clk<=0;
end

endmodule