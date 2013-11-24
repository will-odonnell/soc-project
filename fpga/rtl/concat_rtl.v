
//------> ./rtl_mgc_ioport.v 
//------------------------------------------------------------------
//                M G C _ I O P O R T _ C O M P S
//------------------------------------------------------------------

//------------------------------------------------------------------
//                       M O D U L E S
//------------------------------------------------------------------

//------------------------------------------------------------------
//-- INPUT ENTITIES
//------------------------------------------------------------------

module mgc_in_wire (d, z);

  parameter integer rscid = 1;
  parameter integer width = 8;

  output [width-1:0] d;
  input  [width-1:0] z;

  wire   [width-1:0] d;

  assign d = z;

endmodule

//------------------------------------------------------------------

module mgc_in_wire_en (ld, d, lz, z);

  parameter integer rscid = 1;
  parameter integer width = 8;

  input              ld;
  output [width-1:0] d;
  output             lz;
  input  [width-1:0] z;

  wire   [width-1:0] d;
  wire               lz;

  assign d = z;
  assign lz = ld;

endmodule

//------------------------------------------------------------------

module mgc_in_wire_wait (ld, vd, d, lz, vz, z);

  parameter integer rscid = 1;
  parameter integer width = 8;

  input              ld;
  output             vd;
  output [width-1:0] d;
  output             lz;
  input              vz;
  input  [width-1:0] z;

  wire               vd;
  wire   [width-1:0] d;
  wire               lz;

  assign d = z;
  assign lz = ld;
  assign vd = vz;

endmodule
//------------------------------------------------------------------

module mgc_chan_in (ld, vd, d, lz, vz, z, size, req_size, sizez, sizelz);

  parameter integer rscid = 1;
  parameter integer width = 8;
  parameter integer sz_width = 8;

  input              ld;
  output             vd;
  output [width-1:0] d;
  output             lz;
  input              vz;
  input  [width-1:0] z;
  output [sz_width-1:0] size;
  input              req_size;
  input  [sz_width-1:0] sizez;
  output             sizelz;


  wire               vd;
  wire   [width-1:0] d;
  wire               lz;
  wire   [sz_width-1:0] size;
  wire               sizelz;

  assign d = z;
  assign lz = ld;
  assign vd = vz;
  assign size = sizez;
  assign sizelz = req_size;

endmodule


//------------------------------------------------------------------
//-- OUTPUT ENTITIES
//------------------------------------------------------------------

module mgc_out_stdreg (d, z);

  parameter integer rscid = 1;
  parameter integer width = 8;

  input    [width-1:0] d;
  output   [width-1:0] z;

  wire     [width-1:0] z;

  assign z = d;

endmodule

//------------------------------------------------------------------

module mgc_out_stdreg_en (ld, d, lz, z);

  parameter integer rscid = 1;
  parameter integer width = 8;

  input              ld;
  input  [width-1:0] d;
  output             lz;
  output [width-1:0] z;

  wire               lz;
  wire   [width-1:0] z;

  assign z = d;
  assign lz = ld;

endmodule

//------------------------------------------------------------------

module mgc_out_stdreg_wait (ld, vd, d, lz, vz, z);

  parameter integer rscid = 1;
  parameter integer width = 8;

  input              ld;
  output             vd;
  input  [width-1:0] d;
  output             lz;
  input              vz;
  output [width-1:0] z;

  wire               vd;
  wire               lz;
  wire   [width-1:0] z;

  assign z = d;
  assign lz = ld;
  assign vd = vz;

endmodule

//------------------------------------------------------------------

module mgc_out_prereg_en (ld, d, lz, z);

    parameter integer rscid = 1;
    parameter integer width = 8;

    input              ld;
    input  [width-1:0] d;
    output             lz;
    output [width-1:0] z;

    wire               lz;
    wire   [width-1:0] z;

    assign z = d;
    assign lz = ld;

endmodule

//------------------------------------------------------------------
//-- INOUT ENTITIES
//------------------------------------------------------------------

