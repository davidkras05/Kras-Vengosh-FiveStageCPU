module IF (
	input clk, reset,
	input logic [63:0] BrLoc, Db, EX_ALURes, //64 bits because PC register is 64 bits
	input logic BrTaken, IsBR, FwdForBR,
	output logic [31:0] instruction_output,
	output logic [63:0] PCp4, CurrPC //Added CurrPC as an output since the IF_ID pipeline needs access to the CurrPC
);

	logic [63:0] NextPC;
	
	register PC (.clk(clk), .write(NextPC), .reset(reset), .En(1'b1), .q(CurrPC));
	
	sixtyfourbit_fulladder PCplus4add (.A(64'd4), .B(CurrPC), .Cin(1'b0), .S(PCp4)); // Devoted PC + 4 adder. Needs to be an output for BL instruction
	
	logic [63:0] BrMux_noBR, Db_with_fwd;
	n_bit_2to1 #(.BITS(64)) branchMux (.data_line1(BrLoc), .data_line0(PCp4), .s(BrTaken), .mux_out(BrMux_noBR));
	
	//Need to find the control signal to tell the CPU to use the ALU result if the previous instruction had Rt as the Result
	n_bit_2to1 #(.BITS(64)) fwdBRMux (.data_line1(EX_ALURes), .data_line0(Db), .s(FwdForBR), .mux_out(Db_with_fwd));
	
	n_bit_2to1 #(.BITS(64)) BRMux (.data_line1(Db_with_fwd), .data_line0(BrMux_noBR), .s(IsBR), .mux_out(NextPC)); //Allows for BR instruction
	
	instructmem instructionMemory (.address(CurrPC), .instruction(instruction_output), .clk(clk));
	
endmodule
