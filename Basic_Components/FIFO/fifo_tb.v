`timescale 1ps/1ps
module fifo_tb;
    reg clk, reset, rd, wr;
    reg [2:0] w_data;
    fifo #(.B(3), .W(1)) uut (.clk(clk), .reset(reset), .rd(rd), .wr(wr), .w_data(w_data));
    initial begin
        clk <= 0;
        rd <= 0;
        wr <= 0;
        reset <= 0; #10
        reset <= 1; #10
        reset <= 0;
        rd <= 1; #20
        rd <= 0; #20
        w_data = 3'b101;
        wr <= 1; #20
        wr <= 0; #20
        w_data <= 3'b110;
        wr <= 1; #20
        wr <= 0; #20
        w_data <= 3'b111;
        wr <= 1; #20
        wr <= 0; #30
        w_data <= 3'b000;
        wr <= 1; #20
        wr <= 0; #20
        w_data <= 3'b001;
        wr <= 1; #20
        wr <= 0; #20
        rd <= 1;
    end
    always #10 clk <= ~clk;
    
endmodule