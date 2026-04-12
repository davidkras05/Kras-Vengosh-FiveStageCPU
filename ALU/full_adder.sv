`timescale 1ns/10ps
module full_adder(
	input logic A, B, Cin, SUB;
	output logic Cout, S;
);

	parameter delay = 50; // total delay for full adder is 150 ps

	logic B_add_sub;
	xor #(delay) (B_add_sub, B, SUB); // Take into account the possibility of subtraction


	logic A_buf, Cin_buf;
	buf #(delay) (A_buf, A); // since B went through a gate, A must be buffered to maintain timing
	buf #(delay) (Cin_buf, Cin); // same with Cin


	xor #(delay) (S, A, B_add_sub, Cin); // sum is A ^ B ^ Cin


	logic Cout_term_1, Cout_term2; // Cout = AB + Cin(A + B), term_1 is AB, term_2 is (A + B)
	and #(delay) (Cout_term1, A_buf, B_add_sub); // Make AB
	or #(delay) (Cout_term2, A_buf, B_add_sub); // Make A + B

	logic Cin_buf_2; 
	buf #(delay) (Cin_buf_2, Cin_buf); // Cin needs to be buffered again since it is multiplying (A + B), which is now delayed

	logic Cout_term_3; // term_3 is Cin(A + B)
	and #(delay) (Cout_term_3, Cin_buf_2, Cout_term_2);

	logic Cout_term_1_buf; // now to match the number of gates term_3 used, must buffer term_1 one more time
	buf #(delay) (Cout_term_1_buf, Cout_term_1);

	or #(delay) (Cout, Cout_term_1_buf, Cout_term_3); // Cout = AB + Cin(A + B)

endmodule

module full_adder_tb();

	logic A, B, Cin, sum, Cout;
	
	fullAdder dut(A, B, Cin, sum, Cout);
	
	integer i;
	initial begin
		// creates all possible combinations of A, B, and Cin
		for(i=0; i < 2**3; i++) begin
			{A, B, Cin} = i;  #10;
		end //for loop
		
	end //initial
	
endmodule


