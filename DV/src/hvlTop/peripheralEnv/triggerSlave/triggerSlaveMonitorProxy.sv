`ifndef TRIGGERSLAVEMONITORPROXY_INCLUDED
`define TRIGGERSLAVEMONITORPROXY_INCLUDED

//------------------------------------------------------------------------------
// Class: triggerSlaveMonitorProxy
// Description:
// This monitor collects trigger transactions from Slave BFM
// and sends them to scoreboard using analysis port.
//------------------------------------------------------------------------------

class triggerSlaveMonitorProxy extends uvm_monitor;

  `uvm_component_utils(triggerSlaveMonitorProxy)

  // Virtual handle to Slave Monitor BFM
  virtual triggerSlaveMonitorBfm triggerSlaveMonitorBfmHandle;

  // Handle to Slave Agent configuration
  triggerSlaveAgentConfig triggerSlaveAgentConfigHandle;

  // Analysis port to send monitored transactions
  uvm_analysis_port #(triggerSlaveTx) triggerSlaveMonitorAnalysisPort;

  // Analysis port to send monitored transactions
  uvm_analysis_port #(triggerSlaveTx) triggerOutSlaveMonitorAnalysisPort;

  //Flag declaration to ensure only one trig out monitored
  bit flag;
  // Constructor
  extern function new(string name = "triggerSlaveMonitorProxy",uvm_component parent = null);

  // Build phase
  extern virtual function void build_phase(uvm_phase phase);

  // Run phase
  extern virtual task run_phase(uvm_phase phase);

endclass


//------------------------------------------------------------------------------
// Function: new
// Description: Constructor of slave monitor proxy
//------------------------------------------------------------------------------
function triggerSlaveMonitorProxy ::new(string name = "triggerSlaveMonitorProxy", uvm_component parent = null);
  super.new(name,parent);
endfunction

//------------------------------------------------------------------------------
// Function: build_phase
// Description:
// 1. Get BFM handle from config
// 2. Create analysis port
//------------------------------------------------------------------------------
function void triggerSlaveMonitorProxy ::build_phase(uvm_phase phase);
  super.build_phase(phase);

  // Assign BFM handle from config
  triggerSlaveMonitorBfmHandle = triggerSlaveAgentConfigHandle.triggerSlaveMonitorBfmHandle;

  // Create analysis port
  triggerSlaveMonitorAnalysisPort = new("triggerSlaveMonitorAnalysisPort",this);

  //create analysis port
  triggerOutSlaveMonitorAnalysisPort = new("triggerOutSlaveMonitorAnalysisPort",this);

endfunction

//------------------------------------------------------------------------------
// Task: run_phase
// Description:
// 1. Get struct packet from BFM
// 2. Convert struct to class
// 3. Send transaction to scoreboard
//------------------------------------------------------------------------------

task triggerSlaveMonitorProxy ::run_phase(uvm_phase phase);

  // Struct packet to collect data from BFM
  triggerStructPacket triggerStructPacketHandle;
  triggerStructPacket triggerOutStructPacketHandle;
  // Class transaction
  triggerSlaveTx req;
  triggerSlaveTx req1;
  super.run_phase(phase);
  fork
    forever  begin
      // Create transaction object
      req = triggerSlaveTx :: type_id :: create("req");

      // Collect trigger packet from BFM
      triggerSlaveMonitorBfmHandle.triggerSlaveMonitor(triggerStructPacketHandle);

      // Convert struct to class transaction
      triggerSlaveSeqItemConverter::to_class(triggerStructPacketHandle, req);

      // Send transaction to analysis port
      triggerSlaveMonitorAnalysisPort.write(req);
    end

    forever begin
      // Create transaction object
      req1 = triggerSlaveTx :: type_id :: create("req1");
      triggerSlaveMonitorBfmHandle.triggerOutSlaveMonitor(triggerOutStructPacketHandle);
      triggerSlaveSeqItemConverter::to_class(triggerOutStructPacketHandle, req1);
      triggerOutSlaveMonitorAnalysisPort.write(req1);
    end
  join
endtask

`endif
