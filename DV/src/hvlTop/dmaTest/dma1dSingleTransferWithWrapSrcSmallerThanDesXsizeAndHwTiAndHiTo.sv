`ifndef DMA1D_SINGLE_TRANSFER_WITH_WRAP_SRC_SMALLER_THAN_DES_XSIZE_AND_HWTI_HITO_INCLUDED
  `define DMA1D_SINGLE_TRANSFER_WITH_WRAP_SRC_SMALLER_THAN_DES_XSIZE_AND_HWTI_HITO_INCLUDED

  class dma1dSingleTransferWithWrapSrcSmallerThanDesXsizeAndHwTiAndHiTo extends dmaBaseTest;

    `uvm_component_utils(dma1dSingleTransferWithWrapSrcSmallerThanDesXsizeAndHwTiAndHiTo);
    dma1DVirtualSeq dma1DVirtualSeqHandle;
    extern function new(string name ="dma1dSingleTransferWithWrapSrcSmallerThanDesXsizeAndHwTiAndHiTo",uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);

  endclass


  function dma1dSingleTransferWithWrapSrcSmallerThanDesXsizeAndHwTiAndHiTo::new(string name ="dma1dSingleTransferWithWrapSrcSmallerThanDesXsizeAndHwTiAndHiTo",uvm_component parent = null);
    super.new(name,parent);
  endfunction


  function void dma1dSingleTransferWithWrapSrcSmallerThanDesXsizeAndHwTiAndHiTo::build_phase(uvm_phase phase);
    super.build_phase(phase);

    topEnvConfigHandle.numberOfCommandPerChannel.rand_mode(0);

    foreach(topEnvConfigHandle.allChannelConfig[i]) begin
      topEnvConfigHandle.allChannelConfig[i] =
        new[topEnvConfigHandle.numberOfCommandPerChannel[i]];
    end

    foreach(topEnvConfigHandle.addressIfLinking[i]) begin
      topEnvConfigHandle.addressIfLinking[i] =
        new[topEnvConfigHandle.numberOfCommandPerChannel[i]];
    end

    topEnvConfigHandle.randomize() with {  foreach(topEnvConfigHandle.addressIfLinking[i,j]) { topEnvConfigHandle.addressIfLinking[i][j] inside {[topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[topEnvConfigHandle.peripheralSlaveMemory].min_address : topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[topEnvConfigHandle.peripheralSlaveMemory].max_address]};}};


    // Disable 2D
    topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.YTYPE = Y_DISABLE;

    // SRC TRIGGER
    topEnvConfigHandle.allChannelConfig[0][0].CH_SRCTRIGINCFG.SRCTRIGINBLKSIZE = 10;
    topEnvConfigHandle.allChannelConfig[0][0].CH_SRCTRIGINCFG.SRCTRIGINMODE = 0;
    topEnvConfigHandle.allChannelConfig[0][0].CH_SRCTRIGINCFG.SRCTRIGINTYPE = 2'b10;
    topEnvConfigHandle.allChannelConfig[0][0].CH_SRCTRIGINCFG.SRCTRIGINSEL = 0;

    // DEST TRIGGER
    topEnvConfigHandle.allChannelConfig[0][0].CH_DESTRIGINCFG.DESTRIGINBLKSIZE = 10;
    topEnvConfigHandle.allChannelConfig[0][0].CH_DESTRIGINCFG.DESTRIGINMODE = 0;
    topEnvConfigHandle.allChannelConfig[0][0].CH_DESTRIGINCFG.DESTRIGINTYPE = 2'b10;
    topEnvConfigHandle.allChannelConfig[0][0].CH_DESTRIGINCFG.DESTRIGINSEL = 1;

    // INTERRUPT
    topEnvConfigHandle.allChannelConfig[0][0].CH_INTREN = 3;

    // TRIGOUT
    topEnvConfigHandle.allChannelConfig[0][0].CH_TRIGOUTCFG.TRIGOUTTYPE = 2'b10;
    topEnvConfigHandle.allChannelConfig[0][0].CH_TRIGOUTCFG.TRIGOUTSEL = 0;

    // WRAP MODE
    topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.XTYPE = X_WRAP;

    topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.USETRIGOUT = 1;
    topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.USESRCTRIGIN = 1;
    topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.USEDESTRIGIN = 1;

    // TRANSIZE
    topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.TRANSIZE = 2;

    // ADDR
    topEnvConfigHandle.allChannelConfig[0][0].CH_SRCADDR = 'd700;
    topEnvConfigHandle.allChannelConfig[0][0].CH_DESADDR = 'd1400;

    // SRCXSIZE < DESTXSIZE
    topEnvConfigHandle.allChannelConfig[0][0].CH_XSIZE = 'h0010_0005;

    // BURST
    topEnvConfigHandle.allChannelConfig[0][0].CH_SRCTRANSCFG.SRCMAXBURSTLEN = 6;
    topEnvConfigHandle.allChannelConfig[0][0].CH_DESTRANSCFG.DESMAXBURSTLEN = 6;

    // INC
    topEnvConfigHandle.allChannelConfig[0][0].CH_XADDRINC = 'h00010001;

    // FILL
    topEnvConfigHandle.allChannelConfig[0][0].CH_FILLVAL = 1;

    // ENABLE
    topEnvConfigHandle.allChannelConfig[0][0].CH_CMD.ENABLECMD = 1;

    dump_config_to_file();
    setUpCommand();

  endfunction



  task dma1dSingleTransferWithWrapSrcSmallerThanDesXsizeAndHwTiAndHiTo::run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    `uvm_info(get_type_name(),"Starting dma1DVirtualSequence",UVM_LOW)
    dma1DVirtualSeqHandle = dma1DVirtualSeq::type_id::create("dma1DVirtualSeqHandle");
    dma1DVirtualSeqHandle.topEnvConfigHandle =topEnvConfigHandle;
    dma1DVirtualSeqHandle.reqType = triggerGlobalPkg::SINGLE;
    dma1DVirtualSeqHandle.start(topEnvHandle.topEnvVirtualSequencerHandle);
    phase.drop_objection(this);

  endtask

`endif
