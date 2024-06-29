module uart_rx_fifo #(
    parameter P = 0,
              W = 4,
              s = 1,
              TIMER = 434
) (
    input clk, reset, tdi, rd,
    output [7+P:0] r_data,
    output wire empty, full
);
    // Signal declaration
    wire wr;
    wire [7+P:0] w_data;
    wire rx_tick;
    // submodule instance
    uart_receiver #(.P(P), .s(s), .TIMER(TIMER)) uart_rx (
        clk, reset, tdi, rx_tick, w_data
    );
    fifo #(.B(8+P), .W(W)) uart_fifo_receiver (
        clk, reset, rd, wr, w_data, empty, full, r_data
    );
    single_cycle_tick rd_configure (
        clk, reset, rx_tick, wr
    );
endmodule