`ifndef INTERRUPTSLAVEDRIVERPROXY_INCLUDED
`define INTERRUPTSLAVEDRIVERPROXY_INCLUDED

class interruptSlaveDriverProxy extends uvm_driver #(interruptSlaveTx);
  `uvm_component_utils(interruptSlaveDriverProxy)

  virtual interruptInterface vif;
  interruptSlaveAgentConfig interruptSlaveAgentConfigHandle;

  extern function new(string name = "interruptSlaveDriverProxy",uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task waitForIrq(interruptSlaveTx req);

endclass

function interruptSlaveDriverProxy :: new(string name = "interruptSlaveDriverProxy",uvm_component parent =null);
  super.new(name,parent);
endfunction

function void interruptSlaveDriverProxy :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!(uvm_config_db #(virtual interruptInterface) :: get(this,"","interruptInterface",vif))) begin
    `uvm_fatal("INTERRUPT SLAVE DRIVER","FAILED TO GET INTERRUPT INTERFACE")
  end
endfunction

task interruptSlaveDriverProxy::waitForIrq(interruptSlaveTx req);
  @(vif.monCb);
  do begin
    @(vif.monCb);
  end while((|vif.monCb.irq) != 1);
  req.irq = vif.monCb.irq;
endtask

task interruptSlaveDriverProxy :: run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name(), $sformatf("TriggerSlave-TX\n %s",req.sprint),UVM_HIGH);
    waitForIrq(req);
    `uvm_info(get_type_name(), $sformatf("AFTER :: received req packet in Interrupt Slave Driver \n %s", req.sprint()), UVM_HIGH);
    rsp = interruptSlaveTx :: type_id :: create("rsp");
    rsp.set_id_info(req);
    rsp.irq = req.irq;
    seq_item_port.item_done(rsp);
  end
endtask

`endif
