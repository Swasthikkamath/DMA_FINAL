`ifndef CONFIGUNITENV_INCLUDED
`define CONFIGUNITENV_INCLUDED 
//------------------------------------------------------------------------------
// Class: configUnitEnv
// Description:
//   Top-level environment for the Config Unit.
//------------------------------------------------------------------------------

class configUnitEnv extends uvm_env;
  // Factory registration
  `uvm_component_utils(configUnitEnv)

  // Analysis port for APB master transactions
  uvm_analysis_port #(apb_master_tx) apbPathAnalysisPort;
  // Analysis port for Interrupt Slave transactions
  uvm_analysis_port #(interruptSlaveTx) interruptPathAnalysisPort;

  // Handle for APB Master Agent
  apb_master_agent apbMasterAgentHandle;

  // Handle for Interrupt Slave Agent
  interruptSlaveAgent interruptSlaveAgentHandle;

  // Handle for Virtual Sequencer
  // Used for coordinating sequences across multiple agents 
  configUnitEnvVirtualSequencer configUnitEnvVirtualSequencerHandle;

  // Environment configuration object
  // Contains agent configs and global environment settings
  configUnitEnvConfig configUnitEnvConfigHandle;


  extern function new(string name = "configUnitEnv",uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass
//------------------------------------------------------------------------------
// Function: new
// Description:
//   Constructor for configUnitEnv
//------------------------------------------------------------------------------

function configUnitEnv :: new(string name = "configUnitEnv",uvm_component parent = null);
  super.new(name,parent);
endfunction 

//------------------------------------------------------------------------------
// Function: build_phase
// Description:
//   - Retrieves environment configuration from config_db
//   - Sets agent configurations into config_db
//   - Creates agents,analysis ports and virtual sequencer
//------------------------------------------------------------------------------

function void configUnitEnv :: build_phase(uvm_phase phase);
  super.build_phase(phase);

    // Get environment configuration object from config_db
  if(!(uvm_config_db #(configUnitEnvConfig) :: get(this,"","configUnitEnvConfigHandle",configUnitEnvConfigHandle))) begin 
    `uvm_fatal("CONFIG UNIT ENV","FAILED TO GET THE DM CONTROLLER CONFIG")
  end  
   // Pass APB master agent config to agent via config_db
  uvm_config_db #(apb_master_agent_config ) :: set(this,"apbMasterAgentHandle","apb_master_agent_config",configUnitEnvConfigHandle.apbMasterAgentConfigHandle); 
   // Pass Interrupt slave agent config to agent via config_db
  uvm_config_db #(interruptSlaveAgentConfig) :: set(this,"interruptSlaveAgentHandle","interruptSlaveAgentConfigHandle",configUnitEnvConfigHandle.interruptSlaveAgentConfigHandle); 

   // Create agent instances
  apbMasterAgentHandle =apb_master_agent::type_id::create("apbMasterAgentHandle",this);
  interruptSlaveAgentHandle = interruptSlaveAgent :: type_id :: create("interruptSlaveAgentHandle",this);

  // Create analysis ports
  interruptPathAnalysisPort = new("interruptPathAnalysisPort",this);
  apbPathAnalysisPort = new("apbPathAnalysisPort",this);

  // Conditionally create virtual sequencer
  if(configUnitEnvConfigHandle.hasVirtualSequencer ==1 ) begin 
    configUnitEnvVirtualSequencerHandle = configUnitEnvVirtualSequencer :: type_id :: create("configUnitEnvVirtualSequencerHandle",this);
  end 

endfunction

//------------------------------------------------------------------------------
// Function: connect_phase
// Description:
//   - Connects monitor analysis ports to environment analysis ports
//   - Connects sequencers to virtual sequencer (if enabled)
//------------------------------------------------------------------------------
function void configUnitEnv :: connect_phase(uvm_phase phase);
  super.connect_phase(phase);

   // Connect APB monitor analysis port to env analysis port
   apbMasterAgentHandle.apb_master_mon_proxy_h.apb_master_analysis_port.connect(apbPathAnalysisPort);

  // Connect interrupt monitor analysis port to env analysis port
   interruptSlaveAgentHandle.interruptSlaveMonitorProxyAnalysisPort.connect(interruptPathAnalysisPort);

  // Virtual sequencer connections
   if (configUnitEnvConfigHandle.hasVirtualSequencer == 1) begin
      // Connect APB sequencer to the virtual sequencer if agent is active
     if(configUnitEnvConfigHandle.apbMasterAgentConfigHandle.is_active == UVM_ACTIVE) begin
       configUnitEnvVirtualSequencerHandle.apbMasterSequencerHandle = apbMasterAgentHandle.apb_master_seqr_h;
     end
     // Connect Interrupt sequencer to the virtual sequencer if agent is active
     if(configUnitEnvConfigHandle.interruptSlaveAgentConfigHandle.is_active == UVM_ACTIVE) begin
       configUnitEnvVirtualSequencerHandle.interruptSlaveSequencerHandle =  interruptSlaveAgentHandle.interruptSlaveSequencerHandle;
     end

  end
endfunction 

`endif















 
