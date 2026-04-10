module regfile(
	output logic [63:0] ReadData1, ReadData2, //These were originally 32 bit vectors but I think they are supposed to be 64 since they are outputs of the registers
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
			
	logic [63:0][31:0] reg_outs; //Swapped rows and columns due to loopedthirtytwo_Mux changes
			
	genvar i;

	generate
		for (i = 0; i<31; i++) begin: register_loop
			register registers (.clk(clk), .write(WriteData), .reset(reset), .q(reg_outs[i]));
		end
	endgenerate
	
	register zero_reg (.clk(clk), .write(64'b0), .reset(reset), .q(reg_outs[31]));
	
	//CHECK IF reg_outs WORK WITH NEW LOOPING/SWAPPED ROWS AND COLUMNS
	loopedthirtytwo_mux mux1 (.data_lines(reg_outs), .s(ReadRegister1), .mux_out(ReadData1));
	loopedthirtytwo_mux mux2 (.data_lines(reg_outs), .s(ReadRegister2), .mux_out(ReadData2));
									
endmodule 


