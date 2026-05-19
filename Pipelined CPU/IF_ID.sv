module IF_ID (
	input logic clk, reset,
	input logic[31:0] instruction,
	input logic[63:0] currPC,
	input logic[63:0] PCp4,
	input logic isDType;
	
	output logic[31:0] instructionOut,
	output logic[63:0] currPCOut, Pcp4Out,
	output logic isDTypeOut
);

	//Pass the 32 bit instructions
	
	nbit_register #(.BITS(32)) instructionhold (.clk(clk) .reset(reset), .write(instruction), .q(instructionOut));
	
	//Pass the current 64 bit PC
	
	nbit_register #(.BITS(64)) PChold (.clk(clk), .reset(reset), .write(currPC), .q(currPCOut));
	
	//Pass the PC + 4 for BR and BL
	
	nbit_register #(.BITS(64)) Pcp4hold (.clk(clk), .reset(reset), .write(PCp4), .q(PCp4Out));
	
	//Pass the isDtype signal
	
	D_FF isDtypehold (.q(isDTypeOut), .d(isDType), .reset(reset), .clk(clk));

endmodule
