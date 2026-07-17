`ifndef DMA2DBLOCKTRANSFERWITHADDRINCREFFFXCONTINUESRCGREATERDESXSIZEYFILLSRCSMALLERDESYSIZEANDHWTIANDHITO_INCLUDED
`define DMA2DBLOCKTRANSFERWITHADDRINCREFFFXCONTINUESRCGREATERDESXSIZEYFILLSRCSMALLERDESYSIZEANDHWTIANDHITO_INCLUDED

class dma2dBlockTransferWithAddrIncrEfffXContinueSrcGreaterDesXsizeYFillSrcSmallerDesYsizeAndHwTiAndHiTo extends dmaBaseTest;
  `uvm_component_utils(dma2dBlockTransferWithAddrIncrEfffXContinueSrcGreaterDesXsizeYFillSrcSmallerDesYsizeAndHwTiAndHiTo);
  dma1DVirtualSeq dma1DVirtualSeqHandle;
  dmaPollingVirtualSeq pollingSeq;
  extern function new(string name ="dma2dBlockTransferWithAddrIncrEfffXContinueSrcGreaterDesXsizeYFillSrcSmallerDesYsizeAndHwTiAndHiTo",uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
endclass

function dma2dBlockTransferWithAddrIncrEfffXContinueSrcGreaterDesXsizeYFillSrcSmallerDesYsizeAndHwTiAndHiTo :: new(string name ="dma2dBlockTransferWithAddrIncrEfffXContinueSrcGreaterDesXsizeYFillSrcSmallerDesYsizeAndHwTiAndHiTo",uvm_component parent = null);
  super.new(name,parent);
endfunction


function void dma2dBlockTransferWithAddrIncrEfffXContinueSrcGreaterDesXsizeYFillSrcSmallerDesYsizeAndHwTiAndHiTo::build_phase(uvm_phase phase);
  super.build_phase(phase);
  topEnvConfigHandle.numberOfCommandPerChannel.rand_mode(0);
  topEnvConfigHandle.numberOfCommandPerChannel[0]=1;
  topEnvConfigHandle.numberOfCommandPerChannel[1]=1;
  foreach(topEnvConfigHandle.allChannelConfig[i]) begin
    topEnvConfigHandle.allChannelConfig[i] = new[topEnvConfigHandle.numberOfCommandPerChannel[i]];
  end

  foreach(topEnvConfigHandle.addressIfLinking[i]) begin
    topEnvConfigHandle.addressIfLinking[i] = new[topEnvConfigHandle.numberOfCommandPerChannel[i]];
  end

  topEnvConfigHandle.randomize() with {  foreach(topEnvConfigHandle.addressIfLinking[i,j]) { topEnvConfigHandle.addressIfLinking[i][j] inside {[topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[topEnvConfigHandle.peripheralSlaveMemory].min_address : topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[topEnvConfigHandle.peripheralSlaveMemory].max_address]};}};

  //==================================================================
  // CHANNEL 0 : 2D BLOCK TRANSFER
  //   XTYPE = X_CONTINUE , YTYPE = Y_FILL
  //   X SIZE : SRCXSIZE > DESXSIZE   (CH_XSIZE = 'h0005000A -> DESXSIZE[31:16], SRCXSIZE[15:0])
  //   Y SIZE : SRCYSIZE < DESYSIZE   (CH_YSIZE = 'h00050003 -> DESYSIZE[31:16], SRCYSIZE[15:0])
  //==================================================================
  // Enable 2D on the Y dimension
  topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.YTYPE=Y_FILL;

  // TRIGGER SRC BLK SIZE
  topEnvConfigHandle.allChannelConfig[0][0].CH_SRCTRIGINCFG.SRCTRIGINBLKSIZE = 10;
  // TRIGGER SRC MODE
  topEnvConfigHandle.allChannelConfig[0][0].CH_SRCTRIGINCFG.SRCTRIGINMODE = 0;
  // Trigger SRC TYPE  (HW trigger in)
  topEnvConfigHandle.allChannelConfig[0][0].CH_SRCTRIGINCFG.SRCTRIGINTYPE = 2'b10;
  // TRIGGER SRC SEL
  topEnvConfigHandle.allChannelConfig[0][0].CH_SRCTRIGINCFG.SRCTRIGINSEL = 0;

  // TRIGGER DEST BLK SIZE
  topEnvConfigHandle.allChannelConfig[0][0].CH_DESTRIGINCFG.DESTRIGINBLKSIZE = 10;
  // TRIGGER DEST MODE
  topEnvConfigHandle.allChannelConfig[0][0].CH_DESTRIGINCFG.DESTRIGINMODE = 0;
  // Trigger DEST TYPE  (HW trigger in)
  topEnvConfigHandle.allChannelConfig[0][0].CH_DESTRIGINCFG.DESTRIGINTYPE = 2'b10;
  // TRIGGER DEST SEL
  topEnvConfigHandle.allChannelConfig[0][0].CH_DESTRIGINCFG.DESTRIGINSEL = 1;

  topEnvConfigHandle.allChannelConfig[0][0].CH_TMPLTCFG.SRCTMPLTSIZE=0;
  topEnvConfigHandle.allChannelConfig[0][0].CH_SRCTMPLT='b 100101;
  topEnvConfigHandle.allChannelConfig[0][0].CH_TMPLTCFG.DESTMPLTSIZE=0;
  topEnvConfigHandle.allChannelConfig[0][0].CH_DESTMPLT='b 11;

  // INTERRUPT CMD
  topEnvConfigHandle.allChannelConfig[0][0].CH_INTREN = 'h 703;

  // TRIGGER OUT TYPE  (HW trigger out)
  topEnvConfigHandle.allChannelConfig[0][0].CH_TRIGOUTCFG.TRIGOUTTYPE = 2'b 10;
  // TRIGGER OUT SEL
  topEnvConfigHandle.allChannelConfig[0][0].CH_TRIGOUTCFG.TRIGOUTSEL = 0;

  // XTYPE = X_CONTINUE
  topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.XTYPE = X_CONTINUE;

  topEnvConfigHandle.allChannelConfig[0][0].CH_AUTOCFG.CMDRESTARTCNT=0;
  topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.DONEPAUSEEN=0;

  // ENABLE USETRIGOUT / USESRCTRIGIN / USEDESTRIGIN
  topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.USETRIGOUT = 1;
  topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.USESRCTRIGIN =1;
  topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.USEDESTRIGIN=1;

  // CH_CTRL.TRANSIZE = 2
  topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.TRANSIZE = 2;
  topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.CHPRIO=5;
  topEnvConfigHandle.allChannelConfig[1][0].CH_CTRL.CHPRIO=7;
  topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.DONETYPE=1;
  topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.REGRELOADTYPE=5;

  // CH_SRCADDR / CH_DESADDR
  topEnvConfigHandle.allChannelConfig[0][0].CH_SRCADDR = 'd 700;
  topEnvConfigHandle.allChannelConfig[0][0].CH_DESADDR = 'd 2400;

  // X SIZE  : {DESXSIZE[31:16], SRCXSIZE[15:0]}  -> SRCXSIZE > DESXSIZE
  topEnvConfigHandle.allChannelConfig[0][0].CH_XSIZE = 'h 0005000A;
  // Y SIZE  : {DESYSIZE[31:16], SRCYSIZE[15:0]}  -> SRCYSIZE < DESYSIZE  (2D outer dimension)
  topEnvConfigHandle.allChannelConfig[0][0].CH_YSIZE = 'h 00050003;
  // Y ADDRESS STRIDE : {DESYADDRSTRIDE[31:16], SRCYADDRSTRIDE[15:0]}
  topEnvConfigHandle.allChannelConfig[0][0].CH_YADDRSTRIDE ='h 000A000A;

  topEnvConfigHandle.allChannelConfig[0][0].CH_SRCTRANSCFG.SRCMAXBURSTLEN=10;
  topEnvConfigHandle.allChannelConfig[0][0].CH_DESTRANSCFG.DESMAXBURSTLEN=6;
  topEnvConfigHandle.allChannelConfig[0][0].CH_XADDRINC='h EFFFEFFF;
  topEnvConfigHandle.allChannelConfig[0][0].CH_FILLVAL =7;

  topEnvConfigHandle.allChannelConfig[0][0].CH_CMD.DISABLECMD = 0;
  topEnvConfigHandle.allChannelConfig[0][0].CH_CMD.ENABLECMD = 1;
  topEnvConfigHandle.allChannelConfig[0][0].CH_LINKADDR.LINKADDREN =0;
  topEnvConfigHandle.allChannelConfig[0][0].CH_LINKADDR.LINKADDR = 3000;

  //==================================================================
  // CHANNEL 1 : 2D BLOCK TRANSFER  (same XTYPE/YTYPE and size relations)
  //==================================================================
  topEnvConfigHandle.allChannelConfig[1][0].CH_CTRL.YTYPE=Y_FILL;

  topEnvConfigHandle.allChannelConfig[1][0].CH_SRCTRIGINCFG.SRCTRIGINBLKSIZE = 10;
  topEnvConfigHandle.allChannelConfig[1][0].CH_SRCTRIGINCFG.SRCTRIGINMODE = 0;
  topEnvConfigHandle.allChannelConfig[1][0].CH_SRCTRIGINCFG.SRCTRIGINTYPE = 2'b10;
  topEnvConfigHandle.allChannelConfig[1][0].CH_SRCTRIGINCFG.SRCTRIGINSEL = 2;

  topEnvConfigHandle.allChannelConfig[1][0].CH_DESTRIGINCFG.DESTRIGINBLKSIZE = 10;
  topEnvConfigHandle.allChannelConfig[1][0].CH_YADDRSTRIDE ='h 000A000A;
  topEnvConfigHandle.allChannelConfig[1][0].CH_DESTRIGINCFG.DESTRIGINMODE = 0;
  topEnvConfigHandle.allChannelConfig[1][0].CH_DESTRIGINCFG.DESTRIGINTYPE = 2'b10;
  topEnvConfigHandle.allChannelConfig[1][0].CH_DESTRIGINCFG.DESTRIGINSEL = 3;

  topEnvConfigHandle.allChannelConfig[1][0].CH_TMPLTCFG.SRCTMPLTSIZE=0;
  topEnvConfigHandle.allChannelConfig[1][0].CH_SRCTMPLT='b 11;
  topEnvConfigHandle.allChannelConfig[1][0].CH_TMPLTCFG.DESTMPLTSIZE=0;
  topEnvConfigHandle.allChannelConfig[1][0].CH_DESTMPLT='b 11;

  topEnvConfigHandle.allChannelConfig[1][0].CH_INTREN = 'h 703;
  topEnvConfigHandle.allChannelConfig[1][0].CH_TRIGOUTCFG.TRIGOUTTYPE = 2'b 10;
  topEnvConfigHandle.allChannelConfig[1][0].CH_TRIGOUTCFG.TRIGOUTSEL = 2;

  // XTYPE = X_CONTINUE
  topEnvConfigHandle.allChannelConfig[1][0].CH_CTRL.XTYPE = X_CONTINUE;

  topEnvConfigHandle.allChannelConfig[1][0].CH_CTRL.USETRIGOUT = 1;
  topEnvConfigHandle.allChannelConfig[1][0].CH_CTRL.USESRCTRIGIN =1;
  topEnvConfigHandle.allChannelConfig[1][0].CH_CTRL.USEDESTRIGIN=1;
  topEnvConfigHandle.allChannelConfig[1][0].CH_CTRL.TRANSIZE = 2;
  topEnvConfigHandle.allChannelConfig[1][0].CH_CTRL.DONETYPE = 1;

  topEnvConfigHandle.allChannelConfig[1][0].CH_SRCADDR = 'd 900;
  topEnvConfigHandle.allChannelConfig[1][0].CH_DESADDR = 'd 3400;

  // X SIZE -> SRCXSIZE > DESXSIZE
  topEnvConfigHandle.allChannelConfig[1][0].CH_XSIZE = 'h 0005000A;
  // Y SIZE -> SRCYSIZE < DESYSIZE
  topEnvConfigHandle.allChannelConfig[1][0].CH_YSIZE = 'h 00050003;

  topEnvConfigHandle.allChannelConfig[1][0].CH_SRCTRANSCFG.SRCMAXBURSTLEN=10;
  topEnvConfigHandle.allChannelConfig[1][0].CH_DESTRANSCFG.DESMAXBURSTLEN=6;
  topEnvConfigHandle.allChannelConfig[1][0].CH_XADDRINC='h EFFFEFFF;
  topEnvConfigHandle.allChannelConfig[1][0].CH_FILLVAL =7;

  topEnvConfigHandle.allChannelConfig[1][0].CH_CMD.DISABLECMD = 0;
  topEnvConfigHandle.allChannelConfig[1][0].CH_CMD.ENABLECMD = 1;
  topEnvConfigHandle.allChannelConfig[1][0].CH_LINKADDR.LINKADDREN =0;
  topEnvConfigHandle.allChannelConfig[1][0].CH_LINKADDR.LINKADDR = 3000;
  topEnvConfigHandle.allChannelConfig[0][1].CH_LINKADDR.LINKADDR = 000;

  // same way you can update the needed fields for confguring the respective channels as per req
  dump_config_to_file();
  setUpCommand();

endfunction

task dma2dBlockTransferWithAddrIncrEfffXContinueSrcGreaterDesXsizeYFillSrcSmallerDesYsizeAndHwTiAndHiTo::run_phase(uvm_phase phase);
  super.run_phase(phase);
  phase.raise_objection(this);
  `uvm_info(get_type_name(),"Starting dma1DVirtualSequence (2D BLOCK transfer)",UVM_LOW)
  dma1DVirtualSeqHandle = dma1DVirtualSeq::type_id::create("dma1DVirtualSeqHandle");
  dma1DVirtualSeqHandle.topEnvConfigHandle =topEnvConfigHandle;
  dma1DVirtualSeqHandle.reqType = triggerGlobalPkg::BLOCK;
  dma1DVirtualSeqHandle.start(topEnvHandle.topEnvVirtualSequencerHandle);
  phase.drop_objection(this);
endtask
`endif
