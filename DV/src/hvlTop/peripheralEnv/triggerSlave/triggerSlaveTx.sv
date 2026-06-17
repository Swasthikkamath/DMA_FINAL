`ifndef TRIGGERSLAVETX_INCLUDED
`define TRIGGERSLAVETX_INCLUDED

//------------------------------------------------------------------------------
// Class: triggerSlaveTx
// Description:
// This class represents a Trigger Slave transaction.
// It contains trigger request and acknowledge signals
// used on the slave side of trigger interface.
//------------------------------------------------------------------------------

class triggerSlaveTx extends uvm_sequence_item;

  `uvm_object_utils(triggerSlaveTx)

  // Trigger input request signal
  bit trigInReq;

  // Trigger input acknowledge signal
  bit trigInAck;

  // Trigger output request signal
  bit trigOutReq;

  // Trigger output acknowledge signal
  bit trigOutAck;
  
  // Request type
  reqTypeEnum reqType;

  // Acknowledge type
  ackTypeEnum ackType;

  // Constructor
  extern function new(string name ="triggerSlaveTx");

  // Print function
  extern function void do_print(uvm_printer printer);

endclass


//------------------------------------------------------------------------------
// Function: new
// Description: Constructor of trigger slave transaction
//------------------------------------------------------------------------------
function triggerSlaveTx :: new(string name ="triggerSlaveTx");
 super.new(name);
endfunction 


//------------------------------------------------------------------------------
// Function: do_print
// Description: Prints all transaction fields
//------------------------------------------------------------------------
function void triggerSlaveTx::do_print(uvm_printer printer);
	  
 printer.print_field("ReqType",reqType,$bits(reqType),UVM_DEC);

 printer.print_field("AckType",ackType,$bits(ackType),UVM_DEC);

 printer.print_field("TriggerInReq",trigInReq,$bits(trigInReq),UVM_DEC);

 printer.print_field("TriggerInAck",trigInAck,$bits(trigInAck),UVM_DEC);

 printer.print_field("TriggerOutReq",trigOutReq,$bits(trigOutReq),UVM_DEC);

 printer.print_field("TriggerOutAck",trigOutAck,$bits(trigOutAck),UVM_DEC);
    
endfunction : do_print

`endif
