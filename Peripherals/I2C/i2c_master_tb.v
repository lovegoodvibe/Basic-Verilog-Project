module i2c_master_tb;
    reg clk, reset, start, stop, wr_rd_en_i, fifo_wr_addr, fifo_wr_data;
    reg [6:0] w_addr;
    reg [7:0] w_data;
    reg sda_ack;
    wire sda_next, scl_next, scl, sda;
    i2c_master_for_simulation #() uut (
        .clk(clk), .reset(reset), .start(start), .stop(stop), .wr_rd_en_i(wr_rd_en_i),
        .fifo_wr_addr(fifo_wr_addr), .fifo_wr_data(fifo_wr_data), 
        .w_addr(w_addr), .w_data(w_data), .sda(sda), .scl(scl),
        .sda_next(sda_next), .scl_next(scl_next)
    );
    assign sda = sda_ack ? 1'b0 : sda_next;
    assign scl = scl_next;
    initial begin
        clk <= 0; reset <= 0; start <= 0; stop <= 0; wr_rd_en_i <= 1; 
        fifo_wr_addr <= 0; fifo_wr_data <= 0;
        w_addr <= 7'h15; w_data <= 8'h36;  #20
        reset <= 1; #20
        fifo_wr_addr <= 1; fifo_wr_data <= 1;
        reset <= 0; #20
        fifo_wr_addr <= 0; fifo_wr_data <= 0;
        start <= 1; #20
        start <= 0;
    end
    initial begin
        sda_ack <= 0; #1690
        sda_ack <= 1; #201
        sda_ack <= 0; #1599   //3510-1710-200
        sda_ack <= 1; #201
        sda_ack <= 0;
    end
    initial begin
        stop <= 0; #3490
        stop <= 1; #201
        stop <= 0;
    end
    always #10 clk <= ~clk;
endmodule