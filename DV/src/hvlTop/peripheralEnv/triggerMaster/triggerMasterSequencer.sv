`ifndef TRIGGERMASTERSEQUENCER_INCLUDED
`define TRIGGERMASTERSEQUENCER_INCLUDED

//------------------------------------------------------------------------------
// Class: triggerMasterSequencer
// Description:
// This sequencer controls the flow of triggerMasterTx transactions from sequence to driver.
//------------------------------------------------------------------------------

class triggerMasterSequencer extends uvm_sequencer#(triggerMasterTx);

  `uvm_component_utils(triggerMasterSequencer)

  // Constructor
  extern function new(string name = "triggerMasterSequencer",uvm_component parent = null);

endclass


//------------------------------------------------------------------------------
// Function: new
// Description: Constructor of sequencer
//------------------------------------------------------------------------------
function triggerMasterSequencer :: new(string name = "triggerMasterSequencer",
                                       uvm_component parent = null);
  super.new(name,parent);
endfunction 

`endif
