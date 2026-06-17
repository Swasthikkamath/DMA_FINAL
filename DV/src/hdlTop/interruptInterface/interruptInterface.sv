`ifndef INTERRUPTINTERFACE_INCLUDED
`define INTERRUPTINTERFACE_INCLUDED

import interruptGlobalPkg::*;
interface interruptInterface(input bit clk);

 logic [NUM_CHANNELS-1:0]irq; //each channel can issue an interrupt

endinterface

`endif
