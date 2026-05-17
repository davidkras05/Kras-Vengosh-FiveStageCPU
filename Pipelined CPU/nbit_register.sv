`timescale 1ps/1ps

module nbit_register #(parameter BITS = 64) (
	input logic clk, reset,
	input logic[BITS-1:0] write,
	
	output logic[BITS-1:0] q
);

	genvar i;
	
	generate
		for (i = 0; i < BITS; i++) begin: nregloop
			
			D_FF flipflop (.q(q[i]), .d(write[i]), .reset(reset), .clk(clk));
		
		end
	endgenerate
endmodule
