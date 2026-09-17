`ifndef APB_IF_INCLUDED_
`define APB_IF_INCLUDED_

import apb_global_pkg::*;

//--------------------------------------------------------------------------------------------
// Interface : apb_if
// Pin-level APB signals plus clocking blocks used by the UVM proxies
//--------------------------------------------------------------------------------------------
interface apb_if (input pclk, input preset_n);

  bit psel;
  bit penable;
  bit [ADDRESS_WIDTH-1:0]paddr;
  bit pwrite;
  bit [(DATA_WIDTH/8)-1:0]pstrb;
  bit [DATA_WIDTH-1:0]pwdata;
  logic pready;
  logic [DATA_WIDTH-1:0]prdata;
  logic pslverr;
  bit [2:0]pprot;

  clocking masterDrvCb @(posedge pclk);
    default input #1 output #1;
    input  preset_n, pready, pslverr, prdata;
    output pwrite, paddr, psel, pwdata, pstrb, pprot, penable;
  endclocking

  clocking monCb @(posedge pclk);
    default input #1;
    input preset_n, pready, pslverr, prdata, pwrite, paddr, psel, pwdata, pstrb, pprot, penable;
  endclocking

endinterface : apb_if

`endif
