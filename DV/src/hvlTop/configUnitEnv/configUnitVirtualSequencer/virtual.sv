
////configUnit virtual sequencer(inside configUnit env)
class configUnitVirtualSequencer extends uvm_sequencer;
	`uvm_component_utils(configUnitVirtualSequencer)

	// Handles to real sequencers
	configUnitMasterSequencer master_sqr;
	configUnitSlaveSequencer  slave_sqr;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
endclass


