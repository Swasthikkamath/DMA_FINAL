`ifndef CONFIGUNITENVVIRTUALSEQUENCER_INCLUDED
`define CONFIGUNITENVVIRTUALSEQUENCER_INCLUDED

class configUnitEnvVirtualSequencer extends uvm_sequencer;

  `uvm_component_utils(configUnitEnvVirtualSequencer)

  apb_master_sequencer apbMasterSequencerHandle;
  interruptSlaveSequencer interruptSlaveSequencerHandle;

   extern function new(string name = "configUnitEnvVirtualSequencer",uvm_component parent = null);
endclass

function configUnitEnvVirtualSequencer :: new(string name = "configUnitEnvVirtualSequencer",uvm_component parent = null);
  super.new(name,parent);
endfunction 

`endif

