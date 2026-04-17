`timescale 1ps/1ps

module ALU (
	input logic[63:0] A, B,
	input logic[2:0] cntrl,
	output logic[63:0] result,
	output logic negative, zero, overflow, carry_out
);

	//Head bit ALU
	
	logic[63:0] Couts;
	
	bitsliceALU head (.A(A[0]), .B(B[0]), .Cin(cntrl[0]), .cntrl(cntrl), .result(result[0]), .Cout(Couts[0]));
	
	genvar i;
	
	generate
		for (i = 1; i<64; i++) begin: body_ALUs
			logic a_buf, b_buf, cntrl_buf;
			buf #(100) (a_buf, A);
			buf #(100) (b_buf, B);
			buf #(100) (cntrl_buf, cntrl);
			
			bitsliceALU body (.A(A[i]), .B(B[i]), .Cin(Couts[i-1]), .cntrl(cntrl), .result(result[i]), .Cout(Couts[i]));
		end
	endgenerate
	
	
	flags flag (.results(result), .overflow_in(Couts[63:62]), .negative(negative), .zero(zero), .overflow(overflow), .carryout(carry_out));

endmodule
	