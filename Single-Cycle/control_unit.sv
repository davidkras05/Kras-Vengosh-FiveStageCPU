module control_unit (
	input logic [10:0] op_code,
	input logic zero_flag,
	output logic Reg2Loc, ALUSrc, Mem2Reg, RegWrite, MemWrite, BrTaken, UncondBr, SetFlags,
	output logic [1:0] ALUOp
);

	logic [11:0] extended_op = {1'b0, op_code}
	
	always_comb begin 
		if (extended_op == 12'h458) begin //ADD
			Reg2Loc = 1'b1;
			ALUSrc = 1'b1;
			Mem2Reg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 2'bxx; //ADD, change later
			SetFlags = 1'b0;
		end
		
		else if (extended_op inside {[12'488:12'h489]}) begin // ADDI
			Reg2Loc = 1'b1;
			ALUSrc = 1'b1;
			Mem2Reg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 2'bxx; //ADD, change later
			SetFlags = 1'b0;
		end
		
		else if (extended_op == 12'h558) begin //ADDS
			Reg2Loc = 1'b1;
			ALUSrc = 1'b1;
			Mem2Reg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 2'bxx; //ADD, change later
			SetFlags = 1'b1;
		end
		
		else if (extended_op == 12'h658) begin //SUB
			Reg2Loc = 1'b1;
			ALUSrc = 1'b1;
			Mem2Reg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 2'bxx; //SUB, change later
			SetFlags = 1'b0;
		end
		
		else if (extended_op inside {[12'688:12'h689]}) begin // SUBI
			Reg2Loc = 1'b1;
			ALUSrc = 1'b1;
			Mem2Reg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 2'bxx; //SUB, change later
			SetFlags = 1'b0;
		end
		
		else if (extended_op == 12'h758) begin //SUBS
			Reg2Loc = 1'b1;
			ALUSrc = 1'b1;
			Mem2Reg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 2'bxx; //SUB, change later
			SetFlags = 1'b1;
		end
		
		else if (extended_op == 12'h7C2) begin //LDUR
			Reg2Loc = 1'bx;
			ALUSrc = 1'b1;
			Mem2Reg = 1'b1;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 2'bxx; //ADD, change later
			SetFlags = 1'b0;
		end
		
		else if (extended_op == 12'h7C0) begin //STUR
			Reg2Loc = 1'b0;
			ALUSrc = 1'b1;
			Mem2Reg = 1'bx;
			RegWrite = 1'b0;
			MemWrite = 1'b1;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 2'bxx; //ADD, change later
			SetFlags = 1'b0;
		end
			
		else if (extended_op inside {[12'h0A0:12'h0BF]}) begin //B
			Reg2Loc = 1'bx;
			ALUSrc = 1'bx;
			Mem2Reg = 1'bx;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = 1'b1;
			UncondBr = 1'b1;
			ALUOp = 2'bxx; //Don't care
			SetFlags = 1'b0;
		end
		
		else if (extended_op inside {[12'h5A0:12'h5A7]}) begin // CBZ
			Reg2Loc = 1'b0;
			ALUSrc = 1'b0;
			Mem2Reg = 1'bx;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = zero_flag; // NEED FLAGS
			UncondBr = 1'b0;
			ALUOp = 2'bxx; //PASS, change later
			SetFlags = 1'b0;
		end
		
		else if (extended_op == 12'h6B0) begin // BR, should double check
			Reg2Loc = 1'b1;
			ALUSrc = 1'b0;
			Mem2Reg = 1'b0;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = 1'b1;
			UncondBr = 1'b1;
			ALUOp = 2'bxx; //NOT SURE, change later
			SetFlags = 1'b0;
		end
		
		else if (extended_op inside {[12'h4A0:12'h4BF}]) begin // BL, NOT COMPLETE
			Reg2Loc = 1'b1;
			ALUSrc = 1'b1;
			Mem2Reg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 2'bxx; //ADD, change later
			SetFlags = 1'b0;
		end
		
		else begin // Invalid opcode
			$error("Invalid opcode: %h", extended_op);
			Reg2Loc = 1'bx;
			ALUSrc = 1'bx;
			Mem2Reg = 1'bx;
			RegWrite = 1'bx;
			MemWrite = 1'bx;
			BrTaken = 1'bx;
			UncondBr = 1'bx;
			ALUOp = 2'bxx; //ADD, change later
			SetFlags = 1'bx;
		end
	end

endmodule
