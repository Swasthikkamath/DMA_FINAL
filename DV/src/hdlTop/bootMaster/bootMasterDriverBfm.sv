`ifndef BOOT_MASTER_DRIVER_BFM
`define BOOT_MASTER_DRIVER_BFM
  import bootGlobalPkg :: *;
  `timescale 1ns/1ps
  interface bootMasterDriverBfm(input clk,input rst,output bootEn,output [BOOT_ADDRESS_WIDTH-1:0]bootAddr);
   
    default clocking bootMasterCb @(posedge clk);
      default input #1 output #1;
      input rst;
      output bootEn,bootAddr;
    endclocking 
 
    task bootDrive(input bootStructPacket bootStructPacketHandle);
      bootMasterCb.bootEn <=1;
      bootMasterCb.bootAddr <= bootStructPacketHandle.bootAddr;
      do begin 
       @(bootMasterCb);
      end while(!($rose(rst)));
    endtask


  endinterface
 
`endif

