`ifndef TRIGGERSLAVEPKG_INCLUDED
`define TRIGGERSLAVEPKG_INCLUDED

//------------------------------------------------------------------------------
// Package: triggerSlavePkg
// Description:
// This package contains all files related to Trigger Slave Agent.
// It imports required packages and includes all Trigger Slave components.
//------------------------------------------------------------------------------

package triggerSlavePkg;
  `include "uvm_macros.svh"
  import uvm_pkg ::*;  
  import triggerGlobalPkg::*;
    
  `include "triggerSlaveTx.sv"
  `include "triggerSlaveSequencer.sv"
  `include "triggerSlaveAgentConfig.sv"
  `include  "triggerSlaveDriverProxy.sv"
  `include "triggerSlaveMonitorProxy.sv"
  `include "triggerSlaveAgent.sv"
endpackage

`endif 
