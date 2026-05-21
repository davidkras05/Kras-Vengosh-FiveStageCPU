`timescale 1ps/1ps

 
 module forwardingUnit (
	input logic[4:0] RnIDEX, RmIDEX, RdEXMEM, RdMEMWB,
	input logic RegWriteEXMEM, RegWriteMEMWB,
	
	output logic[1:0] ForwardA, ForwardB
);


	
	always_comb begin
	
		if (1'b1 == 1'b1) begin
			ForwardA = 2'b00;
			ForwardB = 2'b00;
		end
	
		if (RegWriteMEMWB && RdMEMWB != 5'b11111) begin
			if (RdMEMWB == RnIDEX) begin
				ForwardA = 2'b01;
			end
			
			if (RdMEMWB == RmIDEX) begin
				ForwardB = 2'b01;
			end
		end
	
		if (RegWriteEXMEM && RdEXMEM != 5'b11111) begin
			if (RdEXMEM == RnIDEX) begin
				ForwardA = 2'b10;
			end
			
			if (RdEXMEM == RmIDEX) begin
				ForwardB = 2'b10;
			end
		end
		
		else begin
			ForwardA = 2'b00;
			ForwardB = 2'b00;
		end
	end
			
endmodule
