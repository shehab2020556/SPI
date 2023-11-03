`define fatal(error)\
begin\
$display("error in %s", error);\
$finish;\
end

task reset;
input mode;
begin
    if (mode ==1 ) begin
        #10 i_Rst_L=0; i_Clk=0;  i_TX_DV=0; i_SPI_MISO=0; i_TX_Byte=8'b0;
        #10 i_Rst_L=1;
        #10;
    end
    else begin
        #10 i_Rst_L=0; i_Clk=0;  i_TX_DV=0; i_SPI_MISO=0; i_TX_Byte=8'b0;
        #10 i_Rst_L=1;
        #10;
    end
end
endtask




task drive;
input integer n;
begin
    repeat (n) begin
    @(posedge i_Clk)
    i_TX_DV=1;
    i_TX_Byte=8'b1110_1000;
    @(posedge i_Clk)
    i_TX_DV=0;
    i_TX_Byte=8'b0000_0000;
    #900;
    end
    $stop;

end
endtask

task drive_miso;
input integer n;
integer m;
reg [7:0] p_data_miso;
begin
    repeat (n) begin
    p_data_miso=8'b1101_0000;
    m=7;
    @(posedge i_TX_DV)
    repeat (8) begin
        @(negedge o_SPI_Clk)
        i_SPI_MISO= p_data_miso[m];
        m=m-1;
    end
    m=0;
    end

end
endtask

task monitor;
integer n,m;
reg [7:0] p_data;
begin
    m=0;
    while(1)begin
    @(posedge i_TX_DV)
    n=0;
    repeat(8) begin
    
    @(negedge o_SPI_Clk)
    p_data[n]=o_SPI_MOSI;
    n=n+1;

    end
    m=m+1;
    $display("packet mosi number %d = %b" ,m,p_data);
    end

end
endtask

task monitor_miso;
integer n,m;
reg [7:0] p_data;
begin
    m=0;
    while(1)begin
    @(posedge o_TX_Ready)
    m=m+1;
    $display("packet miso number %d = %b" ,m,o_RX_Byte);
    end


    

end
endtask