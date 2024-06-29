module pwm (
    input clk, increase_duty, decrease_duty,
    output wire PWM_OUT 
);
    reg [3:0] counter_PWM = 0, 
              DUTY_CYCLE = 5, 
              duty_cycle_next = 5;
    // configure duty_cycle
    // maybe use debounce circuit to debounce the increase_duty and decrease_duty
    always @(posedge increase_duty, posedge decrease_duty) begin
        if (increase_duty)
            duty_cycle_next <= DUTY_CYCLE + 1;
        else if (decrease_duty)
            duty_cycle_next <= DUTY_CYCLE - 1; 
    end
    always @(posedge clk) begin
        DUTY_CYCLE <= duty_cycle_next;
    end
    // pwm = 10 * clk
    always @(posedge clk) begin
        counter_PWM <= counter_PWM + 1;
        if (counter_PWM >= 9)
            counter_PWM <= 0;
    end
    assign PWM_OUT = (counter_PWM < DUTY_CYCLE) ? 1 : 0; 
endmodule