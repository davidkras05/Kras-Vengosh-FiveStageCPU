module control_unit (
	input logic [31:0] instruction,
	input logic [63:0] Db,
	input logic ZeroFlag, NegativeFlag,
	output logic Reg2Loc, ALUSrc, Mem2Reg, RegWrite, MemWrite, MemRead,
	output logic BrTaken, UncondBr, SetFlags, IsBL, IsBR, isDType,
	output logic [2:0] ALUOp
);

	logic [11:0] extended_op;
	assign extended_op = {1'b0, instruction[31:21]};
	
	logic [7:0] branch_conditional;
	assign branch_conditional = {3'b0, instruction[4:0]};
	
	// ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110
	always_comb begin 
		if (extended_op == 12'h458) begin //ADD
			Reg2Loc = 1'b0;
			ALUSrc = 1'b0;
			Mem2Reg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			MemRead = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 3'b010; //ADD
			SetFlags = 1'b0;
			IsBL = 1'b0;
			IsBR = 1'b0;
			isDType = 1'b0;
		end
		
		else if (extended_op >= 12'h488 && extended_op <= 12'h489) begin // ADDI
			Reg2Loc = 1'b1;
			ALUSrc = 1'b1;
			Mem2Reg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			MemRead = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 3'b010; //ADD
			SetFlags = 1'b0;
			IsBL = 1'b0;
			IsBR = 1'b0;
			isDType = 1'b0;
		end
		
		else if (extended_op == 12'h558) begin //ADDS
			Reg2Loc = 1'b0;
			ALUSrc = 1'b0;
			Mem2Reg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			MemRead = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 3'b010; //ADD
			SetFlags = 1'b1;
			IsBL = 1'b0;
			IsBR = 1'b0;
			isDType = 1'b0;
		end
		
		else if (extended_op == 12'h658) begin //SUB
			Reg2Loc = 1'b0;
			ALUSrc = 1'b0;
			Mem2Reg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			MemRead = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 3'b011; //SUB
			SetFlags = 1'b0;
			IsBL = 1'b0;
			IsBR = 1'b0;
			isDType = 1'b0;
		end
		
		else if (extended_op >= 12'h688 && extended_op <= 12'h689) begin // SUBI
			Reg2Loc = 1'b1;
			ALUSrc = 1'b1;
			Mem2Reg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			MemRead = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 3'b011; //SUB
			SetFlags = 1'b0;
			IsBL = 1'b0;
			IsBR = 1'b0;
			isDType = 1'b0;
		end
		
		else if (extended_op == 12'h758) begin //SUBS
			Reg2Loc = 1'b0;
			ALUSrc = 1'b0;
			Mem2Reg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			MemRead = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 3'b011; //SUB
			SetFlags = 1'b1;
			IsBL = 1'b0;
			IsBR = 1'b0;
			isDType = 1'b0;
		end
		
		else if (extended_op == 12'h7C2) begin //LDUR
			Reg2Loc = 1'bx;
			ALUSrc = 1'b1;
			Mem2Reg = 1'b1;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			MemRead = 1'b1;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 3'b010; //ADD, change later
			SetFlags = 1'b0;
			IsBL = 1'b0;
			IsBR = 1'b0;
			isDType = 1'b1;
		end
		
		else if (extended_op == 12'h7C0) begin //STUR
			Reg2Loc = 1'b1;
			ALUSrc = 1'b1;
			Mem2Reg = 1'bx;
			RegWrite = 1'b0;
			MemWrite = 1'b1;
			MemRead = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 3'b010; //ADD, change later
			SetFlags = 1'b0;
			IsBL = 1'b0;
			IsBR = 1'b0;
			isDType = 1'b1;
		end
			
		else if (extended_op >= 12'h0A0 && extended_op <= 12'h0BF) begin //B
			Reg2Loc = 1'bx;
			ALUSrc = 1'bx;
			Mem2Reg = 1'bx;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			MemRead = 1'b0;
			BrTaken = 1'b1;
			UncondBr = 1'b1;
			ALUOp = 3'bxxx; //Don't care
			SetFlags = 1'b0;
			IsBL = 1'b0;
			IsBR = 1'b0;
			isDType = 1'b0;
		end
		
		else if (extended_op >= 12'h5A0 && extended_op <= 12'h5A7) begin // CBZ
			Reg2Loc = 1'b1;
			ALUSrc = 1'b0;
			Mem2Reg = 1'bx;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			MemRead = 1'b0;
			if (Db == 64'b0) begin
				BrTaken = 1'b1; // NEED FLAGS
			end 
			
			else begin
				BrTaken = 1'b0;
			end
			
			UncondBr = 1'b0;
			ALUOp = 3'b000; //PASS, change later
			SetFlags = 1'b0;
			IsBL = 1'b0;
			IsBR = 1'b0;
			isDType = 1'b0;
		end
		
		else if (extended_op == 12'h6B0) begin // BR, should double check
			Reg2Loc = 1'b1;
			ALUSrc = 1'b0;
			Mem2Reg = 1'b0;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			MemRead = 1'b0;
			BrTaken = 1'b1;
			UncondBr = 1'b1;
			ALUOp = 3'b000; //PASS, (double check)
			SetFlags = 1'b0;
			IsBL = 1'b0;
			IsBR = 1'b1;
			isDType = 1'b0;
		end
		
		else if (extended_op >= 12'h4A0 && extended_op <= 12'h4BF) begin // BL, should double check
			Reg2Loc = 1'bx;
			ALUSrc = 1'bx;
			Mem2Reg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			MemRead = 1'b0;
			BrTaken = 1'b1;
			UncondBr = 1'b1;
			ALUOp = 3'bxxx; //Don't Care
			SetFlags = 1'b0;
			IsBL = 1'b1;
			IsBR = 1'b0;
			isDType = 1'b0;
		end
		
		else if (extended_op >= 12'h2A0 && extended_op <= 12'h2A7 && branch_conditional == 12'h0B) begin // B.LT
			Reg2Loc = 1'b0;
			ALUSrc = 1'b0;
			Mem2Reg = 1'bx;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			MemRead = 1'b0;
			BrTaken = NegativeFlag;
			UncondBr = 1'b0;
			ALUOp = 3'b000; //PASS, change later
			SetFlags = 1'b0;
			IsBL = 1'b0;
			IsBR = 1'b0;
			isDType = 1'b0;
		end
		
		else begin // Invalid opcode
			$error("Invalid opcode: %h", extended_op);
			Reg2Loc = 1'bx;
			ALUSrc = 1'bx;
			Mem2Reg = 1'bx;
			RegWrite = 1'bx;
			MemWrite = 1'bx;
			MemRead = 1'bx;
			BrTaken = 1'bx;
			UncondBr = 1'bx;
			ALUOp = 3'bxxx; //DON'T CARE, change later
			SetFlags = 1'bx;
			IsBL = 1'bx;
			IsBR = 1'bx;
			isDType = 1'bx;
		end
	end

endmodule
