// ----------------------------------------------------------------------
//  HLS HDL:        Verilog Netlister
//  HLS Version:    2011a.50 Production Release
//  HLS Date:       Sun Jul  3 15:07:11 PDT 2011
// 
//  Generated by:   wodonnell@soc3
//  Generated date: Sat Nov 23 21:59:24 2013
// ----------------------------------------------------------------------

// 
module InitDecodemgc_rom_18_32_4 (addr, data_out
);
  input [4:0]addr ;
  output [3:0]data_out ;

  parameter rom_id = 18;
  parameter size = 32;
  parameter width = 4;

  reg [4-1:0] mem [32-1:0];
  // pragma attribute mem MEM_INIT_BLOCK rom_init_blk
  always@(addr) begin: rom_init_blk
    mem[0] = 4'b0000;
    mem[1] = 4'b0110;
    mem[2] = 4'b1011;
    mem[3] = 4'b1101;
    mem[4] = 4'b1011;
    mem[5] = 4'b1101;
    mem[6] = 4'b0000;
    mem[7] = 4'b0110;
    mem[8] = 4'b0100;
    mem[9] = 4'b0010;
    mem[10] = 4'b1111;
    mem[11] = 4'b1001;
    mem[12] = 4'b1111;
    mem[13] = 4'b1001;
    mem[14] = 4'b0100;
    mem[15] = 4'b0010;
    mem[16] = 4'b1001;
    mem[17] = 4'b1111;
    mem[18] = 4'b0010;
    mem[19] = 4'b0100;
    mem[20] = 4'b0010;
    mem[21] = 4'b0100;
    mem[22] = 4'b1001;
    mem[23] = 4'b1111;
    mem[24] = 4'b1101;
    mem[25] = 4'b1011;
    mem[26] = 4'b0110;
    mem[27] = 4'b0000;
    mem[28] = 4'b0110;
    mem[29] = 4'b0000;
    mem[30] = 4'b1101;
    mem[31] = 4'b1011;
  end

  reg [4-1:0] data_out_t;
  always@(addr)
  begin
    data_out_t = mem[addr];
  end
  assign data_out = data_out_t;

endmodule

