`ifndef TRIGGERSLAVEMONITORPROXY_INCLUDED
`define TRIGGERSLAVEMONITORPROXY_INCLUDED

class triggerSlaveMonitorProxy extends uvm_monitor;
  `uvm_component_utils(triggerSlaveMonitorProxy)

  virtual triggerInterface vif;
  triggerSlaveAgentConfig triggerSlaveAgentConfigHandle;
  uvm_analysis_port #(triggerSlaveTx) triggerSlaveMonitorAnalysisPort;
  uvm_analysis_port #(triggerSlaveTx) triggerOutSlaveMonitorAnalysisPort;
  bit flag;

  extern function new(string name = "triggerSlaveMonitorProxy",uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task monitorTrigIn(triggerSlaveTx req);
  extern virtual task monitorTrigOut(triggerSlaveTx req);

endclass

function triggerSlaveMonitorProxy ::new(string name = "triggerSlaveMonitorProxy", uvm_component parent = null);
  super.new(name,parent);
endfunction

function void triggerSlaveMonitorProxy ::build_phase(uvm_phase phase);
  super.build_phase(phase);
  vif = triggerSlaveAgentConfigHandle.vif;
  triggerSlaveMonitorAnalysisPort = new("triggerSlaveMonitorAnalysisPort",this);
  triggerOutSlaveMonitorAnalysisPort = new("triggerOutSlaveMonitorAnalysisPort",this);
endfunction

task triggerSlaveMonitorProxy::monitorTrigIn(triggerSlaveTx req);
  do begin
    @(vif.monCb);
  end while(vif.monCb.trigInReq != 1 || vif.monCb.trigInAck != 1);
  req.trigInReq = vif.monCb.trigInReq;
  req.reqType   = reqTypeEnum'(vif.monCb.reqType);
  req.trigInAck = vif.monCb.trigInAck;
  req.ackType   = ackTypeEnum'(vif.monCb.ackType);
  @(vif.monCb);
endtask

task triggerSlaveMonitorProxy::monitorTrigOut(triggerSlaveTx req);
  do begin
    @(vif.monCb);
  end while(vif.monCb.trigOutReq != 1 || vif.monCb.trigOutAck != 1);
  req.trigOutReq = vif.monCb.trigOutReq;
  req.trigOutAck = vif.monCb.trigOutAck;
endtask

task triggerSlaveMonitorProxy ::run_phase(uvm_phase phase);
  triggerSlaveTx req;
  triggerSlaveTx req1;
  super.run_phase(phase);
  fork
    forever begin
      req = triggerSlaveTx :: type_id :: create("req");
      monitorTrigIn(req);
      triggerSlaveMonitorAnalysisPort.write(req);
    end
    forever begin
      req1 = triggerSlaveTx :: type_id :: create("req1");
      monitorTrigOut(req1);
      triggerOutSlaveMonitorAnalysisPort.write(req1);
    end
  join
endtask

`endif
