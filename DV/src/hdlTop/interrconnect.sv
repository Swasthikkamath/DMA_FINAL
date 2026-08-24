package AxiGlobalPackage;
 
  // Global Parameters

  parameter int NO_OF_MASTERS = 2;

  parameter int NO_OF_SLAVES = 4;

  parameter int ADDR_WIDTH = 32;

  parameter int DATA_WIDTH = 32;

  parameter int ID_WIDTH = 4;

  parameter int SLAVE_MEMORY_SIZE = 12; // 2^10 = 1KB per slave

  parameter int QOS_WIDTH = 4; // QoS priority width (0-15, higher is higher priority)

  // AXI Burst Types

  typedef enum logic [1:0] {

    FIXED = 2'b00,

    INCR  = 2'b01,

    WRAP  = 2'b10

  } burst_type_e;

  // AXI Response Types

  typedef enum logic [1:0] {

    OKAY   = 2'b00,

    EXOKAY = 2'b01,

    SLVERR = 2'b10,

    DECERR = 2'b11

  } resp_type_e;

  // AXI Size Encoding

  typedef enum logic [2:0] {

    SIZE_1B   = 3'b000,

    SIZE_2B   = 3'b001,

    SIZE_4B   = 3'b010,

    SIZE_8B   = 3'b011,

    SIZE_16B  = 3'b100,

    SIZE_32B  = 3'b101,

    SIZE_64B  = 3'b110,

    SIZE_128B = 3'b111

  } size_type_e;
 
endpackage

import AxiGlobalPackage::*;

import AxiGlobalPackage::*;
 
