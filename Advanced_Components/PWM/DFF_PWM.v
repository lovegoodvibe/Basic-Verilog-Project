// Debouncing DFFs for push buttons on FPGA
module DFF_PWM (
    input clk,en,D,
    output reg Q
);
    always @(posedge clk)
    begin 
        if(en==1) // slow clock enable signal 
            Q <= D;
    end 
endmodule 