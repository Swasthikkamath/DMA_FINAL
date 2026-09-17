`ifndef TRIGGERINTERFACE_INCLUDED
`define TRIGGERINTERFACE_INCLUDED

interface triggerInterface(input bit clk);
 wire trigInReq;
 wire[1:0] reqType;
 wire trigInAck;
 wire[1:0] ackType;

 wire trigOutReq;
 wire trigOutAck;
endinterface 

`endif
