`ifndef TRIGGERINTERFACE_INCLUDED
`define TRIGGERINTERFACE_INCLUDED

interface triggerInterface(input bit clk);
  wire trigInReq;
  wire [1:0] reqType;
  wire trigInAck;
  wire [1:0] ackType;
  wire trigOutReq;
  wire trigOutAck;

  clocking masterDrvCb @(posedge clk);
    default input #1 output #1;
    output trigInReq, reqType, trigOutAck;
    input  trigInAck, ackType, trigOutReq;
  endclocking

  clocking slaveDrvCb @(posedge clk);
    default input #1 output #1;
    output trigInAck, ackType, trigOutReq;
    input  trigInReq, reqType, trigOutAck;
  endclocking

  clocking monCb @(posedge clk);
    default input #1;
    input trigInReq, reqType, trigInAck, ackType, trigOutReq, trigOutAck;
  endclocking

endinterface

`endif
