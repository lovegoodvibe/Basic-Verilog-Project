module single_cycle_tick_reverse (
    input clk, reset, in,
    output tick
);
    localparam ZERO = 2'b00,
               ONE_ACTIVE = 2'b01,
               ONE_UNACTIVE = 2'b10;
    reg [1:0] state, state_next;
    always @(negedge clk, posedge reset) begin   
        if(reset)
            state <= ZERO;
        else      
            state <= state_next;
    end
    always @(*) begin
        case (state)
            ZERO: begin
                if(in)
                    state_next <= ONE_UNACTIVE;
                else
                    state_next <= ZERO;
            end
            ONE_UNACTIVE: begin
                if(!in)
                    state_next <= ONE_ACTIVE;
                else 
                    state_next <= ONE_UNACTIVE;
            end
            ONE_ACTIVE: begin
                state_next <= ZERO;
            end
            default: 
                state_next <= ZERO;
        endcase
    end
    assign tick = (state == ONE_ACTIVE) ? 1'b1 : 1'b0;
endmodule
