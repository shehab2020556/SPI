module MUX #(
    parameter bus_width=1
) (
    input wire [bus_width-1:0] in1,in2,
    input wire sel_line,
    output reg [bus_width-1:0] out

);
    
always @(*) begin
    case (sel_line)
        1'b0:  out=in1;
        1'b1: out=in2;
        default: out=in1;
    endcase    
end


endmodule