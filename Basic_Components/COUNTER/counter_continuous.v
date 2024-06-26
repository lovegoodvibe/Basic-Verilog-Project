module counter_continuous #(
    parameter THRESHOLD_VALUE = 100,
              COUNTER_BIT_NUMBER = 8
) (
    input clk, reset, ctrl_inc,
    output tick
);
    reg [COUNTER_BIT_NUMBER-1:0] couter_reg;
	 wire [COUNTER_BIT_NUMBER-1:0] counter_reg_next;
    always @(posedge clk, posedge reset) begin
        if (reset)
            couter_reg <= {COUNTER_BIT_NUMBER{1'b0}};
        else
            couter_reg <= counter_reg_next;
    end
    assign counter_reg_next = ctrl_inc ? couter_reg + {{(COUNTER_BIT_NUMBER-1){1'b0}}, {1'b1}} : {COUNTER_BIT_NUMBER{1'b0}}; 
    assign tick = (couter_reg == THRESHOLD_VALUE) ? 1'b1 : 1'b0;
endmodule