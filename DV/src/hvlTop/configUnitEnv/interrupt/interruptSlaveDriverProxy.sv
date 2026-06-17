`ifndef INTERRUPTSLAVEDRIVERPROXY_INCLUDED
`define INTERRUPTSLAVEDRIVERPROXY_INCLUDED

//------------------------------------------------------------------------------
// Class: interruptSlaveDriverProxy
// Description:
//   Driver proxy for interrupt slave.
//   Receives sequence items, converts them to struct format,
//   interacts with BFM, and drives interrupt behavior to DUT.
//------------------------------------------------------------------------------
class interruptSlaveDriverProxy extends uvm_driver #(interruptSlaveTx);
   //Factory registration 
  `uvm_component_utils(interruptSlaveDriverProxy)
  
   //virtual interface handle to BFM( driving signals)  
  virtual interruptSlaveDriverBfm interruptSlaveDriverBfmHandle;
  
  //Agent Configuration Handle
  interruptSlaveAgentConfig interruptSlaveAgentConfigHandle;

  extern function new(string name = "interruptSlaveDriverProxy",uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass

//Constructor
function interruptSlaveDriverProxy :: new(string name = "interruptSlaveDriverProxy",uvm_component parent =null);
  super.new(name,parent);

endfunction 

//------------------------------------------------------------------------------
// Function: build_phase
// Description:
//   Retrieves BFM handle from config_db
//------------------------------------------------------------------------------

function void interruptSlaveDriverProxy :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get virtual interface (BFM)
  if(!(uvm_config_db #(virtual interruptSlaveDriverBfm) :: get(this,"","interruptSlaveDriverBfm",interruptSlaveDriverBfmHandle))) begin 
    `uvm_fatal("INTERRUPT SLAVE DRIVER","FAILD TO GET BFM")
  end 
endfunction
    
//------------------------------------------------------------------------------
// Task: run_phase
// Description:
//   - Receives sequence items from sequencer
//   - Converts class to struct format for BFM
//   - Waits for interrupt event via BFM
//   - Converts response back to class
//------------------------------------------------------------------------------
task interruptSlaveDriverProxy :: run_phase(uvm_phase phase);
  super.run_phase(phase);

  forever begin
    interruptStructPacket interruptStructPacketHandle;
    //interruptStructConfig interruptStructConfigHandle;
    
    //Get next tx from the sequencer
    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name(), $sformatf("TriggerSlave-TX\n %s",req.sprint),UVM_HIGH);
    //Convert class to struct
    interruptSlaveSeqItemConverter::from_class(req, interruptStructPacketHandle);
    // Wait for interrupt event from DUT via BFM
    interruptSlaveDriverBfmHandle.waitForIrq(interruptStructPacketHandle);
    //convert struct to class
    interruptSlaveSeqItemConverter::to_class(interruptStructPacketHandle, req);
    `uvm_info(get_type_name(), $sformatf("AFTER :: received req packet in Trigger Slave Driver \n %s", req.sprint()), UVM_NONE);
    
    rsp = interruptSlaveTx :: type_id :: create("rsp");
    rsp.set_id_info(req);
    rsp.irq = req.irq; 
    // Indicate completion of transaction
    seq_item_port.item_done(rsp);
  end
endtask 

`endif
