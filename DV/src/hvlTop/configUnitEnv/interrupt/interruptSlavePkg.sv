`ifndef INTERRUPTSLAVEPKG_INCLUDED
`define INTERRUPTSLAVEPKG_INCLUDED

package interruptSlavePkg;
  `include "uvm_macros.svh"
  import uvm_pkg :: *;
  import interruptGlobalPkg::*;
  `include "interruptSlaveAgentConfig.sv"
  `include "interruptSlaveTx.sv"
 `include "interruptSlaveSeqItemConverter.sv"
  `include "interruptSlaveSequencer.sv"
  `include "interruptSlaveAgentConfig.sv"
  `include "interruptSlaveDriverProxy.sv"
  `include "interruptSlaveMonitorProxy.sv"
  `include "interruptSlaveAgent.sv"
endpackage 

`endif
