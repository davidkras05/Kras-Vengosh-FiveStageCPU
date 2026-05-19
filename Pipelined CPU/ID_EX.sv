module ID_EX (
	input logic clk, reset,
	input logic[63:0] readData1, readData2, immediate, currPC,
	input logic[4:0] Rd, Rn, Rm,
	input logic[31:0] instruction,
	input logic[2:0] ALUOp,
	input logic MemtoReg, RegWrite, MemRead, MemWrite, BrTaken, ALUSrc,
	
	output logic[63:0] readData1Out, readData2Out, immediateOut, currPCOut,
	output logic[4:0] RdOut, RnOut, RmOut,
	output logic MemtoRegOut, RegWriteOut, MemReadOut, MemWriteOut, BrTakenOut, ALUSrcOut
	output logic[2:0] ALUOpOut
	
	
);

	//Pass 64 bit read data 1
	nbit_register #(.BITS(64)) rd1_reg (.clk(clk), .reset(reset), .write(readData1), .q(readData1Out));
	
	//Pass 64 bit read data 2
	nbit_register #(.BITS(64)) rd2_reg (.clk(clk), .reset(reset), .write(readData2), .q(readData2Out));
	
	//Pass 64 bit sign extended Immediate
	nbit_register #(.BITS(64)) imm_reg (.clk(clk), .reset(reset), .write(immediate), .q(immediateOut));
	
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
	
	//Pass MEM control bits MemRead, MemWrite, BrTaken
	D_FF MemRd
	_dff (.q(MemReadOut), .d(MemRead), .reset(reset), .clk(clk));
	D_FF MemWr_dff (.q(MemWriteOut), .d(MemWrite), .reset(reset), .clk(clk));
	D_FF BrT_dff (.q(BrTakenOut), .d(BrTaken), .reset(reset), .clk(clk));
	
	//Pass EX control bits ALU code and ALUSrc
	D_FF ALUOp_dff (.q(ALUOpOut), .d(ALUOp), .reset(reset), .clk(clk));
	D_FF ALUSrc_dff (.q(ALUSrcOut), .d(ALUSrc), .reset(reset), .clk(clk));


endmodule
