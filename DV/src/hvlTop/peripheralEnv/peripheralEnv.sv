`ifndef PERIPHERALENV_INCLUDED
`define PERIPHERALENV_INCLUDED

//------------------------------------------------------------------------------
// Class: peripheralEnv
// Description:
// This environment contains AXI Master, AXI Slave,
// Trigger Master and Trigger Slave agents.
// It connects their analysis ports and virtual sequencer.
//------------------------------------------------------------------------------

class peripheralEnv extends uvm_env;
`uvm_component_utils(peripheralEnv)

 // AXI4 SLAVE analysis ports
 uvm_analysis_port #(axi4_slave_tx) axi4SlavePathWriteAddressAnalysisPort;
 uvm_analysis_port #(axi4_slave_tx) axi4SlavePathWriteDataAnalysisPort;
 uvm_analysis_port #(axi4_slave_tx) axi4SlavePathWriteResponseAnalysisPort;
 uvm_analysis_port #(axi4_slave_tx) axi4SlavePathReadAddressAnalysisPort;
 uvm_analysis_port #(axi4_slave_tx) axi4SlavePathReadDataAnalysisPort;

 // AXI4 MASTER analysis ports
 uvm_analysis_port #(axi4_master_tx) axi4MasterPathWriteAddressAnalysisPort;
 uvm_analysis_port #(axi4_master_tx) axi4MasterPathWriteDataAnalysisPort;
 uvm_analysis_port #(axi4_master_tx) axi4MasterPathWriteResponseAnalysisPort;
 uvm_analysis_port #(axi4_master_tx) axi4MasterPathReadAddressAnalysisPort;
 uvm_analysis_port #(axi4_master_tx) axi4MasterPathReadDataAnalysisPort;

 // Trigger analysis ports
 uvm_analysis_port #(triggerMasterTx) triggerMasterPathAnalysisPort;
 uvm_analysis_port #(triggerSlaveTx) triggerSlavePathAnalysisPort;
 uvm_analysis_port #(triggerMasterTx) triggerOutMasterPathAnalysisPort;
 uvm_analysis_port #(triggerSlaveTx) triggerOutSlavePathAnalysisPort;


 // Environment configuration handle
 peripheralEnvConfig peripheralEnvConfigHandle;

 // Agent handles
 axi4_master_agent axi4MasterAgentHandle;
 axi4_slave_agent axi4SlaveAgentHandle;
 triggerMasterAgent triggerMasterAgentHandle;
 triggerSlaveAgent triggerSlaveAgentHandle;

 // Virtual sequencer handle
 peripheralEnvVirtualSequencer peripheralEnvVirtualSequencerHandle;

 // Peripheral index number
 int peripheralNum;

 extern function new(string name = "peripheralEnv",uvm_component parent=null);
 extern virtual function void build_phase(uvm_phase phase);
 extern virtual function void connect_phase(uvm_phase phase);
endclass 


//------------------------------------------------------------------------------
// Constructor: Creates all analysis ports
//------------------------------------------------------------------------------
function peripheralEnv :: new(string name="peripheralEnv",uvm_component parent=null);
  super.new(name,parent);

   // Create AXI slave ports
   axi4SlavePathWriteAddressAnalysisPort = new("axi4SlavePathWriteAddressAnalysisPort",this);
   axi4SlavePathWriteDataAnalysisPort = new("axi4SlavePathWriteDataAnalysisPort",this);
   axi4SlavePathWriteResponseAnalysisPort = new("axi4SlavePathWriteResponseAnalysisPort",this);
   axi4SlavePathReadAddressAnalysisPort = new("axi4SlavePathReadAddressAnalysisPort",this);
   axi4SlavePathReadDataAnalysisPort = new("axi4SlavePathReadDataAnalysisPort",this);

   // Create AXI master ports
   axi4MasterPathWriteAddressAnalysisPort = new("axi4MasterPathWriteAddressAnalysisPort",this);
   axi4MasterPathWriteDataAnalysisPort = new("axi4MasterPathWriteDataAnalysisPort",this);
   axi4MasterPathWriteResponseAnalysisPort = new("axi4MasterPathWriteResponseAnalysisPort",this);
   axi4MasterPathReadAddressAnalysisPort = new("axi4MasterPathReadAddressAnalysisPort",this);
   axi4MasterPathReadDataAnalysisPort = new("axi4MasterPathReadDataAnalysisPort",this);

   // Create trigger ports
   triggerMasterPathAnalysisPort = new("triggerMasterPathAnalysisPort",this);
   triggerSlavePathAnalysisPort = new("triggerSlavePathAnalysisPort",this);

   triggerOutMasterPathAnalysisPort = new("triggerOutMasterPathAnalysisPort",this);
   triggerOutSlavePathAnalysisPort = new("triggerOutSlavePathAnalysisPort",this);


endfunction 


//------------------------------------------------------------------------------
// build_phase:
// 1) Get environment configuration
// 2) Set agent configurations
// 3) Create agents
// 4) Create virtual sequencer if enabled
//------------------------------------------------------------------------------
function void peripheralEnv :: build_phase(uvm_phase phase);
  super.build_phase(phase);

  // Get env config from config DB
  if(!(uvm_config_db #(peripheralEnvConfig)::get(this,"","peripheralEnvConfigHandle",peripheralEnvConfigHandle)))begin 
    `uvm_fatal("PERIPHERAL ENV","CANT GET PERIPHERAL ENV AGENT CONFIG") 
