`ifndef CONFIGUNITENVCONFIG_INCLUDED
`define CONFIGUNITENVCONFIG_INCLUDED

//------------------------------------------------------------------------------
// Class: configUnitEnvConfig
// Description:
//   Environment configuration object that encapsulates all agent-level configurations and global //   control flags required for the config unit env.
//   This class is typically created in the test and passed via uvm_config_db.
//------------------------------------------------------------------------------
class configUnitEnvConfig extends uvm_object;
  // Registering the class with factory for object creation
  `uvm_object_utils(configUnitEnvConfig)

   // Handle for APB master agent configuration
  apb_master_agent_config apbMasterAgentConfigHandle;

  // Handle for interrupt slave agent configuration
  interruptSlaveAgentConfig interruptSlaveAgentConfigHandle;

   // Flag to indicate whether virtual sequencer is present or not
  bit  hasVirtualSequencer;

   // Constructor declaration
  extern function new(string name = "configUnitEnvConfig");
endclass

//------------------------------------------------------------------------------
// Function: new
// Description:
//   Constructor for configUnitEnvConfig
//   Initializes the object with a given name
//------------------------------------------------------------------------------
function configUnitEnvConfig :: new(string name = "configUnitEnvConfig");
  // Call base class constructor
  super.new(name);
endfunction 

`endif
 
