module uart_receiver #(
    parameter P = 0,
              s = 1,
              TIMER = 434
) (
    input clk, reset, tdi,
    output reg rx_tick,
    output [7+P:0] data_rx
);
    localparam IDLE = 2'b00,
               START = 2'b01,
               RX = 2'b10,
               STOP = 2'B11;
    // Signal declaration
    reg [7+P:0] shift_reg;
    reg [1:0] state, state_next;
    reg bit_inc, stop_inc, time_inc, start_inc;
    wire bit_tick, stop_tick, time_tick, start_tick; 
    reg reset_bit_counter, reset_stop_counter;
    // Data path
    // Shift register
    always @(posedge clk) begin
        if (state)
            if(time_tick)
                shift_reg <= {tdi, shift_reg[7+P:1]};
            else
                shift_reg <= shift_reg;
        else    
            shift_reg <= {(8+P){1'b0}}; 
    end
    // Output
    assign data_rx = shift_reg; 
    // Control path
    counter_continuous #(.THRESHOLD_VALUE((TIMER-1)/2-1), .COUNTER_BIT_NUMBER(9)) start_counter (
        .clk(clk), .reset(reset), .ctrl_inc(start_inc), .tick(start_tick)
    );
    counter_continuous #(.THRESHOLD_VALUE(TIMER), .COUNTER_BIT_NUMBER(9)) time_counter (
        .clk(clk), .reset(reset), .ctrl_inc(time_inc), .tick(time_tick)
    );
    counter #(.THRESHOLD_VALUE(7+P), .COUNTER_BIT_NUMBER(4)) bit_counter (
        .clk(clk), .reset(reset || reset_bit_counter), .ctrl_inc(bit_inc), .tick(bit_tick)
    );
    counter #(.THRESHOLD_VALUE(s-1), .COUNTER_BIT_NUMBER(4)) stop_counter (
        .clk(clk), .reset(reset || reset_stop_counter), .ctrl_inc(stop_inc), .tick(stop_tick)
    );
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= IDLE;
            rx_tick <= 0;
        end
        else begin
            state <= state_next;
            rx_tick <= (state_next == STOP);
        end
    end
    always @(*) begin
        start_inc = 0;
        time_inc = 0;
        bit_inc = 0;
        stop_inc = 0;
        reset_bit_counter = 0;
        reset_stop_counter = 0;
        case (state)
            IDLE: begin
                state_next = IDLE;
                reset_stop_counter = 1;
                if(!tdi)
                    state_next = START;
            end
            START: begin
                state_next = START;
                if (start_tick)
                    if(!tdi)
                        state_next = RX;
                    else
                        state_next = IDLE;
                else
                    start_inc = 1;
            end 
            RX: begin
                state_next = RX;
                if (time_tick)
                    if (bit_tick)
                        state_next = STOP;
                    else    
                        bit_inc = 1;
                else    
                    time_inc = 1;
            end
            STOP: begin
                state_next = STOP;
                reset_bit_counter = 1;
                if (time_tick)
                    if(stop_tick)
                        state_next = IDLE;
                    else 
                        stop_inc = 1;
                else    
                    time_inc = 1; 
            end
        endcase
    end
endmodule