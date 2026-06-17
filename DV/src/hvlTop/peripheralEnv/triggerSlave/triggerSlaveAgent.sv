`ifndef TRIGGERSLAVEAGENT_INCLUDED
`define TRIGGERSLAVEAGENT_INCLUDED 

//------------------------------------------------------------------------------
// Class: triggerSlaveAgent
// Description:
// This agent contains slave driver, monitor and sequencer.
// It works as ACTIVE or PASSIVE based on configuration.
//------------------------------------------------------------------------------

class triggerSlaveAgent extends uvm_agent;

  `uvm_component_utils(triggerSlaveAgent)

  // ID of slave (used to get correct config)
  int  slaveId;

  // Handle to slave agent configuration
  triggerSlaveAgentConfig triggerSlaveAgentConfigHandle;

  // Driver handle
  triggerSlaveDriverProxy triggerSlaveDriverProxyHandle;

  // Monitor handle
  triggerSlaveMonitorProxy triggerSlaveMonitorProxyHandle;

  // Sequencer handle
  triggerSlaveSequencer triggerSlaveSequencerHandle;

  // Constructor
  extern function new(string name ="triggerSlaveAgent",uvm_component parent =null);

  // Build phase
  extern virtual function void build_phase(uvm_phase phase);

  // Connect phase
  extern virtual function void connect_phase(uvm_phase phase);

endclass 


//------------------------------------------------------------------------------
// Function: new
// Description: Constructor of trigger slave agent
//------------------------------------------------------------------------------

function triggerSlaveAgent::new(string name = "triggerSlaveAgent", uvm_component parent =null);
 super.new(name,parent);
endfunction 

//------------------------------------------------------------------------------
// Function: build_phase
// Description:
// 1. Get slave agent configuration from config DB
// 2. If ACTIVE ? create driver and sequencer
// 3. Always create monitor
//------------------------------------------------------------------------------

function void triggerSlaveAgent :: build_phase(uvm_phase phase);
  super.build_phase(phase);

  // Get configuration from config DB
  if(!(uvm_config_db #(triggerSlaveAgentConfig) ::get(this,"",$sformatf("triggerSlaveAgentConfigHandle[%0d]",slaveId),triggerSlaveAgentConfigHandle))) begin 
    `uvm_fatal("TRIGGER SLAVE AGENT","FAILED TO GET TRIGGER SLAVE AGENT CONFIG") 
  end

  // If agent is ACTIVE, create driver and sequencer
  if(triggerSlaveAgentConfigHandle.is_active == UVM_ACTIVE) begin 

    triggerSlaveDriverProxyHandle =triggerSlaveDriverProxy::type_id :: create("triggerSlaveDriverProxyHandle",this);
    // Pass config handle to driver
    triggerSlaveDriverProxyHandle.triggerSlaveAgentConfigHandle = triggerSlaveAgentConfigHandle;
    triggerSlaveSequencerHandle =triggerSlaveSequencer ::type_id :: create("triggerSlaveSequencerHandle",this);
  end 
  // Create monitor (for both ACTIVE and PASSIVE)
    triggerSlaveMonitorProxyHandle =triggerSlaveMonitorProxy ::type_id :: create("triggerSlaveMonitorProxyHandle",this); 

  // Pass config handle to monitor
    triggerSlaveMonitorProxyHandle.triggerSlaveAgentConfigHandle = triggerSlaveAgentConfigHandle;
 
endfunction 

//------------------------------------------------------------------------------
// Function: connect_phase
// Description:
// Connect driver and sequencer if agent is ACTIVE
//------------------------------------------------------------------------------

function void triggerSlaveAgent :: connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if(triggerSlaveAgentConfigHandle.is_active == UVM_ACTIVE) begin 
    // Connect driver to sequencer
    triggerSlaveDriverProxyHandle.seq_item_port.connect(triggerSlaveSequencerHandle.seq_item_export);
  end 

endfunction 

`endif
