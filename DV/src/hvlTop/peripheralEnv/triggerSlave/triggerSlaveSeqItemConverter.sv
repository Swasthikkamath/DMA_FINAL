`ifndef TRIGGERSLAVESEQITEMCONVERTER_INCLUDED_
`define TRIGGERSLAVESEQITEMCONVERTER_INCLUDED_

//------------------------------------------------------------------------------
// Class: triggerSlaveSeqItemConverter
// Description:
// This class converts trigger transaction between
// class format (triggerSlaveTx) and
// struct format (triggerStructPacket).
//------------------------------------------------------------------------------

class triggerSlaveSeqItemConverter extends uvm_object;
  
  // Constructor
  extern function new(string name = "triggerSlaveSeqItemConverter");

  // Convert class transaction to struct
  extern static function void from_class(input triggerSlaveTx inputConvHandle, output triggerStructPacket outputConvHandle);

  // Convert struct back to class transaction
  extern static function void to_class(input triggerStructPacket inputConvHandle, ref triggerSlaveTx outputConvHandle);

  // Print function
  extern function void do_print(uvm_printer printer);

endclass : triggerSlaveSeqItemConverter


//------------------------------------------------------------------------------
// Function: new
// Description: Constructor of converter class
//------------------------------------------------------------------------------
function triggerSlaveSeqItemConverter::new(string name = "triggerSlaveSeqItemConverter");
  super.new(name);
endfunction: new


//------------------------------------------------------------------------------
// Function: from_class
// Description:
// Copy values from class object to struct.
// Used before sending data to BFM.
//------------------------------------------------------------------------------
function void triggerSlaveSeqItemConverter::from_class(input triggerSlaveTx inputConvHandle,output triggerStructPacket outputConvHandle);
  
  `uvm_info("triggerSlaveSeqItemConverter",$sformatf("--------------------FROM CLASS-----------------------------------------"),UVM_HIGH);
 
  outputConvHandle.trigInReq  = inputConvHandle.trigInReq; 
  outputConvHandle.trigInAck  = inputConvHandle.trigInAck; 
  outputConvHandle.trigOutReq = inputConvHandle.trigOutReq; 
  outputConvHandle.trigOutAck = inputConvHandle.trigOutAck; 
  outputConvHandle.reqType    = inputConvHandle.reqType;
  outputConvHandle.ackType    = inputConvHandle.ackType;

endfunction : from_class 


//------------------------------------------------------------------------------
// Function: to_class
// Description:
// Copy values from struct to class object.
// Used after receiving data from BFM.
//------------------------------------------------------------------------------
function void triggerSlaveSeqItemConverter::to_class(input triggerStructPacket inputConvHandle, ref triggerSlaveTx outputConvHandle);

  `uvm_info("triggerSlaveSeqItemConverter",$sformatf("--------------------TO CLASS-----------------------------------------"),UVM_HIGH);
  
  outputConvHandle.trigInReq  = inputConvHandle.trigInReq; 
  outputConvHandle.trigInAck  = inputConvHandle.trigInAck; 
  outputConvHandle.trigOutReq = inputConvHandle.trigOutReq; 
  outputConvHandle.trigOutAck = inputConvHandle.trigOutAck; 
  outputConvHandle.reqType    = inputConvHandle.reqType;
  outputConvHandle.ackType    = inputConvHandle.ackType;
     
endfunction : to_class


//------------------------------------------------------------------------------
// Function: do_print
// Description:
// Print struct values
//------------------------------------------------------------------------------
function void triggerSlaveSeqItemConverter::do_print(uvm_printer printer);

  triggerStructPacket triggerStructPacketHandle;
  super.do_print(printer);

  printer.print_field("ReqType",triggerStructPacketHandle.reqType,$bits(triggerStructPacketHandle.reqType),UVM_DEC);

  printer.print_field("AckType",triggerStructPacketHandle.ackType,$bits(triggerStructPacketHandle.ackType),UVM_DEC);

  printer.print_field("TriggerInReq",triggerStructPacketHandle.trigInReq,$bits(triggerStructPacketHandle.trigInReq),UVM_DEC);

  printer.print_field("TriggerInAck",triggerStructPacketHandle.trigInAck,$bits(triggerStructPacketHandle.trigInAck),UVM_DEC);

  printer.print_field("TriggerOutReq",triggerStructPacketHandle.trigOutReq,$bits(triggerStructPacketHandle.trigOutReq),UVM_DEC);

  printer.print_field("TriggerOutAck",triggerStructPacketHandle.trigOutAck,$bits(triggerStructPacketHandle.trigOutAck),UVM_DEC);

endfunction : do_print  

`endif
