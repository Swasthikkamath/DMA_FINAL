`ifndef TRIGGERSLAVEDRIVERPROXY_INCLUDED
`define TRIGGERSLAVEDRIVERPROXY_INCLUDED

class triggerSlaveDriverProxy extends uvm_driver#(triggerSlaveTx);
  `uvm_component_utils(triggerSlaveDriverProxy)

  virtual triggerInterface vif;
  triggerSlaveAgentConfig triggerSlaveAgentConfigHandle;

  extern function new(string name = "triggerSlaveDriverProxy",uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task respondToReq(triggerSlaveTx req);

endclass

function triggerSlaveDriverProxy ::new(string name = "triggerSlaveDriverProxy",uvm_component parent = null);
  super.new(name,parent);
endfunction

function void triggerSlaveDriverProxy ::build_phase(uvm_phase phase);
  super.build_phase(phase);
  vif = triggerSlaveAgentConfigHandle.vif;
endfunction

task triggerSlaveDriverProxy::respondToReq(triggerSlaveTx req);
  do begin
    @(vif.slaveDrvCb);
  end while(vif.slaveDrvCb.trigInReq != 1);
  vif.slaveDrvCb.trigInAck <= 1'b1;
  vif.slaveDrvCb.ackType   <= req.ackType;
  req.trigInReq = vif.slaveDrvCb.trigInReq;
  req.reqType   = reqTypeEnum'(vif.slaveDrvCb.reqType);
endtask

task triggerSlaveDriverProxy :: run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name(),$sformatf("TriggerSlave-TX\n %s",req.sprint),UVM_DEBUG);
    respondToReq(req);
    `uvm_info(get_type_name(),$sformatf("AFTER :: received req packet in Trigger Slave Driver \n %s",req.sprint()),UVM_DEBUG);
    seq_item_port.item_done();
  end
endtask

`endif
