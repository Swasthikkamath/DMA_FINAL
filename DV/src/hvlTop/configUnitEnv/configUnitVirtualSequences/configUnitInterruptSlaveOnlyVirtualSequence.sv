`ifndef CONFIG_UNIT_INTERRUPT_SLAVE_ONLY_VIRTUAL_SEQ_INCLUDED_
`define CONFIG_UNIT_INTERRUPT_SLAVE_ONLY_VIRTUAL_SEQ_INCLUDED_


//------------------------------------------------------------------------------
// Class: configUnitInterruptSlaveOnlyVirtualSequence
// Description:
//   Virtual sequence that drives only interrupt slave transactions
//   Extends the base virtual sequence 
//------------------------------------------------------------------------------


class configUnitInterruptSlaveOnlyVirtualSequence extends configUnitVirtualBaseSeq;

  // Factory registration
  `uvm_object_utils(configUnitInterruptSlaveOnlyVirtualSequence)

   // Handle for interrupt slave sequence
  interrupt_slave_seq irq_seq;

  bit[NUM_CHANNELS-1:0]irqVector;
  
   // Constructor
  function new(string name ="configUnitInterruptSlaveOnlyVirtualSequence");
    super.new(name);
  endfunction

  //------------------------------------------------------------------------------
  // Task: body
  // Description:
  //   - Creates interrupt slave sequence
  //   - Starts the sequence on interrupt slave sequencer via virtual sequencer
  //------------------------------------------------------------------------------
  task body(); 
    // Create interrupt slave sequence instance
    irq_seq = interrupt_slave_seq::type_id::create("irq_seq");

    // Start sequence on interrupt slave sequencer
    // p_sequencer refers to the virtual sequencer handle
    irq_seq.start(p_sequencer.interruptSlaveSequencerHandle);
    irqVector = irq_seq.req.irq;
  endtask

endclass

`endif
