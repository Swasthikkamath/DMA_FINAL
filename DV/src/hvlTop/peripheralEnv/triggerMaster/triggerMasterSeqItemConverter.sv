`ifndef TRIGGERMASTERSEQITEMCONVERTER_INCLUDED_
`define TRIGGERMASTERSEQITEMCONVERTER_INCLUDED_

//------------------------------------------------------------------------------
// Class: triggerMasterSeqItemConverter
// Description:
// This class is used to convert between:
// 1) triggerMasterTx (class type)
// 2) triggerStructPacket (struct type)
// It is mainly used between Driver/Monitor and BFM.
//------------------------------------------------------------------------------

class triggerMasterSeqItemConverter extends uvm_object;
  
  // Constructor
  extern function new(string name = "triggerMasterSeqItemConverter");

  // Converts class to struct
  extern static function void from_class(input triggerMasterTx inputConvHandle, output triggerStructPacket outputConvHandle);

  // Converts struct to class
  extern static function void to_class(input triggerStructPacket inputConvHandle,ref triggerMasterTx outputConvHandle);

  // Print function
  extern function void do_print(uvm_printer printer);

endclass : triggerMasterSeqItemConverter


//------------------------------------------------------------------------------
// Function: new
// Description: Constructor of converter class
//------------------------------------------------------------------------------
function triggerMasterSeqItemConverter::new(string name = "triggerMasterSeqItemConverter");
  super.new(name);
endfunction: new


//------------------------------------------------------------------------------
// Function: from_class
// Description:
// Copies data from class transaction to struct packet
// Used before sending data to BFM
//------------------------------------------------------------------------------
function void triggerMasterSeqItemConverter::from_class(input triggerMasterTx inputConvHandle,output triggerStructPacket outputConvHandle);
  
  `uvm_info("triggerMasterSeqItemConverter",$sformatf("--------------------FROM CLASS-----------------------------------------"),UVM_HIGH);
 
  outputConvHandle.trigInReq  = inputConvHandle.trigInReq; 
  outputConvHandle.trigInAck  = inputConvHandle.trigInAck;
  outputConvHandle.trigOutReq = inputConvHandle.trigOutReq; 
  outputConvHandle.trigOutAck = inputConvHandle.trigOutAck; 
  outputConvHandle.reqType    = inputConvHandle.reqTypeName;
  $display("SEQ ITEM CONV REQ TYPE IS %s",inputConvHandle.reqTypeName);
  outputConvHandle.ackType    = inputConvHandle.ackType;

endfunction : from_class 


//------------------------------------------------------------------------------
// Function: to_class
// Description:
// Copies data from struct packet to class transaction
// Used after receiving data from BFM
//------------------------------------------------------------------------------
function void triggerMasterSeqItemConverter::to_class(input triggerStructPacket inputConvHandle, ref triggerMasterTx outputConvHandle);

  `uvm_info("triggerMasterSeqItemConverter",$sformatf("--------------------TO CLASS-----------------------------------------"),UVM_HIGH);
  
  outputConvHandle.trigInReq  = inputConvHandle.trigInReq; 
  outputConvHandle.trigInAck  = inputConvHandle.trigInAck; 
  outputConvHandle.trigOutReq = inputConvHandle.trigOutReq; 
  outputConvHandle.trigOutAck = inputConvHandle.trigOutAck; 
  outputConvHandle.reqTypeName    = inputConvHandle.reqType;
  outputConvHandle.ackType    = inputConvHandle.ackType;
     
endfunction : to_class


//------------------------------------------------------------------------------
// Function: do_print
// Description:
// Prints struct packet values
//------------------------------------------------------------------------------
function void triggerMasterSeqItemConverter::do_print(uvm_printer printer);

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
