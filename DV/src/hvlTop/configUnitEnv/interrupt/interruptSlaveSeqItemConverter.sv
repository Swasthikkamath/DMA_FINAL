`ifndef INTERRUPTSLAVESEQITEMCONVERTER_INCLUDED_
`define INTERRUPTSLAVESEQITEMCONVERTER_INCLUDED_
//------------------------------------------------------------------------------
// Class: interruptSlaveSeqItemConverter
// Description:
//   Utility class to convert between sequence item (class) and
//   struct format used by BFM.
//------------------------------------------------------------------------------
class interruptSlaveSeqItemConverter extends uvm_object;
  
  extern function new(string name = "interruptSlaveSeqItemConverter");
  extern static function void from_class(input interruptSlaveTx inputConvHandle, output interruptStructPacket outputConvHandle);
  extern static function void to_class(input interruptStructPacket inputConvHandle, ref interruptSlaveTx outputConvHandle);
  extern function void do_print(uvm_printer printer);

endclass : interruptSlaveSeqItemConverter

//Constructor 
function interruptSlaveSeqItemConverter::new(string name = "interruptSlaveSeqItemConverter");
  super.new(name);
endfunction: new

//------------------------------------------------------------------------------
// Function: from_class
// Description:
//   Converts sequence item to struct for driving via BFM
//------------------------------------------------------------------------------
function void interruptSlaveSeqItemConverter::from_class(input interruptSlaveTx inputConvHandle, output interruptStructPacket outputConvHandle);
  `uvm_info("interruptSlaveSeqItemConverter",$sformatf("--------------------FROM CLASS-----------------------------------------"),UVM_HIGH);
   // Map fields from class to struct
  outputConvHandle.irq = inputConvHandle.irq; 
endfunction : from_class 
    
//------------------------------------------------------------------------------
// Function: to_class
// Description:
//   Converts struct data from BFM back to sequence item
//------------------------------------------------------------------------------

function void interruptSlaveSeqItemConverter::to_class(input interruptStructPacket inputConvHandle, ref interruptSlaveTx outputConvHandle);
  `uvm_info("interruptSlaveSeqItemConverter",$sformatf("--------------------TO CLASS-----------------------------------------"),UVM_HIGH);
  // Map fields from struct to class
  outputConvHandle.irq = inputConvHandle.irq;     
endfunction : to_class
    
//------------------------------------------------------------------------------
// Function: do_print
// Description:
//   Custom print method for debugging
//------------------------------------------------------------------------------
function void interruptSlaveSeqItemConverter::do_print(uvm_printer printer);
  interruptStructPacket interruptStructPacketHandle;
  super.do_print(printer);
   // Print IRQ field
  printer.print_field("IRQ",interruptStructPacketHandle.irq,$bits(interruptStructPacketHandle.irq),UVM_DEC);
    
endfunction : do_print  

`endif
  

