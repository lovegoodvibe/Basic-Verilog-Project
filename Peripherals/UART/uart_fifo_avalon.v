module uart_fifo_avalon #(
    parameter P = 0,
              W = 4,
              s = 1,
			  TIMER = 434
) (
    // Avalon interface
	input [1:0] address,
	input chipselect,
	input clk,
	input read,
	input reset_n,
	input write,
	input [31:0] writedata,
    output reg [31:0] readdata,
    // output
	input tdi,
    output wire tdo
);
// Signal declaration
    reg [31:0] data_tx, data_rx, status, control;
    wire [7+P:0] w_data, r_data;
    wire start, wr, rd, full_fifo_tx, empty_fifo_tx, full_fifo_rx, empty_fifo_rx;
// Submodule instance tx_fifo
    uart_tx_fifo #(.P(P), .W(W), .s(s), .TIMER(TIMER)) uart_tx_fifo (
        .clk(clk), .reset(~reset_n), .wr(wr), .start(start), .w_data(w_data), .full(full_fifo_tx), .empty(empty_fifo_tx), .tdo(tdo)
    );
    single_cycle_tick start_cofigure (
        clk, ~reset_n, control[1], start
    );
    single_cycle_tick wr_configure (
        clk, ~reset_n, control[0], wr
    );
    assign w_data = data_tx[7+P:0];
// Submodule instance rx_fifo
    uart_rx_fifo #(.P(P), .W(W), .s(s), .TIMER(TIMER)) uart_rx_fifo (
        .clk(clk), .reset(~reset_n), .tdi(tdi), .rd(rd), .r_data(r_data), .empty(empty_fifo_rx), .full(full_fifo_rx) 
    );
    single_cycle_tick rd_cofigure (
        clk, ~reset_n, control[2], rd
    );
// Avalon write/read
    always @(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            status [31:4] <= 21'b0;
            data_rx [31:8+P] <= 21'b0;
            status[3:0] <= 4'b0;
            data_rx <= {(7+P){1'b0}};
		end
        else begin
            status [31:4] <= 21'b0;
            data_rx [31:8+P] <= 21'b0; 
			status[3:0] <= {empty_fifo_rx, full_fifo_rx, empty_fifo_tx, full_fifo_tx};
            data_rx [7+P:0] <= r_data;
        end
    end
    always @ ( posedge clk or negedge reset_n )
	begin
		if ( reset_n == 1'b0 )
		begin
			data_tx <= 32'b0;
			control <= 32'b0;
			readdata <= 32'b0;
		end
		else if ( chipselect && write )
		begin
			case ( address )
				0 : data_tx <= writedata;
				3 : control <= writedata;
			endcase
		end
		else if ( chipselect && read )
		begin
			case ( address )
				0 : readdata <= data_tx;
                1 : readdata <= data_rx;
				2 : readdata <= status;
				3 : readdata <= control;
			endcase
		end
		else
		begin
			data_tx <= data_tx;
			control <= {control[31:3], rd, start, wr};
			readdata <= 32'b0;
		end
	end
endmodule