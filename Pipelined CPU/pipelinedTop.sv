module singleCycleTop(
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

	
	control_unit control (.instruction(instruction), .Db(Db), .ZeroFlag(ZeroFlaghold), .NegativeFlag(NegativeFlaghold), 
	                      .Reg2Loc(Reg2Locwire), .ALUSrc(ALUSrcwire), .Mem2Reg(Mem2Regwire), 
								 .RegWrite(RegWritewire), .MemWrite(MemWritewire), .MemRead(MemReadwire), .BrTaken(BrTakenwire), 
								 .UncondBr(UncondBrwire), .SetFlags(SetFlagswire), .IsBL(IsBLwire), .IsBR(IsBRwire), 
								 .isDType(isDTypewire), .ALUOp(ALUOpwire));
								
	
	// For the Pipeline wiring, I am using naming conventions to make things easier. Output wires will just be the name of the
	//		pipeline followed by an _ and the name of the output. I am also using dividers to make the pipelines and their wiring clear
	
	// For now the only pipeline I have wired to the rest of the CPU is IF_ID. I have also wired up the outputs for each pipeline
	//		to the wires I made
	
	
	IF instructionFetch (.clk(clk), .reset(reset), .BrLoc(BrLoc), .Db(Db), .BrTaken(BrTakenwire), .IsBR(IsBRwire), 
	                     .instruction_output(instruction), .PCp4(PCp4), .CurrPC(CurrPC));
								
								// BrTaken, still an input IsBr still an input. pipeline BrTaken and IsBr to ID_EX and then write them 
								// back as inputs to IF.
	
	//IF_ID PIPELINE HERE ---------------------------------------------------------------------------------------------
	
	logic[63:0] IF_ID_currPCOut, IF_ID_PCp4Out;
	logic[31:0] IF_ID_instructionOut;
	logic IF_ID_isDTypeOut;
	
	IF_ID firstpipeline (.clk(clk), .reset(reset), .instruction(instruction), .currPC(CurrPC), .PCp4(PCp4), .isDType(isDTypewire)
								.instructionOut(IF_ID_instructionOut), .currPCOut(IF_ID_currPCOut), .PCp4Out(IF_ID_PCp4Out), 
								.isDTypeOut(IF_ID_isDTypeOut));
	
	//-----------------------------------------------------------------------------------------------------------------
	
	
	ID instructionDecode(.clk(clk), .reset(reset), .Reg2Loc(Reg2Locwire), .ALUSrc(ALUSrcwire), 
								.RegWrite(RegWritewire), .IsBL(IsBLwire), .isDType(IF_ID_isDTypeOut), 
								.WriteBck(WriteBck), .PCp4(IF_ID_PCp4Out), .instruction(IF_ID_instructionOut), .Da(Da), 
								.Db(Db), .ALUInput(ALUInput), .Rd(Rd), .Rm(Rm), .Rn(Rn)); 
								
								// Control signals generated here. Need to pipeline signals that are used after this.
								
								//Note* Pipeline Brtaken and IsBR through here
								
	
	//ID_EX PIPELINE HERE ----------------------------------------------------------------------------------------------
	
	logic[63:0] ID_EX_readData1Out, ID_EX_ALUInputOut, ID_EX_currPCOut;
	logic[4:0] ID_EX_RdOut, ID_EX_RnOut, ID_EX_RmOut;
	logic ID_EX_MemtoRegOut, ID_EX_RegWriteOut, ID_EX_MemReadOut, ID_EX_MemWriteOut, ID_EX_ALUSrcOut, ID_EX_BrTakenOut, ID_EX_IsBrOut;
	logic[2:0] ID_EX_ALUOpOut;
	
	ID_EX secondpipeline (.clk(clk), .reset(reset), .readData1(Da), .readData2(Db), .currPC(IF_ID_currPCOut), 
								 .Rd(Rd), .Rn(Rn), .Rm(Rm), .ALUOp(ALUOpwire), .MemtoReg(MemtoRegwire), .RegWrite(RegWritewire), 
								 .MemRead(MemReadwire), .MemWrite(MemWritewire), .BrTaken(), .IsBr(), /* ADD THESE ONCE BRTAKEN AND ISBR IS MOVED TO EX*/
								 .readData1Out(ID_EX_readData1Out), .readData2Out(ID_EX_readData2Out),
								 .ALUInput(ID_EX_ALUInputOut), .currPCOut(ID_EX_currPCOut),
								 .RdOut(ID_EX_RdOut), RnOut(ID_EX_RnOut), .RmOut(ID_EX_RmOut), 
								 .MemtoRegOut(ID_EX_MemtoRegOut), .RegWriteOut(ID_EX_RegWriteOut), 
								 .MemReadOut(ID_EX_MemReadOut), .MemWriteOut(ID_EX_MemWriteOut), .BrTakenOut(ID_EX_BrTakenOut), 
								 .IsBrOut(ID_EX_IsBrOut), 
								 .ALUSrcOut(ID_EX_ALUSrcOut), .ALUOpOut(ID_EX_ALUOpOut));
								 
								 // Pipeline IsBR and BrTaken through here since we are moving them from IF to EX. wire their outputs back
								 // to inputs of IF (BrTaken and IsBr)
								 
	
	//------------------------------------------------------------------------------------------------------------------
	
	
	EX execution (.UncondBr(UncondBrwire), .ALUOp(ALUOpwire), .instruction(instruction), .ALUIn0(Da), .ALUIn1(ALUInput), 
	              .ALURes(ALURes), .BrLoc(BrLoc), .ZeroFlag(ZeroFlag), .NegativeFlag(NegativeFlag));
					  
					  // ADD IsBr AND BrTaken HERE IN EX
					  
	//EX_MEM PIPELINE HERE ---------------------------------------------------------------------------------------------
	
	logic[63:0] EX_MEM_address, EX_MEM_writeMemData;
	logic[4:0] EX_MEM_RdOut;
	logic  EX_MEM_MemtoRegOut, EX_MEM_RegWriteOut, EX_MEM_MemReadOut, EX_MEM_MemWriteOut;
	
	EX_MEM thirdpipeline (.clk(clk), .reset(reset), .ALURes(ALURes), .ReadData2(ID_EX_readData2Out), 
								 .Rd(ID_EX_RdOut), .MemtoReg(ID_EX_MemtoRegOut), .RegWrite(ID_EX_RegWriteOut),
								 .MemRead(ID_EX_MemReadOut), .MemWrite(ID_EX_MemWriteOut), .address(EX_MEM_address), 
								 .writeMemData(ID_EX_readData2Out), .RdOut(EX_MEM_RdOut),
								 .MemtoRegOut(EX_MEM_MemtoRegOut), .RegWriteOut(EX_MEM_RegWriteOut), .MemReadOut(EX_MEM_MemReadOut), 
								 .MemWriteOut(EX_MEM_MemWriteOut));
	
	//------------------------------------------------------------------------------------------------------------------
	
	
	datamem MEM (.address(ALURes), .write_enable(MemWritewire), .read_enable(MemReadwire), 
					.write_data(Db), .clk(clk), .read_data(MEMData));
					
	//MEM_WB PIPELINE HERE ---------------------------------------------------------------------------------------------
	
	logic[63:0] MEM_WB_ALUResOut, MEM_WB_readMemDataOut;
	logic MEM_WB_MemtoRegOut, MEM_WB_RegWriteOut;
	
	MEM_WB fourthpipeline (.clk(clk), .reset(reset), .readMemData(), .ALURes(), .MemtoReg(), .RegWrite(),
								  .ALUResOut(MEM_WB_ALUResOut), .readMemDataOut(MEM_WB_readMemDataOut), 
								  .MemtoRegOut(MEM_WB_MemtoRegOut), .RegWriteOut(MEM_WB_RegWriteOut));
	
	//------------------------------------------------------------------------------------------------------------------
	
	
	WB writeBack (.ALURes(ALURes), .MEMData(MEMData), .Mem2Reg(Mem2Regwire), .WriteBck(WriteBck));
	
	//Flag hold registers
	
	two_onemux zeromux (.in({ZeroFlag, ZeroFlaghold}), .s(SetFlagswire), .y(ZeroFlagmuxout));
	
	D_FF zeroreg (.q(ZeroFlaghold), .d(ZeroFlagmuxout), .reset(reset), .clk(clk));
	
	two_onemux negativemux (.in({NegativeFlag, NegativeFlaghold}), .s(SetFlagswire), .y(NegativeFlagmuxout));
	
	D_FF negativereg (.q(NegativeFlaghold), .d(NegativeFlagmuxout), .reset(reset), .clk(clk));
	
	
	
endmodule

