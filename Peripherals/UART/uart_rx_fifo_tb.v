`timescale 1ps/1ps
module uart_rx_fifo_tb;
    reg clk, reset, wr_i, start;
    wire tdi;
    reg rd;
    reg [7:0] w_data;
    uart_tx_fifo #(.P(0), .W(2), .s(2), .TIMER(5)) uart_tx (
        .clk(clk), .reset(reset), .wr(wr_i), .start(start), .w_data(w_data), .tdo(tdi)
    );
    uart_rx_fifo #(.P(0), .W(2), .s(2), .TIMER(5)) uut (
        clk, reset, tdi, rd
    );   
    initial begin
        rd <= 0;
        clk <= 0;start <= 0;w_data <= 8'h00; wr_i <= 0; reset <= 0; #20
        reset <= 1; #20
        reset <= 0;
        w_data = 8'h05; wr_i <= 1; #20
        wr_i <= 0; #20
        w_data <= 8'h06; wr_i <= 1; #20
        wr_i <= 0; #20
        w_data <= 8'h07; wr_i <= 1; #20
        wr_i <= 0; #30
        w_data <= 8'h0f; wr_i <= 1; #20
        wr_i <= 0; #20
        w_data <= 8'haa;wr_i <= 1; #20
        wr_i <= 0; #10
        start <= 1; #20
        start <= 0; #1500
        w_data <= 8'hab;wr_i <= 1; #20
        wr_i <= 0; #6000
        start <= 1; #20
        start <= 0;
    end
    always #10 clk <= ~clk;
endmodule