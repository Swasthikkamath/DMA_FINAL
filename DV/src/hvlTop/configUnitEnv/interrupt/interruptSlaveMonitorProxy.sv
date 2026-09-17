`ifndef INTERRUPTSLAVEMONITORPROXY_INCLUDED
`define INTERRUPTSLAVEMONITORPROXY_INCLUDED

class interruptSlaveMonitorProxy extends uvm_monitor;
  `uvm_component_utils(interruptSlaveMonitorProxy)

  virtual interruptInterface vif;
  interruptSlaveAgentConfig interruptSlaveAgentConfigHandle;
  uvm_analysis_port #(interruptSlaveTx) interruptSlaveMonitorProxyAnalysisPort;

  extern function new(string name = "interruptSlaveMonitorProxy",uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass

function interruptSlaveMonitorProxy :: new(string name = "interruptSlaveMonitorProxy",uvm_component parent =null);
  super.new(name,parent);
endfunction

function void interruptSlaveMonitorProxy :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!(uvm_config_db #(virtual interruptInterface) :: get(this,"","interruptInterface",vif)))begin
    `uvm_fatal("INTERRUPT SLAVE MONITOR","FAILED TO GET INTERRUPT INTERFACE")
  end
  interruptSlaveMonitorProxyAnalysisPort = new("interruptSlaveMonitorProxyAnalysisPort",this);
endfunction

task interruptSlaveMonitorProxy :: run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
    interruptSlaveTx req;
    req = interruptSlaveTx :: type_id :: create("slave interrupt tx");
    do begin
      @(vif.monCb);
    end while((|vif.monCb.irq) != 1);
    req.irq = vif.monCb.irq;
    interruptSlaveMonitorProxyAnalysisPort.write(req);
  end
endtask

`endif
