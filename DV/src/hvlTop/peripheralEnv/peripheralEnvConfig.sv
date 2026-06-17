`ifndef PERIPHERALENVCONFIG_INCLUDED
`define PERIPHERALENVCONFIG_INCLUDED

//------------------------------------------------------------------------------
// Class: peripheralEnvConfig
// Description:
// This class stores configuration for peripheralEnv.
// It contains agent configuration handles and control flags.
//------------------------------------------------------------------------------

class peripheralEnvConfig extends uvm_object;
  `uvm_object_utils(peripheralEnvConfig)

  // AXI master agent configuration array
  axi4_master_agent_config axi4MasterAgentConfigHandle[];

  // AXI slave agent configuration array
  axi4_slave_agent_config axi4SlaveAgentConfigHandle[];

  // Trigger slave agent configuration array
  triggerSlaveAgentConfig triggerSlaveAgentConfigHandle[];

  // Trigger master agent configuration array
  triggerMasterAgentConfig triggerMasterAgentConfigHandle[];

  // Flag to enable/disable scoreboard
  bit hasScoreboard;

  // Flag to enable/disable virtual sequencer
  bit hasVirtualSequencer;
  
  extern function new(string name = "peripheralEnvConfig");
endclass
 

//------------------------------------------------------------------------------
// Constructor
//------------------------------------------------------------------------------
function peripheralEnvConfig :: new(string name ="peripheralEnvConfig");
  super.new(name);
endfunction 

`endif