module mgc_inout_stdreg_en (ldin, din, ldout, dout, lzin, lzout, z);

    parameter integer rscid = 1;
    parameter integer width = 8;

    input              ldin;
    output [width-1:0] din;
    input              ldout;
    input  [width-1:0] dout;
    output             lzin;
    output             lzout;
    inout  [width-1:0] z;

    wire   [width-1:0] din;
    wire               lzin;
    wire               lzout;
    wire   [width-1:0] z;

    assign lzin = ldin;
    assign din = ldin ? z : {width{1'bz}};
    assign lzout = ldout;
    assign z = ldout ? dout : {width{1'bz}};

endmodule

//------------------------------------------------------------------
module hid_tribuf( I_SIG, ENABLE, O_SIG);
  parameter integer width = 8;

  input [width-1:0] I_SIG;
  input ENABLE;
  inout [width-1:0] O_SIG;

  assign O_SIG = (ENABLE) ? I_SIG : { width{1'bz}};

endmodule
//------------------------------------------------------------------

module mgc_inout_stdreg_wait (ldin, vdin, din, ldout, vdout, dout, lzin, vzin, lzout, vzout, z);

    parameter integer rscid = 1;
    parameter integer width = 8;

    input              ldin;
    output             vdin;
    output [width-1:0] din;
    input              ldout;
    output             vdout;
    input  [width-1:0] dout;
    output             lzin;
    input              vzin;
    output             lzout;
    input              vzout;
    inout  [width-1:0] z;

    wire               vdin;
    wire   [width-1:0] din;
    wire               vdout;
    wire               lzin;
    wire               lzout;
    wire   [width-1:0] z;
    wire   ldout_and_vzout;

    assign lzin = ldin;
    assign vdin = vzin;
    assign din = ldin ? z : {width{1'bz}};
    assign lzout = ldout;
    assign vdout = vzout ;
    assign ldout_and_vzout = ldout && vzout ;

    hid_tribuf #(width) tb( .I_SIG(dout),
                            .ENABLE(ldout_and_vzout),
                            .O_SIG(z) );

endmodule

//------------------------------------------------------------------

module mgc_inout_buf_wait (clk, en, arst, srst, ldin, vdin, din, ldout, vdout, dout, lzin, vzin, lzout, vzout, z);

    parameter integer rscid   = 0; // resource ID
    parameter integer width   = 8; // fifo width
    parameter         ph_clk  =  1'b1; // clock polarity 1=rising edge, 0=falling edge
    parameter         ph_en   =  1'b1; // clock enable polarity
    parameter         ph_arst =  1'b1; // async reset polarity
    parameter         ph_srst =  1'b1; // sync reset polarity

    input              clk;
    input              en;
    input              arst;
    input              srst;
    input              ldin;
    output             vdin;
    output [width-1:0] din;
    input              ldout;
    output             vdout;
    input  [width-1:0] dout;
    output             lzin;
    input              vzin;
    output             lzout;
    input              vzout;
    inout  [width-1:0] z;

    wire               lzout_buf;
    wire               vzout_buf;
    wire   [width-1:0] z_buf;
    wire               vdin;
    wire   [width-1:0] din;
    wire               vdout;
    wire               lzin;
    wire               lzout;
    wire   [width-1:0] z;

    assign lzin = ldin;
    assign vdin = vzin;
    assign din = ldin ? z : {width{1'bz}};
    assign lzout = lzout_buf & ~ldin;
    assign vzout_buf = vzout & ~ldin;
    hid_tribuf #(width) tb( .I_SIG(z_buf),
                            .ENABLE((lzout_buf && (!ldin) && vzout) ),
                            .O_SIG(z)  );

    mgc_out_buf_wait
    #(
        .rscid   (rscid),
        .width   (width),
        .ph_clk  (ph_clk),
        .ph_en   (ph_en),
        .ph_arst (ph_arst),
        .ph_srst (ph_srst)
    )
    BUFF
    (
        .clk     (clk),
        .en      (en),
        .arst    (arst),
        .srst    (srst),
        .ld      (ldout),
        .vd      (vdout),
        .d       (dout),
        .lz      (lzout_buf),
        .vz      (vzout_buf),
        .z       (z_buf)
    );


endmodule

module mgc_inout_fifo_wait (clk, en, arst, srst, ldin, vdin, din, ldout, vdout, dout, lzin, vzin, lzout, vzout, z);

    parameter integer rscid   = 0; // resource ID
    parameter integer width   = 8; // fifo width
    parameter integer fifo_sz = 8; // fifo depth
    parameter         ph_clk  = 1'b1;  // clock polarity 1=rising edge, 0=falling edge
    parameter         ph_en   = 1'b1;  // clock enable polarity
    parameter         ph_arst = 1'b1;  // async reset polarity
    parameter         ph_srst = 1'b1;  // sync reset polarity
    parameter integer ph_log2 = 3;     // log2(fifo_sz)
    parameter integer pwropt  = 0;     // pwropt

    input              clk;
    input              en;
    input              arst;
    input              srst;
    input              ldin;
    output             vdin;
    output [width-1:0] din;
    input              ldout;
    output             vdout;
    input  [width-1:0] dout;
    output             lzin;
    input              vzin;
    output             lzout;
    input              vzout;
    inout  [width-1:0] z;

    wire               lzout_buf;
    wire               vzout_buf;
    wire   [width-1:0] z_buf;
    wire               comb;
    wire               vdin;
    wire   [width-1:0] din;
    wire               vdout;
    wire               lzin;
    wire               lzout;
    wire   [width-1:0] z;

    assign lzin = ldin;
    assign vdin = vzin;
    assign din = ldin ? z : {width{1'bz}};
    assign lzout = lzout_buf & ~ldin;
    assign vzout_buf = vzout & ~ldin;
    assign comb = (lzout_buf && (!ldin) && vzout);

    hid_tribuf #(width) tb2( .I_SIG(z_buf), .ENABLE(comb), .O_SIG(z)  );

    mgc_out_fifo_wait
    #(
        .rscid   (rscid),
        .width   (width),
        .fifo_sz (fifo_sz),
        .ph_clk  (ph_clk),
        .ph_en   (ph_en),
        .ph_arst (ph_arst),
        .ph_srst (ph_srst),
        .ph_log2 (ph_log2),
        .pwropt  (pwropt)
    )
    FIFO
    (
        .clk   (clk),
        .en      (en),
        .arst    (arst),
        .srst    (srst),
        .ld      (ldout),
        .vd      (vdout),
        .d       (dout),
        .lz      (lzout_buf),
        .vz      (vzout_buf),
        .z       (z_buf)
    );

endmodule

//------------------------------------------------------------------
//-- I/O SYNCHRONIZATION ENTITIES
//------------------------------------------------------------------

module mgc_io_sync (ld, lz);

    input  ld;
    output lz;

    assign lz = ld;

endmodule

module mgc_bsync_rdy (rd, rz);

    parameter integer rscid   = 0; // resource ID
    parameter ready = 1;
    parameter valid = 0;

    input  rd;
    output rz;

    wire   rz;

    assign rz = rd;

endmodule

module mgc_bsync_vld (vd, vz);

    parameter integer rscid   = 0; // resource ID
    parameter ready = 0;
    parameter valid = 1;

    output vd;
    input  vz;

    wire   vd;

    assign vd = vz;

endmodule

module mgc_bsync_rv (rd, vd, rz, vz);

    parameter integer rscid   = 0; // resource ID
    parameter ready = 1;
    parameter valid = 1;

    input  rd;
    output vd;
    output rz;
    input  vz;

    wire   vd;
    wire   rz;

    assign rz = rd;
    assign vd = vz;

endmodule

//------------------------------------------------------------------

module mgc_sync (ldin, vdin, ldout, vdout);

  input  ldin;
  output vdin;
  input  ldout;
  output vdout;

  wire   vdin;
  wire   vdout;

  assign vdin = ldout;
  assign vdout = ldin;

endmodule

///////////////////////////////////////////////////////////////////////////////
// dummy function used to preserve funccalls for modulario
// it looks like a memory read to the caller
///////////////////////////////////////////////////////////////////////////////
module funccall_inout (d, ad, bd, z, az, bz);

  parameter integer ram_id = 1;
  parameter integer width = 8;
  parameter integer addr_width = 8;

  output [width-1:0]       d;
  input  [addr_width-1:0]  ad;
  input                    bd;
  input  [width-1:0]       z;
  output [addr_width-1:0]  az;
  output                   bz;

  wire   [width-1:0]       d;
  wire   [addr_width-1:0]  az;
  wire                     bz;

  assign d  = z;
  assign az = ad;
  assign bz = bd;

endmodule


///////////////////////////////////////////////////////////////////////////////
// inlinable modular io not otherwise found in mgc_ioport
///////////////////////////////////////////////////////////////////////////////

module modulario_en_in (vd, d, vz, z);

  parameter integer rscid = 1;
  parameter integer width = 8;

  output             vd;
  output [width-1:0] d;
  input              vz;
  input  [width-1:0] z;

  wire   [width-1:0] d;
  wire               vd;

  assign d = z;
  assign vd = vz;

endmodule

//------> ./rtl_mgc_ioport_v2001.v 
//------------------------------------------------------------------

module mgc_out_reg_pos (clk, en, arst, srst, ld, d, lz, z);

    parameter integer rscid   = 1;
    parameter integer width   = 8;
    parameter         ph_en   =  1'b1;
    parameter         ph_arst =  1'b1;
    parameter         ph_srst =  1'b1;

    input              clk;
    input              en;
    input              arst;
    input              srst;
    input              ld;
    input  [width-1:0] d;
    output             lz;
    output [width-1:0] z;

    reg                lz;
    reg    [width-1:0] z;

    generate
    if (ph_arst == 1'b0)
    begin: NEG_ARST
        always @(posedge clk or negedge arst)
        if (arst == 1'b0)
        begin: B1
            lz <= 1'b0;
            z  <= {width{1'b0}};
        end
        else if (srst == ph_srst)
        begin: B2
            lz <= 1'b0;
            z  <= {width{1'b0}};
        end
        else if (en == ph_en)
        begin: B3
            lz <= ld;
            z  <= (ld) ? d : z;
        end
    end
    else
    begin: POS_ARST
        always @(posedge clk or posedge arst)
        if (arst == 1'b1)
        begin: B1
            lz <= 1'b0;
            z  <= {width{1'b0}};
        end
        else if (srst == ph_srst)
        begin: B2
            lz <= 1'b0;
            z  <= {width{1'b0}};
        end
        else if (en == ph_en)
        begin: B3
            lz <= ld;
            z  <= (ld) ? d : z;
        end
    end
    endgenerate

endmodule

//------------------------------------------------------------------

module mgc_out_reg_neg (clk, en, arst, srst, ld, d, lz, z);

    parameter integer rscid   = 1;
    parameter integer width   = 8;
    parameter         ph_en   =  1'b1;
    parameter         ph_arst =  1'b1;
    parameter         ph_srst =  1'b1;

    input              clk;
    input              en;
    input              arst;
    input              srst;
    input              ld;
    input  [width-1:0] d;
    output             lz;
    output [width-1:0] z;

    reg                lz;
    reg    [width-1:0] z;

    generate
    if (ph_arst == 1'b0)
    begin: NEG_ARST
        always @(negedge clk or negedge arst)
        if (arst == 1'b0)
        begin: B1
            lz <= 1'b0;
            z  <= {width{1'b0}};
        end
        else if (srst == ph_srst)
        begin: B2
            lz <= 1'b0;
            z  <= {width{1'b0}};
        end
        else if (en == ph_en)
        begin: B3
            lz <= ld;
            z  <= (ld) ? d : z;
        end
    end
    else
    begin: POS_ARST
        always @(negedge clk or posedge arst)
        if (arst == 1'b1)
        begin: B1
            lz <= 1'b0;
            z  <= {width{1'b0}};
        end
        else if (srst == ph_srst)
        begin: B2
            lz <= 1'b0;
            z  <= {width{1'b0}};
        end
        else if (en == ph_en)
        begin: B3
            lz <= ld;
            z  <= (ld) ? d : z;
        end
    end
    endgenerate

endmodule

//------------------------------------------------------------------

module mgc_out_reg (clk, en, arst, srst, ld, d, lz, z); // Not Supported

    parameter integer rscid   = 1;
    parameter integer width   = 8;
    parameter         ph_clk  =  1'b1;
    parameter         ph_en   =  1'b1;
    parameter         ph_arst =  1'b1;
    parameter         ph_srst =  1'b1;

    input              clk;
    input              en;
    input              arst;
    input              srst;
    input              ld;
    input  [width-1:0] d;
    output             lz;
    output [width-1:0] z;


    generate
    if (ph_clk == 1'b0)
    begin: NEG_EDGE

        mgc_out_reg_neg
        #(
            .rscid   (rscid),
            .width   (width),
            .ph_en   (ph_en),
            .ph_arst (ph_arst),
            .ph_srst (ph_srst)
        )
        mgc_out_reg_neg_inst
        (
            .clk     (clk),
            .en      (en),
            .arst    (arst),
            .srst    (srst),
            .ld      (ld),
            .d       (d),
            .lz      (lz),
            .z       (z)
        );

    end
    else
    begin: POS_EDGE

        mgc_out_reg_pos
        #(
            .rscid   (rscid),
            .width   (width),
            .ph_en   (ph_en),
            .ph_arst (ph_arst),
            .ph_srst (ph_srst)
        )
        mgc_out_reg_pos_inst
        (
            .clk     (clk),
            .en      (en),
            .arst    (arst),
            .srst    (srst),
            .ld      (ld),
            .d       (d),
            .lz      (lz),
            .z       (z)
        );

    end
    endgenerate

endmodule




//------------------------------------------------------------------

module mgc_out_buf_wait (clk, en, arst, srst, ld, vd, d, vz, lz, z); // Not supported

    parameter integer rscid   = 1;
    parameter integer width   = 8;
    parameter         ph_clk  =  1'b1;
    parameter         ph_en   =  1'b1;
    parameter         ph_arst =  1'b1;
    parameter         ph_srst =  1'b1;

    input              clk;
    input              en;
    input              arst;
    input              srst;
    input              ld;
    output             vd;
    input  [width-1:0] d;
    output             lz;
    input              vz;
    output [width-1:0] z;

    wire               filled;
    wire               filled_next;
    wire   [width-1:0] abuf;
    wire               lbuf;


    assign filled_next = (filled & (~vz)) | (filled & ld) | (ld & (~vz));

    assign lbuf = ld & ~(filled ^ vz);

    assign vd = vz | ~filled;

    assign lz = ld | filled;

    assign z = (filled) ? abuf : d;

    wire dummy;
    wire dummy_bufreg_lz;

    // Output registers:
    mgc_out_reg
    #(
        .rscid   (rscid),
        .width   (1'b1),
        .ph_clk  (ph_clk),
        .ph_en   (ph_en),
        .ph_arst (ph_arst),
        .ph_srst (ph_srst)
    )
    STATREG
    (
        .clk     (clk),
        .en      (en),
        .arst    (arst),
        .srst    (srst),
        .ld      (filled_next),
        .d       (1'b0),       // input d is unused
        .lz      (filled),
        .z       (dummy)            // output z is unused
    );

    mgc_out_reg
    #(
        .rscid   (rscid),
        .width   (width),
        .ph_clk  (ph_clk),
        .ph_en   (ph_en),
        .ph_arst (ph_arst),
        .ph_srst (ph_srst)
    )
    BUFREG
    (
        .clk     (clk),
        .en      (en),
        .arst    (arst),
        .srst    (srst),
        .ld      (lbuf),
        .d       (d),
        .lz      (dummy_bufreg_lz),
        .z       (abuf)
    );

endmodule

//------------------------------------------------------------------

module mgc_out_fifo_wait (clk, en, arst, srst, ld, vd, d, lz, vz,  z);

    parameter integer rscid   = 0; // resource ID
    parameter integer width   = 8; // fifo width
    parameter integer fifo_sz = 8; // fifo depth
    parameter         ph_clk  = 1'b1; // clock polarity 1=rising edge, 0=falling edge
    parameter         ph_en   = 1'b1; // clock enable polarity
    parameter         ph_arst = 1'b1; // async reset polarity
    parameter         ph_srst = 1'b1; // sync reset polarity
    parameter integer ph_log2 = 3; // log2(fifo_sz)
    parameter integer pwropt  = 0; // pwropt


    input                 clk;
    input                 en;
    input                 arst;
    input                 srst;
    input                 ld;    // load data
    output                vd;    // fifo full active low
    input     [width-1:0] d;
    output                lz;    // fifo ready to send
    input                 vz;    // dest ready for data
    output    [width-1:0] z;

    wire    [31:0]      size;


      // Output registers:
 mgc_out_fifo_wait_core#(
        .rscid   (rscid),
        .width   (width),
        .sz_width (32),
        .fifo_sz (fifo_sz),
        .ph_clk  (ph_clk),
        .ph_en   (ph_en),
        .ph_arst (ph_arst),
        .ph_srst (ph_srst),
        .ph_log2 (ph_log2),
        .pwropt  (pwropt)
        ) CORE (
        .clk (clk),
        .en (en),
        .arst (arst),
        .srst (srst),
        .ld (ld),
        .vd (vd),
        .d (d),
        .lz (lz),
        .vz (vz),
        .z (z),
        .size (size)
        );

endmodule



module mgc_out_fifo_wait_core (clk, en, arst, srst, ld, vd, d, lz, vz,  z, size);

    parameter integer rscid   = 0; // resource ID
    parameter integer width   = 8; // fifo width
    parameter integer sz_width = 8; // size of port for elements in fifo
    parameter integer fifo_sz = 8; // fifo depth
    parameter         ph_clk  =  1'b1; // clock polarity 1=rising edge, 0=falling edge
    parameter         ph_en   =  1'b1; // clock enable polarity
    parameter         ph_arst =  1'b1; // async reset polarity
    parameter         ph_srst =  1'b1; // sync reset polarity
    parameter integer ph_log2 = 3; // log2(fifo_sz)
    parameter integer pwropt  = 0; // pwropt

   localparam integer  fifo_b = width * fifo_sz;

    input                 clk;
    input                 en;
    input                 arst;
    input                 srst;
    input                 ld;    // load data
    output                vd;    // fifo full active low
    input     [width-1:0] d;
    output                lz;    // fifo ready to send
    input                 vz;    // dest ready for data
    output    [width-1:0] z;
    output    [sz_width-1:0]      size;

    reg      [( (fifo_sz > 0) ? fifo_sz : 1)-1:0] stat_pre;
    wire     [( (fifo_sz > 0) ? fifo_sz : 1)-1:0] stat;
    reg      [( (fifo_b > 0) ? fifo_b : 1)-1:0] buff_pre;
    wire     [( (fifo_b > 0) ? fifo_b : 1)-1:0] buff;
    reg      [( (fifo_sz > 0) ? fifo_sz : 1)-1:0] en_l;
    reg      [(((fifo_sz > 0) ? fifo_sz : 1)-1)/8:0] en_l_s;

    reg       [width-1:0] buff_nxt;

    reg                   stat_nxt;
    reg                   stat_before;
    reg                   stat_after;
    reg                   en_l_var;

    integer               i;
    genvar                eni;

    integer               count;
    integer               count_t;
    integer               n_elem;
// pragma translate_off
    integer               peak;
// pragma translate_on

    wire [( (fifo_sz > 0) ? fifo_sz : 1)-1:0] dummy_statreg_lz;
    wire [( (fifo_b > 0) ? fifo_b : 1)-1:0] dummy_bufreg_lz;

    generate
    if ( fifo_sz > 0 )
    begin: FIFO_REG
      assign vd = vz | ~stat[0];
      assign lz = ld | stat[fifo_sz-1];
      assign size = (count - (vz && stat[fifo_sz-1])) + ld;
      assign z = (stat[fifo_sz-1]) ? buff[fifo_b-1:width*(fifo_sz-1)] : d;

      always @(*)
      begin: FIFOPROC
        n_elem = 0;
        for (i = fifo_sz-1; i >= 0; i = i - 1)
        begin
          if (i != 0)
            stat_before = stat[i-1];
          else
            stat_before = 1'b0;

          if (i != (fifo_sz-1))
            stat_after = stat[i+1];
          else
            stat_after = 1'b1;

          stat_nxt = stat_after &
                    (stat_before | (stat[i] & (~vz)) | (stat[i] & ld) | (ld & (~vz)));

          stat_pre[i] = stat_nxt;
          en_l_var = 1'b1;
          if (!stat_nxt)
            begin
              buff_nxt = {width{1'b0}};
              en_l_var = 1'b0;
            end
          else if (vz && stat_before)
            buff_nxt[0+:width] = buff[width*(i-1)+:width];
          else if (ld && !((vz && stat_before) || ((!vz) && stat[i])))
            buff_nxt = d;
          else
            begin
              if (pwropt == 0)
                buff_nxt[0+:width] = buff[width*i+:width];
              else
                buff_nxt = {width{1'b0}};
              en_l_var = 1'b0;
            end

          if (ph_en != 0)
            en_l[i] = en & en_l_var;
          else
            en_l[i] = en | ~en_l_var;

          buff_pre[width*i+:width] = buff_nxt[0+:width];

          if ((stat_after == 1'b1) && (stat[i] == 1'b0))
            n_elem = (fifo_sz - 1) - i;
        end

        if (ph_en != 0)
          en_l_s[(((fifo_sz > 0) ? fifo_sz : 1)-1)/8] = 1'b1;
        else
          en_l_s[(((fifo_sz > 0) ? fifo_sz : 1)-1)/8] = 1'b0;

        for (i = fifo_sz-1; i >= 7; i = i - 1)
        begin
          if ((i%2) == 0)
          begin
            if (ph_en != 0)
              en_l_s[(i/8)-1] = en & (stat[i]|stat_pre[i-1]);
            else
              en_l_s[(i/8)-1] = en | ~(stat[i]|stat_pre[i-1]);
          end
        end

        if ( stat[fifo_sz-1] == 1'b0 )
          count_t = 0;
        else if ( stat[0] == 1'b1 )
          count_t = fifo_sz;
        else
          count_t = n_elem;
        count = count_t;
// pragma translate_off
        if ( peak < count )
          peak = count;
// pragma translate_on
      end

      if (pwropt == 0)
      begin: NOCGFIFO
        // Output registers:
        mgc_out_reg
        #(
            .rscid   (rscid),
            .width   (fifo_sz),
            .ph_clk  (ph_clk),
            .ph_en   (ph_en),
            .ph_arst (ph_arst),
            .ph_srst (ph_srst)
        )
        STATREG
        (
            .clk     (clk),
            .en      (en),
            .arst    (arst),
            .srst    (srst),
            .ld      (1'b1),
            .d       (stat_pre),
            .lz      (dummy_statreg_lz[0]),
            .z       (stat)
        );
        mgc_out_reg
        #(
            .rscid   (rscid),
            .width   (fifo_b),
            .ph_clk  (ph_clk),
            .ph_en   (ph_en),
            .ph_arst (ph_arst),
            .ph_srst (ph_srst)
        )
        BUFREG
        (
            .clk     (clk),
            .en      (en),
            .arst    (arst),
            .srst    (srst),
            .ld      (1'b1),
            .d       (buff_pre),
            .lz      (dummy_bufreg_lz[0]),
            .z       (buff)
        );
      end
      else
      begin: CGFIFO
        // Output registers:
        if ( pwropt > 1)
        begin: CGSTATFIFO2
          for (eni = fifo_sz-1; eni >= 0; eni = eni - 1)
          begin: pwroptGEN1
            mgc_out_reg
            #(
              .rscid   (rscid),
              .width   (1),
              .ph_clk  (ph_clk),
              .ph_en   (ph_en),
              .ph_arst (ph_arst),
              .ph_srst (ph_srst)
            )
            STATREG
            (
              .clk     (clk),
              .en      (en_l_s[eni/8]),
              .arst    (arst),
              .srst    (srst),
              .ld      (1'b1),
              .d       (stat_pre[eni]),
              .lz      (dummy_statreg_lz[eni]),
              .z       (stat[eni])
            );
          end
        end
        else
        begin: CGSTATFIFO
          mgc_out_reg
          #(
            .rscid   (rscid),
            .width   (fifo_sz),
            .ph_clk  (ph_clk),
            .ph_en   (ph_en),
            .ph_arst (ph_arst),
            .ph_srst (ph_srst)
          )
          STATREG
          (
            .clk     (clk),
            .en      (en),
            .arst    (arst),
            .srst    (srst),
            .ld      (1'b1),
            .d       (stat_pre),
            .lz      (dummy_statreg_lz[0]),
            .z       (stat)
          );
        end
        for (eni = fifo_sz-1; eni >= 0; eni = eni - 1)
        begin: pwroptGEN2
          mgc_out_reg
          #(
            .rscid   (rscid),
            .width   (width),
            .ph_clk  (ph_clk),
            .ph_en   (ph_en),
            .ph_arst (ph_arst),
            .ph_srst (ph_srst)
          )
          BUFREG
          (
            .clk     (clk),
            .en      (en_l[eni]),
            .arst    (arst),
            .srst    (srst),
            .ld      (1'b1),
            .d       (buff_pre[width*eni+:width]),
            .lz      (dummy_bufreg_lz[width*eni+:width]),
            .z       (buff[width*eni+:width])
          );
        end
      end
    end
    else
    begin: FEED_THRU
      assign vd = vz;
      assign lz = ld;
      assign z = d;
      assign size = ld && !vz;
    end
    endgenerate

endmodule

//------------------------------------------------------------------
//-- PIPE ENTITIES
//------------------------------------------------------------------
/*
 *
 *             _______________________________________________
 * WRITER    |                                               |          READER
 *           |           MGC_PIPE                            |
 *           |           __________________________          |
 *        --<| vdout  --<| vd ---------------  vz<|-----ldin<|---
 *           |           |      FIFO              |          |
 *        ---|>ldout  ---|>ld ---------------- lz |> ---vdin |>--
 *        ---|>dout -----|>d  ---------------- dz |> ----din |>--
 *           |           |________________________|          |
 *           |_______________________________________________|
 */
// two clock pipe
module mgc_pipe (clk, en, arst, srst, ldin, vdin, din, ldout, vdout, dout, size, req_size);

    parameter integer rscid   = 0; // resource ID
    parameter integer width   = 8; // fifo width
    parameter integer sz_width = 8; // width of size of elements in fifo
    parameter integer fifo_sz = 8; // fifo depth
    parameter integer log2_sz = 3; // log2(fifo_sz)
    parameter         ph_clk  = 1'b1;  // clock polarity 1=rising edge, 0=falling edge
    parameter         ph_en   = 1'b1;  // clock enable polarity
    parameter         ph_arst = 1'b1;  // async reset polarity
    parameter         ph_srst = 1'b1;  // sync reset polarity
    parameter integer pwropt  = 0; // pwropt

    input              clk;
    input              en;
    input              arst;
    input              srst;
    input              ldin;
    output             vdin;
    output [width-1:0] din;
    input              ldout;
    output             vdout;
    input  [width-1:0] dout;
    output [sz_width-1:0]      size;
    input              req_size;


    mgc_out_fifo_wait_core
    #(
        .rscid    (rscid),
        .width    (width),
        .sz_width (sz_width),
        .fifo_sz  (fifo_sz),
        .ph_clk   (ph_clk),
        .ph_en    (ph_en),
        .ph_arst  (ph_arst),
        .ph_srst  (ph_srst),
        .ph_log2  (log2_sz),
        .pwropt   (pwropt)
    )
    FIFO
    (
        .clk     (clk),
        .en      (en),
        .arst    (arst),
        .srst    (srst),
        .ld      (ldout),
        .vd      (vdout),
        .d       (dout),
        .lz      (vdin),
        .vz      (ldin),
        .z       (din),
        .size    (size)
    );

endmodule


//------> /misc/linuxws/packages/mentor_2011/catapult/Mgc_home/pkgs/hls_pkgs/mgc_comps_src/mgc_generic_reg_beh.v 
`define POS_CLK_POS_ASYNC 0
`define POS_CLK_NEG_ASYNC 1
`define NEG_CLK_POS_ASYNC 2
`define NEG_CLK_NEG_ASYNC 3
`define POS_CLK_NO_ASYNC 4
`define NEG_CLK_NO_ASYNC 5
`define N_COMBS 6

module mgc_generic_reg (d, clk, en, a_rst, s_rst, q);
   parameter width = 8;
   parameter ph_clk = 1;//clock polarity, 1=rising_edge
   parameter ph_en = 1;
   parameter ph_a_rst = 1;  // 0 to 1 IGNORED
   parameter ph_s_rst = 1;  // 0 to 1 IGNORED
   parameter a_rst_used = 1;
   parameter s_rst_used = 0;
   parameter en_used = 0;

   input  [width-1:0] d;
   input              clk;
   input              en;
   input              a_rst;
   input              s_rst;
   output [width-1:0] q;

   reg [width-1:0] q_temp [`N_COMBS-1:0];

   always@(posedge a_rst or posedge clk)
   begin
     if (a_rst)
       q_temp[`POS_CLK_POS_ASYNC] <= 0;
     else if (s_rst == ph_s_rst)
       q_temp[`POS_CLK_POS_ASYNC] <= 0;
     else begin
       if ((ph_en & en) | ((ph_en==0) & (en==0))) begin
         q_temp[`POS_CLK_POS_ASYNC] <= d;
       end
     end
   end

   always@(negedge a_rst or posedge clk)
   begin
     if (!a_rst)
       q_temp[`POS_CLK_NEG_ASYNC] <= 0;
     else if (s_rst == ph_s_rst)
       q_temp[`POS_CLK_NEG_ASYNC] <= 0;
     else begin
       if ((ph_en & en) | ((ph_en==0) & (en==0))) begin
         q_temp[`POS_CLK_NEG_ASYNC] <= d;
       end
     end
   end

   always@(posedge a_rst or negedge clk)
   begin
     if (a_rst)
       q_temp[`NEG_CLK_POS_ASYNC] <= 0;
     else if (s_rst == ph_s_rst)
       q_temp[`NEG_CLK_POS_ASYNC] <= 0;
     else begin
       if ((ph_en & en) | ((ph_en==0) & (en==0))) begin
         q_temp[`NEG_CLK_POS_ASYNC] <= d;
       end
     end
   end

   always@(negedge a_rst or negedge clk)
   begin
     if (!a_rst)
       q_temp[`NEG_CLK_NEG_ASYNC] <= 0;
     else if (s_rst == ph_s_rst)
       q_temp[`NEG_CLK_NEG_ASYNC] <= 0;
     else begin
       if ((ph_en & en) | ((ph_en==0) & (en==0))) begin
         q_temp[`NEG_CLK_NEG_ASYNC] <= d;
       end
     end
   end

   assign q = ph_clk ?
		   (ph_a_rst ?
		     q_temp[`POS_CLK_POS_ASYNC]: q_temp[`POS_CLK_NEG_ASYNC]) :
		   (ph_a_rst ?
		     q_temp[`NEG_CLK_POS_ASYNC]: q_temp[`NEG_CLK_NEG_ASYNC]);
endmodule

//------> /misc/linuxws/packages/mentor_2011/catapult/Mgc_home/pkgs/siflibs/ram_dualport_be_fpga.v 
//////////////////////////////////////////////////////////////////////////////
//
//  Copyright \251 Mentor Graphics Corporation, 1996-2004, All Rights Reserved.
//                       UNPUBLISHED, LICENSED SOFTWARE.
//            CONFIDENTIAL AND PROPRIETARY INFORMATION WHICH IS THE
//          PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS.
//
//////////////////////////////////////////////////////////////////////////////
module dualport_ram_be ( data_in, addr, re, we, data_out, clk, a_rst, s_rst, en);

parameter ram_id          = 1;
parameter words           = 'd256;
parameter width           = 8;
parameter addr_width      = 8;
parameter [0:0] a_reset_active  = 0;
parameter [0:0] s_reset_active  = 1;
parameter [0:0] enable_active   = 1;
parameter [0:0] re_active   = 1;
parameter [0:0] we_active   = 1;
parameter num_byte_enables = 1;
parameter clock_edge = 1;
parameter num_input_registers         = 2;
parameter num_output_registers        = 1;
parameter no_of_dualport_readwrite_port  = 2;

localparam byte_width = width / num_byte_enables;

  input [(width*no_of_dualport_readwrite_port)-1:0] data_in;
  input [(addr_width*no_of_dualport_readwrite_port)-1:0] addr;
  input [(no_of_dualport_readwrite_port*num_byte_enables)-1:0] re;
  input [(no_of_dualport_readwrite_port*num_byte_enables)-1:0] we;
  output [(width*no_of_dualport_readwrite_port)-1:0] data_out;
  input clk;
  input a_rst;
  input s_rst;
  input en;

  reg  [width-1:0] mem [words-1:0];
  // pragma attribute mem block_ram 1

  wire [num_byte_enables-1:0] rea;
  wire [num_byte_enables-1:0] reb;
  wire [num_byte_enables-1:0] wea;
  wire [num_byte_enables-1:0] web;
  wire [width-1:0] data_ina;
  wire [width-1:0] data_inb;
  reg [width-1:0] data_outa;
  reg [width-1:0] data_outb;

  wire [addr_width-1:0] addra;
  wire [addr_width-1:0] addrb;

  reg [addr_width-1:0] addra_reg;
  reg [addr_width-1:0] addrb_reg;

  reg [num_byte_enables-1:0] rea_reg;
  reg [num_byte_enables-1:0] reb_reg;

// synopsys translate_off
  integer count;
  initial
  begin
    for (count = 0; count < words; count = count + 1) 
      mem[count] = 0;
  end
// synopsys translate_on

  assign addra = addr[(2*addr_width)-1:addr_width];
  assign addrb = addr[addr_width-1:0];

  assign rea = re[((1*num_byte_enables)+num_byte_enables)-1:1*num_byte_enables];
  assign reb = re[((0*num_byte_enables)+num_byte_enables)-1:0*num_byte_enables];
  assign wea = we[((1*num_byte_enables)+num_byte_enables)-1:1*num_byte_enables];
  assign web = we[((0*num_byte_enables)+num_byte_enables)-1:0*num_byte_enables];

  assign data_ina = data_in[(2*width)-1:width];
  assign data_inb = data_in[width-1:0];

  reg [width-1:0] data_ina_inreg [((num_input_registers > 1) ? num_input_registers - 2 : 0): 0];
  reg [width-1:0] data_inb_inreg [((num_input_registers > 1) ? num_input_registers - 2 : 0): 0];
  reg [addr_width-1:0] addra_inreg [((num_input_registers > 1) ? num_input_registers - 2 : 0): 0];
  reg [addr_width-1:0] addrb_inreg [((num_input_registers > 1) ? num_input_registers - 2 : 0): 0];
  reg [num_byte_enables-1:0] rea_inreg [((num_input_registers > 1) ? num_input_registers - 2 : 0): 0];
  reg [num_byte_enables-1:0] reb_inreg [((num_input_registers > 1) ? num_input_registers - 2 : 0): 0];
  reg [num_byte_enables-1:0] wea_inreg [((num_input_registers > 1) ? num_input_registers - 2 : 0): 0];
  reg [num_byte_enables-1:0] web_inreg [((num_input_registers > 1) ? num_input_registers - 2 : 0): 0];

  genvar i;
  generate
  begin : pipe
    if (num_input_registers > 1)
    begin
      for( i=num_input_registers-2; i >= 1; i = i - 1)
      begin : SHIFT_MSBs // Verilog 2000 syntax requires that GENERATE_LOOP_STATEMENT be a named block
                         // Modelsim seems to allow it though it should be a bug
        wire [width-1:0] data_ina_i, data_inb_i;
        wire [addr_width-1:0] addra_i, addrb_i;
        wire [num_byte_enables-1:0] rea_i, reb_i;
        wire [num_byte_enables-1:0] wea_i, web_i;
  
        mgc_generic_reg #(width,      clock_edge, enable_active, a_reset_active, s_reset_active, 1'b0, 1'b0, 1'b0) i_data_ina_inreg (data_ina_inreg[i-1], clk, en, a_rst, s_rst, data_ina_i);
        mgc_generic_reg #(width,      clock_edge, enable_active, a_reset_active, s_reset_active, 1'b0, 1'b0, 1'b0) i_data_inb_inreg (data_inb_inreg[i-1], clk, en, a_rst, s_rst, data_inb_i);
        mgc_generic_reg #(addr_width, clock_edge, enable_active, a_reset_active, s_reset_active, 1'b0, 1'b0, 1'b0) i_addra_inreg    (addra_inreg[i-1],    clk, en, a_rst, s_rst, addra_i);
        mgc_generic_reg #(addr_width, clock_edge, enable_active, a_reset_active, s_reset_active, 1'b0, 1'b0, 1'b0) i_addrb_inreg    (addrb_inreg[i-1],    clk, en, a_rst, s_rst, addrb_i);
        mgc_generic_reg #(num_byte_enables, clock_edge, enable_active, a_reset_active, s_reset_active, 1'b0, 1'b0, 1'b0) i_rea_inreg      (rea_inreg[i-1],      clk, en, a_rst, s_rst, rea_i);
        mgc_generic_reg #(num_byte_enables, clock_edge, enable_active, a_reset_active, s_reset_active, 1'b0, 1'b0, 1'b0) i_reb_inreg      (reb_inreg[i-1],      clk, en, a_rst, s_rst, reb_i);
        mgc_generic_reg #(num_byte_enables, clock_edge, enable_active, a_reset_active, s_reset_active, 1'b0, 1'b0, 1'b0) i_wea_inreg      (wea_inreg[i-1],      clk, en, a_rst, s_rst, wea_i);
        mgc_generic_reg #(num_byte_enables, clock_edge, enable_active, a_reset_active, s_reset_active, 1'b0, 1'b0, 1'b0) i_web_inreg      (web_inreg[i-1],      clk, en, a_rst, s_rst, web_i);
  
        always@(data_ina_i)
          data_ina_inreg[i] = data_ina_i;
        always@(data_inb_i)
          data_inb_inreg[i] = data_inb_i;
  
        always@(addra_i)
          addra_inreg[i] = addra_i;
        always@(addrb_i)
          addrb_inreg[i] = addrb_i;
  
        always@(rea_i)
          rea_inreg[i] = rea_i;
        always@(reb_i)
          reb_inreg[i] = reb_i;
        always@(wea_i)
          wea_inreg[i] = wea_i;
        always@(web_i)
          web_inreg[i] = web_i;
      end // end for loop

      // SHIFT for the first stage
      wire [width-1:0] data_ina_init, data_inb_init;
      wire [addr_width-1:0] addra_init, addrb_init;
      wire [num_byte_enables-1:0] rea_init, reb_init;
      wire [num_byte_enables-1:0] wea_init, web_init;
    
      mgc_generic_reg #(width,      clock_edge, enable_active, a_reset_active, s_reset_active, 1'b0, 1'b0, 1'b1) i_data_ina_inreg_i (data_ina, clk, en, a_rst, s_rst, data_ina_init);
      mgc_generic_reg #(width,      clock_edge, enable_active, a_reset_active, s_reset_active, 1'b0, 1'b0, 1'b1) i_data_inb_inreg_i (data_inb, clk, en, a_rst, s_rst, data_inb_init);
      mgc_generic_reg #(addr_width, clock_edge, enable_active, a_reset_active, s_reset_active, 1'b0, 1'b0, 1'b1) i_addra_inreg_i    (addra,    clk, en, a_rst, s_rst, addra_init);
      mgc_generic_reg #(addr_width, clock_edge, enable_active, a_reset_active, s_reset_active, 1'b0, 1'b0, 1'b1) i_addrb_inreg_i    (addrb,    clk, en, a_rst, s_rst, addrb_init);
      mgc_generic_reg #(num_byte_enables, clock_edge, enable_active, a_reset_active, s_reset_active, 1'b0, 1'b0, 1'b1) i_rea_inreg_i      (rea,      clk, en, a_rst, s_rst, rea_init);
      mgc_generic_reg #(num_byte_enables, clock_edge, enable_active, a_reset_active, s_reset_active, 1'b0, 1'b0, 1'b1) i_reb_inreg_i      (reb,      clk, en, a_rst, s_rst, reb_init);
      mgc_generic_reg #(num_byte_enables, clock_edge, enable_active, a_reset_active, s_reset_active, 1'b0, 1'b0, 1'b1) i_wea_inreg_i      (wea,      clk, en, a_rst, s_rst, wea_init);
      mgc_generic_reg #(num_byte_enables, clock_edge, enable_active, a_reset_active, s_reset_active, 1'b0, 1'b0, 1'b1) i_web_inreg_i      (web,      clk, en, a_rst, s_rst, web_init);
    
      always@(data_ina_init)
        data_ina_inreg[0] = data_ina_init;
      always@(data_inb_init)
        data_inb_inreg[0] = data_inb_init;
    
      always@(addra_init)
        addra_inreg[0] = addra_init;
      always@(addrb_init)
        addrb_inreg[0] = addrb_init;
    
      always@(rea_init)
        rea_inreg[0] = rea_init;
      always@(reb_init)
        reb_inreg[0] = reb_init;

      always@(wea_init)
        wea_inreg[0] = wea_init;
      always@(web_init)
        web_inreg[0] = web_init;
    end
  end
  endgenerate

  wire [width-1:0]      data_ina_f = (num_input_registers > 1) ? data_ina_inreg[num_input_registers-2] : data_ina;
  wire [width-1:0]      data_inb_f = (num_input_registers > 1) ? data_inb_inreg[num_input_registers-2] : data_inb;
  wire [addr_width-1:0] addra_f    = (num_input_registers > 1) ? addra_inreg[num_input_registers-2]    : addra;
  wire [addr_width-1:0] addrb_f    = (num_input_registers > 1) ? addrb_inreg[num_input_registers-2]    : addrb;
  wire [num_byte_enables-1:0]            rea_f      = (num_input_registers > 1) ? rea_inreg[num_input_registers-2]      : rea;
  wire [num_byte_enables-1:0]            reb_f      = (num_input_registers > 1) ? reb_inreg[num_input_registers-2]      : reb;
  wire [num_byte_enables-1:0]            wea_f      = (num_input_registers > 1) ? wea_inreg[num_input_registers-2]      : wea;
  wire [num_byte_enables-1:0]            web_f      = (num_input_registers > 1) ? web_inreg[num_input_registers-2]      : web;

  reg addra_NotDontCare;
  reg addrb_NotDontCare;
  integer j, k, l, m, n, o, p, q;

  generate
    if (clock_edge == 1'b1)
      begin: POSEDGE_BLK
        always @(posedge clk)
        begin
          if ( en == enable_active )
          begin
            addra_NotDontCare = 1'b1;
            begin: blka_X
              for (j = 0; j < addr_width; j = j + 1)
              begin
                if ((addra_f[j] === 1'bX) || (addra_f[j] === 1'bZ))
                begin
                  addra_NotDontCare = 1'b0;
                  for (k = 0; k < num_byte_enables; k = k + 1)
                  begin
                    if (wea_f[k] == we_active) begin
                      $display($time, " Error: Dont-care addresses for pipelined dualport memory write on port A");
                      $finish;
                    end
                  end
                  disable blka_X;
                end
              end
            end
                                                                                        
            addra_reg <= addra_f;
            rea_reg   <= rea_f;

            if (addra_NotDontCare)
            begin
              if ((addra_f < words) && (addra_f >= 0)) begin
                for (j = 0; j < num_byte_enables; j = j + 1)
                begin
                  if (wea_f[j] == we_active) begin
                    // mem[addra_f] <= data_ina_f;
                    mem[addra_f][((j*byte_width)+byte_width)-1-:byte_width] <= data_ina_f[((j*byte_width)+byte_width)-1-:byte_width];
                  end
                end
              end else begin
                for (j = 0; j < num_byte_enables; j = j + 1)
                begin
                  if (wea_f[j] == we_active) begin
                    $display($time, " Error: Out-of-bound pipelined dualport memory-write on port A");
                    $finish;
                  end
                end
              end
            end
          end
        end
        
        always @(posedge clk)
        begin
          if ( en == enable_active )
          begin
            addrb_NotDontCare = 1'b1;
            begin: blkb_X
              for (l = 0; l < addr_width; l = l + 1)
              begin
                if ((addrb_f[l] === 1'bX) || (addrb_f[l] === 1'bZ))
                begin
                  addrb_NotDontCare = 1'b0;
                  for (m = 0; m < num_byte_enables; m = m + 1)
                  begin
                    if (web_f[m] == we_active) begin
                      $display($time, " Error: Dont-care addresses for pipelined dualport memory write on port B");
                      $finish;
                    end
                  end
                  disable blkb_X;
                end
              end
            end
                                                                                        
            addrb_reg <= addrb_f;
            reb_reg   <= reb_f;

            if (addrb_NotDontCare)
            begin
              if ((addrb_f < words) && (addrb_f >= 0)) begin
                for (l = 0; l < num_byte_enables; l = l + 1)
                begin
                  if (web_f[l] == we_active) begin
                    // mem[addrb_f] <= data_inb_f;
                    mem[addrb_f][((l*byte_width)+byte_width)-1-:byte_width] <= data_inb_f[((l*byte_width)+byte_width)-1-:byte_width];
                  end
                end
              end else begin
                for (l = 0; l < num_byte_enables; l = l + 1)
                begin
                  if (web_f[l] == we_active) begin
                    $display($time, " Error: Out-of-bound pipelined dualport memory-write on port B");
                    $finish;
                  end
                end
              end
            end
          end
        end
      end
    else
      begin: NEGEDGE_BLK
        always @(negedge clk)
        begin
          if ( en == enable_active )
          begin
            addra_NotDontCare = 1'b1;
            begin: blka_X
              for (n = 0; n < addr_width; n = n + 1)
              begin
                if ((addra_f[n] === 1'bX) || (addra_f[n] === 1'bZ))
                begin
                  addra_NotDontCare = 1'b0;
                  for (o = 0; o < num_byte_enables; o = o + 1)
                  begin
                    if (wea_f[o] == we_active) begin
                      $display($time, " Error: Dont-care addresses for pipelined dualport memory write on port A");
                      $finish;
                    end
                  end
                  disable blka_X;
                end
              end
            end
                                                                                        
            addra_reg <= addra_f;
            rea_reg   <= rea_f;

            if (addra_NotDontCare)
            begin
              if ((addra_f < words) && (addra_f >= 0)) begin
                for (n = 0; n < num_byte_enables; n = n + 1)
                begin
                  if (wea_f[n] == we_active) begin
                    // mem[addra_f] <= data_ina_f;
                    mem[addra_f][((n*byte_width)+byte_width)-1-:byte_width] <= data_ina_f[((n*byte_width)+byte_width)-1-:byte_width];
                  end
                end
              end else begin
                for (n = 0; n < num_byte_enables; n = n + 1)
                begin
                  if (wea_f[n] == we_active) begin
                    $display($time, " Error: Out-of-bound pipelined dualport memory-write on port A");
                    $finish;
                  end
                end
              end
            end
          end
        end
        
        always @(negedge clk)
        begin
          if ( en == enable_active )
          begin
            addrb_NotDontCare = 1'b1;
            begin: blkb_X
              for (p = 0; p < addr_width; p = p + 1)
              begin
                if ((addrb_f[p] === 1'bX) || (addrb_f[p] === 1'bZ))
                begin
                  addrb_NotDontCare = 1'b0;
                  for (q = 0; q < num_byte_enables; q = q + 1)
                  begin
                    if (web_f[q] == we_active) begin
                      $display($time, " Error: Dont-care addresses for pipelined dualport memory write on port B");
                      $finish;
                    end
                  end
                  disable blkb_X;
                end
              end
            end
                                                                                        
            addrb_reg <= addrb_f;
            reb_reg   <= reb_f;

            if (addrb_NotDontCare)
            begin
              if ((addrb_f < words) && (addrb_f >= 0)) begin
                for (p = 0; p < num_byte_enables; p = p + 1)
                begin
                  if (web_f[p] == we_active) begin
                    // mem[addrb_f] <= data_inb_f;
                    mem[addrb_f][((p*byte_width)+byte_width)-1-:byte_width] <= data_inb_f[((p*byte_width)+byte_width)-1-:byte_width];
                  end
                end
              end else begin
                for (p = 0; p < num_byte_enables; p = p + 1)
                begin
                  if (web_f[p] == we_active) begin
                    $display($time, " Error: Out-of-bound pipelined dualport memory-write on port B");
                    $finish;
                  end
                end
              end
            end
          end
        end
      end
  endgenerate

  integer r;
  always@(
          mem[addra_reg]
          or addra_NotDontCare
          or addra_reg
          or rea_reg
          )
  begin
    if (addra_NotDontCare)
      if ((addra_reg < words) && (addra_reg >= 0))
        for (r = 0; r < num_byte_enables; r = r + 1)
        begin
	  if ( rea_reg[r] == re_active )
            data_outa[((r*byte_width) + byte_width) - 1 -: byte_width] <= mem[addra_reg][((r*byte_width) + byte_width) - 1 -: byte_width];
          else
            data_outa[((r*byte_width) + byte_width) - 1 -: byte_width] <= {(byte_width){1'bX}};
        end
      else
        data_outa <= {width{1'bX}};
    else
      data_outa <= {width{1'bX}};
  end


  integer s;
  always@(
          mem[addrb_reg]
          or addrb_NotDontCare
          or addrb_reg
          or reb_reg
          )
  begin
    if (addrb_NotDontCare)
      if ((addrb_reg < words) && (addrb_reg >= 0))
        for (s = 0; s < num_byte_enables; s = s + 1)
        begin
	  if ( reb_reg[s] == re_active )
            data_outb[((s*byte_width) + byte_width) - 1 -: byte_width] <= mem[addrb_reg][((s*byte_width) + byte_width) - 1 -: byte_width];
          else
            data_outb[((s*byte_width) + byte_width) - 1 -: byte_width] <= {(byte_width){1'bX}};
        end
      else
        data_outb <= {width{1'bX}};
    else
      data_outb <= {width{1'bX}};
  end

  reg [width-1:0] data_outa_outreg [((num_output_registers > 0) ? num_output_registers - 1 : 0): 0];
  reg [width-1:0] data_outb_outreg [((num_output_registers > 0) ? num_output_registers - 1 : 0): 0];

  genvar t;
  generate
  begin : outblk
    if (num_output_registers > 0)
    begin
      for( t = num_output_registers-1; t >= 1; t = t - 1)
      begin : SHIFT_MSBs // Verilog 2000 syntax requires that GENERATE_LOOP_STATEMENT be a named block
                         // Modelsim seems to allow it though it should be a bug
        wire [width-1:0] data_outa_i, data_outb_i;
        mgc_generic_reg #(width, clock_edge, enable_active, a_reset_active, s_reset_active, 1'b0, 1'b0, 1'b1) i_data_outa_outreg (data_outa_outreg[t-1], clk, en, a_rst, s_rst, data_outa_i);
        mgc_generic_reg #(width, clock_edge, enable_active, a_reset_active, s_reset_active, 1'b0, 1'b0, 1'b1) i_data_outb_outreg (data_outb_outreg[t-1], clk, en, a_rst, s_rst, data_outb_i);
  
        always@(data_outa_i)
          data_outa_outreg[t] = data_outa_i;
        always@(data_outb_i)
          data_outb_outreg[t] = data_outb_i;
      end // end for loop

      // SHIFT for the first stage
      wire [width-1:0] data_outa_init, data_outb_init;
      mgc_generic_reg #(width, clock_edge, enable_active, a_reset_active, s_reset_active, 1'b0, 1'b0, 1'b1) i_data_outa_outreg_i (data_outa, clk, en, a_rst, s_rst, data_outa_init);
      mgc_generic_reg #(width, clock_edge, enable_active, a_reset_active, s_reset_active, 1'b0, 1'b0, 1'b1) i_data_outb_outreg_i (data_outb, clk, en, a_rst, s_rst, data_outb_init);

      always@(data_outa_init)
        data_outa_outreg[0] = data_outa_init;
      always@(data_outb_init)
        data_outb_outreg[0] = data_outb_init;
    end
  end
  endgenerate

  assign data_out = (num_output_registers > 0) ? {data_outa_outreg[num_output_registers-1], data_outb_outreg[num_output_registers-1]} : {data_outa,data_outb};

endmodule

//------> /misc/linuxws/packages/mentor_2011/catapult/Mgc_home/pkgs/hls_pkgs/mgc_comps_src/mgc_div_beh.v 
module mgc_div(a,b,z);
   parameter width_a = 8;
   parameter width_b = 8;
   parameter signd = 1;
   input [width_a-1:0] a;
   input [width_b-1:0] b; 
   output [width_a-1:0] z;  
   reg  [width_a-1:0] z;

   always@(a or b)
     begin
	if(signd)
	  div_s(a,b,z);
	else
          div_u(a,b,z);
     end


//-----------------------------------------------------------------
//     -- Vectorized Overloaded Arithmetic Operators
//-----------------------------------------------------------------
   
   function [width_a-1:0] fabs_l; 
      input [width_a-1:0] arg1;
      begin
         case(arg1[width_a-1])
            1'b1:
               fabs_l = {(width_a){1'b0}} - arg1;
            default: // was: 1'b0:
               fabs_l = arg1;
         endcase
      end
   endfunction
   
   function [width_b-1:0] fabs_r; 
      input [width_b-1:0] arg1;
      begin
         case (arg1[width_b-1])
            1'b1:
               fabs_r =  {(width_b){1'b0}} - arg1;
            default: // was: 1'b0:
               fabs_r = arg1;
         endcase
      end
   endfunction

   function [width_b:0] minus;
     input [width_b:0] in1;
     input [width_b:0] in2;
     minus = in1 - in2;
   endfunction

   
   task divmod;
      input [width_a-1:0] l;
      input [width_b-1:0] r;
      output [width_a-1:0] rdiv;
      output [width_b-1:0] rmod;
      
//      parameter llen = width_a;
//      parameter rlen = width_b;
      reg [(32+32)-1:0] lbuf;
      reg [32:0] diff;
	  integer i;
      begin
	 lbuf = 0;
	 lbuf[32-1:0] = l;
/*
	 for(i=width_a-1;i>=0;i=i-1)
	   begin
              diff = minus(lbuf[(llen+rlen)-1:llen-1], {1'b0,r});
	      rdiv[i] = ~diff[rlen];
	      if(diff[rlen] == 0)
		lbuf[(llen+rlen)-1:llen-1] = diff;
	      lbuf[(llen+rlen)-1:1] = lbuf[(llen+rlen)-2:0];
	   end
	 rmod = lbuf[(llen+rlen)-1:llen];
      end
*/
// The for-loop isn't synthesizing in Xilinx, so I am unrolling
// it here.

    diff = minus(lbuf[(32+32)-1:32-1], {1'b0,r});

	 rdiv[7] = ~diff[32];
	 rdiv[6] = ~diff[32];	 
	 rdiv[5] = ~diff[32];
	 rdiv[4] = ~diff[32];	 
	 rdiv[3] = ~diff[32];
	 rdiv[2] = ~diff[32];	 
	 rdiv[1] = ~diff[32];
	 rdiv[0] = ~diff[32];	 

	 rdiv[8+7] = ~diff[32];
	 rdiv[8+6] = ~diff[32];	 
	 rdiv[8+5] = ~diff[32];
	 rdiv[8+4] = ~diff[32];	 
	 rdiv[8+3] = ~diff[32];
	 rdiv[8+2] = ~diff[32];	 
	 rdiv[8+1] = ~diff[32];
	 rdiv[8+0] = ~diff[32];	 

	 rdiv[16+7] = ~diff[32];
	 rdiv[16+6] = ~diff[32];	 
	 rdiv[16+5] = ~diff[32];
	 rdiv[16+4] = ~diff[32];	 
	 rdiv[16+3] = ~diff[32];
	 rdiv[16+2] = ~diff[32];	 
	 rdiv[16+1] = ~diff[32];
	 rdiv[16+0] = ~diff[32];	 

	 rdiv[24+7] = ~diff[32];
	 rdiv[24+6] = ~diff[32];	 
	 rdiv[24+5] = ~diff[32];
	 rdiv[24+4] = ~diff[32];	 
	 rdiv[24+3] = ~diff[32];
	 rdiv[24+2] = ~diff[32];	 
	 rdiv[24+1] = ~diff[32];
	 rdiv[24+0] = ~diff[32];	 

	 if(diff[32] == 0)
		lbuf[(32+32)-1:32-1] = diff;
	 lbuf[(32+32)-1:1] = lbuf[(32+32)-2:0];
    rmod = lbuf[(32+32)-1:32];
    end
	endtask
      

   task div_u;
      input [width_a-1:0] l;
      input [width_b-1:0] r;
      output [width_a-1:0] rdiv;
      
      reg [width_a-01:0] rdiv;
      reg [width_b-1:0] rmod;
      begin
	 divmod(l, r, rdiv, rmod);
      end
   endtask
   
   task mod_u;
      input [width_a-1:0] l;
      input [width_b-1:0] r;
      output [width_b-1:0] rmod;
      
      reg [width_a-01:0] rdiv;
      reg [width_b-1:0] rmod;
      begin
	 divmod(l, r, rdiv, rmod);
      end
   endtask

   task rem_u; 
      input [width_a-1:0] l;
      input [width_b-1:0] r;    
      output [width_b-1:0] rmod;
      begin
	 mod_u(l,r,rmod);
      end
   endtask // rem_u

   task div_s;
      input [width_a-1:0] l;
      input [width_b-1:0] r;
      output [width_a-1:0] rdiv;
      
      reg [width_a-01:0] rdiv;
      reg [width_b-1:0] rmod;
      begin
	 divmod(fabs_l(l), fabs_r(r),rdiv,rmod);
	 if(l[width_a-1] != r[width_b-1])
	   rdiv = {(width_a){1'b0}} - rdiv;
      end
   endtask

   task mod_s;
      input [width_a-1:0] l;
      input [width_b-1:0] r;
      output [width_b-1:0] rmod;
      
      reg [width_a-01:0] rdiv;
      reg [width_b-1:0] rmod;
      reg [width_b-1:0] rnul;
      begin
	 rnul = 0;
	 divmod(fabs_l(l), fabs_r(r), rdiv, rmod);
	 if(l[width_a-1])
	   rmod = {(width_b){1'b0}} - rmod;
	 if((rmod != rnul) && (l[width_a-1] != r[width_b-1]))
	   rmod = r + rmod;
      end
   endtask // mod_s
   
   task rem_s; 
      input [width_a-1:0] l;
      input [width_b-1:0] r;    
      output [width_b-1:0] rmod;   
      reg [width_a-01:0] rdiv;
      reg [width_b-1:0] rmod;
      begin
	 divmod(fabs_l(l),fabs_r(r),rdiv,rmod);
	 if(l[width_a-1])
	   rmod = {(width_b){1'b0}} - rmod;
      end
   endtask

  endmodule

//------> ./rtl_InitDecodemgc_rom_18_32_4.v 
// ----------------------------------------------------------------------
//  HLS HDL:        Verilog Netlister
//  HLS Version:    2011a.50 Production Release
//  HLS Date:       Sun Jul  3 15:07:11 PDT 2011
// 
//  Generated by:   wodonnell@soc1
//  Generated date: Thu Nov 21 22:42:22 2013
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



//------> ./rtl.v 
// ----------------------------------------------------------------------
//  HLS HDL:        Verilog Netlister
//  HLS Version:    2011a.50 Production Release
//  HLS Date:       Sun Jul  3 15:07:11 PDT 2011
// 
//  Generated by:   wodonnell@soc1
//  Generated date: Thu Nov 21 22:42:21 2013
// ----------------------------------------------------------------------

// 
// ------------------------------------------------------------------
//  Design Unit:    InitDecode_core_fsm
//  FSM Module
// ------------------------------------------------------------------


module InitDecode_core_fsm (
  clk, rst, core_wen, fsm_output, st_INIT_TRELLIS_LOOP_1_tr0, st_main_3_tr0, st_BUTTERFLY_LOOP_6_tr0,
      st_MAIN_LOOP_1_tr0, st_main_4_tr0, st_UPDATE_MATRIX_LOOP_2_tr0
);
  input clk;
  input rst;
  input core_wen;
  output [33:0] fsm_output;
  reg [33:0] fsm_output;
  input st_INIT_TRELLIS_LOOP_1_tr0;
  input st_main_3_tr0;
  input st_BUTTERFLY_LOOP_6_tr0;
  input st_MAIN_LOOP_1_tr0;
  input st_main_4_tr0;
  input st_UPDATE_MATRIX_LOOP_2_tr0;


  // FSM State Type Declaration for InitDecode_core_fsm_1
  parameter
    st_main = 6'd0,
    st_main_1 = 6'd1,
    st_main_2 = 6'd2,
    st_INIT_TRELLIS_LOOP = 6'd3,
    st_INIT_TRELLIS_LOOP_1 = 6'd4,
    st_main_3 = 6'd5,
    st_MAIN_LOOP = 6'd6,
    st_BUTTERFLY_LOOP = 6'd7,
    st_BUTTERFLY_LOOP_1 = 6'd8,
    st_BUTTERFLY_LOOP_2 = 6'd9,
    st_BUTTERFLY_LOOP_3 = 6'd10,
    st_BUTTERFLY_LOOP_4 = 6'd11,
    st_BUTTERFLY_LOOP_5 = 6'd12,
    st_BUTTERFLY_LOOP_6 = 6'd13,
    st_MAIN_LOOP_1 = 6'd14,
    st_main_4 = 6'd15,
    st_UPDATE_MATRIX_LOOP = 6'd16,
    st_UPDATE_MATRIX_LOOP_1 = 6'd17,
    st_UPDATE_MATRIX_LOOP_2 = 6'd18,
    st_main_5 = 6'd19,
    st_main_6 = 6'd20,
    st_main_7 = 6'd21,
    st_main_8 = 6'd22,
    st_main_9 = 6'd23,
    st_main_10 = 6'd24,
    st_main_11 = 6'd25,
    st_main_12 = 6'd26,
    st_main_13 = 6'd27,
    st_main_14 = 6'd28,
    st_main_15 = 6'd29,
    st_main_16 = 6'd30,
    st_main_17 = 6'd31,
    st_main_18 = 6'd32,
    st_main_19 = 6'd33,
    state_x = 6'b000000;

  reg [5:0] state_var;
  reg [5:0] state_var_NS;

  always @(st_INIT_TRELLIS_LOOP_1_tr0 or st_main_3_tr0 or st_BUTTERFLY_LOOP_6_tr0
      or st_MAIN_LOOP_1_tr0 or st_main_4_tr0 or st_UPDATE_MATRIX_LOOP_2_tr0 or state_var)
  begin : InitDecode_core_fsm_1
    case (state_var)
      st_main : begin
        fsm_output = 34'b1;
        state_var_NS = st_main_1;
      end
      st_main_1 : begin
        fsm_output = 34'b10;
        state_var_NS = st_main_2;
      end
      st_main_2 : begin
        fsm_output = 34'b100;
        state_var_NS = st_INIT_TRELLIS_LOOP;
      end
      st_INIT_TRELLIS_LOOP : begin
        fsm_output = 34'b1000;
        state_var_NS = st_INIT_TRELLIS_LOOP_1;
      end
      st_INIT_TRELLIS_LOOP_1 : begin
        fsm_output = 34'b10000;
        if ( st_INIT_TRELLIS_LOOP_1_tr0 ) begin
          state_var_NS = st_main_3;
        end
        else begin
          state_var_NS = st_INIT_TRELLIS_LOOP;
        end
      end
      st_main_3 : begin
        fsm_output = 34'b100000;
        if ( st_main_3_tr0 ) begin
          state_var_NS = st_main_4;
        end
        else begin
          state_var_NS = st_MAIN_LOOP;
        end
      end
      st_MAIN_LOOP : begin
        fsm_output = 34'b1000000;
        state_var_NS = st_BUTTERFLY_LOOP;
      end
      st_BUTTERFLY_LOOP : begin
        fsm_output = 34'b10000000;
        state_var_NS = st_BUTTERFLY_LOOP_1;
      end
      st_BUTTERFLY_LOOP_1 : begin
        fsm_output = 34'b100000000;
        state_var_NS = st_BUTTERFLY_LOOP_2;
      end
      st_BUTTERFLY_LOOP_2 : begin
        fsm_output = 34'b1000000000;
        state_var_NS = st_BUTTERFLY_LOOP_3;
      end
      st_BUTTERFLY_LOOP_3 : begin
        fsm_output = 34'b10000000000;
        state_var_NS = st_BUTTERFLY_LOOP_4;
      end
      st_BUTTERFLY_LOOP_4 : begin
        fsm_output = 34'b100000000000;
        state_var_NS = st_BUTTERFLY_LOOP_5;
      end
      st_BUTTERFLY_LOOP_5 : begin
        fsm_output = 34'b1000000000000;
        state_var_NS = st_BUTTERFLY_LOOP_6;
      end
      st_BUTTERFLY_LOOP_6 : begin
        fsm_output = 34'b10000000000000;
        if ( st_BUTTERFLY_LOOP_6_tr0 ) begin
          state_var_NS = st_MAIN_LOOP_1;
        end
        else begin
          state_var_NS = st_BUTTERFLY_LOOP;
        end
      end
      st_MAIN_LOOP_1 : begin
        fsm_output = 34'b100000000000000;
        if ( st_MAIN_LOOP_1_tr0 ) begin
          state_var_NS = st_main_4;
        end
        else begin
          state_var_NS = st_MAIN_LOOP;
        end
      end
      st_main_4 : begin
        fsm_output = 34'b1000000000000000;
        if ( st_main_4_tr0 ) begin
          state_var_NS = st_main_5;
        end
        else begin
          state_var_NS = st_UPDATE_MATRIX_LOOP;
        end
      end
      st_UPDATE_MATRIX_LOOP : begin
        fsm_output = 34'b10000000000000000;
        state_var_NS = st_UPDATE_MATRIX_LOOP_1;
      end
      st_UPDATE_MATRIX_LOOP_1 : begin
        fsm_output = 34'b100000000000000000;
        state_var_NS = st_UPDATE_MATRIX_LOOP_2;
      end
      st_UPDATE_MATRIX_LOOP_2 : begin
        fsm_output = 34'b1000000000000000000;
        if ( st_UPDATE_MATRIX_LOOP_2_tr0 ) begin
          state_var_NS = st_main_5;
        end
        else begin
          state_var_NS = st_UPDATE_MATRIX_LOOP;
        end
      end
      st_main_5 : begin
        fsm_output = 34'b10000000000000000000;
        state_var_NS = st_main_6;
      end
      st_main_6 : begin
        fsm_output = 34'b100000000000000000000;
        state_var_NS = st_main_7;
      end
      st_main_7 : begin
        fsm_output = 34'b1000000000000000000000;
        state_var_NS = st_main_8;
      end
      st_main_8 : begin
        fsm_output = 34'b10000000000000000000000;
        state_var_NS = st_main_9;
      end
      st_main_9 : begin
        fsm_output = 34'b100000000000000000000000;
        state_var_NS = st_main_10;
      end
      st_main_10 : begin
        fsm_output = 34'b1000000000000000000000000;
        state_var_NS = st_main_11;
      end
      st_main_11 : begin
        fsm_output = 34'b10000000000000000000000000;
        state_var_NS = st_main_12;
      end
      st_main_12 : begin
        fsm_output = 34'b100000000000000000000000000;
        state_var_NS = st_main_13;
      end
      st_main_13 : begin
        fsm_output = 34'b1000000000000000000000000000;
        state_var_NS = st_main_14;
      end
      st_main_14 : begin
        fsm_output = 34'b10000000000000000000000000000;
        state_var_NS = st_main_15;
      end
      st_main_15 : begin
        fsm_output = 34'b100000000000000000000000000000;
        state_var_NS = st_main_16;
      end
      st_main_16 : begin
        fsm_output = 34'b1000000000000000000000000000000;
        state_var_NS = st_main_17;
      end
      st_main_17 : begin
        fsm_output = 34'b10000000000000000000000000000000;
        state_var_NS = st_main_18;
      end
      st_main_18 : begin
        fsm_output = 34'b100000000000000000000000000000000;
        state_var_NS = st_main_19;
      end
      st_main_19 : begin
        fsm_output = 34'b1000000000000000000000000000000000;
        state_var_NS = st_main;
      end
      default : begin
        fsm_output = 34'b0000000000000000000000000000000000;
        state_var_NS = st_main;
      end
    endcase
  end

  always @(posedge clk) begin
    if ( rst ) begin
      state_var <= st_main;
    end
    else if ( core_wen ) begin
      state_var <= state_var_NS;
    end
  end

endmodule

// ------------------------------------------------------------------
//  Design Unit:    InitDecode_core_wait_ctrl
// ------------------------------------------------------------------


module InitDecode_core_wait_ctrl (
  clk, rst, core_wen, vecNewDistance_rTow0_rsc_dualport_re_core_sct, vecNewDistance_rTow1_rsc_dualport_re_core_sct,
      vecOutputBits_rsc_dualport_we_core_sct, mgc_start_sync_mgc_bsync_rv_rd_core_sct,
      mgc_start_sync_mgc_bsync_rv_vd, mgc_done_sync_mgc_bsync_rdy_rd_core_sct, InitDecode_return_triosy_mgc_io_sync_ld_core_sct,
      vecOutputBits_triosy_mgc_io_sync_ld_core_sct, vecNewDistance_rTow1_triosy_mgc_io_sync_ld_core_sct,
      vecNewDistance_rTow0_triosy_mgc_io_sync_ld_core_sct, iLevel_triosy_mgc_io_sync_ld_core_sct,
      iPunctPatPartB_triosy_mgc_io_sync_ld_core_sct, iPunctPatPartA_triosy_mgc_io_sync_ld_core_sct,
      iNewNumOutBitsPartB_triosy_mgc_io_sync_ld_core_sct, iNewNumOutBitsPartA_triosy_mgc_io_sync_ld_core_sct,
      iN2_triosy_mgc_io_sync_ld_core_sct, iN1_triosy_mgc_io_sync_ld_core_sct, eNewChannelType_triosy_mgc_io_sync_ld_core_sct,
      eNewCodingScheme_triosy_mgc_io_sync_ld_core_sct, vecNewDistance_rTow0_rsc_dualport_oswt_1,
      vecNewDistance_rTow0_rsc_dualport_bcwt_1, vecNewDistance_rTow0_rsc_dualport_re_core_psct,
      vecNewDistance_rTow1_rsc_dualport_bcwt_1, vecNewDistance_rTow1_rsc_dualport_re_core_psct,
      vecOutputBits_rsc_dualport_oswt, vecOutputBits_rsc_dualport_we_core_psct, mgc_start_sync_mgc_bsync_rv_rd_core_psct,
      mgc_done_sync_mgc_bsync_rdy_rd_core_psct, vecOutputBits_triosy_mgc_io_sync_ld_core_psct,
      vecNewDistance_rTow0_rsc_dualport_oswt_1_pff, vecOutputBits_rsc_dualport_oswt_pff
);
  input clk;
  input rst;
  output core_wen;
  output [1:0] vecNewDistance_rTow0_rsc_dualport_re_core_sct;
  output [1:0] vecNewDistance_rTow1_rsc_dualport_re_core_sct;
  output [1:0] vecOutputBits_rsc_dualport_we_core_sct;
  output mgc_start_sync_mgc_bsync_rv_rd_core_sct;
  input mgc_start_sync_mgc_bsync_rv_vd;
  output mgc_done_sync_mgc_bsync_rdy_rd_core_sct;
  output InitDecode_return_triosy_mgc_io_sync_ld_core_sct;
  output vecOutputBits_triosy_mgc_io_sync_ld_core_sct;
  output vecNewDistance_rTow1_triosy_mgc_io_sync_ld_core_sct;
  output vecNewDistance_rTow0_triosy_mgc_io_sync_ld_core_sct;
  output iLevel_triosy_mgc_io_sync_ld_core_sct;
  output iPunctPatPartB_triosy_mgc_io_sync_ld_core_sct;
  output iPunctPatPartA_triosy_mgc_io_sync_ld_core_sct;
  output iNewNumOutBitsPartB_triosy_mgc_io_sync_ld_core_sct;
  output iNewNumOutBitsPartA_triosy_mgc_io_sync_ld_core_sct;
  output iN2_triosy_mgc_io_sync_ld_core_sct;
  output iN1_triosy_mgc_io_sync_ld_core_sct;
  output eNewChannelType_triosy_mgc_io_sync_ld_core_sct;
  output eNewCodingScheme_triosy_mgc_io_sync_ld_core_sct;
  input vecNewDistance_rTow0_rsc_dualport_oswt_1;
  output vecNewDistance_rTow0_rsc_dualport_bcwt_1;
  reg vecNewDistance_rTow0_rsc_dualport_bcwt_1;
  input [1:0] vecNewDistance_rTow0_rsc_dualport_re_core_psct;
  output vecNewDistance_rTow1_rsc_dualport_bcwt_1;
  reg vecNewDistance_rTow1_rsc_dualport_bcwt_1;
  input [1:0] vecNewDistance_rTow1_rsc_dualport_re_core_psct;
  input vecOutputBits_rsc_dualport_oswt;
  input [1:0] vecOutputBits_rsc_dualport_we_core_psct;
  input mgc_start_sync_mgc_bsync_rv_rd_core_psct;
  input mgc_done_sync_mgc_bsync_rdy_rd_core_psct;
  input vecOutputBits_triosy_mgc_io_sync_ld_core_psct;
  input vecNewDistance_rTow0_rsc_dualport_oswt_1_pff;
  input vecOutputBits_rsc_dualport_oswt_pff;


  // Interconnect Declarations
  wire vecNewDistance_rTow0_rsc_dualport_tiswt0_1;
  wire vecNewDistance_rTow0_rsc_dualport_biwt_1;
  reg vecNewDistance_rTow0_rsc_dualport_icwt_1;
  reg core_wten;
  wire vecNewDistance_rTow1_rsc_dualport_biwt_1;
  reg vecNewDistance_rTow1_rsc_dualport_icwt_1;
  wire vecOutputBits_rsc_dualport_tiswt0;
  wire vecOutputBits_rsc_dualport_biwt;
  reg vecOutputBits_rsc_dualport_icwt;
  reg vecOutputBits_rsc_dualport_bcwt;
  wire mgc_start_sync_mgc_bsync_rv_ogwt;
  wire mgc_start_sync_mgc_bsync_rv_pdswt0;
  wire mgc_start_sync_mgc_bsync_rv_biwt;
  reg mgc_start_sync_mgc_bsync_rv_icwt;
  reg mgc_start_sync_mgc_bsync_rv_bcwt;
  wire mgc_done_sync_mgc_bsync_rdy_ogwt;
  wire mgc_done_sync_mgc_bsync_rdy_pdswt0;
  reg mgc_done_sync_mgc_bsync_rdy_icwt;
  reg mgc_done_sync_mgc_bsync_rdy_bcwt;
  wire InitDecode_return_triosy_mgc_io_sync_ogwt;
  reg InitDecode_return_triosy_mgc_io_sync_icwt;
  reg InitDecode_return_triosy_mgc_io_sync_bcwt;
  wire vecOutputBits_triosy_mgc_io_sync_ogwt;
  wire vecOutputBits_triosy_mgc_io_sync_pdswt0;
  reg vecOutputBits_triosy_mgc_io_sync_icwt;
  reg vecOutputBits_triosy_mgc_io_sync_bcwt;
  wire vecNewDistance_rTow1_triosy_mgc_io_sync_ogwt;
  reg vecNewDistance_rTow1_triosy_mgc_io_sync_icwt;
  reg vecNewDistance_rTow1_triosy_mgc_io_sync_bcwt;
  wire vecNewDistance_rTow0_triosy_mgc_io_sync_ogwt;
  reg vecNewDistance_rTow0_triosy_mgc_io_sync_icwt;
  reg vecNewDistance_rTow0_triosy_mgc_io_sync_bcwt;
  wire iLevel_triosy_mgc_io_sync_ogwt;
  reg iLevel_triosy_mgc_io_sync_icwt;
  reg iLevel_triosy_mgc_io_sync_bcwt;
  wire iPunctPatPartB_triosy_mgc_io_sync_ogwt;
  reg iPunctPatPartB_triosy_mgc_io_sync_icwt;
  reg iPunctPatPartB_triosy_mgc_io_sync_bcwt;
  wire iPunctPatPartA_triosy_mgc_io_sync_ogwt;
  reg iPunctPatPartA_triosy_mgc_io_sync_icwt;
  reg iPunctPatPartA_triosy_mgc_io_sync_bcwt;
  wire iNewNumOutBitsPartB_triosy_mgc_io_sync_ogwt;
  reg iNewNumOutBitsPartB_triosy_mgc_io_sync_icwt;
  reg iNewNumOutBitsPartB_triosy_mgc_io_sync_bcwt;
  wire iNewNumOutBitsPartA_triosy_mgc_io_sync_ogwt;
  reg iNewNumOutBitsPartA_triosy_mgc_io_sync_icwt;
  reg iNewNumOutBitsPartA_triosy_mgc_io_sync_bcwt;
  wire iN2_triosy_mgc_io_sync_ogwt;
  reg iN2_triosy_mgc_io_sync_icwt;
  reg iN2_triosy_mgc_io_sync_bcwt;
  wire iN1_triosy_mgc_io_sync_ogwt;
  reg iN1_triosy_mgc_io_sync_icwt;
  reg iN1_triosy_mgc_io_sync_bcwt;
  wire eNewChannelType_triosy_mgc_io_sync_ogwt;
  reg eNewChannelType_triosy_mgc_io_sync_icwt;
  reg eNewChannelType_triosy_mgc_io_sync_bcwt;
  wire eNewCodingScheme_triosy_mgc_io_sync_ogwt;
  reg eNewCodingScheme_triosy_mgc_io_sync_icwt;
  reg eNewCodingScheme_triosy_mgc_io_sync_bcwt;
  wire and_4_cse;
  wire and_38_cse;
  wire and_46_cse;
  wire vecNewDistance_rTow0_rsc_dualport_tiswt0_1_pff;

  assign vecNewDistance_rTow0_rsc_dualport_tiswt0_1 = (~ core_wten) & vecNewDistance_rTow0_rsc_dualport_oswt_1;
  assign vecNewDistance_rTow0_rsc_dualport_biwt_1 = vecNewDistance_rTow0_rsc_dualport_tiswt0_1
      | vecNewDistance_rTow0_rsc_dualport_icwt_1;
  assign and_4_cse = vecNewDistance_rTow0_rsc_dualport_oswt_1 & core_wen;
  assign vecNewDistance_rTow1_rsc_dualport_biwt_1 = vecNewDistance_rTow0_rsc_dualport_tiswt0_1
      | vecNewDistance_rTow1_rsc_dualport_icwt_1;
  assign vecOutputBits_rsc_dualport_tiswt0 = (~ core_wten) & vecOutputBits_rsc_dualport_oswt;
  assign vecOutputBits_rsc_dualport_biwt = vecOutputBits_rsc_dualport_tiswt0 | vecOutputBits_rsc_dualport_icwt;
  assign mgc_start_sync_mgc_bsync_rv_pdswt0 = (~ core_wten) & mgc_start_sync_mgc_bsync_rv_rd_core_psct;
  assign mgc_start_sync_mgc_bsync_rv_biwt = mgc_start_sync_mgc_bsync_rv_ogwt & mgc_start_sync_mgc_bsync_rv_vd;
  assign mgc_start_sync_mgc_bsync_rv_ogwt = mgc_start_sync_mgc_bsync_rv_pdswt0 |
      mgc_start_sync_mgc_bsync_rv_icwt;
  assign mgc_start_sync_mgc_bsync_rv_rd_core_sct = mgc_start_sync_mgc_bsync_rv_rd_core_psct
      & mgc_start_sync_mgc_bsync_rv_ogwt;
  assign mgc_done_sync_mgc_bsync_rdy_pdswt0 = (~ core_wten) & mgc_done_sync_mgc_bsync_rdy_rd_core_psct;
  assign mgc_done_sync_mgc_bsync_rdy_ogwt = mgc_done_sync_mgc_bsync_rdy_pdswt0 |
      mgc_done_sync_mgc_bsync_rdy_icwt;
  assign and_38_cse = mgc_done_sync_mgc_bsync_rdy_rd_core_psct & core_wen;
  assign mgc_done_sync_mgc_bsync_rdy_rd_core_sct = mgc_done_sync_mgc_bsync_rdy_rd_core_psct
      & mgc_done_sync_mgc_bsync_rdy_ogwt;
  assign InitDecode_return_triosy_mgc_io_sync_ogwt = mgc_done_sync_mgc_bsync_rdy_pdswt0
      | InitDecode_return_triosy_mgc_io_sync_icwt;
  assign InitDecode_return_triosy_mgc_io_sync_ld_core_sct = mgc_done_sync_mgc_bsync_rdy_rd_core_psct
      & InitDecode_return_triosy_mgc_io_sync_ogwt;
  assign vecOutputBits_triosy_mgc_io_sync_pdswt0 = (~ core_wten) & vecOutputBits_triosy_mgc_io_sync_ld_core_psct;
  assign vecOutputBits_triosy_mgc_io_sync_ogwt = vecOutputBits_triosy_mgc_io_sync_pdswt0
      | vecOutputBits_triosy_mgc_io_sync_icwt;
  assign and_46_cse = vecOutputBits_triosy_mgc_io_sync_ld_core_psct & core_wen;
  assign vecOutputBits_triosy_mgc_io_sync_ld_core_sct = vecOutputBits_triosy_mgc_io_sync_ld_core_psct
      & vecOutputBits_triosy_mgc_io_sync_ogwt;
  assign vecNewDistance_rTow1_triosy_mgc_io_sync_ogwt = vecOutputBits_triosy_mgc_io_sync_pdswt0
      | vecNewDistance_rTow1_triosy_mgc_io_sync_icwt;
  assign vecNewDistance_rTow1_triosy_mgc_io_sync_ld_core_sct = vecOutputBits_triosy_mgc_io_sync_ld_core_psct
      & vecNewDistance_rTow1_triosy_mgc_io_sync_ogwt;
  assign vecNewDistance_rTow0_triosy_mgc_io_sync_ogwt = vecOutputBits_triosy_mgc_io_sync_pdswt0
      | vecNewDistance_rTow0_triosy_mgc_io_sync_icwt;
  assign vecNewDistance_rTow0_triosy_mgc_io_sync_ld_core_sct = vecOutputBits_triosy_mgc_io_sync_ld_core_psct
      & vecNewDistance_rTow0_triosy_mgc_io_sync_ogwt;
  assign iLevel_triosy_mgc_io_sync_ogwt = vecOutputBits_triosy_mgc_io_sync_pdswt0
      | iLevel_triosy_mgc_io_sync_icwt;
  assign iLevel_triosy_mgc_io_sync_ld_core_sct = vecOutputBits_triosy_mgc_io_sync_ld_core_psct
      & iLevel_triosy_mgc_io_sync_ogwt;
  assign iPunctPatPartB_triosy_mgc_io_sync_ogwt = vecOutputBits_triosy_mgc_io_sync_pdswt0
      | iPunctPatPartB_triosy_mgc_io_sync_icwt;
  assign iPunctPatPartB_triosy_mgc_io_sync_ld_core_sct = vecOutputBits_triosy_mgc_io_sync_ld_core_psct
      & iPunctPatPartB_triosy_mgc_io_sync_ogwt;
  assign iPunctPatPartA_triosy_mgc_io_sync_ogwt = vecOutputBits_triosy_mgc_io_sync_pdswt0
      | iPunctPatPartA_triosy_mgc_io_sync_icwt;
  assign iPunctPatPartA_triosy_mgc_io_sync_ld_core_sct = vecOutputBits_triosy_mgc_io_sync_ld_core_psct
      & iPunctPatPartA_triosy_mgc_io_sync_ogwt;
  assign iNewNumOutBitsPartB_triosy_mgc_io_sync_ogwt = vecOutputBits_triosy_mgc_io_sync_pdswt0
      | iNewNumOutBitsPartB_triosy_mgc_io_sync_icwt;
  assign iNewNumOutBitsPartB_triosy_mgc_io_sync_ld_core_sct = vecOutputBits_triosy_mgc_io_sync_ld_core_psct
      & iNewNumOutBitsPartB_triosy_mgc_io_sync_ogwt;
  assign iNewNumOutBitsPartA_triosy_mgc_io_sync_ogwt = vecOutputBits_triosy_mgc_io_sync_pdswt0
      | iNewNumOutBitsPartA_triosy_mgc_io_sync_icwt;
  assign iNewNumOutBitsPartA_triosy_mgc_io_sync_ld_core_sct = vecOutputBits_triosy_mgc_io_sync_ld_core_psct
      & iNewNumOutBitsPartA_triosy_mgc_io_sync_ogwt;
  assign iN2_triosy_mgc_io_sync_ogwt = vecOutputBits_triosy_mgc_io_sync_pdswt0 |
      iN2_triosy_mgc_io_sync_icwt;
  assign iN2_triosy_mgc_io_sync_ld_core_sct = vecOutputBits_triosy_mgc_io_sync_ld_core_psct
      & iN2_triosy_mgc_io_sync_ogwt;
  assign iN1_triosy_mgc_io_sync_ogwt = vecOutputBits_triosy_mgc_io_sync_pdswt0 |
      iN1_triosy_mgc_io_sync_icwt;
  assign iN1_triosy_mgc_io_sync_ld_core_sct = vecOutputBits_triosy_mgc_io_sync_ld_core_psct
      & iN1_triosy_mgc_io_sync_ogwt;
  assign eNewChannelType_triosy_mgc_io_sync_ogwt = vecOutputBits_triosy_mgc_io_sync_pdswt0
      | eNewChannelType_triosy_mgc_io_sync_icwt;
  assign eNewChannelType_triosy_mgc_io_sync_ld_core_sct = vecOutputBits_triosy_mgc_io_sync_ld_core_psct
      & eNewChannelType_triosy_mgc_io_sync_ogwt;
  assign eNewCodingScheme_triosy_mgc_io_sync_ogwt = vecOutputBits_triosy_mgc_io_sync_pdswt0
      | eNewCodingScheme_triosy_mgc_io_sync_icwt;
  assign eNewCodingScheme_triosy_mgc_io_sync_ld_core_sct = vecOutputBits_triosy_mgc_io_sync_ld_core_psct
      & eNewCodingScheme_triosy_mgc_io_sync_ogwt;
  assign core_wen = ((~ vecNewDistance_rTow0_rsc_dualport_oswt_1) | vecNewDistance_rTow0_rsc_dualport_biwt_1
      | vecNewDistance_rTow0_rsc_dualport_bcwt_1) & ((~ vecNewDistance_rTow0_rsc_dualport_oswt_1)
      | vecNewDistance_rTow1_rsc_dualport_biwt_1 | vecNewDistance_rTow1_rsc_dualport_bcwt_1)
      & ((~ vecOutputBits_rsc_dualport_oswt) | vecOutputBits_rsc_dualport_biwt |
      vecOutputBits_rsc_dualport_bcwt) & ((~ mgc_start_sync_mgc_bsync_rv_rd_core_psct)
      | mgc_start_sync_mgc_bsync_rv_biwt | mgc_start_sync_mgc_bsync_rv_bcwt) & ((~
      mgc_done_sync_mgc_bsync_rdy_rd_core_psct) | mgc_done_sync_mgc_bsync_rdy_ogwt
      | mgc_done_sync_mgc_bsync_rdy_bcwt) & ((~ mgc_done_sync_mgc_bsync_rdy_rd_core_psct)
      | InitDecode_return_triosy_mgc_io_sync_ogwt | InitDecode_return_triosy_mgc_io_sync_bcwt)
      & ((~ vecOutputBits_triosy_mgc_io_sync_ld_core_psct) | vecOutputBits_triosy_mgc_io_sync_ogwt
      | vecOutputBits_triosy_mgc_io_sync_bcwt) & ((~ vecOutputBits_triosy_mgc_io_sync_ld_core_psct)
      | vecNewDistance_rTow1_triosy_mgc_io_sync_ogwt | vecNewDistance_rTow1_triosy_mgc_io_sync_bcwt)
      & ((~ vecOutputBits_triosy_mgc_io_sync_ld_core_psct) | vecNewDistance_rTow0_triosy_mgc_io_sync_ogwt
      | vecNewDistance_rTow0_triosy_mgc_io_sync_bcwt) & ((~ vecOutputBits_triosy_mgc_io_sync_ld_core_psct)
      | iLevel_triosy_mgc_io_sync_ogwt | iLevel_triosy_mgc_io_sync_bcwt) & ((~ vecOutputBits_triosy_mgc_io_sync_ld_core_psct)
      | iPunctPatPartB_triosy_mgc_io_sync_ogwt | iPunctPatPartB_triosy_mgc_io_sync_bcwt)
      & ((~ vecOutputBits_triosy_mgc_io_sync_ld_core_psct) | iPunctPatPartA_triosy_mgc_io_sync_ogwt
      | iPunctPatPartA_triosy_mgc_io_sync_bcwt) & ((~ vecOutputBits_triosy_mgc_io_sync_ld_core_psct)
      | iNewNumOutBitsPartB_triosy_mgc_io_sync_ogwt | iNewNumOutBitsPartB_triosy_mgc_io_sync_bcwt)
      & ((~ vecOutputBits_triosy_mgc_io_sync_ld_core_psct) | iNewNumOutBitsPartA_triosy_mgc_io_sync_ogwt
      | iNewNumOutBitsPartA_triosy_mgc_io_sync_bcwt) & ((~ vecOutputBits_triosy_mgc_io_sync_ld_core_psct)
      | iN2_triosy_mgc_io_sync_ogwt | iN2_triosy_mgc_io_sync_bcwt) & ((~ vecOutputBits_triosy_mgc_io_sync_ld_core_psct)
      | iN1_triosy_mgc_io_sync_ogwt | iN1_triosy_mgc_io_sync_bcwt) & ((~ vecOutputBits_triosy_mgc_io_sync_ld_core_psct)
      | eNewChannelType_triosy_mgc_io_sync_ogwt | eNewChannelType_triosy_mgc_io_sync_bcwt)
      & ((~ vecOutputBits_triosy_mgc_io_sync_ld_core_psct) | eNewCodingScheme_triosy_mgc_io_sync_ogwt
      | eNewCodingScheme_triosy_mgc_io_sync_bcwt);
  assign vecNewDistance_rTow0_rsc_dualport_re_core_sct = {1'b0 , ((vecNewDistance_rTow0_rsc_dualport_re_core_psct[0])
      & vecNewDistance_rTow0_rsc_dualport_tiswt0_1_pff)};
  assign vecNewDistance_rTow0_rsc_dualport_tiswt0_1_pff = core_wen & vecNewDistance_rTow0_rsc_dualport_oswt_1_pff;
  assign vecNewDistance_rTow1_rsc_dualport_re_core_sct = {1'b0 , ((vecNewDistance_rTow1_rsc_dualport_re_core_psct[0])
      & vecNewDistance_rTow0_rsc_dualport_tiswt0_1_pff)};
  assign vecOutputBits_rsc_dualport_we_core_sct = {1'b0 , ((vecOutputBits_rsc_dualport_we_core_psct[0])
      & core_wen & vecOutputBits_rsc_dualport_oswt_pff)};
  always @(posedge clk) begin
    if ( rst ) begin
      vecNewDistance_rTow0_rsc_dualport_icwt_1 <= 1'b0;
      vecNewDistance_rTow0_rsc_dualport_bcwt_1 <= 1'b0;
      vecNewDistance_rTow1_rsc_dualport_icwt_1 <= 1'b0;
      vecNewDistance_rTow1_rsc_dualport_bcwt_1 <= 1'b0;
      vecOutputBits_rsc_dualport_icwt <= 1'b0;
      vecOutputBits_rsc_dualport_bcwt <= 1'b0;
      mgc_start_sync_mgc_bsync_rv_icwt <= 1'b0;
      mgc_start_sync_mgc_bsync_rv_bcwt <= 1'b0;
      mgc_done_sync_mgc_bsync_rdy_icwt <= 1'b0;
      mgc_done_sync_mgc_bsync_rdy_bcwt <= 1'b0;
      InitDecode_return_triosy_mgc_io_sync_icwt <= 1'b0;
      InitDecode_return_triosy_mgc_io_sync_bcwt <= 1'b0;
      vecOutputBits_triosy_mgc_io_sync_icwt <= 1'b0;
      vecOutputBits_triosy_mgc_io_sync_bcwt <= 1'b0;
      vecNewDistance_rTow1_triosy_mgc_io_sync_icwt <= 1'b0;
      vecNewDistance_rTow1_triosy_mgc_io_sync_bcwt <= 1'b0;
      vecNewDistance_rTow0_triosy_mgc_io_sync_icwt <= 1'b0;
      vecNewDistance_rTow0_triosy_mgc_io_sync_bcwt <= 1'b0;
      iLevel_triosy_mgc_io_sync_icwt <= 1'b0;
      iLevel_triosy_mgc_io_sync_bcwt <= 1'b0;
      iPunctPatPartB_triosy_mgc_io_sync_icwt <= 1'b0;
      iPunctPatPartB_triosy_mgc_io_sync_bcwt <= 1'b0;
      iPunctPatPartA_triosy_mgc_io_sync_icwt <= 1'b0;
      iPunctPatPartA_triosy_mgc_io_sync_bcwt <= 1'b0;
      iNewNumOutBitsPartB_triosy_mgc_io_sync_icwt <= 1'b0;
      iNewNumOutBitsPartB_triosy_mgc_io_sync_bcwt <= 1'b0;
      iNewNumOutBitsPartA_triosy_mgc_io_sync_icwt <= 1'b0;
      iNewNumOutBitsPartA_triosy_mgc_io_sync_bcwt <= 1'b0;
      iN2_triosy_mgc_io_sync_icwt <= 1'b0;
      iN2_triosy_mgc_io_sync_bcwt <= 1'b0;
      iN1_triosy_mgc_io_sync_icwt <= 1'b0;
      iN1_triosy_mgc_io_sync_bcwt <= 1'b0;
      eNewChannelType_triosy_mgc_io_sync_icwt <= 1'b0;
      eNewChannelType_triosy_mgc_io_sync_bcwt <= 1'b0;
      eNewCodingScheme_triosy_mgc_io_sync_icwt <= 1'b0;
      eNewCodingScheme_triosy_mgc_io_sync_bcwt <= 1'b0;
      core_wten <= 1'b0;
    end
    else begin
      vecNewDistance_rTow0_rsc_dualport_icwt_1 <= vecNewDistance_rTow0_rsc_dualport_icwt_1
          ^ vecNewDistance_rTow0_rsc_dualport_tiswt0_1 ^ vecNewDistance_rTow0_rsc_dualport_biwt_1;
      vecNewDistance_rTow0_rsc_dualport_bcwt_1 <= vecNewDistance_rTow0_rsc_dualport_bcwt_1
          ^ vecNewDistance_rTow0_rsc_dualport_biwt_1 ^ and_4_cse;
      vecNewDistance_rTow1_rsc_dualport_icwt_1 <= vecNewDistance_rTow1_rsc_dualport_icwt_1
          ^ vecNewDistance_rTow0_rsc_dualport_tiswt0_1 ^ vecNewDistance_rTow1_rsc_dualport_biwt_1;
      vecNewDistance_rTow1_rsc_dualport_bcwt_1 <= vecNewDistance_rTow1_rsc_dualport_bcwt_1
          ^ vecNewDistance_rTow1_rsc_dualport_biwt_1 ^ and_4_cse;
      vecOutputBits_rsc_dualport_icwt <= vecOutputBits_rsc_dualport_icwt ^ vecOutputBits_rsc_dualport_tiswt0
          ^ vecOutputBits_rsc_dualport_biwt;
      vecOutputBits_rsc_dualport_bcwt <= vecOutputBits_rsc_dualport_bcwt ^ vecOutputBits_rsc_dualport_biwt
          ^ (vecOutputBits_rsc_dualport_oswt & core_wen);
      mgc_start_sync_mgc_bsync_rv_icwt <= mgc_start_sync_mgc_bsync_rv_icwt ^ mgc_start_sync_mgc_bsync_rv_pdswt0
          ^ mgc_start_sync_mgc_bsync_rv_biwt;
      mgc_start_sync_mgc_bsync_rv_bcwt <= mgc_start_sync_mgc_bsync_rv_bcwt ^ mgc_start_sync_mgc_bsync_rv_biwt
          ^ (mgc_start_sync_mgc_bsync_rv_rd_core_psct & core_wen);
      mgc_done_sync_mgc_bsync_rdy_icwt <= mgc_done_sync_mgc_bsync_rdy_icwt ^ mgc_done_sync_mgc_bsync_rdy_pdswt0
          ^ mgc_done_sync_mgc_bsync_rdy_ogwt;
      mgc_done_sync_mgc_bsync_rdy_bcwt <= mgc_done_sync_mgc_bsync_rdy_bcwt ^ mgc_done_sync_mgc_bsync_rdy_ogwt
          ^ and_38_cse;
      InitDecode_return_triosy_mgc_io_sync_icwt <= InitDecode_return_triosy_mgc_io_sync_icwt
          ^ mgc_done_sync_mgc_bsync_rdy_pdswt0 ^ InitDecode_return_triosy_mgc_io_sync_ogwt;
      InitDecode_return_triosy_mgc_io_sync_bcwt <= InitDecode_return_triosy_mgc_io_sync_bcwt
          ^ InitDecode_return_triosy_mgc_io_sync_ogwt ^ and_38_cse;
      vecOutputBits_triosy_mgc_io_sync_icwt <= vecOutputBits_triosy_mgc_io_sync_icwt
          ^ vecOutputBits_triosy_mgc_io_sync_pdswt0 ^ vecOutputBits_triosy_mgc_io_sync_ogwt;
      vecOutputBits_triosy_mgc_io_sync_bcwt <= vecOutputBits_triosy_mgc_io_sync_bcwt
          ^ vecOutputBits_triosy_mgc_io_sync_ogwt ^ and_46_cse;
      vecNewDistance_rTow1_triosy_mgc_io_sync_icwt <= vecNewDistance_rTow1_triosy_mgc_io_sync_icwt
          ^ vecOutputBits_triosy_mgc_io_sync_pdswt0 ^ vecNewDistance_rTow1_triosy_mgc_io_sync_ogwt;
      vecNewDistance_rTow1_triosy_mgc_io_sync_bcwt <= vecNewDistance_rTow1_triosy_mgc_io_sync_bcwt
          ^ vecNewDistance_rTow1_triosy_mgc_io_sync_ogwt ^ and_46_cse;
      vecNewDistance_rTow0_triosy_mgc_io_sync_icwt <= vecNewDistance_rTow0_triosy_mgc_io_sync_icwt
          ^ vecOutputBits_triosy_mgc_io_sync_pdswt0 ^ vecNewDistance_rTow0_triosy_mgc_io_sync_ogwt;
      vecNewDistance_rTow0_triosy_mgc_io_sync_bcwt <= vecNewDistance_rTow0_triosy_mgc_io_sync_bcwt
          ^ vecNewDistance_rTow0_triosy_mgc_io_sync_ogwt ^ and_46_cse;
      iLevel_triosy_mgc_io_sync_icwt <= iLevel_triosy_mgc_io_sync_icwt ^ vecOutputBits_triosy_mgc_io_sync_pdswt0
          ^ iLevel_triosy_mgc_io_sync_ogwt;
      iLevel_triosy_mgc_io_sync_bcwt <= iLevel_triosy_mgc_io_sync_bcwt ^ iLevel_triosy_mgc_io_sync_ogwt
          ^ and_46_cse;
      iPunctPatPartB_triosy_mgc_io_sync_icwt <= iPunctPatPartB_triosy_mgc_io_sync_icwt
          ^ vecOutputBits_triosy_mgc_io_sync_pdswt0 ^ iPunctPatPartB_triosy_mgc_io_sync_ogwt;
      iPunctPatPartB_triosy_mgc_io_sync_bcwt <= iPunctPatPartB_triosy_mgc_io_sync_bcwt
          ^ iPunctPatPartB_triosy_mgc_io_sync_ogwt ^ and_46_cse;
      iPunctPatPartA_triosy_mgc_io_sync_icwt <= iPunctPatPartA_triosy_mgc_io_sync_icwt
          ^ vecOutputBits_triosy_mgc_io_sync_pdswt0 ^ iPunctPatPartA_triosy_mgc_io_sync_ogwt;
      iPunctPatPartA_triosy_mgc_io_sync_bcwt <= iPunctPatPartA_triosy_mgc_io_sync_bcwt
          ^ iPunctPatPartA_triosy_mgc_io_sync_ogwt ^ and_46_cse;
      iNewNumOutBitsPartB_triosy_mgc_io_sync_icwt <= iNewNumOutBitsPartB_triosy_mgc_io_sync_icwt
          ^ vecOutputBits_triosy_mgc_io_sync_pdswt0 ^ iNewNumOutBitsPartB_triosy_mgc_io_sync_ogwt;
      iNewNumOutBitsPartB_triosy_mgc_io_sync_bcwt <= iNewNumOutBitsPartB_triosy_mgc_io_sync_bcwt
          ^ iNewNumOutBitsPartB_triosy_mgc_io_sync_ogwt ^ and_46_cse;
      iNewNumOutBitsPartA_triosy_mgc_io_sync_icwt <= iNewNumOutBitsPartA_triosy_mgc_io_sync_icwt
          ^ vecOutputBits_triosy_mgc_io_sync_pdswt0 ^ iNewNumOutBitsPartA_triosy_mgc_io_sync_ogwt;
      iNewNumOutBitsPartA_triosy_mgc_io_sync_bcwt <= iNewNumOutBitsPartA_triosy_mgc_io_sync_bcwt
          ^ iNewNumOutBitsPartA_triosy_mgc_io_sync_ogwt ^ and_46_cse;
      iN2_triosy_mgc_io_sync_icwt <= iN2_triosy_mgc_io_sync_icwt ^ vecOutputBits_triosy_mgc_io_sync_pdswt0
          ^ iN2_triosy_mgc_io_sync_ogwt;
      iN2_triosy_mgc_io_sync_bcwt <= iN2_triosy_mgc_io_sync_bcwt ^ iN2_triosy_mgc_io_sync_ogwt
          ^ and_46_cse;
      iN1_triosy_mgc_io_sync_icwt <= iN1_triosy_mgc_io_sync_icwt ^ vecOutputBits_triosy_mgc_io_sync_pdswt0
          ^ iN1_triosy_mgc_io_sync_ogwt;
      iN1_triosy_mgc_io_sync_bcwt <= iN1_triosy_mgc_io_sync_bcwt ^ iN1_triosy_mgc_io_sync_ogwt
          ^ and_46_cse;
      eNewChannelType_triosy_mgc_io_sync_icwt <= eNewChannelType_triosy_mgc_io_sync_icwt
          ^ vecOutputBits_triosy_mgc_io_sync_pdswt0 ^ eNewChannelType_triosy_mgc_io_sync_ogwt;
      eNewChannelType_triosy_mgc_io_sync_bcwt <= eNewChannelType_triosy_mgc_io_sync_bcwt
          ^ eNewChannelType_triosy_mgc_io_sync_ogwt ^ and_46_cse;
      eNewCodingScheme_triosy_mgc_io_sync_icwt <= eNewCodingScheme_triosy_mgc_io_sync_icwt
          ^ vecOutputBits_triosy_mgc_io_sync_pdswt0 ^ eNewCodingScheme_triosy_mgc_io_sync_ogwt;
      eNewCodingScheme_triosy_mgc_io_sync_bcwt <= eNewCodingScheme_triosy_mgc_io_sync_bcwt
          ^ eNewCodingScheme_triosy_mgc_io_sync_ogwt ^ and_46_cse;
      core_wten <= ~ core_wen;
    end
  end
endmodule

// ------------------------------------------------------------------
//  Design Unit:    InitDecode_core
// ------------------------------------------------------------------


module InitDecode_core (
  clk, rst, vecNewDistance_rTow0_rsc_dualport_data_out, vecNewDistance_rTow1_rsc_dualport_data_out,
      core_wen, vecNewDistance_rTow0_rsc_dualport_re_core_sct, vecNewDistance_rTow1_rsc_dualport_re_core_sct,
      vecOutputBits_rsc_dualport_data_in_core, vecOutputBits_rsc_dualport_addr_core,
      vecOutputBits_rsc_dualport_we_core_sct, iNewNumOutBitsPartA_rsc_mgc_in_wire_d,
      iNewNumOutBitsPartB_rsc_mgc_in_wire_d, InitDecode_return_rsc_mgc_out_stdreg_d,
      vecTrelMetric1_rsc_dualport_data_in, vecTrelMetric1_rsc_dualport_addr, vecTrelMetric1_rsc_dualport_re,
      vecTrelMetric1_rsc_dualport_we, vecTrelMetric1_rsc_dualport_data_out, vecTrelMetric2_rsc_dualport_data_in,
      vecTrelMetric2_rsc_dualport_addr, vecTrelMetric2_rsc_dualport_re, vecTrelMetric2_rsc_dualport_we,
      vecTrelMetric2_rsc_dualport_data_out, matdecDecisions_rsc_dualport_data_in,
      matdecDecisions_rsc_dualport_addr, matdecDecisions_rsc_dualport_re, matdecDecisions_rsc_dualport_we,
      matdecDecisions_rsc_dualport_data_out, mgc_start_sync_mgc_bsync_rv_rd_core_sct,
      mgc_start_sync_mgc_bsync_rv_vd, mgc_done_sync_mgc_bsync_rdy_rd_core_sct, InitDecode_return_triosy_mgc_io_sync_ld_core_sct,
      vecOutputBits_triosy_mgc_io_sync_ld_core_sct, vecNewDistance_rTow1_triosy_mgc_io_sync_ld_core_sct,
      vecNewDistance_rTow0_triosy_mgc_io_sync_ld_core_sct, iLevel_triosy_mgc_io_sync_ld_core_sct,
      iPunctPatPartB_triosy_mgc_io_sync_ld_core_sct, iPunctPatPartA_triosy_mgc_io_sync_ld_core_sct,
      iNewNumOutBitsPartB_triosy_mgc_io_sync_ld_core_sct, iNewNumOutBitsPartA_triosy_mgc_io_sync_ld_core_sct,
      iN2_triosy_mgc_io_sync_ld_core_sct, iN1_triosy_mgc_io_sync_ld_core_sct, eNewChannelType_triosy_mgc_io_sync_ld_core_sct,
      eNewCodingScheme_triosy_mgc_io_sync_ld_core_sct, div_mgc_div_a, div_mgc_div_b,
      div_mgc_div_z_oreg, vecNewDistance_rTow0_rsc_dualport_addr_core_pff
);
  input clk;
  input rst;
  input [63:0] vecNewDistance_rTow0_rsc_dualport_data_out;
  input [63:0] vecNewDistance_rTow1_rsc_dualport_data_out;
  output core_wen;
  output [1:0] vecNewDistance_rTow0_rsc_dualport_re_core_sct;
  output [1:0] vecNewDistance_rTow1_rsc_dualport_re_core_sct;
  output [15:0] vecOutputBits_rsc_dualport_data_in_core;
  output [11:0] vecOutputBits_rsc_dualport_addr_core;
  output [1:0] vecOutputBits_rsc_dualport_we_core_sct;
  input [31:0] iNewNumOutBitsPartA_rsc_mgc_in_wire_d;
  input [31:0] iNewNumOutBitsPartB_rsc_mgc_in_wire_d;
  output [31:0] InitDecode_return_rsc_mgc_out_stdreg_d;
  reg [31:0] InitDecode_return_rsc_mgc_out_stdreg_d;
  output [63:0] vecTrelMetric1_rsc_dualport_data_in;
  output [11:0] vecTrelMetric1_rsc_dualport_addr;
  output [1:0] vecTrelMetric1_rsc_dualport_re;
  output [1:0] vecTrelMetric1_rsc_dualport_we;
  input [63:0] vecTrelMetric1_rsc_dualport_data_out;
  output [63:0] vecTrelMetric2_rsc_dualport_data_in;
  output [11:0] vecTrelMetric2_rsc_dualport_addr;
  output [1:0] vecTrelMetric2_rsc_dualport_re;
  output [1:0] vecTrelMetric2_rsc_dualport_we;
  input [63:0] vecTrelMetric2_rsc_dualport_data_out;
  output [1:0] matdecDecisions_rsc_dualport_data_in;
  output [23:0] matdecDecisions_rsc_dualport_addr;
  output [1:0] matdecDecisions_rsc_dualport_re;
  output [1:0] matdecDecisions_rsc_dualport_we;
  input [1:0] matdecDecisions_rsc_dualport_data_out;
  output mgc_start_sync_mgc_bsync_rv_rd_core_sct;
  input mgc_start_sync_mgc_bsync_rv_vd;
  output mgc_done_sync_mgc_bsync_rdy_rd_core_sct;
  output InitDecode_return_triosy_mgc_io_sync_ld_core_sct;
  output vecOutputBits_triosy_mgc_io_sync_ld_core_sct;
  output vecNewDistance_rTow1_triosy_mgc_io_sync_ld_core_sct;
  output vecNewDistance_rTow0_triosy_mgc_io_sync_ld_core_sct;
  output iLevel_triosy_mgc_io_sync_ld_core_sct;
  output iPunctPatPartB_triosy_mgc_io_sync_ld_core_sct;
  output iPunctPatPartA_triosy_mgc_io_sync_ld_core_sct;
  output iNewNumOutBitsPartB_triosy_mgc_io_sync_ld_core_sct;
  output iNewNumOutBitsPartA_triosy_mgc_io_sync_ld_core_sct;
  output iN2_triosy_mgc_io_sync_ld_core_sct;
  output iN1_triosy_mgc_io_sync_ld_core_sct;
  output eNewChannelType_triosy_mgc_io_sync_ld_core_sct;
  output eNewCodingScheme_triosy_mgc_io_sync_ld_core_sct;
  output [31:0] div_mgc_div_a;
  reg [31:0] div_mgc_div_a;
  output [31:0] div_mgc_div_b;
  reg [31:0] div_mgc_div_b;
  input [31:0] div_mgc_div_z_oreg;
  output [11:0] vecNewDistance_rTow0_rsc_dualport_addr_core_pff;


  // Interconnect Declarations
  wire vecNewDistance_rTow0_rsc_dualport_bcwt_1;
  wire vecNewDistance_rTow1_rsc_dualport_bcwt_1;
  wire [33:0] fsm_output;
  wire or_dcpl_18;
  wire or_dcpl_38;
  wire or_dcpl_40;
  wire or_dcpl_73;
  wire or_dcpl_79;
  wire or_dcpl_80;
  wire or_dcpl_82;
  wire or_dcpl_86;
  wire or_dcpl_87;
  wire or_dcpl_89;
  wire or_dcpl_95;
  wire or_dcpl_98;
  wire or_dcpl_99;
  wire or_dcpl_103;
  wire or_dcpl_104;
  wire or_dcpl_106;
  wire or_dcpl_129;
  wire or_dcpl_132;
  wire or_dcpl_161;
  wire or_dcpl_164;
  wire or_dcpl_165;
  wire or_dcpl_168;
  wire or_dcpl_173;
  wire or_dcpl_176;
  wire and_dcpl_19;
  wire and_dcpl_22;
  wire and_dcpl_37;
  wire or_dcpl_273;
  reg [31:0] drf_pOldTrelMetric_1_smx_lpi_1;
  reg [31:0] drf_pOldTrelMetric_2_smx_lpi_1;
  reg [31:0] drf_pOldTrelMetric_3_smx_lpi_1;
  reg [31:0] drf_pOldTrelMetric_4_smx_lpi_1;
  reg [31:0] iNumOutBits_sva;
  reg [30:0] acc_3_psp_sva;
  reg [1:0] pCurTrelMetric_2_sva;
  reg [1:0] pOldTrelMetric_2_sva;
  reg [6:0] i_3_sva_1;
  wire [7:0] xi_3_sva_1;
  reg [31:0] iDistCnt_sva;
  reg [31:0] i_2_sva;
  reg [31:0] drf_pOldTrelMetric_1_smx_lpi_2;
  reg [31:0] drf_pOldTrelMetric_2_smx_lpi_2;
  reg [31:0] drf_pOldTrelMetric_3_smx_lpi_2;
  reg [31:0] drf_pOldTrelMetric_4_smx_lpi_2;
  reg [31:0] MAIN_LOOP_if_slc_vecNewDistance_rTow0_cse_sva;
  reg [31:0] MAIN_LOOP_if_slc_vecNewDistance_rTow1_cse_sva;
  reg equal_tmp;
  reg nor_tmp_1;
  reg [31:0] drf_pOldTrelMetric_1_smx_lpi_2_dfm;
  reg [31:0] BUTTERFLY_LOOP_rFiStAccMetricPrev0_slc_vecrMetricSet_1_cse_sva;
  reg [31:0] BUTTERFLY_LOOP_rFiStAccMetricPrev0_sva;
  wire [32:0] xBUTTERFLY_LOOP_rFiStAccMetricPrev0_sva;
  reg [31:0] drf_pOldTrelMetric_2_smx_lpi_2_dfm;
  reg [31:0] BUTTERFLY_LOOP_rFiStAccMetricPrev1_slc_vecrMetricSet_1_cse_sva;
  reg [7:0] BUTTERFLY_LOOP_if_acc_1_ncse_sva;
  reg [31:0] drf_pOldTrelMetric_3_smx_lpi_2_dfm;
  reg [31:0] drf_pOldTrelMetric_4_smx_lpi_2_dfm;
  reg [31:0] BUTTERFLY_LOOP_rSecStAccMetricPrev1_sva;
  reg [5:0] MAIN_LOOP_cnt_1_sva_1;
  reg iCurDecState_sg2_sva;
  reg iCurDecState_sg3_sva;
  reg iCurDecState_sg1_sva;
  reg iCurDecState_sg4_sva;
  reg iCurDecState_1_sva;
  reg iCurDecState_sg5_1_sva;
  reg [31:0] i_sva;
  reg exit_UPDATE_MATRIX_LOOP_sva;
  reg equal_tmp_8;
  reg nor_tmp_8;
  reg [31:0] drf_pOldTrelMetric_5_smx_lpi_dfm;
  reg UPDATE_MATRIX_LOOP_decCurBit_asn_4_itm;
  reg [5:0] UPDATE_MATRIX_LOOP_acc_5_itm;
  wire [6:0] xUPDATE_MATRIX_LOOP_acc_5_itm;
  reg [5:0] i_3_sva_2;
  reg [4:0] MAIN_LOOP_cnt_1_sva_2;
  wire or_293_cse;
  reg reg_vecNewDistance_rTow1_rsc_dualport_re_core_psct_1_cse;
  reg reg_eNewCodingScheme_triosy_mgc_io_sync_iswt0_cse;
  reg reg_InitDecode_return_triosy_mgc_io_sync_iswt0_cse;
  reg reg_start_sync_mgc_bsync_rv_iswt0_cse;
  reg reg_vecOutputBits_rsc_dualport_we_core_psct_1_cse;
  wire or_245_cse;
  wire or_284_cse;
  wire and_43_cse;
  wire [3:0] MAIN_LOOP_b5_1_sva;
  wire [1:0] vecNewDistance_rTow0_rsc_dualport_re_core_sct_reg;
  wire or_78_rmff;
  wire [1:0] vecNewDistance_rTow1_rsc_dualport_re_core_sct_reg;
  wire [1:0] vecOutputBits_rsc_dualport_we_core_sct_reg;
  wire [31:0] mux_1_itm;
  wire [31:0] mux_3_itm;
  wire [33:0] BUTTERFLY_LOOP_if_1_acc_itm;
  wire [34:0] xBUTTERFLY_LOOP_if_1_acc_itm;
  wire [33:0] BUTTERFLY_LOOP_if_1_acc_3_itm;
  wire [34:0] xBUTTERFLY_LOOP_if_1_acc_3_itm;
  wire [33:0] MAIN_LOOP_acc_4_itm;
  wire [34:0] xMAIN_LOOP_acc_4_itm;
  wire [31:0] z_out_1;
  wire [32:0] z_out_2;
  wire [33:0] xz_out_2;
  wire [31:0] iNumOutBits_sva_mx0w0;
  wire [32:0] xiNumOutBits_sva_mx0w0;
  wire [31:0] i_2_sva_1;
  wire [32:0] xi_2_sva_1;
  wire equal_tmp_mx0w0;
  wire nor_tmp_mx0w0;
  wire [31:0] drf_pOldTrelMetric_4_smx_lpi_2_dfm_1;
  wire nor_1_cse;
  wire [31:0] drf_pOldTrelMetric_1_smx_lpi_2_dfm_1;
  reg [31:0] reg_vecNewDistance_rTow0_rsc_dualport_data_out_bfwt_tmp_1;
  reg [31:0] reg_vecNewDistance_rTow1_rsc_dualport_data_out_bfwt_tmp_1;
  reg [31:0] reg_BUTTERFLY_LOOP_rFiStAccMetricPrev1_sva_cse;
  wire [32:0] xreg_BUTTERFLY_LOOP_rFiStAccMetricPrev1_sva_cse;
  wire or_319_cse;
  wire mux_54_m1c;
  wire mux_56_m1c;

  wire[31:0] mux1h_9_nl;
  wire[3:0] mux_66_nl;
  wire[31:0] mux1h_6_nl;
  wire[0:0] mux_67_nl;
  wire[3:0] mux1h_24_nl;
  wire[0:0] mux_68_nl;
  wire[0:0] mux_20_nl;
  wire[7:0] mux_45_nl;
  wire[0:0] mux_46_nl;
  wire[0:0] mux_47_nl;
  wire[0:0] mux_48_nl;
  wire[31:0] mux1h_70_nl;
  wire[0:0] mux_55_nl;
  InitDecodemgc_rom_18_32_4 #(.rom_id(18),
  .size(32),
  .width(4)) BUTTERFLY_LOOP_read_rom_MAIN_LOOP_met0_rom_map_1_rg (
      .addr((MAIN_LOOP_cnt_1_sva_2)),
      .data_out(MAIN_LOOP_b5_1_sva)
    );
  InitDecode_core_wait_ctrl InitDecode_core_wait_ctrl_inst (
      .clk(clk),
      .rst(rst),
      .core_wen(core_wen),
      .vecNewDistance_rTow0_rsc_dualport_re_core_sct(vecNewDistance_rTow0_rsc_dualport_re_core_sct_reg),
      .vecNewDistance_rTow1_rsc_dualport_re_core_sct(vecNewDistance_rTow1_rsc_dualport_re_core_sct_reg),
      .vecOutputBits_rsc_dualport_we_core_sct(vecOutputBits_rsc_dualport_we_core_sct_reg),
      .mgc_start_sync_mgc_bsync_rv_rd_core_sct(mgc_start_sync_mgc_bsync_rv_rd_core_sct),
      .mgc_start_sync_mgc_bsync_rv_vd(mgc_start_sync_mgc_bsync_rv_vd),
      .mgc_done_sync_mgc_bsync_rdy_rd_core_sct(mgc_done_sync_mgc_bsync_rdy_rd_core_sct),
      .InitDecode_return_triosy_mgc_io_sync_ld_core_sct(InitDecode_return_triosy_mgc_io_sync_ld_core_sct),
      .vecOutputBits_triosy_mgc_io_sync_ld_core_sct(vecOutputBits_triosy_mgc_io_sync_ld_core_sct),
      .vecNewDistance_rTow1_triosy_mgc_io_sync_ld_core_sct(vecNewDistance_rTow1_triosy_mgc_io_sync_ld_core_sct),
      .vecNewDistance_rTow0_triosy_mgc_io_sync_ld_core_sct(vecNewDistance_rTow0_triosy_mgc_io_sync_ld_core_sct),
      .iLevel_triosy_mgc_io_sync_ld_core_sct(iLevel_triosy_mgc_io_sync_ld_core_sct),
      .iPunctPatPartB_triosy_mgc_io_sync_ld_core_sct(iPunctPatPartB_triosy_mgc_io_sync_ld_core_sct),
      .iPunctPatPartA_triosy_mgc_io_sync_ld_core_sct(iPunctPatPartA_triosy_mgc_io_sync_ld_core_sct),
      .iNewNumOutBitsPartB_triosy_mgc_io_sync_ld_core_sct(iNewNumOutBitsPartB_triosy_mgc_io_sync_ld_core_sct),
      .iNewNumOutBitsPartA_triosy_mgc_io_sync_ld_core_sct(iNewNumOutBitsPartA_triosy_mgc_io_sync_ld_core_sct),
      .iN2_triosy_mgc_io_sync_ld_core_sct(iN2_triosy_mgc_io_sync_ld_core_sct),
      .iN1_triosy_mgc_io_sync_ld_core_sct(iN1_triosy_mgc_io_sync_ld_core_sct),
      .eNewChannelType_triosy_mgc_io_sync_ld_core_sct(eNewChannelType_triosy_mgc_io_sync_ld_core_sct),
      .eNewCodingScheme_triosy_mgc_io_sync_ld_core_sct(eNewCodingScheme_triosy_mgc_io_sync_ld_core_sct),
      .vecNewDistance_rTow0_rsc_dualport_oswt_1(reg_vecNewDistance_rTow1_rsc_dualport_re_core_psct_1_cse),
      .vecNewDistance_rTow0_rsc_dualport_bcwt_1(vecNewDistance_rTow0_rsc_dualport_bcwt_1),
      .vecNewDistance_rTow0_rsc_dualport_re_core_psct(({1'b0 , or_78_rmff})),
      .vecNewDistance_rTow1_rsc_dualport_bcwt_1(vecNewDistance_rTow1_rsc_dualport_bcwt_1),
      .vecNewDistance_rTow1_rsc_dualport_re_core_psct(({1'b0 , or_78_rmff})),
      .vecOutputBits_rsc_dualport_oswt(reg_vecOutputBits_rsc_dualport_we_core_psct_1_cse),
      .vecOutputBits_rsc_dualport_we_core_psct(({1'b0 , (fsm_output[17])})),
      .mgc_start_sync_mgc_bsync_rv_rd_core_psct(reg_start_sync_mgc_bsync_rv_iswt0_cse),
      .mgc_done_sync_mgc_bsync_rdy_rd_core_psct(reg_InitDecode_return_triosy_mgc_io_sync_iswt0_cse),
      .vecOutputBits_triosy_mgc_io_sync_ld_core_psct(reg_eNewCodingScheme_triosy_mgc_io_sync_iswt0_cse),
      .vecNewDistance_rTow0_rsc_dualport_oswt_1_pff(or_78_rmff),
      .vecOutputBits_rsc_dualport_oswt_pff((fsm_output[17]))
    );
  InitDecode_core_fsm InitDecode_core_fsm_inst (
      .clk(clk),
      .rst(rst),
      .core_wen(core_wen),
      .fsm_output(fsm_output),
      .st_INIT_TRELLIS_LOOP_1_tr0((i_3_sva_1[6])),
      .st_main_3_tr0((~ (z_out_2[32]))),
      .st_BUTTERFLY_LOOP_6_tr0((MAIN_LOOP_cnt_1_sva_1[5])),
      .st_MAIN_LOOP_1_tr0((~ (MAIN_LOOP_acc_4_itm[33]))),
      .st_main_4_tr0((~ (z_out_2[32]))),
      .st_UPDATE_MATRIX_LOOP_2_tr0(exit_UPDATE_MATRIX_LOOP_sva)
    );
  assign mux_1_itm = MUX_v_32_2_2({(vecNewDistance_rTow0_rsc_dualport_data_out[31:0])
      , reg_vecNewDistance_rTow0_rsc_dualport_data_out_bfwt_tmp_1}, vecNewDistance_rTow0_rsc_dualport_bcwt_1);
  assign mux_3_itm = MUX_v_32_2_2({(vecNewDistance_rTow1_rsc_dualport_data_out[31:0])
      , reg_vecNewDistance_rTow1_rsc_dualport_data_out_bfwt_tmp_1}, vecNewDistance_rTow1_rsc_dualport_bcwt_1);
  assign and_43_cse = (fsm_output[13]) & (MAIN_LOOP_cnt_1_sva_1[5]);
  assign or_78_rmff = ((fsm_output[14]) & (MAIN_LOOP_acc_4_itm[33])) | ((z_out_2[32])
      & (fsm_output[5]));
  assign or_245_cse = or_dcpl_73 | (fsm_output[8]) | or_dcpl_18 | or_dcpl_89 | or_dcpl_87
      | or_dcpl_86 | (fsm_output[2]) | (fsm_output[16]) | (fsm_output[17]) | (fsm_output[3])
      | or_dcpl_79;
  assign or_284_cse = or_dcpl_40 | or_dcpl_38 | (fsm_output[13]) | (fsm_output[7])
      | (fsm_output[10]);
  assign xiNumOutBits_sva_mx0w0 = iNewNumOutBitsPartA_rsc_mgc_in_wire_d + iNewNumOutBitsPartB_rsc_mgc_in_wire_d;
  assign iNumOutBits_sva_mx0w0 = xiNumOutBits_sva_mx0w0[31:0];
  assign xi_2_sva_1 = i_2_sva + 32'b1;
  assign i_2_sva_1 = xi_2_sva_1[31:0];
  assign equal_tmp_mx0w0 = (pOldTrelMetric_2_sva[1]) & (~ (pOldTrelMetric_2_sva[0]));
  assign nor_tmp_mx0w0 = ~(((pOldTrelMetric_2_sva[0]) & (~ (pOldTrelMetric_2_sva[1])))
      | equal_tmp_mx0w0);
  assign drf_pOldTrelMetric_4_smx_lpi_2_dfm_1 = MUX1HOT_v_32_3_2({(vecTrelMetric1_rsc_dualport_data_out[63:32])
      , (vecTrelMetric2_rsc_dualport_data_out[31:0]) , drf_pOldTrelMetric_4_smx_lpi_2},
      {nor_1_cse , equal_tmp , nor_tmp_1});
  assign nor_1_cse = ~(equal_tmp | nor_tmp_1);
  assign drf_pOldTrelMetric_1_smx_lpi_2_dfm_1 = MUX1HOT_v_32_3_2({(vecTrelMetric1_rsc_dualport_data_out[31:0])
      , (vecTrelMetric2_rsc_dualport_data_out[63:32]) , drf_pOldTrelMetric_1_smx_lpi_2},
      {nor_1_cse , equal_tmp , nor_tmp_1});
  assign xBUTTERFLY_LOOP_if_1_acc_itm = conv_s2u_33_34({BUTTERFLY_LOOP_rFiStAccMetricPrev0_sva
      , 1'b1}) + conv_s2u_33_34({(~ reg_BUTTERFLY_LOOP_rFiStAccMetricPrev1_sva_cse)
      , 1'b1});
  assign BUTTERFLY_LOOP_if_1_acc_itm = xBUTTERFLY_LOOP_if_1_acc_itm[33:0];
  assign xBUTTERFLY_LOOP_if_1_acc_3_itm = conv_s2u_33_34({reg_BUTTERFLY_LOOP_rFiStAccMetricPrev1_sva_cse
      , 1'b1}) + conv_s2u_33_34({(~ BUTTERFLY_LOOP_rSecStAccMetricPrev1_sva) , 1'b1});
  assign BUTTERFLY_LOOP_if_1_acc_3_itm = xBUTTERFLY_LOOP_if_1_acc_3_itm[33:0];
  assign xMAIN_LOOP_acc_4_itm = conv_s2u_33_34({i_2_sva_1 , 1'b1}) + conv_s2u_33_34({(~
      acc_3_psp_sva) , (~ (iNumOutBits_sva[0])) , 1'b1});
  assign MAIN_LOOP_acc_4_itm = xMAIN_LOOP_acc_4_itm[33:0];
  assign or_dcpl_18 = (fsm_output[11]) | (fsm_output[9]);
  assign or_dcpl_38 = (fsm_output[9]) | (fsm_output[12]);
  assign or_dcpl_40 = (fsm_output[8]) | (fsm_output[11]);
  assign or_dcpl_73 = (fsm_output[6]) | (fsm_output[4]);
  assign or_dcpl_79 = (fsm_output[7]) | (fsm_output[10]);
  assign or_dcpl_80 = (fsm_output[1]) | (fsm_output[3]);
  assign or_dcpl_82 = (fsm_output[16]) | (fsm_output[17]);
  assign or_dcpl_86 = (fsm_output[15]) | (fsm_output[5]);
  assign or_dcpl_87 = (fsm_output[14]) | (fsm_output[18]);
  assign or_dcpl_89 = (fsm_output[12]) | (fsm_output[13]);
  assign or_dcpl_95 = (fsm_output[11]) | (fsm_output[30]);
  assign or_dcpl_98 = (fsm_output[20]) | (fsm_output[6]);
  assign or_dcpl_99 = or_dcpl_98 | (fsm_output[4]) | (fsm_output[8]);
  assign or_dcpl_103 = (fsm_output[24]) | (fsm_output[23]) | (fsm_output[22]) | (fsm_output[21]);
  assign or_dcpl_104 = (fsm_output[26]) | (fsm_output[25]);
  assign or_dcpl_106 = (fsm_output[29]) | (fsm_output[28]) | (fsm_output[27]);
  assign or_dcpl_129 = (fsm_output[18]) | (fsm_output[15]);
  assign or_dcpl_132 = (fsm_output[33]) | (fsm_output[31]);
  assign or_dcpl_161 = (fsm_output[2]) | (fsm_output[0]) | (fsm_output[32]);
  assign or_dcpl_164 = (fsm_output[14]) | (fsm_output[5]);
  assign or_dcpl_165 = ((z_out_2[32]) & (fsm_output[15])) | or_dcpl_164;
  assign or_dcpl_168 = or_dcpl_132 | (fsm_output[9]);
  assign or_dcpl_173 = (fsm_output[30]) | (fsm_output[19]) | ((fsm_output[18]) &
      (~ exit_UPDATE_MATRIX_LOOP_sva));
  assign or_dcpl_176 = or_dcpl_98 | (fsm_output[4]);
  assign and_dcpl_19 = (fsm_output[9]) & (BUTTERFLY_LOOP_if_1_acc_itm[33]);
  assign and_dcpl_22 = (fsm_output[12]) & (~ (BUTTERFLY_LOOP_if_1_acc_3_itm[33]));
  assign and_dcpl_37 = ~((fsm_output[14]) | (fsm_output[5]));
  assign or_dcpl_273 = (fsm_output[6]) | (fsm_output[7]);
  assign or_293_cse = or_dcpl_18 | (fsm_output[12]) | (fsm_output[10]);
  assign vecNewDistance_rTow0_rsc_dualport_addr_core_pff = {6'b0 , ((z_out_2[5:0])
      & (signext_6_1(fsm_output[14])))};
  assign vecNewDistance_rTow0_rsc_dualport_re_core_sct = vecNewDistance_rTow0_rsc_dualport_re_core_sct_reg;
  assign vecNewDistance_rTow1_rsc_dualport_re_core_sct = vecNewDistance_rTow1_rsc_dualport_re_core_sct_reg;
  assign vecOutputBits_rsc_dualport_data_in_core = {15'b0 , (matdecDecisions_rsc_dualport_data_out[0])};
  assign vecOutputBits_rsc_dualport_addr_core = {6'b0 , UPDATE_MATRIX_LOOP_acc_5_itm};
  assign vecOutputBits_rsc_dualport_we_core_sct = vecOutputBits_rsc_dualport_we_core_sct_reg;
  assign or_319_cse = ((fsm_output[9]) & (~ (BUTTERFLY_LOOP_if_1_acc_itm[33]))) |
      ((fsm_output[12]) & (BUTTERFLY_LOOP_if_1_acc_3_itm[33]));
  assign mux1h_9_nl = MUX1HOT_v_32_3_2({BUTTERFLY_LOOP_rFiStAccMetricPrev0_sva ,
      reg_BUTTERFLY_LOOP_rFiStAccMetricPrev1_sva_cse , BUTTERFLY_LOOP_rSecStAccMetricPrev1_sva},
      {and_dcpl_19 , or_319_cse , and_dcpl_22});
  assign vecTrelMetric1_rsc_dualport_data_in = {32'b0 , (mux1h_9_nl)};
  assign mux_66_nl = MUX_v_4_2_2({(MAIN_LOOP_cnt_1_sva_2[4:1]) , (MAIN_LOOP_cnt_1_sva_2[3:0])},
      or_dcpl_38);
  assign vecTrelMetric1_rsc_dualport_addr = {(fsm_output[7]) , MAIN_LOOP_cnt_1_sva_2
      , ((MAIN_LOOP_cnt_1_sva_2[4]) & (~ or_dcpl_129) & (~((fsm_output[7]) | (fsm_output[10]))))
      , ((mux_66_nl) & (signext_4_1(~ or_dcpl_129))) , (((MAIN_LOOP_cnt_1_sva_2[0])
      & (~ or_dcpl_129) & (~ (fsm_output[9]))) | (fsm_output[12]))};
  assign vecTrelMetric1_rsc_dualport_re = ({(~((fsm_output[7]) & (~ (pOldTrelMetric_2_sva[1]))
      & (pOldTrelMetric_2_sva[0]))) , 1'b0}) | (signext_2_1(or_dcpl_106 | or_dcpl_104
      | or_dcpl_103 | or_dcpl_176 | or_dcpl_40 | or_dcpl_173 | or_dcpl_168 | or_dcpl_89
      | or_dcpl_165 | or_dcpl_161 | or_dcpl_82 | or_dcpl_80 | (pOldTrelMetric_2_sva[1])
      | (~ (pOldTrelMetric_2_sva[0]))));
  assign vecTrelMetric1_rsc_dualport_we = {1'b1 , (~(or_dcpl_38 & (pCurTrelMetric_2_sva[0])
      & (~ (pCurTrelMetric_2_sva[1]))))};
  assign mux1h_6_nl = MUX1HOT_v_32_4_2({32'b10011100010000 , BUTTERFLY_LOOP_rFiStAccMetricPrev0_sva
      , reg_BUTTERFLY_LOOP_rFiStAccMetricPrev1_sva_cse , BUTTERFLY_LOOP_rSecStAccMetricPrev1_sva},
      {(fsm_output[3]) , and_dcpl_19 , or_319_cse , and_dcpl_22});
  assign vecTrelMetric2_rsc_dualport_data_in = {32'b0 , ((mux1h_6_nl) & (signext_32_1(~
      (fsm_output[1]))))};
  assign mux_67_nl = MUX_s_1_2_2({(i_3_sva_2[5]) , (MAIN_LOOP_cnt_1_sva_2[4])}, or_dcpl_38);
  assign mux1h_24_nl = MUX1HOT_v_4_3_2({(i_3_sva_2[4:1]) , (MAIN_LOOP_cnt_1_sva_2[4:1])
      , (MAIN_LOOP_cnt_1_sva_2[3:0])}, {(fsm_output[3]) , or_dcpl_79 , or_dcpl_38});
  assign mux_68_nl = MUX_s_1_2_2({(i_3_sva_2[0]) , (MAIN_LOOP_cnt_1_sva_2[0])}, or_dcpl_79);
  assign vecTrelMetric2_rsc_dualport_addr = {(~ (fsm_output[7])) , MAIN_LOOP_cnt_1_sva_2
      , (((mux_67_nl) & (~ or_dcpl_129) & (~((fsm_output[1]) | (fsm_output[10]))))
      | (fsm_output[7])) , ((mux1h_24_nl) & (signext_4_1(~ or_dcpl_129)) & (signext_4_1(~
      (fsm_output[1])))) , (((mux_68_nl) & (~ or_dcpl_129) & (~((fsm_output[1]) |
      (fsm_output[9])))) | (fsm_output[12]))};
  assign vecTrelMetric2_rsc_dualport_re = ({(~((fsm_output[7]) & (pOldTrelMetric_2_sva[1])
      & (~ (pOldTrelMetric_2_sva[0])))) , 1'b0}) | (signext_2_1(or_dcpl_106 | or_dcpl_104
      | or_dcpl_103 | or_dcpl_176 | or_dcpl_40 | or_dcpl_173 | or_dcpl_168 | or_dcpl_89
      | or_dcpl_165 | or_dcpl_161 | or_dcpl_82 | or_dcpl_80 | (~ (pOldTrelMetric_2_sva[1]))
      | (pOldTrelMetric_2_sva[0])));
  assign vecTrelMetric2_rsc_dualport_we = {1'b1 , ((or_dcpl_38 & ((pCurTrelMetric_2_sva[0])
      | (~ (pCurTrelMetric_2_sva[1])))) | (fsm_output[29]) | (fsm_output[28]) | (fsm_output[27])
      | or_dcpl_104 | or_dcpl_103 | or_dcpl_99 | or_dcpl_95 | (fsm_output[19]) |
      or_dcpl_132 | (fsm_output[13]) | (fsm_output[14]) | or_dcpl_129 | (fsm_output[5])
      | (fsm_output[2]) | (fsm_output[0]) | (fsm_output[32]) | or_dcpl_82 | or_dcpl_79)};
  assign mux_20_nl = MUX_s_1_2_2({(~ (BUTTERFLY_LOOP_if_1_acc_itm[33])) , (~ (BUTTERFLY_LOOP_if_1_acc_3_itm[33]))},
      fsm_output[12]);
  assign matdecDecisions_rsc_dualport_data_in = {1'b0 , (mux_20_nl)};
  assign mux_45_nl = MUX_v_8_2_2({BUTTERFLY_LOOP_if_acc_1_ncse_sva , (((~ (i_sva[7:0]))
      + conv_u2u_2_8({iCurDecState_sg5_1_sva , iCurDecState_sg3_sva})) + ({(acc_3_psp_sva[6:0])
      , (iNumOutBits_sva[0])}))}, fsm_output[16]);
  assign mux_46_nl = MUX_s_1_2_2({(MAIN_LOOP_cnt_1_sva_2[2]) , iCurDecState_sg2_sva},
      fsm_output[16]);
  assign mux_47_nl = MUX_s_1_2_2({(MAIN_LOOP_cnt_1_sva_2[1]) , iCurDecState_sg1_sva},
      fsm_output[16]);
  assign mux_48_nl = MUX_s_1_2_2({(MAIN_LOOP_cnt_1_sva_2[0]) , iCurDecState_1_sva},
      fsm_output[16]);
  assign matdecDecisions_rsc_dualport_addr = {12'b0 , (mux_45_nl) , (mux_46_nl) ,
      (mux_47_nl) , (mux_48_nl) , ((UPDATE_MATRIX_LOOP_decCurBit_asn_4_itm & (~ (fsm_output[9])))
      | (fsm_output[12]))};
  assign matdecDecisions_rsc_dualport_re = {1'b1 , (~ (fsm_output[16]))};
  assign matdecDecisions_rsc_dualport_we = {1'b1 , (~ or_dcpl_38)};
  always @(posedge clk) begin
    if ( rst ) begin
      InitDecode_return_rsc_mgc_out_stdreg_d <= 32'b0;
      drf_pOldTrelMetric_5_smx_lpi_dfm <= 32'b0;
      pOldTrelMetric_2_sva <= 2'b0;
      pCurTrelMetric_2_sva <= 2'b0;
      drf_pOldTrelMetric_1_smx_lpi_1 <= 32'b0;
      drf_pOldTrelMetric_2_smx_lpi_1 <= 32'b0;
      drf_pOldTrelMetric_3_smx_lpi_1 <= 32'b0;
      drf_pOldTrelMetric_4_smx_lpi_1 <= 32'b0;
      i_3_sva_2 <= 6'b0;
      reg_vecOutputBits_rsc_dualport_we_core_psct_1_cse <= 1'b0;
      reg_vecNewDistance_rTow1_rsc_dualport_re_core_psct_1_cse <= 1'b0;
      reg_eNewCodingScheme_triosy_mgc_io_sync_iswt0_cse <= 1'b0;
      reg_InitDecode_return_triosy_mgc_io_sync_iswt0_cse <= 1'b0;
      reg_start_sync_mgc_bsync_rv_iswt0_cse <= 1'b0;
      div_mgc_div_b <= 32'b0;
      div_mgc_div_a <= 32'b0;
      iNumOutBits_sva <= 32'b0;
      acc_3_psp_sva <= 31'b0;
      i_3_sva_1 <= 7'b0;
      iDistCnt_sva <= 32'b0;
      i_sva <= 32'b0;
      iCurDecState_sg5_1_sva <= 1'b0;
      iCurDecState_1_sva <= 1'b0;
      iCurDecState_sg1_sva <= 1'b0;
      iCurDecState_sg2_sva <= 1'b0;
      iCurDecState_sg3_sva <= 1'b0;
      iCurDecState_sg4_sva <= 1'b0;
      MAIN_LOOP_cnt_1_sva_2 <= 5'b0;
      i_2_sva <= 32'b0;
      drf_pOldTrelMetric_3_smx_lpi_2 <= 32'b0;
      drf_pOldTrelMetric_4_smx_lpi_2 <= 32'b0;
      drf_pOldTrelMetric_2_smx_lpi_2 <= 32'b0;
      drf_pOldTrelMetric_1_smx_lpi_2 <= 32'b0;
      MAIN_LOOP_if_slc_vecNewDistance_rTow0_cse_sva <= 32'b0;
      MAIN_LOOP_if_slc_vecNewDistance_rTow1_cse_sva <= 32'b0;
      MAIN_LOOP_cnt_1_sva_1 <= 6'b0;
      BUTTERFLY_LOOP_if_acc_1_ncse_sva <= 8'b0;
      BUTTERFLY_LOOP_rFiStAccMetricPrev1_slc_vecrMetricSet_1_cse_sva <= 32'b0;
      equal_tmp <= 1'b0;
      nor_tmp_1 <= 1'b0;
      BUTTERFLY_LOOP_rFiStAccMetricPrev0_slc_vecrMetricSet_1_cse_sva <= 32'b0;
      BUTTERFLY_LOOP_rFiStAccMetricPrev0_sva <= 32'b0;
      reg_BUTTERFLY_LOOP_rFiStAccMetricPrev1_sva_cse <= 32'b0;
      BUTTERFLY_LOOP_rSecStAccMetricPrev1_sva <= 32'b0;
      drf_pOldTrelMetric_4_smx_lpi_2_dfm <= 32'b0;
      drf_pOldTrelMetric_2_smx_lpi_2_dfm <= 32'b0;
      drf_pOldTrelMetric_1_smx_lpi_2_dfm <= 32'b0;
      drf_pOldTrelMetric_3_smx_lpi_2_dfm <= 32'b0;
      equal_tmp_8 <= 1'b0;
      nor_tmp_8 <= 1'b0;
      exit_UPDATE_MATRIX_LOOP_sva <= 1'b0;
      UPDATE_MATRIX_LOOP_decCurBit_asn_4_itm <= 1'b0;
      UPDATE_MATRIX_LOOP_acc_5_itm <= 6'b0;
    end
    else if ( core_wen ) begin
      InitDecode_return_rsc_mgc_out_stdreg_d <= MUX_v_32_2_2({InitDecode_return_rsc_mgc_out_stdreg_d
          , div_mgc_div_z_oreg}, fsm_output[32]);
      drf_pOldTrelMetric_5_smx_lpi_dfm <= MUX_v_32_2_2({drf_pOldTrelMetric_5_smx_lpi_dfm
          , z_out_1}, fsm_output[19]);
      pOldTrelMetric_2_sva <= MUX1HOT_v_2_3_2({2'b10 , pCurTrelMetric_2_sva , pOldTrelMetric_2_sva},
          {(fsm_output[2]) , and_43_cse , (~(and_43_cse | (fsm_output[2])))});
      pCurTrelMetric_2_sva <= MUX1HOT_v_2_3_2({2'b1 , pCurTrelMetric_2_sva , pOldTrelMetric_2_sva},
          {(fsm_output[2]) , (or_dcpl_73 | or_dcpl_40 | or_dcpl_38 | (fsm_output[14])
          | ((fsm_output[13]) & (~ (MAIN_LOOP_cnt_1_sva_1[5]))) | (fsm_output[5])
          | (fsm_output[3]) | (fsm_output[7]) | (fsm_output[10])) , and_43_cse});
      drf_pOldTrelMetric_1_smx_lpi_1 <= MUX_v_32_2_2({drf_pOldTrelMetric_1_smx_lpi_1
          , drf_pOldTrelMetric_1_smx_lpi_2_dfm}, fsm_output[13]);
      drf_pOldTrelMetric_2_smx_lpi_1 <= MUX_v_32_2_2({drf_pOldTrelMetric_2_smx_lpi_1
          , drf_pOldTrelMetric_2_smx_lpi_2_dfm}, fsm_output[13]);
      drf_pOldTrelMetric_3_smx_lpi_1 <= MUX_v_32_2_2({drf_pOldTrelMetric_3_smx_lpi_1
          , drf_pOldTrelMetric_3_smx_lpi_2_dfm}, fsm_output[13]);
      drf_pOldTrelMetric_4_smx_lpi_1 <= MUX_v_32_2_2({drf_pOldTrelMetric_4_smx_lpi_1
          , drf_pOldTrelMetric_4_smx_lpi_2_dfm}, fsm_output[13]);
      i_3_sva_2 <= MUX_v_6_2_2({6'b1 , (i_3_sva_1[5:0])}, fsm_output[4]);
      reg_vecOutputBits_rsc_dualport_we_core_psct_1_cse <= fsm_output[17];
      reg_vecNewDistance_rTow1_rsc_dualport_re_core_psct_1_cse <= or_78_rmff;
      reg_eNewCodingScheme_triosy_mgc_io_sync_iswt0_cse <= ((fsm_output[18]) & exit_UPDATE_MATRIX_LOOP_sva)
          | ((~ (z_out_2[32])) & (fsm_output[15]));
      reg_InitDecode_return_triosy_mgc_io_sync_iswt0_cse <= fsm_output[32];
      reg_start_sync_mgc_bsync_rv_iswt0_cse <= ~(or_dcpl_106 | or_dcpl_104 | or_dcpl_103
          | or_dcpl_99 | or_dcpl_95 | (fsm_output[19]) | (fsm_output[33]) | (fsm_output[31])
          | (fsm_output[9]) | or_dcpl_89 | or_dcpl_87 | or_dcpl_86 | (fsm_output[2])
          | (fsm_output[32]) | or_dcpl_82 | or_dcpl_80 | or_dcpl_79);
      div_mgc_div_b <= iDistCnt_sva;
      div_mgc_div_a <= MUX_v_32_2_2({z_out_1 , drf_pOldTrelMetric_5_smx_lpi_dfm},
          or_dcpl_106 | or_dcpl_104 | (fsm_output[24]) | (fsm_output[23]) | (fsm_output[22])
          | (fsm_output[21]) | (fsm_output[20]) | (fsm_output[30]));
      iNumOutBits_sva <= MUX_v_32_2_2({iNumOutBits_sva_mx0w0 , iNumOutBits_sva},
          or_245_cse);
      acc_3_psp_sva <= MUX_v_31_2_2({((iNumOutBits_sva_mx0w0[31:1]) + 31'b11) , acc_3_psp_sva},
          or_245_cse);
      i_3_sva_1 <= xi_3_sva_1[6:0];
      iDistCnt_sva <= (MUX_v_32_2_2({(z_out_2[31:0]) , iDistCnt_sva}, and_dcpl_37))
          & (signext_32_1(~ (fsm_output[5])));
      i_sva <= (MUX_v_32_2_2({(z_out_2[31:0]) , i_sva}, (fsm_output[18]) | (fsm_output[17])))
          & (signext_32_1(~ (fsm_output[15])));
      iCurDecState_sg5_1_sva <= (MUX_s_1_2_2({(matdecDecisions_rsc_dualport_data_out[0])
          , iCurDecState_sg5_1_sva}, fsm_output[18])) & (~ (fsm_output[15]));
      iCurDecState_1_sva <= (MUX_s_1_2_2({iCurDecState_1_sva , iCurDecState_sg1_sva},
          fsm_output[18])) & (~ (fsm_output[15]));
      iCurDecState_sg1_sva <= (MUX_s_1_2_2({iCurDecState_sg1_sva , iCurDecState_sg2_sva},
          fsm_output[18])) & (~ (fsm_output[15]));
      iCurDecState_sg2_sva <= (MUX_s_1_2_2({iCurDecState_sg2_sva , iCurDecState_sg3_sva},
          fsm_output[18])) & (~ (fsm_output[15]));
      iCurDecState_sg3_sva <= (MUX_s_1_2_2({iCurDecState_sg3_sva , iCurDecState_sg4_sva},
          fsm_output[18])) & (~ (fsm_output[15]));
      iCurDecState_sg4_sva <= (MUX_s_1_2_2({iCurDecState_sg4_sva , iCurDecState_sg5_1_sva},
          fsm_output[18])) & (~ (fsm_output[15]));
      MAIN_LOOP_cnt_1_sva_2 <= (MUX_v_5_2_2({(MAIN_LOOP_cnt_1_sva_1[4:0]) , MAIN_LOOP_cnt_1_sva_2},
          ~((fsm_output[6]) | (fsm_output[13])))) & (signext_5_1(~ (fsm_output[6])));
      i_2_sva <= (MUX_v_32_2_2({i_2_sva_1 , i_2_sva}, and_dcpl_37)) & (signext_32_1(~
          (fsm_output[5])));
      drf_pOldTrelMetric_3_smx_lpi_2 <= MUX1HOT_v_32_3_2({drf_pOldTrelMetric_3_smx_lpi_1
          , drf_pOldTrelMetric_3_smx_lpi_2 , drf_pOldTrelMetric_3_smx_lpi_2_dfm},
          {or_dcpl_164 , ((fsm_output[6]) | (fsm_output[8]) | (fsm_output[9]) | or_dcpl_79)
          , (fsm_output[13])});
      drf_pOldTrelMetric_4_smx_lpi_2 <= MUX1HOT_v_32_3_2({drf_pOldTrelMetric_4_smx_lpi_1
          , drf_pOldTrelMetric_4_smx_lpi_2 , drf_pOldTrelMetric_4_smx_lpi_2_dfm},
          {or_dcpl_164 , or_dcpl_273 , (fsm_output[13])});
      drf_pOldTrelMetric_2_smx_lpi_2 <= MUX1HOT_v_32_3_2({drf_pOldTrelMetric_2_smx_lpi_1
          , drf_pOldTrelMetric_2_smx_lpi_2 , drf_pOldTrelMetric_2_smx_lpi_2_dfm},
          {or_dcpl_164 , or_dcpl_273 , (fsm_output[13])});
      drf_pOldTrelMetric_1_smx_lpi_2 <= MUX1HOT_v_32_3_2({drf_pOldTrelMetric_1_smx_lpi_1
          , drf_pOldTrelMetric_1_smx_lpi_2 , drf_pOldTrelMetric_1_smx_lpi_2_dfm},
          {or_dcpl_164 , or_dcpl_273 , (fsm_output[13])});
      MAIN_LOOP_if_slc_vecNewDistance_rTow0_cse_sva <= MUX_v_32_2_2({mux_1_itm ,
          MAIN_LOOP_if_slc_vecNewDistance_rTow0_cse_sva}, or_284_cse);
      MAIN_LOOP_if_slc_vecNewDistance_rTow1_cse_sva <= MUX_v_32_2_2({mux_3_itm ,
          MAIN_LOOP_if_slc_vecNewDistance_rTow1_cse_sva}, or_284_cse);
      MAIN_LOOP_cnt_1_sva_1 <= MUX_v_6_2_2({MAIN_LOOP_cnt_1_sva_1 , (conv_u2u_5_6(MAIN_LOOP_cnt_1_sva_2)
          + 6'b1)}, fsm_output[7]);
      BUTTERFLY_LOOP_if_acc_1_ncse_sva <= MUX_v_8_2_2({BUTTERFLY_LOOP_if_acc_1_ncse_sva
          , ((i_2_sva[7:0]) + conv_u2u_2_8(MAIN_LOOP_cnt_1_sva_2[4:3]))}, fsm_output[7]);
      BUTTERFLY_LOOP_rFiStAccMetricPrev1_slc_vecrMetricSet_1_cse_sva <= MUX1HOT_v_32_3_2({BUTTERFLY_LOOP_rFiStAccMetricPrev1_slc_vecrMetricSet_1_cse_sva
          , MAIN_LOOP_if_slc_vecNewDistance_rTow1_cse_sva , MAIN_LOOP_if_slc_vecNewDistance_rTow0_cse_sva},
          {(~ (fsm_output[7])) , (((~((MAIN_LOOP_b5_1_sva[3]) | (MAIN_LOOP_b5_1_sva[2])
          | (MAIN_LOOP_b5_1_sva[1]) | (MAIN_LOOP_b5_1_sva[0]))) & (fsm_output[7]))
          | ((MAIN_LOOP_b5_1_sva[1]) & (~((MAIN_LOOP_b5_1_sva[3]) | (MAIN_LOOP_b5_1_sva[2])
          | (MAIN_LOOP_b5_1_sva[0]))) & (fsm_output[7])) | ((MAIN_LOOP_b5_1_sva[2])
          & (~((MAIN_LOOP_b5_1_sva[3]) | (MAIN_LOOP_b5_1_sva[1]) | (MAIN_LOOP_b5_1_sva[0])))
          & (fsm_output[7])) | ((MAIN_LOOP_b5_1_sva[2]) & (MAIN_LOOP_b5_1_sva[1])
          & (~((MAIN_LOOP_b5_1_sva[3]) | (MAIN_LOOP_b5_1_sva[0]))) & (fsm_output[7])))
          , (((MAIN_LOOP_b5_1_sva[3]) & (MAIN_LOOP_b5_1_sva[0]) & (~((MAIN_LOOP_b5_1_sva[2])
          | (MAIN_LOOP_b5_1_sva[1]))) & (fsm_output[7])) | ((MAIN_LOOP_b5_1_sva[3])
          & (MAIN_LOOP_b5_1_sva[1]) & (MAIN_LOOP_b5_1_sva[0]) & (~ (MAIN_LOOP_b5_1_sva[2]))
          & (fsm_output[7])) | ((MAIN_LOOP_b5_1_sva[3]) & (MAIN_LOOP_b5_1_sva[2])
          & (MAIN_LOOP_b5_1_sva[0]) & (~ (MAIN_LOOP_b5_1_sva[1])) & (fsm_output[7]))
          | ((MAIN_LOOP_b5_1_sva[3]) & (MAIN_LOOP_b5_1_sva[2]) & (MAIN_LOOP_b5_1_sva[1])
          & (MAIN_LOOP_b5_1_sva[0]) & (fsm_output[7])))});
      equal_tmp <= MUX_s_1_2_2({equal_tmp , equal_tmp_mx0w0}, fsm_output[7]);
      nor_tmp_1 <= MUX_s_1_2_2({nor_tmp_1 , nor_tmp_mx0w0}, fsm_output[7]);
      BUTTERFLY_LOOP_rFiStAccMetricPrev0_slc_vecrMetricSet_1_cse_sva <= MUX_v_32_16_2({MAIN_LOOP_if_slc_vecNewDistance_rTow0_cse_sva
          , 32'b0 , MAIN_LOOP_if_slc_vecNewDistance_rTow0_cse_sva , 32'b0 , MAIN_LOOP_if_slc_vecNewDistance_rTow0_cse_sva
          , 32'b0 , MAIN_LOOP_if_slc_vecNewDistance_rTow0_cse_sva , 32'b0 , 32'b0
          , MAIN_LOOP_if_slc_vecNewDistance_rTow1_cse_sva , 32'b0 , MAIN_LOOP_if_slc_vecNewDistance_rTow1_cse_sva
          , 32'b0 , MAIN_LOOP_if_slc_vecNewDistance_rTow1_cse_sva , 32'b0 , MAIN_LOOP_if_slc_vecNewDistance_rTow1_cse_sva},
          MAIN_LOOP_b5_1_sva);
      BUTTERFLY_LOOP_rFiStAccMetricPrev0_sva <= xBUTTERFLY_LOOP_rFiStAccMetricPrev0_sva[31:0];
      reg_BUTTERFLY_LOOP_rFiStAccMetricPrev1_sva_cse <= xreg_BUTTERFLY_LOOP_rFiStAccMetricPrev1_sva_cse[31:0];
      BUTTERFLY_LOOP_rSecStAccMetricPrev1_sva <= MUX_v_32_2_2({BUTTERFLY_LOOP_rSecStAccMetricPrev1_sva
          , (drf_pOldTrelMetric_4_smx_lpi_2_dfm_1 + BUTTERFLY_LOOP_rFiStAccMetricPrev0_slc_vecrMetricSet_1_cse_sva)},
          fsm_output[8]);
      drf_pOldTrelMetric_4_smx_lpi_2_dfm <= MUX_v_32_2_2({drf_pOldTrelMetric_4_smx_lpi_2_dfm_1
          , drf_pOldTrelMetric_4_smx_lpi_2_dfm}, or_293_cse);
      drf_pOldTrelMetric_2_smx_lpi_2_dfm <= MUX_v_32_2_2({z_out_1 , drf_pOldTrelMetric_2_smx_lpi_2_dfm},
          or_293_cse);
      drf_pOldTrelMetric_1_smx_lpi_2_dfm <= MUX_v_32_2_2({drf_pOldTrelMetric_1_smx_lpi_2_dfm_1
          , drf_pOldTrelMetric_1_smx_lpi_2_dfm}, or_293_cse);
      drf_pOldTrelMetric_3_smx_lpi_2_dfm <= MUX_v_32_2_2({z_out_1 , drf_pOldTrelMetric_3_smx_lpi_2_dfm},
          fsm_output[12]);
      equal_tmp_8 <= equal_tmp_mx0w0;
      nor_tmp_8 <= nor_tmp_mx0w0;
      exit_UPDATE_MATRIX_LOOP_sva <= MUX_s_1_2_2({exit_UPDATE_MATRIX_LOOP_sva , (~
          (readslicef_34_1_33((conv_s2u_33_34({(z_out_2[31:0]) , 1'b1}) + conv_s2u_33_34({(~
          iNumOutBits_sva) , 1'b1})))))}, fsm_output[16]);
      UPDATE_MATRIX_LOOP_decCurBit_asn_4_itm <= iCurDecState_1_sva & (fsm_output[18]);
      UPDATE_MATRIX_LOOP_acc_5_itm <= xUPDATE_MATRIX_LOOP_acc_5_itm[5:0];
    end
  end
  always @(posedge clk) begin
    if ( rst ) begin
      reg_vecNewDistance_rTow0_rsc_dualport_data_out_bfwt_tmp_1 <= 32'b0;
      reg_vecNewDistance_rTow1_rsc_dualport_data_out_bfwt_tmp_1 <= 32'b0;
    end
    else begin
      reg_vecNewDistance_rTow0_rsc_dualport_data_out_bfwt_tmp_1 <= mux_1_itm;
      reg_vecNewDistance_rTow1_rsc_dualport_data_out_bfwt_tmp_1 <= mux_3_itm;
    end
  end
  assign xi_3_sva_1  = conv_u2u_6_7(i_3_sva_2) + 7'b1;
  assign xBUTTERFLY_LOOP_rFiStAccMetricPrev0_sva  = drf_pOldTrelMetric_1_smx_lpi_2_dfm_1
      + BUTTERFLY_LOOP_rFiStAccMetricPrev0_slc_vecrMetricSet_1_cse_sva;
  assign xreg_BUTTERFLY_LOOP_rFiStAccMetricPrev1_sva_cse  = z_out_1 + BUTTERFLY_LOOP_rFiStAccMetricPrev1_slc_vecrMetricSet_1_cse_sva;
  assign xUPDATE_MATRIX_LOOP_acc_5_itm  = (iNumOutBits_sva[5:0]) + (~ (i_sva[5:0]));
  assign mux1h_70_nl = MUX1HOT_v_32_4_2({iDistCnt_sva , i_sva , (~ iNumOutBits_sva)
      , ({(~ acc_3_psp_sva) , (~ (iNumOutBits_sva[0]))})}, {(fsm_output[14]) , (fsm_output[16])
      , (fsm_output[15]) , (fsm_output[5])});
  assign xz_out_2 = conv_s2u_32_33(mux1h_70_nl) + 33'b1;
  assign z_out_2 = xz_out_2[32:0];
  assign mux_54_m1c = MUX_s_1_2_2({(~(equal_tmp_8 | nor_tmp_8)) , nor_1_cse}, or_dcpl_40);
  assign mux_56_m1c = MUX_s_1_2_2({nor_tmp_8 , nor_tmp_1}, or_dcpl_40);
  assign mux_55_nl = MUX_s_1_2_2({equal_tmp_8 , equal_tmp}, or_dcpl_40);
  assign z_out_1 = MUX1HOT_v_32_6_2({(vecTrelMetric1_rsc_dualport_data_out[31:0])
      , (vecTrelMetric1_rsc_dualport_data_out[63:32]) , (vecTrelMetric2_rsc_dualport_data_out[31:0])
      , drf_pOldTrelMetric_5_smx_lpi_dfm , drf_pOldTrelMetric_2_smx_lpi_2 , drf_pOldTrelMetric_3_smx_lpi_2},
      {((~ (fsm_output[8])) & mux_54_m1c) , ((fsm_output[8]) & mux_54_m1c) , (mux_55_nl)
      , ((fsm_output[19]) & mux_56_m1c) , ((fsm_output[8]) & mux_56_m1c) , ((fsm_output[11])
      & mux_56_m1c)});

  function [31:0] MUX_v_32_2_2;
    input [63:0] inputs;
    input [0:0] sel;
    reg [31:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = inputs[63:32];
      end
      1'b1 : begin
        result = inputs[31:0];
      end
      default : begin
        result = inputs[63:32];
      end
    endcase
    MUX_v_32_2_2 = result;
  end
  endfunction


  function [31:0] MUX1HOT_v_32_3_2;
    input [95:0] inputs;
    input [2:0] sel;
    reg [31:0] result;
    integer i;
  begin
    result = inputs[0+:32] & {32{sel[0]}};
    for( i = 1; i < 3; i = i + 1 )
      result = result | (inputs[i*32+:32] & {32{sel[i]}});
    MUX1HOT_v_32_3_2 = result;
  end
  endfunction


  function [5:0] signext_6_1;
    input [0:0] vector;
  begin
    signext_6_1= {{5{vector[0]}}, vector};
  end
  endfunction


  function [3:0] MUX_v_4_2_2;
    input [7:0] inputs;
    input [0:0] sel;
    reg [3:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = inputs[7:4];
      end
      1'b1 : begin
        result = inputs[3:0];
      end
      default : begin
        result = inputs[7:4];
      end
    endcase
    MUX_v_4_2_2 = result;
  end
  endfunction


  function [3:0] signext_4_1;
    input [0:0] vector;
  begin
    signext_4_1= {{3{vector[0]}}, vector};
  end
  endfunction


  function [1:0] signext_2_1;
    input [0:0] vector;
  begin
    signext_2_1= {{1{vector[0]}}, vector};
  end
  endfunction


  function [31:0] MUX1HOT_v_32_4_2;
    input [127:0] inputs;
    input [3:0] sel;
    reg [31:0] result;
    integer i;
  begin
    result = inputs[0+:32] & {32{sel[0]}};
    for( i = 1; i < 4; i = i + 1 )
      result = result | (inputs[i*32+:32] & {32{sel[i]}});
    MUX1HOT_v_32_4_2 = result;
  end
  endfunction


  function [31:0] signext_32_1;
    input [0:0] vector;
  begin
    signext_32_1= {{31{vector[0]}}, vector};
  end
  endfunction


  function [0:0] MUX_s_1_2_2;
    input [1:0] inputs;
    input [0:0] sel;
    reg [0:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = inputs[1:1];
      end
      1'b1 : begin
        result = inputs[0:0];
      end
      default : begin
        result = inputs[1:1];
      end
    endcase
    MUX_s_1_2_2 = result;
  end
  endfunction


  function [3:0] MUX1HOT_v_4_3_2;
    input [11:0] inputs;
    input [2:0] sel;
    reg [3:0] result;
    integer i;
  begin
    result = inputs[0+:4] & {4{sel[0]}};
    for( i = 1; i < 3; i = i + 1 )
      result = result | (inputs[i*4+:4] & {4{sel[i]}});
    MUX1HOT_v_4_3_2 = result;
  end
  endfunction


  function [7:0] MUX_v_8_2_2;
    input [15:0] inputs;
    input [0:0] sel;
    reg [7:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = inputs[15:8];
      end
      1'b1 : begin
        result = inputs[7:0];
      end
      default : begin
        result = inputs[15:8];
      end
    endcase
    MUX_v_8_2_2 = result;
  end
  endfunction


  function [1:0] MUX1HOT_v_2_3_2;
    input [5:0] inputs;
    input [2:0] sel;
    reg [1:0] result;
    integer i;
  begin
    result = inputs[0+:2] & {2{sel[0]}};
    for( i = 1; i < 3; i = i + 1 )
      result = result | (inputs[i*2+:2] & {2{sel[i]}});
    MUX1HOT_v_2_3_2 = result;
  end
  endfunction


  function [5:0] MUX_v_6_2_2;
    input [11:0] inputs;
    input [0:0] sel;
    reg [5:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = inputs[11:6];
      end
      1'b1 : begin
        result = inputs[5:0];
      end
      default : begin
        result = inputs[11:6];
      end
    endcase
    MUX_v_6_2_2 = result;
  end
  endfunction


  function [30:0] MUX_v_31_2_2;
    input [61:0] inputs;
    input [0:0] sel;
    reg [30:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = inputs[61:31];
      end
      1'b1 : begin
        result = inputs[30:0];
      end
      default : begin
        result = inputs[61:31];
      end
    endcase
    MUX_v_31_2_2 = result;
  end
  endfunction


  function [4:0] MUX_v_5_2_2;
    input [9:0] inputs;
    input [0:0] sel;
    reg [4:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = inputs[9:5];
      end
      1'b1 : begin
        result = inputs[4:0];
      end
      default : begin
        result = inputs[9:5];
      end
    endcase
    MUX_v_5_2_2 = result;
  end
  endfunction


  function [4:0] signext_5_1;
    input [0:0] vector;
  begin
    signext_5_1= {{4{vector[0]}}, vector};
  end
  endfunction


  function [31:0] MUX_v_32_16_2;
    input [511:0] inputs;
    input [3:0] sel;
    reg [31:0] result;
  begin
    case (sel)
      4'b0000 : begin
        result = inputs[511:480];
      end
      4'b0001 : begin
        result = inputs[479:448];
      end
      4'b0010 : begin
        result = inputs[447:416];
      end
      4'b0011 : begin
        result = inputs[415:384];
      end
      4'b0100 : begin
        result = inputs[383:352];
      end
      4'b0101 : begin
        result = inputs[351:320];
      end
      4'b0110 : begin
        result = inputs[319:288];
      end
      4'b0111 : begin
        result = inputs[287:256];
      end
      4'b1000 : begin
        result = inputs[255:224];
      end
      4'b1001 : begin
        result = inputs[223:192];
      end
      4'b1010 : begin
        result = inputs[191:160];
      end
      4'b1011 : begin
        result = inputs[159:128];
      end
      4'b1100 : begin
        result = inputs[127:96];
      end
      4'b1101 : begin
        result = inputs[95:64];
      end
      4'b1110 : begin
        result = inputs[63:32];
      end
      4'b1111 : begin
        result = inputs[31:0];
      end
      default : begin
        result = inputs[511:480];
      end
    endcase
    MUX_v_32_16_2 = result;
  end
  endfunction


  function [0:0] readslicef_34_1_33;
    input [33:0] vector;
    reg [33:0] tmp;
  begin
    tmp = vector >> 33;
    readslicef_34_1_33 = tmp[0:0];
  end
  endfunction


  function [31:0] MUX1HOT_v_32_6_2;
    input [191:0] inputs;
    input [5:0] sel;
    reg [31:0] result;
    integer i;
  begin
    result = inputs[0+:32] & {32{sel[0]}};
    for( i = 1; i < 6; i = i + 1 )
      result = result | (inputs[i*32+:32] & {32{sel[i]}});
    MUX1HOT_v_32_6_2 = result;
  end
  endfunction


  function  [33:0] conv_s2u_33_34 ;
    input signed [32:0]  vector ;
  begin
    conv_s2u_33_34 = {vector[32], vector};
  end
  endfunction


  function  [7:0] conv_u2u_2_8 ;
    input [1:0]  vector ;
  begin
    conv_u2u_2_8 = {{6{1'b0}}, vector};
  end
  endfunction


  function  [5:0] conv_u2u_5_6 ;
    input [4:0]  vector ;
  begin
    conv_u2u_5_6 = {1'b0, vector};
  end
  endfunction


  function  [6:0] conv_u2u_6_7 ;
    input [5:0]  vector ;
  begin
    conv_u2u_6_7 = {1'b0, vector};
  end
  endfunction


  function  [32:0] conv_s2u_32_33 ;
    input signed [31:0]  vector ;
  begin
    conv_s2u_32_33 = {vector[31], vector};
  end
  endfunction

endmodule

// ------------------------------------------------------------------
//  Design Unit:    InitDecode
//  Generated from file(s):
//    6) $PROJECT_HOME/src/ViterbiDecoder.cpp
//    3) $PROJECT_HOME/src/GlobalDefinitions.h
// ------------------------------------------------------------------


module InitDecode (
  start, ready, done, iNewNumOutBitsPartA_rsc_z, iNewNumOutBitsPartB_rsc_z, InitDecode_return_rsc_z,
      eNewCodingScheme_triosy_lz, eNewChannelType_triosy_lz, iN1_triosy_lz, iN2_triosy_lz,
      iNewNumOutBitsPartA_triosy_lz, iNewNumOutBitsPartB_triosy_lz, iPunctPatPartA_triosy_lz,
      iPunctPatPartB_triosy_lz, iLevel_triosy_lz, vecNewDistance_rTow0_triosy_lz,
      vecNewDistance_rTow1_triosy_lz, vecOutputBits_triosy_lz, InitDecode_return_triosy_lz,
      clk, rst, vecNewDistance_rTow0_rsc_dualport_data_in, vecNewDistance_rTow0_rsc_dualport_addr,
      vecNewDistance_rTow0_rsc_dualport_re, vecNewDistance_rTow0_rsc_dualport_we,
      vecNewDistance_rTow0_rsc_dualport_data_out, vecNewDistance_rTow1_rsc_dualport_data_in,
      vecNewDistance_rTow1_rsc_dualport_addr, vecNewDistance_rTow1_rsc_dualport_re,
      vecNewDistance_rTow1_rsc_dualport_we, vecNewDistance_rTow1_rsc_dualport_data_out,
      vecOutputBits_rsc_dualport_data_in, vecOutputBits_rsc_dualport_addr, vecOutputBits_rsc_dualport_re,
      vecOutputBits_rsc_dualport_we, vecOutputBits_rsc_dualport_data_out
);
  input start;
  output ready;
  output done;
  input [31:0] iNewNumOutBitsPartA_rsc_z;
  input [31:0] iNewNumOutBitsPartB_rsc_z;
  output [31:0] InitDecode_return_rsc_z;
  output eNewCodingScheme_triosy_lz;
  output eNewChannelType_triosy_lz;
  output iN1_triosy_lz;
  output iN2_triosy_lz;
  output iNewNumOutBitsPartA_triosy_lz;
  output iNewNumOutBitsPartB_triosy_lz;
  output iPunctPatPartA_triosy_lz;
  output iPunctPatPartB_triosy_lz;
  output iLevel_triosy_lz;
  output vecNewDistance_rTow0_triosy_lz;
  output vecNewDistance_rTow1_triosy_lz;
  output vecOutputBits_triosy_lz;
  output InitDecode_return_triosy_lz;
  input clk;
  input rst;
  output [63:0] vecNewDistance_rTow0_rsc_dualport_data_in;
  output [11:0] vecNewDistance_rTow0_rsc_dualport_addr;
  output [1:0] vecNewDistance_rTow0_rsc_dualport_re;
  output [1:0] vecNewDistance_rTow0_rsc_dualport_we;
  input [63:0] vecNewDistance_rTow0_rsc_dualport_data_out;
  output [63:0] vecNewDistance_rTow1_rsc_dualport_data_in;
  output [11:0] vecNewDistance_rTow1_rsc_dualport_addr;
  output [1:0] vecNewDistance_rTow1_rsc_dualport_re;
  output [1:0] vecNewDistance_rTow1_rsc_dualport_we;
  input [63:0] vecNewDistance_rTow1_rsc_dualport_data_out;
  output [15:0] vecOutputBits_rsc_dualport_data_in;
  output [11:0] vecOutputBits_rsc_dualport_addr;
  output [1:0] vecOutputBits_rsc_dualport_re;
  output [1:0] vecOutputBits_rsc_dualport_we;
  input [15:0] vecOutputBits_rsc_dualport_data_out;


  // Interconnect Declarations
  wire core_wen;
  wire [1:0] vecNewDistance_rTow0_rsc_dualport_re_core_sct;
  wire [1:0] vecNewDistance_rTow1_rsc_dualport_re_core_sct;
  wire [15:0] vecOutputBits_rsc_dualport_data_in_core;
  wire [11:0] vecOutputBits_rsc_dualport_addr_core;
  wire [1:0] vecOutputBits_rsc_dualport_we_core_sct;
  wire [31:0] iNewNumOutBitsPartA_rsc_mgc_in_wire_d;
  wire [31:0] iNewNumOutBitsPartB_rsc_mgc_in_wire_d;
  wire [31:0] InitDecode_return_rsc_mgc_out_stdreg_d;
  wire [63:0] vecTrelMetric1_rsc_dualport_data_in;
  wire [11:0] vecTrelMetric1_rsc_dualport_addr;
  wire [1:0] vecTrelMetric1_rsc_dualport_re;
  wire [1:0] vecTrelMetric1_rsc_dualport_we;
  wire [63:0] vecTrelMetric1_rsc_dualport_data_out;
  wire [63:0] vecTrelMetric2_rsc_dualport_data_in;
  wire [11:0] vecTrelMetric2_rsc_dualport_addr;
  wire [1:0] vecTrelMetric2_rsc_dualport_re;
  wire [1:0] vecTrelMetric2_rsc_dualport_we;
  wire [63:0] vecTrelMetric2_rsc_dualport_data_out;
  wire [1:0] matdecDecisions_rsc_dualport_data_in;
  wire [23:0] matdecDecisions_rsc_dualport_addr;
  wire [1:0] matdecDecisions_rsc_dualport_re;
  wire [1:0] matdecDecisions_rsc_dualport_we;
  wire [1:0] matdecDecisions_rsc_dualport_data_out;
  wire mgc_start_sync_mgc_bsync_rv_rd_core_sct;
  wire mgc_start_sync_mgc_bsync_rv_vd;
  wire mgc_done_sync_mgc_bsync_rdy_rd_core_sct;
  wire InitDecode_return_triosy_mgc_io_sync_ld_core_sct;
  wire vecOutputBits_triosy_mgc_io_sync_ld_core_sct;
  wire vecNewDistance_rTow1_triosy_mgc_io_sync_ld_core_sct;
  wire vecNewDistance_rTow0_triosy_mgc_io_sync_ld_core_sct;
  wire iLevel_triosy_mgc_io_sync_ld_core_sct;
  wire iPunctPatPartB_triosy_mgc_io_sync_ld_core_sct;
  wire iPunctPatPartA_triosy_mgc_io_sync_ld_core_sct;
  wire iNewNumOutBitsPartB_triosy_mgc_io_sync_ld_core_sct;
  wire iNewNumOutBitsPartA_triosy_mgc_io_sync_ld_core_sct;
  wire iN2_triosy_mgc_io_sync_ld_core_sct;
  wire iN1_triosy_mgc_io_sync_ld_core_sct;
  wire eNewChannelType_triosy_mgc_io_sync_ld_core_sct;
  wire eNewCodingScheme_triosy_mgc_io_sync_ld_core_sct;
  wire [31:0] div_mgc_div_a;
  wire [31:0] div_mgc_div_b;
  wire [31:0] div_mgc_div_z;
  reg [31:0] div_mgc_div_z_oreg;
  wire [11:0] vecNewDistance_rTow0_rsc_dualport_addr_core_iff;

  mgc_in_wire #(.rscid(8),
  .width(32)) iNewNumOutBitsPartA_rsc_mgc_in_wire (
      .d(iNewNumOutBitsPartA_rsc_mgc_in_wire_d),
      .z(iNewNumOutBitsPartA_rsc_z)
    );
  mgc_in_wire #(.rscid(9),
  .width(32)) iNewNumOutBitsPartB_rsc_mgc_in_wire (
      .d(iNewNumOutBitsPartB_rsc_mgc_in_wire_d),
      .z(iNewNumOutBitsPartB_rsc_z)
    );
  mgc_out_stdreg #(.rscid(13),
  .width(32)) InitDecode_return_rsc_mgc_out_stdreg (
      .d(InitDecode_return_rsc_mgc_out_stdreg_d),
      .z(InitDecode_return_rsc_z)
    );
  dualport_ram_be #(.ram_id(14),
  .words(64),
  .width(32),
  .addr_width(6),
  .a_reset_active(0),
  .s_reset_active(1),
  .enable_active(0),
  .re_active(0),
  .we_active(0),
  .num_byte_enables(1),
  .clock_edge(1),
  .num_input_registers(1),
  .num_output_registers(0),
  .no_of_dualport_readwrite_port(2)) vecTrelMetric1_rsc_dualport (
      .data_in(({32'b0 , (vecTrelMetric1_rsc_dualport_data_in[31:0])})),
      .addr(vecTrelMetric1_rsc_dualport_addr),
      .re(vecTrelMetric1_rsc_dualport_re),
      .we(vecTrelMetric1_rsc_dualport_we),
      .data_out(vecTrelMetric1_rsc_dualport_data_out),
      .clk(clk),
      .s_rst(rst),
      .a_rst(1'b1),
      .en((~ core_wen))
    );
  dualport_ram_be #(.ram_id(15),
  .words(64),
  .width(32),
  .addr_width(6),
  .a_reset_active(0),
  .s_reset_active(1),
  .enable_active(0),
  .re_active(0),
  .we_active(0),
  .num_byte_enables(1),
  .clock_edge(1),
  .num_input_registers(1),
  .num_output_registers(0),
  .no_of_dualport_readwrite_port(2)) vecTrelMetric2_rsc_dualport (
      .data_in(({32'b0 , (vecTrelMetric2_rsc_dualport_data_in[31:0])})),
      .addr(vecTrelMetric2_rsc_dualport_addr),
      .re(vecTrelMetric2_rsc_dualport_re),
      .we(vecTrelMetric2_rsc_dualport_we),
      .data_out(vecTrelMetric2_rsc_dualport_data_out),
      .clk(clk),
      .s_rst(rst),
      .a_rst(1'b1),
      .en((~ core_wen))
    );
  dualport_ram_be #(.ram_id(17),
  .words(4096),
  .width(1),
  .addr_width(12),
  .a_reset_active(0),
  .s_reset_active(1),
  .enable_active(0),
  .re_active(0),
  .we_active(0),
  .num_byte_enables(1),
  .clock_edge(1),
  .num_input_registers(1),
  .num_output_registers(0),
  .no_of_dualport_readwrite_port(2)) matdecDecisions_rsc_dualport (
      .data_in(({1'b0 , (matdecDecisions_rsc_dualport_data_in[0])})),
      .addr(({12'b0 , (matdecDecisions_rsc_dualport_addr[11:0])})),
      .re(matdecDecisions_rsc_dualport_re),
      .we(matdecDecisions_rsc_dualport_we),
      .data_out(matdecDecisions_rsc_dualport_data_out),
      .clk(clk),
      .s_rst(rst),
      .a_rst(1'b1),
      .en((~ core_wen))
    );
  mgc_bsync_rv #(.rscid(19),
  .ready(1),
  .valid(1)) mgc_start_sync_mgc_bsync_rv (
      .rd(mgc_start_sync_mgc_bsync_rv_rd_core_sct),
      .vd(mgc_start_sync_mgc_bsync_rv_vd),
      .rz(ready),
      .vz(start)
    );
  mgc_bsync_rdy #(.rscid(20),
  .ready(1),
  .valid(0)) mgc_done_sync_mgc_bsync_rdy (
      .rd(mgc_done_sync_mgc_bsync_rdy_rd_core_sct),
      .rz(done)
    );
  mgc_io_sync  InitDecode_return_triosy_mgc_io_sync (
      .ld(InitDecode_return_triosy_mgc_io_sync_ld_core_sct),
      .lz(InitDecode_return_triosy_lz)
    );
  mgc_io_sync  vecOutputBits_triosy_mgc_io_sync (
      .ld(vecOutputBits_triosy_mgc_io_sync_ld_core_sct),
      .lz(vecOutputBits_triosy_lz)
    );
  mgc_io_sync  vecNewDistance_rTow1_triosy_mgc_io_sync (
      .ld(vecNewDistance_rTow1_triosy_mgc_io_sync_ld_core_sct),
      .lz(vecNewDistance_rTow1_triosy_lz)
    );
  mgc_io_sync  vecNewDistance_rTow0_triosy_mgc_io_sync (
      .ld(vecNewDistance_rTow0_triosy_mgc_io_sync_ld_core_sct),
      .lz(vecNewDistance_rTow0_triosy_lz)
    );
  mgc_io_sync  iLevel_triosy_mgc_io_sync (
      .ld(iLevel_triosy_mgc_io_sync_ld_core_sct),
      .lz(iLevel_triosy_lz)
    );
  mgc_io_sync  iPunctPatPartB_triosy_mgc_io_sync (
      .ld(iPunctPatPartB_triosy_mgc_io_sync_ld_core_sct),
      .lz(iPunctPatPartB_triosy_lz)
    );
  mgc_io_sync  iPunctPatPartA_triosy_mgc_io_sync (
      .ld(iPunctPatPartA_triosy_mgc_io_sync_ld_core_sct),
      .lz(iPunctPatPartA_triosy_lz)
    );
  mgc_io_sync  iNewNumOutBitsPartB_triosy_mgc_io_sync (
      .ld(iNewNumOutBitsPartB_triosy_mgc_io_sync_ld_core_sct),
      .lz(iNewNumOutBitsPartB_triosy_lz)
    );
  mgc_io_sync  iNewNumOutBitsPartA_triosy_mgc_io_sync (
      .ld(iNewNumOutBitsPartA_triosy_mgc_io_sync_ld_core_sct),
      .lz(iNewNumOutBitsPartA_triosy_lz)
    );
  mgc_io_sync  iN2_triosy_mgc_io_sync (
      .ld(iN2_triosy_mgc_io_sync_ld_core_sct),
      .lz(iN2_triosy_lz)
    );
  mgc_io_sync  iN1_triosy_mgc_io_sync (
      .ld(iN1_triosy_mgc_io_sync_ld_core_sct),
      .lz(iN1_triosy_lz)
    );
  mgc_io_sync  eNewChannelType_triosy_mgc_io_sync (
      .ld(eNewChannelType_triosy_mgc_io_sync_ld_core_sct),
      .lz(eNewChannelType_triosy_lz)
    );
  mgc_io_sync  eNewCodingScheme_triosy_mgc_io_sync (
      .ld(eNewCodingScheme_triosy_mgc_io_sync_ld_core_sct),
      .lz(eNewCodingScheme_triosy_lz)
    );
  mgc_div #(.width_a(32),
  .width_b(32),
  .signd(1)) div_mgc_div (
      .a(div_mgc_div_a),
      .b(div_mgc_div_b),
      .z(div_mgc_div_z)
    );
  InitDecode_core InitDecode_core_inst (
      .clk(clk),
      .rst(rst),
      .vecNewDistance_rTow0_rsc_dualport_data_out(vecNewDistance_rTow0_rsc_dualport_data_out),
      .vecNewDistance_rTow1_rsc_dualport_data_out(vecNewDistance_rTow1_rsc_dualport_data_out),
      .core_wen(core_wen),
      .vecNewDistance_rTow0_rsc_dualport_re_core_sct(vecNewDistance_rTow0_rsc_dualport_re_core_sct),
      .vecNewDistance_rTow1_rsc_dualport_re_core_sct(vecNewDistance_rTow1_rsc_dualport_re_core_sct),
      .vecOutputBits_rsc_dualport_data_in_core(vecOutputBits_rsc_dualport_data_in_core),
      .vecOutputBits_rsc_dualport_addr_core(vecOutputBits_rsc_dualport_addr_core),
      .vecOutputBits_rsc_dualport_we_core_sct(vecOutputBits_rsc_dualport_we_core_sct),
      .iNewNumOutBitsPartA_rsc_mgc_in_wire_d(iNewNumOutBitsPartA_rsc_mgc_in_wire_d),
      .iNewNumOutBitsPartB_rsc_mgc_in_wire_d(iNewNumOutBitsPartB_rsc_mgc_in_wire_d),
      .InitDecode_return_rsc_mgc_out_stdreg_d(InitDecode_return_rsc_mgc_out_stdreg_d),
      .vecTrelMetric1_rsc_dualport_data_in(vecTrelMetric1_rsc_dualport_data_in),
      .vecTrelMetric1_rsc_dualport_addr(vecTrelMetric1_rsc_dualport_addr),
      .vecTrelMetric1_rsc_dualport_re(vecTrelMetric1_rsc_dualport_re),
      .vecTrelMetric1_rsc_dualport_we(vecTrelMetric1_rsc_dualport_we),
      .vecTrelMetric1_rsc_dualport_data_out(vecTrelMetric1_rsc_dualport_data_out),
      .vecTrelMetric2_rsc_dualport_data_in(vecTrelMetric2_rsc_dualport_data_in),
      .vecTrelMetric2_rsc_dualport_addr(vecTrelMetric2_rsc_dualport_addr),
      .vecTrelMetric2_rsc_dualport_re(vecTrelMetric2_rsc_dualport_re),
      .vecTrelMetric2_rsc_dualport_we(vecTrelMetric2_rsc_dualport_we),
      .vecTrelMetric2_rsc_dualport_data_out(vecTrelMetric2_rsc_dualport_data_out),
      .matdecDecisions_rsc_dualport_data_in(matdecDecisions_rsc_dualport_data_in),
      .matdecDecisions_rsc_dualport_addr(matdecDecisions_rsc_dualport_addr),
      .matdecDecisions_rsc_dualport_re(matdecDecisions_rsc_dualport_re),
      .matdecDecisions_rsc_dualport_we(matdecDecisions_rsc_dualport_we),
      .matdecDecisions_rsc_dualport_data_out(matdecDecisions_rsc_dualport_data_out),
      .mgc_start_sync_mgc_bsync_rv_rd_core_sct(mgc_start_sync_mgc_bsync_rv_rd_core_sct),
      .mgc_start_sync_mgc_bsync_rv_vd(mgc_start_sync_mgc_bsync_rv_vd),
      .mgc_done_sync_mgc_bsync_rdy_rd_core_sct(mgc_done_sync_mgc_bsync_rdy_rd_core_sct),
      .InitDecode_return_triosy_mgc_io_sync_ld_core_sct(InitDecode_return_triosy_mgc_io_sync_ld_core_sct),
      .vecOutputBits_triosy_mgc_io_sync_ld_core_sct(vecOutputBits_triosy_mgc_io_sync_ld_core_sct),
      .vecNewDistance_rTow1_triosy_mgc_io_sync_ld_core_sct(vecNewDistance_rTow1_triosy_mgc_io_sync_ld_core_sct),
      .vecNewDistance_rTow0_triosy_mgc_io_sync_ld_core_sct(vecNewDistance_rTow0_triosy_mgc_io_sync_ld_core_sct),
      .iLevel_triosy_mgc_io_sync_ld_core_sct(iLevel_triosy_mgc_io_sync_ld_core_sct),
      .iPunctPatPartB_triosy_mgc_io_sync_ld_core_sct(iPunctPatPartB_triosy_mgc_io_sync_ld_core_sct),
      .iPunctPatPartA_triosy_mgc_io_sync_ld_core_sct(iPunctPatPartA_triosy_mgc_io_sync_ld_core_sct),
      .iNewNumOutBitsPartB_triosy_mgc_io_sync_ld_core_sct(iNewNumOutBitsPartB_triosy_mgc_io_sync_ld_core_sct),
      .iNewNumOutBitsPartA_triosy_mgc_io_sync_ld_core_sct(iNewNumOutBitsPartA_triosy_mgc_io_sync_ld_core_sct),
      .iN2_triosy_mgc_io_sync_ld_core_sct(iN2_triosy_mgc_io_sync_ld_core_sct),
      .iN1_triosy_mgc_io_sync_ld_core_sct(iN1_triosy_mgc_io_sync_ld_core_sct),
      .eNewChannelType_triosy_mgc_io_sync_ld_core_sct(eNewChannelType_triosy_mgc_io_sync_ld_core_sct),
      .eNewCodingScheme_triosy_mgc_io_sync_ld_core_sct(eNewCodingScheme_triosy_mgc_io_sync_ld_core_sct),
      .div_mgc_div_a(div_mgc_div_a),
      .div_mgc_div_b(div_mgc_div_b),
      .div_mgc_div_z_oreg(div_mgc_div_z_oreg),
      .vecNewDistance_rTow0_rsc_dualport_addr_core_pff(vecNewDistance_rTow0_rsc_dualport_addr_core_iff)
    );
  assign vecNewDistance_rTow0_rsc_dualport_data_in = 64'b0;
  assign vecNewDistance_rTow0_rsc_dualport_addr = {6'b0 , (vecNewDistance_rTow0_rsc_dualport_addr_core_iff[5:0])};
  assign vecNewDistance_rTow0_rsc_dualport_re = ~ vecNewDistance_rTow0_rsc_dualport_re_core_sct;
  assign vecNewDistance_rTow0_rsc_dualport_we = 2'b11;
  assign vecNewDistance_rTow1_rsc_dualport_data_in = 64'b0;
  assign vecNewDistance_rTow1_rsc_dualport_addr = {6'b0 , (vecNewDistance_rTow0_rsc_dualport_addr_core_iff[5:0])};
  assign vecNewDistance_rTow1_rsc_dualport_re = ~ vecNewDistance_rTow1_rsc_dualport_re_core_sct;
  assign vecNewDistance_rTow1_rsc_dualport_we = 2'b11;
  assign vecOutputBits_rsc_dualport_data_in = {8'b0 , (vecOutputBits_rsc_dualport_data_in_core[7:0])};
  assign vecOutputBits_rsc_dualport_addr = {6'b0 , (vecOutputBits_rsc_dualport_addr_core[5:0])};
  assign vecOutputBits_rsc_dualport_re = 2'b11;
  assign vecOutputBits_rsc_dualport_we = ~ vecOutputBits_rsc_dualport_we_core_sct;
  always @(posedge clk) begin
    if ( rst ) begin
      div_mgc_div_z_oreg <= 32'b0;
    end
    else if ( core_wen ) begin
      div_mgc_div_z_oreg <= div_mgc_div_z;
    end
  end
endmodule



