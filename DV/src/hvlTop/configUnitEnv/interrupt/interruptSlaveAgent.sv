`ifndef INTERRUPTSLAVEAGENT_INCLUDED
`define INTERRUPTSLAVEAGENT_INCLUDED
//------------------------------------------------------------------------------
// Class: interruptSlaveAgent
// Description:
//   UVM Agent for Interrupt Slave interface.
//   - In ACTIVE mode: creates Driver + Sequencer + Monitor
//   - In PASSIVE mode: creates only Monitor
//   - Provides analysis port to send monitored transactions to scoreboard
//------------------------------------------------------------------------------
class interruptSlaveAgent extends uvm_agent;
  // Factory registration
  `uvm_component_utils(interruptSlaveAgent)
  // Generates transactions
  interruptSlaveSequencer interruptSlaveSequencerHandle;
  // drives transactions to DUT (only in ACTIVE mode)
  interruptSlaveDriverProxy interruptSlaveDriverProxyHandle;
  // observes DUT signals and sends transactions
  interruptSlaveMonitorProxy interruptSlaveMonitorProxyHandle;
  // Agent configuration handle
  interruptSlaveAgentConfig interruptSlaveAgentConfigHandle;
  // Analysis port to broadcast monitored transactions
  uvm_analysis_port #(interruptSlaveTx) interruptSlaveMonitorProxyAnalysisPort;
 
  extern function new(string name = "interruptSlaveAgent",uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
 
endclass
 
 
function interruptSlaveAgent :: new(string name = "interruptSlaveAgent",uvm_component parent = null);  
  super.new(name,parent);
endfunction
 
//------------------------------------------------------------------------------
// Function: build_phase
// Description:
//   - Gets agent config from config_db
//   - Creates components based on active/passive mode
//   - Initializes analysis port
//------------------------------------------------------------------------------
 
function void interruptSlaveAgent :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get agent configuration
  if(!(uvm_config_db #(interruptSlaveAgentConfig) ::get(this ,"","interruptSlaveAgentConfigHandle",interruptSlaveAgentConfigHandle)))begin 
   `uvm_fatal("interrupt slave agent","FAILED TO GET THE INTERRUPT SLAVE AGENT CONFIG")
  end 
   // Create driver and sequencer only in ACTIVE mode
  if(interruptSlaveAgentConfigHandle.is_active == UVM_ACTIVE) begin
    interruptSlaveDriverProxyHandle = interruptSlaveDriverProxy :: type_id :: create("interruptSlaveDriverProxyHandle",this);
    //pass config to driver
    interruptSlaveDriverProxyHandle.interruptSlaveAgentConfigHandle = interruptSlaveAgentConfigHandle;
    interruptSlaveSequencerHandle = interruptSlaveSequencer :: type_id :: create("interruptSlaveSequencerHandle",this);
  end
  interruptSlaveMonitorProxyHandle = interruptSlaveMonitorProxy :: type_id :: create("interruptSlaveMonitorProxyHandle",this);
  //Pass config to monitor
  interruptSlaveMonitorProxyHandle.interruptSlaveAgentConfigHandle = interruptSlaveAgentConfigHandle;
  // Create analysis port
  interruptSlaveMonitorProxyAnalysisPort = new("slave agent port",this);
endfunction
//------------------------------------------------------------------------------
// Function: connect_phase
// Description:
//   - Connects sequencer to driver (ACTIVE mode)
//   - Connects monitor analysis port to agent analysis port
//------------------------------------------------------------------------------
function void interruptSlaveAgent :: connect_phase(uvm_phase phase);
  
  // Connect driver and sequencer in ACTIVE mode
   if(interruptSlaveAgentConfigHandle.is_active == UVM_ACTIVE) begin
     interruptSlaveDriverProxyHandle.seq_item_port.connect(interruptSlaveSequencerHandle.seq_item_export);
   end 
  // Connect monitor output to agent analysis port
   interruptSlaveMonitorProxyHandle.interruptSlaveMonitorProxyAnalysisPort.connect(interruptSlaveMonitorProxyAnalysisPort);
endfunction 
`endif
