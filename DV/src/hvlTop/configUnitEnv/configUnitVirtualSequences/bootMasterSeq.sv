`ifndef BOOT_MASTER_SEQ
`define BOOT_MASTER_SEQ

class bootMasterSeq extends uvm_sequence#(bootMasterTx);
  `uvm_object_utils(bootMasterSeq)

  bit[BOOT_ADDRESS_WIDTH-1:0]bootAddress;
  extern function new(string name = "bootMasterSeq");

  extern virtual task body();
endclass


function bootMasterSeq :: new(string name = "bootMasterSeq");
  super.new(name);
endfunction

task bootMasterSeq :: body();
  req = bootMasterTx :: type_id ::create("bootMasterTx");
  //    req.randomize()with{bootEn==1;bootAddr == bootAddress;};
  req.bootEn=1;
  req.bootAddr = bootAddress;
  start_item(req);
  //    req.randomize()with{bootEn==1;bootAddr == bootAddress;};
  finish_item(req);
endtask

`endif
