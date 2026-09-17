`ifndef BOOT_MASTER_DRIVER_PROXY
`define BOOT_MASTER_DRIVER_PROXY

class bootMasterDriverProxy extends uvm_driver#(bootMasterTx);
  `uvm_component_utils(bootMasterDriverProxy)

  extern function new(string name="bootMasterDriverProxy",uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task bootDrive(bootMasterTx req);

  bootMasterAgentConfig bootMasterAgentConfigHandle;
  virtual bootInterface vif;
endclass

function bootMasterDriverProxy :: new(string name="bootMasterDriverProxy",uvm_component parent=null);
  super.new(name,parent);
endfunction

function void bootMasterDriverProxy :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!(uvm_config_db #(bootMasterAgentConfig) :: get(this,"","bootMasterAgentConfigHandle",bootMasterAgentConfigHandle)))begin
    `uvm_fatal("bootMasterDriverProxy","COULDNT GET DRIVER CONFIG")
  end
  vif = bootMasterAgentConfigHandle.vif;
endfunction

task bootMasterDriverProxy::bootDrive(bootMasterTx req);
  vif.masterDrvCb.bootEn   <= 1'b1;
  vif.masterDrvCb.bootAddr <= req.bootAddr;
  do begin
    @(vif.masterDrvCb);
  end while(!(vif.roseRst()));
endtask

task bootMasterDriverProxy :: run_phase(uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(req);
    bootDrive(req);
    rsp = bootMasterTx :: type_id:: create("bootrsp");
    rsp.set_id_info(req);
    seq_item_port.item_done(rsp);
  end
endtask

`endif
