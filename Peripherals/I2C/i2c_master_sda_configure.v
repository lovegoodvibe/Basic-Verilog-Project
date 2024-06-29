module i2c_master_sda_configure #(
    parameter ADDR_BIT = 7
) (
    input reset, start, scl, wr_rd_en_i, fifo_wr_addr, fifo_wr_data,
    input [ADDR_BIT-1:0] w_addr,
    input [7:0] w_data,
    output [7:0] r_data,
    input [2:0] state, 
    output reg sda
);
    localparam ADDR = 3'b000,
               ACK_ADDR = 3'b001,
               WR_RD = 3'b010,
               ACK_WR_RD = 3'b011,
               STOP = 3'b100;
// Signal declaration
    reg [ADDR_BIT:0] shift_reg_addr; 
    reg [7:0] shift_reg_data;
    wire sda_next;
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
    // Control
    assign sda_next = (start) ? 1'b0 :
                      (state == ADDR) ? shift_reg_addr [ADDR_BIT] :
                      (state == WR_RD) ? shift_reg_data[7] : 1'b1;
    always @(negedge scl, posedge reset, posedge start) begin
        sda <= sda_next;
    end
endmodule