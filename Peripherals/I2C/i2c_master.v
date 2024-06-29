module i2c_master #(
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
    output wire scl_next, 
    output reg sda_next
);
    localparam ADDR = 3'b000,
               ACK_ADDR = 3'b001,
               WR_RD = 3'b010,
               ACK_WR_RD = 3'b011,
               STOP = 3'b100;
// Signal declaration
    reg [ADDR_BIT:0] shift_reg_addr; 
    reg [7:0] shift_reg_data;
    wire [2:0] state;
    assign wr_rd_tick = (state == ACK_WR_RD);
// SCL instance
    i2c_master_scl_configure #(.ADDR_BIT(ADDR_BIT), 
                               .W(W), 
                               .INACTIVE_W(INACTIVE_W), 
                               .COUNTER_BIT(COUNTER_BIT)) 
    scl_configure (
        clk, reset, start, stop, sda, state, scl_next
    );
    assign scl = (!scl_next) ? 1'b0 : 1'bz;
// Data path SDA
    // shift address register
    always @(posedge scl ,posedge fifo_wr_addr) begin
        if(fifo_wr_addr)
            shift_reg_addr <= {{1'b1},w_addr,wr_rd_en_i};
        else if(state == ADDR)
            shift_reg_addr <= {shift_reg_addr[ADDR_BIT:0], 1'b1};
    end
    // Shift data register 
    always @(posedge scl ,posedge fifo_wr_addr) begin
        if (fifo_wr_data)
            shift_reg_data <= w_data;
        else if(state == WR_RD)
            if(wr_rd_en_i)
                shift_reg_data <= {shift_reg_data[6:0], 1'b1};
            else 
                shift_reg_data <= {shift_reg_data[6:0], sda};
    end
    assign r_data = shift_reg_data; 
    // SDA
    assign sda = (!sda_next) ? 1'b0 : 1'bz; 
    // Control
// State logic continuous
    always @(negedge scl, posedge reset, posedge start) begin
        if (reset) 
            sda_next <= 1'b1;
        else if (start) 
            sda_next <= 1'b0;
        else 
            if(state == ADDR) 
                sda_next <= shift_reg_addr [ADDR_BIT];
            else if (state == WR_RD)
                sda_next <= shift_reg_data[7];
            else
                sda_next <= 1'b1;
    end
endmodule