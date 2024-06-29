module i2c_master_for_simulation #(
    parameter ADDR_BIT = 7,
              W = 10, 
              INACTIVE_W = 5,
              COUNTER_BIT = 3
) (
    input clk, reset, start, stop, wr_rd_en_i, fifo_wr_addr, fifo_wr_data,
    input [ADDR_BIT-1:0] w_addr,
    input [7:0] w_data,
    output [7:0] r_data,
    output wr_rd_tick,
    inout sda, scl,
    output scl_next, sda_next
);
// Signal declaration
    reg ctrl_sda; 
    wire [2:0] state;
    assign wr_rd_tick = (state == ACK_WR_RD);
// instance
    i2c_master_scl_configure #(.ADDR_BIT(ADDR_BIT), 
                               .W(W), 
                               .INACTIVE_W(INACTIVE_W), 
                               .COUNTER_BIT(COUNTER_BIT)) 
    scl_configure (
        clk, reset, start, stop, sda, state, scl_next
    );
    i2c_master_sda_configure #(.ADDR_BIT(ADDR_BIT)) sda_configure (
        reset, start, ctrl_sda, wr_rd_en_i, fifo_wr_addr, fifo_wr_data, 
        w_addr, w_data, r_data, state, sda_next
    );
    always @(posedge clk) begin
        ctrl_sda <= scl;
    end
    assign scl = (!scl_next) ? 1'b0 : 1'bz;
    assign sda = (!sda_next) ? 1'b0 : 1'bz; 
endmodule