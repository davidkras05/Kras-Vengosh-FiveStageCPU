// 1:2 decoder with enable
`timescale 1ps/1ps

module one_twodecoder( //100ps DELAY
	input logic A, En,
	output logic [1:0] y
);

	logic nA, y_1_intermediate, En_y0_buf;
	
	parameter delay = 50;
	
	not #(delay) (nA, A); //nA is delayed 50ps
	
	buf #(delay) (En_y0_buf, En); //En delayed 50ps
	
	and #(delay) (y[0], nA, En_y0_buf); //y[0] delayed 100ps (delay from nA and En 50ps and the AND 50ps)
	
	and #(delay) (y_1_intermediate, A, En);
	
	buf #(delay) (y[1], y_1_intermediate); //y[1] delayed 100ps (delay from the AND gate +50ps delay from the buffer 50ps)
	
	//Output bits y from 1:2 are delayed by 100ps

endmodule

// 2:4 decoder with enable, built from three 1:2 decoder above
module two_fourdecoder( //250ps DELAY
	input logic A, B, En, // B is LSB
	output logic [3:0] y
);
	logic[1:0] onetwo_out;
	
	parameter delay = 50;
	
	one_twodecoder en_dec (.A(A), .En(En), .y(onetwo_out));
	
	logic B_buf;

	buf #(150) (B_buf, B);
	
	logic first_en, second_en;
	
	and #(delay) (first_en, onetwo_out[0], En);
	and #(delay) (second_en, onetwo_out[1], En);

	one_twodecoder first (.A(B_buf), .En(first_en), .y(y[1:0]));
	one_twodecoder second (.A(B_buf), .En(second_en), .y(y[3:2]));
	
endmodule


// 3:8 decoder with enable, built from two 2:4 decoders above and a 1:2 decoder
module three_eightdecoder( //400ps DELAY
	input logic A, B, C, En, // C is LSB
	output logic [7:0] y
);
	logic[1:0] onetwo_out;
	
	one_twodecoder en_dec (.A(A), .En(En), .y(onetwo_out));
	
	logic B_buf, C_buf;
	
	buf #(150) (B_buf, B);
	buf #(150) (C_buf, C);
	
	logic first_en, second_en;
	
	parameter delay = 50;
	
	and #(delay) (first_en, onetwo_out[0], En);
	and #(delay) (second_en, onetwo_out[1], En);
	
	two_fourdecoder first (.A(B_buf), .B(C_buf), .En(first_en), .y(y[3:0]));
	two_fourdecoder second (.A(B_buf), .B(C_buf), .En(second_en), .y(y[7:4]));
	
endmodule

// 4:16 decoder with enable, built from two 3:8 decoders above and a 1:2 decoder
module four_sixteendecoder( //550ps DELAY
	input logic A, B, C, D, En, // D is LSB
	output logic [15:0] y
);

	logic[1:0] onetwo_out;
	
	one_twodecoder en_dec (.A(A), .En(En), .y(onetwo_out));
	
	logic En_buf;
	
	buf #(0) (En_buf, En);
	
	logic first_en, second_en;
	
	parameter delay = 0;
	
	and #(delay) (first_en, onetwo_out[0], En);
	and #(delay) (second_en, onetwo_out[1], En);
	
	three_eightdecoder first (.A(B), .B(C), .C(D), .En(first_en), .y(y[7:0]));
	three_eightdecoder second (.A(B), .B(C), .C(D), .En(second_en), .y(y[15:8]));
	
endmodule

// 5:32 decoder with enable, built from two 4:16 decoders above and a 1:2 decoder
module five_thirtytwodecoder( // 700ps DELAY
	input logic A, B, C, D, E, En, // E is LSB
	output logic [31:0] y
);

	logic[1:0] onetwo_out;
	
	one_twodecoder en_dec (.A(A), .En(En), .y(onetwo_out));
	
	logic B_buf, C_buf, D_buf, E_buf;
	
	buf #(150) (B_buf, B);
	buf #(150) (C_buf, C);
	buf #(150) (D_buf, D);
	buf #(150) (E_buf, E);
	
	logic first_en, second_en;
	
	parameter delay = 50;
	
	and #(delay) (first_en, onetwo_out[0], En); //first_en delay: 50ps
	and #(delay) (second_en, onetwo_out[1], En); //Second_en delay: 50ps
	
	four_sixteendecoder first (.A(B_buf), .B(C_buf), .C(D_buf), .D(E_buf), .En(first_en), .y(y[15:0]));
	four_sixteendecoder second (.A(B_buf), .B(C_buf), .C(D_buf), .D(E_buf), .En(second_en), .y(y[31:16]));

endmodule

//Test benching for debugging

//1:2 Decoder test bench. 200ps delays because of 100ps delay outputs
// Lets separate the tbs, no?
module one_two_tb;
	logic A, En;
	logic[1:0] y;
	
	one_twodecoder DUT (.A(A), .En(En), .y(y));
	
	initial begin
		
		$display("Testing Enable");
		A = 0; En = 0; #200;
		assert(y == 2'b00);
		
		A = 1; En = 0; #200;
		assert(y == 2'b00);
		
		$display("Testing output Line 0");
		A = 0; En = 1; #200;
		assert(y == 2'b01);
		
		$display("Testing output Line 1");
		A = 1; En = 1; #200;
		assert(y == 2'b10);
		
		$stop;
	end
	
endmodule	

//5:32 decoder test bench. 800ps delays (extra room just in case)
module five_thirtytwo_tb;
	logic[4:0] input_test;
	logic En;
	logic [31:0] y;
	
	five_thirtytwodecoder DUT (.A(input_test[4]), .B(input_test[3]), .C(input_test[2]), .D(input_test[1]), .E(input_test[0]), .En(En), .y(y));
	
	initial begin
		
		$display("Testing all cases without enable (Should be all 0)");
		
		for (int i = 0; i < 32; i++) begin: first_testloop
			En = 0; input_test = i; #800;
			assert(y == 0) else $error("Test failed: Expected: %032b Got: %032b", 32'b0, y);
		end
			
		$display("Testing all cases with enable");
		
		for (int j = 0; j<32; j++) begin: second_testloop
			En = 1; input_test = j; #800;
			assert(y == (32'b1 << j)) else $error("Test failed: Expected %032b Got: %032b", (32'b1 << j), y);
		end
		
		$stop;
		
	end
	
endmodule

//3:8 decoder test bench. 800ps delays
module three_eight_tb;
	logic[2:0] input_test;
	logic En;
	logic[7:0] y;
	
	three_eightdecoder DUT (.A(input_test[2]), .B(input_test[1]), .C(input_test[0]), .En(En), .y(y));
	
	initial begin
		$display("Testing all cases without enable (Should be all 0)");
		
		for (int i = 0; i < 8; i++) begin: first_testloop
			En = 0; input_test = i; #800;
			assert(y == 0) else $error("Test failed: Expected: %08b Got: %08b", 8'b0, y);
		end
		
		
		$display("Testing all cases with enable");
		
		for (int j = 0; j<8; j++) begin: second_testloop
			En = 1; input_test = j; #800;
			assert(y == (8'b1 << j)) else $error("Test failed: Expected %08b Got: %08b", (8'b1 << j), y);
		end
		
		$stop;
	end
endmodule

//2:4 decoder test bench.
module two_four_tb;
	logic[1:0] input_test;
	logic En;
	logic[3:0] y;
	
	two_fourdecoder DUT (.A(input_test[1]), .B(input_test[0]), .En(En), .y(y));
	
	initial begin
		$display("Testing all cases without enable (Should be all 0)");
		
		for (int i = 0; i < 4; i++) begin: first_testloop
			En = 0; input_test = i; #800;
			assert(y == 0) else $error("Test failed: Expected: %04b Got: %04b", 4'b0, y);
		end
		
		
		$display("Testing all cases with enable");
		
		for (int j = 0; j < 4; j++) begin: second_testloop
			En = 1; input_test = j; #800;
			assert(y == (4'b1 << j)) else $error("Test failed: Expected %04b Got: %04b", (4'b1 << j), y);
		end
		
		$stop;
	end
endmodule	
			