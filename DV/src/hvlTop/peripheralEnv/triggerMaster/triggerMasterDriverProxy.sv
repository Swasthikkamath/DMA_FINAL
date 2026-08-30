`ifndef TRIGGERMASTERDRIVERPROXY_INCLUDED
`define TRIGGERMASTERDRIVERPROXY_INCLUDED

//------------------------------------------------------------------------------
// Class: triggerMasterDriverProxy
// Description:
// This driver receives trigger transactions from sequence
// and sends them to BFM (Bus Functional Model).
//------------------------------------------------------------------------------

class triggerMasterDriverProxy extends uvm_driver#(triggerMasterTx);

  `uvm_component_utils(triggerMasterDriverProxy)

  // Handle to virtual BFM interface
  virtual triggerMasterDriverBfm triggerMasterDriverBfmHandle;

  // Handle to agent configuration
  triggerMasterAgentConfig triggerMasterAgentConfigHandle;

  // Constructor
  extern function new(string name = "triggerMasterDriverProxy",uvm_component parent = null);

  // Build phase
  extern virtual function void build_phase(uvm_phase phase);

  // Run phase
  extern virtual task run_phase(uvm_phase phase);

endclass


//------------------------------------------------------------------------------
// Function: new
// Description: Constructor of driver proxy
//------------------------------------------------------------------------------
function triggerMasterDriverProxy :: new(string name = "triggerMasterDriverProxy",uvm_component parent = null);
  super.new(name,parent);
endfunction


//------------------------------------------------------------------------------
// Function: build_phase
// Description: Gets BFM handle from agent config
//------------------------------------------------------------------------------
function void triggerMasterDriverProxy :: build_phase(uvm_phase phase);
  super.build_phase(phase);

  // Assign BFM handle from config
  triggerMasterDriverBfmHandle = triggerMasterAgentConfigHandle.triggerMasterDriverBfmHandle;
endfunction


//------------------------------------------------------------------------------
// Task: run_phase
// Description:
// 1. Gets transaction from sequence
// 2. Converts class to struct
// 3. Sends to BFM
// 4. Converts back to class
// 5. Completes the item
//------------------------------------------------------------------------------
task triggerMasterDriverProxy :: run_phase(uvm_phase phase);
  super.run_phase(phase);
  fork
    forever begin
      // Struct packet handle used for BFM communication
      triggerStructPacket triggerStructPacketHandle;

      // Get next transaction from sequence
      seq_item_port.get_next_item(req);

      // Print received transaction
      `uvm_info(get_type_name(), $sformatf("TriggerMASTER-TX\n %s",req.sprint),UVM_HIGH);

      // Convert class transaction to struct
      triggerMasterSeqItemConverter::from_class(req,triggerStructPacketHandle);

      // Send struct packet to BFM
      triggerMasterDriverBfmHandle.triggerDriveToBfm(triggerStructPacketHandle);

      // Convert struct back to class
      triggerMasterSeqItemConverter::to_class(triggerStructPacketHandle, req);

      // Debug print after driving
      `uvm_info(get_type_name(), $sformatf("AFTER :: received req packet in Trigger Master Driver \n %s",req.sprint()),UVM_HIGH);

      // Inform sequence that item is done
      seq_item_port.item_done();
    end
    forever begin
      triggerStructPacket triggerStructPacketHandle;
      triggerMasterDriverBfmHandle.triggerDriveOut(triggerStructPacketHandle);
    end
  join
endtask

`endif
