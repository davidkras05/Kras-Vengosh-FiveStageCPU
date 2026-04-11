// 1:2 decoder with enable
`timescale 1ns/10ps

module one_twodecoder(
	input logic A, En,
	output logic [1:0] y
);

	logic nA, y_1_intermediate;
	
	parameter delay = 50;
	
	not #(delay) (nA, A);
	
	and #(delay) (y[0], nA, En);
	
	and #(delay) (y_1_intermediate, A, En);
	
	buf (y[1], y_1_intermediate);
	
	

endmodule

// 2:4 decoder with enable, built from three 1:2 decoder above
module two_fourdecoder(
	input logic A, B, En, // B is LSB
	output logic [3:0] y
);
	logic[1:0] onetwo_out;
	
	parameter delay = 50;
	
	one_twodecoder en_dec (.A(B), .En(En), .y(onetwo_out));
	
	logic first_en, second_en;
	
	and #(delay) (first_en, onetwo_out[0], En);
	and #(delay) (second_en, onetwo_out[1], En);

	one_twodecoder first (.A(A), .En(first_en), .y(y[1:0]));
	one_twodecoder second (.A(A), .En(second_en), .y(y[3:2]));
	
endmodule


// 3:8 decoder with enable, built from two 2:4 decoders above and a 1:2 decoder
module three_eightdecoder(
	input logic A, B, C, En, // C is LSB
	output logic [7:0] y
);
	logic[1:0] onetwo_out;
	
	one_twodecoder en_dec (.A(C), .En(En), .y(onetwo_out));
	
	logic first_en, second_en;
	
	parameter delay = 50;
	
	and #(delay) (first_en, onetwo_out[0], En);
	and #(delay) (second_en, onetwo_out[1], En);
	
	two_fourdecoder first (.A(A), .B(B), .En(first_en), .y(y[3:0]));
	two_fourdecoder second (.A(A), .B(B), .En(second_en), .y(y[7:4]));
	
endmodule

// 4:16 decoder with enable, built from two 3:8 decoders above and a 1:2 decoder
module four_sixteendecoder(
	input logic A, B, C, D, En, // D is LSB
	output logic [15:0] y
);

	logic[1:0] onetwo_out;
	
	one_twodecoder en_dec (.A(D), .En(En), .y(onetwo_out));
	
	logic first_en, second_en;
	
	parameter delay = 50;
	
	and #(delay) (first_en, onetwo_out[0], En);
	and #(delay) (second_en, onetwo_out[1], En);
	
	three_eightdecoder first (.A(A), .B(B), .C(C), .En(first_en), .y(y[7:0]));
	three_eightdecoder second (.A(A), .B(B), .C(C), .En(second_en), .y(y[15:8]));
	
endmodule

// 5:32 decoder with enable, built from two 4:16 decoders above and a 1:2 decoder
module five_thirtytwodecoder(
	input logic A, B, C, D, E, En, // E is LSB
	output logic [31:0] y
);

	logic[1:0] onetwo_out;
	
	one_twodecoder en_dec (.A(E), .En(En), .y(onetwo_out));
	
	logic first_en, second_en;
	
	parameter delay = 50;
	
	and #(delay) (first_en, onetwo_out[0], En);
	and #(delay) (second_en, onetwo_out[1], En);
	
	four_sixteendecoder first (.A(A), .B(B), .C(C), .D(D), .En(first_en), .y(y[15:0]));
	four_sixteendecoder second (.A(A), .B(B), .C(C), .D(D), .En(second_en), .y(y[31:16]));

endmodule
