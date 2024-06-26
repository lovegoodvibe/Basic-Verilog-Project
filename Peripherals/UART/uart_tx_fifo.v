module uart_tx_fifo #(
    parameter B = 8,
              W = 4,
              s = 1,
			  TIMER = 434
) (
    input clk, reset, wr, start,
    input [B-1:0] w_data,
    output wire full, empty, tdo
);
    // signal declaration
    wire rd;
    wire [B-1:0] r_data;

    // wire tx;
    wire tx_tick;
    // submodule instance
    uart_transmitter #(.b(B), .s(s), .TIMER(TIMER)) uart_tx (
        clk, reset, (tx_tick || start) && ~empty, r_data, tx_tick, tdo
    );
    fifo #(.B(B), .W(W)) uart_fifo_transmitter (
        clk, reset, rd, wr, w_data, empty, full, r_data
    );
    single_cycle_tick tx_tick_rd (
        clk, reset, tx_tick, rd
    );
    // single_cycle_tick_reverse rd_tx (
    //     clk, reset, (tx_tick || start) && ~empty, tx
    // );
endmodule