`timescale 1ns / 1ns  
 module tb_divider;  
      reg clock, reset, start;  
      reg [31:0] A, B,, D, R;    
      wire ok, err;  
      // Instantiate the Unit Under Test (UUT)  
      Divide uut (.clk(clock), .start(start), .reset(reset), .A(A), .B(B), .D(D), .R(R), .ok(ok), .err(err)); 
      initial begin   
            clock = 0;  
            forever #50 clock = ~clock;  
      end  
      initial begin  
           // Initialize Inputs  
           start = 0;  
           A = 32'd1023;  
           B = 32'd50;  
           reset=1;  
           // Wait 100 ns for global reset to finish  
           #1000;  
           reset=0;  
     start = 1;   
           #5000;  
           $finish;  
      end  
 endmodule  