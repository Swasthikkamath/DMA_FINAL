`ifndef DMA1D_BLOCK_TRANSFER_WITH_CONTINUE_SRC_AND_DEST_XSIZE_EQ_AND_SWTI_HITO_INCLUDED
`define DMA1D_BLOCK_TRANSFER_WITH_CONTINUE_SRC_AND_DEST_XSIZE_EQ_AND_SWTI_HITO_INCLUDED

class dma1dBlockTransferWithContinueSrcAndDesXsizeEqAndSwTiAndSiTo extends dmaBaseTest;
  `uvm_component_utils(dma1dBlockTransferWithContinueSrcAndDesXsizeEqAndSwTiAndSiTo);
  dma1DVirtualSeq dma1DVirtualSeqHandle;
  dmaPollingVirtualSeq seq;
  extern function new(string name ="dma1dBlockTransferWithContinueSrcAndDesXsizeEqAndSwTiAndSiTo",uvm_component parent = null);

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass

function dma1dBlockTransferWithContinueSrcAndDesXsizeEqAndSwTiAndSiTo :: new(string name ="dma1dBlockTransferWithContinueSrcAndDesXsizeEqAndSwTiAndSiTo",uvm_component parent = null);
  super.new(name,parent);
endfunction


function void dma1dBlockTransferWithContinueSrcAndDesXsizeEqAndSwTiAndSiTo::build_phase(uvm_phase phase);
  super.build_phase(phase);
  topEnvConfigHandle.numberOfCommandPerChannel.rand_mode(0);
  foreach(topEnvConfigHandle.allChannelConfig[i]) begin
    topEnvConfigHandle.allChannelConfig[i] = new[topEnvConfigHandle.numberOfCommandPerChannel[i]];
  end
  foreach(topEnvConfigHandle.addressIfLinking[i]) begin
    topEnvConfigHandle.addressIfLinking[i] = new[topEnvConfigHandle.numberOfCommandPerChannel[i]];
  end

  topEnvConfigHandle.randomize() with {  foreach(topEnvConfigHandle.addressIfLinking[i,j]) { topEnvConfigHandle.addressIfLinking[i][j] inside {[topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[topEnvConfigHandle.peripheralSlaveMemory].min_address : topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[topEnvConfigHandle.peripheralSlaveMemory].max_address]};}};

  // Disable 2D
  topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.YTYPE=Y_DISABLE;
  
  // TRIGGER SRC BLK SIZE
  topEnvConfigHandle.allChannelConfig[0][0].CH_SRCTRIGINCFG.SRCTRIGINBLKSIZE = 10;

  // TRIGGER SRC MODE
  topEnvConfigHandle.allChannelConfig[0][0].CH_SRCTRIGINCFG.SRCTRIGINMODE = 0;

  // Trigger SRC TYPE
  topEnvConfigHandle.allChannelConfig[0][0].CH_SRCTRIGINCFG.SRCTRIGINTYPE = 2'b 00;

  // TRIGGER SRC SEL
  topEnvConfigHandle.allChannelConfig[0][0].CH_SRCTRIGINCFG.SRCTRIGINSEL = 0;

  // TRIGGER DEST BLK SIZE
  topEnvConfigHandle.allChannelConfig[0][0].CH_DESTRIGINCFG.DESTRIGINBLKSIZE = 10;

  // TRIGGER DEST MODE
  topEnvConfigHandle.allChannelConfig[0][0].CH_DESTRIGINCFG.DESTRIGINMODE = 0;
 
  // Trigger DEST TYPE
  topEnvConfigHandle.allChannelConfig[0][0].CH_DESTRIGINCFG.DESTRIGINTYPE = 2'b 00;

  //TRIGGER DEST SEL
  topEnvConfigHandle.allChannelConfig[0][0].CH_DESTRIGINCFG.DESTRIGINSEL = 1;

  // INTERUPT CMD
  topEnvConfigHandle.allChannelConfig[0][0].CH_INTREN = 'h004;

  // TRIGGER OUT TYPE
  topEnvConfigHandle.allChannelConfig[0][0].CH_TRIGOUTCFG.TRIGOUTTYPE = 2'b10;

  // TRIGGER OUT SEL
  topEnvConfigHandle.allChannelConfig[0][0].CH_TRIGOUTCFG.TRIGOUTSEL = 0;

  // XTYPE = CONTINUE
  topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.XTYPE = X_CONTINUE;

  // ENABLE USETRIGOUT
  topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.USETRIGOUT = 1;

  // ENABLE USESRCTRIGIN
  topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.USESRCTRIGIN =1;

  // ENABLE USEDESTRIGIN
  topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.USEDESTRIGIN=1;

  // CH_CTRL.TRANSIZE = 2
  topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.TRANSIZE = 2;

  topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL.DONETYPE=1;
  // CH_SRCADDR   = 32'D700
  topEnvConfigHandle.allChannelConfig[0][0].CH_SRCADDR = 'd 700;

  // CH_DESADDR = 32'D1400
  topEnvConfigHandle.allChannelConfig[0][0].CH_DESADDR = 'd 1400;

  // condition SRCXSIZE == DESTXSIZE
  // CH_XSIZE = 32'H 0005_0005
  topEnvConfigHandle.allChannelConfig[0][0].CH_XSIZE = 'h 0005_0005;

  // CH_SRCTRANSCFG.SRCMAXBURSTLEN = 6
  topEnvConfigHandle.allChannelConfig[0][0].CH_SRCTRANSCFG.SRCMAXBURSTLEN=6;

  //CH_DESTRANSCFG.DESMAXBURSTLEN = 6
  topEnvConfigHandle.allChannelConfig[0][0].CH_DESTRANSCFG.DESMAXBURSTLEN=6;
  
  //CH_XADDRINC = 'h 00010001;
  topEnvConfigHandle.allChannelConfig[0][0].CH_XADDRINC='h 00010001;

  //CH_FILLVAL =1;
  topEnvConfigHandle.allChannelConfig[0][0].CH_FILLVAL =1;
 
  //CH_CMD.ENABLECMD = 1
  topEnvConfigHandle.allChannelConfig[0][0].CH_CMD.ENABLECMD = 1;

   topEnvConfigHandle.allChannelConfig[0][0].CH_LINKADDR.LINKADDREN =0;
  topEnvConfigHandle.allChannelConfig[0][0].CH_LINKADDR.LINKADDR = 3000;
  topEnvConfigHandle.allChannelConfig[0][1].CH_LINKADDR.LINKADDR = 000;
  topEnvConfigHandle.addressIfLinking[0][1] = 3000;

  
  // Disable 2D
  topEnvConfigHandle.allChannelConfig[0][1].CH_CTRL.YTYPE=Y_DISABLE;
  
  // TRIGGER SRC BLK SIZE
  topEnvConfigHandle.allChannelConfig[0][1].CH_SRCTRIGINCFG.SRCTRIGINBLKSIZE = 10;
  
  // TRIGGER SRC MODE
  topEnvConfigHandle.allChannelConfig[0][1].CH_SRCTRIGINCFG.SRCTRIGINMODE = 0;
  
  // Trigger SRC TYPE
  topEnvConfigHandle.allChannelConfig[0][1].CH_SRCTRIGINCFG.SRCTRIGINTYPE = 2'b10;

  // TRIGGER SRC SEL
  topEnvConfigHandle.allChannelConfig[0][1].CH_SRCTRIGINCFG.SRCTRIGINSEL = 0;

  // TRIGGER DEST BLK SIZE
  topEnvConfigHandle.allChannelConfig[0][1].CH_DESTRIGINCFG.DESTRIGINBLKSIZE = 2'b10;

  // TRIGGER DEST MODE
  topEnvConfigHandle.allChannelConfig[0][1].CH_DESTRIGINCFG.DESTRIGINMODE = 0;

  // Trigger DEST TYPE
  topEnvConfigHandle.allChannelConfig[0][1].CH_DESTRIGINCFG.DESTRIGINTYPE = 2'b10;

  //TRIGGER DEST SEL
  topEnvConfigHandle.allChannelConfig[0][1].CH_DESTRIGINCFG.DESTRIGINSEL = 1;

  // INTERUPT CMD
  topEnvConfigHandle.allChannelConfig[0][1].CH_INTREN = 'h 3;

  // TRIGGER OUT TYPE
  topEnvConfigHandle.allChannelConfig[0][1].CH_TRIGOUTCFG.TRIGOUTTYPE = 2'b10;

  // TRIGGER OUT SEL
  topEnvConfigHandle.allChannelConfig[0][1].CH_TRIGOUTCFG.TRIGOUTSEL = 0;

  // XTYPE = CONTINUE
  topEnvConfigHandle.allChannelConfig[0][1].CH_CTRL.XTYPE = X_CONTINUE;

  // ENABLE USETRIGOUT
  topEnvConfigHandle.allChannelConfig[0][1].CH_CTRL.USETRIGOUT = 1;

  // ENABLE USESRCTRIGIN
  topEnvConfigHandle.allChannelConfig[0][1].CH_CTRL.USESRCTRIGIN =1;

  // ENABLE USEDESTRIGIN
  topEnvConfigHandle.allChannelConfig[0][1].CH_CTRL.USEDESTRIGIN=1;

  // CH_CTRL.TRANSIZE = 2
  topEnvConfigHandle.allChannelConfig[0][1].CH_CTRL.TRANSIZE = 2;

  topEnvConfigHandle.allChannelConfig[0][1].CH_CTRL.DONETYPE = 1;
  // CH_SRCADDR   = 32'D700
  topEnvConfigHandle.allChannelConfig[0][1].CH_SRCADDR = 'd 700;

  // CH_DESADDR = 32'D1400
  topEnvConfigHandle.allChannelConfig[0][1].CH_DESADDR = 'd 1400;

  // condition SRCXSIZE == DESTXSIZE
  // CH_XSIZE = 32'H 0005_0005
  topEnvConfigHandle.allChannelConfig[0][1].CH_XSIZE = 'h 00050005;

  // CH_SRCTRANSCFG.SRCMAXBURSTLEN = 6
  topEnvConfigHandle.allChannelConfig[0][1].CH_SRCTRANSCFG.SRCMAXBURSTLEN=6;

  //CH_DESTRANSCFG.DESMAXBURSTLEN = 6
  topEnvConfigHandle.allChannelConfig[0][1].CH_DESTRANSCFG.DESMAXBURSTLEN=6;

  //CH_XADDRINC = 'h 00010001;
  topEnvConfigHandle.allChannelConfig[0][1].CH_XADDRINC='h 00010001;

  //CH_FILLVAL =1;
  topEnvConfigHandle.allChannelConfig[0][1].CH_FILLVAL =1;

  //CH_CMD.ENABLECMD = 1
  topEnvConfigHandle.allChannelConfig[0][1].CH_CMD.ENABLECMD = 1;
  topEnvConfigHandle.allChannelConfig[0][1].CH_CTRL.DONETYPE=1;

  // same way you can update the needed fields for confguring the respective channels as per req
  dump_config_to_file();
  setUpCommand();

endfunction

task dma1dBlockTransferWithContinueSrcAndDesXsizeEqAndSwTiAndSiTo::run_phase(uvm_phase phase);
  super.run_phase(phase);
  phase.raise_objection(this);
  `uvm_info(get_type_name(),"Starting dma1DVirtualSequence",UVM_LOW)
  /*u can make use dma1DVirtualSeq but if it run infinitely it means either the interrupt is not generated for sw trig req so in that scenario pls do make use of polling virtual seq where in you can see
STATUS register on a contnious manner*/
  dma1DVirtualSeqHandle = dma1DVirtualSeq::type_id::create("dma1DVirtualSeqHandle");
  seq =dmaPollingVirtualSeq :: type_id :: create("test");
  seq.reqType = triggerGlobalPkg::BLOCK;
  seq.topEnvConfigHandle =topEnvConfigHandle;
  seq.start(topEnvHandle.topEnvVirtualSequencerHandle);
  phase.drop_objection(this);
endtask

`endif

