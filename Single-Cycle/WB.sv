module WB (
	input logic[63:0] ALURes, MEMData,
	input logic Mem2Reg,
	output logic WriteBck //goes to ID registerfile datawrite
);

	n_bit_2to1 writeBackMux #(.BITS(64)) (.data_line1(MEMData), .data_line0(ALURes), .s(Mem2Reg), .mux_out(WriteBck));

endmodule
