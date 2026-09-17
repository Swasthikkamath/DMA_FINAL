`ifndef BOOT_MASTER_PKG
`define BOOT_MASTER_PKG

package bootMasterPkg;
   `include "uvm_macros.svh"
   import uvm_pkg::*;
   import bootGlobalPkg :: *;

   `include "bootMasterTx.sv"
   `include"bootMasterAgentConfig.sv"
   `include"bootMasterDriverProxy.sv"
   `include"bootMasterMonitorProxy.sv"
   `include"bootMasterSequencer.sv"
   `include"bootMasterAgent.sv"

endpackage
`endif 
