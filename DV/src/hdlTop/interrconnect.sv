package AxiGlobalPackage;
  // Global Parameters
 
  parameter int NO_OF_MASTERS = 2;
 
  parameter int NO_OF_SLAVES = 6;
 
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
  // interconnect gives up on the transfer and reclaims the slave.
  //
  // DISABLED BY DEFAULT (0), deliberately. The DMA-350 TRM section 4.8.2 states
  // that a channel stop "waits for all the outstanding responses from read and
  // write transactions". So every accepted AR/AW must eventually produce its R
  // or B response at the master, even for a channel that has been stopped - the
  // DMA is draining those responses in order to complete the stop handshake.
  //
  // Reclaiming a transfer here drops its response on the floor, which hangs
  // that handshake forever. There is therefore no such thing as an abandoned
  // read for this DUT: the master is always still waiting. Leave this at 0
  // unless you are deliberately debugging a wedged slave model, where a
  // stuck-forever interconnect is harder to diagnose than a reclaimed one.
  parameter int ABORT_TIMEOUT = 0
)(
 
  input logic aclk,
 
  input logic aresetn,
 
  axi4_if axiMasterInterface[AxiGlobalPackage::NO_OF_MASTERS],
 
  axi4_if axiSlaveInterface[AxiGlobalPackage::NO_OF_SLAVES+1] // index NO_OF_SLAVES is reserved for the default/decode-error slave
 
);
  // TOTAL_SLAVES = every real, address-mapped slave (0 .. NO_OF_SLAVES-1)
 
  // plus one reserved default slave at index NO_OF_SLAVES that catches any
 
  // address which does not decode to a real slave.
 
  localparam int TOTAL_SLAVES = AxiGlobalPackage::NO_OF_SLAVES + 1;
 
  localparam int DEFAULT_SLAVE = AxiGlobalPackage::NO_OF_SLAVES;

 
  // ============================================================================
 
  // 1. Master Signal Collection (Unpacking)
 
  // ============================================================================
 
  logic [ID_WIDTH-1:0]    master_awid[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic [ADDR_WIDTH-1:0]  master_awaddr[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic [7:0]             master_awlen[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic [2:0]             master_awsize[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic [1:0]             master_awburst[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic                   master_awlock[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic [3:0]             master_awcache[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic [2:0]             master_awprot[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic                   master_awvalid[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic [QOS_WIDTH-1:0]   master_awqos[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic [DATA_WIDTH-1:0]   master_wdata[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic [DATA_WIDTH/8-1:0] master_wstrb[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic                    master_wlast[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic                    master_wvalid[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic                    master_bready[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic [ID_WIDTH-1:0]    master_arid[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic [ADDR_WIDTH-1:0]  master_araddr[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic [7:0]             master_arlen[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic [2:0]             master_arsize[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic [1:0]             master_arburst[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic                   master_arlock[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic [3:0]             master_arcache[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic [2:0]             master_arprot[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic                   master_arvalid[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic [QOS_WIDTH-1:0]   master_arqos[AxiGlobalPackage::NO_OF_MASTERS];
 
  logic                   master_rready[AxiGlobalPackage::NO_OF_MASTERS];
  generate
 
    for (genvar m = 0; m < AxiGlobalPackage::NO_OF_MASTERS; m++) begin : master_signal_collect
 
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
 
  logic [AxiGlobalPackage::ID_WIDTH-1:0] slave_bid[TOTAL_SLAVES];
 
  logic [1:0]          slave_bresp[TOTAL_SLAVES];
 
  logic                slave_bvalid[TOTAL_SLAVES];
 
  logic slave_arready[TOTAL_SLAVES];
 
  logic [AxiGlobalPackage::ID_WIDTH-1:0]   slave_rid[TOTAL_SLAVES];
 
  logic [AxiGlobalPackage::DATA_WIDTH-1:0] slave_rdata[TOTAL_SLAVES];
 
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
  function automatic int decode_address(logic [AxiGlobalPackage::ADDR_WIDTH-1:0] addr);
    for (int i = 0; i <AxiGlobalPackage:: NO_OF_SLAVES; i++) begin
      if (addr >= (i * (1 << AxiGlobalPackage::SLAVE_MEMORY_SIZE)) &&
          addr <  ((i + 1) * (1 << AxiGlobalPackage::SLAVE_MEMORY_SIZE))) begin
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
 
    for (int k = 0; k < AxiGlobalPackage::NO_OF_MASTERS; k++) begin
      // Scan starting just after whoever was served last on this slave.
      cand = (lastServed + 1 + k) % AxiGlobalPackage::NO_OF_MASTERS;
 
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
  // 4. Outstanding-transaction tracking
  //
  // TOPOLOGY NOTE
  // -------------
  // One physical master port (the DMA interface manager) is time-multiplexed
  // between DMA channels, and the channel is carried in AWID/ARID - RID/BID come
  // back tagged the same way. So the channels ARE distinguishable on the wire,
  // and the master legitimately keeps several transactions outstanding at once,
  // to different slaves.
  //
  // The interconnect must therefore NEVER gate a new AR/AW on some other
  // transaction of the same master finishing. Doing so deadlocks: the master
  // holds RREADY low while it waits to issue its next read, and the
  // interconnect holds ARREADY low while it waits for the previous read to
  // drain. Each per-slave FSM independently allows one outstanding transaction
  // per slave, which is the only limit imposed here.
  //
  // What still needs ordering is the W channel: it carries no address, so W
  // bursts must be delivered to slaves in the order their AWs were accepted.
  // That is what the per-master destination queue below is for.
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
 
  // ---- W-channel destination queue, one per master --------------------------
  localparam int WQ_DEPTH = TOTAL_SLAVES;
 
  int wq_mem [AxiGlobalPackage::NO_OF_MASTERS][WQ_DEPTH];
  int wq_head[AxiGlobalPackage::NO_OF_MASTERS];
  int wq_tail[AxiGlobalPackage::NO_OF_MASTERS];
  int wq_cnt [AxiGlobalPackage::NO_OF_MASTERS];
 
  int wq_dest[AxiGlobalPackage::NO_OF_MASTERS];   // slave the current W burst belongs to (-1 = none)
 
  always_comb begin
    for (int m = 0; m < AxiGlobalPackage::NO_OF_MASTERS; m++) begin
      wq_dest[m] = (wq_cnt[m] != 0) ? wq_mem[m][wq_head[m]] : -1;
    end
  end
 
  // ---- R-burst lock, one per master -----------------------------------------
  // Read data from two slaves must not interleave back to one master, so once a
  // burst starts delivering it keeps the master's R channel until RLAST. The
  // lock is only taken when a beat actually transfers, so a slave that is
  // presenting data nobody is consuming cannot wedge the arbiter.
  int r_lock  [AxiGlobalPackage::NO_OF_MASTERS];
  bit r_lock_v[AxiGlobalPackage::NO_OF_MASTERS];
 
  // ---- Stopped-channel detection -------------------------------------------
  // The DMA carries the channel number in AWID/ARID and only moves to another
  // channel's pending transfer when the current channel is stopped. So if a new
  // address is accepted for a master while an older transfer of that master is
  // still outstanding UNDER A DIFFERENT ID, that older transfer belongs to a
  // channel that has just been stopped.
  //
  // Its data must not be routed back to the master - the master has moved on and
  // will not accept it, which otherwise stalls the read channel forever. But the
  // slave still has a burst in flight and must be allowed to finish it, so the
  // interconnect drains that burst itself (asserting RREADY / BREADY towards the
  // slave) and discards the beats instead of forwarding them.
  logic [AxiGlobalPackage::ID_WIDTH-1:0] rd_id[TOTAL_SLAVES];   // ARID captured at AR handshake
  logic [AxiGlobalPackage::ID_WIDTH-1:0] wr_id[TOTAL_SLAVES];   // AWID captured at AW handshake
  bit rd_discard[TOTAL_SLAVES];
  bit wr_discard[TOTAL_SLAVES];
  int r_rr    [AxiGlobalPackage::NO_OF_MASTERS];  // round-robin pointer for picking the next burst
  int b_rr    [AxiGlobalPackage::NO_OF_MASTERS];  // round-robin pointer for B responses
 
  // ----------------------------------------------------------------------------
  // Forward/backward qualification, shared by the muxes and the state machines.
  // ----------------------------------------------------------------------------
  bit aw_fwd [TOTAL_SLAVES];
  bit w_fwd  [TOTAL_SLAVES];
  bit ar_fwd [TOTAL_SLAVES];
  bit b_sel  [TOTAL_SLAVES];
  bit r_sel  [TOTAL_SLAVES];
 
  bit wr_done[TOTAL_SLAVES];
  bit rd_done[TOTAL_SLAVES];
  bit wr_kill[TOTAL_SLAVES];
  bit rd_kill[TOTAL_SLAVES];
 
  // A new address accepted this cycle for each master, and the ID it carried.
  bit                  new_ar[AxiGlobalPackage::NO_OF_MASTERS];
  bit                  new_aw[AxiGlobalPackage::NO_OF_MASTERS];
  logic [AxiGlobalPackage::ID_WIDTH-1:0] new_ar_id[AxiGlobalPackage::NO_OF_MASTERS];
  logic [AxiGlobalPackage::ID_WIDTH-1:0] new_aw_id[AxiGlobalPackage::NO_OF_MASTERS];
 
  always_comb begin
    for (int m = 0; m < AxiGlobalPackage::NO_OF_MASTERS; m++) begin
      new_ar[m]    = 1'b0;
      new_aw[m]    = 1'b0;
      new_ar_id[m] = '0;
      new_aw_id[m] = '0;
    end
    for (int s = 0; s < TOTAL_SLAVES; s++) begin
      if (rd_state[s] == ADDR_PHASE && rd_owner[s] >= 0 &&
          ar_fwd[s] && slave_arready[s]) begin
        new_ar[rd_owner[s]]    = 1'b1;
        new_ar_id[rd_owner[s]] = master_arid[rd_owner[s]];
      end
      if (wr_state[s] == ADDR_PHASE && wr_owner[s] >= 0 &&
          aw_fwd[s] && slave_awready[s]) begin
        new_aw[wr_owner[s]]    = 1'b1;
        new_aw_id[wr_owner[s]] = master_awid[wr_owner[s]];
      end
    end
  end
 
  always_comb begin
    int pick;
    int c;
 
    pick = -1;
    c    = 0;
 
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
 
    // ---- address channels ----
    // Gated only on "this master is still driving an address that decodes to
    // me". No cross-transaction gating: see the topology note above.
    for (int s = 0; s < TOTAL_SLAVES; s++) begin
      if (wr_state[s] == ADDR_PHASE && wr_owner[s] >= 0) begin
        aw_fwd[s] = master_awvalid[wr_owner[s]] &&
                    (decode_address(master_awaddr[wr_owner[s]]) == s);
      end
      if (rd_state[s] == ADDR_PHASE && rd_owner[s] >= 0) begin
        ar_fwd[s] = master_arvalid[rd_owner[s]] &&
                    (decode_address(master_araddr[rd_owner[s]]) == s);
      end
    end
 
    // ---- W channel: strictly to the head of the owner's destination queue ----
    for (int s = 0; s < TOTAL_SLAVES; s++) begin
      if (wr_state[s] == DATA_PHASE && wr_owner[s] >= 0) begin
        w_fwd[s] = master_wvalid[wr_owner[s]] && (wq_dest[wr_owner[s]] == s);
      end
    end
 
    // ---- R channel: one burst at a time per master, round-robin between them --
    for (int m = 0; m < AxiGlobalPackage::NO_OF_MASTERS; m++) begin
      pick = -1;
 
      if (r_lock_v[m]) begin
        // Mid-burst: stay with the locked slave.
        if (rd_state[r_lock[m]] == DATA_PHASE && rd_owner[r_lock[m]] == m &&
            !rd_discard[r_lock[m]] && slave_rvalid[r_lock[m]]) begin
          pick = r_lock[m];
        end
      end else begin
        for (int k = 0; k < TOTAL_SLAVES; k++) begin
          c = (r_rr[m] + 1 + k) % TOTAL_SLAVES;
          if (pick == -1 && rd_state[c] == DATA_PHASE && rd_owner[c] == m &&
              !rd_discard[c] && slave_rvalid[c]) begin
            pick = c;
          end
        end
      end
 
      if (pick != -1) begin
        r_sel[pick]   = 1'b1;
        rd_done[pick] = slave_rlast[pick] && master_rready[m];
      end
    end
 
    // ---- B channel: one response at a time per master, round-robin ------------
    for (int m = 0; m < AxiGlobalPackage::NO_OF_MASTERS; m++) begin
      pick = -1;
      for (int k = 0; k < TOTAL_SLAVES; k++) begin
        c = (b_rr[m] + 1 + k) % TOTAL_SLAVES;
        if (pick == -1 && wr_state[c] == DATA_PHASE && wr_owner[c] == m &&
            !wr_discard[c] && slave_bvalid[c]) begin
          pick = c;
        end
      end
      if (pick != -1) begin
        b_sel[pick]   = 1'b1;
        wr_done[pick] = master_bready[m];
      end
    end
 
    // ---- abandoned-transfer reclaim ----
    for (int s = 0; s < TOTAL_SLAVES; s++) begin
      wr_kill[s] = (ABORT_TIMEOUT != 0) &&
                   (wr_state[s] == DATA_PHASE) && (wr_stall[s] >= ABORT_TIMEOUT);
      rd_kill[s] = (ABORT_TIMEOUT != 0) &&
                   (rd_state[s] == DATA_PHASE) && (rd_stall[s] >= ABORT_TIMEOUT);
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
          wr_last_served[s] <= AxiGlobalPackage::NO_OF_MASTERS - 1;
          wr_stall[s]       <= 0;
        end else begin
          case (wr_state[s])
 
            IDLE: begin
              int best_m;
              best_m      = slaveOwner(s, 1, wr_last_served[s]);
              wr_stall[s] <= 0;
              if (best_m != -1) begin
                wr_owner[s] <= best_m;
                wr_state[s] <= ADDR_PHASE;
              end
            end
 
            ADDR_PHASE: begin
              // Losing aw_fwd means the request was withdrawn or re-targeted
              // (a stopped DMA channel does exactly this): release the grant
              // instead of latching it and capturing the next channel's address.
              if (!aw_fwd[s]) begin
                wr_state[s] <= IDLE;
                wr_owner[s] <= -1;
              end else if (slave_awready[s]) begin
                wr_state[s] <= DATA_PHASE;
                wr_stall[s] <= 0;
              end
            end
 
            DATA_PHASE: begin
              if (wr_done[s] || wr_kill[s]) begin
                wr_last_served[s] <= wr_owner[s];
                wr_state[s]       <= IDLE;
                wr_owner[s]       <= -1;
                wr_stall[s]       <= 0;
              end else if (w_fwd[s] && slave_wready[s]) begin
                wr_stall[s] <= 0;                 // burst is progressing
              end else begin
                wr_stall[s] <= wr_stall[s] + 1;
              end
            end
 
            default: begin
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
          rd_last_served[s] <= AxiGlobalPackage::NO_OF_MASTERS - 1;
          rd_stall[s]       <= 0;
        end else begin
          case (rd_state[s])
 
            IDLE: begin
              int best_m;
              best_m      = slaveOwner(s, 0, rd_last_served[s]);
              rd_stall[s] <= 0;
              if (best_m != -1) begin
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
              if (rd_done[s] || rd_kill[s]) begin
                rd_last_served[s] <= rd_owner[s];
                rd_state[s]       <= IDLE;
                rd_owner[s]       <= -1;
                rd_stall[s]       <= 0;
              end else if (r_sel[s] && master_rready[rd_owner[s]]) begin
                rd_stall[s] <= 0;                 // beats are flowing
              end else begin
                rd_stall[s] <= rd_stall[s] + 1;
              end
            end
 
            default: begin
              rd_state[s] <= IDLE;
              rd_owner[s] <= -1;
            end
 
          endcase
        end
      end
 
    end
  endgenerate
 
  // ----------------------------------------------------------------------------
  // Stopped-channel tracking, per slave.
  //
  // rd_id/wr_id remember which channel (AXI ID) each accepted transfer belongs
  // to. When the master gets a new address accepted under a different ID, any
  // still-outstanding transfer of that master belongs to a channel that has
  // been stopped, so it is marked for discard: drained towards the slave,
  // never forwarded to the master.
  // ----------------------------------------------------------------------------
  generate
    for (genvar s = 0; s < TOTAL_SLAVES; s++) begin : stopped_channel_track
      always_ff @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
          rd_id[s]      <= '0;
          wr_id[s]      <= '0;
          rd_discard[s] <= 1'b0;
          wr_discard[s] <= 1'b0;
        end else begin
          // ---- reads ----
          if (rd_state[s] == ADDR_PHASE && rd_owner[s] >= 0 &&
              ar_fwd[s] && slave_arready[s]) begin
            rd_id[s]      <= master_arid[rd_owner[s]];
            rd_discard[s] <= 1'b0;              // freshly accepted, keep it
          end else if (rd_state[s] == DATA_PHASE && rd_owner[s] >= 0 &&
                       new_ar[rd_owner[s]] && (new_ar_id[rd_owner[s]] != rd_id[s])) begin
            // The master moved to a different channel while this one was still
            // outstanding => this channel was stopped. Do not return its data.
            rd_discard[s] <= 1'b1;
          end
          if (rd_done[s] || rd_kill[s]) rd_discard[s] <= 1'b0;
 
          // ---- writes ----
          if (wr_state[s] == ADDR_PHASE && wr_owner[s] >= 0 &&
              aw_fwd[s] && slave_awready[s]) begin
            wr_id[s]      <= master_awid[wr_owner[s]];
            wr_discard[s] <= 1'b0;
          end else if (wr_state[s] == DATA_PHASE && wr_owner[s] >= 0 &&
                       new_aw[wr_owner[s]] && (new_aw_id[wr_owner[s]] != wr_id[s])) begin
            wr_discard[s] <= 1'b1;
          end
          if (wr_done[s] || wr_kill[s]) wr_discard[s] <= 1'b0;
        end
      end
    end
  endgenerate
 
  // ----------------------------------------------------------------------------
  // Per-master bookkeeping: W destination queue, R burst lock, round-robin ptrs
  // ----------------------------------------------------------------------------
  generate
    for (genvar m = 0; m < AxiGlobalPackage::NO_OF_MASTERS; m++) begin : master_tracking
      always_ff @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
          wq_head[m]  <= 0;
          wq_tail[m]  <= 0;
          wq_cnt[m]   <= 0;
          r_lock[m]   <= -1;
          r_lock_v[m] <= 1'b0;
          r_rr[m]     <= TOTAL_SLAVES - 1;
          b_rr[m]     <= TOTAL_SLAVES - 1;
          for (int i = 0; i < WQ_DEPTH; i++) wq_mem[m][i] <= -1;
        end else begin
          bit did_push;
          bit did_pop;
 
          did_push = 1'b0;
          did_pop  = 1'b0;
 
          // Push one entry per accepted AW. A master drives a single address at
          // a time and a grant requires a decode match, so at most one slave can
          // accept an AW for it in any cycle.
          for (int s = 0; s < TOTAL_SLAVES; s++) begin
            if (wr_state[s] == ADDR_PHASE && wr_owner[s] == m &&
                aw_fwd[s] && slave_awready[s]) begin
              wq_mem[m][wq_tail[m]] <= s;
              wq_tail[m]            <= (wq_tail[m] + 1) % WQ_DEPTH;
              did_push               = 1'b1;
            end
          end
 
          if (wq_cnt[m] != 0) begin
            int hs;
            hs = wq_mem[m][wq_head[m]];
            // Pop on WLAST, or when the head slave gave up on the burst.
            if ((w_fwd[hs] && slave_wready[hs] && master_wlast[m]) ||
                wr_kill[hs] ||
                (wr_state[hs] != DATA_PHASE) || (wr_owner[hs] != m)) begin
              wq_head[m] <= (wq_head[m] + 1) % WQ_DEPTH;
              did_pop     = 1'b1;
            end
          end
 
          if (did_push && !did_pop)      wq_cnt[m] <= wq_cnt[m] + 1;
          else if (!did_push && did_pop) wq_cnt[m] <= wq_cnt[m] - 1;
 
          // ---- R burst lock ----
          for (int s = 0; s < TOTAL_SLAVES; s++) begin
            if (r_sel[s] && rd_owner[s] == m && master_rready[m]) begin
              if (slave_rlast[s]) begin
                r_lock_v[m] <= 1'b0;      // burst finished, free to re-arbitrate
                r_lock[m]   <= -1;
                r_rr[m]     <= s;
              end else begin
                r_lock_v[m] <= 1'b1;      // mid-burst, hold this slave
                r_lock[m]   <= s;
              end
            end
          end
          // A locked slave that gets reclaimed must release the lock.
          if (r_lock_v[m] && (rd_kill[r_lock[m]] ||
                              rd_discard[r_lock[m]] ||
                              rd_state[r_lock[m]] != DATA_PHASE ||
                              rd_owner[r_lock[m]] != m)) begin
            r_lock_v[m] <= 1'b0;
            r_lock[m]   <= -1;
          end
 
          // ---- B round-robin ----
          for (int s = 0; s < TOTAL_SLAVES; s++) begin
            if (b_sel[s] && wr_owner[s] == m && master_bready[m]) begin
              b_rr[m] <= s;
            end
          end
        end
      end
    end
  endgenerate
 
  // ============================================================================
  // 5. Muxing: Master to Slave (Forward Path)
  //
  // axi4_if members are nets, so they must be driven by continuous assignment.
  // The routing decision is computed procedurally into block-local variables
  // (*_d) exactly as before, and each variable is continuously assigned onto
  // its interface net. Routing logic is unchanged.
  // ============================================================================
  generate
    for (genvar s = 0; s < TOTAL_SLAVES; s++) begin : m2s_routing
      logic [AxiGlobalPackage::ID_WIDTH-1:0]     awid_d;
      logic [AxiGlobalPackage::ADDR_WIDTH-1:0]   awaddr_d;
      logic [7:0]                                awlen_d;
      logic [2:0]                                awsize_d;
      logic [1:0]                                awburst_d;
      logic                                      awlock_d;
      logic [3:0]                                awcache_d;
      logic [2:0]                                awprot_d;
      logic [AxiGlobalPackage::QOS_WIDTH-1:0]    awqos_d;
      logic                                      awvalid_d;
      logic [AxiGlobalPackage::DATA_WIDTH-1:0]   wdata_d;
      logic [AxiGlobalPackage::DATA_WIDTH/8-1:0] wstrb_d;
      logic                                      wlast_d;
      logic                                      wvalid_d;
      logic                                      bready_d;
      logic [AxiGlobalPackage::ID_WIDTH-1:0]     arid_d;
      logic [AxiGlobalPackage::ADDR_WIDTH-1:0]   araddr_d;
      logic [7:0]                                arlen_d;
      logic [2:0]                                arsize_d;
      logic [1:0]                                arburst_d;
      logic                                      arlock_d;
      logic [3:0]                                arcache_d;
      logic [2:0]                                arprot_d;
      logic [AxiGlobalPackage::QOS_WIDTH-1:0]    arqos_d;
      logic                                      arvalid_d;
      logic                                      rready_d;

      always_comb begin
        int wo;
        int ro;

        wo = wr_owner[s];
        ro = rd_owner[s];

        awid_d    = '0;
        awaddr_d  = '0;
        awlen_d   = '0;
        awsize_d  = '0;
        awburst_d = '0;
        awlock_d  = '0;
        awcache_d = '0;
        awprot_d  = '0;
        awqos_d   = '0;
        awvalid_d = 1'b0;
        wdata_d   = '0;
        wstrb_d   = '0;
        wlast_d   = 1'b0;
        wvalid_d  = 1'b0;
        bready_d  = 1'b0;
        arid_d    = '0;
        araddr_d  = '0;
        arlen_d   = '0;
        arsize_d  = '0;
        arburst_d = '0;
        arlock_d  = '0;
        arcache_d = '0;
        arprot_d  = '0;
        arqos_d   = '0;
        arvalid_d = 1'b0;
        rready_d  = 1'b0;

        if (wr_state[s] == ADDR_PHASE && wo >= 0) begin
          awid_d    = master_awid[wo];
          awaddr_d  = master_awaddr[wo];
          awlen_d   = master_awlen[wo];
          awsize_d  = master_awsize[wo];
          awburst_d = master_awburst[wo];
          awlock_d  = master_awlock[wo];
          awcache_d = master_awcache[wo];
          awprot_d  = master_awprot[wo];
          awqos_d   = master_awqos[wo];
          awvalid_d = aw_fwd[s];
        end

        if (wr_state[s] == DATA_PHASE && wo >= 0) begin
          if (wq_dest[wo] == s) begin
            wdata_d  = master_wdata[wo];
            wstrb_d  = master_wstrb[wo];
            wlast_d  = master_wlast[wo];
            wvalid_d = w_fwd[s];
          end
          bready_d = b_sel[s] && master_bready[wo];
        end

        if (rd_state[s] == ADDR_PHASE && ro >= 0) begin
          arid_d    = master_arid[ro];
          araddr_d  = master_araddr[ro];
          arlen_d   = master_arlen[ro];
          arsize_d  = master_arsize[ro];
          arburst_d = master_arburst[ro];
          arlock_d  = master_arlock[ro];
          arcache_d = master_arcache[ro];
          arprot_d  = master_arprot[ro];
          arqos_d   = master_arqos[ro];
          arvalid_d = ar_fwd[s];
        end

        if (rd_state[s] == DATA_PHASE && ro >= 0) begin
          // Never handshake on behalf of the master. A stopped channel's slave
          // port is left un-acknowledged: r_sel[s] is already 0 for it, so
          // RREADY stays low and the TB's slave agent never observes a beat
          // that the DMA did not actually take.
          rready_d = r_sel[s] && master_rready[ro];
        end
      end

      assign axiSlaveInterface[s].awid    = awid_d;
      assign axiSlaveInterface[s].awaddr  = awaddr_d;
      assign axiSlaveInterface[s].awlen   = awlen_d;
      assign axiSlaveInterface[s].awsize  = awsize_d;
      assign axiSlaveInterface[s].awburst = awburst_d;
      assign axiSlaveInterface[s].awlock  = awlock_d;
      assign axiSlaveInterface[s].awcache = awcache_d;
      assign axiSlaveInterface[s].awprot  = awprot_d;
      assign axiSlaveInterface[s].awqos   = awqos_d;
      assign axiSlaveInterface[s].awvalid = awvalid_d;
      assign axiSlaveInterface[s].wdata   = wdata_d;
      assign axiSlaveInterface[s].wstrb   = wstrb_d;
      assign axiSlaveInterface[s].wlast   = wlast_d;
      assign axiSlaveInterface[s].wvalid  = wvalid_d;
      assign axiSlaveInterface[s].bready  = bready_d;
      assign axiSlaveInterface[s].arid    = arid_d;
      assign axiSlaveInterface[s].araddr  = araddr_d;
      assign axiSlaveInterface[s].arlen   = arlen_d;
      assign axiSlaveInterface[s].arsize  = arsize_d;
      assign axiSlaveInterface[s].arburst = arburst_d;
      assign axiSlaveInterface[s].arlock  = arlock_d;
      assign axiSlaveInterface[s].arcache = arcache_d;
      assign axiSlaveInterface[s].arprot  = arprot_d;
      assign axiSlaveInterface[s].arqos   = arqos_d;
      assign axiSlaveInterface[s].arvalid = arvalid_d;
      assign axiSlaveInterface[s].rready  = rready_d;
    end
  endgenerate

  // ============================================================================
  // 6. Muxing: Slave to Master (Backward Path)
  //
  // Each master takes each response from exactly one arbitrated slave. The
  // original code looped over every slave with no arbitration, letting the
  // highest index silently overwrite every lower one - which is how a stale
  // slave handed its read data (RID and all) to the master instead of the slave
  // that was actually addressed.
  //
  // Same net-driving scheme as section 5: procedural mux into *_d variables,
  // continuous assign onto the interface nets.
  // ============================================================================
  generate
    for (genvar m = 0; m < AxiGlobalPackage::NO_OF_MASTERS; m++) begin : s2m_routing
      logic                                    awready_d;
      logic                                    wready_d;
      logic [AxiGlobalPackage::ID_WIDTH-1:0]   bid_d;
      logic [1:0]                              bresp_d;
      logic                                    bvalid_d;
      logic                                    arready_d;
      logic [AxiGlobalPackage::ID_WIDTH-1:0]   rid_d;
      logic [AxiGlobalPackage::DATA_WIDTH-1:0] rdata_d;
      logic [1:0]                              rresp_d;
      logic                                    rlast_d;
      logic                                    rvalid_d;

      always_comb begin
        awready_d = 1'b0;
        wready_d  = 1'b0;
        bid_d     = '0;
        bresp_d   = '0;
        bvalid_d  = 1'b0;
        arready_d = 1'b0;
        rid_d     = '0;
        rdata_d   = '0;
        rresp_d   = '0;
        rlast_d   = 1'b0;
        rvalid_d  = 1'b0;

        for (int s = 0; s < TOTAL_SLAVES; s++) begin
          if (wr_state[s] == ADDR_PHASE && wr_owner[s] == m && aw_fwd[s]) begin
            awready_d = slave_awready[s];
          end
          if (wr_state[s] == DATA_PHASE && wr_owner[s] == m && wq_dest[m] == s) begin
            wready_d = slave_wready[s];
          end
          if (b_sel[s] && wr_owner[s] == m) begin
            bid_d    = slave_bid[s];
            bresp_d  = slave_bresp[s];
            bvalid_d = 1'b1;
          end
          if (rd_state[s] == ADDR_PHASE && rd_owner[s] == m && ar_fwd[s]) begin
            arready_d = slave_arready[s];
          end
          if (r_sel[s] && rd_owner[s] == m) begin
            rid_d    = slave_rid[s];
            rdata_d  = slave_rdata[s];
            rresp_d  = slave_rresp[s];
            rlast_d  = slave_rlast[s];
            rvalid_d = 1'b1;
          end
        end
      end

      assign axiMasterInterface[m].awready = awready_d;
      assign axiMasterInterface[m].wready  = wready_d;
      assign axiMasterInterface[m].bid     = bid_d;
      assign axiMasterInterface[m].bresp   = bresp_d;
      assign axiMasterInterface[m].bvalid  = bvalid_d;
      assign axiMasterInterface[m].arready = arready_d;
      assign axiMasterInterface[m].rid     = rid_d;
      assign axiMasterInterface[m].rdata   = rdata_d;
      assign axiMasterInterface[m].rresp   = rresp_d;
      assign axiMasterInterface[m].rlast   = rlast_d;
      assign axiMasterInterface[m].rvalid  = rvalid_d;
    end
  endgenerate
 
  // ============================================================================
  // Routing trace (compile with +define+AXI_IC_DEBUG to enable)
  //
  // Prints every address accepted and every response returned, with the master,
  // the slave, and the ID. One run of this answers "did channel N's request go
  // to the right slave, and did the right data come back" without needing to
  // read it off a waveform.
  // ============================================================================
`ifdef AXI_IC_DEBUG
  bit rd_discard_q[TOTAL_SLAVES];
  bit wr_discard_q[TOTAL_SLAVES];
  always_ff @(posedge aclk) begin
    for (int i = 0; i < TOTAL_SLAVES; i++) begin
      rd_discard_q[i] <= rd_discard[i];
      wr_discard_q[i] <= wr_discard[i];
    end
  end
 
  generate
    for (genvar s = 0; s < TOTAL_SLAVES; s++) begin : ic_trace_slave
      always_ff @(posedge aclk) begin
        if (aresetn) begin
          if (axiSlaveInterface[s].awvalid && slave_awready[s])
            $display("[%0t] IC AW  master=%0d -> slave=%0d addr=0x%08h id=%0d",
                     $time, wr_owner[s], s, axiSlaveInterface[s].awaddr,
                     axiSlaveInterface[s].awid);
          if (axiSlaveInterface[s].arvalid && slave_arready[s])
            $display("[%0t] IC AR  master=%0d -> slave=%0d addr=0x%08h id=%0d",
                     $time, rd_owner[s], s, axiSlaveInterface[s].araddr,
                     axiSlaveInterface[s].arid);
          if (r_sel[s] && slave_rvalid[s] && master_rready[rd_owner[s]])
            $display("[%0t] IC R   slave=%0d -> master=%0d rid=%0d data=0x%08h last=%0b",
                     $time, s, rd_owner[s], slave_rid[s], slave_rdata[s],
                     slave_rlast[s]);
          if (b_sel[s] && slave_bvalid[s] && master_bready[wr_owner[s]])
            $display("[%0t] IC B   slave=%0d -> master=%0d bid=%0d resp=%0d",
                     $time, s, wr_owner[s], slave_bid[s], slave_bresp[s]);
          // A stopped channel's transfer is quarantined, not drained: its
          // data is never forwarded to the master and the interconnect never
          // acknowledges it, so the TB's slave agent sees no phantom beats.
          if (rd_discard[s] && !rd_discard_q[s])
            $display("[%0t] IC STOPPED read slave=%0d (ch id=%0d): data no longer routed",
                     $time, s, rd_id[s]);
          if (wr_discard[s] && !wr_discard_q[s])
            $display("[%0t] IC STOPPED write slave=%0d (ch id=%0d): response no longer routed",
                     $time, s, wr_id[s]);
          if (wr_kill[s])
            $display("[%0t] IC ABORT write slave=%0d (master=%0d) reclaimed on timeout",
                     $time, s, wr_owner[s]);
          if (rd_kill[s])
            $display("[%0t] IC ABORT read  slave=%0d (master=%0d) reclaimed on timeout",
                     $time, s, rd_owner[s]);
        end
      end
    end
  endgenerate
`endif
 
endinterface
