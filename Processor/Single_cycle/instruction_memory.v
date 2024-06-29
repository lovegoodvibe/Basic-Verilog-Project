module instruction_memory (
    input clk,
    input [4:0] address_read,
    output reg [7:0] instruction
);
    reg [7:0] instruction_file [31:0];
    always @(posedge clk) begin
        instruction <= instruction_file [address_read];
    end
    initial begin
        instruction_file [0] = 8'h0e; // load a mem[14] = 14
        instruction_file [1] = 8'h2f; // l0ad b mem[15] = 15
        instruction_file [2] = 8'h80; // add
        instruction_file [3] = 8'h40; // store mem[14] 
        instruction_file [4] = 8'b00; // load a mem[0]
    end
endmodule