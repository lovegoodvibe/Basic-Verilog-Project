module uart_transmitter #(
    parameter P = 0, // number bit of parity + data
              s = 1, // number of stop bit
              TIMER = 434
) (
    input clk, reset, tx,
    input [7+P:0] data_tx,
    output reg tx_tick, tdo
);
    localparam IDLE = 1'b0,
               TX = 1'b1;
    // Signal declaration
    reg [8+P:0] shift_reg;
    reg state;
    reg state_next = 1'b0, time_inc, bit_inc, reset_bit_counter;
	wire time_tick, bit_tick;
    wire tdo_next;
    // Data path
    // Shift register
    always @(posedge clk) begin
        if(state)
            if (time_tick)
                shift_reg <= {1'b1, shift_reg[8+P:1]};
            else
                shift_reg <= shift_reg;
        else 
            shift_reg <= {data_tx[7+P:0], 1'b0}; // data + start_bit
    end
    // Output
    always @(posedge clk) begin
        tdo <= tdo_next;
    end
    assign tdo_next = state ? shift_reg [0] : 1'b1;
    // Control path 
    counter #(.THRESHOLD_VALUE(8+P+s), .COUNTER_BIT_NUMBER (4)) bit_counter (
        .clk(clk), .reset(reset || reset_bit_counter), .ctrl_inc(bit_inc), .tick(bit_tick));
    counter_continuous #(.THRESHOLD_VALUE(TIMER), .COUNTER_BIT_NUMBER(9)) time_counter (
        .clk(clk), .reset(reset), .ctrl_inc(time_inc), .tick(time_tick));
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= IDLE;
            tx_tick <= 0;
        end
        else begin
            state <= state_next;
            tx_tick <= bit_tick;
        end
    end         

    always @(*) begin
        time_inc = 0;
        bit_inc = 0;
        reset_bit_counter = 0;
        case (state)
            IDLE: begin
                state_next = IDLE;
                reset_bit_counter = 1;
                if (tx)
                    state_next = TX; 
            end 
            TX: begin
                state_next = TX;
                if (time_tick) begin
                    if (bit_tick) begin
                        state_next = IDLE;
                    end
                    else
                        bit_inc = 1;
                end
                else
                    time_inc = 1;
            end    			
        endcase
    end
endmodule