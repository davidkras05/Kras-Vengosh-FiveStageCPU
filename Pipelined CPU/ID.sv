`timescale 1ps/1ps

module ID (
	input logic clk, reset, Reg2Loc, ALUSrc, RegWrite, IsBL, isDType, UncondBr,
	input logic[63:0] WriteBck, PCp4, CurrPC, //From writeback
	input logic[31:0] instruction,
	input logic[4:0] WBRd,
	input logic WBErrorA, WBErrorB,
	
	output logic[63:0] Da, Db, ALUInput, BrLoc,
	output logic[4:0] Rd, Rm, Rn
);
	parameter DELAY = 50;
	
	logic[63:0] Da_pre_wb_mux, Db_pre_wb_mux;
	
	assign Rm = instruction[20:16];
	assign Rd = instruction[4:0];
	assign Rn = instruction[9:5];
	
	logic[4:0] splitout, Aw_in;
	
	n_bit_2to1 #(.BITS(5)) ldurstur_mux (.data_line1(Rd), .data_line0(Rm), .s(Reg2Loc), .mux_out(splitout));
	
	n_bit_2to1 #(.BITS(5)) aw_mux (.data_line1(5'b11110), .data_line0(WBRd), .s(IsBL), .mux_out(Aw_in));
	
	logic [63:0] Dw_in;
	n_bit_2to1 #(.BITS(64)) dw_mux (.data_line1(PCp4), .data_line0(WriteBck), .s(IsBL), .mux_out(Dw_in));
	
	// Hopefully fixes the double WB issue with BL instructions. Along with this, removed RegWrite from BL instruction in control unit
	logic RegWrite_with_BL;
	or #(DELAY) (RegWrite_with_BL, RegWrite, IsBL);
	
	// Made changes here. WriteRegister is the register that's being written into, which is always Rd
	// Additionally, WriteData is the actual data, which comes from WB. Also, the input WriteBck had only 5 bits when it needed 64.
	// Finally, DataWrite was redundant to WriteBck
	regfile registerFile (.ReadData1(Da_pre_wb_mux), .ReadData2(Db_pre_wb_mux), .WriteData(Dw_in), 
								.ReadRegister1(Rn), .ReadRegister2(splitout), .WriteRegister(Aw_in), 
								.RegWrite(RegWrite_with_BL),
								.clk(clk), .reset(reset));
	
	// These (hopefully) muxes take care of the issue where the WB takes an extra clock cycle 
   //	so the data is wrong in the read out for Da and Db
	n_bit_2to1 #(.BITS(64)) Da_WB_MUX (.data_line1(WriteBck), .data_line0(Da_pre_wb_mux), .s(WBErrorA), .mux_out(Da));
								
	n_bit_2to1 #(.BITS(64)) Db_WB_MUX (.data_line1(WriteBck), .data_line0(Db_pre_wb_mux), .s(WBErrorB), .mux_out(Db));
								
	logic[11:0] Immediate;
	assign Immediate = instruction[21:10];
	
	logic [8:0] DT_address;
	
	assign DT_address = instruction[20:12];
	
	logic[63:0] Immediate64, DT_address64, shift;
	
	assign Immediate64 = {{52{1'b0}}, Immediate}; //Zero extend the immediate to 64 bits
	
	assign DT_address64 = {{55{DT_address[8]}}, DT_address}; //Sign extend the DT addr to 64 bits
	
	n_bit_2to1 #(.BITS(64)) ImmChoose (.data_line1(DT_address64), .data_line0(Immediate64), .s(isDType), .mux_out(shift));
	
	n_bit_2to1 #(.BITS(64)) ALUchoose (.data_line1(shift), .data_line0(Db), .s(ALUSrc), .mux_out(ALUInput));
	
	
	
	// Branching moved from EX -------------------------
	
	logic [18:0] CondAddr19;
	logic [25:0] BrAddr26;

	assign CondAddr19 = instruction[23:5];
	assign BrAddr26 = instruction[25:0];

	logic [63:0] BrAddr64, CondAddr64;

	assign BrAddr64 = {{38{BrAddr26[25]}}, BrAddr26};
	assign CondAddr64 = {{45{CondAddr19[18]}}, CondAddr19};

	logic [63:0] BrLoc_unshifted, BrLoc_unsummed;

	n_bit_2to1 #(.BITS(64)) UncondMux (.data_line1(BrAddr64), .data_line0(CondAddr64), .s(UncondBr), .mux_out(BrLoc_unshifted));

	assign BrLoc_unsummed = {BrLoc_unshifted[61:0], 2'b00}; //New shift (without RTL version)
	
	
	sixtyfourbit_fulladder BPCadd (.A(BrLoc_unsummed), .B(CurrPC), .Cin(1'b0), .S(BrLoc)); // Adds current PC to Br
	
	
	
endmodule
								
	

	
