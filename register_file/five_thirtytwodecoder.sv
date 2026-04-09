module two_fourdecoder(
	input logic A, B, En, //B is LSB
	output logic[3:0] y
);

	logic nA, nB;
	
	not (nA, A);
	not (nB, B);
	
	and (y[0], nA, nB, En);
	and (y[1], nA, B, En);
	and (y[2], A, nB, En);
	and (y[3], A, B, En);
	
endmodule

module three_eightdecoder(
	input logic A, B, C, En, //C is LSB
	output logic[7:0] y
);

	logic nA, nB, nC;
	
	not (nA, A);
	not (nB, B);
	not (nC, C);
	
	and (y[0], En, nA, nB, nC);
	and (y[1], En, nA, nB, C);
	and (y[2], En, nA, B, nC);
	and (y[3], En, nA, B, C);
	and (y[4], En, A, nB, nC);
	and (y[5], En, A, nB, C);
	and (y[6], En, A, B, nC);
	and (y[7], En, A, B, C);

endmodule

module five_thirtytwodecoder(
	input logic A, B, C, D, E, En,
	output logic[31:0] y

);
	logic[3:0] subEn;

	two_fourdecoder twofour (
		.A(A),
		.B(B),
		.En(En),
		.y(subEn)
		
	);
	
	// I assigned the outputs from the 3:8s to the overall 5:32 using splicing. here is the deal though,
	// I am not sure if that is allowed/considered RTL however I don't know any other way to do it besides
	// straight up making each individual decoder and wiring everything manually which would be extremely
	// annoying. I don't think it would be a problem since its not creating hardware/multipliers its
	// literally just wiring but still might want to check just in case so no suprises.
	
	// Also, I coded this kinda stupidly and the inputs/enables (in the 5:32 and sub-decoders) 
	// could be vectors. Might want to change them to be vectors although in the grand scheme of things, 
	// it doesn't matter. not sure if it will affect performance tho.
	
	genvar i;
	
	generate
		for (i = 0; i<4; i++) begin: three_eight
			three_eightdecoder first (
				.A(C),
				.B(D),
				.C(E),
				.En(subEn[i]),
				
				.y(y[8*i +: 8])
			); 
		end
	endgenerate
endmodule
