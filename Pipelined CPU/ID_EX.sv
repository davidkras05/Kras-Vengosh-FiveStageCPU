module ID_EX (
	input logic[63:0] readData1, readData2, immediate, currPC,
	input logic[31:0] instruction,
	input logic[3:0] ALUop,
	input logic MemtoReg, RegWrite, MemRead, MemWrite, BrTaken, ALUSrc,
	
	output logic[63:0] readData1Out, readData2Out, immediateOut, currPCOut,
	output logic[4:0] Rd,
	output logic[10:0] OpCode, // In the diagram this gets passed to an ALUop which we do not have, may need to handle this differently
	output logic MEMtoReg, RegWrite, MemRead, MemWrite, BrTaken, ALUSrc
	
	
);

	//Pass 64 bit read data 1
	
	//Pass 64 bit read data 2
	
	//Pass 64 bit sign extended Immediate
	
	//Pass 64 bit current PC
	
	//Pass OpCode (instruction[31:21])
	
	//Pass Rd (instruction[4:0])
	
	//Pass WB control bits MemtoReg, RegWrite
	
	//Pass MEM control bits MemRead, MemWrite, BrTaken
	
	//Pass EX control bits ALU code and ALUSrc


endmodule
