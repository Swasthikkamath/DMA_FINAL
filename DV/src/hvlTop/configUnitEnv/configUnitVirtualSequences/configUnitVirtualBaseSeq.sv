
`ifndef CONFIG_UNIT_VIRTUAL_BASE_SEQ_INCLUDED_
`define CONFIG_UNIT_VIRTUAL_BASE_SEQ_INCLUDED_

//------------------------------------------------------------------------------
// Class: configUnitVirtualBaseSeq
// Description:
//   Base virtual sequence for the Config Unit environment.
//   Provides access to the virtual sequencer and ensures proper casting from m_sequencer to p_sequencer.
//   All virtual sequences in this environment should be extended from this base sequence
//------------------------------------------------------------------------------

class configUnitVirtualBaseSeq extends uvm_sequence;
  // Factory registration
  `uvm_object_utils(configUnitVirtualBaseSeq)

  // Typed handle to virtual sequencer and enables access to all agent sequencers through p_sequencer
  `uvm_declare_p_sequencer(configUnitEnvVirtualSequencer)

// Constructor
  function new(string name = "configUnitVirtualBaseSeq");
    super.new(name);
  endfunction

  //------------------------------------------------------------------------------
  // Task: body
  // Description:
  //   - Ensures that m_sequencer is correctly cast to the expected virtual sequencer type (configUnitEnvVirtualSequencer)
  //   - Provides safety check before derived sequences use p_sequencer
  //------------------------------------------------------------------------------

  task body();
    // Cast base sequencer handle to virtual sequencer
    if (!$cast(p_sequencer, m_sequencer)) begin
      `uvm_fatal(get_type_name(),"p_sequencer cast failed. configUnitEnvVirtualSequencer not set")
    end
  endtask

endclass

`endif

 
