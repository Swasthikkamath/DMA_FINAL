`ifndef INTERRUPTSLAVEDRIVERBFM_INCLUDED
`define INTERRUPTSLAVEDRIVERBFM_INCLUDED
`timescale 1ns/1ps

interface interruptSlaveDriverBfm(input bit irq,input bit clk);
import interruptGlobalPkg :: *;

clocking interruptSlaveCb @(posedge clk); 
 default input #1 output #1;
 input irq; 
endclocking 

task waitForIrq(inout interruptStructPacket packetStruct);
 do begin
   @(interruptSlaveCb);
 end while((|interruptSlaveCb.irq)!=1);
 packetStruct.irq = interruptSlaveCb.irq;
endtask

endinterface 

`endif
