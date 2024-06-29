module uart_tx_fsm_tb;
    reg clk, reset, tx;
    reg [7:0] data_tx;
    uart_transmitter #(.TIMER(10), .P(0)) uut (.clk(clk), .reset(reset), .tx(tx), .data_tx(data_tx));
    initial begin
        clk <= 0;
        reset <= 0;
        tx <= 0;
        data_tx <= 8'h55; #10
        reset <= 1; #10
        reset <= 0; 
        tx <= 1; #20;
		tx <= 0;
    end
    always #10 clk = ~clk;
    
endmodule