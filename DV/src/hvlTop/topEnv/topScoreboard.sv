`ifndef TOPSCOREBOARD_INCLUDED
`define TOPSCOREBOARD_INCLUDED

//--------------------------------------------------------------------------------------------
// Class: topScoreboard
// This is used to implement golden model of Corelink DMA-350 with trigger and interrupt support  
//--------------------------------------------------------------------------------------------

class topScoreboard extends uvm_scoreboard;
  `uvm_component_utils(topScoreboard)


  // sub scoreboard handles 

  topAxiSubScoreboard topAxiSubScoreboardHandle;
  topApbSubScoreboard topApbSubScoreboardHandle;
  topTriggerSubScoreboard topTriggerSubScoreboardHandle;
   topInterruptSubScoreboard   topInterruptSubScoreboardHandle ; 
  // Analysis FIFOs - AXI Master Path
  uvm_analysis_export #(axi4_master_tx) peripheralUnitAxi4MasterPathWriteAddressAnalysisExport[];
  uvm_analysis_export #(axi4_master_tx) peripheralUnitAxi4MasterPathWriteDataAnalysisExport[];
  uvm_analysis_export #(axi4_master_tx) peripheralUnitAxi4MasterPathWriteResponseAnalysisExport[];
  uvm_analysis_export #(axi4_master_tx) peripheralUnitAxi4MasterPathReadAddressAnalysisExport[];
  uvm_analysis_export #(axi4_master_tx) peripheralUnitAxi4MasterPathReadDataAnalysisExport[];
   // Analysis  - AXI Slave Path
  uvm_analysis_export #(axi4_slave_tx) peripheralUnitAxi4SlavePathWriteAddressAnalysisExport[];
  uvm_analysis_export #(axi4_slave_tx) peripheralUnitAxi4SlavePathWriteDataAnalysisExport[];
  uvm_analysis_export #(axi4_slave_tx) peripheralUnitAxi4SlavePathWriteResponseAnalysisExport[];
  uvm_analysis_export #(axi4_slave_tx) peripheralUnitAxi4SlavePathReadAddressAnalysisExport[];
  uvm_analysis_export #(axi4_slave_tx) peripheralUnitAxi4SlavePathReadDataAnalysisExport[];
  
  // Analysis FIFOs - Trigger Path
  uvm_analysis_export #(triggerMasterTx) peripheralUnitTriggerMasterPathAnalysisExport[];
  uvm_analysis_export #(triggerSlaveTx) peripheralUnitTriggerSlavePathAnalysisExport[];
   // Analysis FIFOs - Trigger Path
  uvm_analysis_export #(triggerMasterTx) peripheralUnitTriggerOutMasterPathAnalysisExport[];
  uvm_analysis_export #(triggerSlaveTx) peripheralUnitTriggerOutSlavePathAnalysisExport[];

  // Analysis FIFOs - Config Path
  uvm_analysis_export #(apb_master_tx) configUnitApbPathAnalysisExport;
  uvm_analysis_export #(interruptSlaveTx) configUnitInterruptPathAnalysisExport;
  
  // Method declarations
  extern function new(string name = "topScoreboard", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
endclass

//Function name: new
//Description : The defination component type class constructor
function topScoreboard::new(string name = "topScoreboard", uvm_component parent = null);
  super.new(name, parent);
endfunction


//Function name: build_phase
//Description : Used to create or call constructor for the tlm fifo and some dynamic array initializa//tion
function void topScoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get configuration
  if (!uvm_config_db#(topEnvConfig)::get(this, "", "topEnvConfigHandle", sharedResource::topEnvConfigHandle)) begin
    `uvm_fatal("TOP_SCOREBOARD", "FAILED TO GET TOP CONFIG IN TOP SCOREBOARD")
  end

  foreach(sharedResource::respRef[i]) begin 
    sharedResource::respRef[i] = axi4_master_tx :: type_id :: create("RESP TX");
  end  
  sharedResource::peripheralMem = axi4_slave_memory :: type_id :: create("mem"); 
  // Create analysis FIFOs
  peripheralUnitAxi4MasterPathWriteAddressAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES];
  peripheralUnitAxi4MasterPathWriteDataAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES];
  peripheralUnitAxi4MasterPathWriteResponseAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES];
  peripheralUnitAxi4MasterPathReadAddressAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES];
  peripheralUnitAxi4MasterPathReadDataAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES];
  
  peripheralUnitAxi4SlavePathWriteAddressAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES];
  peripheralUnitAxi4SlavePathWriteDataAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES];
  peripheralUnitAxi4SlavePathWriteResponseAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES];
  peripheralUnitAxi4SlavePathReadAddressAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES];
  peripheralUnitAxi4SlavePathReadDataAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES];
  
  peripheralUnitTriggerMasterPathAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES];
  peripheralUnitTriggerSlavePathAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES];
  
  peripheralUnitTriggerOutMasterPathAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES];
  peripheralUnitTriggerOutSlavePathAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES];
  
  foreach (peripheralUnitAxi4MasterPathWriteAddressAnalysisExport[i]) begin
    peripheralUnitAxi4MasterPathWriteAddressAnalysisExport[i] = 
      new($sformatf("peripheralUnitAxi4MasterPathWriteAddressAnalysisExport[%0d]", i), this);
    peripheralUnitAxi4MasterPathWriteDataAnalysisExport[i] = 
      new($sformatf("peripheralUnitAxi4MasterPathWriteDataAnalysisExport[%0d]", i), this);
    peripheralUnitAxi4MasterPathWriteResponseAnalysisExport[i] = 
      new($sformatf("peripheralUnitAxi4MasterPathWriteResponseAnalysisExport[%0d]", i), this);
    peripheralUnitAxi4MasterPathReadAddressAnalysisExport[i] = 
      new($sformatf("peripheralUnitAxi4MasterPathReadAddressAnalysisExport[%0d]", i), this);
    peripheralUnitAxi4MasterPathReadDataAnalysisExport[i] = 
      new($sformatf("peripheralUnitAxi4MasterPathReadDataAnalysisExport[%0d]", i), this);
      
    peripheralUnitAxi4SlavePathWriteAddressAnalysisExport[i] = 
      new($sformatf("peripheralUnitAxi4SlavePathWriteAddressAnalysisExport[%0d]", i), this);
    peripheralUnitAxi4SlavePathWriteDataAnalysisExport[i] = 
      new($sformatf("peripheralUnitAxi4SlavePathWriteDataAnalysisExport[%0d]", i), this);
    peripheralUnitAxi4SlavePathWriteResponseAnalysisExport[i] = 
      new($sformatf("peripheralUnitAxi4SlavePathWriteResponseAnalysisExport[%0d]", i), this);
    peripheralUnitAxi4SlavePathReadAddressAnalysisExport[i] = 
      new($sformatf("peripheralUnitAxi4SlavePathReadAddressAnalysisExport[%0d]", i), this);
    peripheralUnitAxi4SlavePathReadDataAnalysisExport[i] = 
      new($sformatf("peripheralUnitAxi4SlavePathReadDataAnalysisExport[%0d]", i), this);
      
    peripheralUnitTriggerMasterPathAnalysisExport[i] = 
      new($sformatf("peripheralUnitTriggerMasterPathAnalysisExport[%0d]", i), this);
    peripheralUnitTriggerSlavePathAnalysisExport[i] = 
      new($sformatf("peripheralUnitTriggerSlavePathAnalysisExport[%0d]", i), this);
   peripheralUnitTriggerOutMasterPathAnalysisExport[i] =new($sformatf("peripheralUnitTriggerOutMasterPathAnalysisExport[%0d]", i), this);
    peripheralUnitTriggerOutSlavePathAnalysisExport[i] =new($sformatf("peripheralUnitTriggerOutSlavePathAnalysisExport[%0d]", i), this);
  end
  
  configUnitApbPathAnalysisExport = new("configUnitApbPathAnalysisExport", this);
  configUnitInterruptPathAnalysisExport = new("configUnitInterruptPathAnalysisExport", this);
  
  // Initialize semaphores
  sharedResource::interruptControl = new(0);
  foreach (sharedResource::semaPhoreTriggerHandle[i])begin 
    sharedResource::semaPhoreTriggerHandle[i] = new(0);
    sharedResource::semaPhoreTriggerOutHandle[i] = new(0);
  end 
  
  // Initialize AXI path tracking
  sharedResource::prioritySrcPerChannel = new[axi4_globals_pkg :: NO_OF_SLAVES];
  sharedResource::priorityDesPerChannel = new[axi4_globals_pkg :: NO_OF_SLAVES];

  topAxiSubScoreboardHandle = topAxiSubScoreboard ::type_id :: create("topAxiSubScoreboardHandle",this);
  topApbSubScoreboardHandle = topApbSubScoreboard :: type_id :: create("topApbSubScoreboardHandle",this);
  topTriggerSubScoreboardHandle = topTriggerSubScoreboard :: type_id :: create("topTriggerSubScoreboard",this);
  topInterruptSubScoreboardHandle = topInterruptSubScoreboard :: type_id :: create("topInterruptSubScoreboard",this);

