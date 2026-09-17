`ifndef HDLTOP_INCLUDED
`define HDLTOP_INCLUDED
`timescale 1ns/1ps
module hdlTop;
  import uvm_pkg::*;
  import axi4_globals_pkg::*;
  import dmaGlobalPkg::*;
//  import apb_global_pkg::*;

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
  axi4_if  axi4InterfaceHandle[(axi4_globals_pkg::NO_OF_SLAVES)+3](pclk,preset_n);  //2 master dma + (NO_OF_SLAVES +1 )

  interruptInterface  interruptInterfaceHandle(pclk);
  triggerInterface triggerInterfaceHandle[axi4_globals_pkg::NO_OF_SLAVES+1](pclk);
  bootInterface bootInterfaceHandle(pclk,preset_n);

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
    .AWID_D(axi4InterfaceHandle[NO_OF_SLAVES+1].awid),
    .AWLEN_D(axi4InterfaceHandle[NO_OF_SLAVES+1].awlen),
    .AWSIZE_D(axi4InterfaceHandle[NO_OF_SLAVES+1].awsize),
    .AWBURST_D(axi4InterfaceHandle[NO_OF_SLAVES+1].awburst),
    .AWVALID_D(axi4InterfaceHandle[NO_OF_SLAVES+1].awvalid),
    .AWQOS(axi4InterfaceHandle[NO_OF_SLAVES+1].awqos),
    .AWADDR_D(axi4InterfaceHandle[NO_OF_SLAVES+1].awaddr),
    .AWREADY(axi4InterfaceHandle[NO_OF_SLAVES+1].awready),
    .WVALID_D(axi4InterfaceHandle[NO_OF_SLAVES+1].wvalid),
    .WDATA_D(axi4InterfaceHandle[NO_OF_SLAVES+1].wdata),
    .WREADY(axi4InterfaceHandle[NO_OF_SLAVES+1].wready),
    .WSTRB(axi4InterfaceHandle[NO_OF_SLAVES+1].wstrb),
    .WLAST_D(axi4InterfaceHandle[NO_OF_SLAVES+1].wlast),
    .BID(axi4InterfaceHandle[NO_OF_SLAVES+1].bid),
    .BRESP(axi4InterfaceHandle[NO_OF_SLAVES+1].bresp),
    .BVALID(axi4InterfaceHandle[NO_OF_SLAVES+1].bvalid),
    .BREADY_D(axi4InterfaceHandle[NO_OF_SLAVES+1].bready),
    .ARID(axi4InterfaceHandle[NO_OF_SLAVES+1].arid),
    .ARLEN(axi4InterfaceHandle[NO_OF_SLAVES+1].arlen),
    .ARSIZE(axi4InterfaceHandle[NO_OF_SLAVES+1].arsize),
    .ARBURST(axi4InterfaceHandle[NO_OF_SLAVES+1].arburst),   //driven 0 when loading next command
    .ARQOS(axi4InterfaceHandle[NO_OF_SLAVES+1].arqos), 
    .ARVALID(axi4InterfaceHandle[NO_OF_SLAVES+1].arvalid),
    .ARADDR(axi4InterfaceHandle[NO_OF_SLAVES+1].araddr),
    .ARREADY(axi4InterfaceHandle[NO_OF_SLAVES+1].arready),
    .RID(axi4InterfaceHandle[NO_OF_SLAVES+1].rid),
    .RRESP(axi4InterfaceHandle[NO_OF_SLAVES+1].rresp),    
    .RVALID(axi4InterfaceHandle[NO_OF_SLAVES+1].rvalid),    
    .RDATA_I(axi4InterfaceHandle[NO_OF_SLAVES+1].rdata),
    .RREADY(axi4InterfaceHandle[NO_OF_SLAVES+1].rready),
    .RLAST(axi4InterfaceHandle[NO_OF_SLAVES+1].rlast),
    // Interrupt
    .IRQ(interruptInterfaceHandle.irq),
    .boot_en(bootInterfaceHandle.bootEn),
    .boot_addr(bootInterfaceHandle.bootAddr),
    // Trigger
    .trig_req(trigInReq),
    .trig_req_type(trigInReqType),
    .trig_ack(trigInAck),
    .trig_ack_type(trigInAckType),
    .trig_out_req(trigOutReq),
    .trig_out_ack(trigOutAck)
  );
  AxiInterconnect inter(pclk,preset_n,axi4InterfaceHandle[(NO_OF_SLAVES+1):(NO_OF_SLAVES+2)],axi4InterfaceHandle[0:(NO_OF_SLAVES)]);
  generate
    for(genvar i=0;i<(axi4_globals_pkg::NO_OF_SLAVES +1);i++) begin
      initial begin
        uvm_config_db#(virtual axi4_if)::set(null, "*", $sformatf("axi4_if[%0d]", i), axi4InterfaceHandle[i]);
        uvm_config_db#(virtual triggerInterface)::set(null, "*", $sformatf("triggerInterface[%0d]", i), triggerInterfaceHandle[i]);
      end
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

  initial begin
    uvm_config_db#(virtual apb_if)::set(null, "*", "apb_if", apbInterfaceHandle);
    uvm_config_db#(virtual interruptInterface)::set(null, "*", "interruptInterface", interruptInterfaceHandle);
    uvm_config_db#(virtual bootInterface)::set(null, "*", "bootInterface", bootInterfaceHandle);
  end

initial begin
  $dumpfile("simulation_output.vcd");
  $dumpvars(0, u_dma);
  $dumpvars(0, apbInterfaceHandle);
  $dumpvars(0, interruptInterfaceHandle);

end
  genvar gi, gj;

    generate
          for (gi = 0; gi < axi4_globals_pkg::NO_OF_SLAVES + 3; gi = gi + 1) begin : dump_axi4
            initial begin $dumpfile("simulation_output.vcd"); $dumpvars(0, axi4InterfaceHandle[gi]);
              end     
            end
        endgenerate

          generate
                for (gj = 0; gj < axi4_globals_pkg::NO_OF_SLAVES + 1; gj = gj + 1) begin : dump_trigger
                  initial begin $dumpfile("simulation_output.vcd");$dumpvars(0, triggerInterfaceHandle[gj]);
                    end     
                  end
              endgenerate
endmodule 
`endif

