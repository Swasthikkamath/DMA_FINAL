`ifndef PERIPHERAL_VIRTUAL_SEQ_PKG_INCLUDED_
`define PERIPHERAL_VIRTUAL_SEQ_PKG_INCLUDED_


//------------------------------------------------------------------------------
// Package: peripheralVirtualSeqPkg
// Description:
// This package contains all Peripheral Virtual Sequences.
// It imports required protocol, environment, and sequence packages
// needed to run virtual sequences in the peripheral environment.
//------------------------------------------------------------------------------


package peripheralVirtualSeqPkg;

  //-------------------------------------------------------
  // Importing UVM Pkg
  //-------------------------------------------------------
  
 `include "uvm_macros.svh"
  import uvm_pkg::*;
  import axi4_globals_pkg::*;
  import triggerGlobalPkg::*;

  import axi4_master_pkg::*;
  import axi4_slave_pkg::*;
  import triggerMasterPkg::*;
  import triggerSlavePkg::*;
  import axi4_slave_seq_pkg:: *;

  import peripheralEnvPkg::*;  
  import triggerMasterSequencePkg :: *; 

  `include "peripheralBaseVirtualSequence.sv"
  `include "peripheralAxiSlaveOnlyVirtualSequence.sv"
  `include "peripheralTriggerMasterOnlyVirtualSequence.sv"
  
endpackage : peripheralVirtualSeqPkg

`endif


