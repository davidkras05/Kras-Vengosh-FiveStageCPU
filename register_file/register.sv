module register (
	input logic clk,
	input logic[63:0] write,
	input logic reset,
	
	output logic[63:0] q
	
);
	
	/*This is the 64 bit register for wiring to the five_thirtytwodecoder. This creates one
		instance of a 64 bit register. the full 32 can be instantiated in the top module*/
	
	genvar i;
	
	generate
		for(i=0; i<64; i++) begin: sub_FF
	
			D_FF flipflop (.q(q[i]), .d(write[i]), .reset(reset), .clk(clk));
		
		end
	endgenerate
endmodule
