`ifndef AXI4_IF_INCLUDED_
`define AXI4_IF_INCLUDED_

import axi4_globals_pkg::*;

//--------------------------------------------------------------------------------------------
// Interface : axi4_if
// Pin-level AXI4 signals plus master/slave/monitor clocking blocks
//--------------------------------------------------------------------------------------------
interface axi4_if(input aclk, input aresetn);

  // Write address channel
  wire [3:0] awid;
  wire [ADDRESS_WIDTH-1:0] awaddr;
  wire [7:0] awlen;
  wire [2:0] awsize;
  wire [1:0] awburst;
  wire [1:0] awlock;
  wire [3:0] awcache;
  wire [2:0] awprot;
  wire [3:0] awqos;
  wire [3:0] awregion;
  wire awuser;
  wire awvalid;
  wire awready;
  // Write data channel
  wire [DATA_WIDTH-1:0] wdata;
  wire [(DATA_WIDTH/8)-1:0] wstrb;
  wire wlast;
  wire [3:0] wuser;
  wire wvalid;
  wire wready;
  // Write response channel
  wire [3:0] bid;
  wire [1:0] bresp;
  wire [3:0] buser;
  wire bvalid;
  wire bready;
  // Read address channel
  wire [3:0] arid;
  wire [ADDRESS_WIDTH-1:0] araddr;
  wire [7:0] arlen;
  wire [2:0] arsize;
  wire [1:0] arburst;
  wire [1:0] arlock;
  wire [3:0] arcache;
  wire [2:0] arprot;
  wire [3:0] arqos;
  wire [3:0] arregion;
  wire [3:0] aruser;
  wire arvalid;
  wire arready;
  // Read data channel
  wire [3:0] rid;
  wire [DATA_WIDTH-1:0] rdata;
  wire [1:0] rresp;
  wire rlast;
  wire [3:0] ruser;
  wire rvalid;
  wire rready;

  clocking masterDrvCb @(posedge aclk);
    default input #1step output #1step;
    output awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot, awqos, awregion, awuser, awvalid;
    output wdata, wstrb, wlast, wuser, wvalid;
    output bready;
    output arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot, arqos, arregion, aruser, arvalid;
    output rready;
    input  awready, wready, bid, bresp, buser, bvalid, arready, rid, rdata, rresp, rlast, ruser, rvalid;
  endclocking

  clocking slaveDrvCb @(posedge aclk);
    default input #1step output #1step;
    input  awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot, awqos, awvalid;
    input  wdata, wstrb, wlast, wuser, wvalid, bready;
    input  arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot, arqos, arregion, aruser, arvalid, rready;
    output awready, wready, bid, bresp, buser, bvalid, arready, rid, rdata, rresp, rlast, ruser, rvalid;
  endclocking

  clocking monCb @(posedge aclk);
    default input #1step;
    input awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot, awqos, awvalid, awready;
    input wdata, wstrb, wlast, wuser, wvalid, wready;
    input bid, bresp, buser, bvalid, bready;
    input arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot, arqos, arregion, aruser, arvalid, arready;
    input rid, rdata, rresp, rlast, ruser, rvalid, rready;
  endclocking

endinterface: axi4_if

`endif
