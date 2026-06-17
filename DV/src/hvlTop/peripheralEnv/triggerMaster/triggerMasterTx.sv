`ifndef TRIGGERMASTERTX_INCLUDED
`define TRIGGERMASTERTX_INCLUDED

//------------------------------------------------------------------------------
// Class: triggerMasterTx
// Description: 
// This class is used to create a trigger transaction.
// It contains request and acknowledge signals for trigger interface.
//------------------------------------------------------------------------------

class triggerMasterTx extends uvm_sequence_item;

  `uvm_object_utils(triggerMasterTx)

  // Variable: reqType
  // Type: reqTypeEnum
  // Description: Type of trigger request
  rand reqTypeEnum reqTypeName;

  // Variable: trigInReq
  // Type: bit
  // Description: Trigger input request signal
  bit trigInReq;

  // Variable: trigInAck
  // Type: bit
  // Description: Trigger input acknowledge signal
  bit trigInAck;

  // Variable: trigOutReq
  // Type: bit
  // Description: Trigger output request signal
  bit trigOutReq;

  // Variable: trigOutAck
  // Type: bit
  // Description: Trigger output acknowledge signal
  bit trigOutAck;

  // Variable: ackType
  // Type: ackTypeEnum
  // Description: Type of acknowledge
  ackTypeEnum ackType;

  // Constructor
  extern function new(string name ="triggerMasterTx");

  // Print function
  extern function void do_print(uvm_printer printer);

endclass


//------------------------------------------------------------------------------
// Function: new
// Description: Constructor of the class
//------------------------------------------------------------------------------
function triggerMasterTx :: new(string name ="triggerMasterTx");
  super.new(name);
endfunction 


//------------------------------------------------------------------------------
// Function: do_print
// Description: Prints all transaction values
//------------------------------------------------------------------------------
function void triggerMasterTx::do_print(uvm_printer printer);
	  
  printer.print_field("ReqType",        reqTypeName,     $bits(reqTypeName),     UVM_DEC);
  printer.print_field("AckType",        ackType,     $bits(ackType),     UVM_DEC);
  printer.print_field("TriggerInReq",   trigInReq,   $bits(trigInReq),   UVM_DEC);
  printer.print_field("TriggerInAck",   trigInAck,   $bits(trigInAck),   UVM_DEC);
  printer.print_field("TriggerOutReq",  trigOutReq,  $bits(trigOutReq),  UVM_DEC);
  printer.print_field("TriggerOutAck",  trigOutAck,  $bits(trigOutAck),  UVM_DEC);

endfunction : do_print

`endif
