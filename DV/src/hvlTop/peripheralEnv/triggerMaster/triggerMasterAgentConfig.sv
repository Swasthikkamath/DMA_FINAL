`ifndef TRIGGERMASTERAGENTCONFIG_INCLUDED
`define TRIGGERMASTERAGENTCONFIG_INCLUDED

//------------------------------------------------------------------------------
// Class: triggerMasterAgentConfig
// Description:
// This class stores configuration information for Trigger Master Agent.
// It contains BFM handles and active/passive mode control.
//------------------------------------------------------------------------------

class triggerMasterAgentConfig extends uvm_object;

  `uvm_object_utils(triggerMasterAgentConfig)
  
  virtual triggerInterface vif;

  // Defines whether agent is ACTIVE or PASSIVE
  uvm_active_passive_enum is_active;

  //flag to indicate flow control
  bit flowControl;
    
  // Constructor
  extern function new(string name = "triggerMasterAgentConfig");

endclass


//------------------------------------------------------------------------------
// Function: new
// Description: Constructor of agent configuration class
//------------------------------------------------------------------------------
function triggerMasterAgentConfig ::new(string name = "triggerMasterAgentConfig");
  super.new(name);
endfunction 

`endif
