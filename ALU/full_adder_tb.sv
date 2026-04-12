module full_adder_tb();

	logic A, B, Cin, SUB, Cout, S;
	
	full_adder dut(.A, .B, .Cin, .SUB, .Cout, .S);
	
	integer i;
	initial begin
		// creates all possible combinations of A, B, Cin, SUB
		for(i=0; i < 2**4; i++) begin
			{A, B, Cin, SUM} = i;  #10;
		end //for loop
		
	end //initial
	
endmodule
