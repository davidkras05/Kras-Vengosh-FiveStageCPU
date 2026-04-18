// Test bench for ALU
`timescale 1ps/1ps

// Meaning of signals in and out of the ALU:

// Flags:
// negative: whether the result output is negative if interpreted as 2's comp.
// zero: whether the result output was a 64-bit zero.
// overflow: on an add or subtract, whether the computation overflowed if the inputs are interpreted as 2's comp.
// carry_out: on an add or subtract, whether the computation produced a carry-out.

// cntrl			Operation						Notes:
// 000:			result = B						value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant

module alustim();

	parameter delay = 100000;

	logic		[63:0]	A, B;
	logic		[2:0]		cntrl;
	logic		[63:0]	result;
	logic					negative, zero, overflow, carry_out ;

	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	

	ALU dut (.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ps", 10);

	integer i;
	logic [63:0] test_val;
	initial begin
	
		$display("%t testing PASS_A operations", $time);
		cntrl = ALU_PASS_B;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			#(delay);
			assert(result == B && negative == B[63] && zero == (B == '0));
		end
		
		$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		A = 64'h0000000000000001; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000002 && carry_out === 0 && overflow === 0 && negative === 0 && zero === 0) else
			$error("Test failed expected: result %064h and all 0s on the flags. Got: result %064h carryout %01b overflow %01b negative %01b zero %01b", 64'h2, result, carry_out, overflow, negative, zero);
		
		$display("%t testing subtration (4-2)", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'h0000000000000004; B = 64'h0000000000000002; //Testing 4-2
		#(delay);
		assert(result == 64'h0000000000000002 && carry_out === 1 && overflow === 0 && negative === 0 && zero === 0) else
			$error("Test failed expected: result %064h and all 0s on the flags. Got: result %064h carryout %01b overflow %01b negative %01b zero %01b", 64'h2, result, carry_out, overflow, negative, zero);
		
		//Testing AND
		
		$display("%t testing AND", $time);
		cntrl = ALU_AND;
		A = 64'h1; B = 64'h1; //Testing AND, 64'h1 is just 64'h0000000000000001
		#(delay);
		assert(result == 64'h0000000000000001 && carry_out === 0 && overflow === 0 && negative === 0 && zero === 0) else
			$error("Test failed expected: result %064h and all 0s on flags. Got: result %064h carryout %01b overflow %01b negative %01b zero %01b", 64'h1, result, carry_out, overflow, negative, zero);
		
		//Testing OR
		
		$display("%t testing OR", $time);
		cntrl = ALU_OR;
		A = 64'h1; B = 64'h0; //Testing OR
		#(delay);
		assert(result == 64'h0000000000000001 && carry_out == 'x && overflow === 0 && negative === 0 && zero === 0) else
			$error("Test failed expected: result %064h and all 0s on flags. Got: result %064h carryout %01b overflow %01b negative %01b zero %01b", 64'h1, result, carry_out, overflow, negative, zero);
		
		//Testing XOR
		
		$display("%t testing XOR", $time);
		cntrl = ALU_XOR;
		A = 64'h1; B = 64'h1; //Testing XOR
		#(delay);
		assert(result == 64'h0 && carry_out === 0 && overflow === 0 && negative === 0 && zero === 1) else
			$error("Test failed expected: result %064h and all 0s on flags except zero. Got: result %064h carryout %01b overflow %01b negative %01b zero %01b", 64'h0, result, carry_out, overflow, negative, zero);
		
		//Testing negative flag
		
		$display("%t testing negative flag (2-4)", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'h0000000000000002; B = 64'h0000000000000004; //Testing 2-4
		#(delay);
		assert(result == 64'hFFFFFFFFFFFFFFFE && carry_out === 0 && overflow === 0 && negative === 1 && zero === 0) else
			$error("Test failed expected: result %064h and 0s on all flags except negative & carryout. Got: result %064h carryout %01b overflow %01b negative %01b zero %01b", 64'hFFFFFFFFFFFFFFFE, result, carry_out, overflow, negative, zero);
		
		//Overflow tests
		
		$display("%t testing overflow flag on addition (max positive + 1)", $time);
		cntrl = ALU_ADD;
		A = 64'h7FFFFFFFFFFFFFFF; B = 64'h0000000000000001; //  max positive + 1
		#(delay);
		assert(result == 64'h8000000000000000 && carry_out === 0 && overflow === 1 && negative === 1 && zero === 0) else
			$error("Test failed expected: result %064h carryout 0 overflow 1 negative 1 zero 0. Got: result %064h carryout %01b overflow %01b negative %01b zero %01b",64'h8000000000000000, result, carry_out, overflow, negative, zero);
		
		$display("%t testing overflow flag on addition (most negative + most negative)", $time);
		cntrl = ALU_ADD;
		A = 64'h8000000000000000; B = 64'h8000000000000000; // min negative + min negative
		#(delay);
		assert(result == 64'h0000000000000000 && carry_out === 1 && overflow === 1 && negative === 0 && zero === 1) else
			$error("Test failed expected: result %064h carryout 1 overflow 1 negative 0 zero 1. Got: result %064h carryout %01b overflow %01b negative %01b zero %01b",64'h0000000000000000, result, carry_out, overflow, negative, zero);

		$display("%t testing overflow flag on subtraction (max positive - -1)", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'h7FFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFFFFFFFF; // max positive - (-1)
		#(delay);
		assert(result == 64'h8000000000000000 && carry_out === 0 && overflow === 1 && negative === 1 && zero === 0) else
			$error("Test failed expected: result %064h carryout 0 overflow 1 negative 1 zero 0. Got: result %064h carryout %01b overflow %01b negative %01b zero %01b",64'h8000000000000000, result, carry_out, overflow, negative, zero);

		$display("%t testing overflow flag on subtraction (most negative - 1)", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'h8000000000000000; B = 64'h0000000000000001; // min negative - 1
		#(delay);
		assert(result == 64'h7FFFFFFFFFFFFFFF && carry_out === 1 && overflow === 1 && negative === 0 && zero === 0) else
			$error("Test failed expected: result %064h carryout 1 overflow 1 negative 0 zero 0. Got: result %064h carryout %01b overflow %01b negative %01b zero %01b",64'h7FFFFFFFFFFFFFFF, result, carry_out, overflow, negative, zero);
		
		
	end
endmodule

