module pipelinedTop(
	input logic clk,
	input logic reset
);
	logic Reg2Locwire, ALUSrcwire, MemtoRegwire, RegWritewire, MemWritewire, isDTypewire;
	logic MemReadwire, BrTakenwire, UncondBrwire, SetFlagswire, IsBLwire, IsBRwire;
	
	logic [2:0] ALUOpwire;
	logic [63:0] Da, Db, ALUInput, ALURes, BrLoc, WriteBck, MEMData;
	logic [63:0] PCp4, CurrPC;
	logic [31:0] instruction;
	logic[4:0] Rd, Rm, Rn;
	
	// flags (for now only zero flag and negative flag might need others later though):
	logic ZeroFlag, NegativeFlag, ZeroFlaghold, ZeroFlagmuxout, NegativeFlaghold, NegativeFlagmuxout;

	
	logic[31:0] IF_ID_instructionOut;
	logic[63:0] ID_EX_readData2Out, EX_MEM_address, ID_EX_PCp4Out, EX_MEM_PCp4Out, MEM_WB_PCp4Out;
	logic ID_EX_BrTakenOut, MEM_WB_RegWriteOut, MEM_WB_IsBLOut, ID_EX_ALUSrcOut, ID_EX_SetFlagsOut;
	logic WBErrorA, WBErrorB, FwdForBR;
	logic [4:0] MEM_WB_RdOut;
	logic [1:0] FwdA, FwdB;
	
	control_unit control (.instruction(IF_ID_instructionOut), .Db(Db), 
								 .ZeroFlag(ZeroFlaghold), .NegativeFlag(NegativeFlaghold),
								 .ALUOutputZero(ZeroFlag), .ALUOutputNegative(NegativeFlag), .EX_SetFlags(ID_EX_SetFlagsOut),
	                      .Reg2Loc(Reg2Locwire), .ALUSrc(ALUSrcwire), .Mem2Reg(MemtoRegwire), 
								 .RegWrite(RegWritewire), .MemWrite(MemWritewire), .MemRead(MemReadwire), .BrTaken(BrTakenwire), 
								 .UncondBr(UncondBrwire), .SetFlags(SetFlagswire), .IsBL(IsBLwire), .IsBR(IsBRwire), 
								 .isDType(isDTypewire), .ALUOp(ALUOpwire));
								
	
	// For the Pipeline wiring, I am using naming conventions to make things easier. Output wires will just be the name of the
	//		pipeline followed by an _ and the name of the output. I am also using dividers to make the pipelines and their wiring clear
	
	// For now the only pipeline I have wired to the rest of the CPU is IF_ID. I have also wired up the outputs for each pipeline
	//		to the wires I made
	
	
	IF instructionFetch (.clk(clk), .reset(reset), .BrLoc(BrLoc), .Db(Db), .EX_ALURes(ALURes), .BrTaken(BrTakenwire), .IsBR(IsBRwire),
	                     .FwdForBR(FwdForBR), .instruction_output(instruction), .PCp4(PCp4), .CurrPC(CurrPC));
								
								// BrTaken, still an input IsBr still an input. pipeline BrTaken and IsBr to ID_EX and then write them 
								// back as inputs to IF.
	
	//IF_ID PIPELINE HERE ---------------------------------------------------------------------------------------------
	
	logic[63:0] IF_ID_CurrPCOut, IF_ID_PCp4Out;
	
	
	IF_ID firstpipeline (.clk(clk), .reset(reset), .instruction(instruction), .currPC(CurrPC), .PCp4(PCp4),
								.instructionOut(IF_ID_instructionOut), .currPCOut(IF_ID_CurrPCOut), .PCp4Out(IF_ID_PCp4Out));
	
	//-----------------------------------------------------------------------------------------------------------------
	
	
	ID instructionDecode(.clk(clk), .reset(reset), 
	
								.Reg2Loc(Reg2Locwire), .ALUSrc(ALUSrcwire), .RegWrite(MEM_WB_RegWriteOut), 
								.IsBL(IsBLwire), .isDType(isDTypewire), .UncondBr(UncondBrwire),
								.WriteBck(WriteBck), 
								.PCp4(IF_ID_PCp4Out), .CurrPC(IF_ID_CurrPCOut), .instruction(IF_ID_instructionOut), 
								.WBRd(MEM_WB_RdOut), .WBErrorA(WBErrorA), .WBErrorB(WBErrorB), 
								
								.Da(Da), .Db(Db), .ALUInput(ALUInput), 
								.BrLoc(BrLoc), 
								.Rd(Rd), .Rm(Rm), .Rn(Rn)); 
								
								// Control signals generated here. Need to pipeline signals that are used after this.
								
	
	//ID_EX PIPELINE HERE ----------------------------------------------------------------------------------------------
	
	logic[63:0] ID_EX_readData1Out, ID_EX_ALUInputOut, ID_EX_currPCOut;
	logic[31:0] ID_EX_instructionOut;
	logic[4:0] ID_EX_RdOut, ID_EX_RnOut, ID_EX_RmOut;
	logic ID_EX_MemtoRegOut, ID_EX_RegWriteOut, ID_EX_MemReadOut, ID_EX_MemWriteOut;
	logic ID_EX_UncondBrOut, ID_EX_IsBLOut;
	logic[2:0] ID_EX_ALUOpOut;
	
	ID_EX secondpipeline (.clk(clk), .reset(reset), 
	
								 .readData1(Da), .readData2(Db), .ALUInput(ALUInput), .PCp4(IF_ID_PCp4Out),  
								 .Rd(Rd), .Rn(Rn), .Rm(Rm), 
								 .ALUOp(ALUOpwire), .ALUSrc(ALUSrcwire), .MemtoReg(MemtoRegwire), .RegWrite(RegWritewire), 
								 .MemRead(MemReadwire), .MemWrite(MemWritewire), .BrTaken(BrTakenwire), 
								 .UncondBr(UncondBrwire), .IsBL(IsBLwire), .SetFlags(SetFlagswire),
								 
								 .readData1Out(ID_EX_readData1Out), .readData2Out(ID_EX_readData2Out), .ALUInputOut(ID_EX_ALUInputOut), .PCp4Out(ID_EX_PCp4Out),
								 .RdOut(ID_EX_RdOut), .RnOut(ID_EX_RnOut), .RmOut(ID_EX_RmOut),
								 .ALUOpOut(ID_EX_ALUOpOut), .ALUSrcOut(ID_EX_ALUSrcOut), .MemtoRegOut(ID_EX_MemtoRegOut), .RegWriteOut(ID_EX_RegWriteOut), 
								 .MemReadOut(ID_EX_MemReadOut), .MemWriteOut(ID_EX_MemWriteOut), .BrTakenOut(ID_EX_BrTakenOut), 
								 .UncondBrOut(ID_EX_UncondBrOut), .IsBLOut(ID_EX_IsBLOut), .SetFlagsOut(ID_EX_SetFlagsOut));
								 
								 // Pipeline IsBR and BrTaken through here since we are moving them from IF to EX. wire their outputs back
								 // to inputs of IF (BrTaken and IsBr) also, wire DB back to IF from the ID_EX pipeline
								 
	
	//------------------------------------------------------------------------------------------------------------------
	
	
	EX execution (.UncondBr(ID_EX_UncondBrOut), .ALUOp(ID_EX_ALUOpOut), 
					  .ALUIn0(ID_EX_readData1Out), .ALUIn1(ID_EX_ALUInputOut),
					  .ALUIn_WB(WriteBck), .ALUIn_EXMEM(EX_MEM_address),
					  .FwdA(FwdA), .FwdB(FwdB),
					  .ALURes(ALURes), .ZeroFlag(ZeroFlag), .NegativeFlag(NegativeFlag));
					  
	//Flag hold registers
	
	two_onemux zeromux (.in({ZeroFlag, ZeroFlaghold}), .s(ID_EX_SetFlagsOut), .y(ZeroFlagmuxout));
	
	D_FF zeroreg (.q(ZeroFlaghold), .d(ZeroFlagmuxout), .reset(reset), .clk(clk));
	
	two_onemux negativemux (.in({NegativeFlag, NegativeFlaghold}), .s(ID_EX_SetFlagsOut), .y(NegativeFlagmuxout));
	
	D_FF negativereg (.q(NegativeFlaghold), .d(NegativeFlagmuxout), .reset(reset), .clk(clk));
					  
					  
	//EX_MEM PIPELINE HERE ---------------------------------------------------------------------------------------------
	
	logic[63:0] EX_MEM_writeMemData;
	logic[4:0] EX_MEM_RdOut;
	logic  EX_MEM_MemtoRegOut, EX_MEM_RegWriteOut, EX_MEM_MemReadOut, EX_MEM_MemWriteOut, EX_MEM_IsBLOut;
	
	// ALURes = address and readData2 = writeMemData
	EX_MEM thirdpipeline (.clk(clk), .reset(reset),
	
								 .ALURes(ALURes), .ReadData2(ID_EX_readData2Out), .PCp4(ID_EX_PCp4Out),
								 .Rd(ID_EX_RdOut), 
								 .MemtoReg(ID_EX_MemtoRegOut), .RegWrite(ID_EX_RegWriteOut), .MemRead(ID_EX_MemReadOut),
								 .MemWrite(ID_EX_MemWriteOut), .IsBL(ID_EX_IsBLOut),
								 
								 .address(EX_MEM_address), .writeMemData(EX_MEM_writeMemData), .PCp4Out(EX_MEM_PCp4Out),
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
	
								  .readMemData(MEMData), .ALURes(EX_MEM_address), .PCp4(EX_MEM_PCp4Out), .Rd(EX_MEM_RdOut), 
								  .MemtoReg(EX_MEM_MemtoRegOut),.RegWrite(EX_MEM_RegWriteOut), .IsBL(EX_MEM_IsBLOut),
								  
								  .ALUResOut(MEM_WB_ALUResOut), .readMemDataOut(MEM_WB_readMemDataOut), .PCp4Out(MEM_WB_PCp4Out), .RdOut(MEM_WB_RdOut),
								  .MemtoRegOut(MEM_WB_MemtoRegOut), .RegWriteOut(MEM_WB_RegWriteOut), .IsBLOut(MEM_WB_IsBLOut));
	
	//FORWARDING UNIT HERE ---------------------------------------------------------------------------------------------
	
	
	forwardingUnit fwding_unit (.RnID(Rn), .RmID(Rm), 
										 .RnIDEX(ID_EX_RnOut), .RmIDEX(ID_EX_RmOut), 
										 .RdEXMEM(EX_MEM_RdOut), .RdMEMWB(MEM_WB_RdOut), .RdEX(ID_EX_RdOut), .RdID(Rd),
	                            .RegWriteEXMEM(EX_MEM_RegWriteOut), .RegWriteMEMWB(MEM_WB_RegWriteOut),
										 .ALUSrcEX(ID_EX_ALUSrcOut), .Reg2LocID(Reg2Locwire), .ID_IsBR(IsBRwire), .RegWriteIDEX(ID_EX_RegWriteOut),
										 .ForwardA(FwdA), .ForwardB(FwdB), 
										 .WBErrorA(WBErrorA), .WBErrorB(WBErrorB), 
										 .FwdForBR(FwdForBR));
	//------------------------------------------------------------------------------------------------------------------
	
	WB writeBack (.ALURes(MEM_WB_ALUResOut), .MEMData(MEM_WB_readMemDataOut), .Mem2Reg(MEM_WB_MemtoRegOut), .WriteBck(WriteBck));
	
	
	
	
	
endmodule

