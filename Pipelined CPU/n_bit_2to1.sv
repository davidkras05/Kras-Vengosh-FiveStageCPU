module n_bit_2to1 #(parameter BITS = 64) (
	input logic [BITS-1:0] data_line1,
	input logic[BITS-1:0] data_line0,
	input logic s,
	output logic [BITS-1:0] mux_out
);
	
	genvar i;
	
	generate
		for (i = 0; i<BITS; i++) begin: n_bit_2to1_loop
			two_onemux muxlooping (.in({data_line1[i], data_line0[i]}), .s(s), .y(mux_out[i]));
		end
	endgenerate
endmodule

	