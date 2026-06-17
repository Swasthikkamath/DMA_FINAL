`ifndef TRIGGERMASTERSEQUENCEPKG_INCLUDED
`define TRIGGERMASTERSEQUENCEPKG_INCLUDED

package triggerMasterSequencePkg;
  import uvm_pkg :: *;
  `include "uvm_macros.svh"
  import triggerGlobalPkg::*;
  import triggerMasterPkg :: *;
  `include "triggerMasterSequence.sv"
endpackage 

`endif
