import typedefs::*;
module alu (
	input	logic		clk,
	input	logic	[7:0]	accum,
	input	logic	[7:0]	data,
	input	opcode_t	opcode,
	output	logic		zero,
	output	logic	[7:0]	out
);

timeunit 1ns;
timeprecision 100ps;

always @(negedge clk)
	unique case (opcode)
		ADD : out <= accum + data;
		AND : out <= accum & data;
		XOR : out <= accum ^ data;
		LDA : out <= data;
		HLT,
		SKZ,
		JMP,
		STO : out <= accum;
		default : out <= 8'b1;
	endcase

always_comb
	zero = ~(|accum);

endmodule
