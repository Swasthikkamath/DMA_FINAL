`ifndef BOOT_MASTER_MONITOR_BFM
`define BOOT_MASTER_MONITOR_BFM
  import bootGlobalPkg :: *;
  `timescale 1ns/1ps
  interface bootMasterMonitorBfm(input clk,input rst,input bootEn,input [BOOT_ADDRESS_WIDTH-1:0]bootAddr);
   
    default clocking bootMasterCb @(posedge clk);
      default input #1 output #1;
      input rst;
      input bootEn,bootAddr;
    endclocking 
 
    task bootMonitor(output  bootStructPacket bootStructPacketHandle);
      do begin 
       @(bootMasterCb);
      end while(!($rose(rst)));
      bootStructPacketHandle.bootAddr <= bootMasterCb.bootAddr; 
      bootStructPacketHandle.bootEn <= bootMasterCb.bootEn;
    endtask


  endinterface
 
`endif

