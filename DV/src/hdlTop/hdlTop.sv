`ifndef HDLTOP_INCLUDED
`define HDLTOP_INCLUDED
`timescale 1ns/1ps
module hdlTop;
  import uvm_pkg::*;
  import axi4_globals_pkg::*;
  import dmaGlobalPkg::*;
  import apb_global_pkg::*;

  bit pclk;
  bit preset_n;
  
  wire logic[axi4_globals_pkg::NO_OF_SLAVES-1:0]trigInReq;
  wire logic[axi4_globals_pkg::NO_OF_SLAVES-1:0]trigInAck;
  wire logic[axi4_globals_pkg::NO_OF_SLAVES-1:0]trigOutReq;
  wire logic[axi4_globals_pkg::NO_OF_SLAVES-1:0]trigOutAck;

  wire logic[(2*(axi4_globals_pkg::NO_OF_SLAVES))-1:0] trigInReqType;
  wire logic[(2*(axi4_globals_pkg::NO_OF_SLAVES))-1:0] trigInAckType;

  
  initial begin
    pclk = 1'b0;
    forever #10 pclk = ~pclk;
  end
  initial begin
    preset_n = 1'b1;
    #15 preset_n = 1'b0;
 
    repeat(1) begin
      @(posedge pclk);
    end
    preset_n = 1'b1;
  end
  apb_if  apbInterfaceHandle(pclk,preset_n);
  axi4_if  axi4InterfaceHandle[(axi4_globals_pkg::NO_OF_SLAVES)+2](pclk,preset_n);

  interruptInterface  interruptInterfaceHandle(pclk);
  triggerInterface triggerInterfaceHandle[axi4_globals_pkg::NO_OF_SLAVES](pclk);
  top_mod#(.DATA_W(32)) u_dma (
    // APB
    .clk(pclk),
    .resetn(preset_n),
    .PSEL(apbInterfaceHandle.psel),
    .PENABLE(apbInterfaceHandle.penable),
    .PWRITE(apbInterfaceHandle.pwrite),
    .PADDR(apbInterfaceHandle.paddr),
    .PWDATA(apbInterfaceHandle.pwdata),
    .PRDATA(apbInterfaceHandle.prdata),
    .PREADY(apbInterfaceHandle.pready),
    .PSLVERR(apbInterfaceHandle.pslverr),
    .PSTRB(apbInterfaceHandle.pstrb),
    // AXI
    .AWID_D(axi4InterfaceHandle[4].awid),
    .AWLEN_D(axi4InterfaceHandle[4].awlen),
    .AWSIZE_D(axi4InterfaceHandle[4].awsize),
    .AWBURST_D(axi4InterfaceHandle[4].awburst),
    .AWVALID_D(axi4InterfaceHandle[4].awvalid),
    .AWQOS(axi4InterfaceHandle[4].awqos),
    .AWADDR_D(axi4InterfaceHandle[4].awaddr),
    .AWREADY(axi4InterfaceHandle[4].awready),
    .WVALID_D(axi4InterfaceHandle[4].wvalid),
    .WDATA_D(axi4InterfaceHandle[4].wdata),
    .WREADY(axi4InterfaceHandle[4].wready),
    .WSTRB(axi4InterfaceHandle[4].wstrb),
    .WLAST_D(axi4InterfaceHandle[4].wlast),
    .BID(axi4InterfaceHandle[4].bid),
    .BRESP(axi4InterfaceHandle[4].bresp),
    .BVALID(axi4InterfaceHandle[4].bvalid),
    .BREADY_D(axi4InterfaceHandle[4].bready),
    .ARID(axi4InterfaceHandle[4].arid),
    .ARLEN(axi4InterfaceHandle[4].arlen),
    .ARSIZE(axi4InterfaceHandle[4].arsize),
    .ARBURST(axi4InterfaceHandle[4].arburst),   //driven 0 when loading next command
    .ARQOS(axi4InterfaceHandle[4].arqos), 
    .ARVALID(axi4InterfaceHandle[4].arvalid),
    .ARADDR(axi4InterfaceHandle[4].araddr),
    .ARREADY(axi4InterfaceHandle[4].arready),
    .RID(axi4InterfaceHandle[4].rid),
    .RRESP(axi4InterfaceHandle[4].rresp),    
    .RVALID(axi4InterfaceHandle[4].rvalid),    
    .RDATA_I(axi4InterfaceHandle[4].rdata),
    .RREADY(axi4InterfaceHandle[4].rready),
    .RLAST(axi4InterfaceHandle[4].rlast),
    // Interrupt
    .IRQ(interruptInterfaceHandle.irq),
    .boot_en(0),
    // Trigger
    .trig_req(trigInReq),
    .trig_req_type(trigInReqType),
    .trig_ack(trigInAck),
    .trig_ack_type(trigInAckType),
    .trig_out_req(trigOutReq),
    .trig_out_ack(trigOutAck)
  );
  AxiInterconnect inter(pclk,present_n,axi4InterfaceHandle[4:5],axi4InterfaceHandle[0:3]);
  generate
    for(genvar i=0;i<axi4_globals_pkg::NO_OF_SLAVES;i++) begin 
      axi4_master_agent_bfm #(i) axi4MasterAgentBfm(axi4InterfaceHandle[i]);
      axi4_slave_agent_bfm #(i) axi4SlaveAgentBfm(axi4InterfaceHandle[i]);
      triggerMasterAgentBfm #(i) triggerMasterAgentBfm(triggerInterfaceHandle[i]);
      triggerSlaveAgentBfm #(i) triggerSlaveAgentBfm(triggerInterfaceHandle[i]);
    end

  endgenerate
 
  generate
   for(genvar i=0;i<axi4_globals_pkg::NO_OF_SLAVES;i++) begin
    // always_comb begin 
     assign trigInReq[i] = triggerInterfaceHandle[i].trigInReq; // now we will use the vector for connection
     assign trigInReqType[(2*i) +:2] = triggerInterfaceHandle[i].reqType;
     assign triggerInterfaceHandle[i].trigInAck = trigInAck[i];
     assign trigInAckType[(2*i) +:2] = triggerInterfaceHandle[i].ackType;
      
     assign triggerInterfaceHandle[i].trigOutReq = trigOutReq[i];
     assign trigOutAck[i] = triggerInterfaceHandle[i].trigOutAck;
  //  end
   end 
  endgenerate
 
  apb_master_agent_bfm apbMasterAgentBfm(apbInterfaceHandle);
  interruptSlaveAgentBfm interruptSlaveAgentBfmHandle(interruptInterfaceHandle);
  interruptMasterAgentBfm interruptMasterAgentBfmHandle(interruptInterfaceHandle);

  initial begin
        $dumpfile("simulation_output.vcd"); // Name of the VCD file
        $dumpvars(0, u_dma);       // Dumps all signals in the module
  end

endmodule 
`endif