end

  // Set AXI slave agent config
  uvm_config_db #(axi4_slave_agent_config) :: set(this,"axi4SlaveAgentHandle",$sformatf("axi4SlaveAgentConfigHandle[%0d]",peripheralNum),peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[peripheralNum]); 

  // Set AXI master agent config
  uvm_config_db #(axi4_master_agent_config) :: set(this,"axi4MasterAgentHandle",$sformatf("axi4MasterAgentConfigHandle[%0d]",peripheralNum),peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[peripheralNum]); 

  // Set Trigger slave agent config
  uvm_config_db #(triggerSlaveAgentConfig) :: set(this,"triggerSlaveAgentHandle",$sformatf("triggerSlaveAgentConfigHandle[%0d]",peripheralNum),peripheralEnvConfigHandle.triggerSlaveAgentConfigHandle[peripheralNum]); 

  // Set Trigger master agent config
  uvm_config_db #(triggerMasterAgentConfig) :: set(this,"triggerMasterAgentHandle",$sformatf("triggerMasterAgentConfigHandle[%0d]",peripheralNum),peripheralEnvConfigHandle.triggerMasterAgentConfigHandle[peripheralNum]); 

  // Create AXI master agent
  axi4MasterAgentHandle= axi4_master_agent :: type_id :: create("axi4MasterAgentHandle",this);
  axi4MasterAgentHandle.masterId = peripheralNum;

  // Create AXI slave agent
  axi4SlaveAgentHandle = axi4_slave_agent :: type_id :: create("axi4SlaveAgentHandle",this);
  axi4SlaveAgentHandle.slaveId = peripheralNum;

  // Create Trigger slave agent
  triggerSlaveAgentHandle = triggerSlaveAgent :: type_id :: create("triggerSlaveAgentHandle",this);
  triggerSlaveAgentHandle.slaveId = peripheralNum;

  // Create Trigger master agent
  triggerMasterAgentHandle = triggerMasterAgent :: type_id :: create("triggerMasterAgentHandle",this);
  triggerMasterAgentHandle.masterId = peripheralNum;

  // Create virtual sequencer if enabled
 if(peripheralEnvConfigHandle.hasVirtualSequencer == 1) begin 
   peripheralEnvVirtualSequencerHandle = peripheralEnvVirtualSequencer :: type_id :: create("peripheralEnvVirtualSequencerHandle",this);
 end  
endfunction  


