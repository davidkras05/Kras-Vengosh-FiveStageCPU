`timescale 1ns/10ps

module register (
	input logic clk,
	input logic[63:0] write,
	input logic reset,
	input logic En,
	
	output logic[63:0] q
	
);
	
	/*This is the 64 bit register for wiring to the five_thirtytwodecoder. This creates one
		instance of a 64 bit register. The full 32 can be instantiated in the top module*/
		
	parameter delay = 50;
	
	genvar i;
	
	generate
		for(i=0; i<64; i++) begin: sub_FF
			
			logic data_hold, reset_buf, clk_buf, data_hold_buf;
			
			two_onemux enable (.in({write[i], q[i]}), .s(En), .y(data_hold));
			
			buf #(450) (data_hold_buf, data_hold);
	
			D_FF flipflop (.q(q[i]), .d(data_hold_buf), .reset(reset), .clk(clk));
		
		end
	endgenerate
endmodule


module register_tb ();

    parameter ClockDelay = 5000;

    logic clk, reset;
    logic [63:0] write, q;
    
    integer i;
    
    initial begin // Set up the clock
        clk <= 0;
        forever #(ClockDelay/2) clk <= ~clk;
    end
    
    initial $timeformat(-9, 2, " ns", 10);
    
    register dut (.clk, .write, .reset, .q);
    
    
    
    initial begin
        // test reset behavior:
        $display("%t Test reset behavior.", $time);
        reset <= 1;
        write <= 64'b0;
        @(posedge clk);
        
        reset <= 0;
        @(posedge clk);
        
        // test writing into register:
        $display("%t Write all ones.", $time);
        write <= 64'hFFFF_FFFF_FFFF_FFFF;
        @(posedge clk);
        
        // test if register holds data:
        $display("%t Tesing hold behavior.", $time);
        @(posedge clk);
        
        
        // write in all zeros:
        $display("%t Write all zeros.", $time);
        write <= 64'b0;
        @(posedge clk);
        
        // test each bit individually:
        
        $display("%t Testing each bit individually.", $time);
        for (i = 0; i < 64; i++) begin
            write <= 64'b1 << i; // this is a 1 bit left shifted i times
            @(posedge clk);
        end
        @(posedge clk);
    
    $stop;
    end
    
endmodule


