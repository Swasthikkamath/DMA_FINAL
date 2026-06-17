//------------------------------------------------------------------------------
// Class: interrupt_slave_seq
// Description:
//   Basic sequence to generate an interrupt transaction.
//   Creates and sends a single interrupt transaction item.
//------------------------------------------------------------------------------
class interrupt_slave_seq extends uvm_sequence #(interruptSlaveTx);
  // Factory registration
  `uvm_object_utils(interrupt_slave_seq)
  interruptSlaveTx req;
   // Constructor
  function new(string name = "interrupt_slave_seq");
    super.new(name);
  endfunction

//------------------------------------------------------------------------------
// Task: body
// Description:
//   - Creates a transaction
//   - Sends it to the driver using start_item/finish_item
//------------------------------------------------------------------------------
  virtual task body();
    //create interrupt transaction object 
    req = interruptSlaveTx::type_id::create("req");

    // Send transaction to driver
    start_item(req);
    finish_item(req);
    get_response(req);
    
    //DEBUG MSG

    `uvm_info(get_type_name(), "Interrupt asserted by slave", UVM_MEDIUM)
    `uvm_info(get_type_name(), "Interrupt deasserted by slave", UVM_MEDIUM)
  endtask

endclass
