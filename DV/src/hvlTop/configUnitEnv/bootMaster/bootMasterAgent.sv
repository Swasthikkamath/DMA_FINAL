`ifndef BOOT_MASTER_AGENT_INCLUDED_
`define BOOT_MASTER_AGENT_INCLUDED_

class bootMasterAgent extends uvm_agent;
   `uvm_component_utils(bootMasterAgent)
   
  uvm_analysis_port #(bootMasterTx) bootMasterMonitorProxyAnalysisPort;

  bootMasterAgentConfig bootMasterAgentConfigHandle;

  bootMasterDriverProxy bootMasterDriverProxyHandle;

  bootMasterMonitorProxy bootMasterMonitorProxyHandle;

  bootMasterSequencer bootMasterSequencerHandle;

  extern function new(string name = "bootMasterAgent",uvm_component parent=null);

  extern virtual function void build_phase(uvm_phase phase);

  extern virtual function void connect_phase(uvm_phase phase);

endclass



function bootMasterAgent :: new(string name="bootMasterAgent",uvm_component parent = null);
  super.new(name,parent);
endfunction 

function void bootMasterAgent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!(uvm_config_db #(bootMasterAgentConfig)::get(this,"","bootMasterAgentConfigHandle",bootMasterAgentConfigHandle)   ))begin 
    `uvm_fatal("BOOT MASTER AGENT ","FAILED TO GET AGENT CONFIG")
  end 

  if(bootMasterAgentConfigHandle.is_active==1)begin 
    bootMasterDriverProxyHandle = bootMasterDriverProxy::type_id :: create("bootMasterDriverProxyHandle",this);
    uvm_config_db #(bootMasterAgentConfig) :: set(this,"bootMasterDriverProxyHandle","bootMasterAgentConfigHandle",bootMasterAgentConfigHandle);
    bootMasterSequencerHandle = bootMasterSequencer :: type_id :: create("bootMasterSequencerHandle",this);
  end 

  uvm_config_db #(bootMasterAgentConfig) :: set(this,"bootMasterMonitorProxyHandle","bootMasterAgentConfigHandle",bootMasterAgentConfigHandle);
  bootMasterMonitorProxyHandle = bootMasterMonitorProxy :: type_id :: create("bootMasterMonitorProxyHandle",this);
  bootMasterMonitorProxyAnalysisPort = new("bootMasterMonitorProxyAnalysisPort",this);
endfunction 

function void bootMasterAgent::connect_phase(uvm_phase phase);
  if(bootMasterAgentConfigHandle.is_active==1)
   bootMasterDriverProxyHandle.seq_item_port.connect(bootMasterSequencerHandle.seq_item_export);
   bootMasterMonitorProxyHandle.bootMasterMonitorProxyAnalysisPort.connect(bootMasterMonitorProxyAnalysisPort);

endfunction 


`endif



