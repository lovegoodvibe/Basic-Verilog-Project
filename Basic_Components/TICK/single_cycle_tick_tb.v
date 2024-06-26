`timescale 1ps/1ps
module single_cycle_tick_tb;
    reg clk, reset, in;
    single_cycle_tick uut ( clk, reset, in);
    initial begin
        clk <= 1; reset <= 0; in <= 0; #20
        reset <= 1; #20
        reset <= 0; #20
        in <= 1; #60
        in <= 0; #20 
        in <= 1; #20
        in <= 0; #30
        in <= 1; #60
        in <= 0;
    end
    always #10 clk = ~clk;
endmodule