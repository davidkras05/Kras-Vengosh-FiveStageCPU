module ID_EX (
	input logic clk, reset,
	input logic[31:0] instruction,
	input logic[63:0] readData1, readData2, ALUInput, currPC, 
	input logic[4:0] Rd, Rn, Rm,
	input logic[2:0] ALUOp,
	input logic MemtoReg, RegWrite, MemRead, MemWrite, BrTaken, UncondBr, IsBL, IsBR,
	
	output logic[31:0] instructionOut,
	output logic[63:0] readData1Out, readData2Out, ALUInputOut, currPCOut,
	output logic[4:0] RdOut, RnOut, RmOut,
	output logic[2:0] ALUOpOut,
	output logic MemtoRegOut, RegWriteOut, MemReadOut, MemWriteOut, BrTakenOut, UncondBrOut, IsBLOut, IsBROut
	
);

	//Pass 32 bit instruction
	nbit_register #(.BITS(32)) instr_reg(.clk(clk), .reset(reset), .write(instruction), .q(instructionOut));

	//Pass 64 bit read data 1
	nbit_register #(.BITS(64)) rd1_reg (.clk(clk), .reset(reset), .write(readData1), .q(readData1Out));
	
	//Pass the 64 bit read data 2
	nbit_register #(.BITS(64)) rd2_reg (.clk(clk), .reset(reset), .write(readData2), .q(readData2Out));
	
	//Pass 64 bit ALUInput
	nbit_register #(.BITS(64)) ALUInput_reg (.clk(clk), .reset(reset), .write(ALUInput), .q(ALUInputOut));
	
	//Pass 64 bit current PC
	nbit_register #(.BITS(64)) pc_reg (.clk(clk), .reset(reset), .write(currPC), .q(currPCOut));
	
	//Pass Rd (instruction[4:0])
	nbit_register #(.BITS(5)) Rd_reg (.clk(clk), .reset(reset), .write(Rd), .q(RdOut));
	
	//Pass Rn (instruction[9:5])
	nbit_register #(.BITS(5)) Rn_reg (.clk(clk), .reset(reset), .write(Rn), .q(RnOut));
	
	//Pass Rm (instruction[20:16])
	nbit_register #(.BITS(5)) Rm_reg (.clk(clk), .reset(reset), .write(Rm), .q(RmOut));
	
	//Pass WB control bits MemtoReg, RegWrite
	D_FF M2R_dff (.q(MemtoRegOut), .d(MemtoReg), .reset(reset), .clk(clk));
	D_FF RegWr_dff (.q(RegWriteOut), .d(RegWrite), .reset(reset), .clk(clk));
	

	//Pass MEM control bits MemRead, MemWrite, BrTaken, IsBROut, IsBLOut
	D_FF MemRd_dff (.q(MemReadOut), .d(MemRead), .reset(reset), .clk(clk));
	D_FF MemWr_dff (.q(MemWriteOut), .d(MemWrite), .reset(reset), .clk(clk));
	D_FF BrT_dff (.q(BrTakenOut), .d(BrTaken), .reset(reset), .clk(clk));
	D_FF IsBR_dff (.q(IsBROut), .d(IsBR), .reset(reset), .clk(clk));
	D_FF IsBL_dff (.q(IsBLOut), .d(IsBL), .reset(reset), .clk(clk));
	
	//Pass EX control bits ALU code, UncondBr
	nbit_register #(.BITS(3)) ALUOp_reg (.clk(clk), .reset(reset), .write(ALUOp), .q(ALUOpOut));
	D_FF UncondBr_dff (.q(UncondBrOut), .d(UncondBr), .reset(reset), .clk(clk));


endmodule
