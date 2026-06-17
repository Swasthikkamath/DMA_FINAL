`ifndef TRIGGERSLAVEAGENTCONFIG_INCLUDED
`define TRIGGERSLAVEAGENTCONFIG_INCLUDED

//------------------------------------------------------------------------------
// Class: triggerSlaveAgentConfig
// Description:
// This class stores configuration information for Trigger Slave Agent.
// It contains BFM handles and active/passive mode control.
//------------------------------------------------------------------------------

class triggerSlaveAgentConfig extends uvm_object;

  `uvm_object_utils(triggerSlaveAgentConfig)

  // Virtual handle to Slave Driver BFM
  virtual triggerSlaveDriverBfm triggerSlaveDriverBfmHandle;

  // Virtual handle to Slave Monitor BFM
  virtual triggerSlaveMonitorBfm triggerSlaveMonitorBfmHandle;

  // Defines whether slave agent works as ACTIVE or PASSIVE
  uvm_active_passive_enum is_active;

  //flag to indicate flow control
 
  bit[1:0] srcReqType;
  
  bit[1:0] desReqType; 
   
  // Constructor
  extern function new(string name = "triggerSlaveAgentConfig");

endclass


//------------------------------------------------------------------------------
// Function: new
// Description: Constructor of slave agent configuration class
//------------------------------------------------------------------------------
function triggerSlaveAgentConfig ::new(string name = "triggerSlaveAgentConfig");
  super.new(name);
endfunction 

`endif
