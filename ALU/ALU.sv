module ALU (
	input logic[63:0] A, B,
	input logic[2:0] cntrl,
	output logic[63:0] result,
	output logic negative, zero, overflow, carryout
);

	//Head bit ALU
	
	logic[63:0] Couts;
	
	bitsliceALU head (.A(A[0]), .(B[0]), .cntrl(cntrl), .Cin(cntrl[0]), .result(result[0]), .Cout(Couts[0]));
	
	genvar i;
	
	generate
		for (i = 1; i<64; i++) begin: body_ALUs
			bitsliceALU body (.A(A[i]), .B(B[i]), .cntrl(cntrl), .Cin(Cout[i-1]), .result(result[i]), .Cout(Couts[i]));
		end
	endgenerate
	
	
	flags flag (.results(result), .overflow_in(Couts[63:61]), .negative(negative), .zero(zero), .overflow(overflow), .carryout(carryout));

endmodule
	