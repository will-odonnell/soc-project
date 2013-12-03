`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:         The Learning Labs
// Engineer:        Mark McDermott
// 
// Create Date:     19:08:45 02/10/2008 
// Design Name: 
// Module Name:    
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: This file is used debug the mezzanine to fpga interface.
//
// Dependencies: Need the correct UCF file. Can't use the Master File
//
// Additional Comments: Copyright 2006,2007,2008 -- DO NOT DISTRIBUTE
//
//////////////////////////////////////////////////////////////////////////////////

module mem_8x6144 (
	DI,
	DIP,
	ADDR,
	EN,
	WE,
	SSR,
	CLK,
	DO,
	DOP	                  
);

input [7:0]	DI;
input 		DIP;
input [12:0]	ADDR;
input		EN;
input		WE;
input		SSR;
input		CLK;
output [7:0]	DO;
output 		DOP; 

// ----------------------------------------------------------------------------
// Wires and Continuous Signals 
// -----------------------------------------------------------------------------
wire 		ram0_enable;
wire		ram1_enable;
wire		ram2_enable;

assign ram0_enable = (EN == 0) ? 1'b0 :              // Memory not enabled
		     (ADDR[12:11] == 2'b00) ? 1'b1 : // Enable if valid range
		     1'b0; 			     // otherwise disable
assign ram1_enable = (EN == 0) ? 1'b0 :              // Memory not enabled
		     (ADDR[12:11] == 2'b01) ? 1'b1 : // Enable if valid range
		     1'b0; 			     // otherwise disable
assign ram2_enable = (EN == 0) ? 1'b0 :              // Memory not enabled
		     (ADDR[12:11] == 2'b10) ? 1'b1 : // Enable if valid range
		     1'b0; 			     // otherwise disable



// ----------------------------------------------------------------------------
// Block RAM Instantiations
// -----------------------------------------------------------------------------
RAMB16_S9 RAM16_0 (
	.DI(DI),   		// 32-bit data_in bus ([31:0])
        .DIP(DIP),              // 4-bit parity data_in bus ([35:32])
        .ADDR(ADDR),		// 11-bit address bus
        .EN(ram0_enable),       // RAM enable signal
        .WE(WE),           	// Write enable signal
        .SSR(SSR),              // set/reset signal
        .CLK(CLK),	     	// clock signal
        .DO(DO)            	// 32-bit data_out bus ([31:0])
);

RAMB16_S9 RAM16_1 (
	.DI(DI),   		// 32-bit data_in bus ([31:0])
        .DIP(DIP),              // 4-bit parity data_in bus ([35:32])
        .ADDR(ADDR),		// 11-bit address bus
        .EN(ram1_enable),       // RAM enable signal
        .WE(WE),           	// Write enable signal
        .SSR(SSR),              // set/reset signal
        .CLK(CLK),     		// clock signal
        .DO(DO)            	// 32-bit data_out bus ([31:0])
);

RAMB16_S9 RAM16_2 (
	.DI(DI),   		// 32-bit data_in bus ([31:0])
        .DIP(DIP),              // 4-bit parity data_in bus ([35:32])
        .ADDR(ADDR),		// 11-bit address bus
        .EN(ram2_enable),       // RAM enable signal
        .WE(WE),           	// Write enable signal
        .SSR(SSR),              // set/reset signal
        .CLK(CLK),     		// clock signal
        .DO(DO)            	// 32-bit data_out bus ([31:0])
);

endmodule


