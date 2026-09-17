`ifndef TRIGGERMASTERMONITORPROXY_INCLUDED
`define TRIGGERMAASTERMONITORPROXY_INCLUDED

class triggerMasterMonitorProxy extends uvm_monitor;
  `uvm_component_utils(triggerMasterMonitorProxy)

  virtual triggerInterface vif;
  triggerMasterAgentConfig triggerMasterAgentConfigHandle;
  uvm_analysis_port #(triggerMasterTx) triggerMasterMonitorAnalysisPort;
  uvm_analysis_port #(triggerMasterTx) triggerOutMasterMonitorAnalysisPort;
  bit flag;

  extern function new(string name = "triggerMasterMonitorProxy",uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task monitorTrigIn(triggerMasterTx req);
  extern virtual task monitorTrigOut(triggerMasterTx req);

endclass

function triggerMasterMonitorProxy :: new(string name = "triggerMasterMonitorProxy",uvm_component parent = null);
  super.new(name,parent);
endfunction

function void triggerMasterMonitorProxy :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  vif = triggerMasterAgentConfigHandle.vif;
  triggerMasterMonitorAnalysisPort = new("triggerMasterMonitorAnalysisPort",this);
  triggerOutMasterMonitorAnalysisPort = new("triggerOutMasterMonitorAnalysisPort",this);
endfunction

task triggerMasterMonitorProxy::monitorTrigIn(triggerMasterTx req);
  do begin
    @(vif.monCb);
  end while(vif.monCb.trigInReq != 1 || vif.monCb.trigInAck != 1);
  req.trigInReq   = vif.monCb.trigInReq;
  req.reqTypeName = reqTypeEnum'(vif.monCb.reqType);
  req.trigInAck   = vif.monCb.trigInAck;
  req.ackType     = ackTypeEnum'(vif.monCb.ackType);
endtask

task triggerMasterMonitorProxy::monitorTrigOut(triggerMasterTx req);
  do begin
    @(vif.monCb);
  end while(vif.monCb.trigOutReq != 1 || vif.monCb.trigOutAck != 1);
  req.trigOutReq = vif.monCb.trigOutReq;
  req.trigOutAck = vif.monCb.trigOutAck;
endtask

task triggerMasterMonitorProxy :: run_phase(uvm_phase phase);
  triggerMasterTx req;
  triggerMasterTx req1;
  super.run_phase(phase);

  fork
    forever begin
      req = triggerMasterTx :: type_id :: create("req");
      monitorTrigIn(req);
      triggerMasterMonitorAnalysisPort.write(req);
    end
    forever begin
      req1 = triggerMasterTx :: type_id :: create("req1");
      monitorTrigOut(req1);
      triggerOutMasterMonitorAnalysisPort.write(req1);
    end
  join
endtask

`endif
