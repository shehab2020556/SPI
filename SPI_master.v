`include "register.v"
`include "MUX.v"
`include "serializer.v"
`include "parallelizer.v"
`include "counter.v"
`include "clk_divider.v"
`include "SPI_signal_gen.v"

module SPI_Master #(
    parameter bus_width=8,
    parameter reg_number=3,
    parameter num_of_bits=6
) (
    input   wire                    i_Clk,i_Rst_L,i_TX_DV,i_SPI_MISO,
    input   wire  [bus_width-1:0]   i_TX_Byte,
    output  wire  [bus_width-1:0]   o_RX_Byte,
    output  wire                    o_SPI_MOSI,o_TX_Ready,o_SPI_Clk 

);

wire o_trailing_edge,o_leading_edge;

SPI_signal_gen #(.reg_number(3),.num_of_bits(6)) SPI_signal_gen_0(
    .clk(i_Clk),
    .rst(i_Rst_L),
    .i_cpol(1'b1),
    .i_tx_valid(i_TX_DV),
    .out_clk(o_SPI_Clk),
    .o_tx_rdy(o_TX_Ready),
    .o_leading_edge(o_leading_edge),
    .o_trailing_edge(o_trailing_edge)
    );

serializer #(.bus_width(bus_width)) serializer_0(
    .clk(i_Clk),
    .enable(o_leading_edge),
    .rst(i_Rst_L),
    .data_valid(i_TX_DV),
    .p_data(i_TX_Byte),
    .s_data(o_SPI_MOSI)
    );

prallelizer #(.bus_width(bus_width)) parallelizer_0 (
    .clk(i_Clk),
    .enable(o_trailing_edge),
    .rst(i_Rst_L),
    .p_data(o_RX_Byte),
    .s_data(i_SPI_MISO)
);
    
endmodule