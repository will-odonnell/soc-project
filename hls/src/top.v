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

module top (
                    SYS_CLK,          // 24 MHz FPGA clock
                    MZ_CPLD_CLKO,     // Clock from CPLD
                    FPGA_CLK4,        // 27 MHz clock
                    FPGA_CLK3,        // 100 MHz clock
                    SYS_RST_N,
                    MZ_CPLD_RESET_OUT, // Reset from CPLD
                    MZ_BUF_DATA,
                    MZ_BUF_ADDR,
                    MZ_CPLD_AS,       // Address strobe - Active High
                    MZ_CPLD_RW,
                    FPGA_MZ_DTACK,    // DTACK FPGA->MZ Active High
                    MZ_CPLD_BYTE_N,
                    MZ_CPLD_MISC0,    // cs1_rs_b
                    MZ_CPLD_MISC1,    // cs1_ws_b
                    MZ_CPLD_MISC2,    // cs5_rs_b
                    MZ_CPLD_MISC3,    // cs5_ws_b
                    MZ_CPLD_MISC4,    // CPLD: oe_b
                    MZ_CPLD_MISC5,    // CPLD: cs0_b
                    MZ_CPLD_MISC6,    // CPLD: cs1_b
                    MZ_CPLD_MISC7,    // CPLD: cs2_b
                    MZ_CPLD_MISC8,    // CPLD: cs3_b
                    MZ_CPLD_MISC9,    // CPLD: cs5_b
                    MZ_CPLD_MISC10,   // CPLD: nfio4
                    MZ_CPLD_MISC11,   // CPLD: nfio5
                    MZ_CPLD_MISC12,   // RAW r/w signal 
                    MZ_CPLD_MISC13,   // data_oe_b
                    MZ_CPLD_MISC14,   // Interrupt from FPGA to CPLD
                    LED,
                    DIP_SW
                );

// -------------------------------------------------------------------
// INPUTS
// -------------------------------------------------------------------

 
input                SYS_CLK;
input                MZ_CPLD_CLKO;
input                FPGA_CLK4;
input                FPGA_CLK3;
input                SYS_RST_N;
input                MZ_CPLD_RESET_OUT;
input [23:0]         MZ_BUF_ADDR;
input                MZ_CPLD_AS;   
input                MZ_CPLD_RW;
input [3:0]          MZ_CPLD_BYTE_N;
input [7:0]          DIP_SW;
input                MZ_CPLD_MISC0;
input                MZ_CPLD_MISC1;
input                MZ_CPLD_MISC2;
input                MZ_CPLD_MISC3;
input                MZ_CPLD_MISC4;
input                MZ_CPLD_MISC5;
input                MZ_CPLD_MISC6;
input                MZ_CPLD_MISC7;
input                MZ_CPLD_MISC8;
input                MZ_CPLD_MISC9;
input                MZ_CPLD_MISC10;
input                MZ_CPLD_MISC11;
input                MZ_CPLD_MISC12;

// -------------------------------------------------------------------
//    INOUTS
// -------------------------------------------------------------------

inout [31:0]         MZ_BUF_DATA;     // 32 bit data bus

// -------------------------------------------------------------------
//     OUTPUTS
// -------------------------------------------------------------------


output               FPGA_MZ_DTACK;   // DTACK back to Mezzanine State Machine
output [7:0]         LED;

output               MZ_CPLD_MISC13;
output               MZ_CPLD_MISC14;

// -------------------------------------------------------------------
//     REGISTERS
// -------------------------------------------------------------------

reg  [3:0]          count;           // Use to determine how long DTACK is asserted
reg                 dtack;           // Internal DTACK register

reg   [23:0]        latched_addr;
reg   [31:0]        latched_data;
reg   [31:0]        feedback_addr;

reg   [2:0]         state;
reg   [1:0]         as_sync;        // Sync Address Strobe from CPLD

