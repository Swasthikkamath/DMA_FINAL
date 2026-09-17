`ifndef TRIGGERSLAVEDRIVERBFM_INCLUDED
`define TRIGGERSLAVEDRIVERBFM_INCLUDED

`timescale 1ns/1ps
interface triggerSlaveDriverBfm(input bit trigInReq, output wire trigOutReq, input bit trigOutAck,input wire[1:0]reqType,output wire trigInAck,output wire[1:0]ackType,input bit clk);

import triggerGlobalPkg :: *;

clocking triggerSlaveCb @(posedge clk); 
  default input #1 output #1;
  input trigInReq,trigOutAck,reqType;
  output trigInAck,trigOutReq,ackType;
endclocking 


task respondToReq(inout triggerStructPacket packetStruct);

 do begin 
  @(triggerSlaveCb);
 end while(triggerSlaveCb.trigInReq != 1);

 triggerSlaveCb.trigInAck <=1;
 triggerSlaveCb.ackType <= packetStruct.ackType;
 packetStruct.trigInReq = triggerSlaveCb.trigInReq;
 packetStruct.reqType = reqTypeEnum'(triggerSlaveCb.reqType);
endtask


endinterface 

`endif
