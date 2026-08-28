`ifndef BOOT_MASTER_TX 
`define BOOT_MASTER_TX

class bootMasterTx extends uvm_sequence_item;
  `uvm_object_utils(bootMasterTx)

  extern function new(string name="bootMasterTx");

  bit bootEn;

  bit[BOOT_ADDRESS_WIDTH-1:0]bootAddr;

endclass

function bootMasterTx :: new(string name="bootMasterTx");
  super.new(name);
endfunction 

`endif
