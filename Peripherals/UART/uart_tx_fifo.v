module uart_tx_fifo #(
    parameter P = 0,
              W = 4,
              s = 1,
			  TIMER = 434
) (
    input clk, reset, wr, start,
    input [7+P:0] w_data,
    output wire full, empty, tdo
);
    // signal declaration
    wire rd;
    wire [7+P:0] r_data;

    // wire tx;
    wire tx_tick;
    // submodule instance
    uart_transmitter #(.P(P), .s(s), .TIMER(TIMER)) uart_tx (
        clk, reset, (tx_tick || start) && ~empty, r_data, tx_tick, tdo
    );
    fifo #(.B(8+P), .W(W)) uart_fifo_transmitter (
        clk, reset, rd, wr, w_data, empty, full, r_data
    );
    single_cycle_tick tx_tick_rd (
        clk, reset, tx_tick, rd
    );
    // single_cycle_tick_reverse rd_tx (
    //     clk, reset, (tx_tick || start) && ~empty, tx
    // );
endmodule