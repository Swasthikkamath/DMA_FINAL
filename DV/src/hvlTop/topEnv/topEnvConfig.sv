`ifndef TOPENVCONFIG_INCLUDED
`define TOPENVCONFIG_INCLUDED

//------------------------------------------------------------------------------
// Class: topEnvConfig
// Description:
//   Configuration object for top environment.
//   Holds all sub-environment configs and global control flags.
//------------------------------------------------------------------------------
class topEnvConfig extends uvm_object;
  // Factory Regsitration
  `uvm_object_utils(topEnvConfig)
   
   //Enable/disable scoreboard
   bit hasScoreboard;
   // Sub Environment Config handles 
   //dmaControllerEnvConfig dmaControllerEnvConfigHandle;
   peripheralEnvConfig  peripheralEnvConfigHandle;
   configUnitEnvConfig  configUnitEnvConfigHandle;

   // Enable/disable virtual sequencer
   bit hasVirtualSequencer;
   
   // Register Model Handle
   reg_block_top regBlockHandle;
   
   // Enable flag for master 1 (optional control)
   bit m1Enabled;

   rand int numberOfCommandPerChannel[NUM_CHANNELS]; 
   dmaChannelReg allChannelConfig[NUM_CHANNELS][]; // each chhanel each command config 
   
    rand longint addressIfLinking[NUM_CHANNELS][]; 
    
    bit peripheralSlaveMemory;
    
    bit hasCoverage;

    int noOfchannels;
   
    bit m1_enabled;

/*    constraint settingNumCommandRestrict{ foreach(numberOfCommandPerChannel[i]) {
         numberOfCommandPerChannel[i]==1;            
          }
        }*/

  extern function new(string name = "topEnvConfig");

endclass 

//Constructor
function topEnvConfig :: new(string name = "topEnvConfig");
  super.new(name);
endfunction 

`endif 

