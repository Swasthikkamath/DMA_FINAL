`ifndef TRIGGERSLAVEDRIVERPROXY_INCLUDED
`define TRIGGERSLAVEDRIVERPROXY_INCLUDED 

//------------------------------------------------------------------------------
// Class: triggerSlaveDriverProxy
// Description:
// This driver receives triggerSlaveTx transactions
// and sends them to Slave BFM.
//------------------------------------------------------------------------------

class triggerSlaveDriverProxy extends uvm_driver#(triggerSlaveTx);

  `uvm_component_utils(triggerSlaveDriverProxy)

  // Virtual handle to Slave Driver BFM
  virtual triggerSlaveDriverBfm triggerSlaveDriverBfmHandle;

  // Handle to Slave Agent configuration
  triggerSlaveAgentConfig triggerSlaveAgentConfigHandle;
  
  // Constructor
  extern function new(string name = "triggerSlaveDriverProxy",uvm_component parent = null);

  // Build phase
  extern virtual function void build_phase(uvm_phase phase);

  // Run phase
  extern virtual task run_phase(uvm_phase phase);

endclass 


//------------------------------------------------------------------------------
// Function: new
// Description: Constructor of slave driver proxy
//------------------------------------------------------------------------------
function triggerSlaveDriverProxy ::new(string name = "triggerSlaveDriverProxy",uvm_component parent = null);
  super.new(name,parent);
endfunction

//------------------------------------------------------------------------------
// Function: build_phase
// Description: Gets BFM handle from slave agent config
//------------------------------------------------------------------------------

function void triggerSlaveDriverProxy ::build_phase(uvm_phase phase);
  super.build_phase(phase);

  // Assign BFM handle from config
  triggerSlaveDriverBfmHandle = triggerSlaveAgentConfigHandle.triggerSlaveDriverBfmHandle;
endfunction  


//------------------------------------------------------------------------------
// Task: run_phase
// Description:
// Forever loop to handle slave transactions.
//------------------------------------------------------------------------------
task triggerSlaveDriverProxy ::
     run_phase(uvm_phase phase);

  super.run_phase(phase);

  forever begin

    // Struct packet handle for communication with BFM
    triggerStructPacket triggerStructPacketHandle;

    seq_item_port.get_next_item(req);

      `uvm_info(get_type_name(),$sformatf("TriggerSlave-TX\n %s",req.sprint),UVM_DEBUG);
  
      triggerSlaveSeqItemConverter::from_class(req, triggerStructPacketHandle);

      //triggerSlaveDriverBfmHandle.triggerDriveToBfm(...);

      triggerSlaveSeqItemConverter::to_class(triggerStructPacketHandle, req);

      `uvm_info(get_type_name(),$sformatf("AFTER :: received req packet in Trigger Slave Driver \n %s",req.sprint()),UVM_DEBUG);

      seq_item_port.item_done();

  end

endtask 

`endif
