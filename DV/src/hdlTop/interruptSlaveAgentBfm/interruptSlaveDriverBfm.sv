`ifndef INTERRUPTSLAVEDRIVERBFM_INCLUDED
`define INTERRUPTSLAVEDRIVERBFM_INCLUDED
`timescale 1ns/1ps
  import interruptGlobalPkg :: *;
interface interruptSlaveDriverBfm(input bit[NUM_CHANNELS-1:0] irq,input bit clk);

clocking interruptSlaveCb @(posedge clk); 
 default input #1 output #1;
 input irq; 
endclocking 

task waitForIrq(inout interruptStructPacket packetStruct);
 @(interruptSlaveCb); //TO GIVE ENOUGH TIME FOR SETTLING OF VALUE
 do begin
   @(interruptSlaveCb);
 end while((|interruptSlaveCb.irq)!=1);
 packetStruct.irq = interruptSlaveCb.irq;
endtask

endinterface 

`endif
