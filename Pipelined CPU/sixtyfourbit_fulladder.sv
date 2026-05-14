module sixtyfourbit_fulladder(
	input logic[63:0] A, B,
	input logic Cin,
	output logic[63:0] S
);
	
	logic[63:0] carry_out_internal;
	
	full_adder head (.A(A[0]), .B(B[0]), .Cin(1'b0), .Cout(carry_out_internal[0]), .S(S[0]));
	
	genvar i;
	
	generate
		for (i=1; i<64; i++) begin: fulladder_loop
			full_adder body (.A(A[i]), .B(B[i]), .Cin(carry_out_internal[i-1]), .Cout(carry_out_internal[i]), .S(S[i]));
		end
	endgenerate
endmodule
