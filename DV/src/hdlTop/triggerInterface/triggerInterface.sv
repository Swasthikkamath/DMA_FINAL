`ifndef TRIGGERINTERFACE_INCLUDED
`define TRIGGERINTERFACE_INCLUDED

interface triggerInterface(input bit clk);
 logic trigInReq;
 logic[1:0] reqType;
 logic trigInAck;
 logic[1:0] ackType;

 logic trigOutReq;
 logic trigOutAck;
endinterface 

`endif
