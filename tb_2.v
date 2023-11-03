module tb_2 #(parameter bus_width = 8)
();


reg              i_Clk,i_Rst_L,i_TX_DV,i_SPI_MISO;
reg [bus_width-1:0]   i_TX_Byte;
wire  [bus_width-1:0]   o_RX_Byte;
wire                    o_SPI_MOSI,o_TX_Ready,o_SPI_Clk;

SPI_Master spi(.i_Clk(i_Clk),
    .i_Rst_L(i_Rst_L),
    .i_TX_DV(i_TX_DV),
    .i_SPI_MISO(i_SPI_MISO),
    .i_TX_Byte(i_TX_Byte),
    .o_RX_Byte(o_RX_Byte),
    .o_SPI_MOSI(o_SPI_MOSI),
    .o_TX_Ready(o_TX_Ready),
    .o_SPI_Clk(o_SPI_Clk)
    );

`include "tasks_2.v"

reg mode=1;
integer n=5;

always #5 i_Clk=~i_Clk;

initial begin
    reset(mode);
    fork
    drive(n);
    drive_miso(n);
    monitor();
    monitor_miso();
    join
end
    
endmodule