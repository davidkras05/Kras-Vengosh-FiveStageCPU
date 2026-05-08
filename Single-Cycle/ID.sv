module ID (
	input logic clk, reset, Reg2Loc, ALUSrc, RegWrite, IsBL,
	input logic[63:0] WriteBck, PCp4, //From writeback
	input logic[31:0] instruction,
	output logic[63:0] Da, Db, ALUInput
);

	logic[4:0] Rd, Rm, Rn;
	
	assign Rm = instruction[20:16];
	assign Rd = instruction[4:0];
	assign Rn = instruction[9:5];
	
	logic[4:0] splitout, Aw_in;
	
	n_bit_2to1 ldurstur_mux #(.BITS(5))(.data_line1(Rd), .data_line0(Rm), .s(Reg2Loc), .mux_out(splitout));
	
	n_bit_2to1 aw_mux #(.BITS(5))(.data_line1(5'b11110), .data_line0(Rd), .s(IsBL), .mux_out(Aw_in));
	
	logic [63:0] Dw_in;
	n_bit_2to1 aw_mux #(.BITS(64))(.data_line1(PCp4), .data_line0(WriteBck), .s(IsBL), .mux_out(Dw_in));
	
	// Made changes here. WriteRegister is the register that's being written into, which is always Rd
	// Additionally, WriteData is the actual data, which comes from WB. Also, the input WriteBck had only 5 bits when it needed 64.
	// Finally, DataWrite was redundant to WriteBck
	regfile registerFile (.ReadData1(Da), .ReadData2(Db), .WriteData(Dw_in), 
								.ReadRegister1(Rn), .ReadRegister2(splitout), .WriteRegister(Aw_in), 
								.RegWrite(RegWrite), .clk(clk), .reset(reset));
								
	logic[11:0] Immediate;
	
	assign Immediate = instruction[21:10];
	
	logic[63:0] Immediate64;
	
	assign Immediate64 = {{52{Immediate[11]}}, Immediate}; //Sign extend the immediate to 64 bits
	
	n_bit_2to1 ALUchoose #(.BITS(64))(.data_line1(Immediate64), .data_line0(Db), .s(ALUSrc), .mux_out(ALUInput));
	
endmodule
								
	

	
