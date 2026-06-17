`ifndef TRIGGERMASTERMONITORPROXY_INCLUDED
`define TRIGGERMAASTERMONITORPROXY_INCLUDED 

//------------------------------------------------------------------------------
// Class: triggerMasterMonitorProxy
// Description:
// This monitor collects trigger transactions from BFM and sends them to scoreboard using analysis port.
//------------------------------------------------------------------------------

class triggerMasterMonitorProxy extends uvm_monitor;

  `uvm_component_utils(triggerMasterMonitorProxy)

  // Handle to virtual BFM monitor
  virtual triggerMasterMonitorBfm triggerMasterMonitorBfmHandle;

  // Handle to agent configuration
  triggerMasterAgentConfig triggerMasterAgentConfigHandle;

  // Analysis port to send monitored transactions
  uvm_analysis_port #(triggerMasterTx) triggerMasterMonitorAnalysisPort;
  
  //Analysis port to send monitored transactions
  uvm_analysis_port #(triggerMasterTx) triggerOutMasterMonitorAnalysisPort;

  //declare flag so that trig out is looked out for only once
  bit flag;
 
  // Constructor
  extern function new(string name = "triggerMasterMonitorProxy",uvm_component parent = null);

  // Build phase
  extern virtual function void build_phase(uvm_phase phase);

  // Run phase
  extern virtual task run_phase(uvm_phase phase);
 
endclass 


//------------------------------------------------------------------------------
// Function: new
// Description: Constructor of monitor proxy
//------------------------------------------------------------------------------
function triggerMasterMonitorProxy :: new(string name = "triggerMasterMonitorProxy",uvm_component parent = null);
  super.new(name,parent);
endfunction

//------------------------------------------------------------------------------
// Function: build_phase
// Description:
// 1. Get BFM handle from agent config
// 2. Create analysis port
//------------------------------------------------------------------------------
function void triggerMasterMonitorProxy :: build_phase(uvm_phase phase);
  super.build_phase(phase);

  // Assign BFM handle from config
  triggerMasterMonitorBfmHandle = triggerMasterAgentConfigHandle.triggerMasterMonitorBfmHandle;

  // Create analysis port
  triggerMasterMonitorAnalysisPort = new("triggerMasterMonitorAnalysisPort",this);
  
  // Create analysis port
  triggerOutMasterMonitorAnalysisPort = new("triggerOutMasterMonitorAnalysisPort",this);

endfunction  

//------------------------------------------------------------------------------
// Task: run_phase
// Description:
// 1. Get trigger struct packet from BFM
// 2. Convert struct to class
// 3. Send transaction to scoreboard using analysis port
//------------------------------------------------------------------------------

task triggerMasterMonitorProxy :: run_phase(uvm_phase phase);

  // Struct packet used to collect data from BFM
  triggerStructPacket triggerStructPacketHandle;
 
  // Struct packet used to collect data from BFM
  triggerStructPacket triggerOutStructPacketHandle;

  // Class transaction
  triggerMasterTx req;

  // Class transaction
  triggerMasterTx req1;

  super.run_phase(phase);
  
  fork
    forever  begin      
      // Create transaction object
      req = triggerMasterTx :: type_id :: create("req");
  
      // Collect trigger packet from BFM
      triggerMasterMonitorBfmHandle.triggerMasterMonitor(triggerStructPacketHandle);

      // Convert struct to class transaction
      triggerMasterSeqItemConverter::to_class(triggerStructPacketHandle, req);

      // Send transaction to analysis port
      triggerMasterMonitorAnalysisPort.write(req);
    end 
  
    forever begin   
      // Create transaction object
      req1 = triggerMasterTx :: type_id :: create("req1");
      triggerMasterMonitorBfmHandle.triggerOutMasterMonitor(triggerOutStructPacketHandle);
      triggerMasterSeqItemConverter::to_class(triggerOutStructPacketHandle, req1);
      triggerOutMasterMonitorAnalysisPort.write(req1);
    end 
  join
 
endtask 

`endif
