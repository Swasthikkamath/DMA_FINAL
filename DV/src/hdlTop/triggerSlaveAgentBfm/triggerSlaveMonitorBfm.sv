`ifndef TRIGGERSLAVEMONITORBFM_INCLUDED
`define TRIGGERSLAVEMONITORBFM_INCLUDED


`timescale 1ns/1ps
interface triggerSlaveMonitorBfm(input bit trigInReq,input logic[1:0]reqType,input bit trigInAck,input logic[1:0]ackType,
                                 input bit trigOutReq,input bit trigOutAck,input clk);

import triggerGlobalPkg :: *;

clocking triggerSlaveCb @(posedge clk); 
  default input #1 output #1;
  input trigInReq,trigOutReq,reqType;
  input trigInAck,trigOutAck,ackType;
endclocking 

task triggerSlaveMonitor(output triggerStructPacket packetStruct);
  
do begin 
 @(triggerSlaveCb);
end while(triggerSlaveCb.trigInReq != 1 || 	triggerSlaveCb.trigInAck != 1);
packetStruct.trigInReq = triggerSlaveCb.trigInReq;
packetStruct.reqType = reqTypeEnum'(triggerSlaveCb.reqType);
packetStruct.trigInAck = triggerSlaveCb.trigInAck;
packetStruct.ackType = ackTypeEnum'(triggerSlaveCb.ackType);
  @(triggerSlaveCb); //if 2 trigger happen close by it is influencing the arbit logic
endtask

task triggerOutSlaveMonitor(output triggerStructPacket packetStruct);

do begin
 @(triggerSlaveCb);
end while(triggerSlaveCb.trigOutReq != 1 || triggerSlaveCb.trigOutAck != 1);
packetStruct.trigOutReq = triggerSlaveCb.trigOutReq;
packetStruct.trigOutAck = triggerSlaveCb.trigOutAck;

endtask



 
endinterface 

`endif
