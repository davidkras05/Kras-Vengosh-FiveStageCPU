module EX (
	input logic UncondBr,
	input logic [2:0] ALUOp,
	input logic [31:0] instruction,
	input logic [63:0] CurrPC, ALUIn0, ALUIn1, ALUIn_WB, ALUIn_EXMEM, //Normal into 00, WB into 01, EXMEM into 10, X in 11
	input logic [1:0] FwdA, FwdB,
	output logic [63:0] ALURes, BrLoc,
	output logic ZeroFlag, NegativeFlag
);

	logic[63:0] A, B;

	
	// 64-bit 3:1 MUX needed, outputs are A and B (ALUIn0, ALUIn1, respectively)
	
	//MUX A
	
	logic[63:0] firstlevel1A, firstlevel2A;
	
	n_bit_2to1 #(.BITS(64)) forwardMux1A (.data_line1(ALUIn_WB), .data_line0(ALUIn0), .s(FwdA[0]), .mux_out(firstlevel1A));
	n_bit_2to1 #(.BITS(64)) forwardMux2A (.data_line1(64'bx), .data_line0(ALUIn_EXMEM), .s(FwdA[0]), .mux_out(firstlevel2A));
	
	n_bit_2to1 #(.BITS(64)) forwardMux3A (.data_line1(firstlevel1A), .data_line0(firstlevel2A), .s(FwdA[1]), .mux_out(A));
	
	//MUX B
	
	logic[63:0] firstlevel1B, firstlevel2B;
	
	n_bit_2to1 #(.BITS(64)) forwardMux1B (.data_line1(ALUIn_WB), .data_line0(ALUIn1), .s(FwdB[0]), .mux_out(firstlevel1B));
	n_bit_2to1 #(.BITS(64)) forwardMux2B (.data_line1(64'bx), .data_line0(ALUIn_EXMEM), .s(FwdB[0]), .mux_out(firstlevel2B));
	
	n_bit_2to1 #(.BITS(64)) forwardMux3B (.data_line1(firstlevel1B), .data_line0(firstlevel2B), .s(FwdB[1]), .mux_out(B));
	
	
	// Then change ALU inputs to A and B
	ALU ALU (.A(A), .B(B), .cntrl(ALUOp), .result(ALURes), .negative(NegativeFlag), .zero(ZeroFlag), .overflow(), .carry_out());

	logic [18:0] CondAddr19;
	logic [25:0] BrAddr26;

	assign CondAddr19 = instruction[23:5];
	assign BrAddr26 = instruction[25:0];

	logic [63:0] BrAddr64, CondAddr64;

	assign BrAddr64 = {{38{BrAddr26[25]}}, BrAddr26};
	assign CondAddr64 = {{45{CondAddr19[18]}}, CondAddr19};

	logic [63:0] BrLoc_unshifted;

	n_bit_2to1 #(.BITS(64)) UncondMux (.data_line1(BrAddr64), .data_line0(CondAddr64), .s(UncondBr), .mux_out(BrLoc_unshifted));

	logic[63:0] BrLoc_not_pcrel;
	assign BrLoc_not_pcrel = {BrLoc_unshifted[61:0], 2'b00}; //New shift (without RTL version)
	
	
	sixtyfourbit_fulladder BPCadd (.A(BrLoc_not_pcrel), .B(CurrPC), .Cin(1'b0), .S(BrLoc)); // Adds current PC to Br

endmodule 