reg                 ram_enable;     // Based on one hot enable signals
reg   [3:0]         ram_write;

reg [31:0] operand_a;
reg [31:0] operand_b;
reg [31:0] add_result;
reg [2:0]  add_state;
reg        add_req;
reg        add_ack;

// -------------------------------------------------------------------
//  DATA BUS ASSIGNMENTS
// -------------------------------------------------------------------


       // This assignment puts the latched address back out on the data lines.

//wire [31:0]     MZ_BUF_DATA = (MZ_CPLD_RW && MZ_CPLD_AS) ? latched_addr : 32'bz; 

       // This assignment puts the latched address back out on the data lines.
   
wire [31:0]     MZ_BUF_DATA = (MZ_CPLD_RW && MZ_CPLD_AS) ? latched_data : 32'bz; 


       // This assignment puts the SWITCHES back out on the data bus lines.

//wire [31:0]     MZ_BUF_DATA = (MZ_CPLD_RW && MZ_CPLD_AS) ? {4{DIP_SW}} : 32'bz;            

           
// -------------------------------------------------------------------
//  Continuous assignments and wires
// -------------------------------------------------------------------

assign          FPGA_MZ_DTACK = dtack;    // Drive DTACK to CPLD

wire            dtack_wishbone = 1'b1;    // DTACK from components on the Wishbone Bus.

assign          ram_wr = ram_write[0] && ram_write[1] && ram_write[2] && ram_write[3];


         
assign          buffered_clk = MZ_CPLD_CLKO;     // Clock from CPLD
//assign          buffered_clk = FPGA_CLK4;       // 27 MHz clock
//assign          buffered_clk = FPGA_CLK3;       // 100 MHz clock
//assign          buffered_clk = SYS_CLK;         // 24 MHz FPGA clock

// -------------------------------------------------------------------
//
//  BLOCK RAM instantiations
//
// -------------------------------------------------------------------

wire   [31:0]  ram_data;
wire   [3:0]   parity_out;

/*
RAMB16_S9 U_RAMB16_S9_X0Y0  (   
                 .DI(MZ_BUF_DATA[31:24]),  // 8-bit data_in bus
                 .DIP(1'b0),               // 4-bit parity data_in bus 
                 .ADDR(latched_addr[12:2]), // 11-bit address bus
                 .EN(ram_enable),          // RAM enable signal
                 .WE(ram_write[3]),        // Write enable signal
                 .SSR(1'b0),               // set/reset signal
                 .CLK(!buffered_clk ),     // clock signal
                 .DO(ram_data[31:24]),     // 8-bit data_out bus
                 .DOP(parity_out[3])       // 1-bit parity data_out bus 
			     );

RAMB16_S9 U_RAMB16_S9_B   (   
                 .DI(MZ_BUF_DATA[15:8]),   // 8-bit data_in bus
                 .DIP(1'b0),               // 4-bit parity data_in bus 
                 .ADDR(latched_addr[12:2]), // 11-bit address bus
                 .EN(ram_enable),          // RAM enable signal
                 .WE(ram_write[1]),        // Write enable signal
                 .SSR(1'b0),               // set/reset signal
                 .CLK(!buffered_clk ),     // clock signal
                 .DO(ram_data[15:8]),      // 8-bit data_out bus
                 .DOP(parity_out[1])       // 1-bit parity data_out bus 
			     );

RAMB16_S9 U_RAMB16_S9_C  (   
                 .DI(MZ_BUF_DATA[23:16]),  // 8-bit data_in bus
                 .DIP(1'b0),               // 4-bit parity data_in bus 
                 .ADDR(latched_addr[12:2]), // 11-bit address bus
                 .EN(ram_enable),          // RAM enable signal
                 .WE(ram_write[2]),        // Write enable signal
                 .SSR(1'b0),               // set/reset signal
                 .CLK(!buffered_clk ),     // clock signal
                 .DO(ram_data[23:16]),     // 8-bit data_out bus
                 .DOP(parity_out[2])       // 1-bit parity data_out bus 
			     );


RAMB16_S9 U_RAMB16_S9_A   (   
                 .DI(MZ_BUF_DATA[7:0]),    // 8-bit data_in bus
                 .DIP(1'b0),               // 4-bit parity data_in bus 
                 .ADDR(latched_addr[12:2]), // 11-bit address bus
                 .EN(ram_enable),          // RAM enable signal
                 .WE(ram_write[0]),        // Write enable signal
                 .SSR(1'b0),               // set/reset signal
                 .CLK(!buffered_clk ),     // clock signal
                 .DO(ram_data[7:0]),       // 8-bit data_out bus
                 .DOP(parity_out[0])       // 1-bit parity data_out bus 
			     );

*/

