module EX_MEM (
	input logic clk, reset,
	input logic[63:0] ALURes, ReadData2, Branch,
	input logic[4:0] Rd,
	input logic MemtoReg, RegWrite, MemRead, MemWrite, BrTaken, zeroFlag,
	
	output logic[63:0] address, writeMemData, BranchOut,
	output logic[4:0] RdOut,
	output logic zeroFlagOut, MemtoRegOut, RegWriteOut, MemReadOut, MemWriteOut, BrTakenOut
);

	//Pass 64 bit ALU Result
	
	nbit_register #(.BITS(64)) passALU (.clk(clk), .reset(reset), .write(ALURes), .q(address));
	
	//Pass 64 bit ReadData2
	
	nbit_register #(.BITS(64)) passReadData2 (.clk(clk), .reset(reset), .write(ReadData2), .q(writeMemData));

	//Pass 64 bit Branch (to add when branching)
	
	nbit_register #(.BITS(64)) passBranch (.clk(clk), .reset(reset), .write(Branch), .q(BranchOut));
	
	//Pass ZeroFlag
	
	D_FF passzero (.q(zeroFlagOut), .d(zeroFlag), .reset(reset), .clk(clk));
	
	//Pass Rd (instruction[4:0])
	
	nbit_register #(.BITS(5)) passRd (.clk(clk), .reset(reset), .write(Rd), .q(RdOut));
	
	//Pass the WB and MEM Flags
	
	D_FF passMemtoReg (.q(MemtoRegOut), .d(MemtoReg), .reset(reset), .clk(clk));

	D_FF passRegWrite (.q(RegWriteOut), .d(RegWrite), .reset(reset), .clk(clk));
	
	D_FF passMemReadOut (.q(MemReadOut), .d(MemRead), .reset(reset), .clk(clk));
	
	D_FF passMemWriteOut (.q(MemWriteOut), .d(MemWrite), .reset(reset), .clk(clk));
	
	D_FF passBrTaken (.q(BrTakenOut), .d(BrTaken), .reset(reset), .clk(clk));


endmodule
