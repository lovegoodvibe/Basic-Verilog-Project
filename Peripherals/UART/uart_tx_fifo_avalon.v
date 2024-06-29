module uart_tx_fifo_avalon #(
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
    output wire tdo
);
    // Signal declaration
    reg [31:0] data, status, control;
    wire [7+P:0] w_data;
    wire start, wr, full, empty;
    // Submodule instance
    uart_tx_fifo #(.P(P), .W(W), .s(s), .TIMER(TIMER)) uart_tx_fifo (
        .clk(clk), .reset(~reset_n), .wr(wr), .start(start), .w_data(w_data), .full(full), .empty(empty), .tdo(tdo)
    );
    single_cycle_tick start_cofigure (
        clk, ~reset_n, control[1], start
    );
    single_cycle_tick wr_configure (
        clk, ~reset_n, control[0], wr
    );
    assign w_data = data[7+P:0];
    always @(posedge clk or negedge reset_n) begin
        if(!reset_n)
            status[31:0] <= {32{1'b0}};
        else begin
            status[0] <= full;
            status[1] <= empty;
            status[31:2] <= {30{1'b0}};
        end
    end
    // Avalon write/read
    always @ ( posedge clk or negedge reset_n )
	begin
		if ( reset_n == 1'b0 )
		begin
			data <= 32'b0;
			//status <= 32'b0;
			control <= 32'b0;
			readdata <= 32'b0;
		end
		else if ( chipselect && write )
		begin
			case ( address )
				0 			: data <= writedata;
				// 1 			: status <= writedata;
				2 			: control <= writedata;
                default: data <= writedata;
			endcase
		end
		else if ( chipselect && read )
		begin
			case ( address )
				0 : readdata <= data;
				1 : readdata <= status;
				2 : readdata <= control;
                default: readdata <= data;
			endcase
		end
		else
		begin
			data <= data;
			// status <= status;
			control[31:2] <= control [31:2];
			control [1] <= start;
			control [0] <= wr;
			readdata <= 32'b0;
		end
	end
endmodule