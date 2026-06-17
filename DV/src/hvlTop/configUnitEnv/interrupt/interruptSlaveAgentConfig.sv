`ifndef INTERRUPTSLAVEAGENTCONFIG_INCLUDED
`define INTERRUPTSLAVEAGENTCONFIG_INCLUDED
//------------------------------------------------------------------------------
// Class: interruptSlaveAgentConfig
// Description:
//   Configuration object for interrupt slave agent.
//   Controls whether the agent operates in ACTIVE or PASSIVE mode.
//------------------------------------------------------------------------------
class interruptSlaveAgentConfig extends uvm_object;
  //Factory registration
  `uvm_object_utils(interruptSlaveAgentConfig)
  
  // Defines agent mode:
  // UVM_ACTIVE  -> Driver + Sequencer + Monitor
  // UVM_PASSIVE -> Only Monitor
  uvm_active_passive_enum is_active;
  
  extern function new(string name = "interruptSlaveAgentConfig");
endclass 
// Constructor
function interruptSlaveAgentConfig :: new(string name = "interruptSlaveAgentConfig");
  super.new(name);
endfunction


`endif
