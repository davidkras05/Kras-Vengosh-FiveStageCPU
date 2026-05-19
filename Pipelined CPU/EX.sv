module EX (
	input logic UncondBr,
	input logic [2:0] ALUOp,
	input logic [31:0] instruction,
	input logic [63:0] CurrPC, ALUIn0, ALUIn1, ALUIn_WB, ALUIn_EXMEM, //Normal into 00, WB into 01, EXMEM into 10, X in 11
	input logic [1:0] FwdA, FwdB,
	output logic [63:0] ALURes, BrLoc,
	output logic ZeroFlag, NegativeFlag
);

	logic [63:0] A, B;
	
	// 64-bit 3:1 MUX needed, outputs are A and B (ALUIn0, ALUIn1, respectively)
	
	
	// Then change ALU inputs to A and B
	ALU ALU (.A(ALUIn0), .B(ALUIn1), .cntrl(ALUOp), .result(ALURes), .negative(NegativeFlag), .zero(ZeroFlag), .overflow(), .carry_out());

	logic [18:0] CondAddr19;
	logic [25:0] BrAddr26;

	assign CondAddr19 = instruction[23:5];
	assign BrAddr26 = instruction[25:0];

	logic [63:0] BrAddr64, CondAddr64;

	assign BrAddr64 = {{38{BrAddr26[25]}}, BrAddr26};
	assign CondAddr64 = {{45{CondAddr19[18]}}, CondAddr19};

	logic [63:0] BrLoc_unshifted;

	n_bit_2to1 #(.BITS(64)) UncondMux (.data_line1(BrAddr64), .data_line0(CondAddr64), .s(UncondBr), .mux_out(BrLoc_unshifted));

	logic BrLoc_not_pcrel;
	assign BrLoc_not_pcrel = {BrLoc_unshifted[61:0], 2'b00}; //New shift (without RTL version)
	
	
	sixtyfourbit_fulladder BPCadd (.A(BrLoc_not_pcrel), .B(CurrPC), .Cin(1'b0), .S(BrLoc)); // Adds current PC to Br

endmodule 