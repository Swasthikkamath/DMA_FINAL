`ifndef PERIPHERALENVPKG_INCLUDED
`define PERIPHERALENVPKG_INCLUDED

//------------------------------------------------------------------------------
// Package: peripheralEnvPkg
// Description:
// This package contains peripheral environment related files.
// It imports required agent packages and includes env components.
//------------------------------------------------------------------------------

package peripheralEnvPkg;

`include "uvm_macros.svh"
import uvm_pkg :: *;

import triggerMasterPkg :: *;
import triggerSlavePkg ::*;
import axi4_master_pkg :: *;
import axi4_slave_pkg :: *;


`include "peripheralEnvConfig.sv"
`include "peripheralEnvVirtualSequencer.sv"
`include "peripheralEnv.sv"
endpackage 






`endif 
