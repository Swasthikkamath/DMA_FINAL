`ifndef TOPENVPKG_INCLUDED
`define TOPENVPKG_INCLUDED

package topEnvPkg;
 `include "uvm_macros.svh"
 import uvm_pkg ::*;
 import peripheralEnvPkg::*;
 import triggerMasterPkg :: *;
 import triggerSlavePkg ::*;
 import axi4_master_pkg :: *;
 import axi4_slave_pkg :: *;
 import apb_master_pkg :: *;
 import axi4_globals_pkg::*;
 import dmaGlobalPkg::*;
 import configUnitEnvPkg ::*;
 import interruptSlavePkg :: *;
 `include "topRal_Reg.sv"
 `include "topRal_Reg_Block.sv"
 `include "topEnvConfig.sv"
 `include "subScoreboard/sharedResource.sv"
 `include"subScoreboard/topApbSubScoreboard.sv"
 `include"subScoreboard/topAxiSubScoreboard.sv"
 `include"subScoreboard/topTriggerSubScoreboard.sv" 
 `include "subScoreboard/topInterruptSubScoreboard.sv"
 `include "topScoreboard.sv"
 `include "topEnvVirtualSequencer.sv"
 `include "topCoverage.sv"
 `include "topEnv.sv"
 
endpackage

`endif 
