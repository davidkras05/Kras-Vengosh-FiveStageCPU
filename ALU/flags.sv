`timescale 1ns/10ps

//DELAYS:
// - zero: 200 ps
// - negative: 0 ps
// - overflow: 50 ps
// - carryout: 0 ps

module flags (
	input logic[63:0] results,
	input logic[1:0] overflow_in,
	output logic negative, zero, overflow, carryout
);
	
	//ZERO CHECK

	parameter delay = 0;
	
	logic[63:0] zero_not;
	logic[15:0] zero_not2;
	logic[3:0] zero_not3;
	
	genvar i, j, k;
	
	//Layer 1
	generate
		for (i = 0; i<64; i++) begin: zero_check
			not #(delay) (zero_not[i], results[i]);
		end
	endgenerate
	
	//Layer 2
	generate
		for (j = 0; j<64; j += 4) begin: zero_checklayer2
			and #(delay) (zero_not2[j/4], zero_not[j], zero_not[j+1], zero_not[j+2], zero_not[j+3]);
		end
	endgenerate
	
	//Layer 3
	generate
		for (k = 0; k<16; k += 4) begin: zero_checklayer3
			and #(delay) (zero_not3[k/4], zero_not2[k], zero_not2[k+1], zero_not2[k+2], zero_not2[k+3]);
		end
	endgenerate
	
	//Final Layer
	and #(delay) (zero, zero_not3[0], zero_not3[1], zero_not3[2], zero_not3[3]);
	
	//TOTAL DELAY FOR ZERO FLAG: 200 ps
	
	//Negative check
	assign negative = results[63];
	
	//TOTAL DELAY FOR NEGATIVE: 0 ps
	
	//Overflow check
	xor #(delay) (overflow, overflow_in[0], overflow_in[1]);
	
	//TOTAL DELAY FOR OVERFLOW: 50 ps
	
	//Carryout check
	assign carryout = overflow_in[1];
	
	//TOTAL DELAY FOR CARRYOUT CHECK: 0 ps
	
endmodule
