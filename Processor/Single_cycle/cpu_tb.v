`timescale 1ps/1ps
module cpu_tb;
    // symbolic state declaration
    // signal declaration
    reg clk;
    wire [4:0] pc;
    wire [7:0] instruction;
	wire [4:0] address;
    wire rd_mem, wr_mem;
	wire [7:0] data_read_mem;
    wire [7:0] data_write_mem;
    // body
    // state register
    // FSM data path (counter) next-state logic
    instruction_memory instruction_file (.clk(clk), .address_read(pc), 
                                         .instruction(instruction));
    data_memory data_file (.clk(clk), .wr(wr_mem), .rd(rd_mem), .address(address), 
                           .data_read(data_read_mem), .data_write(data_write_mem));
    core uut (.clk(clk), .instruction(instruction), .pc(pc), 
               .data_read_mem(data_read_mem), .wr_mem(wr_mem), .rd_mem(rd_mem),
               .address(address), .data_write_mem(data_write_mem));  
    initial begin
        clk <= 0;
        // for (i = 0; i < 100 ; i = i + 1) begin
        //     #10 clk <= ~clk;
        // end
    end
    always #10 clk <= ~clk;
endmodule