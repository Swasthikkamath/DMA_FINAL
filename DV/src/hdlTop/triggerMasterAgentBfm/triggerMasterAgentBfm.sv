`ifndef TRIGGERMASTERAGENTBFM_INCLUDED_
`define TRIGGERMASTERAGENTBFM_INCLUDED_

module triggerMasterAgentBfm #(parameter int SLAVE_ID = 0)(triggerInterface triggerInterfaceHandle);

   import uvm_pkg::*;

   `include "uvm_macros.svh"
   import triggerGlobalPkg :: *; 
   triggerMasterDriverBfm triggerMasterDriverBfmHandle(.trigInReq(triggerInterfaceHandle.trigInReq),.reqType(triggerInterfaceHandle.reqType),
                                                       .trigInAck(triggerInterfaceHandle.trigInAck),.ackType(triggerInterfaceHandle.ackType),
						        .clk(triggerInterfaceHandle.clk),.trigOutReq(triggerInterfaceHandle.trigOutReq),
							.trigOutAck(triggerInterfaceHandle.trigOutAck));

   triggerMasterMonitorBfm triggerMasterMonitorBfmHandle(.trigInReq(triggerInterfaceHandle.trigInReq),.reqType(triggerInterfaceHandle.reqType),
   							 .trigInAck(triggerInterfaceHandle.trigInAck),.ackType(triggerInterfaceHandle.ackType),
							 .clk(triggerInterfaceHandle.clk),.trigOutReq(triggerInterfaceHandle.trigOutReq),
							 .trigOutAck(triggerInterfaceHandle.trigOutAck));

   initial begin
   uvm_config_db#(virtual triggerMasterDriverBfm)::set(null,"*",$sformatf("triggerMasterDriverBfm[%0d]",SLAVE_ID), triggerMasterDriverBfmHandle); 
   uvm_config_db#(virtual triggerMasterMonitorBfm)::set(null,"*",$sformatf("triggerMasterMonitorBfm[%0d]",SLAVE_ID), triggerMasterMonitorBfmHandle);
  end

  initial begin
    `uvm_info("triggerMasterAgentBfm",$sformatf("Trigger Master Agent Bfm"),UVM_LOW);
  end
   
endmodule : triggerMasterAgentBfm

`endif

