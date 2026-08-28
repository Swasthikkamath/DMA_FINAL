`ifndef BOOT_MASTER_AGENT_BFM 
`define BOOT_MASTER_AGENT_BFM

interface bootMasterAgentBfm(interface bootInterface);
 import uvm_pkg::*;

     `include "uvm_macros.svh"
 
    bootMasterDriverBfm bootMasterDriverBfmHandle(.bootEn(bootInterface.bootEn),.bootAddr(bootInterface.bootAddr),.rst(bootInterface.rst),.clk(bootInterface.clk));
    bootMasterMonitorBfm  bootMasterMonitorBfmHandle(.bootEn(bootInterface.bootEn),.bootAddr(bootInterface.bootAddr),.rst(bootInterface.rst),.clk(bootInterface.clk));

  initial begin 
    uvm_config_db#(virtual bootMasterDriverBfm) :: set(null,"*","bootMasterDriverBfmHandle",bootMasterDriverBfmHandle);
    uvm_config_db#(virtual bootMasterMonitorBfm) :: set(null,"*","bootMasterMonitorBfmHandle",bootMasterMonitorBfmHandle);
  end 

endinterface 


`endif
