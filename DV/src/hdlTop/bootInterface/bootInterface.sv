`ifndef BOOT_INTERFACE
`define BOOT_INTERFACE
 import bootGlobalPkg :: *;
  interface bootInterface(input clk,input rst);
    bit bootEn;
    bit [BOOT_ADDRESS_WIDTH-1:0]bootAddr;;
  endinterface

`endif
