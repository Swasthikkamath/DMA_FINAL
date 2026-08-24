// ---------------------------------------------------------------------------
// Testbench for AxiInterconnect.
//
// Models the real topology: DMA-350 drives ONE interface manager
// (axiMasterInterface[0]) which is time-multiplexed internally between channel
// 0 and channel 1.  Channel 1 (high QoS) engages a slave, is STOPPED, and
// channel 0 must then be routed purely by address decode.
//
// Stimulus is driven on negedge; all handshakes are observed by posedge
// monitors, so checks never race the DUT.
// ---------------------------------------------------------------------------
`timescale 1ns/1ps

module tb_interconnect;

  import AxiGlobalPackage::*;

  localparam int TOTAL_SLAVES     = NO_OF_SLAVES + 1;
  // Match the shipped default: reclaim disabled. Per the DMA-350 TRM a channel
  // stop waits for every outstanding response, so the interconnect must never
  // drop one.
  localparam int TB_ABORT_TIMEOUT = 0;

  logic aclk = 0;
  logic aresetn = 0;
  always #5 aclk = ~aclk;

  axi4_if mif[NO_OF_MASTERS](aclk, aresetn);
  axi4_if sif[TOTAL_SLAVES](aclk, aresetn);

  AxiInterconnect #(.ABORT_TIMEOUT(TB_ABORT_TIMEOUT)) dut(aclk, aresetn, mif, sif);

  // ---------------------------------------------------------------
  // Slave models
  // ---------------------------------------------------------------
  bit s_aw_en[TOTAL_SLAVES], s_w_en[TOTAL_SLAVES], s_ar_en[TOTAL_SLAVES];
  bit s_r_en [TOTAL_SLAVES], s_rlast[TOTAL_SLAVES], s_b_en[TOTAL_SLAVES];

  int s_aw_cnt[TOTAL_SLAVES], s_w_cnt[TOTAL_SLAVES], s_ar_cnt[TOTAL_SLAVES];
  logic [31:0] s_last_awaddr[TOTAL_SLAVES], s_last_araddr[TOTAL_SLAVES],
               s_last_wdata [TOTAL_SLAVES];
  logic [3:0]  s_arid[TOTAL_SLAVES];   // ARID captured at AR handshake, echoed on RID

  genvar gs;
  generate
    for (gs = 0; gs < TOTAL_SLAVES; gs++) begin : slave_model
      always_comb begin
        sif[gs].awready = s_aw_en[gs];
        sif[gs].wready  = s_w_en[gs];
        sif[gs].arready = s_ar_en[gs];
        sif[gs].rvalid  = s_r_en[gs];
        sif[gs].rlast   = s_rlast[gs];
        sif[gs].rdata   = 32'hD0D0_0000 + gs;   // slave-unique pattern
        sif[gs].rresp   = 2'b00;
        sif[gs].rid     = s_arid[gs];   // echo the captured ARID
        sif[gs].bvalid  = s_b_en[gs];
        sif[gs].bresp   = 2'b00;
        sif[gs].bid     = '0;
      end

      always_ff @(posedge aclk) begin
        if (!aresetn) begin
          s_aw_cnt[gs] <= 0; s_w_cnt[gs] <= 0; s_ar_cnt[gs] <= 0;
          s_last_awaddr[gs] <= '0; s_last_araddr[gs] <= '0; s_last_wdata[gs] <= '0;
          s_arid[gs] <= '0;
        end else begin
          if (sif[gs].awvalid && sif[gs].awready) begin
            s_aw_cnt[gs] <= s_aw_cnt[gs] + 1; s_last_awaddr[gs] <= sif[gs].awaddr;
            $display("[%0t] SLAVE%0d AW  addr=0x%08h", $time, gs, sif[gs].awaddr);
          end
          if (sif[gs].wvalid && sif[gs].wready) begin
            s_w_cnt[gs] <= s_w_cnt[gs] + 1; s_last_wdata[gs] <= sif[gs].wdata;
            $display("[%0t] SLAVE%0d W   data=0x%08h", $time, gs, sif[gs].wdata);
          end
          if (sif[gs].arvalid && sif[gs].arready) begin
            s_ar_cnt[gs] <= s_ar_cnt[gs] + 1; s_last_araddr[gs] <= sif[gs].araddr;
            s_arid[gs]   <= sif[gs].arid;
            $display("[%0t] SLAVE%0d AR  addr=0x%08h", $time, gs, sif[gs].araddr);
          end
        end
      end
    end
  endgenerate

  // ---------------------------------------------------------------
  // Master-side monitors (ground truth for what master 0 actually saw)
  // ---------------------------------------------------------------
  int m0_aw_cnt, m0_w_cnt, m0_b_cnt, m0_ar_cnt, m0_r_cnt;
  logic [31:0] m0_last_rdata;
  logic [3:0]  m0_last_rid;
  bit          m0_saw_ch0_data;   // saw a beat tagged RID 0 carrying slave 0's pattern
  bit          m0_saw_ch1_data;   // saw a beat tagged RID 1 (a stopped channel's drain)

  always_ff @(posedge aclk) begin
    if (!aresetn) begin
      m0_aw_cnt <= 0; m0_w_cnt <= 0; m0_b_cnt <= 0;
      m0_ar_cnt <= 0; m0_r_cnt <= 0; m0_last_rdata <= '0; m0_last_rid <= '0;
      m0_saw_ch0_data <= 1'b0; m0_saw_ch1_data <= 1'b0;
    end else begin
      if (mif[0].awvalid && mif[0].awready) m0_aw_cnt <= m0_aw_cnt + 1;
      if (mif[0].wvalid  && mif[0].wready ) m0_w_cnt  <= m0_w_cnt  + 1;
      if (mif[0].bvalid  && mif[0].bready ) m0_b_cnt  <= m0_b_cnt  + 1;
      if (mif[0].arvalid && mif[0].arready) m0_ar_cnt <= m0_ar_cnt + 1;
      if (mif[0].rvalid  && mif[0].rready ) begin
        m0_r_cnt      <= m0_r_cnt + 1;
        m0_last_rdata <= mif[0].rdata;
        m0_last_rid   <= mif[0].rid;
        if (mif[0].rid == 4'd0 && mif[0].rdata == 32'hD0D0_0000) m0_saw_ch0_data <= 1'b1;
        if (mif[0].rid == 4'd1) m0_saw_ch1_data <= 1'b1;
        $display("[%0t] MASTER0 R  rid=%0d data=0x%08h", $time, mif[0].rid, mif[0].rdata);
      end
    end
  end

  // Exact per-master grant counters on slave 1, for the fairness scenario.
  int aw_m0_wins, aw_m1_wins;
  always_ff @(posedge aclk) begin
    if (!aresetn) begin
      aw_m0_wins <= 0; aw_m1_wins <= 0;
    end else if (sif[1].awvalid && sif[1].awready) begin
      if (sif[1].awaddr == 32'h0000_1000) aw_m0_wins <= aw_m0_wins + 1;
      if (sif[1].awaddr == 32'h0000_1080) aw_m1_wins <= aw_m1_wins + 1;
    end
  end

  // ---------------------------------------------------------------
  // Drivers
  // ---------------------------------------------------------------
  task automatic m0_idle();
    mif[0].awvalid=0; mif[0].wvalid=0; mif[0].arvalid=0;
    mif[0].bready=1;  mif[0].rready=1;
    mif[0].awaddr='0; mif[0].araddr='0; mif[0].wdata='0;
    mif[0].awqos='0;  mif[0].arqos='0;
    mif[0].awlen='0;  mif[0].arlen='0;  mif[0].wlast=0;
    mif[0].awid='0;   mif[0].arid='0;
  endtask

  task automatic m1_idle();
    mif[1].awvalid=0; mif[1].wvalid=0; mif[1].arvalid=0;
    mif[1].bready=1;  mif[1].rready=1;
    mif[1].awaddr='0; mif[1].araddr='0; mif[1].wdata='0;
    mif[1].awqos='0;  mif[1].arqos='0;
    mif[1].awlen='0;  mif[1].arlen='0;  mif[1].wlast=0;
    mif[1].awid='0;   mif[1].arid='0;
  endtask

  task automatic reset_all();
    aresetn = 0;
    m0_idle(); m1_idle();
    for (int s = 0; s < TOTAL_SLAVES; s++) begin
      s_aw_en[s]=0; s_w_en[s]=0; s_ar_en[s]=0;
      s_r_en[s]=0;  s_rlast[s]=0; s_b_en[s]=0;
    end
    repeat (4) @(negedge aclk);
    aresetn = 1;
    repeat (2) @(negedge aclk);
  endtask

  task automatic idle_cycles(int n);
    repeat (n) @(negedge aclk);
  endtask

  // Drive AW until master 0 sees AWREADY, or give up after `limit` cycles.
  task automatic m0_aw(input logic [31:0] addr, input logic [3:0] qos,
                       input int limit, output bit ok);
    int target;
    target = m0_aw_cnt + 1;
    ok = 0;
    @(negedge aclk);
    mif[0].awaddr = addr; mif[0].awqos = qos; mif[0].awvalid = 1;
    for (int t = 0; t < limit; t++) begin
      @(negedge aclk);
      if (m0_aw_cnt >= target) begin ok = 1; break; end
    end
    mif[0].awvalid = 0;
  endtask

  task automatic m0_ar(input logic [31:0] addr, input logic [3:0] qos,
                       input int limit, output bit ok);
    int target;
    target = m0_ar_cnt + 1;
    ok = 0;
    @(negedge aclk);
    mif[0].araddr = addr; mif[0].arqos = qos; mif[0].arvalid = 1;
    for (int t = 0; t < limit; t++) begin
      @(negedge aclk);
      if (m0_ar_cnt >= target) begin ok = 1; break; end
    end
    mif[0].arvalid = 0;
  endtask

  // Single-beat write burst (WLAST on the only beat).
  task automatic m0_w(input logic [31:0] data, input int limit, output bit ok);
    int target;
    target = m0_w_cnt + 1;
    ok = 0;
    @(negedge aclk);
    mif[0].wdata = data; mif[0].wvalid = 1; mif[0].wlast = 1;
    for (int t = 0; t < limit; t++) begin
      @(negedge aclk);
      if (m0_w_cnt >= target) begin ok = 1; break; end
    end
    mif[0].wvalid = 0; mif[0].wlast = 0;
  endtask

  int errors = 0;
  task automatic check(string name, bit cond);
    if (cond) $display("  PASS : %s", name);
    else begin $display("  FAIL : %s", name); errors++; end
  endtask

  bit ok;

  // ---------------------------------------------------------------
  initial begin

    // =================================================================
    $display("\n=== SCENARIO A : write, channel stopped BEFORE its AW was accepted ===");
    // This is the reported case: channel 1 has AWVALID up for slave 2, the
    // slave has not accepted yet, the channel is stopped, and channel 0 must
    // then be routed purely by address.
    reset_all();
    s_aw_en[2] = 0;                                   // slave 2 busy
    @(negedge aclk);
    mif[0].awaddr = 32'h0000_2000; mif[0].awqos = 4'd15; mif[0].awvalid = 1;
    idle_cycles(5);
    mif[0].awvalid = 0;                               // *** CHANNEL 1 STOPPED ***
    idle_cycles(3);

    s_aw_en[0] = 1; s_w_en[0] = 1; s_aw_en[2] = 1; s_w_en[2] = 1;
    m0_aw(32'h0000_0400, 4'd0, 40, ok);
    check("ch0 AW was accepted", ok);
    m0_w(32'hC0FF_EE00, 40, ok);
    check("ch0 W was accepted", ok);
    idle_cycles(2);

    check("ch0 AW landed on slave 0",
          s_aw_cnt[0] == 1 && s_last_awaddr[0] == 32'h0000_0400);
    check("ch0 W  landed on slave 0",
          s_w_cnt[0] == 1 && s_last_wdata[0] == 32'hC0FF_EE00);
    check("nothing leaked into slave 2", s_aw_cnt[2] == 0 && s_w_cnt[2] == 0);

    // =================================================================
    $display("\n=== SCENARIO B : write, channel stopped with a write outstanding ===");
    // Per DMA-350 TRM 4.8.2 a stop "waits for all the outstanding responses
    // from read and write transactions", so an accepted AW always gets its W
    // burst and its B response - even on a stopped channel. Both masters'
    // writes must land on their own slaves and both B responses must come back.
    reset_all();
    for (int i = 0; i < TOTAL_SLAVES; i++) begin s_aw_en[i]=1; s_w_en[i]=1; end

    m0_aw(32'h0000_2000, 4'd15, 40, ok);           // channel 1 -> slave 2
    check("ch1 AW accepted by slave 2", ok && s_aw_cnt[2] == 1);
    m0_w(32'hBEEF_0000, 40, ok);                   // it completes its burst
    check("ch1 W accepted", ok);
    @(negedge aclk); s_b_en[2] = 1;
    idle_cycles(4);
    @(negedge aclk); s_b_en[2] = 0;
    check("ch1 got its B response", m0_b_cnt == 1);

    m0_aw(32'h0000_0400, 4'd0, 40, ok);            // channel 0 -> slave 0
    check("ch0 AW accepted by slave 0", ok);
    m0_w(32'hFEED_0000, 40, ok);
    check("ch0 W accepted", ok);
    @(negedge aclk); s_b_en[0] = 1;
    idle_cycles(4);
    @(negedge aclk); s_b_en[0] = 0;
    idle_cycles(2);

    check("ch1 data landed on slave 2", s_last_wdata[2] == 32'hBEEF_0000);
    check("ch0 data landed on slave 0", s_last_wdata[0] == 32'hFEED_0000);
    check("neither write leaked into the other's slave",
          s_w_cnt[2] == 1 && s_w_cnt[0] == 1);
    check("both B responses reached the master", m0_b_cnt == 2);

    // =================================================================
    $display("\n=== SCENARIO C : stopped channel's read still gets its response ===");
    // Channel 1's read is outstanding when the channel stops and the DMA stops
    // consuming. Channel 0's read is issued meanwhile. When the DMA resumes,
    // BOTH responses must arrive, each tagged with its own channel's ID, and
    // neither may be dropped - a dropped response hangs the stop handshake.
    reset_all();
    s_ar_en[2] = 1;
    @(negedge aclk);
    mif[0].arid = 4'd1;
    mif[0].araddr = 32'h0000_2000; mif[0].arqos = 4'd15; mif[0].arvalid = 1;
    idle_cycles(5);
    check("ch1 AR accepted by slave 2", s_ar_cnt[2] == 1 && s_arid[2] == 4'd1);
    @(negedge aclk);
    mif[0].arvalid = 0; s_ar_en[2] = 0;
    s_r_en[2] = 1; s_rlast[2] = 0;      // slave 2 holding beats
    mif[0].rready = 0;                  // *** CHANNEL 1 STOPPED consuming ***
    idle_cycles(4);

    s_ar_en[0] = 1;
    @(negedge aclk);
    mif[0].arid = 4'd0;
    mif[0].araddr = 32'h0000_0400; mif[0].arqos = 4'd0; mif[0].arvalid = 1;
    idle_cycles(6);
    check("ch0 AR accepted by slave 0 while ch1's read is still outstanding",
          s_ar_cnt[0] == 1 && s_last_araddr[0] == 32'h0000_0400);
    check("ch0 AR never leaked into slave 2", s_ar_cnt[2] == 1);
    @(negedge aclk); mif[0].arvalid = 0;

    // DMA resumes draining. Channel 1's burst finishes, then channel 0's data.
    @(negedge aclk);
    s_r_en[0] = 1; s_rlast[0] = 1;
    mif[0].rready = 1;
    idle_cycles(3);
    @(negedge aclk); s_rlast[2] = 1;    // slave 2 completes its burst
    idle_cycles(3);
    @(negedge aclk); s_r_en[2] = 0; s_rlast[2] = 0;
    idle_cycles(8);

    check("ch1's outstanding read data was delivered, not dropped",
          m0_saw_ch1_data);
    check("ch0's read data was delivered tagged RID 0",
          m0_saw_ch0_data);

    // =================================================================
    $display("\n=== SCENARIO D : baseline, a normal write then a normal read ===");
    reset_all();
    for (int s = 0; s < TOTAL_SLAVES; s++) begin
      s_aw_en[s]=1; s_w_en[s]=1; s_ar_en[s]=1;
    end

    m0_aw(32'h0000_3010, 4'd5, 40, ok);
    check("normal write AW accepted", ok);
    m0_w(32'hAAAA_5555, 40, ok);
    check("normal write W accepted", ok);
    @(negedge aclk); s_b_en[3] = 1;          // slave 3 returns its response
    idle_cycles(4);
    @(negedge aclk); s_b_en[3] = 0;
    idle_cycles(2);

    check("normal write AW landed on slave 3",
          s_aw_cnt[3] == 1 && s_last_awaddr[3] == 32'h0000_3010);
    check("normal write W landed on slave 3",
          s_w_cnt[3] == 1 && s_last_wdata[3] == 32'hAAAA_5555);
    check("normal write touched no other slave",
          s_aw_cnt[0]==0 && s_aw_cnt[1]==0 && s_aw_cnt[2]==0 && s_aw_cnt[4]==0);
    check("master 0 received its B response", m0_b_cnt == 1);

    // The read also proves the write binding was released on B.
    @(negedge aclk); s_r_en[1] = 1; s_rlast[1] = 1;
    m0_ar(32'h0000_1004, 4'd5, 40, ok);
    check("normal read AR accepted", ok);
    idle_cycles(3);
    check("normal read AR landed on slave 1",
          s_ar_cnt[1] == 1 && s_last_araddr[1] == 32'h0000_1004);
    check("normal read data came from slave 1",
          m0_r_cnt >= 1 && m0_last_rdata == 32'hD0D0_0001);
    @(negedge aclk); s_r_en[1] = 0; s_rlast[1] = 0;

    // =================================================================
    $display("\n=== SCENARIO E : out-of-range address goes to the default slave ===");
    reset_all();
    for (int s = 0; s < TOTAL_SLAVES; s++) begin s_aw_en[s]=1; s_w_en[s]=1; end
    m0_aw(32'hDEAD_0000, 4'd1, 40, ok);
    check("out-of-range AW accepted", ok);
    idle_cycles(2);
    check("out-of-range AW went to the default slave",
          s_aw_cnt[NO_OF_SLAVES] == 1 && s_last_awaddr[NO_OF_SLAVES] == 32'hDEAD_0000);

    // =================================================================
    $display("\n=== SCENARIO F : QoS arbitration between two masters ===");
    reset_all();
    s_aw_en[1] = 1; s_w_en[1] = 1;
    @(negedge aclk);
    mif[0].awaddr = 32'h0000_1000; mif[0].awqos = 4'd2;  mif[0].awvalid = 1;
    mif[1].awaddr = 32'h0000_1040; mif[1].awqos = 4'd12; mif[1].awvalid = 1;
    idle_cycles(6);
    check("higher-QoS master won slave 1",
          s_aw_cnt[1] == 1 && s_last_awaddr[1] == 32'h0000_1040);
    @(negedge aclk); mif[0].awvalid = 0; mif[1].awvalid = 0;

    // =================================================================
    $display("\n=== SCENARIO H : back-to-back writes to different slaves ===");
    // Proves the per-master binding is released and re-taken cleanly, and that
    // an earlier destination never picks up a later burst.
    reset_all();
    for (int s = 0; s < TOTAL_SLAVES; s++) begin
      s_aw_en[s]=1; s_w_en[s]=1;
    end
    begin
      logic [31:0] addrs [3];
      logic [31:0] datas [3];
      addrs[0] = 32'h0000_0100; addrs[1] = 32'h0000_2100; addrs[2] = 32'h0000_1100;
      datas[0] = 32'h1111_1111; datas[1] = 32'h2222_2222; datas[2] = 32'h3333_3333;

      for (int i = 0; i < 3; i++) begin
        int dst;
        dst = (addrs[i] >> SLAVE_MEMORY_SIZE);
        m0_aw(addrs[i], 4'd3, 40, ok);
        check($sformatf("burst %0d AW accepted", i), ok);
        m0_w(datas[i], 40, ok);
        check($sformatf("burst %0d W accepted", i), ok);
        @(negedge aclk); s_b_en[dst] = 1;
        idle_cycles(4);
        @(negedge aclk); s_b_en[dst] = 0;
        idle_cycles(2);
        check($sformatf("burst %0d data landed on slave %0d", i, dst),
              s_last_wdata[dst] == datas[i]);
      end
      check("each slave saw exactly its own single burst",
            s_w_cnt[1] == 1 && s_w_cnt[2] == 1 && s_w_cnt[0] == 1);
      check("untouched slaves saw nothing",
            s_w_cnt[3] == 0 && s_w_cnt[4] == 0);
    end

    // =================================================================
    $display("\n=== SCENARIO I : two masters concurrently to different slaves ===");
    reset_all();
    for (int s = 0; s < TOTAL_SLAVES; s++) begin s_aw_en[s]=1; s_w_en[s]=1; end
    @(negedge aclk);
    mif[0].awaddr = 32'h0000_0200; mif[0].awqos = 4'd4; mif[0].awvalid = 1;
    mif[1].awaddr = 32'h0000_3200; mif[1].awqos = 4'd4; mif[1].awvalid = 1;
    idle_cycles(6);
    @(negedge aclk); mif[0].awvalid = 0; mif[1].awvalid = 0;
    idle_cycles(2);
    check("master 0 reached slave 0",
          s_aw_cnt[0] == 1 && s_last_awaddr[0] == 32'h0000_0200);
    check("master 1 reached slave 3",
          s_aw_cnt[3] == 1 && s_last_awaddr[3] == 32'h0000_3200);
    check("no cross-talk to other slaves",
          s_aw_cnt[1] == 0 && s_aw_cnt[2] == 0 && s_aw_cnt[4] == 0);

    // =================================================================
    $display("\n=== SCENARIO J : equal-QoS fairness (no starvation) ===");
    // Both masters hammer the SAME slave at equal QoS. Round-robin tie-break
    // must let each of them through; the old lowest-index-wins would starve
    // master 1 completely.
    reset_all();
    s_aw_en[1] = 1; s_w_en[1] = 1;
    begin
      @(negedge aclk);
      mif[0].awaddr = 32'h0000_1000; mif[0].awqos = 4'd7; mif[0].awvalid = 1;
      mif[1].awaddr = 32'h0000_1080; mif[1].awqos = 4'd7; mif[1].awvalid = 1;
      // Each grant completes as soon as slave 1 returns its B response.
      for (int i = 0; i < 8; i++) begin
        @(negedge aclk); s_b_en[1] = 1;
        idle_cycles(3);
        @(negedge aclk); s_b_en[1] = 0;
        idle_cycles(3);
      end
      @(negedge aclk); mif[0].awvalid = 0; mif[1].awvalid = 0;
      idle_cycles(2);
      $display("  grants on slave 1: master0=%0d master1=%0d", aw_m0_wins, aw_m1_wins);
      check("both masters were granted at equal QoS (no starvation)",
            aw_m0_wins > 0 && aw_m1_wins > 0);
    end

    // =================================================================
    $display("\n=== SCENARIO K : stopped channel must NOT block the other channel ===");
    // Reproduces the captured deadlock. One master port carries two DMA
    // channels tagged by ARID. Channel 1's read is left in flight on slave 1
    // with the master no longer asserting RREADY (channel stopped). Channel 0
    // must still get its AR accepted for slave 0 - if the interconnect gates
    // the new AR on the old read draining, and the master gates RREADY on its
    // AR being accepted, the two lock each other up forever.
    reset_all();
    s_ar_en[1] = 1;
    @(negedge aclk);
    mif[0].arid = 4'd1;              // channel 1's tag
    mif[0].araddr = 32'h0000_1300; mif[0].arqos = 4'd7; mif[0].arvalid = 1;
    idle_cycles(5);
    check("ch1 AR was accepted by slave 1", s_ar_cnt[1] == 1);
    @(negedge aclk);
    mif[0].arvalid = 0;
    s_ar_en[1] = 0;
    s_r_en[1] = 1; s_rlast[1] = 0;   // slave 1 still holding beats, no RLAST
    mif[0].rready = 0;               // *** CHANNEL 1 STOPPED consuming ***
    idle_cycles(4);

    // Channel 0 now issues its own read, to a DIFFERENT slave, with its own ID.
    s_ar_en[0] = 1;
    @(negedge aclk);
    mif[0].arid = 4'd0; mif[0].araddr = 32'h0000_02bc; mif[0].arqos = 4'd5;
    mif[0].arvalid = 1;
    idle_cycles(8);
    check("ch0 AR is accepted even though ch1's read is still outstanding",
          s_ar_cnt[0] == 1 && s_last_araddr[0] == 32'h0000_02bc);
    check("ch0 AR went to slave 0, not slave 1", s_ar_cnt[1] == 1);
    check("slave 0 captured ARID 0 (channel 0's tag)", s_arid[0] == 4'd0);
    @(negedge aclk); mif[0].arvalid = 0;

    // Channel 0 now accepts data again. Channel 1's slave drains its remaining
    // beats first (tagged RID 1, which the DMA discards for a stopped channel),
    // then channel 0's own data must arrive tagged RID 0.
    @(negedge aclk);
    s_r_en[0] = 1; s_rlast[0] = 1;
    mif[0].rready = 1;
    idle_cycles(3);
    @(negedge aclk); s_rlast[1] = 1;   // slave 1 finishes its burst
    idle_cycles(3);
    @(negedge aclk); s_r_en[1] = 0; s_rlast[1] = 0;
    idle_cycles(6);
    $display("  master0 got rid=%0d data=0x%08h", m0_last_rid, m0_last_rdata);
    // Channel 1's leftover beats may legitimately arrive too (tagged RID 1,
    // which the DMA discards for a stopped channel). What matters is that
    // channel 0's own data reached the master tagged with channel 0's ID.
    check("ch0 read data reached the master tagged RID 0", m0_saw_ch0_data);

    // =================================================================
    $display("\n=== SCENARIO N : channel stop with NO other traffic ===");
    // The quiet case: one channel has a read outstanding, the channel is
    // stopped, and nothing else is in flight. Per TRM 4.8.2 the stop drains
    // the outstanding response, so the interconnect must deliver it and then
    // return the slave to IDLE, ready for the next transfer.
    reset_all();
    s_ar_en[3] = 1;
    @(negedge aclk);
    mif[0].arid = 4'd1;
    mif[0].araddr = 32'h0000_3000; mif[0].arqos = 4'd9; mif[0].arvalid = 1;
    idle_cycles(5);
    check("AR accepted by slave 3", s_ar_cnt[3] == 1);

    // *** CHANNEL STOPPED *** - no new requests are issued from here on.
    @(negedge aclk);
    mif[0].arvalid = 0; s_ar_en[3] = 0;
    s_r_en[3] = 1; s_rlast[3] = 0;   // slave still has beats to return
    mif[0].rready = 0;               // DMA momentarily not consuming
    idle_cycles(10);
    check("nothing is driven to any other slave during the stop",
          s_ar_cnt[0]==0 && s_ar_cnt[1]==0 && s_ar_cnt[2]==0 && s_ar_cnt[4]==0);

    // The stop drains the outstanding response.
    @(negedge aclk); mif[0].rready = 1;
    idle_cycles(3);
    @(negedge aclk); s_rlast[3] = 1;
    idle_cycles(3);
    @(negedge aclk); s_r_en[3] = 0; s_rlast[3] = 0;
    idle_cycles(4);
    check("the outstanding response was delivered, not dropped", m0_saw_ch1_data);
    check("slave 3 returned to IDLE after the drain", dut.rd_state[3] == 0);

    // The interconnect must be usable again for the next transfer.
    s_ar_en[1] = 1;
    @(negedge aclk); mif[0].arid = 4'd0;
    m0_ar(32'h0000_1500, 4'd3, 40, ok);
    check("a new transfer after the stop is accepted", ok);
    check("it routed to slave 1 by address", s_ar_cnt[1] == 1);

    // =================================================================
    $display("\n=== SCENARIO G : address decode boundaries ===");
    check("0x00000000 -> slave 0", dut.decode_address(32'h0000_0000) == 0);
    check("0x00000FFF -> slave 0", dut.decode_address(32'h0000_0FFF) == 0);
    check("0x00001000 -> slave 1", dut.decode_address(32'h0000_1000) == 1);
    check("0x00001FFF -> slave 1", dut.decode_address(32'h0000_1FFF) == 1);
    check("0x00002000 -> slave 2", dut.decode_address(32'h0000_2000) == 2);
    check("0x00003FFF -> slave 3", dut.decode_address(32'h0000_3FFF) == 3);
    check("0x00004000 -> default", dut.decode_address(32'h0000_4000) == NO_OF_SLAVES);
    check("0xFFFFFFFF -> default", dut.decode_address(32'hFFFF_FFFF) == NO_OF_SLAVES);

    $display("\n================ errors = %0d ================", errors);
    if (errors == 0) $display("RESULT: ALL CHECKS PASSED");
    else             $display("RESULT: %0d CHECK(S) FAILED", errors);
    $finish;
  end

  initial begin
    #500000;
    $display("TIMEOUT");
    $finish;
  end

endmodule
