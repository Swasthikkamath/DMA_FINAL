//Virtual base sequence
`ifndef TOPVIRTUALBASESEQ_INCLUDED_
`define TOPVIRTUALBASESEQ_INCLUDED_

class topVirtualBaseSeq extends uvm_sequence;
  `uvm_object_utils(topVirtualBaseSeq)
  
  topEnvConfig topEnvConfigHandle;
  // Declaring p_sequencer
  `uvm_declare_p_sequencer(topEnvVirtualSequencer)
 extern function new(string name = "topVirtualBaseSeq");
 extern task body();

endclass : topVirtualBaseSeq

function topVirtualBaseSeq::new(string name = "topVirtualBaseSeq");
  super.new(name);
endfunction : new

task topVirtualBaseSeq::body();

  if(!$cast(p_sequencer, m_sequencer)) begin
    `uvm_error(get_full_name(),
      "Top virtual sequencer pointer cast failed")
  end


endtask : body

`endif
