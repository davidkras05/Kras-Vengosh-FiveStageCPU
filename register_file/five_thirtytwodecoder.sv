// 1:2 decoder with enable
module one_twodecoder(
	input logic A, En
	output logic [1:0] y
);

	logic nA;
	not #50 (nA, A)
	
	and #50 (y[0], nA, En);
	and #50 (y[1], A, En);

endmodule

// 2:4 decoder with enable, built from three 1:2 decoder above
module two_fourdecoder(
	input logic A, B, En // B is LSB
	output logic [3:0] y
);
	logic onetwo_out;
	
	one_twodecoder en_dec (.A(B), .En(En), .y(onetwo_out));
	
	logic first_en, second_en;
	
	and #50 (first_en, onetwo_out[0], En);
	and #50 (second_en, onetwo_out[1], En);

	one_twodecoder first (.A(A), .En(first_en), .y(y[1:0]));
	one_twodecoder second (.A(A), .En(second_en), .y(y[3:2]));
	
endmodule


// 3:8 decoder with enable, built from two 2:4 decoders above and a 1:2 decoder
module three_eightdecoder(
	input logic A, B, C, En // C is LSB
	output logic [7:0] y
);
	logic onetwo_out;
	
	one_twodecoder en_dec (.A(C), .En(En), .y(onetwo_out));
	
	logic first_en, second_en;
	
	and #50 (first_en, onetwo_out[0], En);
	and #50 (second_en, onetwo_out[1], En);
	
	two_fourdecoder first (.A(A), .B(B), .En(first_en), .y(y[3:0]));
	two_fourdecoder second (.A(A), .B(B), .En(second_en), .y(y[7:4]));
	
endmodule

// 4:16 decoder with enable, built from two 3:8 decoders above and a 1:2 decoder
module four_sixteendecoder(
	input logic A, B, C, D, En // D is LSB
	output logic [15:0] y
);

	logic onetwo_out;
	
	one_twodecoder en_dec (.A(D), .En(En), .y(onetwo_out));
	
	logic first_en, second_en;
	
	and #50 (first_en, onetwo_out[0], En);
	and #50 (second_en, onetwo_out[1], En);
	
	three_eightdecoder first (.A(A), .B(B), .C(C), .En(first_en), .y(y[7:0]));
	three_eightdecoder second (.A(A), .B(B), .C(C), .En(second_en), .y(y[15:8]));
	
endmodule

// 5:32 decoder with enable, built from two 4:16 decoders above and a 1:2 decoder
module five_thirtytwodecoder(
	input logic A, B, C, D, E, En // E is LSB
	output logic [31:0]
);

	logic onetwo_out;
	
	one_twodecoder en_dec (.A(E), .En(En), .y(onetwo_out));
	
	logic first_en, second_en;
	
	and #50 (first_en, onetwo_out[0], En);
	and #50 (second_en, onetwo_out[1], En);
	
	four_sixteendecoder first (.A(A), .B(B), .C(C), .D(D) .En(first_en), .y(y[15:0]));
	four_sixteendecoder second (.A(A), .B(B), .C(C), .D(D) .En(seco,nd_en), .y(y[31:16]));

endmodule
	
	
	
//module two_fourdecoder(
//	input logic A, B, En, //B is LSB
//	output logic[3:0] y
//);
//
//	logic nA, nB;
//	
//	not #50 (nA, A);
//	not #50 (nB, B);
//	
//	and #50 (y[0], nA, nB, En);
//	and #50 (y[1], nA, B, En);
//	and #50 (y[2], A, nB, En);
//	and #50 (y[3], A, B, En);
//	
//endmodule

//module three_eightdecoder(
//	input logic A, B, C, En, //C is LSB
//	output logic[7:0] y
//);
//
//	logic nA, nB, nC;
//	
//	not #50 (nA, A);
//	not #50 (nB, B);
//	not #50 (nC, C);
//	
//	and #50 (y[0], En, nA, nB, nC);
//	and #50 (y[1], En, nA, nB, C);
//	and #50 (y[2], En, nA, B, nC);
//	and #50 (y[3], En, nA, B, C);
//	and #50 (y[4], En, A, nB, nC);
//	and #50 (y[5], En, A, nB, C);
//	and #50 (y[6], En, A, B, nC);
//	and #50 (y[7], En, A, B, C);
//
//endmodule

//module five_thirtytwodecoder(
//	input logic A, B, C, D, E, En,
//	output logic[31:0] y
//
//);
//	logic[3:0] subEn;
//
//	two_fourdecoder twofour (
//		.A(A),
//		.B(B),
//		.En(En),
//		.y(subEn)
//		
//	);
//	
//	// I assigned the outputs from the 3:8s to the overall 5:32 using splicing. here is the deal though,
//	// I am not sure if that is allowed/considered RTL however I don't know any other way to do it besides
//	// straight up making each individual decoder and wiring everything manually which would be extremely
//	// annoying. I don't think it would be a problem since its not creating hardware/multipliers its
//	// literally just wiring but still might want to check just in case so no suprises.
//	
//	// Also, I coded this kinda stupidly and the inputs/enables (in the 5:32 and sub-decoders) 
//	// could be vectors. Might want to change them to be vectors although in the grand scheme of things, 
//	// it doesn't matter. not sure if it will affect performance tho.
//	
//	genvar i;
//	
//	generate
//		for (i = 0; i<4; i++) begin: three_eight
//			three_eightdecoder first (
//				.A(C),
//				.B(D),
//				.C(E),
//				.En(subEn[i]),
//				
//				.y(y[8*i +: 8])
//			); 
//		end
//	endgenerate
//endmodule
