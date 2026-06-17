`ifndef TOPENV_INCLUDED 
`define TOPENV_INCLUDED 

//------------------------------------------------------------------------------
// Class: topEnv
// Description:
//   Top-level UVM environment.
//   Integrates config unit, peripheral environments, scoreboard,
//   virtual sequencer, and register model connections.
//------------------------------------------------------------------------------

class topEnv extends uvm_env;
   // Factory registration
  `uvm_component_utils(topEnv)
  // Environment configuration handle
   topEnvConfig topEnvConfigHandle;
  
   //dmaControllerEnv dmaControllerEnvHandle;
  
   // Sub-environments
   configUnitEnv  configUnitEnvHandle;
   peripheralEnv peripheralEnvHandle[];
  
  //Scoreboard Handle
   topScoreboard topScoreboardHandle;
  
  //Virtual Sequencer Handle
   topEnvVirtualSequencer topEnvVirtualSequencerHandle;
  
   //reg block instantiation 
   reg_block_top regmodel;  
   
   //adapter instantiation
   apb_master_adapter adapter_inst; 
   
   uvm_reg_predictor#(apb_master_tx) topPredictor;

   extern function new(string  name = "topEnv",uvm_component parent = null);
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);  

endclass

// Constructor
function topEnv :: new(string name = "topEnv",uvm_component parent = null);
  super.new(name,parent);
endfunction 

//------------------------------------------------------------------------------
// Function: build_phase
// Description:
//   - Get top-level config
//   - Create sub-environments
//   - Setup virtual sequencer and scoreboard
//------------------------------------------------------------------------------
function void topEnv::build_phase(uvm_phase phase);
  super.build_phase(phase);
// Get configuration from config_db
  if(!(uvm_config_db #(topEnvConfig) :: get(this,"" ,"topEnvConfigHandle",topEnvConfigHandle)))begin 
    `uvm_fatal("TOPENV","FAILED TO GETTOP ENV CONFIG")
  end 
  
//  uvm_config_db #(dmaControllerEnvConfig)::set(this,"dmaControllerEnvHandle","dmaControllerEnvConfig",topEnvConfigHandle.dmaControllerEnvConfigHandle); 
  
  // Pass config to config unit env
  uvm_config_db #(configUnitEnvConfig) :: set(this,"configUnitEnvHandle","configUnitEnvConfigHandle",topEnvConfigHandle.configUnitEnvConfigHandle); 

 // dmaControllerEnvHandle = dmaControllerEnv :: type_id :: create("dmaControllerEnvHandle",this);
  
  // Create virtual sequencer depending on configuration
  if(topEnvConfigHandle.hasVirtualSequencer==1)begin
    topEnvVirtualSequencerHandle = topEnvVirtualSequencer :: type_id :: create("topEnvVirtualSequencerHandle",this);
  end 
  
  // Create peripheral environments (array)
  peripheralEnvHandle = new[axi4_globals_pkg::NO_OF_SLAVES]; 
  topEnvVirtualSequencerHandle.peripheralEnvVirtualSequencerHandle = new[axi4_globals_pkg::NO_OF_SLAVES];
  
  foreach(peripheralEnvHandle[i]) begin 
    // Pass config to each peripheral env
    uvm_config_db #(peripheralEnvConfig) :: set(this,$sformatf("peripheralEnvHandle[%0d]",i),"peripheralEnvConfigHandle",topEnvConfigHandle.peripheralEnvConfigHandle); 
    
    peripheralEnvHandle[i] = peripheralEnv :: type_id :: create($sformatf("peripheralEnvHandle[%0d]",i),this); 
   peripheralEnvHandle[i].peripheralNum = i;
  end 
  // Create config unit env
  configUnitEnvHandle = configUnitEnv :: type_id :: create("configUnitEnvHandle",this);
  
  // Create adapter and predictor
  adapter_inst = apb_master_adapter :: type_id :: create("adapter_inst");
  topPredictor = uvm_reg_predictor#(apb_master_tx) :: type_id :: create("topPredictor",this);
  
  // Create scoreboard based on configuration
  if(topEnvConfigHandle.hasScoreboard==1)begin
    topScoreboardHandle = topScoreboard :: type_id :: create("topScoreboardHandle",this);
    uvm_config_db #(topEnvConfig) :: set(this ,"topScoreboardHandle","topEnvConfigHandle",topEnvConfigHandle); 
  end 
endfunction 

