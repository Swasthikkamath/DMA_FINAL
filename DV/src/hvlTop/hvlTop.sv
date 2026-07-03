`ifndef HVLTOP_INCLUDED_
`define HVLTOP_INCLUDED_

//--------------------------------------------------------------------------------------------
// Module : HvlTop
//  Starts the testbench components
//--------------------------------------------------------------------------------------------
module HvlTop;

  //-------------------------------------------------------
  // Importing UVM Package and test Package
  //-------------------------------------------------------
  import uvm_pkg::*;
  import dmaTestPkg::*;
  
  //-------------------------------------------------------
  // Calling run_test for simulation
  //-------------------------------------------------------
  initial begin
    run_test("dmaBaseTest");
  end

  

endmodule : HvlTop

`endif
