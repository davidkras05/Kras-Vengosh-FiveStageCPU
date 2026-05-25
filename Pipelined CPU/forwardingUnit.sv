`timescale 1ps/1ps

 
 module forwardingUnit (
	input logic[4:0] RnID, RmID,
	input logic[4:0] RnIDEX, RmIDEX, RdEXMEM, RdMEMWB, RdEX, RdID,
	input logic RegWriteEXMEM, RegWriteMEMWB, ALUSrcEX, Reg2LocID,
	input logic ID_IsBR, RegWriteIDEX,
	
	output logic[1:0] ForwardA, ForwardB,
	output logic WBErrorA, WBErrorB, FwdForBR
);


	
	always_comb begin
	
		//FwdA
		if (RegWriteEXMEM && RdEXMEM != 5'b11111 && RdEXMEM == RnIDEX) begin
			ForwardA = 2'b10;
		end
		else if (RegWriteMEMWB && RdMEMWB != 5'b11111 && RdMEMWB == RnIDEX) begin
			ForwardA = 2'b01;
		end
		else begin
			ForwardA = 2'b00;
		end
			
		
		//FwdB
		if (RegWriteEXMEM && RdEXMEM != 5'b11111 && RdEXMEM == RmIDEX && ~ALUSrcEX) begin
			ForwardB = 2'b10;
		end
		else if (RegWriteMEMWB && RdMEMWB != 5'b11111 && RdMEMWB == RmIDEX && ~ALUSrcEX) begin
			ForwardB = 2'b01;
		end
		else begin
			ForwardB = 2'b00;
		end
		
		
			
		if (RdMEMWB == RnID && RegWriteMEMWB && RdMEMWB != 5'b11111) begin
			WBErrorA = 1'b1;
		end
		else begin
			WBErrorA = 1'b0;
		end
		
		
		if (RdMEMWB == RmID && ~Reg2LocID && RegWriteMEMWB && RdMEMWB != 5'b11111) begin
			WBErrorB = 1'b1;
		end
		else begin
			WBErrorB = 1'b0;
		end
		
		if (RdEX == RdID && ID_IsBR && RegWriteIDEX && RdEX != 5'b11111) begin
			FwdForBR = 1'b1;
		end
		else begin
			FwdForBR = 1'b0;
		end
		
	end
			
endmodule
