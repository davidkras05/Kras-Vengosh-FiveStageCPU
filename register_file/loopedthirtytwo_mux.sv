module loopedthirtytwo_mux(
	input logic [31:0][63:0] data_lines,
	input logic [4:0] s,
	output logic [63:0] mux_out
);

genvar i;

generate
	for (int i = 0; i < 64; i++) begin:
		thirtytwo_1_mux (.in(data_lines[31:0][i]), .s(s), .y(mux_out[i]))
	end
endgenerate

endmodule 
