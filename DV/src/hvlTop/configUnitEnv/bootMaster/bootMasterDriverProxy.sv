`ifndef BOOT_MASTER_DRIVER_PROXY
`define BOOT_MASTER_DRIVER_PROXY


class bootMasterDriverProxy extends uvm_driver#(bootMasterTx);
  `uvm_component_utils(bootMasterDriverProxy)

  extern function new(string name="bootMasterDriverProxy",uvm_component parent=null);

  extern virtual function void build_phase(uvm_phase phase);

  extern virtual task run_phase(uvm_phase phase);
  bootMasterAgentConfig bootMasterAgentConfigHandle; 
  virtual bootMasterDriverBfm bootMasterDriverBfmHandle;
  bootStructPacket bootStructPacketHandle;
endclass 

function bootMasterDriverProxy :: new(string name="bootMasterDriverProxy",uvm_component parent=null);
  super.new(name,parent);
endfunction 

function void bootMasterDriverProxy :: build_phase(uvm_phase phase);
  super.build_phase(phase);

  if(!(uvm_config_db #(bootMasterAgentConfig) :: get(this,"","bootMasterAgentConfigHandle",bootMasterAgentConfigHandle)))begin 
    `uvm_fatal("bootMasterDriverProxy","COULDNT GET DRIVER CONFIG")
  end 

  bootMasterDriverBfmHandle = bootMasterAgentConfigHandle.bootMasterDriverBfmHandle;
endfunction 


task bootMasterDriverProxy :: run_phase(uvm_phase phase);
   //bootEn 
  //boot addr 
  //
  //rest   boot en next seq $rose (rest)
  //
  forever begin 
    seq_item_port.get_next_item(req);
    $display("ORIGINL ADDDDD IS %d",req.bootAddr);
    bootMasterSeqItemConverter :: fromClass(req,bootStructPacketHandle);
    bootMasterDriverBfmHandle.bootDrive(bootStructPacketHandle);
    bootMasterSeqItemConverter :: toClass(bootStructPacketHandle,req);
    rsp = bootMasterTx :: type_id:: create("bootrsp");
    rsp.set_id_info(req);
    seq_item_port.item_done(rsp);
  end 


endtask

`endif



