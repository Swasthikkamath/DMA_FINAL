`ifndef PERIPHERAL_TRIGGER_MASTER_ONLY_VIRTUAL_SEQ_INCLUDED_
`define PERIPHERAL_TRIGGER_MASTER_ONLY_VIRTUAL_SEQ_INCLUDED_

//------------------------------------------------------------------------------
// Class: peripheralTriggerMasterOnlyVirtualSequence
// Description:
// This virtual sequence runs only Trigger Master sequence.
// It operates on the Peripheral Virtual Sequencer and
// continuously generates trigger master transactions.
//------------------------------------------------------------------------------

class peripheralTriggerMasterOnlyVirtualSequence extends peripheralVirtualBaseSeq;

`uvm_object_utils(peripheralTriggerMasterOnlyVirtualSequence)

 // handle declaration for the peripheral TRIGGER MASTER
 triggerMasterSequence triggerMasterSequenceHandle;
  
 reqTypeEnum reqType;
 extern function new(string name ="peripheralTriggerMasterOnlyVirtualSequence");
 extern task body();

endclass: peripheralTriggerMasterOnlyVirtualSequence


//------------------------------------------------------------------------------
// Constructor
//------------------------------------------------------------------------------
function peripheralTriggerMasterOnlyVirtualSequence::new(string name ="peripheralTriggerMasterOnlyVirtualSequence");
 super.new(name);
endfunction : new


//------------------------------------------------------------------------------
// Task: body
// Description:
// 1) Creates Trigger Master sequence
// 2) Checks virtual sequencer and trigger sequencer handles
// 3) Starts Trigger Master sequence continuously
//------------------------------------------------------------------------------
task peripheralTriggerMasterOnlyVirtualSequence::body();
  
   // Create Trigger Master sequence
   triggerMasterSequenceHandle =  triggerMasterSequence::type_id::create("triggerMasterSequenceHandle") ;

   // Check if virtual sequencer exists
   if (p_sequencer == null)
	    `uvm_fatal("VSEQ", "p_sequencer is NULL")

   // Check if Trigger Master sequencer exists
	  if (p_sequencer.triggerMasterSequencerHandle == null)
			    `uvm_fatal("VSEQ", "triggerMasterSequencerHandle is NULL")

  // Run trigger master sequence in paralle
  fork
   begin
     triggerMasterSequenceHandle.reqType = reqType;
     forever begin 
        triggerMasterSequenceHandle.start(p_sequencer.triggerMasterSequencerHandle);
     end
   end
  join_none

endtask : body

`endif
