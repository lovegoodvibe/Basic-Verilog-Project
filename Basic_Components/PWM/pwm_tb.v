`timescale 1ps/1ps
module pwm_tb;
    reg clk, reset, start;
    pwm #(.PULSE_WIDTH(6), .ACTIVE_WIDTH(3), .B(3)) uut (
        clk, reset, start
    );
    initial begin
        clk <= 0; reset = 0; start <= 0; #20
        reset <= 1; #20
        reset <= 0; #20
        start <= 1; #20
        start <= 0; #1000
        reset <= 1;
    end
    always #10 clk = ~clk; 
endmodule