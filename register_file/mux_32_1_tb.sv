module mux_2_1_tb();

	logic [1:0] in;
	logic s, y;

	twoone_mux dut (.in, .s, .y);
	
	initial begin
	
		in = 2'b10;
		s = 1'b0; 
		#200;
		
		s = 1'b1;
		#200;
		
		$stop;
	end

endmodule

module mux_32_1_tb();

	logic [31:0] in;
	logic [4:0] s; 
	logic y;

	thirtytwo_1_mux dut (.in, .s, .y);
	
	initial begin
		
		$stop;
	end

endmodule 