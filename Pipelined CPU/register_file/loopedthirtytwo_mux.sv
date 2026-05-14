module loopedthirtytwo_mux(
	input logic [63:0][31:0] data_lines, //SWAPPED COLUMNS AND ROWS FOR PROPER COMPILATION IN THE LOOP
	input logic [4:0] s,
	output logic [63:0] mux_out
);

genvar i;

generate
	for (i = 0; i < 64; i++) begin: mux_loop
		thirtytwo_1_mux muxes (.in(data_lines[i][31:0]), .s(s), .y(mux_out[i])); 
	end
endgenerate

endmodule 
