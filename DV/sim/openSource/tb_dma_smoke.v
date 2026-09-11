// -----------------------------------------------------------------------------
// Open-source smoke test for the DMA controller RTL (top_mod).
//
// This is NOT a replacement for the full UVM regression (which requires
// QuestaSim). It is a lightweight, license-free sanity check that:
//   * elaborates and simulates the complete RTL with Icarus Verilog, and
//   * exercises the APB configuration interface with real read/write traffic
//     (write a channel register, then read it back and self-check).
//
// It lets a developer confirm the environment + RTL are healthy without any
// commercial simulator or license.
// -----------------------------------------------------------------------------
`timescale 1ns/1ps

module tb_dma_smoke;

  localparam DATA_W     = 128;
  localparam DATA_WIDTH = 32;
  localparam ADDR_WIDTH = 32;
  localparam ID_W       = 4;
  localparam NUM_CH     = 3;

  // Clock / reset
  reg clk;
  reg resetn;

  // APB
  reg  [ADDR_WIDTH-1:0] PADDR;
  reg                   PWRITE;
  reg                   PENABLE;
  reg                   PSEL;
  reg  [DATA_WIDTH-1:0] PWDATA;
  reg  [DATA_WIDTH/8-1:0] PSTRB;
  wire [DATA_WIDTH-1:0] PRDATA;
  wire                  PREADY;
  wire                  PSLVERR;

  // Tie-offs for the AXI / trigger / interrupt facing ports. This smoke test
  // only drives the APB programming interface, so the data-path inputs are
  // held at benign idle values.
  reg                   boot_en;
  reg  [29:0]           boot_addr;
  reg  [5:0]            trig_req;
  reg  [11:0]           trig_req_type;
  reg  [5:0]            trig_out_ack;
  reg                   ARREADY;
  reg  [ID_W-1:0]       RID;
  reg  [DATA_W-1:0]     RDATA_I;
  reg  [1:0]            RRESP;
  reg                   RLAST;
  reg                   RVALID;
  reg                   WREADY;
  reg                   AWREADY;
  reg  [ID_W-1:0]       BID;
  reg                   BVALID;
  reg  [1:0]            BRESP;

  integer errors;

  top_mod #(.DATA_W(DATA_W)) u_dma (
    .clk           (clk),
    .resetn        (resetn),
    .boot_en       (boot_en),
    .boot_addr     (boot_addr),
    // APB
    .PADDR         (PADDR),
    .PWRITE        (PWRITE),
    .PENABLE       (PENABLE),
    .PSEL          (PSEL),
    .PWDATA        (PWDATA),
    .PSTRB         (PSTRB),
    .PRDATA        (PRDATA),
    .PREADY        (PREADY),
    .PSLVERR       (PSLVERR),
    // Trigger
    .trig_req      (trig_req),
    .trig_req_type (trig_req_type),
    .trig_ack      (),
    .trig_ack_type (),
    .trig_out_req  (),
    .trig_out_ack  (trig_out_ack),
    // AXI read
    .ARREADY       (ARREADY),
    .RID           (RID),
    .RDATA_I       (RDATA_I),
    .RRESP         (RRESP),
    .RLAST         (RLAST),
    .RVALID        (RVALID),
    // AXI write
    .WREADY        (WREADY),
    .AWREADY       (AWREADY),
    .BID           (BID),
    .BVALID        (BVALID),
    .BRESP         (BRESP),
    // Unused AXI outputs left open
    .ARQOS         (),
    .AWQOS         (),
    .ARID          (),
    .ARLEN         (),
    .ARSIZE        (),
    .ARBURST       (),
    .ARVALID       (),
    .ARADDR        (),
    .RREADY        (),
    .WSTRB         (),
    .AWID_D        (),
    .AWLEN_D       (),
    .AWSIZE_D      (),
    .AWBURST_D     (),
    .AWVALID_D     (),
    .AWADDR_D      (),
    .WVALID_D      (),
    .WDATA_D       (),
    .WLAST_D       (),
    .BREADY_D      (),
    .IRQ           ()
  );

  // 100 MHz clock
  initial clk = 1'b0;
  always #5 clk = ~clk;

  // APB write following the APB4 handshake, polling PREADY for wait states.
  task apb_write(input [ADDR_WIDTH-1:0] addr, input [DATA_WIDTH-1:0] data);
    integer guard;
    begin
      @(posedge clk);
      PSEL    <= 1'b1;
      PENABLE <= 1'b0;
      PWRITE  <= 1'b1;
      PADDR   <= addr;
      PWDATA  <= data;
      PSTRB   <= {(DATA_WIDTH/8){1'b1}};
      @(posedge clk);          // SETUP -> ACCESS
      PENABLE <= 1'b1;
      guard = 0;
      @(posedge clk);
      while (PREADY !== 1'b1 && guard < 100) begin
        @(posedge clk);
        guard = guard + 1;
      end
      if (PREADY !== 1'b1) begin
        $display("[%0t] ERROR: APB write to 0x%08h timed out", $time, addr);
        errors = errors + 1;
      end
      PSEL    <= 1'b0;
      PENABLE <= 1'b0;
      PWRITE  <= 1'b0;
      @(posedge clk);
    end
  endtask

  // APB read following the APB4 handshake, polling PREADY, returns captured data.
  task apb_read(input [ADDR_WIDTH-1:0] addr, output [DATA_WIDTH-1:0] data);
    integer guard;
    begin
      @(posedge clk);
      PSEL    <= 1'b1;
      PENABLE <= 1'b0;
      PWRITE  <= 1'b0;
      PADDR   <= addr;
      PSTRB   <= {(DATA_WIDTH/8){1'b0}};
      @(posedge clk);          // SETUP -> ACCESS
      PENABLE <= 1'b1;
      guard = 0;
      data  = {DATA_WIDTH{1'bx}};
      @(posedge clk);
      while (PREADY !== 1'b1 && guard < 100) begin
        @(posedge clk);
        guard = guard + 1;
      end
      if (PREADY === 1'b1) begin
        data = PRDATA;
      end else begin
        $display("[%0t] ERROR: APB read from 0x%08h timed out", $time, addr);
        errors = errors + 1;
      end
      PSEL    <= 1'b0;
      PENABLE <= 1'b0;
      @(posedge clk);
    end
  endtask

  task check(input [8*32-1:0] name, input [DATA_WIDTH-1:0] got, input [DATA_WIDTH-1:0] exp);
    begin
      if (got === exp)
        $display("[%0t] PASS: %0s = 0x%08h", $time, name, got);
      else begin
        $display("[%0t] FAIL: %0s = 0x%08h (expected 0x%08h)", $time, name, got, exp);
        errors = errors + 1;
      end
    end
  endtask

  reg [DATA_WIDTH-1:0] rdata;

  initial begin
    // Waveform dump for debugging in GTKWave.
    $dumpfile("dma_smoke.vcd");
    $dumpvars(0, tb_dma_smoke);

    errors        = 0;
    boot_en       = 1'b0;
    boot_addr     = 30'd0;
    trig_req      = 6'd0;
    trig_req_type = 12'd0;
    trig_out_ack  = 6'd0;
    ARREADY       = 1'b0;
    RID           = {ID_W{1'b0}};
    RDATA_I       = {DATA_W{1'b0}};
    RRESP         = 2'b00;
    RLAST         = 1'b0;
    RVALID        = 1'b0;
    WREADY        = 1'b0;
    AWREADY       = 1'b0;
    BID           = {ID_W{1'b0}};
    BVALID        = 1'b0;
    BRESP         = 2'b00;
    PADDR         = {ADDR_WIDTH{1'b0}};
    PWRITE        = 1'b0;
    PENABLE       = 1'b0;
    PSEL          = 1'b0;
    PWDATA        = {DATA_WIDTH{1'b0}};
    PSTRB         = {(DATA_WIDTH/8){1'b0}};

    // Reset: DUT top drives resetn active-low with an initial dip.
    resetn = 1'b1;
    #2  resetn = 1'b0;
    repeat (4) @(posedge clk);
    resetn = 1'b1;
    repeat (4) @(posedge clk);

    $display("--------------------------------------------------------------");
    $display("DMA RTL open-source smoke test (Icarus Verilog)");
    $display("--------------------------------------------------------------");

    // Channel 0 interrupt-enable register lives at 0x0108 (base 0x0100 + 0x08).
    // It is a plain R/W config register that the datapath does not overwrite,
    // so it is a clean target for a write / read-back check.
    apb_write(32'h0000_0108, 32'hDEAD_BEEF);
    apb_read (32'h0000_0108, rdata);
    check("CH0 intr_enable (0x0108)", rdata, 32'hDEAD_BEEF);

    // Repeat on channel 1 (base 0x0200) to prove per-channel address decode.
    apb_write(32'h0000_0208, 32'h1234_5678);
    apb_read (32'h0000_0208, rdata);
    check("CH1 intr_enable (0x0208)", rdata, 32'h1234_5678);

    // And confirm the two channels are independent (CH0 unchanged).
    apb_read (32'h0000_0108, rdata);
    check("CH0 intr_enable retained", rdata, 32'hDEAD_BEEF);

    repeat (4) @(posedge clk);

    $display("--------------------------------------------------------------");
    if (errors == 0)
      $display("SMOKE TEST PASSED: 0 errors");
    else
      $display("SMOKE TEST FAILED: %0d error(s)", errors);
    $display("--------------------------------------------------------------");

    if (errors != 0) $fatal(1, "smoke test failed");
    $finish;
  end

  // Global watchdog so the sim can never hang the CI/environment.
  initial begin
    #200000;
    $display("[%0t] ERROR: global timeout reached", $time);
    $fatal(1, "global timeout");
  end

endmodule
