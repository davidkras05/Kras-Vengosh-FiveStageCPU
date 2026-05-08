module singleCycleTop(
	input logic clk,
	input logic reset,
);
	logic Reg2Locwire, ALUSrcwire, Mem2Regwire, RegWritewire, MemWritewire, BrTakenwire, UncondBrwire, SetFlagswire;
	
	//Need an ALUOp wire. figure out how many bits needed for it and place it here
	
	// Quick note on the ALU and flags. I think we may need the negative flag for the B.LT command since it being *True* means that the second
   // argument was less than the first, right?
	// Also we still need BR but I'll need to work on that tmr between my classes
	logic [2:0] ALUOpwire;
	
	// flags (for now only zero flag, might need others later though):
	logic ZeroFlag, NegativeFlag;

	control_unit control (.instructions(instruction), .ZeroFlag(ZeroFlag), .NegativeFlag(NegativeFlag), 
	                      .Reg2Loc(Reg2Locwire), .ALUSrc(ALUSrcwire), .Mem2Reg(Mem2Regwire), 
								 .RegWrite(RegWritewire), .MemWrite(MemWritewire), .BrTaken(BrTakenwire), 
								 .UncondBr(UncondBrwire), .SetFlags(SetFlagswire), .ALUOp(ALUOp));
								
	logic [31:0] instruction;
	
	IF instructionFetch (.clk(clk), .reset(reset), .BrLoc(BrLoc), .BrTaken(BrTakenwire), .instruction_output(instruction));
	
	logic [63:0] Da, Db, ALUInput, ALURes, BrLoc, WriteBck, MEMData;
	
	ID instructionDecode(.clk(clk), .reset(reset), .Reg2Loc(Reg2Locwire), .ALUSrc(ALUSrcwire), 
								.RegWrite(RegWritewire), .WriteBck(WriteBck), .instruction(instruction), .Da(Da), .Db(Db) .ALUInput(ALUInput));
								
	
	
	EX execution (.UncondBr(UncondBrwire), .ALUOp(ALUOpwite), .instruction(instruction), .ALUIn0(Da), .ALUIn1(ALUInput), 
	              .ALURes(ALURes), .BrLoc(BrLoc), .ZeroFlag(ZeroFlag), .NegativeFlag(NegativeFlag));
	
	
	// Super not sure what xfer_size is
	datamem MEM (.address(ALURes), .write_enable(MemWritewire), .read_enable(MEmReadwire), .write_data(Db), .clk(clk), 
	             .xfer_size(), .read_data(MEMData))
	
	WB writeBack (.ALURes(ALURes), .MEMData(MEMData), .Mem2Reg(Mem2Regwire), .WriteBck(WriteBck));
	
endmodule
	

// This is a rough skeleton of what I imagine the top level is supposed to look like. I made the wires for the control unit
// and wired them to each of the Muxes in each stage. We need some more stuff though before we can finish this. Namely:
//
// 		1. We need the control unit entirely figured out. this is the first priority. The ALU we made has a operation of 3 bits
//				the ALUOp has a 2 bit operation. why? also I keep seeing on diagrams a like ALUOp unit connected to the control which is
//				then connected to the ALU? why? And do we need to do that?
//	
//			2. We need to figure out firmly what our inputs and outputs need to be for the top level. So far I just have clk and reset
//				which I know for a fact is needed. But I have no clue what else. I would imagine there is no need for an output but
//				idk what more inputs we need. The biggest one: how the hell do we actually get instructions into this thing
//
//			3. EX is unfinished due to the CNTRL problem and how many bits we are supposed to have
//
//			4. Are we going to be screwed over due to not having 2 different adders for the PC counter and just using 1 with a mux instead?
//				I would imagine not but it is something we should consider. If not I don't think we should worry about it.
//
//			5. Debugging and testing. I am guessing we are going to have to do a shitload of this so we should start early. lets look
//				at the tools they provide and also figure if we need to do a testbench. I dont think so but we should double check
//
//			End of my yap sesh.

