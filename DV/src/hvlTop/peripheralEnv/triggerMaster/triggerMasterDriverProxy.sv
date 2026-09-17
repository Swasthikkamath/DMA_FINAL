`ifndef TRIGGERMASTERDRIVERPROXY_INCLUDED
`define TRIGGERMASTERDRIVERPROXY_INCLUDED

class triggerMasterDriverProxy extends uvm_driver#(triggerMasterTx);
  `uvm_component_utils(triggerMasterDriverProxy)

  virtual triggerInterface vif;
  triggerMasterAgentConfig triggerMasterAgentConfigHandle;

  extern function new(string name = "triggerMasterDriverProxy",uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task driveTrigIn(triggerMasterTx req);
  extern virtual task driveTrigOut();

endclass

function triggerMasterDriverProxy :: new(string name = "triggerMasterDriverProxy",uvm_component parent = null);
  super.new(name,parent);
endfunction

function void triggerMasterDriverProxy :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  vif = triggerMasterAgentConfigHandle.vif;
endfunction

task triggerMasterDriverProxy::driveTrigIn(triggerMasterTx req);
  @(vif.masterDrvCb);
  vif.masterDrvCb.trigInReq <= 1'b1;
  vif.masterDrvCb.reqType   <= req.reqTypeName;
  do begin
    @(vif.masterDrvCb);
  end while(vif.masterDrvCb.trigInAck != 1);
  vif.masterDrvCb.trigInReq <= 1'b0;
  req.trigInAck = vif.masterDrvCb.trigInAck;
  req.ackType   = ackTypeEnum'(vif.masterDrvCb.ackType);
endtask

task triggerMasterDriverProxy::driveTrigOut();
  @(vif.masterDrvCb);
  vif.masterDrvCb.trigOutAck <= 1'b0;
  do begin
    @(vif.masterDrvCb);
  end while(vif.masterDrvCb.trigOutReq != 1);
  vif.masterDrvCb.trigOutAck <= 1'b1;
endtask

task triggerMasterDriverProxy :: run_phase(uvm_phase phase);
  super.run_phase(phase);
  fork
    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info(get_type_name(), $sformatf("TriggerMASTER-TX\n %s",req.sprint),UVM_HIGH);
      driveTrigIn(req);
      `uvm_info(get_type_name(), $sformatf("AFTER :: received req packet in Trigger Master Driver \n %s",req.sprint()),UVM_HIGH);
      seq_item_port.item_done();
    end
    forever begin
      driveTrigOut();
    end
  join
endtask

`endif
