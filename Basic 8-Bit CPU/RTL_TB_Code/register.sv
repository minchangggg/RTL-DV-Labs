module register (
	input	wire clk,
	input   wire enable,
	input   wire rst_,
	input 	wire [7:0] data,
	output	reg  [7:0] out
);

timeunit 1ns;
timeprecision 100ps;

always_ff @(posedge clk, negedge rst_)
	if (!rst_)
		out <= '0;
	else if (enable)
		out <= data;
	else
		out <= out;
endmodule
