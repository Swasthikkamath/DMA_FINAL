`ifndef BOOT_GLOBALS_PKG
`define BOOT_GLOBALS_PKG
  package bootGlobalPkg;
    parameter BOOT_ADDRESS_WIDTH =32;

    typedef struct packed {bit bootEn ; bit[BOOT_ADDRESS_WIDTH-1:0]bootAddr;}bootStructPacket;
  endpackage 

`endif
