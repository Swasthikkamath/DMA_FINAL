`ifndef TRIGGERMASTERSEQUENCE_INCLUDED
`define TRIGGERMASTERSEQUENCE_INCLUDED

class triggerMasterSequence extends uvm_sequence#(triggerMasterTx);
  `uvm_object_utils(triggerMasterSequence)
  reqTypeEnum reqType;
  extern function new(string name="triggerMasterSequence");
  extern virtual task body();
endclass 

 function triggerMasterSequence :: new(string name ="triggerMasterSequence");
   super.new(name);
 endfunction

task triggerMasterSequence::body();
  super.body();
  req = triggerMasterTx :: type_id :: create("triggerMasterTx");
  req.randomize()with{reqTypeName == reqType;};
  start_item(req);
  finish_item(req);
endtask 

`endif
