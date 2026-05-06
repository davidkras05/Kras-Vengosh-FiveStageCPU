module singleCycleTop(
	input logic clk,
	input logic reset,
);
	logic Reg2Locwire, ALUSrcwire, Mem2Regwire, RegWritewire, MemWritewire, BrTakenwire, UncondBrwire, SetFlagswire;
	//Need an ALUOp wire. figure out how many bits needed for it and place it here

	control_unit control (.op_code(), .zero_flag(), .Reg2Loc(Reg2Locwire), .ALUSrc(ALUSrcwire), .Mem2Reg(Mem2Regwire), 
								.RegWrite(RegWritewire), .MemWrite(MemWritewire), .BrTaken(BrTakenwire), 
								.UncondBr(UncondBrwire), .SetFlags(SetFlagswire), .ALUOp());
	
	IF instructionFetch (.clk(clk), .reset(reset), .BrLoc(), .BrTaken(BrTakenwire), .instruction_output());
	
	ID instructionDecode(.clk(clk), .reset(reset), .Reg2Loc(Reg2Locwire), .ALUSrc(ALUSrcwire), 
								.RegWrite(RegWritewire), .WriteBck(), .DataWrite(), .instruction(), .Da(), .ALUInput());
	
	EX execution (.UncondBr(UncondBrwire), .ALUOp(), .instruction(), .ALUIn0(), .ALUIn1(), .ALURes(), .BrLoc(), .Zeroflag());
	
	instructmem MEM (.address(), .instruction(), .clk(clk));
	
	WB writeBack (.ALURes(), .MEMData(), .Mem2Reg(Mem2Regwire), .WriteBck());
	
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

