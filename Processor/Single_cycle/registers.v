module registers (
    input clk, wr_A, wr_B, rd_mem,
    input [7:0] data_write, result,
    output reg [7:0] A, B 
); 
    always @(posedge clk) begin
        if (wr_A) begin
            if (rd_mem)
                A <= data_write;
            else
                A <= result;
        end
        if (wr_B)
            B <= data_write;
    end
endmodule