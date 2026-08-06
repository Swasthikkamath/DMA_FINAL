`ifndef INTERRUPTGLOBALPKG_INCLUDED
`define INTERRUPTGLOBALPKG_INCLUDED

package interruptGlobalPkg;
 
parameter int NUM_CHANNELS=2;
typedef struct {
  bit[NUM_CHANNELS-1:0] irq;
}interruptStructPacket;

endpackage

`endif

