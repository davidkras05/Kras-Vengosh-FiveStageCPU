module EX_MEM (
	input logic clk, reset,
	input logic[63:0] ALURes, ReadData2, Branch,
	input logic[4:0] Rd,
	input logic MemtoReg, RegWrite, MemRead, MemWrite, BrTaken,
	
	output logic[63:0] address, writeMemData, BranchOut,
	output logic[4:0] RdOut,
);

	//Pass 64 bit ALU Result
	
	//Pass 64 bit ReadData2
	
	//Pass 64 bit Branch (to add when branching)
	
	//Pass ZeroFlag
	
	//Pass Rd (instruction[4:0])
	
	//Pass the WB and MEM Flags



endmodule
