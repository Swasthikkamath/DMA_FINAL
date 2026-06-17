`ifndef TRIGGERMASTERAGENT_INCLUDED
`define TRIGGERMASTERAGENT_INCLUDED 

//------------------------------------------------------------------------------
// Class: triggerMasterAgent
// Description:
// This agent contains driver, monitor and sequencer.
// It works as ACTIVE or PASSIVE based on configuration.
//------------------------------------------------------------------------------

class triggerMasterAgent extends uvm_agent;

  `uvm_component_utils(triggerMasterAgent)

  // ID of master (used to get correct config)
  int  masterId;

  // Handle to agent configuration
  triggerMasterAgentConfig triggerMasterAgentConfigHandle;

  // Driver handle
  triggerMasterDriverProxy triggerMasterDriverProxyHandle;

  // Monitor handle
  triggerMasterMonitorProxy triggerMasterMonitorProxyHandle;

  // Sequencer handle
  triggerMasterSequencer triggerMasterSequencerHandle;

  // Constructor
  extern function new(string name ="triggerMasterAgent",uvm_component parent =null);

  // Build phase
  extern virtual function void build_phase(uvm_phase phase);

  // Connect phase
  extern virtual function void connect_phase(uvm_phase phase);

endclass 

//------------------------------------------------------------------------------
// Function: new
// Description: Constructor of trigger master agent
//------------------------------------------------------------------------------

function triggerMasterAgent::new(string name = "triggerMasterAgent",uvm_component parent =null);
 super.new(name,parent);
endfunction 

//------------------------------------------------------------------------------
// Function: build_phase
// Description:
// 1. Get agent configuration from config DB
// 2. If agent is ACTIVE ? create driver and sequencer
// 3. Always create monitor
//------------------------------------------------------------------------------
function void triggerMasterAgent :: build_phase(uvm_phase phase);

  super.build_phase(phase);

  // Get configuration from config DB
  if(!(uvm_config_db #(triggerMasterAgentConfig) ::get(this,"",$sformatf("triggerMasterAgentConfigHandle[%0d]",masterId),triggerMasterAgentConfigHandle))) begin 
    `uvm_fatal("TRIGGER MASTER AGENT","FAILED TO GET TRIGGER MASTER AGENT CONFIG")   
  end

  // If agent is ACTIVE, create driver and sequencer
  if(triggerMasterAgentConfigHandle.is_active == UVM_ACTIVE) begin 
    triggerMasterDriverProxyHandle =triggerMasterDriverProxy ::type_id :: create("triggerMasterDriverProxyHandle",this);

    // Pass config handle to driver
    triggerMasterDriverProxyHandle.triggerMasterAgentConfigHandle = triggerMasterAgentConfigHandle;

    triggerMasterSequencerHandle =triggerMasterSequencer ::type_id :: create("triggerMasterSequencerHandle",this);
  end 

  // Create monitor (both ACTIVE and PASSIVE agent need monitor)
  triggerMasterMonitorProxyHandle =triggerMasterMonitorProxy ::type_id :: create("triggerMasterMonitorProxyHandle",this); 

  // Pass config handle to monitor
  triggerMasterMonitorProxyHandle.triggerMasterAgentConfigHandle = triggerMasterAgentConfigHandle; 

endfunction 

//------------------------------------------------------------------------------
// Function: connect_phase
// Description:
// Connect driver and sequencer if agent is ACTIVE
//------------------------------------------------------------------------------

function void triggerMasterAgent :: connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if(triggerMasterAgentConfigHandle.is_active == UVM_ACTIVE) begin 
    // Connect driver to sequencer
    triggerMasterDriverProxyHandle.seq_item_port.connect(triggerMasterSequencerHandle.seq_item_export);
  end 

endfunction 

`endif 
