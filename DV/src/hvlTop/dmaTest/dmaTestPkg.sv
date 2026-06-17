`ifndef DMATESTPKG_INCLUDED
`define DMATESTPKG_INCLUDED

package dmaTestPkg;
  `include "uvm_macros.svh"
  import uvm_pkg ::*;
  import peripheralEnvPkg::*;
  import triggerMasterPkg :: *;
  import triggerSlavePkg ::*;
  import axi4_master_pkg :: *;
  import axi4_slave_pkg :: *;
  import apb_master_pkg :: *;
  import configUnitEnvPkg::*;
  import topEnvPkg :: *;
  import axi4_globals_pkg::*;
  import dmaGlobalPkg::*;
  import interruptSlavePkg :: *;
  import topVirtualSeqPkg::*;
  `include "dmaReportServer.sv"
  `include "dmaBaseTest.sv"

  //HARDWARE TRIGGER IN AND TRIGGER OUT TESTCASE

  `include "dma1dBlockTransferWithContinueSrcAndDesXsizeEqAndSwTiAndSiTo.sv"

  //SINGLE TYPE

  `include "dma1dSingleTransferWithSrcAndDesXsizeEq0AndHwTiAndHiTo.sv"

  `include "dma1dSingleTransferWithSrcXsizeEq0AndDesXsizeGreaterThan0AndHwTiAndHiTo.sv"

  `include "dma1dSingleTransferWithContinueSrcXsizeGreaterThan0AndDesXsizeEq0AndHwTiAndHiTo.sv"
  `include "dma1dSingleTransferWithFillSrcXsizeGreaterThan0AndDesXsizeEq0AndHwTiAndHiTo.sv"
  `include "dma1dSingleTransferWithWrapSrcXsizeGreaterThan0AndDesXsizeEq0AndHwTiAndHiTo.sv"

  `include "dma1dSingleTransferWithContinueSrcAndDesXsizeEqAndHwTiAndHiTo.sv"
  `include "dma1dSingleTransferWithFillSrcAndDesXsizeEqAndHwTiAndHiTo.sv"
  `include "dma1dSingleTransferWithWrapSrcAndDesXsizeEqAndHwTiAndHiTo.sv"

  `include "dma1dSingleTransferWithWrapSrcGreaterThanDesXsizeAndHwTiAndHiTo.sv"
  `include "dma1dSingleTransferWithFillSrcGreaterThanDesXsizeAndHwTiAndHiTo.sv"
  `include "dma1dSingleTransferWithContinueSrcGreaterThanDesXsizeAndHwTiAndHiTo.sv"

  `include "dma1dSingleTransferWithWrapSrcSmallerThanDesXsizeAndHwTiAndHiTo.sv"
  `include "dma1dSingleTransferWithFillSrcSmallerThanDesXsizeAndHwTiAndHiTo.sv"
  `include "dma1dSingleTransferWithContinueSrcSmallerThanDesXsizeAndHwTiAndHiTo.sv"

  //BLOCK TYPE
  `include "dma1dBlockTransferWithSrcAndDesXsizeEq0AndHwTiAndHiTo.sv"

  `include "dma1dBlockTransferWithSrcXsizeEq0AndDesXsizeGreaterThan0AndHwTiAndHiTo.sv"

  `include "dma1dBlockTransferWithContinueSrcXsizeGreaterThan0AndDesXsizeEq0AndHwTiAndHiTo.sv"
  `include "dma1dBlockTransferWithFillSrcXsizeGreaterThan0AndDesXsizeEq0AndHwTiAndHiTo.sv"
  `include "dma1dBlockTransferWithWrapSrcXsizeGreaterThan0AndDesXsizeEq0AndHwTiAndHiTo.sv"

  `include "dma1dBlockTransferWithContinueSrcAndDesXsizeEqAndHwTiAndHiTo.sv"
  `include "dma1dBlockTransferWithFillSrcAndDesXsizeEqAndHwTiAndHiTo.sv"
  `include "dma1dBlockTransferWithWrapSrcAndDesXsizeEqAndHwTiAndHiTo.sv"

  `include "dma1dBlockTransferWithWrapSrcGreaterThanDesXsizeAndHwTiAndHiTo.sv"
  `include "dma1dBlockTransferWithFillSrcGreaterThanDesXsizeAndHwTiAndHiTo.sv"
  `include "dma1dBlockTransferWithContinueSrcGreaterThanDesXsizeAndHwTiAndHiTo.sv"

  `include "dma1dBlockTransferWithWrapSrcSmallerThanDesXsizeAndHwTiAndHiTo.sv"
  `include "dma1dBlockTransferWithFillSrcSmallerThanDesXsizeAndHwTiAndHiTo.sv"
  `include "dma1dBlockTransferWithContinueSrcSmallerThanDesXsizeAndHwTiAndHiTo.sv"

  //==================================================================
  // 2D BLOCK TRANSFER TESTCASES (all XTYPE x YTYPE combinations)
  //==================================================================
  `include "2d/dma2dBlockTransferWithXContinueYContinueAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueYWrapAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueYFillAndHwTiAndHiTo.sv"

  `include "2d/dma2dBlockTransferWithXWrapYContinueAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapYWrapAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapYFillAndHwTiAndHiTo.sv"

  `include "2d/dma2dBlockTransferWithXFillYContinueAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillYWrapAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillYFillAndHwTiAndHiTo.sv"

endpackage

`endif
