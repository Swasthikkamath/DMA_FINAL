`ifndef INTERRUPTSLAVEMONITORBFM_INCLUDED
`define INTERRUPTSLAVEMONITORBFM_INCLUDED

`timescale 1ns/1ps
interface interruptSlaveMonitorBfm(input bit irq, input bit clk);
import interruptGlobalPkg :: *;
clocking interruptSlaveCb @(posedge clk); 
 default input #1 output #1;
 input irq; 
endclocking 

task interruptSlaveMonitor(output interruptStructPacket packetStruct);
  
 do begin
 @(interruptSlaveCb);
 end while(interruptSlaveCb.irq != 1);

endtask

endinterface 

`endif

