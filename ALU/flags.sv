`timescale 1ns/10ps

module flags (
	input logic[63:0] results,
	output logic overflow, negative, zero
);

	parameter delay = 0;
	
	logic[63:0] zero_not;
	logic[15:0] zero_not2;
	logic[3:0] zero_not3;
	
	genvar i, j, k, f;
	
	//Layer 1
	generate
		for (i = 0; i<63; i++) begin: zero_check
			not #(delay) (zero_not[i], results[i]);
		end
	endgenerate
	
	//Layer 2
	generate
		for (j = 0; j<16; j += 4) begin: zero_checklayer2
			and #(delay) (zero_not2[j], zero_not[j], zero_not[j+1], zero_not[j+2], zero_not[j+3]);
		end
	endgenerate
	
	//Layer 3
	generate
		for (k = 0; k<16; j += 4) begin: zero_checklayer3
			and #(delay) (zero_not3[k], zero_not2[k], zero_not2[k+1], zero_not2[k+2], zero_not2[k+3]);
		end
	endgenerate
	
	//Final Layer
	generate
		for (f = 0; f<3; 