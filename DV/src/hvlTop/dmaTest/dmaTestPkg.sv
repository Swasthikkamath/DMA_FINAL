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
  // 2D BLOCK TRANSFER TESTCASES
  // All XTYPE x YTYPE x (SRCXSIZE vs DESXSIZE) x (SRCYSIZE vs DESYSIZE)
  // combinations  -> 3 x 3 x 3 x 3 = 81 testcases
  //==================================================================
  `include "2d/dma2dBlockTransferWithXContinueSrcGreaterDesXsizeYContinueSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcGreaterDesXsizeYContinueSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcGreaterDesXsizeYContinueSrcEqualDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcGreaterDesXsizeYWrapSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcGreaterDesXsizeYWrapSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcGreaterDesXsizeYWrapSrcEqualDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcGreaterDesXsizeYFillSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcGreaterDesXsizeYFillSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcGreaterDesXsizeYFillSrcEqualDesYsizeAndHwTiAndHiTo.sv"

  `include "2d/dma2dBlockTransferWithXContinueSrcSmallerDesXsizeYContinueSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcSmallerDesXsizeYContinueSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcSmallerDesXsizeYContinueSrcEqualDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcSmallerDesXsizeYWrapSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcSmallerDesXsizeYWrapSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcSmallerDesXsizeYWrapSrcEqualDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcSmallerDesXsizeYFillSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcSmallerDesXsizeYFillSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcSmallerDesXsizeYFillSrcEqualDesYsizeAndHwTiAndHiTo.sv"

  `include "2d/dma2dBlockTransferWithXContinueSrcEqualDesXsizeYContinueSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcEqualDesXsizeYContinueSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcEqualDesXsizeYContinueSrcEqualDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcEqualDesXsizeYWrapSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcEqualDesXsizeYWrapSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcEqualDesXsizeYWrapSrcEqualDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcEqualDesXsizeYFillSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcEqualDesXsizeYFillSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXContinueSrcEqualDesXsizeYFillSrcEqualDesYsizeAndHwTiAndHiTo.sv"

  `include "2d/dma2dBlockTransferWithXWrapSrcGreaterDesXsizeYContinueSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcGreaterDesXsizeYContinueSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcGreaterDesXsizeYContinueSrcEqualDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcGreaterDesXsizeYWrapSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcGreaterDesXsizeYWrapSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcGreaterDesXsizeYWrapSrcEqualDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcGreaterDesXsizeYFillSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcGreaterDesXsizeYFillSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcGreaterDesXsizeYFillSrcEqualDesYsizeAndHwTiAndHiTo.sv"

  `include "2d/dma2dBlockTransferWithXWrapSrcSmallerDesXsizeYContinueSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcSmallerDesXsizeYContinueSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcSmallerDesXsizeYContinueSrcEqualDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcSmallerDesXsizeYWrapSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcSmallerDesXsizeYWrapSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcSmallerDesXsizeYWrapSrcEqualDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcSmallerDesXsizeYFillSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcSmallerDesXsizeYFillSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcSmallerDesXsizeYFillSrcEqualDesYsizeAndHwTiAndHiTo.sv"

  `include "2d/dma2dBlockTransferWithXWrapSrcEqualDesXsizeYContinueSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcEqualDesXsizeYContinueSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcEqualDesXsizeYContinueSrcEqualDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcEqualDesXsizeYWrapSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcEqualDesXsizeYWrapSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcEqualDesXsizeYWrapSrcEqualDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcEqualDesXsizeYFillSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcEqualDesXsizeYFillSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXWrapSrcEqualDesXsizeYFillSrcEqualDesYsizeAndHwTiAndHiTo.sv"

  `include "2d/dma2dBlockTransferWithXFillSrcGreaterDesXsizeYContinueSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcGreaterDesXsizeYContinueSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcGreaterDesXsizeYContinueSrcEqualDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcGreaterDesXsizeYWrapSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcGreaterDesXsizeYWrapSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcGreaterDesXsizeYWrapSrcEqualDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcGreaterDesXsizeYFillSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcGreaterDesXsizeYFillSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcGreaterDesXsizeYFillSrcEqualDesYsizeAndHwTiAndHiTo.sv"

  `include "2d/dma2dBlockTransferWithXFillSrcSmallerDesXsizeYContinueSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcSmallerDesXsizeYContinueSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcSmallerDesXsizeYContinueSrcEqualDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcSmallerDesXsizeYWrapSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcSmallerDesXsizeYWrapSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcSmallerDesXsizeYWrapSrcEqualDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcSmallerDesXsizeYFillSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcSmallerDesXsizeYFillSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcSmallerDesXsizeYFillSrcEqualDesYsizeAndHwTiAndHiTo.sv"

  `include "2d/dma2dBlockTransferWithXFillSrcEqualDesXsizeYContinueSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcEqualDesXsizeYContinueSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcEqualDesXsizeYContinueSrcEqualDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcEqualDesXsizeYWrapSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcEqualDesXsizeYWrapSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcEqualDesXsizeYWrapSrcEqualDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcEqualDesXsizeYFillSrcGreaterDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcEqualDesXsizeYFillSrcSmallerDesYsizeAndHwTiAndHiTo.sv"
  `include "2d/dma2dBlockTransferWithXFillSrcEqualDesXsizeYFillSrcEqualDesYsizeAndHwTiAndHiTo.sv"

endpackage

`endif
