`ifndef INTERRUPTSLAVESEQUENCER_INCLUDED 
`define INTERRUPTSLAVESEQUENCER_INCLUDED
//------------------------------------------------------------------------------
// Class: interruptSlaveSequencer
// Description:
//   Sequencer for interrupt slave agent.
//   Responsible for controlling the flow of interrupt transactions
//   from sequences to the driver.
//------------------------------------------------------------------------------
class interruptSlaveSequencer extends uvm_sequencer #(interruptSlaveTx);
   //Factory Registration
  `uvm_component_utils(interruptSlaveSequencer)
  extern function new(string name="interruptSlaveSequencer",uvm_component parent = null);
endclass 

//Constructor
function interruptSlaveSequencer :: new(string name="interruptSlaveSequencer",uvm_component parent = null);
  super.new(name,parent);
endfunction
`endif
