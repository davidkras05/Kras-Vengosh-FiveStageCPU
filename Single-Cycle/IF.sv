module IF (
	input clk, reset,
	input logic[63:0] Branchloc, //64 bits because PC register is 64 bits
	input logic BrTaken,
	output logic[31:0] instruction_output;
);

	logic[63:0] adderwire, curr_PC, next_PC;

	sixty_four_2to1 branchMux (.data_line1(Branchloc), .data_line0(64'b4), .s(BrTaken), .mux_out(adder_wire));
		
	sixtyfourbit_fulladder PCadd (.A(adder_wire), .B(curr_PC), .Cin(1'b0), .S(next_PC));
	
	register PC (.clk(clk), .write(next_PC), .reset(reset), .En(1'b1), .q(curr_PC));
	
	instructmem instructionMemory (address(.curr_PC), .instruction(instruction_output), .clk(clk));
	
endmodule
