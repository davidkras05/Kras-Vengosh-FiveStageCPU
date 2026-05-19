module pipelinedTop(
	input logic clk,
	input logic reset
);
	logic Reg2Locwire, ALUSrcwire, Mem2Regwire, RegWritewire, MemWritewire, isDTypewire;
	logic MemReadwire, BrTakenwire, UncondBrwire, SetFlagswire, IsBLwire, IsBRwire;
	
	logic [2:0] ALUOpwire;
	logic [63:0] Da, Db, ALUInput, ALURes, BrLoc, WriteBck, MEMData;
	logic [63:0] PCp4, CurrPC;
	logic [31:0] instruction;
	logic[4:0] Rd, Rm, Rn;
	
	// flags (for now only zero flag and negative flag might need others later though):
	logic ZeroFlag, NegativeFlag, ZeroFlaghold, ZeroFlagmuxout, NegativeFlaghold, NegativeFlagmuxout;

	
	logic[31:0] IF_ID_instructionOut;
	logic[63:0] ID_EX_readData2Out, EX_MEM_address;
	logic ID_EX_BrTakenOut, ID_EX_IsBROut, MEM_WB_RegWriteOut, MEM_WB_IsBLOut;
	logic [1:0] FwdA, FwdB;
	
	control_unit control (.instruction(IF_ID_instructionOut), .Db(Db), .ZeroFlag(ZeroFlaghold), .NegativeFlag(NegativeFlaghold), 
	                      .Reg2Loc(Reg2Locwire), .ALUSrc(ALUSrcwire), .Mem2Reg(Mem2Regwire), 
								 .RegWrite(RegWritewire), .MemWrite(MemWritewire), .MemRead(MemReadwire), .BrTaken(BrTakenwire), 
								 .UncondBr(UncondBrwire), .SetFlags(SetFlagswire), .IsBL(IsBLwire), .IsBR(IsBRwire), 
								 .isDType(isDTypewire), .ALUOp(ALUOpwire));
								
	
	// For the Pipeline wiring, I am using naming conventions to make things easier. Output wires will just be the name of the
	//		pipeline followed by an _ and the name of the output. I am also using dividers to make the pipelines and their wiring clear
	
	// For now the only pipeline I have wired to the rest of the CPU is IF_ID. I have also wired up the outputs for each pipeline
	//		to the wires I made
	
	
	IF instructionFetch (.clk(clk), .reset(reset), .BrLoc(BrLoc), .Db(ID_EX_readData2Out), .BrTaken(ID_EX_BrTakenOut), .IsBR(ID_EX_IsBROut), 
	                     .instruction_output(instruction), .PCp4(PCp4), .CurrPC(CurrPC));
								
								// BrTaken, still an input IsBr still an input. pipeline BrTaken and IsBr to ID_EX and then write them 
								// back as inputs to IF.
	
	//IF_ID PIPELINE HERE ---------------------------------------------------------------------------------------------
	
	logic[63:0] IF_ID_currPCOut, IF_ID_PCp4Out;
	
	
	IF_ID firstpipeline (.clk(clk), .reset(reset), .instruction(instruction), .currPC(CurrPC), .PCp4(PCp4),
								.instructionOut(IF_ID_instructionOut), .currPCOut(IF_ID_currPCOut), .PCp4Out(IF_ID_PCp4Out));
	
	//-----------------------------------------------------------------------------------------------------------------
	
	
	ID instructionDecode(.clk(clk), .reset(reset), .Reg2Loc(Reg2Locwire), .ALUSrc(ALUSrcwire), 
								.RegWrite(MEM_WB_RegWriteOut), .IsBL(MEM_WB_IsBLOut), .isDType(isDTypewire), 
								.WriteBck(WriteBck), .PCp4(IF_ID_PCp4Out), .instruction(IF_ID_instructionOut), .Da(Da), 
								.Db(Db), .ALUInput(ALUInput), .Rd(Rd), .Rm(Rm), .Rn(Rn)); 
								
								// Control signals generated here. Need to pipeline signals that are used after this.
								
	
	//ID_EX PIPELINE HERE ----------------------------------------------------------------------------------------------
	
	logic[63:0] ID_EX_readData1Out, ID_EX_ALUInputOut, ID_EX_currPCOut;
	logic[31:0] ID_EX_instructionOut;
	logic[4:0] ID_EX_RdOut, ID_EX_RnOut, ID_EX_RmOut;
	logic ID_EX_MemtoRegOut, ID_EX_RegWriteOut, ID_EX_MemReadOut, ID_EX_MemWriteOut, ID_EX_ALUSrcOut;
	logic ID_EX_UncondBrOut, ID_EX_ISBLOut;
	logic[2:0] ID_EX_ALUOpOut;
	
	ID_EX secondpipeline (.clk(clk), .reset(reset), 
	
								 .instruction(instruction),
								 .readData1(Da), .readData2(Db), .ALUInput(ALUInput), 
							    .currPC(IF_ID_currPCOut), 
								 .Rd(Rd), .Rn(Rn), .Rm(Rm), 
								 .ALUOp(ALUOpwire), .MemtoReg(MemtoRegwire), .RegWrite(RegWritewire), 
								 .MemRead(MemReadwire), .MemWrite(MemWritewire), .BrTaken(BrTakenwire), 
								 .UncondBr(UncondBrwire), .IsBL(IsBLwire), .IsBR(IsBRwire),
								 
								 .instructionOut(ID_EX_instructionOut),
								 .readData1Out(ID_EX_readData1Out), .readData2Out(ID_EX_readData2Out), .ALUInputOut(ID_EX_ALUInputOut), 
								 .currPCOut(ID_EX_currPCOut),
								 .RdOut(ID_EX_RdOut), .RnOut(ID_EX_RnOut), .RmOut(ID_EX_RmOut),
								 .ALUOpOut(ID_EX_ALUOpOut), .MemtoRegOut(ID_EX_MemtoRegOut), .RegWriteOut(ID_EX_RegWriteOut), 
								 .MemReadOut(ID_EX_MemReadOut), .MemWriteOut(ID_EX_MemWriteOut), .BrTakenOut(ID_EX_BrTakenOut), 
								 .UncondBrOut(ID_EX_UncondBrOut), .IsBLOut(ID_EX_IsBLOut), .IsBROut(ID_EX_IsBROut));
								 
								 // Pipeline IsBR and BrTaken through here since we are moving them from IF to EX. wire their outputs back
								 // to inputs of IF (BrTaken and IsBr) also, wire DB back to IF from the ID_EX pipeline
								 
	
	//------------------------------------------------------------------------------------------------------------------
	
	
	EX execution (.UncondBr(ID_EX_UncondBrOut), .ALUOp(ID_EX_ALUOpOut), .instruction(ID_EX_instructionOut), 
					  .CurrPC(ID_EX_currPCOut),
					  .ALUIn0(ID_EX_readData1Out), .ALUIn1(ID_EX_ALUInputOut),
					  .ALUIn_WB(WriteBck), .ALUIn_EXMEM(EX_MEM_address),
					  .FwdA(FwdA), .FwdB(FwdB),
					  .ALURes(ALURes), .BrLoc(BrLoc), .ZeroFlag(ZeroFlag), .NegativeFlag(NegativeFlag));
					  
	//Flag hold registers
	
	two_onemux zeromux (.in({ZeroFlag, ZeroFlaghold}), .s(SetFlagswire), .y(ZeroFlagmuxout));
	
	D_FF zeroreg (.q(ZeroFlaghold), .d(ZeroFlagmuxout), .reset(reset), .clk(clk));
	
	two_onemux negativemux (.in({NegativeFlag, NegativeFlaghold}), .s(SetFlagswire), .y(NegativeFlagmuxout));
	
	D_FF negativereg (.q(NegativeFlaghold), .d(NegativeFlagmuxout), .reset(reset), .clk(clk));
					  
					  
	//EX_MEM PIPELINE HERE ---------------------------------------------------------------------------------------------
	
	logic[63:0] EX_MEM_writeMemData;
	logic[4:0] EX_MEM_RdOut;
	logic  EX_MEM_MemtoRegOut, EX_MEM_RegWriteOut, EX_MEM_MemReadOut, EX_MEM_MemWriteOut, EX_MEM_IsBLOut;
	
	// ALURes = address and readData2 = writeMemData
	EX_MEM thirdpipeline (.clk(clk), .reset(reset),
	
								 .ALURes(ALURes), .ReadData2(ID_EX_readData2Out), 
								 .Rd(ID_EX_RdOut), 
								 .MemtoReg(ID_EX_MemtoRegOut), .RegWrite(ID_EX_RegWriteOut), .MemRead(ID_EX_MemReadOut),
								 .MemWrite(ID_EX_MemWriteOut), .IsBL(ID_EX_ISBLOut),
								 
								 .address(EX_MEM_address), .writeMemData(EX_MEM_writeMemData), 
								 .RdOut(EX_MEM_RdOut),
								 .MemtoRegOut(EX_MEM_MemtoRegOut), .RegWriteOut(EX_MEM_RegWriteOut), .MemReadOut(EX_MEM_MemReadOut), 
								 .MemWriteOut(EX_MEM_MemWriteOut), .IsBLOut(EX_MEM_IsBLOut));
	
	//------------------------------------------------------------------------------------------------------------------
	
	
	datamem MEM (.address(EX_MEM_address), .write_enable(EX_MEM_MemWriteOut), .read_enable(EX_MEM_MemReadOut), 
					.write_data(EX_MEM_writeMemData), .clk(clk), .read_data(MEMData));
					
	//MEM_WB PIPELINE HERE ---------------------------------------------------------------------------------------------
	
	logic[63:0] MEM_WB_ALUResOut, MEM_WB_readMemDataOut;
	logic MEM_WB_MemtoRegOut;
	
	MEM_WB fourthpipeline (.clk(clk), .reset(reset), 
	
								  .readMemData(MEMData), .ALURes(EX_MEM_address), 
								  .MemtoReg(EX_MEM_MemtoRegOut),.RegWrite(EX_MEM_RegWriteOut), .IsBL(EX_MEM_IsBLOut),
								  
								  .ALUResOut(MEM_WB_ALUResOut), .readMemDataOut(MEM_WB_readMemDataOut), 
								  .MemtoRegOut(MEM_WB_MemtoRegOut), .RegWriteOut(MEM_WB_RegWriteOut), .IsBLOut(MEM_WB_IsBLOut));
	
	//FORWARDING UNIT HERE ---------------------------------------------------------------------------------------------
	
	
	forwardingUnit fwding_unit (.RnIDEX(ID_EX_RnOut), .RmIDEX(ID_EX_RmOut), .RdEXMEM(ID_EX_RdOut), .RdMEMWB(EX_MEM_RnOut),
	                            .RegWriteEXMEM(EX_MEM_RegWriteOut), .RegWriteMEMWB(MEM_WB_RegWriteOut),
										 .ForwardA(FwdA), .ForwardB(FwdB));
	//------------------------------------------------------------------------------------------------------------------
	
	WB writeBack (.ALURes(MEM_WB_ALUResOut), .MEMData(MEM_WB_readMemDataOut), .Mem2Reg(MEM_WB_MemtoRegOut), .WriteBck(WriteBck));
	
	
	
	
	
endmodule

