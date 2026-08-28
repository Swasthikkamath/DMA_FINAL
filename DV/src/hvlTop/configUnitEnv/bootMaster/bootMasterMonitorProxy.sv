`ifndef BOOT_MASTER_MONITOR_PROXY
`define BOOT_MASTER_MONITOR_PROXY


class bootMasterMonitorProxy extends uvm_monitor;
  `uvm_component_utils(bootMasterMonitorProxy)

  extern function new(string name="bootMasterMonitorProxy",uvm_component parent=null);

  extern virtual function void build_phase(uvm_phase phase);

  extern virtual task run_phase(uvm_phase phase);
 
  bootMasterTx req;

  bootMasterAgentConfig bootMasterAgentConfigHandle;
  uvm_analysis_port#(bootMasterTx) bootMasterMonitorProxyAnalysisPort;


 virtual  bootMasterMonitorBfm bootMasterMonitorBfmHandle;
  bootStructPacket bootStructPacketHandle;
endclass 

function bootMasterMonitorProxy :: new(string name="bootMasterMonitorProxy",uvm_component parent=null);
  super.new(name,parent);
endfunction 

function void bootMasterMonitorProxy :: build_phase(uvm_phase phase);
  super.build_phase(phase);

  if(!(uvm_config_db #(bootMasterAgentConfig) :: get(this,"","bootMasterAgentConfigHandle",bootMasterAgentConfigHandle)))begin 
    `uvm_fatal("bootMasterMonitorProxy","COULDNT GET MONITOR CONFIG")
  end 

  bootMasterMonitorBfmHandle = bootMasterAgentConfigHandle.bootMasterMonitorBfmHandle;
  bootMasterMonitorProxyAnalysisPort = new("bootMasterMonitorProxyAnalysisPort",this);
endfunction 


task bootMasterMonitorProxy :: run_phase(uvm_phase phase);
   //bootEn 
  //boot addr 
  //
  //rest   boot en next seq $rose (rest)
  //
  forever begin 
    req = bootMasterTx :: type_id :: create("bootMonitorTx");
    bootMasterSeqItemConverter :: fromClass(req,bootStructPacketHandle);
    bootMasterMonitorBfmHandle.bootMonitor(bootStructPacketHandle);
    bootMasterSeqItemConverter :: toClass(bootStructPacketHandle,req);
    if(req.bootEn==1) 
       bootMasterMonitorProxyAnalysisPort.write(req);
  end 


endtask

`endif



