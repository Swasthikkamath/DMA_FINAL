`ifndef INTERRUPTSLAVEMONITORPROXY_INCLUDED
`define INTERRUPTSLAVEMONITORPROXY_INCLUDED
//------------------------------------------------------------------------------
// Class: interruptSlaveMonitorProxy
// Description:
//   Monitor proxy for interrupt slave.
//   Observes DUT activity via BFM, converts struct to class,
//   and sends transactions to analysis components.
//------------------------------------------------------------------------------
class interruptSlaveMonitorProxy extends uvm_monitor;
   //Factory Registration
  `uvm_component_utils(interruptSlaveMonitorProxy)
  
  // Virtual interface handle to monitor BFM
  virtual interruptSlaveMonitorBfm  interruptSlaveMonitorBfmHandle;
  
  //Agent config handle
  interruptSlaveAgentConfig interruptSlaveAgentConfigHandle;
  
  // Analysis port to broadcast monitored transactions
  uvm_analysis_port #(interruptSlaveTx) interruptSlaveMonitorProxyAnalysisPort;
 
  extern function new(string name = "interruptSlaveMonitorProxy",uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass

//Constructor
function interruptSlaveMonitorProxy :: new(string name = "interruptSlaveMonitorProxy",uvm_component parent =null);
  super.new(name,parent); 
endfunction 

//------------------------------------------------------------------------------
// Function: build_phase
// Description:
//   Retrieves monitor BFM and creates analysis port
//------------------------------------------------------------------------------
function void interruptSlaveMonitorProxy :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  //Get virtual interface
  if(!(uvm_config_db #(virtual interruptSlaveMonitorBfm) :: get(this,"","interruptSlaveMonitorBfm",interruptSlaveMonitorBfmHandle)))begin
    `uvm_fatal("INTERRUPT SLAVE DRIVER","FAILD TO GET BFM")
  end
  
  //create analysis port
  interruptSlaveMonitorProxyAnalysisPort = new("interruptSlaveMonitorProxyAnalysisPort",this);
endfunction

//------------------------------------------------------------------------------
// Task: run_phase
// Description:
//   - Samples DUT signals via BFM
//   - Converts struct data to class transaction
//   - Sends transaction through analysis port
//------------------------------------------------------------------------------
task interruptSlaveMonitorProxy :: run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin 
    
   // Struct packet from BFM
   interruptStructPacket interruptStructPacketHandle;
   //Transaction handle
   interruptSlaveTx req;
   req = interruptSlaveTx :: type_id :: create("slave interrupt tx"); 
    
    // Capture data from DUT via BFM
    interruptSlaveMonitorBfmHandle.interruptSlaveMonitor(interruptStructPacketHandle);
    
    // Convert struct to class
    interruptSlaveSeqItemConverter::to_class(interruptStructPacketHandle, req);
    
    // Send transaction to sb
    interruptSlaveMonitorProxyAnalysisPort.write(req);
  end 

endtask

`endif
