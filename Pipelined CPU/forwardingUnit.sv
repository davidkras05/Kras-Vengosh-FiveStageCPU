`timescale 1ps/1ps

 
 module forwardingUnit (
	input logic[4:0] RnIDEX, RmIDEX, RdEXMEM, RdMEMWB,
	input logic RegWriteEXMEM, RegWriteMEMWB,
	
	output logic[1:0] ForwardA, ForwardB
);


	parameter DELAY = 50;
	
	//Compare next instruction with current instruction logic.
	
	//Equality wires:
	logic[5:0] RdEXMEM_eq_Rn, RdEXMEM_eq_Rm;
	logic[5:0] RdMEMWB_eq_Rn, RdMEMWB_eq_Rm;
	
	assign RdEXMEM_eq_Rn[0] = RegWriteEXMEM;
	assign RdEXMEM_eq_Rm[0] = RegWriteEXMEM;
	
	assign RdMEMWB_eq_Rn[0] = RegWriteMEMWB;
	assign RdMEMWB_eq_Rm[0] = RegWriteMEMWB;
	
	//Create intermediate wires (signal_store is for the equality checking bit, signal_store_1 is for checking that Rd is not X31)
	
	
	genvar i;
	
	logic[19:0] eq_store, x31_store;
	
	generate
		for (i = 0; i < 5; i++) begin : eq_loop
			
		   //0-4
			xnor #(DELAY) (eq_store[i], RdEXMEM[i], RnIDEX[i]);
			not #(DELAY) (x31_store[i], RdEXMEM[i]);
			and #(DELAY) (RdEXMEM_eq_Rn[i+1], RdEXMEM_eq_Rn[i], eq_store[i], x31_store[i]);
			
			//5-9
			xnor #(DELAY) (eq_store[i+5], RdEXMEM[i+5], RmIDEX[i]);
			not #(DELAY) (x31_store[i+5], RdEXMEM[i+5]);
			and #(DELAY) (RdEXMEM_eq_Rm[i+1], RdEXMEM_eq_Rm[i], eq_store[i+5], x31_store[i+5]);
			
			//10-14
			xnor #(DELAY) (eq_store[i+10], RdMEMWB[i+10], RnIDEX[i]);
			not #(DELAY) (x31_store[i+10], RdMEMWB[i+10]);
			and #(DELAY) (RdMEMWB_eq_Rn[i+1], RdMEMWB_eq_Rn[i], eq_store[i+10], x31_store[i+10]);
			
			//15-19
			xnor #(DELAY) (eq_store[i+15], RdMEMWB[i+15], RmIDEX[i]);
			not #(DELAY) (x31_store[i+15], RdMEMWB[i+15]);
			and #(DELAY) (RdMEMWB_eq_Rm[i+1], RdMEMWB_eq_Rm[i], eq_store[i+15], x31_store[i+15]);
		end
	endgenerate
	
	// Make sure to have only 00, 10, 01 for options.
	// EXMEM fwding takes precedence, so must make sure 2nd bit is secondary to first bit
	
	logic MEMWB_allowed_A, MEMWB_allowed_B;
	not #(DELAY) (MEMWB_allowed_A, RdEXMEM_eq_Rn[5]);
	not #(DELAY) (MEMWB_allowed_B, RdEXMEM_eq_Rm[5]);
	
	logic MEMWB_needed_A, MEMWB_needed_B;
	and #(DELAY) (MEMWB_needed_A, MEMWB_allowed_A, RdMEMWB_eq_Rn[5]);
	and #(DELAY) (MEMWB_needed_B, MEMWB_allowed_B, RdMEMWB_eq_Rm[5]);
	
	assign ForwardA = {RdEXMEM_eq_Rn[5], MEMWB_needed_A};
	assign ForwardB = {RdEXMEM_eq_Rm[5], MEMWB_needed_B};
	

endmodule