RAMB16_S36 U_RAMB16_S36 (   
                 .DI(MZ_BUF_DATA[31:0]),   // 32-bit data_in bus ([31:0])
                 .DIP(4'b0),               // 4-bit parity data_in bus ([35:32])
                 .ADDR(latched_addr[10:2]), // 9-bit address bus
                 .EN(ram_enable),          // RAM enable signal
                 .WE(ram_wr),              // Write enable signal
                 .SSR(1'b0),               // set/reset signal
                 .CLK(!buffered_clk ),     // clock signal
                 .DO(ram_data),            // 32-bit data_out bus ([31:0])
                 .DOP(parity_out)          // 4-bit parity data_out bus ([35:32])
                 );



// --------------------------------------------------------------------------
//
// Detect AS from CPLD - Synchronize through 2 flipflops. The CPLD is clocked
// at 64MHz and the FPGA is being clocked somewhere between 24MHz and 100MHz.
//
// --------------------------------------------------------------------------
  
always @(negedge buffered_clk or negedge SYS_RST_N) begin
            if (!SYS_RST_N)  begin             
                   as_sync[1:0] <= 2'b0;
            end

            else if (SYS_RST_N) begin 
                   as_sync[1] <= as_sync[0];        // sync
                   as_sync[0] <= MZ_CPLD_AS;        // Sample the input pin
                         
            end         
end

// --------------------------------------------------------------------------
// AS from CPLD is detected when both FF's have a high signal. Negated immediately.
// --------------------------------------------------------------------------

assign       as_detected = as_sync[1] &&
                           as_sync[0] &&
                           MZ_CPLD_AS;
 

// -------------------------------------------------------------------
//
// These assignments check that the switch and LEDS are working
// and then muxes various bus signals onto the LEDS for probing.
//
// -------------------------------------------------------------------

//assign          LED = DIP_SW;

/*
assign          LED = DIP_SW | 
                      {FPGA_MZ_DTACK, 
                       MZ_CPLD_AS, 
                       MZ_CPLD_RW,       
                       !MZ_CPLD_BYTE_N[3] && as_detected,
                       !MZ_CPLD_BYTE_N[2] && as_detected,
                       !MZ_CPLD_BYTE_N[1] && as_detected,
                       !MZ_CPLD_BYTE_N[0] && as_detected,
                       ram_enable
                       };
*/
/*              
assign          LED = DIP_SW | 
                      {dtack, 
                       MZ_CPLD_AS, 
                       as_detected,       
                       ram_write[3],
                       ram_write[2],
                       ram_write[1],
                       ram_write[0],
                       ram_enable
                       };
            
*/                      
/*
assign          LED = DIP_SW | 
                      {FPGA_MZ_DTACK, 
                       MZ_CPLD_AS, 
                       MZ_CPLD_MISC6,       // Chip Select 1
                       MZ_CPLD_MISC9,      // Chip Select 5
                       MZ_CPLD_RW,       
                       MZ_CPLD_MISC12,       // Raw RW signal
                       ram_enable,      
                       MZ_CPLD_MISC4
                       };

assign          LED = DIP_SW | 
                      {buffered_clk, 
                       MZ_CPLD_AS, 
                       MZ_CPLD_MISC6,       // Chip Select 1
                       MZ_CPLD_MISC9,      // Chip Select 5
                       MZ_CPLD_RW,       
                       MZ_CPLD_MISC12,       // Raw RW signal
                       ram_enable,      
                       MZ_CPLD_MISC4
                       };
*/

reg [3:0] counter;
reg [3:0] counter1;
reg signal;
reg signal1;

always @(posedge MZ_CPLD_CLKO)
begin
  if (!SYS_RST_N)  begin 
    counter <= 1'b0;
	 signal <= 1'b0;
  end
  else begin 
    counter <= (counter ==4'hf)?4'h0: (counter+1'b1);
	 if (counter ==4'hf ) signal <= ~signal;
  end
end

always @(posedge FPGA_CLK3)
begin
  if (!SYS_RST_N)  begin 
    counter1 <= 1'b0;
	 signal1 <= 1'b0;
  end
  else begin 
    counter1 <= (counter1 ==4'hf)?4'h0: (counter1+1'b1);
	 if (counter1 ==4'hf ) signal1 <= ~signal1;
  end
end


assign LED[0] = MZ_CPLD_CLKO;
assign LED[1] = DIP_SW[0] | FPGA_CLK3;
assign LED[2] = signal ;
assign LED[3] = signal1;

assign         MZ_CPLD_MISC14 = 1'b0;  // Interrupt from FPGA to CPLD
assign         MZ_CPLD_MISC13 = 1'b0;  // Undefined output to CPLD
 
// -----------------------------------------------------------------------------
//            STATE MACHINE
// -----------------------------------------------------------------------------
        

always @(posedge buffered_clk or negedge SYS_RST_N) begin

            if (!SYS_RST_N)  begin             // In RESET
                state            <= 3'b0;      // Start in State 0
                dtack            <= 1'b0;      // Negate dtack to CPLD                               
					 add_state        <= 3'b0;
             end
        
        // --------------------------------------------------------------
        // MAIN CONTROL LOOP  
        // --------------------------------------------------------------

            else if (SYS_RST_N) begin 

                 // --------------------------------------------------------------
                 //    STATE 0
                 // --------------------------------------------------------------

                    if ((as_detected) && (state == 3'b000)) begin
                        state          <= 3'b001;       // GOTO STATE 1
                        ram_enable     <= 1'b1;         // Assert RAM enable
                        latched_addr   <= MZ_BUF_ADDR;  // Latch address bus
                      end
                    
                    else if ((!as_detected) && (state == 3'b000)) begin
                        state          <= 3'b000;        // Stay in STATE 0
                        ram_enable     <= 1'b0;
                        dtack          <= 1'b0;          // Negate dtack
                    end

                 // --------------------------------------------------------------
                 //    STATE 1
                 // --------------------------------------------------------------

                    else if ((as_detected) && (state == 3'b001)) begin
                        state         <= 3'b010;      // GOTO STATE 2

                        ram_write[0]  <= !MZ_CPLD_MISC12 && !MZ_CPLD_BYTE_N[0];
                        ram_write[1]  <= !MZ_CPLD_MISC12 && !MZ_CPLD_BYTE_N[1];
                        ram_write[2]  <= !MZ_CPLD_MISC12 && !MZ_CPLD_BYTE_N[2];
                        ram_write[3]  <= !MZ_CPLD_MISC12 && !MZ_CPLD_BYTE_N[3];
                        
//                        ram_write[0]  <= !MZ_CPLD_RW && !MZ_CPLD_BYTE_N[0];
//                        ram_write[1]  <= !MZ_CPLD_RW && !MZ_CPLD_BYTE_N[1];
//                        ram_write[2]  <= !MZ_CPLD_RW && !MZ_CPLD_BYTE_N[2];
//                        ram_write[3]  <= !MZ_CPLD_RW && !MZ_CPLD_BYTE_N[3];
                    end
                        
                    else if ((!as_detected) && (state == 3'b001)) begin
                        state         <= 3'b100;     // GOTO  STATE 4
                    end
 
                 // --------------------------------------------------------------
                 //    STATE 2
                 // --------------------------------------------------------------

                    else if ((as_detected) && (state == 3'b010)) begin
                        state          <= 3'b011;      // GOTO STATE 3
                        ram_write[3:0] <= 4'b0;        // Disable writes to RAM

                    end

                    else if ((!as_detected) && (state == 3'b010)) begin
                        state         <= 3'b100;     // Go to STATE 4
                        dtack         <= 1'b0;       // Negate dtack to CPLD
                        ram_write     <= 4'b0;        // Disable writes to RAM

                        end  
  
                 // --------------------------------------------------------------
                 //    STATE 3
                 // --------------------------------------------------------------

                    else if ((!dtack_wishbone) && (state == 3'b011)) begin
                         state         <= 3'b011;      // STAY IN STATE 3
                    end

                    else if ((dtack_wishbone ) && (state == 3'b011)) begin
                        //state          <= 3'b100;    // GOTO  STATE 4

                        latched_data   <= (ram_data | {4{DIP_SW}});  // Read the data
/*
                        feedback_addr   <= {
                                           DIP_SW[7:0],
                                           MZ_CPLD_MISC6,
                                           MZ_CPLD_MISC9,
                                           MZ_CPLD_MISC10,
                                           MZ_CPLD_MISC12,
                                           MZ_BUF_ADDR[19:0]
                                           };
 */
								if((latched_addr[10:2] == 9'b0)) begin
									state <= 3'b110;
								end
								else begin
									state <= 3'b100;
								end
								
                    end
                    
             
                 // --------------------------------------------------------------
                 //    STATE 4
                 // --------------------------------------------------------------

 
                   else if ( state == 3'b100) begin
                        state           <= 3'b101;        // GOTO STATE 5
                        dtack           <= 1'b1;          // Assert dtack

                   end

             
                 // --------------------------------------------------------------
                 //    STATE 5
                 // --------------------------------------------------------------

                    else if (as_detected & ( state == 3'b101)) begin
                        state          <= 3'b101;        // Stay in STATE 5

                   end

                   else if (!as_detected & ( state == 3'b101)) begin
                        state           <= 3'b000;        // GOTO STATE 0
                        dtack           <= 1'b0;          // Negate dtack
                        ram_enable      <= 1'b0;

                   end
  
                 // --------------------------------------------------------------
                 //    STATE 6
                 // --------------------------------------------------------------
					  
							else if(state == 3'b110) begin
								if(add_state == 3'b000) begin
									ram_enable     <= 1'b1;         // Assert RAM enable
									latched_addr[10:2]   <= 9'h001;  // Latch address bus
									ram_write      <= 4'b0;
									add_state      <= 3'b001;
								end
								else if(add_state == 3'b001) begin
									operand_a      <= ram_data;
									add_state <= 3'b010;
								end
								else if(add_state == 3'b010) begin
									ram_enable     <= 1'b1;         // Assert RAM enable
									latched_addr[10:2]   <= 9'h002;  // Latch address bus
									ram_write      <= 4'b0;
									add_state      <= 3'b011;
								end
								else if(add_state == 3'b011) begin
									operand_b <= ram_data;
									add_state <= 3'b100;
								end
								else if(add_state == 3'b100) begin
									latched_data <= operand_a + operand_b;
									add_state <= 3'b0;
									ram_enable <= 1'b0;
									state <= 3'b100;
								end
							end
                                     
            end         //  END of MAIN CONTROL LOOP

     end          // END of State Machine LOOP


endmodule
