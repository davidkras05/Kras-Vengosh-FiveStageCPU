module four_onemux(
	input logic[3:0] in,
	input logic[1:0] s,
	output logic z 
);

	logic[1:0] ns;
	logic[3:0] a;
	
	not (ns[0], s[0]); 
	not(ns[1], s[1]);  
	
	// need seperate outputs on each and then a bigass or gate that ors everything together.
	and (a[0], in[0], ns[0], ns[1]);
	and (a[1], in[1], s[0], ns[1]);
	and (a[2], in[2], ns[0], s[1]);
	and (a[3], in[3], s[0], s[1]);
	
	or (z, a[0], a[1], a[2], a[3]);
	
endmodule

module two_onemux(
	input logic[1:0] in,
	input logic s,
	output logic z 
);
	logic ns;
	logic[1:0] a;
	
	not(ns, s);
	
	//See comment above on the four_onemux. same issue here
	and (a[0], in[0], ns);
	and (a[1], in[1], s);
	
	or (z, a[0], a[1]);
	
endmodule

module sixteen_onemux(
	input logic[15:0] in,
	input logic[3:0] s,
	output logic z
);
	logic[3:0] firstLevel;
	
	//Creates the first level of the 16:1 mux
	genvar i;
	
	generate
		for (i = 0; i<4; i++) begin: mux_loop
			four_onemux first (.in(in[4*i +: 4]), .s(s[1:0]), .z(firstLevel[i]));
		end
	endgenerate
	
	// Creates the second level of the 16:1 mux, the 4 parallel 4:1s are going into a final 4:1 for a
	// total 16:1
	
	four_onemux second (.in(firstLevel), .s(s[3:2]), .z(z));

endmodule

module thirtytwo_1_mux(
	input logic[31:0] in,
	input logic[4:0] s,
	output logic z
);
	logic[1:0] firstLevel;
	
	//This is the full 32:1 mux by wiring two 16:1s to to a 2:1
	
	//First level
	genvar i;
	
	generate
		for (i = 0; i<2; i++) begin: mux_loop
			sixteen_onemux first (.in(in[16*i +: 16]), .s(s[3:0]), .z(firstLevel[i]));
		end
	endgenerate
	
	//Second level
	
	two_onemux second (.in(firstLevel), .s(s[4]), .z(z));
	
endmodule
	