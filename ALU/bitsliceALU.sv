
`timescale 1ps/1ps

// ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110
module bitsliceALU(
	input logic A, B, Cin,
	input logic [2:0] cntrl,
	output logic result, Cout // for adding and subtracting, result is s, cout is cout
);

	parameter delay = 50;


	logic B_add_sub;
	xor #(delay) (B_add_sub, cntrl[0], B); //cntrl[0] is the LSB of the control input, a 1 means to subtract, a 0 means add

	logic A_buf; // A must be buffered for the full adder to match the timing of B now
	buf #(delay) (A_buf, A);

	logic S; // delayed by 50 ps
	full_adder f_a (.A, .B(B_add_sub), .Cin, .Cout, .S); // Cout has 100 ps delay


	logic and_res, or_res, xor_res;

	and #(delay) (and_res, A, B); // all delayed by 50 ps
	or #(delay) (or_res, A, B);
	xor #(delay) (xor_res, A, B);
	
	logic B_buf; // a clean signal for B must be buffered to match the timing of the rest of the signals to the mux
	buf #(delay) (B_buf, B);

	logic [7:0] mux_in;
	
	assign mux_in[0] = B;
	assign mux_in[2] = S;
	assign mux_in[3] = S;
	assign mux_in[4] = and_res;
	assign mux_in[5] = or_res;
	assign mux_in[6] = xor_res;
	
	
	eight_onemux selector (.in(mux_in), .s(cntrl), .y(result));


endmodule
