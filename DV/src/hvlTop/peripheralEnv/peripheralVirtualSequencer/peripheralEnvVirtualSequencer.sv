`ifndef PERIPHERALENVVIRTUALSEQUENCER_INCLUDED
`define PERIPHERALENVVIRTUALSEQUENCER_INCLUDED

//------------------------------------------------------------------------------
// Class: peripheralEnvVirtualSequencer
// Description:
// This Peripheral Virtual Sequencer holds handles of all agent-level
// sequencers within the peripheral environment.
// It enables coordinated stimulus control across multiple protocols.
//------------------------------------------------------------------------------

class peripheralEnvVirtualSequencer extends uvm_sequencer;
  `uvm_component_utils(peripheralEnvVirtualSequencer)

  // AXI master write sequencer handle
  axi4_master_write_sequencer axi4MasterWriteSequencerHandle;

  // AXI master read sequencer handle
  axi4_master_read_sequencer axi4MasterReadSequencerHandle;

  // AXI slave write sequencer handle
  axi4_slave_write_sequencer axi4SlaveWriteSequencerHandle;

  // AXI slave read sequencer handle
  axi4_slave_read_sequencer axi4SlaveReadSequencerHandle;

  // Trigger master sequencer handle
  triggerMasterSequencer triggerMasterSequencerHandle;

  // Trigger slave sequencer handle
  triggerSlaveSequencer triggerSlaveSequencerHandle;
 
  extern function new(string name = "peripheralEnvVirtualSequencer",uvm_component parent=null);
 endclass


//------------------------------------------------------------------------------
// Constructor
//------------------------------------------------------------------------------
function peripheralEnvVirtualSequencer :: new(string name ="peripheralEnvVirtualSequencer",uvm_component parent =null);
  super.new(name,parent);
endfunction 

`endif
