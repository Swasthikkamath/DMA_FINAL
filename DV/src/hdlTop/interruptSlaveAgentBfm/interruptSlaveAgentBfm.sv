`ifndef INTERRUPTSLAVEAGENTBFM_INCLUDED_
`define INTERRUPTSLAVEAGENTBFM_INCLUDED_

module interruptSlaveAgentBfm(interruptInterface interruptInterfaceHandle);

   import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  initial begin
    `uvm_info("Interrupt Slave AGent",$sformatf("Interrupt Slave AGent"),UVM_LOW);
  end
  
  interruptSlaveDriverBfm interruptSlaveDriverBfmHandle(.irq(interruptInterfaceHandle.irq),.clk(interruptInterfaceHandle.clk));
   interruptSlaveMonitorBfm interruptSlaveMonitorBfmHandle(.irq(interruptInterfaceHandle.irq),.clk(interruptInterfaceHandle.clk));

    initial begin
    uvm_config_db#(virtual interruptSlaveDriverBfm)::set(null,"*","interruptSlaveDriverBfm",interruptSlaveDriverBfmHandle);
    uvm_config_db#(virtual interruptSlaveMonitorBfm)::set(null,"*","interruptSlaveMonitorBfm",interruptSlaveMonitorBfmHandle);
  end

endmodule : interruptSlaveAgentBfm

`endif

