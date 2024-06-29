module data_memory (
    input clk, wr, rd,
    input [4:0] address,
    input [7:0] data_write,
    output reg [7:0] data_read
);
    reg [7:0] data_file [31:0];
    always @(*) begin
        if (rd)
            data_read <= data_file [address];
    end
    always @(posedge clk) begin
        if (wr)
            data_file [address] <= data_write;
    end

    initial begin
        data_file [14] <= 14;
        data_file [15] <= 15;
    end
endmodule