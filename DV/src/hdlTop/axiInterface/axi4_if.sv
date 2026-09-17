`ifndef AXI4_IF_INCLUDED_
`define AXI4_IF_INCLUDED_

// Import axi4_globals_pkg 
import axi4_globals_pkg::*;

//--------------------------------------------------------------------------------------------
// Interface : axi4_if
// Declaration of pin level signals for axi4 interface
//--------------------------------------------------------------------------------------------
interface axi4_if(input aclk, input aresetn);

  //Write_address_channel
  wire     [3: 0] awid     ;
  wire     [ADDRESS_WIDTH-1: 0] awaddr ;
  wire     [7: 0] awlen     ;
  wire     [2: 0] awsize    ;
  wire     [1: 0] awburst   ;
  wire     [1: 0] awlock    ;
  wire     [3: 0] awcache   ;
  wire     [2: 0] awprot    ;
  wire     [3:0] awqos      ;
  wire     [3:0] awregion   ;
  wire           awuser     ;
  wire            awvalid   ;
  wire		         awready   ;
  //Write_data_channel
  wire     [DATA_WIDTH-1: 0] wdata     ;
  wire     [(DATA_WIDTH/8)-1: 0] wstrb ;
  wire            wlast     ;
  wire      [3:0] wuser     ;
  wire            wvalid    ;
 	wire            wready    ;
  //Write Response Channel
  wire     [3: 0] bid       ;
  wire     [1: 0] bresp     ;
  wire     [3: 0] buser     ;
  wire            bvalid    ;
  wire            bready    ;
  //Read Address Channel
  wire     [3: 0] arid     ;
  wire     [ADDRESS_WIDTH-1:0] araddr  ;
  wire     [7:0] arlen      ;
  wire     [2:0] arsize     ;
  wire     [1:0] arburst    ;
  wire     [1:0] arlock     ;
  wire     [3:0] arcache    ;
  wire     [2:0] arprot     ;
  wire     [3:0] arqos      ;
  wire     [3:0] arregion   ;
  wire     [3:0] aruser     ;
  wire           arvalid    ;
 	wire	          arready    ;
  //Read Data Channel
  wire     [3: 0] rid      ;
  wire     [DATA_WIDTH-1: 0] rdata     ;
  wire     [1:0] rresp      ;
  wire           rlast      ;
  wire     [3:0] ruser      ;
  wire           rvalid     ;
  wire  	        rready     ;
  

endinterface: axi4_if 

`endif
