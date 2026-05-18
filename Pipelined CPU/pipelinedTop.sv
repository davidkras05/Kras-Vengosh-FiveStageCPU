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
	
	//IF_ID PIPELINE HERE ---------------------------------------------------------------------------------------------
	
	logic[63:0] IF_ID_currPCOut, IF_ID_PCp4Out;
	logic[31:0] IF_ID_instructionOut;
	
	IF_ID firstpipeline (.clk(clk), .reset(reset), .instruction(instruction), .currPC(CurrPC), .PCp4(PCp4),
								.instructionOut(IF_ID_instructionOut), .currPCOut(IF_ID_currPCOut), .PCp4(IF_ID_PCp4Out));
	
	//-----------------------------------------------------------------------------------------------------------------
	
	
	ID instructionDecode(.clk(clk), .reset(reset), .Reg2Loc(Reg2Locwire), .ALUSrc(ALUSrcwire), 
								.RegWrite(RegWritewire), .IsBL(IsBLwire), .isDType(isDTypewire), 
								.WriteBck(WriteBck), .PCp4(IF_ID_PCp4Out), .instruction(IF_ID_instructionOut), .Da(Da), 
								.Db(Db), .ALUInput(ALUInput)); //Since we are using PCp4 here, I am not sure if we have to add it to the pipeline
																		// we also need to add outputs of Rd, Rn, Rm.
	
	//ID_EX PIPELINE HERE ----------------------------------------------------------------------------------------------
	
	logic[63:0] ID_EX_readData1Out, ID_EX_readData2Out, ID_EX_immediateOut, ID_EX_currPCOut;
	logic[4:0] ID_EX_RdOut, ID_EX_RnOut, ID_EX_RmOut;
	logic ID_EX_MemtoRegOut, ID_EX_RegWriteOut, ID_EX_MemReadOut, ID_EX_MemWriteOut, ID_EX_BrTakenOut, ID_EX_ALUSrcOut;
	logic[2:0] ID_EX_ALUOpOut;
	
	ID_EX secondpipeline (.clk(clk), .reset(reset), .readData1(), .readData2(), .immediate(), .currPC(), 
								 .Rd(), .Rn(), .Rm(), .instruction(), .ALUOp(), .MemtoReg(), .RegWrite(), .MemRead(),
								 .MemWrite(), .BrTaken(), .ALUSrc(), 
								 .readData1Out(ID_EX_readData1Out), .readData2Out(ID_EX_readData2Out), 
								 .immediateOut(ID_EX_immediateOut), .currPCOut(ID_EX_currPCOut),
								 .RdOut(ID_EX_RdOut), RnOut(ID_EX_RnOut), .RmOut(ID_EX_RmOut), 
								 .MemtoRegOut(ID_EX_MemtoRegOut), .RegWriteOut(ID_EX_RegWriteOut), 
								 .MemReadOut(ID_EX_MemReadOut), .MemWriteOut(ID_EX_MemWriteOut), 
								 .BrTakenOut(ID_EX_BrTakenOut), .ALUSrcOut(ID_EX_ALUSrcOut), .ALUOpOut(ID_EX_ALUOpOut));
								 
								 // Since we added more control signals, we should figure out if we need to 
								 //  add those too. Like "isDtype" or "IsBR" or "IsBL" So I am skipping wiring the inputs here for now
								 //  also I think we don't have to pass BRTaken here I think what we actually need to pass is BrLoc since
								 //  BrTaken is only used in IF so I don't see why that would have to be pipelined to here.
	
	//------------------------------------------------------------------------------------------------------------------
	
	
	EX execution (.UncondBr(UncondBrwire), .ALUOp(ALUOpwire), .instruction(instruction), .ALUIn0(Da), .ALUIn1(ALUInput), 
	              .ALURes(ALURes), .BrLoc(BrLoc), .ZeroFlag(ZeroFlag), .NegativeFlag(NegativeFlag));
					  
	//EX_MEM PIPELINE HERE ---------------------------------------------------------------------------------------------
	
	logic[63:0] EX_MEM_address, EX_MEM_writeMemData, EX_MEM_BranchOut;
	logic[4:0] EX_MEM_RdOut;
	logic EX_MEM_zeroFlagOut, EX_MEM_MemtoRegOut, EX_MEM_RegWriteOut, EX_MEM_MemReadOut, EX_MEM_MemWriteOut, EX_MEM_BrTakenOut;
	
	EX_MEM thirdpipeline (.clk(clk), .reset(reset), .ALURes(), .ReadData2(), .Branch(), .Rd(), .MemtoReg(), .RegWrite(),
								 .MemRead(), .MemWrite(), .BrTaken(), .zeroFlag(), .address(), .writeMemData(), .BranchOut(), .RdOut(),
								 .zeroFlagOut(), .MemtoRegOut(), .RegWriteOut(), .MemReadOut(), .MemWriteOut(), .BrTakenOut());
	
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

