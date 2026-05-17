module MEM_WB (
	input logic clk, reset,
	input logic[63:0] readMemData, ALURes,
	input logic MemtoReg, RegWrite,
	
	output logic[63:0] ALUResOut, readMemDataOut,
	output logic MemtoRegOut, RegWriteOut
);

	//Pass 64 bit Memory read data
	
	nbit_register #(.BITS(64)) passMemoryRead (.clk(clk), .reset(reset), .write(readMemData), .q(readMemDataOut));
	
	//Pass 64 bit ALU Result
	
	nbit_register #(.BITS(64)) passMemoryRead (.clk(clk), .reset(reset), .write(ALURes), .q(ALUResOut));
	
	//Pass WB control signals MemtoReg, RegWrite
	
	D_FF passMemtoReg (.q(MemtoRegOut), .d(MemtoReg), .reset(reset), .clk(clk));
	
	D_FF passRegWrite (.q(RegWriteOut), .d(RegWrite), .reset(reset), .clk(clk));
	
endmodule