interface AxiInterconnect #(
  // Cycles a slave may sit in DATA_PHASE with no progress before the
  // interconnect concludes the master abandoned the burst (DMA channel stop)
  // and reclaims the slave. No mis-routing is possible while stalled, so this
  // only bounds how long recovery takes; it is safe to make it large.
  parameter int ABORT_TIMEOUT = 1024
)(

  input logic aclk,

  input logic aresetn,

  axi4_if axiMasterInterface[NO_OF_MASTERS],

  axi4_if axiSlaveInterface[NO_OF_SLAVES+1] // index NO_OF_SLAVES is reserved for the default/decode-error slave

);
 
  // TOTAL_SLAVES = every real, address-mapped slave (0 .. NO_OF_SLAVES-1)

  // plus one reserved default slave at index NO_OF_SLAVES that catches any

  // address which does not decode to a real slave.

  localparam int TOTAL_SLAVES = NO_OF_SLAVES + 1;

  localparam int DEFAULT_SLAVE = NO_OF_SLAVES;
 

  // ============================================================================

  // 1. Master Signal Collection (Unpacking)

  // ============================================================================

  logic [ID_WIDTH-1:0]    master_awid[NO_OF_MASTERS];

  logic [ADDR_WIDTH-1:0]  master_awaddr[NO_OF_MASTERS];

  logic [7:0]             master_awlen[NO_OF_MASTERS];

  logic [2:0]             master_awsize[NO_OF_MASTERS];

  logic [1:0]             master_awburst[NO_OF_MASTERS];

  logic                   master_awlock[NO_OF_MASTERS];

  logic [3:0]             master_awcache[NO_OF_MASTERS];

  logic [2:0]             master_awprot[NO_OF_MASTERS];

  logic                   master_awvalid[NO_OF_MASTERS];

  logic [QOS_WIDTH-1:0]   master_awqos[NO_OF_MASTERS];

  logic [DATA_WIDTH-1:0]   master_wdata[NO_OF_MASTERS];

  logic [DATA_WIDTH/8-1:0] master_wstrb[NO_OF_MASTERS];

  logic                    master_wlast[NO_OF_MASTERS];

  logic                    master_wvalid[NO_OF_MASTERS];

  logic                    master_bready[NO_OF_MASTERS];

  logic [ID_WIDTH-1:0]    master_arid[NO_OF_MASTERS];

  logic [ADDR_WIDTH-1:0]  master_araddr[NO_OF_MASTERS];

  logic [7:0]             master_arlen[NO_OF_MASTERS];

  logic [2:0]             master_arsize[NO_OF_MASTERS];

  logic [1:0]             master_arburst[NO_OF_MASTERS];

  logic                   master_arlock[NO_OF_MASTERS];

  logic [3:0]             master_arcache[NO_OF_MASTERS];

  logic [2:0]             master_arprot[NO_OF_MASTERS];

  logic                   master_arvalid[NO_OF_MASTERS];

  logic [QOS_WIDTH-1:0]   master_arqos[NO_OF_MASTERS];

  logic                   master_rready[NO_OF_MASTERS];
 
  generate

    for (genvar m = 0; m < NO_OF_MASTERS; m++) begin : master_signal_collect

      always_comb begin

        master_awid[m]     = axiMasterInterface[m].awid;

        master_awaddr[m]   = axiMasterInterface[m].awaddr;

        master_awlen[m]    = axiMasterInterface[m].awlen;

        master_awsize[m]   = axiMasterInterface[m].awsize;

        master_awburst[m]  = axiMasterInterface[m].awburst;

        master_awlock[m]   = axiMasterInterface[m].awlock;

        master_awcache[m]  = axiMasterInterface[m].awcache;

        master_awprot[m]   = axiMasterInterface[m].awprot;

        master_awvalid[m]  = axiMasterInterface[m].awvalid;

        master_awqos[m]    = axiMasterInterface[m].awqos;

        master_wdata[m]    = axiMasterInterface[m].wdata;

        master_wstrb[m]    = axiMasterInterface[m].wstrb;

        master_wlast[m]    = axiMasterInterface[m].wlast;

        master_wvalid[m]   = axiMasterInterface[m].wvalid;

        master_bready[m]   = axiMasterInterface[m].bready;

        master_arid[m]     = axiMasterInterface[m].arid;

        master_araddr[m]   = axiMasterInterface[m].araddr;

        master_arlen[m]    = axiMasterInterface[m].arlen;

        master_arsize[m]   = axiMasterInterface[m].arsize;

        master_arburst[m]  = axiMasterInterface[m].arburst;

        master_arlock[m]   = axiMasterInterface[m].arlock;

        master_arcache[m]  = axiMasterInterface[m].arcache;

        master_arprot[m]   = axiMasterInterface[m].arprot;

        master_arvalid[m]  = axiMasterInterface[m].arvalid;

        master_arqos[m]    = axiMasterInterface[m].arqos;

        master_rready[m]   = axiMasterInterface[m].rready;

      end

    end

  endgenerate
 
  // ============================================================================

  // 2. Slave Signal Collection (Unpacking)

  // Sized to TOTAL_SLAVES so the default slave (index NO_OF_SLAVES) is

  // collected the same way as every real slave.

  // ============================================================================

  logic slave_awready[TOTAL_SLAVES];

  logic slave_wready[TOTAL_SLAVES];

  logic [ID_WIDTH-1:0] slave_bid[TOTAL_SLAVES];

  logic [1:0]          slave_bresp[TOTAL_SLAVES];

  logic                slave_bvalid[TOTAL_SLAVES];

  logic slave_arready[TOTAL_SLAVES];

  logic [ID_WIDTH-1:0]   slave_rid[TOTAL_SLAVES];

  logic [DATA_WIDTH-1:0] slave_rdata[TOTAL_SLAVES];

  logic [1:0]            slave_rresp[TOTAL_SLAVES];

  logic                  slave_rlast[TOTAL_SLAVES];

  logic                  slave_rvalid[TOTAL_SLAVES];
 
  generate

    for (genvar s = 0; s < TOTAL_SLAVES; s++) begin : slave_signal_collect

      always_comb begin

        slave_awready[s] = axiSlaveInterface[s].awready;

        slave_wready[s]  = axiSlaveInterface[s].wready;

        slave_bid[s]     = axiSlaveInterface[s].bid;

        slave_bresp[s]   = axiSlaveInterface[s].bresp;

        slave_bvalid[s]  = axiSlaveInterface[s].bvalid;

        slave_arready[s] = axiSlaveInterface[s].arready;

        slave_rid[s]     = axiSlaveInterface[s].rid;

        slave_rdata[s]   = axiSlaveInterface[s].rdata;

        slave_rresp[s]   = axiSlaveInterface[s].rresp;

        slave_rlast[s]   = axiSlaveInterface[s].rlast;

        slave_rvalid[s]  = axiSlaveInterface[s].rvalid;

      end

    end

  endgenerate
 

  // ============================================================================
  // 3. Range-Based Address Decoder
  //
  // Every slave owns one uniform 2**SLAVE_MEMORY_SIZE window:
  //   slave i  ->  [ i*2**SLAVE_MEMORY_SIZE , (i+1)*2**SLAVE_MEMORY_SIZE )
  // Anything outside the mapped region goes to DEFAULT_SLAVE.
  //
  // The previous special case for slave 0 ("addr > 0 && addr <= 4096") had two
  // defects: address 0x0 fell through to DEFAULT_SLAVE, and 0x1000 matched both
  // slave 0 and slave 1 (the loop below claims it for slave 1). Both are fixed
  // by giving every slave the same uniform window.
  // ============================================================================
  function automatic int decode_address(logic [ADDR_WIDTH-1:0] addr);
    for (int i = 0; i < NO_OF_SLAVES; i++) begin
      if (addr >= (i * (1 << SLAVE_MEMORY_SIZE)) &&
          addr <  ((i + 1) * (1 << SLAVE_MEMORY_SIZE))) begin
        return i;
      end
    end
    return DEFAULT_SLAVE; // Out of range -> route to the default (decode-error) slave
  endfunction

  // ----------------------------------------------------------------------------
  // Arbitration helper: highest-QoS master currently targeting slaveId.
  //
  // Ties break round-robin starting just after lastServed, so two masters at
  // equal QoS cannot starve each other. (Previously the lowest index always won
  // and wr_last_served/rd_last_served were written but never read.)
  //
  // The function is pure now - it no longer writes the module-level
  // masterWriteReq/masterReadReq scratch arrays, which were being driven
  // concurrently from every per-slave always_ff block.
  // ----------------------------------------------------------------------------
  function automatic int slaveOwner(int slaveId, int writeRead, int lastServed);
    int  best;
    int  bestQos;
    int  cand;
    int  candQos;
    bit  candReq;

    best    = -1;
    bestQos = -1;

    for (int k = 0; k < NO_OF_MASTERS; k++) begin
      // Scan starting just after whoever was served last on this slave.
      cand = (lastServed + 1 + k) % NO_OF_MASTERS;

      if (writeRead == 1) begin
        candReq = master_awvalid[cand] && (decode_address(master_awaddr[cand]) == slaveId);
        candQos = int'(master_awqos[cand]);
      end else begin
        candReq = master_arvalid[cand] && (decode_address(master_araddr[cand]) == slaveId);
        candQos = int'(master_arqos[cand]);
      end

      // Strictly-greater keeps the earliest candidate in round-robin order on a
      // QoS tie, which is what makes the round-robin fair.
      if (candReq && (candQos > bestQos)) begin
        bestQos = candQos;
        best    = cand;
      end
    end

    return best;
  endfunction

  // ============================================================================
  // 4. Per-master transaction binding
  //
  // WHY THIS EXISTS
  // ---------------
  // The AXI W channel carries no address. The only thing binding a W burst to a
  // slave is the order of the AW that preceded it. When one physical master port
  // is time-multiplexed between two DMA channels and a channel is STOPPED
  // mid-transfer, that ordering guarantee is broken: an AW has been accepted for
  // slave X, but the W beats that follow belong to a different channel aimed at
  // slave Y. Nothing in the W beats themselves tells the interconnect this.
  //
  // Therefore the interconnect binds ONE write transaction per master at a time,
  // end to end (AW accepted -> ... -> B received), and refuses to accept the
  // next AW until that binding is resolved. If a channel is stopped, the next
  // channel's AW is back-pressured (a visible stall) rather than allowed to bind
  // while stale W beats are still in flight. Stalling is recoverable; routing a
  // channel's write data into the wrong slave silently corrupts memory.
  //
  // The same single-binding rule is applied to reads, which additionally removes
  // any chance of two slaves interleaving read data back to one master.
  //
  // A stalled binding is reclaimed after ABORT_TIMEOUT cycles of no progress,
  // which is what lets a stopped DMA channel free the slave it was using.
  // Because no mis-routing is possible while stalled, this timeout can safely be
  // large; it only bounds how long recovery takes.
  // ============================================================================
  typedef enum bit [1:0] {IDLE, ADDR_PHASE, DATA_PHASE} state_t;

  state_t wr_state[TOTAL_SLAVES];
  int     wr_owner[TOTAL_SLAVES];
  int     wr_last_served[TOTAL_SLAVES];
  int     wr_stall[TOTAL_SLAVES];

  state_t rd_state[TOTAL_SLAVES];
  int     rd_owner[TOTAL_SLAVES];
  int     rd_last_served[TOTAL_SLAVES];
  int     rd_stall[TOTAL_SLAVES];

  // Which slave each master's in-flight write/read is bound to (-1 = none).
  bit w_busy[NO_OF_MASTERS];
  int w_dest[NO_OF_MASTERS];
  bit r_busy[NO_OF_MASTERS];
  int r_dest[NO_OF_MASTERS];

  // ----------------------------------------------------------------------------
  // Forward-path qualification. The state machines and the routing muxes both
  // read these, so they can never disagree about when a handshake happened.
  // ----------------------------------------------------------------------------
  bit aw_fwd [TOTAL_SLAVES]; // AW presented to this slave
  bit w_fwd  [TOTAL_SLAVES]; // W  presented to this slave
  bit ar_fwd [TOTAL_SLAVES]; // AR presented to this slave
  bit b_sel  [TOTAL_SLAVES]; // this slave is its owner's B source
  bit r_sel  [TOTAL_SLAVES]; // this slave is its owner's R source

  bit wr_done [TOTAL_SLAVES]; // write completed this cycle (B accepted)
  bit rd_done [TOTAL_SLAVES]; // read completed this cycle (RLAST accepted)
  bit wr_kill [TOTAL_SLAVES]; // write binding abandoned - reclaim
  bit rd_kill [TOTAL_SLAVES]; // read binding abandoned  - reclaim

  always_comb begin
    for (int s = 0; s < TOTAL_SLAVES; s++) begin
      aw_fwd[s]  = 1'b0;
      w_fwd[s]   = 1'b0;
      ar_fwd[s]  = 1'b0;
      b_sel[s]   = 1'b0;
      r_sel[s]   = 1'b0;
      wr_done[s] = 1'b0;
      rd_done[s] = 1'b0;
      wr_kill[s] = 1'b0;
      rd_kill[s] = 1'b0;
    end

    for (int s = 0; s < TOTAL_SLAVES; s++) begin
      int wo;
      int ro;
      wo = wr_owner[s];
      ro = rd_owner[s];

      // ---- AW ----
      // Requires the owner's CURRENT address to still decode to this slave, so
      // a grant left over from a stopped channel cannot capture the next
      // channel's address. Also requires the owner to have no write already
      // bound, which is what prevents a second binding forming over stale
      // W beats.
      if (wr_state[s] == ADDR_PHASE && wo >= 0) begin
        aw_fwd[s] = master_awvalid[wo] &&
                    (decode_address(master_awaddr[wo]) == s) &&
                    !w_busy[wo];
      end

      // ---- W ---- strictly to the slave this master's write is bound to.
      if (wr_state[s] == DATA_PHASE && wo >= 0) begin
        w_fwd[s] = master_wvalid[wo] && w_busy[wo] && (w_dest[wo] == s);
      end

      // ---- B ---- exactly one source slave per master, by binding.
      if (wr_state[s] == DATA_PHASE && wo >= 0) begin
        b_sel[s]   = w_busy[wo] && (w_dest[wo] == s) && slave_bvalid[s];
        wr_done[s] = b_sel[s] && master_bready[wo];
      end

      // ---- AR / R ---- same rules as the write side.
      if (rd_state[s] == ADDR_PHASE && ro >= 0) begin
        ar_fwd[s] = master_arvalid[ro] &&
                    (decode_address(master_araddr[ro]) == s) &&
                    !r_busy[ro];
      end

      if (rd_state[s] == DATA_PHASE && ro >= 0) begin
        r_sel[s]   = r_busy[ro] && (r_dest[ro] == s) && slave_rvalid[s];
        rd_done[s] = r_sel[s] && slave_rlast[s] && master_rready[ro];
      end

      // ---- abandoned-burst reclaim ----
      wr_kill[s] = (wr_state[s] == DATA_PHASE) && (wr_stall[s] >= ABORT_TIMEOUT);
      rd_kill[s] = (rd_state[s] == DATA_PHASE) && (rd_stall[s] >= ABORT_TIMEOUT);
    end
  end

  // ----------------------------------------------------------------------------
  // Per-slave arbitration state machines
  // ----------------------------------------------------------------------------
  generate
    for (genvar s = 0; s < TOTAL_SLAVES; s++) begin : arbitration_logic

      // --- Write Channel ---
      always_ff @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
          wr_state[s]       <= IDLE;
          wr_owner[s]       <= -1;
          wr_last_served[s] <= NO_OF_MASTERS - 1;
          wr_stall[s]       <= 0;
        end else begin
          case (wr_state[s])

            IDLE: begin
              int best_m;
              best_m      = slaveOwner(s, 1, wr_last_served[s]);
              wr_stall[s] <= 0;
              // Do not grant to a master that already has a write bound - it
              // could not be forwarded anyway, and it would only churn.
              if (best_m != -1 && !w_busy[best_m]) begin
                wr_owner[s] <= best_m;
                wr_state[s] <= ADDR_PHASE;
              end
            end

            ADDR_PHASE: begin
              // aw_fwd already folds in "owner still driving AND still decoding
              // to me", so losing it means the request was withdrawn or
              // re-targeted: release rather than latch the stale grant.
              if (!aw_fwd[s]) begin
                wr_state[s] <= IDLE;
                wr_owner[s] <= -1;
              end else if (slave_awready[s]) begin
                wr_state[s] <= DATA_PHASE;
                wr_stall[s] <= 0;
              end
            end

            DATA_PHASE: begin
              if (wr_done[s]) begin
                wr_last_served[s] <= wr_owner[s];
                wr_state[s]       <= IDLE;
                wr_owner[s]       <= -1;
                wr_stall[s]       <= 0;
              end else if (wr_kill[s]) begin
                wr_last_served[s] <= wr_owner[s];
                wr_state[s]       <= IDLE;
                wr_owner[s]       <= -1;
                wr_stall[s]       <= 0;
              end else if (w_fwd[s] && slave_wready[s]) begin
                wr_stall[s] <= 0;              // burst is progressing
              end else begin
                wr_stall[s] <= wr_stall[s] + 1;
              end
            end

            default: begin   // unreachable encoding - fail safe to IDLE
              wr_state[s] <= IDLE;
              wr_owner[s] <= -1;
            end

          endcase
        end
      end

      // --- Read Channel ---
      always_ff @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
          rd_state[s]       <= IDLE;
          rd_owner[s]       <= -1;
          rd_last_served[s] <= NO_OF_MASTERS - 1;
          rd_stall[s]       <= 0;
        end else begin
          case (rd_state[s])

            IDLE: begin
              int best_m;
              best_m      = slaveOwner(s, 0, rd_last_served[s]);
              rd_stall[s] <= 0;
              if (best_m != -1 && !r_busy[best_m]) begin
                rd_owner[s] <= best_m;
                rd_state[s] <= ADDR_PHASE;
              end
            end

            ADDR_PHASE: begin
              if (!ar_fwd[s]) begin
                rd_state[s] <= IDLE;
                rd_owner[s] <= -1;
              end else if (slave_arready[s]) begin
                rd_state[s] <= DATA_PHASE;
                rd_stall[s] <= 0;
              end
            end

            DATA_PHASE: begin
              if (rd_done[s]) begin
                rd_last_served[s] <= rd_owner[s];
                rd_state[s]       <= IDLE;
                rd_owner[s]       <= -1;
                rd_stall[s]       <= 0;
              end else if (rd_kill[s]) begin
                rd_last_served[s] <= rd_owner[s];
                rd_state[s]       <= IDLE;
                rd_owner[s]       <= -1;
                rd_stall[s]       <= 0;
              end else if (r_sel[s] && master_rready[rd_owner[s]]) begin
                rd_stall[s] <= 0;              // beats are flowing
              end else begin
                rd_stall[s] <= rd_stall[s] + 1;
              end
            end

            default: begin   // unreachable encoding - fail safe to IDLE
              rd_state[s] <= IDLE;
              rd_owner[s] <= -1;
            end

          endcase
        end
      end

    end
  endgenerate

  // ----------------------------------------------------------------------------
  // Per-master binding registers
  // ----------------------------------------------------------------------------
  generate
    for (genvar m = 0; m < NO_OF_MASTERS; m++) begin : binding_regs
      always_ff @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
          w_busy[m] <= 1'b0;
          w_dest[m] <= -1;
          r_busy[m] <= 1'b0;
          r_dest[m] <= -1;
        end else begin
          // ---- write binding ----
          if (!w_busy[m]) begin
            // A master drives one AW at a time and a grant requires a decode
            // match, so at most one slave can accept an AW for it per cycle.
            for (int s = 0; s < TOTAL_SLAVES; s++) begin
              if (wr_state[s] == ADDR_PHASE && wr_owner[s] == m &&
                  aw_fwd[s] && slave_awready[s]) begin
                w_busy[m] <= 1'b1;
                w_dest[m] <= s;
              end
            end
          end else begin
            for (int s = 0; s < TOTAL_SLAVES; s++) begin
              if (w_dest[m] == s && (wr_done[s] || wr_kill[s])) begin
                w_busy[m] <= 1'b0;
                w_dest[m] <= -1;
              end
            end
          end

          // ---- read binding ----
          if (!r_busy[m]) begin
            for (int s = 0; s < TOTAL_SLAVES; s++) begin
              if (rd_state[s] == ADDR_PHASE && rd_owner[s] == m &&
                  ar_fwd[s] && slave_arready[s]) begin
                r_busy[m] <= 1'b1;
                r_dest[m] <= s;
              end
            end
          end else begin
            for (int s = 0; s < TOTAL_SLAVES; s++) begin
              if (r_dest[m] == s && (rd_done[s] || rd_kill[s])) begin
                r_busy[m] <= 1'b0;
                r_dest[m] <= -1;
              end
            end
          end
        end
      end
    end
  endgenerate

  // ============================================================================
  // 5. Muxing: Master to Slave (Forward Path)
  //
  // Every field is assigned unconditionally, so an idle slave port is driven to
  // a defined value instead of latching whatever the previous owner left there.
  // ============================================================================
  generate
    for (genvar s = 0; s < TOTAL_SLAVES; s++) begin : m2s_routing
      always_comb begin
        int wo;
        int ro;

        wo = wr_owner[s];
        ro = rd_owner[s];

        axiSlaveInterface[s].awid    = '0;
        axiSlaveInterface[s].awaddr  = '0;
        axiSlaveInterface[s].awlen   = '0;
        axiSlaveInterface[s].awsize  = '0;
        axiSlaveInterface[s].awburst = '0;
        axiSlaveInterface[s].awlock  = '0;
        axiSlaveInterface[s].awcache = '0;
        axiSlaveInterface[s].awprot  = '0;
        axiSlaveInterface[s].awqos   = '0;
        axiSlaveInterface[s].awvalid = 1'b0;
        axiSlaveInterface[s].wdata   = '0;
        axiSlaveInterface[s].wstrb   = '0;
        axiSlaveInterface[s].wlast   = 1'b0;
        axiSlaveInterface[s].wvalid  = 1'b0;
        axiSlaveInterface[s].bready  = 1'b0;
        axiSlaveInterface[s].arid    = '0;
        axiSlaveInterface[s].araddr  = '0;
        axiSlaveInterface[s].arlen   = '0;
        axiSlaveInterface[s].arsize  = '0;
        axiSlaveInterface[s].arburst = '0;
        axiSlaveInterface[s].arlock  = '0;
        axiSlaveInterface[s].arcache = '0;
        axiSlaveInterface[s].arprot  = '0;
        axiSlaveInterface[s].arqos   = '0;
        axiSlaveInterface[s].arvalid = 1'b0;
        axiSlaveInterface[s].rready  = 1'b0;

        // ---- Write address channel ----
        if (wr_state[s] == ADDR_PHASE && wo >= 0) begin
          axiSlaveInterface[s].awid    = master_awid[wo];
          axiSlaveInterface[s].awaddr  = master_awaddr[wo];
          axiSlaveInterface[s].awlen   = master_awlen[wo];
          axiSlaveInterface[s].awsize  = master_awsize[wo];
          axiSlaveInterface[s].awburst = master_awburst[wo];
          axiSlaveInterface[s].awlock  = master_awlock[wo];
          axiSlaveInterface[s].awcache = master_awcache[wo];
          axiSlaveInterface[s].awprot  = master_awprot[wo];
          axiSlaveInterface[s].awqos   = master_awqos[wo];
          axiSlaveInterface[s].awvalid = aw_fwd[s];
        end

        // ---- Write data / response ----
        if (wr_state[s] == DATA_PHASE && wo >= 0 && w_busy[wo] && (w_dest[wo] == s)) begin
          axiSlaveInterface[s].wdata  = master_wdata[wo];
          axiSlaveInterface[s].wstrb  = master_wstrb[wo];
          axiSlaveInterface[s].wlast  = master_wlast[wo];
          axiSlaveInterface[s].wvalid = w_fwd[s];
          axiSlaveInterface[s].bready = master_bready[wo];
        end

        // ---- Read address channel ----
        if (rd_state[s] == ADDR_PHASE && ro >= 0) begin
          axiSlaveInterface[s].arid    = master_arid[ro];
          axiSlaveInterface[s].araddr  = master_araddr[ro];
          axiSlaveInterface[s].arlen   = master_arlen[ro];
          axiSlaveInterface[s].arsize  = master_arsize[ro];
          axiSlaveInterface[s].arburst = master_arburst[ro];
          axiSlaveInterface[s].arlock  = master_arlock[ro];
          axiSlaveInterface[s].arcache = master_arcache[ro];
          axiSlaveInterface[s].arprot  = master_arprot[ro];
          axiSlaveInterface[s].arqos   = master_arqos[ro];
          axiSlaveInterface[s].arvalid = ar_fwd[s];
        end

        // ---- Read data ----
        if (rd_state[s] == DATA_PHASE && ro >= 0 && r_busy[ro] && (r_dest[ro] == s)) begin
          axiSlaveInterface[s].rready = master_rready[ro];
        end
      end
    end
  endgenerate

  // ============================================================================
  // 6. Muxing: Slave to Master (Backward Path)
  //
  // Each master takes each response from exactly one slave, chosen by its
  // binding. The previous version looped over every slave with no arbitration,
  // so the highest slave index silently overwrote every lower one - which is how
  // a stale slave ended up handing its read data to the master instead of the
  // slave that was actually addressed.
  // ============================================================================
  generate
    for (genvar m = 0; m < NO_OF_MASTERS; m++) begin : s2m_routing
      always_comb begin
        axiMasterInterface[m].awready = 1'b0;
        axiMasterInterface[m].wready  = 1'b0;
        axiMasterInterface[m].bid     = '0;
        axiMasterInterface[m].bresp   = '0;
        axiMasterInterface[m].bvalid  = 1'b0;
        axiMasterInterface[m].arready = 1'b0;
        axiMasterInterface[m].rid     = '0;
        axiMasterInterface[m].rdata   = '0;
        axiMasterInterface[m].rresp   = '0;
        axiMasterInterface[m].rlast   = 1'b0;
        axiMasterInterface[m].rvalid  = 1'b0;

        for (int s = 0; s < TOTAL_SLAVES; s++) begin
          // AWREADY: the one slave in ADDR_PHASE whose decode matches.
          if (wr_state[s] == ADDR_PHASE && wr_owner[s] == m && aw_fwd[s]) begin
            axiMasterInterface[m].awready = slave_awready[s];
          end
          // WREADY: strictly this master's bound write destination.
          if (wr_state[s] == DATA_PHASE && wr_owner[s] == m &&
              w_busy[m] && (w_dest[m] == s)) begin
            axiMasterInterface[m].wready = slave_wready[s];
          end
          // B: exactly one source slave.
          if (b_sel[s] && wr_owner[s] == m) begin
            axiMasterInterface[m].bid    = slave_bid[s];
            axiMasterInterface[m].bresp  = slave_bresp[s];
            axiMasterInterface[m].bvalid = 1'b1;
          end
          // ARREADY: the one slave in ADDR_PHASE whose decode matches.
          if (rd_state[s] == ADDR_PHASE && rd_owner[s] == m && ar_fwd[s]) begin
            axiMasterInterface[m].arready = slave_arready[s];
          end
          // R: exactly one source slave.
          if (r_sel[s] && rd_owner[s] == m) begin
            axiMasterInterface[m].rid    = slave_rid[s];
            axiMasterInterface[m].rdata  = slave_rdata[s];
            axiMasterInterface[m].rresp  = slave_rresp[s];
            axiMasterInterface[m].rlast  = slave_rlast[s];
            axiMasterInterface[m].rvalid = 1'b1;
          end
        end
      end
    end
  endgenerate

endinterface
