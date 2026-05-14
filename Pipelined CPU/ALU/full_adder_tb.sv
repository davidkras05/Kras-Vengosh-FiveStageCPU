`timescale 1ns/1ps

module full_adder_tb();

	logic [1:0] in; // group for easier testbenching
	logic Cin, Cout, S;
	
	full_adder dut(.A(in[0]), .B(in[1]), .Cin, .Cout, .S);
	
	integer i;
	initial begin
		// creates all possible combinations of A, B, Cin, SUB
		for(i=0; i < 2**3; i++) begin
			{in[0], in[1], Cin} = i;  #500;
		end //for loop
		
	end //initial
	
endmodule
