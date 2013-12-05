// ----------------------------------------------------------------------
//  HLS HDL:        Verilog Netlister
//  HLS Version:    2011a.50 Production Release
//  HLS Date:       Sun Jul  3 15:07:11 PDT 2011
// 
//  Generated by:   wodonnell@soc1
//  Generated date: Tue Dec  3 22:46:25 2013
// ----------------------------------------------------------------------

// 
module InitDecodemgc_rom_23_130_4 (addr, data_out
);
  input [7:0]addr ;
  output [3:0]data_out ;

  parameter rom_id = 23;
  parameter size = 130;
  parameter width = 4;

  reg [4-1:0] mem [130-1:0];
  // pragma attribute mem MEM_INIT_BLOCK rom_init_blk
  always@(addr) begin: rom_init_blk
    mem[0] = 4'b0001;
    mem[1] = 4'b0100;
    mem[2] = 4'b0001;
    mem[3] = 4'b0000;
    mem[4] = 4'b0000;
    mem[5] = 4'b0000;
    mem[6] = 4'b0000;
    mem[7] = 4'b0000;
    mem[8] = 4'b0000;
    mem[9] = 4'b0000;
    mem[10] = 4'b0011;
    mem[11] = 4'b1010;
    mem[12] = 4'b0001;
    mem[13] = 4'b0010;
    mem[14] = 4'b0010;
    mem[15] = 4'b0000;
    mem[16] = 4'b0000;
    mem[17] = 4'b0000;
    mem[18] = 4'b0000;
    mem[19] = 4'b0000;
    mem[20] = 4'b0001;
    mem[21] = 4'b0011;
    mem[22] = 4'b0010;
    mem[23] = 4'b0000;
    mem[24] = 4'b0000;
    mem[25] = 4'b0000;
    mem[26] = 4'b0000;
    mem[27] = 4'b0000;
    mem[28] = 4'b0000;
    mem[29] = 4'b0000;
    mem[30] = 4'b0100;
    mem[31] = 4'b1011;
    mem[32] = 4'b0010;
    mem[33] = 4'b0010;
    mem[34] = 4'b0010;
    mem[35] = 4'b0011;
    mem[36] = 4'b0000;
    mem[37] = 4'b0000;
    mem[38] = 4'b0000;
    mem[39] = 4'b0000;
    mem[40] = 4'b0001;
    mem[41] = 4'b0010;
    mem[42] = 4'b0011;
    mem[43] = 4'b0000;
    mem[44] = 4'b0000;
    mem[45] = 4'b0000;
    mem[46] = 4'b0000;
    mem[47] = 4'b0000;
    mem[48] = 4'b0000;
    mem[49] = 4'b0000;
    mem[50] = 4'b0100;
    mem[51] = 4'b0111;
    mem[52] = 4'b0011;
    mem[53] = 4'b0101;
    mem[54] = 4'b0011;
    mem[55] = 4'b0100;
    mem[56] = 4'b0000;
    mem[57] = 4'b0000;
    mem[58] = 4'b0000;
    mem[59] = 4'b0000;
    mem[60] = 4'b0011;
    mem[61] = 4'b0101;
    mem[62] = 4'b0011;
    mem[63] = 4'b0100;
    mem[64] = 4'b0011;
    mem[65] = 4'b0000;
    mem[66] = 4'b0000;
    mem[67] = 4'b0000;
    mem[68] = 4'b0000;
    mem[69] = 4'b0000;
    mem[70] = 4'b0010;
    mem[71] = 4'b0011;
    mem[72] = 4'b0011;
    mem[73] = 4'b0100;
    mem[74] = 4'b0000;
    mem[75] = 4'b0000;
    mem[76] = 4'b0000;
    mem[77] = 4'b0000;
    mem[78] = 4'b0000;
    mem[79] = 4'b0000;
    mem[80] = 4'b1000;
    mem[81] = 4'b1011;
    mem[82] = 4'b0011;
    mem[83] = 4'b0100;
    mem[84] = 4'b0100;
    mem[85] = 4'b0011;
    mem[86] = 4'b0100;
    mem[87] = 4'b0100;
    mem[88] = 4'b0011;
    mem[89] = 4'b0100;
    mem[90] = 4'b0011;
    mem[91] = 4'b0100;
    mem[92] = 4'b0011;
    mem[93] = 4'b0100;
    mem[94] = 4'b0100;
    mem[95] = 4'b0000;
    mem[96] = 4'b0000;
    mem[97] = 4'b0000;
    mem[98] = 4'b0000;
    mem[99] = 4'b0000;
    mem[100] = 4'b0100;
    mem[101] = 4'b0101;
    mem[102] = 4'b0011;
    mem[103] = 4'b0100;
    mem[104] = 4'b0100;
    mem[105] = 4'b0100;
    mem[106] = 4'b0000;
    mem[107] = 4'b0000;
    mem[108] = 4'b0000;
    mem[109] = 4'b0000;
    mem[110] = 4'b0111;
    mem[111] = 4'b1000;
    mem[112] = 4'b0011;
    mem[113] = 4'b0100;
    mem[114] = 4'b0100;
    mem[115] = 4'b0100;
    mem[116] = 4'b0100;
    mem[117] = 4'b0100;
    mem[118] = 4'b0100;
    mem[119] = 4'b0000;
    mem[120] = 4'b1000;
    mem[121] = 4'b1001;
    mem[122] = 4'b0011;
    mem[123] = 4'b0100;
    mem[124] = 4'b0100;
    mem[125] = 4'b0100;
    mem[126] = 4'b0100;
    mem[127] = 4'b0100;
    mem[128] = 4'b0100;
    mem[129] = 4'b0100;
  end

  reg [4-1:0] data_out_t;
  reg [7:0] addr_mx;
  always@(addr)
  begin
    if (addr >= 0 && addr < 130)
      addr_mx = addr;
    else
      addr_mx = {1'b0, addr[6:0]};
    data_out_t = mem[addr_mx];
  end
  assign data_out = data_out_t;

endmodule

