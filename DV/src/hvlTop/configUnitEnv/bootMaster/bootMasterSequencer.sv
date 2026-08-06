

class bootMasterSequencer extends uvm_sequencer#(bootMastertx);
  │`uvm_component_utils(bootMasterSequencer)

  extern function new(string name ="bootMasterSequencer",uvm_component parent=null);
endclass

function bootMasterSequencer :: new(string name="bootMasterSequencer",uvm_component parent=null);
  super.new(name,parent);
endfunction 







