`timescale 1ps/1ps


module pipelined_tb ();

	logic clk, reset;
	
	pipelinedTop DUT (.clk(clk), .reset(reset));
	
	//CLK setup
	
	parameter CLKdelay = 100000;
	
	initial begin
		clk = 0;
		forever #(CLKdelay/2) clk = ~clk;
	end
	
	initial begin
		reset = 1;
		repeat (1) @(posedge clk);
		reset = 0;
	
		repeat (600) begin
			@(posedge clk);
			$display("time=%0t instruction=%h ALURes=%h Writebck=%h", $time, DUT.instruction, DUT.ALURes, DUT.WriteBck);
			
		end
		
		$stop;
	end
endmodule
	