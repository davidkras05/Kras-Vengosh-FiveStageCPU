`timescale 1ns/10ps

module regfile(
	output logic [63:0] ReadData1, ReadData2, 
	input logic [63:0] WriteData,
	input logic [4:0] ReadRegister1, ReadRegister2,
	input logic [4:0] WriteRegister,
	input logic RegWrite, clk, reset
	
	
);

	logic [31:0] dec_out;

	five_thirtytwodecoder dec (.A(WriteRegister[4]),
										.B(WriteRegister[3]),
										.C(WriteRegister[2]),
										.D(WriteRegister[1]),
										.E(WriteRegister[0]),
										.En(RegWrite),
										.y(dec_out));
			
	logic [31:0][63:0] reg_outs;
			
	genvar i;

	generate
		for (i = 0; i<31; i++) begin: register_loop
			register registers (.clk(clk), .write(WriteData), .reset(reset), .En(dec_out[i]), .q(reg_outs[i]));
		end
	endgenerate
	
	register zero_reg (.clk(clk), .write(64'b0), .reset(reset), .En(dec_out[31]), .q(reg_outs[31]));
	
	//Transposing columns here due to looping errors with rows initially. have to transpose after
	// wiring through registers.
	
	logic [63:0][31:0] reg_outs_transpose;
	
	genvar j, k;
	
	generate
		for (j = 0; j < 32; j++) begin: transpose_r
			for (k = 0; k < 64; k++) begin: transpose_c
				assign reg_outs_transpose[k][j] = reg_outs[j][k];
			end
		end
	endgenerate

	
	loopedthirtytwo_mux mux1 (.data_lines(reg_outs_transpose), .s(ReadRegister1), .mux_out(ReadData1));
	loopedthirtytwo_mux mux2 (.data_lines(reg_outs_transpose), .s(ReadRegister2), .mux_out(ReadData2));
									
endmodule 


