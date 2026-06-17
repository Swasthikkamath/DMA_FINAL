`ifndef TRIGGERSLAVEAGENTBFM_INCLUDED_
`define TRIGGERSLAVEAGENTBFM_INCLUDED_


module triggerSlaveAgentBfm #(parameter int SLAVE_ID = 0)(triggerInterface triggerInterfaceHandle);

  //-------------------------------------------------------
  // Package : Importing Uvm Pakckage and Test Package
  //-------------------------------------------------------
  import uvm_pkg::*;
  `include "uvm_macros.svh"

   triggerSlaveDriverBfm triggerSlaveDriverBfmHandle(.trigInReq(triggerInterfaceHandle.trigInReq),.trigInAck(triggerInterfaceHandle.trigInAck),
                                                     .reqType(triggerInterfaceHandle.reqType),.ackType(triggerInterfaceHandle.ackType),
						     .clk(triggerInterfaceHandle.clk),.trigOutReq(triggerInterfaceHandle.trigOutReq),
						     .trigOutAck(triggerInterfaceHandle.trigOutAck));

   triggerSlaveMonitorBfm triggerSlaveMonitorBfmHandle(.trigInReq(triggerInterfaceHandle.trigInReq),.trigInAck(triggerInterfaceHandle.trigInAck),
   						       .reqType(triggerInterfaceHandle.reqType),.ackType(triggerInterfaceHandle.ackType),
						       .clk(triggerInterfaceHandle.clk),.trigOutReq(triggerInterfaceHandle.trigOutReq),
						       .trigOutAck(triggerInterfaceHandle.trigOutAck));

   initial begin
    uvm_config_db#(virtual triggerSlaveDriverBfm)::set(null,"*",$sformatf("triggerSlaveDriverBfm[%0d]",SLAVE_ID), triggerSlaveDriverBfmHandle); 
    uvm_config_db#(virtual triggerSlaveMonitorBfm)::set(null,"*",$sformatf("triggerSlaveMonitorBfm[%0d]",SLAVE_ID), triggerSlaveMonitorBfmHandle);
   end
   
   initial begin
    `uvm_info("Trigger slave agent bfm",$sformatf("TRIGGER SLAVE AGENT BFM"),UVM_LOW);
  end
   
endmodule : triggerSlaveAgentBfm

`endif

