`ifndef INTERRUPTINTERFACE_INCLUDED
`define INTERRUPTINTERFACE_INCLUDED

import interruptGlobalPkg::*;

interface interruptInterface(input bit clk);
  logic [NUM_CHANNELS-1:0] irq;

  clocking monCb @(posedge clk);
    default input #1;
    input irq;
  endclocking

endinterface

`endif