//------------------------------------------------------------------------------
// connect_phase:
// Connect all monitor analysis ports
// Connect sequencers to virtual sequencer if active
//------------------------------------------------------------------------------
function void peripheralEnv :: connect_phase(uvm_phase phase);

 // Connect AXI master monitor ports
 axi4MasterAgentHandle.axi4_master_mon_proxy_h.axi4_master_write_address_analysis_port.connect(axi4MasterPathWriteAddressAnalysisPort);
 axi4MasterAgentHandle.axi4_master_mon_proxy_h.axi4_master_write_data_analysis_port.connect(axi4MasterPathWriteDataAnalysisPort);
 axi4MasterAgentHandle.axi4_master_mon_proxy_h.axi4_master_write_response_analysis_port.connect(axi4MasterPathWriteResponseAnalysisPort);
 axi4MasterAgentHandle.axi4_master_mon_proxy_h.axi4_master_read_address_analysis_port.connect(axi4MasterPathReadAddressAnalysisPort);
 axi4MasterAgentHandle.axi4_master_mon_proxy_h.axi4_master_read_data_analysis_port.connect(axi4MasterPathReadDataAnalysisPort);

 // Connect AXI slave monitor ports
 axi4SlaveAgentHandle.axi4_slave_mon_proxy_h.axi4_slave_write_address_analysis_port.connect(axi4SlavePathWriteAddressAnalysisPort);
 axi4SlaveAgentHandle.axi4_slave_mon_proxy_h.axi4_slave_write_data_analysis_port.connect(axi4SlavePathWriteDataAnalysisPort);
 axi4SlaveAgentHandle.axi4_slave_mon_proxy_h.axi4_slave_write_response_analysis_port.connect(axi4SlavePathWriteResponseAnalysisPort);
 axi4SlaveAgentHandle.axi4_slave_mon_proxy_h.axi4_slave_read_address_analysis_port.connect(axi4SlavePathReadAddressAnalysisPort);
 axi4SlaveAgentHandle.axi4_slave_mon_proxy_h.axi4_slave_read_data_analysis_port.connect(axi4SlavePathReadDataAnalysisPort);

 // Connect trigger monitor ports
 triggerMasterAgentHandle.triggerMasterMonitorProxyHandle.triggerMasterMonitorAnalysisPort.connect(triggerMasterPathAnalysisPort);
 triggerSlaveAgentHandle.triggerSlaveMonitorProxyHandle.triggerSlaveMonitorAnalysisPort.connect(triggerSlavePathAnalysisPort);

  triggerMasterAgentHandle.triggerMasterMonitorProxyHandle.triggerOutMasterMonitorAnalysisPort.connect(triggerOutMasterPathAnalysisPort);
  triggerSlaveAgentHandle.triggerSlaveMonitorProxyHandle.triggerOutSlaveMonitorAnalysisPort.connect(triggerOutSlavePathAnalysisPort);


 // Connect virtual sequencer if enabled
 if(peripheralEnvConfigHandle.hasVirtualSequencer ==1)begin 

  if(peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[peripheralNum].is_active == UVM_ACTIVE)begin 
    peripheralEnvVirtualSequencerHandle.axi4MasterWriteSequencerHandle =  axi4MasterAgentHandle.axi4_master_write_seqr_h;
    peripheralEnvVirtualSequencerHandle.axi4MasterReadSequencerHandle = axi4MasterAgentHandle.axi4_master_read_seqr_h;
  end 

  if(peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[peripheralNum].is_active == UVM_ACTIVE)begin 
    peripheralEnvVirtualSequencerHandle.axi4SlaveWriteSequencerHandle = axi4SlaveAgentHandle.axi4_slave_write_seqr_h;
    peripheralEnvVirtualSequencerHandle.axi4SlaveReadSequencerHandle = axi4SlaveAgentHandle.axi4_slave_read_seqr_h;
  end 

  if(peripheralEnvConfigHandle.triggerSlaveAgentConfigHandle[peripheralNum].is_active == UVM_ACTIVE)begin 
    peripheralEnvVirtualSequencerHandle.triggerSlaveSequencerHandle = triggerSlaveAgentHandle.triggerSlaveSequencerHandle;
  end 

  if(peripheralEnvConfigHandle.triggerMasterAgentConfigHandle[peripheralNum].is_active == UVM_ACTIVE) begin 
    peripheralEnvVirtualSequencerHandle.triggerMasterSequencerHandle = triggerMasterAgentHandle.triggerMasterSequencerHandle;
  end 
 end 

endfunction 
`endif
