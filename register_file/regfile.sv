module registerfile_top(

	input logic write_en, reset, clk,
	input logic [4:0] reg_id, read_reg_0, read_reg_1,
	input logic [63:0] write,
	output logic [63:0] regout_0, regout_1 //These were originally 32 bit vectors but I think they are supposed to be 64 since they are outputs of the registers
	
);

	logic [31:0] dec_out;

	five_thirtytwodecoder dec (.A(reg_id[4]),
										.B(reg_id[3]),
										.C(reg_id[2]),
										.D(reg_id[1]),
										.E(reg_id[0]),
										.En(write_en),
										.y(dec_out));
			
	logic [63:0][31:0] reg_outs; //Swapped rows and columns due to loopedthirtytwo_Mux changes
			
	genvar i;

	generate
		for (i = 0; i<31; i++) begin: register_loop
			register registers (.clk(clk), .write(write), .reset(reset), .q(reg_outs[i]));
		end
	endgenerate
	
	register zero_reg (.clk(clk), .write(64'b0), .reset(reset), .q(reg_outs[31]));
	
	//CHECK IF reg_outs WORK WITH NEW LOOPING/SWAPPED ROWS AND COLUMNS
	loopedthirtytwo_mux mux0 (.data_lines(reg_outs), .s(read_reg_0), .mux_out(regout_0));
	loopedthirtytwo_mux mux1 (.data_lines(reg_outs), .s(read_reg_1), .mux_out(regout_1));
									
endmodule 


