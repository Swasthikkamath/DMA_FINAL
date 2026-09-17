`ifndef APB_MASTER_PKG_INCLUDED_
`define APB_MASTER_PKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: apb_apb_master_pkg
//  Includes all the files related to apb apb_master
//--------------------------------------------------------------------------------------------
package apb_master_pkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;
 
  //-------------------------------------------------------
  // Import apb_global_pkg 
  //-------------------------------------------------------
  import apb_global_pkg::*;

  //-------------------------------------------------------
  // Include all other files
  //-------------------------------------------------------
  `include "apbMasterAgentConfig.sv"
  `include "apbMasterTx.sv"
  `include "apbMasterAdapter.sv"
  `include "apbMasterSequencer.sv"
  `include "apbMasterDriverProxy.sv"
  `include "apbMasterMonitorProxy.sv"
  `include "apbMasterCoverage.sv"
  `include "apbMasterAgent.sv"
  
endpackage : apb_master_pkg

`endif

