`ifndef PERIPHERAL_VIRTUAL_BASE_SEQ_INCLUDED_
`define PERIPHERAL_VIRTUAL_BASE_SEQ_INCLUDED_

//------------------------------------------------------------------------------
// Class: peripheralVirtualBaseSeq
// Description:
// Base virtual sequence for the Peripheral environment.
// It runs on the Peripheral Virtual Sequencer and provides access to all agent-level sequencers.
//------------------------------------------------------------------------------

class peripheralVirtualBaseSeq extends uvm_sequence;
  `uvm_object_utils(peripheralVirtualBaseSeq)
  
  // Declare typed virtual sequencer pointer
  `uvm_declare_p_sequencer(peripheralEnvVirtualSequencer)

  extern function new(string name = "peripheralVirtualBaseSeq");
  
  extern task body();

endclass : peripheralVirtualBaseSeq


//------------------------------------------------------------------------------
// Constructor
//------------------------------------------------------------------------------
function peripheralVirtualBaseSeq::new(string name = "peripheralVirtualBaseSeq");
  super.new(name);
endfunction : new


//------------------------------------------------------------------------------
// Task: body
// Description:
// Ensures that the sequence is running on the correct
// Peripheral Virtual Sequencer.
//------------------------------------------------------------------------------
task peripheralVirtualBaseSeq::body();
 
  // Cast m_sequencer to p_sequencer
  if(!$cast(p_sequencer,m_sequencer))
    `uvm_error(get_full_name(),"Virtual sequencer pointer cast failed for pheripheral ")

endtask : body

`endif
