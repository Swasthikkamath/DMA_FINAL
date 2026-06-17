`ifndef TRIGGERSLAVESEQUENCER_INCLUDED
`define TRIGGERSLAVESEQUENCER_INCLUDED

//------------------------------------------------------------------------------
// Class: triggerSlaveSequencer
// Description:
// This sequencer controls the flow of triggerSlaveTx transactions from sequence to slave driver.
//------------------------------------------------------------------------------

class triggerSlaveSequencer extends uvm_sequencer#(triggerSlaveTx);

  `uvm_component_utils(triggerSlaveSequencer)

  // Constructor
  extern function new(string name = "triggerSlaveSequencer", uvm_component parent = null);

endclass


//------------------------------------------------------------------------------
// Function: new
// Description: Constructor of slave sequencer
//------------------------------------------------------------------------------
function triggerSlaveSequencer::new(string name = "triggerSlaveSequencer", uvm_component parent = null);
  super.new(name,parent);
endfunction 

`endif
