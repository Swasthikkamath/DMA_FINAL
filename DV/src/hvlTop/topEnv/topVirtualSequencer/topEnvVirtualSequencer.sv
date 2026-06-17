`ifndef TOPENVVIRTUALSEQUENCER_INCLUDED
`define TOPENVVIRTUALSEQUENCER_INCLUDED

class topEnvVirtualSequencer extends uvm_sequencer;
  `uvm_component_utils(topEnvVirtualSequencer)

   peripheralEnvVirtualSequencer peripheralEnvVirtualSequencerHandle[];
   configUnitEnvVirtualSequencer configUnitEnvVirtualSequencerHandle;
   //dmaControllerEnvVirtualSequencer dmaControllerEnvVirtualSequencerHandle;

   extern function new(string name ="topEnvVirtualSequencer",uvm_component parent = null);
endclass 

function topEnvVirtualSequencer :: new(string name = "topEnvVirtualSequencer",uvm_component parent=null);
  super.new(name,parent);
endfunction 

`endif

