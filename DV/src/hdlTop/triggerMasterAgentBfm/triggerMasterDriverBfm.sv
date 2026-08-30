`ifndef TRIGGERMASTERDRIVERBFM_INCLUDED
`define TRIGGERMASTERDRIVERBFM_INCLUDED


`timescale 1ns/1ps
interface triggerMasterDriverBfm(input bit trigInAck,
  input bit trigOutReq,
  output bit trigOutAck,
  input logic[1:0]ackType,
  input bit clk,
  output bit trigInReq,
  output logic[1:0]reqType);


  import triggerGlobalPkg :: *;
  clocking triggerMasterCb @(posedge clk);
    default input #1 output #1;
    input trigInAck,trigOutReq,ackType;
    output trigInReq,trigOutAck,reqType;
  endclocking

  int flag;
  task triggerDriveToBfm(inout triggerStructPacket structPacket);
    @(triggerMasterCb);
    triggerMasterCb.trigInReq <= 1;
    triggerMasterCb.reqType <= structPacket.reqType;
    do begin
      @(triggerMasterCb);
    end while(triggerMasterCb.trigInAck != 1);
    triggerMasterCb.trigInReq <= 0;
    structPacket.trigInAck = triggerMasterCb.trigInAck;
    structPacket.ackType = ackTypeEnum'(triggerMasterCb.ackType);

  endtask

  task triggerDriveOut(inout triggerStructPacket structPacket);
    @(triggerMasterCb);
    triggerMasterCb.trigOutAck<=0;
    structPacket.trigOutAck = 0;
    do begin
      @(triggerMasterCb);
    end while(triggerMasterCb.trigOutReq != 1);
    triggerMasterCb.trigOutAck<=1;
    structPacket.trigOutAck = 1;
  endtask

endinterface

`endif
