module count (
	input	logic	[4:0]	data,
	input	logic		load,
	input 	logic		clk,
	input 	logic		enable,
	input 	logic		rst_,
	output	logic	[4:0]	count
);

timeunit 1ns;
timeprecision 100ps;

always_ff @(posedge clk, negedge rst_)
	if (!rst_)
		count <= '0;
	else if (load)
		count <= data;
	else if (enable)
		count <= count+1;

endmodule
