`ifndef DMAPOLLINGVIRTUALSEQ_INCLUDED
`define DMAPOLLINGVIRTUALSEQ_INCLUDED
class dmaPollingVirtualSeq extends topVirtualBaseSeq;
  `uvm_object_utils(dmaPollingVirtualSeq)
  configUnitInterruptSlaveOnlyVirtualSequence configUnitInterruptSlaveOnlyVirtualSequenceHandle;

  int local1;
  reqTypeEnum reqType;
  peripheralTriggerMasterOnlyVirtualSequence seq[4];
  axi4_slave_bk_read_32b_transfer_seq  seq1,seq2;
  axi4_slave_bk_write_32b_transfer_seq  seq3,seq4;

  extern function new(string name = "dmaPollingVirtualSeq");
  extern task body();
endclass : dmaPollingVirtualSeq

function dmaPollingVirtualSeq::new(string name = "dmaPollingVirtualSeq");
  super.new(name);
endfunction

task dmaPollingVirtualSeq::body();
  uvm_status_e status;
  super.body();

  configUnitInterruptSlaveOnlyVirtualSequenceHandle = configUnitInterruptSlaveOnlyVirtualSequence :: type_id :: create("configUnitInterruptSlaveOnlyVirtualSequenceHandle");

  foreach(seq[i] )begin 
    seq[i] = peripheralTriggerMasterOnlyVirtualSequence :: type_id :: create($sformatf("TRIGGERSEQ[%d]",i));
    seq[i].reqType = triggerGlobalPkg::BLOCK;
  end 
  seq1 = axi4_slave_bk_read_32b_transfer_seq :: type_id :: create("ss");
  seq2 = axi4_slave_bk_read_32b_transfer_seq :: type_id :: create("ss1");
  seq3 = axi4_slave_bk_write_32b_transfer_seq :: type_id :: create("s3");
  seq4 = axi4_slave_bk_write_32b_transfer_seq :: type_id :: create("s4");

  fork
    forever begin
      seq1.start(p_sequencer.peripheralEnvVirtualSequencerHandle[0].axi4SlaveReadSequencerHandle);
    end
  join_none

  fork
    forever begin
      seq2.start(p_sequencer.peripheralEnvVirtualSequencerHandle[1].axi4SlaveReadSequencerHandle);
    end
  join_none

  fork
    forever begin
      seq3.start(p_sequencer.peripheralEnvVirtualSequencerHandle[0].axi4SlaveWriteSequencerHandle);
    end
  join_none

  fork
    forever begin
      seq4.start(p_sequencer.peripheralEnvVirtualSequencerHandle[1].axi4SlaveWriteSequencerHandle);
    end
  join_none

  topEnvConfigHandle.regBlockHandle.CH_FILLVAL_inst[0].write(status,.value(topEnvConfigHandle.allChannelConfig[0][0].CH_FILLVAL));
  topEnvConfigHandle.regBlockHandle.CH_CTRL_inst[0].write(status,.value(topEnvConfigHandle.allChannelConfig[0][0].CH_CTRL));
  topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].write(status,.value(topEnvConfigHandle.allChannelConfig[0][0].CH_SRCADDR));
  topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].write(status,.value(topEnvConfigHandle.allChannelConfig[0][0].CH_DESADDR));
  topEnvConfigHandle.regBlockHandle.CH_SRCTRANSCFG_inst[0].write(status,.value(topEnvConfigHandle.allChannelConfig[0][0].CH_SRCTRANSCFG));
  topEnvConfigHandle.regBlockHandle.CH_DESTRANSCFG_inst[0].write(status,.value(topEnvConfigHandle.allChannelConfig[0][0].CH_DESTRANSCFG));
  topEnvConfigHandle.regBlockHandle.CH_XADDRINC_inst[0].write(status,.value(topEnvConfigHandle.allChannelConfig[0][0].CH_XADDRINC));
  topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].write(status,.value(topEnvConfigHandle.allChannelConfig[0][0].CH_XSIZE));
  topEnvConfigHandle.regBlockHandle.CH_YSIZE_inst[0].write(status,.value(topEnvConfigHandle.allChannelConfig[0][0].CH_YSIZE));
  topEnvConfigHandle.regBlockHandle.CH_LINKADDR_inst[0].write(status,.value(topEnvConfigHandle.allChannelConfig[0][0].CH_LINKADDR));
  topEnvConfigHandle.regBlockHandle.CH_INTREN_inst[0].write(status,.value(topEnvConfigHandle.allChannelConfig[0][0].CH_INTREN));
  topEnvConfigHandle.regBlockHandle.CH_DESTMPLT_inst[0].write(status,.value('1));
  topEnvConfigHandle.regBlockHandle.CH_SRCTRIGINCFG_inst[0].write(status,.value(topEnvConfigHandle.allChannelConfig[0][0].CH_SRCTRIGINCFG));
  topEnvConfigHandle.regBlockHandle.CH_TRIGOUTCFG_inst[0].write(status,.value(topEnvConfigHandle.allChannelConfig[0][0].CH_TRIGOUTCFG));
  topEnvConfigHandle.regBlockHandle.CH_DESTMPLT_inst[0].write(status,.value('h3F));
  topEnvConfigHandle.regBlockHandle.CH_DESTRIGINCFG_inst[0].write(status,.value(topEnvConfigHandle.allChannelConfig[0][0].CH_DESTRIGINCFG));


    topEnvConfigHandle.regBlockHandle.CH_FILLVAL_inst[1].write(status,.value(topEnvConfigHandle.allChannelConfig[1][0].CH_FILLVAL));
  topEnvConfigHandle.regBlockHandle.CH_CTRL_inst[1].write(status,.value(topEnvConfigHandle.allChannelConfig[1][0].CH_CTRL));
  topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[1].write(status,.value(topEnvConfigHandle.allChannelConfig[1][0].CH_SRCADDR));
  topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[1].write(status,.value(topEnvConfigHandle.allChannelConfig[1][0].CH_DESADDR));
  topEnvConfigHandle.regBlockHandle.CH_SRCTRANSCFG_inst[1].write(status,.value(topEnvConfigHandle.allChannelConfig[1][0].CH_SRCTRANSCFG));
  topEnvConfigHandle.regBlockHandle.CH_DESTRANSCFG_inst[1].write(status,.value(topEnvConfigHandle.allChannelConfig[1][0].CH_DESTRANSCFG));
  topEnvConfigHandle.regBlockHandle.CH_XADDRINC_inst[1].write(status,.value(topEnvConfigHandle.allChannelConfig[1][0].CH_XADDRINC));
  topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[1].write(status,.value(topEnvConfigHandle.allChannelConfig[1][0].CH_XSIZE));
  topEnvConfigHandle.regBlockHandle.CH_YSIZE_inst[1].write(status,.value(topEnvConfigHandle.allChannelConfig[1][0].CH_YSIZE));
  topEnvConfigHandle.regBlockHandle.CH_LINKADDR_inst[1].write(status,.value(topEnvConfigHandle.allChannelConfig[1][0].CH_LINKADDR));
  topEnvConfigHandle.regBlockHandle.CH_INTREN_inst[1].write(status,.value(topEnvConfigHandle.allChannelConfig[1][0].CH_INTREN));
  topEnvConfigHandle.regBlockHandle.CH_DESTMPLT_inst[1].write(status,.value('1));
  topEnvConfigHandle.regBlockHandle.CH_SRCTRIGINCFG_inst[1].write(status,.value(topEnvConfigHandle.allChannelConfig[1][0].CH_SRCTRIGINCFG));
  topEnvConfigHandle.regBlockHandle.CH_TRIGOUTCFG_inst[1].write(status,.value(topEnvConfigHandle.allChannelConfig[1][0].CH_TRIGOUTCFG));
  topEnvConfigHandle.regBlockHandle.CH_DESTMPLT_inst[1].write(status,.value('h3F));
  topEnvConfigHandle.regBlockHandle.CH_DESTRIGINCFG_inst[1].write(status,.value(topEnvConfigHandle.allChannelConfig[1][0].CH_DESTRIGINCFG));
 
foreach(seq[i])begin
  automatic int j=i;
    fork
        seq[j].start(p_sequencer.peripheralEnvVirtualSequencerHandle[j]);
    join_none
  end 


topEnvConfigHandle.regBlockHandle.CH_CMD_inst[0].write(status,.value(topEnvConfigHandle.allChannelConfig[0][0].CH_CMD));
topEnvConfigHandle.regBlockHandle.CH_CMD_inst[1].write(status,.value(topEnvConfigHandle.allChannelConfig[1][0].CH_CMD));


  fork
    configUnitInterruptSlaveOnlyVirtualSequenceHandle.start(p_sequencer.configUnitEnvVirtualSequencerHandle);
  join_none
//  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_CMD_inst[0].write(status,.value(32'b0101_0101_0000_0000_0000_0001));
  topEnvConfigHandle.regBlockHandle.CH_CMD_inst[1].write(status,.value(32'b0101_0101_0000_0000_0000_0001)); 
//  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
 topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

//  topEnvConfigHandle.regBlockHandle.CH_CMD_inst[1].write(status,.value(32'b0101_0101_0000_0000_0000_1001));
topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));
//topEnvConfigHandle.regBlockHandle.CH_CMD_inst[1].write(status,.value(32'b0101_0101_0000_0000_0000_1001));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

  topEnvConfigHandle.regBlockHandle.CH_CMD_inst[1].write(status,.value(32'b0101_0101_0000_0000_0000_1001));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

 
topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));


  /*
topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[0].read(status,.value(local1));
*/
/*
topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));

topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[0].read(status,.value(local1));
*/



  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
  topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));
topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[0].read(status,.value(local1));

endtask :body
`endif