endfunction

function void topScoreboard :: connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    foreach(this.peripheralUnitTriggerMasterPathAnalysisExport[i]) begin 
       this.peripheralUnitTriggerMasterPathAnalysisExport[i].connect(topTriggerSubScoreboardHandle.peripheralUnitTriggerMasterPathAnalysisExport[i].analysis_export);
       this.peripheralUnitTriggerOutMasterPathAnalysisExport[i].connect(topTriggerSubScoreboardHandle.peripheralUnitTriggerOutMasterPathAnalysisExport[i].analysis_export);

    end 
   foreach(this.peripheralUnitTriggerSlavePathAnalysisExport[i]) begin
     this.peripheralUnitTriggerSlavePathAnalysisExport[i].connect(topTriggerSubScoreboardHandle.peripheralUnitTriggerSlavePathAnalysisExport[i].analysis_export);
     this.peripheralUnitTriggerOutSlavePathAnalysisExport[i].connect(topTriggerSubScoreboardHandle.peripheralUnitTriggerOutSlavePathAnalysisExport[i].analysis_export);

   end

   this.configUnitApbPathAnalysisExport.connect(topApbSubScoreboardHandle.configUnitApbPathAnalysisExport.analysis_export);

   this.configUnitInterruptPathAnalysisExport.connect(topInterruptSubScoreboardHandle.configUnitInterruptPathAnalysisExport.analysis_export);
 
   foreach(peripheralUnitAxi4MasterPathWriteAddressAnalysisExport[i]) begin 
     this.peripheralUnitAxi4MasterPathWriteAddressAnalysisExport[i].connect(topAxiSubScoreboardHandle.peripheralUnitAxi4MasterPathWriteAddressAnalysisExport[i].analysis_export);
     this.peripheralUnitAxi4MasterPathWriteDataAnalysisExport[i].connect(topAxiSubScoreboardHandle.peripheralUnitAxi4MasterPathWriteDataAnalysisExport[i].analysis_export);
