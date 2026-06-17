`ifndef TRIGGERMASTERMONITORBFM_INCLUDED
`define TRIGGERMASTERMONITORBFM_INCLUDED
`timescale 1ns/1ps

interface triggerMasterMonitorBfm(input bit trigInReq,
                                  input logic[1:0]reqType,
                                  input bit trigInAck,
                                  input logic[1:0]ackType,
                                  input bit trigOutReq,
                                  input bit trigOutAck,input clk);

import triggerGlobalPkg :: *;

clocking triggerMasterCb @(posedge clk); 
  default input #1 output #1;
  input trigInReq,trigOutReq,reqType;
  input trigInAck,trigOutAck,ackType;
endclocking 

task triggerMasterMonitor(output triggerStructPacket packetStruct);
  
do begin 
 @(triggerMasterCb);
end while(triggerMasterCb.trigInReq != 1 || 	triggerMasterCb.trigInAck != 1);
packetStruct.trigInReq = triggerMasterCb.trigInReq;
packetStruct.reqType = reqTypeEnum'(triggerMasterCb.reqType);
packetStruct.trigInAck = triggerMasterCb.trigInAck;
packetStruct.ackType = ackTypeEnum'(triggerMasterCb.ackType);

endtask

task triggerOutMasterMonitor(output triggerStructPacket packetStruct);

do begin
 @(triggerMasterCb);
end while(triggerMasterCb.trigOutReq != 1 || triggerMasterCb.trigOutAck != 1);
packetStruct.trigOutReq = triggerMasterCb.trigOutReq;
packetStruct.trigOutAck = triggerMasterCb.trigOutAck;

endtask

 
endinterface 

`endif
