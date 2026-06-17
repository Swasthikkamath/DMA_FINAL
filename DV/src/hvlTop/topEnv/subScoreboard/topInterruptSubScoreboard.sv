`ifndef TOPINTERRUPTSUBSCOREBOARD_INCLUDED 
`define TOPINTERRUPTSUBSCOREBOARD_INCLUDED


class topInterruptSubScoreboard extends uvm_component;
  `uvm_component_utils(topInterruptSubScoreboard)

  uvm_tlm_analysis_fifo #(interruptSlaveTx) configUnitInterruptPathAnalysisExport;

  extern function new(string name="topInterruptSubScoreboard",uvm_component parent=null);

  extern virtual function void build_phase(uvm_phase phase);

  extern task handleInterrupt();  
endclass 


function topInterruptSubScoreboard :: new(string name="topInterruptSubScoreboard",uvm_component parent=null);
  super.new(name,parent);
endfunction 

function void topInterruptSubScoreboard :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  configUnitInterruptPathAnalysisExport = new("configUnitInterruptPathAnalysisExport", this);
endfunction

//Task name : handleInterrupt
//Description : Is used to handle interrupt port transaction
task topInterruptSubScoreboard::handleInterrupt();
  forever begin
    interruptSlaveTx interruptTx;
    
    sharedResource::interruptControl.get(1);
    configUnitInterruptPathAnalysisExport.get(interruptTx);
    
    `uvm_info("TOP_SCOREBOARD", "Interrupt received and cleared", UVM_MEDIUM)
    
    sharedResource::interruptAccessed = 0;
  end
endtask
`endif
 


