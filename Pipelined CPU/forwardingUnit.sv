`timescale 1ps/1ps

 
 module forwardingUnit (
	input logic[4:0] RnIDEX, RmIDEX, RdEXMEM, RdMEMWB,
	input logic RegWriteEXMEM, RegWriteMEMWB,
	
	output logic[1:0] ForwardA, ForwardB
);

	parameter DELAY = 50;
	
	//Compare next instruction with current instruction logic.
	
	//Equality wires:
	logic RdEXMEM_eq_Rn, RdEXMEM_eq_Rm;
	logic RdMEMWB_eq_Rn, RdMEMWB_eq_Rm;
	
	assign RdEXMEM_eq_Rn = RegWriteEXMEM;
	assign RdEXMEM_eq_Rm = RegWriteEXMEM;
	
	assign RdMEMWB_eq_Rn = RegWriteMEMWB;
	assign RdMEMWB_eq_Rm = RegWriteMEMWB;
	
	//Create intermediate wires (signal_store is for the equality checking bit, signal_store_1 is for checking that Rd is not X31)
	logic eq_store_0, x31_store_0;
	logic eq_store_1, x31_store_1;
	logic eq_store_2, x31_store_2;
	logic eq_store_3, x31_store_3;
	
	genvar i;
	
	
	generate
		for (i = 0; i < 5; i++) begin : eq_loop
			xnor #(DELAY) (eq_store_0, RdEXMEM[i], RnIDEX[i]);
			not #(DELAY) (x31_store_0, RdEXMEM[i]);
			and #(DELAY) (RdEXMEM_eq_Rn, RdEXMEM_eq_Rn, eq_store_0, x31_store_0);
			
			xnor #(DELAY) (eq_store_1, RdEXMEM[i], RmIDEX[i]);
			not #(DELAY) (x31_store_1, RdEXMEM[i]);
			and #(DELAY) (RdEXMEM_eq_Rm, RdEXMEM_eq_Rm, eq_store_1, x31_store_1);
			
			xnor #(DELAY) (eq_store_2, RdMEMWB[i], RnIDEX[i]);
			not #(DELAY) (x31_store_2, RdMEMWB[i]);
			and #(DELAY) (RdMEMWB_eq_Rn, RdMEMWB_eq_Rn, eq_store_2, x31_store_2);
			
			xnor #(DELAY) (eq_store_3, RdMEMWB[i], RmIDEX[i]);
			not #(DELAY) (x31_store_3, RdMEMWB[i]);
			and #(DELAY) (RdMEMWB_eq_Rm, RdMEMWB_eq_Rm, eq_store_3, x31_store_3);
		end
	endgenerate
	
	// Make sure to have only 00, 10, 01 for options.
	// EXMEM fwding takes precedence, so must make sure 2nd bit is secondary to first bit
	
	logic MEMWB_allowed_A, MEMWB_allowed_B;
	not #(DELAY) (MEMWB_allowed_A, RdEXMEM_eq_Rn);
	not #(DELAY) (MEMWB_allowed_B, RdEXMEM_eq_Rm);
	
	logic MEMWB_needed_A, MEMWB_needed_B;
	and #(DELAY) (MEMWEB_needed_A, MEMWB_allowed_A, RdMEMWB_eq_Rn);
	and #(DELAY) (MEMWEB_needed_A, MEMWB_allowed_A, RdMEMWB_eq_Rn);
	
	assign ForwardA = {RdEXMEM_eq_Rn, MEMWB_needed_A};
	assign ForwardB = {RdEXMEM_eq_Rm, MEMWB_needed_B};
	

endmodule
