module alu (
    input [1:0] alu_op,
	input [7:0] A,
    input [7:0] B,
    output reg [7:0] result
);
    parameter  ADD = 2'b00,
               SUB = 2'b01,
               AND = 2'b10,
               OR = 2'b11;
    // excute
    always @ (*) begin
        case (alu_op)
            ADD: result = A + B;
            SUB: result = A - B;
            AND: result = A & B;
            OR: result = A | B; 
        endcase
    end
endmodule