`ifndef INTERRUPTMASTERAGENTBFM_INCLUDED_
`define INTERRUPTMASTERAGENTBFM_INCLUDED_

module interruptMasterAgentBfm(interruptInterface interruptInterfaceHandle);

   import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  initial begin
    `uvm_info("Interrupt Master AGent",$sformatf("Interrupt Master AGent"),UVM_LOW);
  end
  
  interruptMasterDriverBfm interruptMasterDriverBfmHandle();
  
  interruptMasterMonitorBfm interruptMasterMonitorBfmHandle();


    initial begin
    uvm_config_db#(virtual interruptMasterDriverBfm)::set(null,"*","interruptMasterDriverBfm",interruptMasterDriverBfmHandle);
    uvm_config_db#(virtual interruptMasterMonitorBfm)::set(null,"*","interruptMasterMonitorBfm",interruptMasterMonitorBfmHandle);
  end

endmodule : interruptMasterAgentBfm

`endif