//------------------------------------------------------------------------------
// Function: connect_phase
// Description:
//   - Connect analysis ports to scoreboard
//   - Setup register model predictor
//   - Connect virtual sequencers
//------------------------------------------------------------------------------
function void topEnv::connect_phase(uvm_phase phase);
  // Connect analysis ports to scoreboard
  if(topEnvConfigHandle.hasScoreboard == 1)begin
    configUnitEnvHandle.apbPathAnalysisPort.connect(topScoreboardHandle.configUnitApbPathAnalysisExport);
    configUnitEnvHandle.interruptPathAnalysisPort.connect(topScoreboardHandle.configUnitInterruptPathAnalysisExport);   
    
    foreach(peripheralEnvHandle[i]) begin     
      // AXI master & slave path connections
      peripheralEnvHandle[i].axi4MasterPathWriteAddressAnalysisPort.connect(topScoreboardHandle.peripheralUnitAxi4MasterPathWriteAddressAnalysisExport[i]);
	  peripheralEnvHandle[i].axi4MasterPathWriteDataAnalysisPort.connect(topScoreboardHandle.peripheralUnitAxi4MasterPathWriteDataAnalysisExport[i]);
	  peripheralEnvHandle[i].axi4MasterPathWriteResponseAnalysisPort.connect(topScoreboardHandle.peripheralUnitAxi4MasterPathWriteResponseAnalysisExport[i]);
	  peripheralEnvHandle[i].axi4MasterPathReadAddressAnalysisPort.connect(topScoreboardHandle.peripheralUnitAxi4MasterPathReadAddressAnalysisExport[i]);
	  peripheralEnvHandle[i].axi4MasterPathReadDataAnalysisPort.connect(topScoreboardHandle.peripheralUnitAxi4MasterPathReadDataAnalysisExport[i]);
	  peripheralEnvHandle[i].axi4SlavePathWriteAddressAnalysisPort.connect(topScoreboardHandle.peripheralUnitAxi4SlavePathWriteAddressAnalysisExport[i]);
	  peripheralEnvHandle[i].axi4SlavePathWriteDataAnalysisPort.connect(topScoreboardHandle.peripheralUnitAxi4SlavePathWriteDataAnalysisExport[i]);
	  peripheralEnvHandle[i].axi4SlavePathWriteResponseAnalysisPort.connect(topScoreboardHandle.peripheralUnitAxi4SlavePathWriteResponseAnalysisExport[i]);
	  peripheralEnvHandle[i].axi4SlavePathReadAddressAnalysisPort.connect(topScoreboardHandle.peripheralUnitAxi4SlavePathReadAddressAnalysisExport[i]);
	  peripheralEnvHandle[i].axi4SlavePathReadDataAnalysisPort.connect(topScoreboardHandle.peripheralUnitAxi4SlavePathReadDataAnalysisExport[i]);
      // Trigger connections
          peripheralEnvHandle[i].triggerMasterPathAnalysisPort.connect(topScoreboardHandle.peripheralUnitTriggerMasterPathAnalysisExport[i]);
	  peripheralEnvHandle[i].triggerSlavePathAnalysisPort.connect(topScoreboardHandle.peripheralUnitTriggerSlavePathAnalysisExport[i]);
          peripheralEnvHandle[i].triggerOutMasterPathAnalysisPort.connect(topScoreboardHandle.peripheralUnitTriggerOutMasterPathAnalysisExport[i]);
          peripheralEnvHandle[i].triggerOutSlavePathAnalysisPort.connect(topScoreboardHandle.peripheralUnitTriggerOutSlavePathAnalysisExport[i]);
        
   end 
  end

  configUnitEnvHandle.apbPathAnalysisPort.connect(topPredictor.bus_in);
  
  topPredictor.map = topEnvConfigHandle.regBlockHandle.address_map;
  topPredictor.adapter = adapter_inst;
  topEnvConfigHandle.regBlockHandle.address_map.set_sequencer(configUnitEnvHandle.apbMasterAgentHandle.apb_master_seqr_h,adapter_inst);
  topEnvConfigHandle.regBlockHandle.address_map.set_auto_predict(0);
  
  // Virtual sequencer connections
  if(topEnvConfigHandle.hasVirtualSequencer == 1) begin 
   foreach(topEnvVirtualSequencerHandle.peripheralEnvVirtualSequencerHandle[i])begin 
     if(topEnvConfigHandle.peripheralEnvConfigHandle.hasVirtualSequencer==1) begin 
       topEnvVirtualSequencerHandle.peripheralEnvVirtualSequencerHandle[i] = peripheralEnvHandle[i].peripheralEnvVirtualSequencerHandle;
     end 
   end 
  // Connect config unit virtual sequencer
  topEnvVirtualSequencerHandle.configUnitEnvVirtualSequencerHandle = configUnitEnvHandle.configUnitEnvVirtualSequencerHandle; 
  end 
   
endfunction 

`endif

  




  

