module EX (
	input logic UncondBr,
	input logic [2:0] ALUOp,
	input logic [31:0] instruction,
	input logic [63:0] ALUIn0, ALUIn1,
	output logic [63:0] ALURes, BrLoc,
	output logic ZeroFlag, NegativeFlag
);

	ALU ALU (.A(ALUIn0), .B(ALUIn1), .cntrl(ALUOp), .result(ALURes), .negative(NegativeFlag), .zero(ZeroFlag), .overflow(), .carry_out())

	logic [18:0] CondAddr19;
	logic [25:0] BrAddr26;

	assign CondAddr19 = instruction[23:5];
	assign BrAddr26 = instruction[25:0];

	logic [63:0] BrAddr64, CondAddr64;

	assign BrAddr64 = {{38{BrAddr26[25]}}, BrAddr26};
	assign CondAddr64 = {{45{CondAddr19[25]}}, CondAddr19};

	logic [63:0] BrLoc_unshifted;

	n_bit_2to1 #(.BITS(64)) (.data_line1(BrAddr64), .data_line0(CondAddr64), .s(UncondBr), .mux_out(BrLoc_unshifted))

	assign BrLoc = BrLoc_unshifted << 2;

endmodule 