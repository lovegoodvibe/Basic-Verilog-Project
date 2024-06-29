module i2c_master_scl_configure #(
    parameter ADDR_BIT = 7,
              W = 10, 
              INACTIVE_W = 5,
              COUNTER_BIT = 3
) (
    input clk, reset, start, stop, sda,
    output [2:0] scl_state,
    output scl
);
    localparam ADDR = 3'b000,
               ACK_ADDR = 3'b001,
               WR_RD = 3'b010,
               ACK_WR_RD = 3'b011,
               STOP = 3'b100;
// Signal declaration
    wire scl_reverse; 
    reg [2:0] state, state_next;
    reg start_scl, stop_scl;
    wire counter_addr_bit_tick, counter_data_bit_tick;
// Create SCL from PWM of clk
    pwm #(.PULSE_WIDTH(W), .ACTIVE_WIDTH(INACTIVE_W), .B(COUNTER_BIT)) scl_clk (
        clk, (reset || stop_scl), start_scl, scl_reverse
    ); 
    assign scl = ~scl_reverse;
// SCL control signal
    always @(posedge clk) begin
        start_scl <= start;
    end
    always @(posedge scl, posedge reset) begin
        if (reset)
            stop_scl <= 0;
        else if (state == STOP)
            stop_scl <= 1;
        else 
            stop_scl <= 0;
    end
// SDA control path
// Output
    assign scl_state = state;
// State logic continuous
    always @(negedge scl, posedge reset, posedge start) begin
        if (reset) begin
            state <= STOP;
        end
        else if (start) begin
            state <= ADDR;
        end
        else begin 
            state <= state_next;
        end 
    end
// State logic combination
    counter_continuous #(.THRESHOLD_VALUE(ADDR_BIT + 1), .COUNTER_BIT_NUMBER(4)) counter_addr_bit (
        scl, reset, (state == ADDR), counter_addr_bit_tick 
    );
    counter_continuous #(.THRESHOLD_VALUE(8), .COUNTER_BIT_NUMBER(4)) counter_data_bit ( 
        scl, reset, (state == WR_RD), counter_data_bit_tick  
    );
    always @(*) begin
        case (state)
            ADDR: begin
                state_next = ADDR;
                if (counter_addr_bit_tick)
                    state_next = ACK_ADDR; 
            end
            ACK_ADDR: begin
                if (!sda)
                    state_next = WR_RD;
                else    
                    state_next = STOP;
            end
            WR_RD: begin
                state_next = WR_RD;
                if (counter_data_bit_tick)
                    state_next = ACK_WR_RD;
            end
            ACK_WR_RD: begin
                if (!sda) begin
                    state_next = WR_RD;
                    if (stop)
                        state_next = STOP;
                end  
                else
                    state_next = STOP;   
            end
            default: state_next = STOP; 
        endcase
    end
endmodule