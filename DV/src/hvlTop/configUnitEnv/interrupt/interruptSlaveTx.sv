`ifndef INTERRUPTSLAVETX_INCLUDED
`define INTERRUPTSLAVETX_INCLUDED

//------------------------------------------------------------------------------
// Class: interruptSlaveTx
// Description:
//   Sequence item (transaction) for interrupt slave.
//   Contains fields representing interrupt signals.
//------------------------------------------------------------------------------

class interruptSlaveTx extends uvm_sequence_item;
  //Factory Registration
  `uvm_object_utils(interruptSlaveTx)

  bit [NUM_CHANNELS-1:0]irq;
  extern function new(string name = "interruptSlaveTx");
  extern function void do_print(uvm_printer printer);
endclass

//Constructor
function interruptSlaveTx :: new(string name = "interruptSlaveTx");
  super.new(name);
endfunction

//------------------------------------------------------------------------------
// Function: do_print
// Description:
//   Prints transaction fields (used in debug/logging)
//------------------------------------------------------------------------------
function void interruptSlaveTx::do_print(uvm_printer printer);	  
  printer.print_field("IRQ ",irq,$bits(irq),UVM_DEC);
endfunction :do_print
`endif

