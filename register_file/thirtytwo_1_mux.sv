`timescale 1ns/10ps

module two_onemux(
	input logic [1:0] in,
	input logic s,
	output logic y
);
	
	parameter delay = 50;
	
	logic not_s, A_line, B_line;
	
	not #(delay) (not_s, s);
	
	and #(delay) (A_line, in[0], not_s);
	and #(delay) (B_line, in[1], s);
	
	logic B_line_buf;
	
	buf #(delay) (B_line_buf, B_line);

	or #(delay) (y, A_line, B_line_buf);

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

	logic [1:0] first_layer_out;
	
	sixteen_onemux first (.in(in[15:0]), .s(s[3:0]), .y(first_layer_out[0]));
	sixteen_onemux second (.in(in[31:16]), .s(s[3:0]), .y(first_layer_out[1]));
	
	two_onemux sec_layer (.in(first_layer_out), .s(s[4]), .y(y));

endmodule
