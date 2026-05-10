module singleCycleTop(
	input logic clk,
	input logic reset
);
	logic Reg2Locwire, ALUSrcwire, Mem2Regwire, RegWritewire, MemWritewire, MemReadwire, BrTakenwire, UncondBrwire, SetFlagswire, IsBLwire, IsBRwire;
	
	logic [2:0] ALUOpwire;
	logic [63:0] Da, Db, ALUInput, ALURes, BrLoc, WriteBck, MEMData;
	logic [63:0] PCp4;
	logic [31:0] instruction;
	
	// flags (for now only zero flag and negative flag might need others later though):
	logic ZeroFlag, NegativeFlag, ZeroFlaghold, ZeroFlagmuxout, NegativeFlaghold, NegativeFlagmuxout;

	
	control_unit control (.instruction(instruction), .Db(Db), .ZeroFlag(ZeroFlaghold), .NegativeFlag(NegativeFlaghold), 
	                      .Reg2Loc(Reg2Locwire), .ALUSrc(ALUSrcwire), .Mem2Reg(Mem2Regwire), 
								 .RegWrite(RegWritewire), .MemWrite(MemWritewire), .MemRead(MemReadwire), .BrTaken(BrTakenwire), 
								 .UncondBr(UncondBrwire), .SetFlags(SetFlagswire), .IsBL(IsBLwire), .IsBR(IsBRwire), 
								 .ALUOp(ALUOpwire));
								
	
	
	IF instructionFetch (.clk(clk), .reset(reset), .BrLoc(BrLoc), .Db(Db), .BrTaken(BrTakenwire), .IsBR(IsBRwire), 
	                     .instruction_output(instruction), .PCp4(PCp4));
	
	
	
	ID instructionDecode(.clk(clk), .reset(reset), .Reg2Loc(Reg2Locwire), .ALUSrc(ALUSrcwire), 
								.RegWrite(RegWritewire), .IsBL(IsBLwire), .WriteBck(WriteBck), .PCp4(PCp4), 
								.instruction(instruction), .Da(Da), .Db(Db), .ALUInput(ALUInput));
								
	
	
	EX execution (.UncondBr(UncondBrwire), .ALUOp(ALUOpwire), .instruction(instruction), .ALUIn0(Da), .ALUIn1(ALUInput), 
	              .ALURes(ALURes), .BrLoc(BrLoc), .ZeroFlag(ZeroFlag), .NegativeFlag(NegativeFlag));
	
	
	// ngl i think that its always 64 bits, since its the amount that goes into memory
	datamem MEM (.address(ALURes), .write_enable(MemWritewire), .read_enable(MemReadwire), 
					.write_data(Db), .clk(clk), .read_data(MEMData));
	
	WB writeBack (.ALURes(ALURes), .MEMData(MEMData), .Mem2Reg(Mem2Regwire), .WriteBck(WriteBck));
	
	//Flag hold registers
	
	two_onemux zeromux (.in({ZeroFlag, ZeroFlaghold}), .s(SetFlagswire), .y(ZeroFlagmuxout));
	
	D_FF zeroreg (.q(Zeroflaghold), .d(ZeroFlagmuxout), .reset(reset), .clk(clk));
	
	two_onemux negativemux (.in({NegativeFlag, NegativeFlaghold}), .s(SetFlagswire), .y(NegativeFlagmuxout));
	
	D_FF negativereg (.q(NegativeFlaghold), .d(NegativeFlagmuxout), .reset(reset), .clk(clk));
	
	
	
endmodule

