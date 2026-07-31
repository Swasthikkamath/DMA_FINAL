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
 
interface AxiInterconnect(

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
 
logic[NO_OF_MASTERS-1:0]masterWriteReq[TOTAL_SLAVES];

logic[NO_OF_MASTERS-1:0]masterReadReq[TOTAL_SLAVES];

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

  // Returns DEFAULT_SLAVE (== NO_OF_SLAVES) for any address that does not

  // fall inside a real slave's range, instead of -1.

  // ============================================================================

  function automatic logic [$clog2(TOTAL_SLAVES):0] decode_address(logic [ADDR_WIDTH-1:0] addr);

    // Fixed Range for Slave 0: 0 to 4095 (0x000 to 0xFFF)

    if (addr > 32'h0000_0000 && addr <= 32'd 4096) return 0;

    // Default dynamic logic for other slaves

    for (int i = 1; i < NO_OF_SLAVES; i++) begin

      if (addr >= (i * (1 << SLAVE_MEMORY_SIZE)) && addr < ((i+1) * (1 << SLAVE_MEMORY_SIZE)))begin 

        return i;

     end 

    end

    return DEFAULT_SLAVE; // Out of range -> route to the default (decode-error) slave

  endfunction

  function automatic int slaveOwner(int slaveId,int writeRead);

    int masterWithMaxQos=-1;

    int maxQos;

    bit firstMaster;

    if(writeRead==1) begin 

      for(int m=0;m<NO_OF_MASTERS;m++) begin 

        if(master_awvalid[m] && decode_address(master_awaddr[m]) == slaveId) begin 

          masterWriteReq[slaveId][m] = 1;

        end

        else begin 

          masterWriteReq[slaveId][m] = 0;

        end  

      end   

      for(int m=0;m<NO_OF_MASTERS;m++) begin

        if(masterWriteReq[slaveId][m] == 1 && firstMaster==0) begin 

          maxQos = master_awqos[m];

          masterWithMaxQos = m;

          firstMaster=1;

        end 

        else if(masterWriteReq[slaveId][m] == 1) begin

          if(maxQos < master_awqos[m]) begin 

            maxQos = master_awqos[m];

            masterWithMaxQos = m;

          end 

        end 

      end 

      return masterWithMaxQos;

    end 

    else if(writeRead == 0) begin 

      for(int m=0;m<NO_OF_MASTERS;m++) begin

        if(master_arvalid[m] && decode_address(master_araddr[m]) == slaveId) begin

          masterReadReq[slaveId][m] = 1;

        end

        else begin

          masterReadReq[slaveId][m] = 0;

        end

      end

      for(int m=0;m<NO_OF_MASTERS;m++) begin

        if(masterReadReq[slaveId][m] == 1 && firstMaster==0) begin

          maxQos = master_arqos[m];

          masterWithMaxQos = m;

          firstMaster=1;

        end

        else if(masterReadReq[slaveId][m] == 1) begin

          if(maxQos < master_arqos[m]) begin

            maxQos = master_arqos[m];

            masterWithMaxQos = m;

          end

        end

      end

      return masterWithMaxQos;

    end 

  endfunction
 
  // ============================================================================

  // 4. Sticky Arbitration (Write and Read)

  // Extended to TOTAL_SLAVES so slave index DEFAULT_SLAVE gets the same

  // arbitration/state-machine treatment as every real slave.

  // ============================================================================

  typedef enum bit [1:0] {IDLE, ADDR_PHASE, DATA_PHASE} state_t;

  state_t wr_state[TOTAL_SLAVES];

  int wr_owner[TOTAL_SLAVES];

  int wr_last_served[TOTAL_SLAVES];
 
  state_t rd_state[TOTAL_SLAVES];

  int rd_owner[TOTAL_SLAVES];

  int rd_last_served[TOTAL_SLAVES];
 
  generate

    for (genvar s = 0; s < TOTAL_SLAVES; s++) begin : arbitration_logic

      // --- Write Channel State Machine ---

      always_ff @(posedge aclk or negedge aresetn) begin

        if (!aresetn) begin

          wr_state[s] <= IDLE;

          wr_owner[s] <= 'b x;

          wr_last_served[s] <= 'bx ;

        end else begin

          case (wr_state[s])

            IDLE: begin

              // Look for highest QoS master targeting this slave

              int best_m ;

              logic [QOS_WIDTH-1:0] max_qos;
 
              best_m =-1;

              max_qos =0;

              best_m = slaveOwner(s,1);

              if (best_m != -1) begin

                wr_owner[s] <= best_m;

                wr_state[s] <= ADDR_PHASE;

              end

            end

            ADDR_PHASE: begin

              if (master_awvalid[wr_owner[s]] && slave_awready[s]) 

                wr_state[s] <= DATA_PHASE;

            end

            DATA_PHASE: begin

              if (slave_bvalid[s] && master_bready[wr_owner[s]]) begin

                wr_last_served[s] <= wr_owner[s];

                wr_state[s] <= IDLE;

              end

            end

          endcase

        end

      end
 
      // --- Read Channel State Machine ---

      always_ff @(posedge aclk or negedge aresetn) begin

        if (!aresetn) begin

          rd_state[s] <= IDLE;

          rd_owner[s] <= 0;

          rd_last_served[s] <= 0;

        end else begin

          case (rd_state[s])

            IDLE: begin

              int best_m ;

              logic [QOS_WIDTH-1:0] max_qos;
 
              best_m =-1;

              max_qos =0;

              best_m = slaveOwner(s,0);

              if (best_m != -1) begin

                rd_owner[s] <= best_m;

                rd_state[s] <= ADDR_PHASE;

              end

            end

            ADDR_PHASE: begin

              if (master_arvalid[rd_owner[s]] && slave_arready[s])

                rd_state[s] <= DATA_PHASE;

            end

            DATA_PHASE: begin

              if (slave_rvalid[s] && slave_rlast[s] && master_rready[rd_owner[s]]) begin

                rd_last_served[s] <= rd_owner[s];

                rd_state[s] <= IDLE;

              end

            end

          endcase

        end

      end

    end

  endgenerate
 
  // ============================================================================

  // 5. Muxing: Master to Slave (Forward Path)

  // Loop now covers TOTAL_SLAVES; axiSlaveInterface[DEFAULT_SLAVE] is the

  // reserved port that a default/decode-error slave should be bound to at

  // instantiation time.

  // ============================================================================

  generate

    for (genvar s = 0; s < TOTAL_SLAVES; s++) begin : m2s_routing

      always_comb begin

        // Default (Idle)

        axiSlaveInterface[s].awvalid = 1'b0;

        axiSlaveInterface[s].wvalid  = 1'b0;

        axiSlaveInterface[s].arvalid = 1'b0;
 
        // Write Routing

        if (wr_state[s] != IDLE) begin

          axiSlaveInterface[s].awid    = master_awid[wr_owner[s]];

          axiSlaveInterface[s].awaddr  = master_awaddr[wr_owner[s]];

          axiSlaveInterface[s].awlen   = master_awlen[wr_owner[s]];

          axiSlaveInterface[s].awsize  = master_awsize[wr_owner[s]];

          axiSlaveInterface[s].awburst = master_awburst[wr_owner[s]];

          axiSlaveInterface[s].awlock  = master_awlock[wr_owner[s]];

          axiSlaveInterface[s].awcache = master_awcache[wr_owner[s]];

          axiSlaveInterface[s].awprot  = master_awprot[wr_owner[s]];

          axiSlaveInterface[s].awqos   = master_awqos[wr_owner[s]];

          axiSlaveInterface[s].awvalid = (wr_state[s] == ADDR_PHASE) && master_awvalid[wr_owner[s]];

          axiSlaveInterface[s].wdata   = master_wdata[wr_owner[s]];

          axiSlaveInterface[s].wstrb   = master_wstrb[wr_owner[s]];

          axiSlaveInterface[s].wlast   = master_wlast[wr_owner[s]];

          axiSlaveInterface[s].wvalid  = master_wvalid[wr_owner[s]];

          axiSlaveInterface[s].bready  = master_bready[wr_owner[s]];

        end
 
        // Read Routing

        if (rd_state[s] != IDLE) begin 

          axiSlaveInterface[s].arid    = master_arid[rd_owner[s]];

          axiSlaveInterface[s].araddr  = master_araddr[rd_owner[s]];

          axiSlaveInterface[s].arlen   = master_arlen[rd_owner[s]];

          axiSlaveInterface[s].arsize  = master_arsize[rd_owner[s]];

          axiSlaveInterface[s].arburst = master_arburst[rd_owner[s]];

          axiSlaveInterface[s].arlock  = master_arlock[rd_owner[s]];

          axiSlaveInterface[s].arcache = master_arcache[rd_owner[s]];

          axiSlaveInterface[s].arprot  = master_arprot[rd_owner[s]];

          axiSlaveInterface[s].arqos   = master_arqos[rd_owner[s]];

          axiSlaveInterface[s].arvalid = (rd_state[s] == ADDR_PHASE) && master_arvalid[rd_owner[s]];

          axiSlaveInterface[s].rready  = master_rready[rd_owner[s]];

        end

      end

    end

  endgenerate
 
  // ============================================================================

  // 6. Muxing: Slave to Master (Backward Path)

  // Inner loop now scans TOTAL_SLAVES so a response coming back from the

  // default slave is also routed to whichever master issued the out-of-range

  // transaction.

  // ============================================================================

  generate

    for (genvar m = 0; m < NO_OF_MASTERS; m++) begin : s2m_routing

      always_comb begin

        axiMasterInterface[m].awready = 1'b0;

        axiMasterInterface[m].wready  = 1'b0;

        axiMasterInterface[m].bvalid  = 1'b0;

        axiMasterInterface[m].arready = 1'b0;

        axiMasterInterface[m].rvalid  = 1'b0;
 
        for (int s = 0; s < TOTAL_SLAVES; s++) begin

          // Write Handshakes

          // Each signal is only forwarded during the exact phase it is

          // architecturally valid in, not merely whenever wr_state[s]!=IDLE.

          // This stops a stale/previous-owner's wready/bvalid/bid/bresp on

          // this slave port from leaking into the new owner during ADDR_PHASE.

          if (wr_owner[s] == m) begin

            if (wr_state[s] == ADDR_PHASE) begin

              axiMasterInterface[m].awready = slave_awready[s];

            end

            if (wr_state[s] == DATA_PHASE) begin

              axiMasterInterface[m].wready  = slave_wready[s];

              axiMasterInterface[m].bid     = slave_bid[s];

              axiMasterInterface[m].bresp   = slave_bresp[s];

              axiMasterInterface[m].bvalid  = slave_bvalid[s];

            end

          end

          // Read Handshakes

          if (rd_owner[s] == m) begin

            if (rd_state[s] == ADDR_PHASE) begin

              axiMasterInterface[m].arready = slave_arready[s];

            end

            if (rd_state[s] == DATA_PHASE) begin

              axiMasterInterface[m].rid     = slave_rid[s];

              axiMasterInterface[m].rdata   = slave_rdata[s];

              axiMasterInterface[m].rresp   = slave_rresp[s];

              axiMasterInterface[m].rlast   = slave_rlast[s];

              axiMasterInterface[m].rvalid  = slave_rvalid[s];

            end

          end

        end

      end

    end

  endgenerate
 
endinterface
 
