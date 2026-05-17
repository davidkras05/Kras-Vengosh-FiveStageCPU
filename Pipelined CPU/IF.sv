module IF (
	input clk, reset,
	input logic [63:0] BrLoc, Db, //64 bits because PC register is 64 bits
	input logic BrTaken, IsBR,
	output logic [31:0] instruction_output,
	output logic [63:0] PCp4, CurrPC //Added CurrPC as an output since the IF_ID pipeline needs access to the CurrPC
);

	logic [63:0] NextPC;
	
	register PC (.clk(clk), .write(NextPC), .reset(reset), .En(1'b1), .q(CurrPC));
	
	sixtyfourbit_fulladder PCplus4add (.A(64'd4), .B(CurrPC), .Cin(1'b0), .S(PCp4)); // Devoted PC + 4 adder. Needs to be an output for BL instruction
	
	logic [63:0] B_instr_add;
	sixtyfourbit_fulladder BPCadd (.A(BrLoc), .B(CurrPC), .Cin(1'b0), .S(B_instr_add));
	
	logic [63:0] BrMux_noBR;
	n_bit_2to1 #(.BITS(64)) branchMux (.data_line1(B_instr_add), .data_line0(PCp4), .s(BrTaken), .mux_out(BrMux_noBR));
	
	
	n_bit_2to1 #(.BITS(64)) BRMux (.data_line1(Db), .data_line0(BrMux_noBR), .s(IsBR), .mux_out(NextPC)); //Allows for BR instruction
	
	instructmem instructionMemory (.address(CurrPC), .instruction(instruction_output), .clk(clk));
	
endmodule
