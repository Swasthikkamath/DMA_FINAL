`ifndef TOPVIRTUALSEQPKG_INCLUDED_
`define TOPVIRTUALSEQPKG_INCLUDED_

package topVirtualSeqPkg;

 `include "uvm_macros.svh"
  import uvm_pkg::*;
  import dmaGlobalPkg::*;
  import axi4_globals_pkg::*;
  import peripheralEnvPkg::*;
  import triggerGlobalPkg::*;
  import configUnitEnvPkg::*;
  import peripheralVirtualSeqPkg::*;
  import configUnitVirtualSeqPkg::*;
  import triggerMasterSequencePkg::*;
  import axi4_slave_seq_pkg:: *; 
  import topEnvPkg::*; 
  import bootGlobalPkg:: *;
  `include "topVirtualBaseSeq.sv"
  `include "dmaPollingVirtualSeq.sv"
  `include "dma1DVirtualSeq.sv"
endpackage : topVirtualSeqPkg

`endif
