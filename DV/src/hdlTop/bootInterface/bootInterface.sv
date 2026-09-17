`ifndef BOOT_INTERFACE
`define BOOT_INTERFACE
import bootGlobalPkg::*;

interface bootInterface(input clk, input rst);
  bit bootEn;
  bit [BOOT_ADDRESS_WIDTH-1:0] bootAddr;

  clocking masterDrvCb @(posedge clk);
    default input #1 output #1;
    output bootEn, bootAddr;
    input  rst;
  endclocking

  clocking monCb @(posedge clk);
    default input #1;
    input bootEn, bootAddr, rst;
  endclocking

  default clocking masterDrvCb;

  function automatic bit roseRst();
    return $rose(rst);
  endfunction

endinterface

`endif
