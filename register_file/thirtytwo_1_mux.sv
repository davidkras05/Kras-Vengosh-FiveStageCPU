`timescale 1ns/10ps

module two_onemux(
	input logic [1:0] in,
	input logic s,
	output logic y
);
	
	parameter delay = 0;
	
	logic not_s, A_line, B_line;
	
	not #(delay) (not_s, s); 
	
	logic bit_0_in_buf;
	
	buf #(delay) (bit_0_in_buf, in[0]);
	
	and #(delay) (A_line, bit_0_in_buf, not_s); // 50 ps delay
	and #(delay) (B_line, in[1], s); // 0 ps delay
	
	logic B_line_buf; 
	
	buf #(delay) (B_line_buf, B_line); // 50 ps delay

	or #(delay) (y, A_line, B_line_buf); // 100 ps delay

endmodule

module four_onemux(
	input logic [3:0] in,
	input logic [1:0] s,
	output logic y
);
	
	logic [1:0] first_layer_out;
	
	two_onemux first (.in(in[1:0]), .s(s[0]), .y(first_layer_out[0])); 
	two_onemux second (.in(in[3:2]), .s(s[0]), .y(first_layer_out[1]));
	
	two_onemux sec_layer (.in(first_layer_out), .s(s[1]), .y(y));

endmodule

module eight_onemux(
	input logic [7:0] in,
	input logic [2:0] s,
	output logic y
);

	logic [1:0] first_layer_out;
	
	four_onemux first (.in(in[3:0]), .s(s[1:0]), .y(first_layer_out[0]));
	four_onemux second (.in(in[7:4]), .s(s[1:0]), .y(first_layer_out[1]));
	
	two_onemux sec_layer (.in(first_layer_out), .s(s[2]), .y(y));

endmodule

module sixteen_onemux(
	input logic [15:0] in,
	input logic [3:0] s,
	output logic y
);

	logic [1:0] first_layer_out;
	
	eight_onemux first (.in(in[7:0]), .s(s[2:0]), .y(first_layer_out[0]));
	eight_onemux second (.in(in[15:8]), .s(s[2:0]), .y(first_layer_out[1]));
	
	two_onemux sec_layer (.in(first_layer_out), .s(s[3]), .y(y));

endmodule

module thirtytwo_1_mux(
	input logic [31:0] in,
	input logic [4:0] s,
	output logic y
);

	logic [3:0] first_layer_out;
	
	eight_onemux first (.in(in[7:0]), .s(s[2:0]), .y(first_layer_out[0]));
	eight_onemux second (.in(in[15:8]), .s(s[2:0]), .y(first_layer_out[1]));
	eight_onemux third (.in(in[23:16]), .s(s[2:0]), .y(first_layer_out[2]));
	eight_onemux fourth (.in(in[31:24]), .s(s[2:0]), .y(first_layer_out[3]));
	
	
	four_onemux sec_layer (.in(first_layer_out), .s(s[4:3]), .y(y));

endmodule
