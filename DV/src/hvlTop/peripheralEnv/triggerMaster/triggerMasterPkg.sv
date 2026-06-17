`ifndef TRIGGERMASTERPKG_INCLUDED
`define TRIGGERMASTERPKG_INCLUDED

//------------------------------------------------------------------------------
// Package: triggerMasterPkg
// Description:
// This package contains all files related to Trigger Master Agent.
// It imports required packages and includes all Trigger Master components.
//------------------------------------------------------------------------------

package triggerMasterPkg;

  `include "uvm_macros.svh"
  import uvm_pkg ::*;

  import triggerGlobalPkg::*;
  import apb_global_pkg ::*;
    
  `include "triggerMasterTx.sv"
  `include "triggerMasterSeqItemConverter.sv"
  `include "triggerMasterSequencer.sv"
  `include "triggerMasterAgentConfig.sv"
  `include "triggerMasterDriverProxy.sv"
  `include "triggerMasterMonitorProxy.sv"
  `include "triggerMasterAgent.sv"  
  
endpackage

`endif
