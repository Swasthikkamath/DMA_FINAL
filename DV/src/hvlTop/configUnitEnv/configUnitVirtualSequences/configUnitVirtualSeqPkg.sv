

`ifndef CONFIGUNIT_VIRTUAL_SEQ_PKG_INCLUDED_
`define CONFIGUNIT_VIRTUAL_SEQ_PKG_INCLUDED_

package configUnitVirtualSeqPkg;

  //-------------------------------------------------------
  // Importing UVM Pkg
  //-------------------------------------------------------
  
   `include "uvm_macros.svh"
	  import uvm_pkg::*;
	  import apb_global_pkg::*;
	  import interruptGlobalPkg::*;
	  import apb_master_pkg::*;
	//import topEnvPkg::*;
	  import configUnitEnvPkg::*;
	  import interruptSlavePkg::*;
	
//  import configunit_seq_pkg::*;
    `include "interrupt_slave_seq.sv"

    `include "configUnitVirtualBaseSeq.sv"

`include "configUnitInterruptSlaveOnlyVirtualSequence.sv"
endpackage : configUnitVirtualSeqPkg

`endif

