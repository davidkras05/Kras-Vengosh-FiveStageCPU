module register_top(

	input logic write_en, reset, clk
	input logic [4:0] reg_id, read_reg_0, read_reg_1,
	input logic [63:0] write,
	output logic [31:0] regout_0, regout_1
	
);

logic [31:0] dec_out;

five_thirtytwodecoder dec (.A(reg_id[4]),
                           .B(reg_id[3]),
									.C(reg_id[2]),
									.D(reg_id[1]),
									.E(reg_id[0]),
									.En(write_en),
									.y(dec_out))
			
logic [31:0][63:0] reg_outs;
			
genvar i;

generate
	for (i = 0; i<31; i++) begin:
		register registers (.clk(clk), .write(write), .reset(reset), .q(reg_outs[i]))
	end
endgenerate

loopedthirtytwo_mux mux0 (.data_lines(reg_outs), .s(read_reg_0), .mux_out(regout_0))
loopedthirtytwo_mux mux1 (.data_lines(reg_outs), .s(read_reg_1), .mux_out(regout_1))
									
endmodule 


