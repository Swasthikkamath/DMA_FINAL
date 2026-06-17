`ifndef TRIGGERGLOBALPKG_INCLUDED
`define TRIGGERGLOBALPKG_INCLUDED

package triggerGlobalPkg;

typedef enum bit[1:0]{
SINGLE       = 2'b00,
LAST_SINGLE  = 2'b01,
BLOCK        = 2'b10, 
LAST_BLOCK   = 2'b11
}reqTypeEnum;

typedef enum bit[1:0]{
OKAY         = 2'b00,
LAST_OKAY    = 2'b01,
DENY         = 2'b10,
RESERVED     = 2'b11
}ackTypeEnum;

typedef struct{
    bit trigInReq;
    bit trigInAck;
    bit trigOutReq;
    bit trigOutAck;
   reqTypeEnum reqType;
   ackTypeEnum ackType;
  }triggerStructPacket;


//typedef struct{ }triggerStructConfig;

endpackage

`endif
