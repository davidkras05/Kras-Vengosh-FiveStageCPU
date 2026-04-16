
`timescale 1ps/1ps
module mux_2_1_tb();

	logic [1:0] in;
	logic s, y;

	two_onemux dut (.in, .s, .y);
	
	initial begin
	
		in = 2'b10;
		s = 1'b0; 
		#200;
		
		s = 1'b1;
		#200;
		
		$stop;
	end

endmodule

module mux_4_1_tb();

	logic [3:0] in;
	logic [1:0] s;
	logic y;
	
	four_onemux dut (.in, .s, .y);
	
	initial begin
	
		// output should always be 1
		for (int i = 0; i < 4; i++) begin
			in = 4'b0;
			in[i] = 1'b1;
			s = i;
			#500;
		end
		
		// output should always be 0
		for (int i = 0; i < 4; i++) begin
			in = '1;
			in[i] = 1'b0;
			s = i;
			#500;
		end
		$stop;
	end

endmodule 

module mux_32_1_tb();

	logic [31:0] in;
	logic [4:0] s; 
	logic y;

	thirtytwo_1_mux dut (.in, .s, .y);
	
	initial begin
	
		// output should always be 1
		for (int i = 0; i < 32; i++) begin
			in = 32'b0;
			in[i] = 1'b1;
			s = i;
			#300;
		end
		
		// output should always be 0
		for (int i = 0; i < 32; i++) begin
			in = '1;
			in[i] = 1'b0;
			s = i;
			#300;
		end
		$stop;
	end

endmodule 