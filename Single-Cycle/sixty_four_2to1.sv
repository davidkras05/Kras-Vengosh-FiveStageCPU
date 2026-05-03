module sixty_four_2to1 (
	input logic [63:0] data_line1,
	input logic[63:0] data_line0,
	input logic s,
	output logic [63:0] mux_out
);
	
	genvar i;
	
	generate
		for (i = 0; i<64; i++) begin: sixty_four_2to1_loop
			two_onemux muxlooping (.in({data_line1[i], data_line0[i]}), .s(s), .y(mux_out[i]));
		end
	endgenerate
endmodule

	