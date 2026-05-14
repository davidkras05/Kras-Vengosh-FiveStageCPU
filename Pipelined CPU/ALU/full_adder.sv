`timescale 1ps/1ps

// DELAYS:
//  - S: 50 ps
//  - Cout: 100 ps
module full_adder(
	input logic A, B, Cin,
	output logic Cout, S
);

	parameter delay = 50;


	xor #(delay) (S, A, B, Cin); // sum is A ^ B ^ Cin


	logic Cout_term_1, Cout_term_2; // Cout = AB + Cin(A + B), term_1 is AB, term_2 is (A + B)
	and #(delay) (Cout_term_1, A, B); // Make AB
	or #(delay) (Cout_term_2, A, B); // Make A + B

	logic Cin_buf; 
	buf #(delay) (Cin_buf, Cin); // Cin needs to be buffered again since it is multiplying (A + B), which is now delayed

	logic Cout_term_3; // term_3 is Cin(A + B)
	and #(delay) (Cout_term_3, Cin_buf, Cout_term_2);

	logic Cout_term_1_buf; // now to match the number of gates term_3 used, must buffer term_1 one more time
	buf #(delay) (Cout_term_1_buf, Cout_term_1);

	or #(delay) (Cout, Cout_term_1_buf, Cout_term_3); // Cout = AB + Cin(A + B)

endmodule

