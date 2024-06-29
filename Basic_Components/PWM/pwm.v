module pwm #(
    parameter PULSE_WIDTH = 100,
              ACTIVE_WIDTH = 50,
              B = 8
) (
    input clk, reset, start,
    output wire pwm
);
    localparam IDLE = 2'b00,
               ACTIVE = 2'b01,
               INACTIVE = 2'b11;
    // Signal declaration
    reg [1:0] state, state_next;
    reg active_inc, inactive_inc;
    wire active_tick, inactive_tick;
    // Data path
    counter_continuous #(.THRESHOLD_VALUE(ACTIVE_WIDTH-1), .COUNTER_BIT_NUMBER(B)) active_duty (
        clk, reset, active_inc, active_tick
    ); 
    counter_continuous #(.THRESHOLD_VALUE(PULSE_WIDTH - ACTIVE_WIDTH - 1), .COUNTER_BIT_NUMBER(B)) inactive_duty (
        clk, reset, inactive_inc, inactive_tick
    );
    // Output
    assign pwm = (active_inc || active_tick) ? 1'b1 : 1'b0;     
    // Control path
    always @(posedge clk, posedge reset) begin
        if(reset)
            state <= IDLE;
        else 
            state <= state_next;
    end
    always @(*) begin
        active_inc = 0;
        inactive_inc = 0;
        case (state)
            IDLE: begin
                if(start)
                    state_next = ACTIVE;
                else
                    state_next = IDLE;
            end 
            ACTIVE: begin
                state_next = ACTIVE;
                if(active_tick)
                    state_next = INACTIVE;
                else 
                    active_inc = 1;
            end
            INACTIVE: begin 
                state_next = INACTIVE;
                if (inactive_tick)
                    state_next = ACTIVE;
                else
                    inactive_inc = 1; 
            end
            default: state_next = IDLE;
        endcase
    end
endmodule