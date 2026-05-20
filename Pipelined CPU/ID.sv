module ID (
	input logic clk, reset, Reg2Loc, ALUSrc, RegWrite, IsBL, isDType,
	input logic[63:0] WriteBck, PCp4, //From writeback
	input logic[31:0] instruction,
	
	output logic[63:0] Da, Db, ALUInput,
	output logic[4:0] Rd, Rm, Rn
);
	
	assign Rm = instruction[20:16];
	assign Rd = instruction[4:0];
	assign Rn = instruction[9:5];
	
	logic[4:0] splitout, Aw_in;
	
	n_bit_2to1 #(.BITS(5)) ldurstur_mux (.data_line1(Rd), .data_line0(Rm), .s(Reg2Loc), .mux_out(splitout));
	
	n_bit_2to1 #(.BITS(5)) aw_mux (.data_line1(5'b11110), .data_line0(Rd), .s(IsBL), .mux_out(Aw_in));
	
	logic [63:0] Dw_in;
	n_bit_2to1 #(.BITS(64)) dw_mux (.data_line1(PCp4), .data_line0(WriteBck), .s(IsBL), .mux_out(Dw_in));
	
	// Made changes here. WriteRegister is the register that's being written into, which is always Rd
	// Additionally, WriteData is the actual data, which comes from WB. Also, the input WriteBck had only 5 bits when it needed 64.
	// Finally, DataWrite was redundant to WriteBck
	regfile registerFile (.ReadData1(Da), .ReadData2(Db), .WriteData(Dw_in), 
								.ReadRegister1(Rn), .ReadRegister2(splitout), .WriteRegister(Aw_in), 
								.RegWrite(RegWrite),
								.clk(clk), .reset(reset));
								
	logic[11:0] Immediate;
	assign Immediate = instruction[21:10];
	
	logic [8:0] DT_address;
	
	assign DT_address = instruction[20:12];
	
	logic[63:0] Immediate64, DT_address64, shift;
	
	assign Immediate64 = {{52{1'b0}}, Immediate}; //Zero extend the immediate to 64 bits
	
	assign DT_address64 = {{55{DT_address[8]}}, DT_address}; //Sign extend the DT addr to 64 bits
	
	n_bit_2to1 #(.BITS(64)) ImmChoose (.data_line1(DT_address64), .data_line0(Immediate64), .s(isDType), .mux_out(shift));
	
	n_bit_2to1 #(.BITS(64)) ALUchoose (.data_line1(shift), .data_line0(Db), .s(ALUSrc), .mux_out(ALUInput));
	
endmodule
								
	

	