this.peripheralUnitAxi4MasterPathWriteResponseAnalysisExport[i].connect(topAxiSubScoreboardHandle.peripheralUnitAxi4MasterPathWriteResponseAnalysisExport[i].analysis_export);
     this.peripheralUnitAxi4MasterPathReadAddressAnalysisExport[i].connect(topAxiSubScoreboardHandle.peripheralUnitAxi4MasterPathReadAddressAnalysisExport[i].analysis_export);
     this.peripheralUnitAxi4MasterPathReadDataAnalysisExport[i].connect(topAxiSubScoreboardHandle.peripheralUnitAxi4MasterPathReadDataAnalysisExport[i].analysis_export);
   end     

   foreach(peripheralUnitAxi4SlavePathWriteAddressAnalysisExport[i]) begin
     this.peripheralUnitAxi4SlavePathWriteAddressAnalysisExport[i].connect(topAxiSubScoreboardHandle.peripheralUnitAxi4SlavePathWriteAddressAnalysisExport[i].analysis_export);
     this.peripheralUnitAxi4SlavePathWriteDataAnalysisExport[i].connect(topAxiSubScoreboardHandle.peripheralUnitAxi4SlavePathWriteDataAnalysisExport[i].analysis_export);
     this.peripheralUnitAxi4SlavePathWriteResponseAnalysisExport[i].connect(topAxiSubScoreboardHandle.peripheralUnitAxi4SlavePathWriteResponseAnalysisExport[i].analysis_export);
     this.peripheralUnitAxi4SlavePathReadAddressAnalysisExport[i].connect(topAxiSubScoreboardHandle.peripheralUnitAxi4SlavePathReadAddressAnalysisExport[i].analysis_export);
     this.peripheralUnitAxi4SlavePathReadDataAnalysisExport[i].connect(topAxiSubScoreboardHandle.peripheralUnitAxi4SlavePathReadDataAnalysisExport[i].analysis_export);
   end


endfunction 
task topScoreboard :: run_phase(uvm_phase phase);
  super.run_phase(phase);
 
   sharedResource::initializeCommands(); 
   fork
    // APB configuration monitoring
    topApbSubScoreboardHandle.handleApbTransaction();
    
    // Interrupt monitoring
    topInterruptSubScoreboardHandle.handleInterrupt();
    
    // Trigger monitoring
    topTriggerSubScoreboardHandle.handleTriggers();

    topTriggerSubScoreboardHandle.handleTriggerOut();
 
    begin
      foreach (peripheralUnitAxi4MasterPathWriteDataAnalysisExport[i]) begin
        automatic int master_id = i;
        fork
          topAxiSubScoreboardHandle.handleAxi4MasterWrite(master_id);
          topAxiSubScoreboardHandle.handleAxi4MasterWriteResp(master_id);
        join_none
      end
    end
    
    // AXI Slave path monitoring (for each slave)
    begin
      foreach (peripheralUnitAxi4SlavePathWriteDataAnalysisExport[i]) begin
        automatic int slave_id = i;
        fork
          topAxiSubScoreboardHandle.handleAxi4SlaveRead(slave_id);
        join_none
      end
    end
  join_none


endtask 

`endif
