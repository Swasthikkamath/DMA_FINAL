`ifndef PERIPHERAL_AXI_SLAVE_ONLY_VIRTUAL_SEQ_INCLUDED_
`define PERIPHERAL_AXI_SLAVE_ONLY_VIRTUAL_SEQ_INCLUDED_

//------------------------------------------------------------------------------
// Class: peripheralAxiSlaveOnlyVirtualSequence
// Description:
// This virtual sequence runs only AXI Slave write and read sequences.
// It operates on the Peripheral Virtual Sequencer and continuously generates AXI slave traffic.
//------------------------------------------------------------------------------

class peripheralAxiSlaveOnlyVirtualSequence extends peripheralVirtualBaseSeq;

`uvm_object_utils(peripheralAxiSlaveOnlyVirtualSequence)

 // handle declaration for the peripheral axi_slave write and read
  axi4_slave_bk_write_32b_transfer_seq  axi4_slave_bk_write_32b_transfer_seq_h;
  axi4_slave_bk_read_32b_transfer_seq axi4_slave_bk_read_32b_transfer_seq_h;

 extern function new(string name ="peripheralAxiSlaveOnlyVirtualSequence");
 extern task body();

endclass: peripheralAxiSlaveOnlyVirtualSequence


//------------------------------------------------------------------------------
// Constructor
//------------------------------------------------------------------------------
function peripheralAxiSlaveOnlyVirtualSequence::new(string name ="peripheralAxiSlaveOnlyVirtualSequence");
 super.new(name);
endfunction : new


//------------------------------------------------------------------------------
// Task: body
// Description:
// 1) Calls base sequence body()
// 2) Creates AXI slave write & read sequences
// 3) Checks required sequencer handles
// 4) Starts write and read sequences in parallel forever
//------------------------------------------------------------------------------
task peripheralAxiSlaveOnlyVirtualSequence::body();
 
	super.body();

  // Create AXI slave write sequence
  axi4_slave_bk_write_32b_transfer_seq_h = axi4_slave_bk_write_32b_transfer_seq::type_id::create("axi4_slave_bk_write_32b_transfer_seq_h");

  // Create AXI slave read sequence
  axi4_slave_bk_read_32b_transfer_seq_h = axi4_slave_bk_read_32b_transfer_seq::type_id::create("axi4_slave_bk_read_32b_transfer_seq_h");

	 // Check if virtual sequencer exists
	 if (p_sequencer == null)
		     `uvm_fatal("VSEQ", "p_sequencer is NULL")

	 // Check if AXI slave read sequencer exists
	  if (p_sequencer.axi4SlaveReadSequencerHandle == null)
			    `uvm_fatal("VSEQ", "AxiSlaveReadSequencerHandle is NULL")

	 // Check if AXI slave write sequencer exists
	  if (p_sequencer.axi4SlaveWriteSequencerHandle == null)
			    `uvm_fatal("VSEQ", "AxiSlaveWriteSequencerHandle is NULL")

  // Run write and read sequences in parallel
  fork

   begin 
      forever begin
        axi4_slave_bk_write_32b_transfer_seq_h.start(p_sequencer.axi4SlaveWriteSequencerHandle);
        //axi4_slave_bk_write_32b_transfer_seq_h.start(p_sequencer.axi4_slave_write_seqr_h);
      end
   end

   begin 
     forever begin
        axi4_slave_bk_read_32b_transfer_seq_h.start(p_sequencer.axi4SlaveReadSequencerHandle);
       // axi4_slave_bk_read_32b_transfer_seq_h.start(p_sequencer.axi4_slave_read_seqr_h);
      end
   end

  join_none
	
endtask : body

`endif
