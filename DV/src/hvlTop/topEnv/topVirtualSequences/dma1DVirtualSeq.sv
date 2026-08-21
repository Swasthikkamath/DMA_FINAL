
class dma1DVirtualSeq extends topVirtualBaseSeq;
  `uvm_object_utils(dma1DVirtualSeq)
  configUnitInterruptSlaveOnlyVirtualSequence configUnitInterruptSlaveOnlyVirtualSequenceHandle;
  peripheralTriggerMasterOnlyVirtualSequence  peripheralTriggerMasterOnlyVirtualSequenceHandle[axi4_globals_pkg::NO_OF_SLAVES+1];
  peripheralAxiSlaveOnlyVirtualSequence peripheralAxiSlaveVirtualSequenceHandle[axi4_globals_pkg::NO_OF_SLAVES+1];
  CH_STATUS_FIELD temp;
  CH_ERRINFO_FIELD err;  
  int executedCommand[dmaGlobalPkg::NUM_CHANNELS];
  CH_SRCTRIGINCFG_FIELD triggerType;
  int killedThread;
  CH_WRKREGPTR_FIELD wrkptr;
  CH_WRKREGVAL_FIELD wrkValPtr;
  CH_SRCADDR_FIELD srcAddr;
  CH_DESADDR_FIELD desAddr;
  CH_XSIZE_FIELD XSIZE;
  CH_YSIZE_FIELD YSIZE;  
  reqTypeEnum reqType;
  CH_SRCADDR_FIELD curSrcAddr;
  CH_DESADDR_FIELD curDesAddr;
  CH_XSIZE_FIELD curXSIZE;
  CH_YSIZE_FIELD curYSIZE;
  CH_TRIGOUTCFG_FIELD triggerOutType;
  extern function new(string name = "dma1DVirtualSeq");
  extern task body();
endclass : dma1DVirtualSeq
      
function dma1DVirtualSeq::new(string name = "dma1DVirtualSeq");
  super.new(name);
endfunction : new

task dma1DVirtualSeq::body();
  uvm_status_e status;
   int i;
  process toKillWhenInterrupt;
  super.body();
  for (int j = 0; j < axi4_globals_pkg::NO_OF_SLAVES+1; j++) begin
    peripheralAxiSlaveVirtualSequenceHandle[j] =peripheralAxiSlaveOnlyVirtualSequence::type_id::create($sformatf("peripheralAxiSlaveVirtualSequenceHandle[%0d]", j));
   peripheralTriggerMasterOnlyVirtualSequenceHandle[j] =  peripheralTriggerMasterOnlyVirtualSequence :: type_id :: create($sformatf("peripheralTriggerMasterVirtualSequenceHandle[%0d]", j));
   peripheralTriggerMasterOnlyVirtualSequenceHandle[j].reqType = this.reqType;
end
 configUnitInterruptSlaveOnlyVirtualSequenceHandle = configUnitInterruptSlaveOnlyVirtualSequence :: type_id :: create("configUnitInterruptSlaveOnlyVirtualSequenceHandle");
  fork 
    begin
      for (i = 0; i < NUM_CHANNELS; i++) begin
        toKillWhenInterrupt = process :: self;
        topEnvConfigHandle.regBlockHandle.CH_SRCTRIGINCFG_inst[i].write(status,topEnvConfigHandle.allChannelConfig[i][0].CH_SRCTRIGINCFG);

        topEnvConfigHandle.regBlockHandle.CH_CTRL_inst[i].write(status,topEnvConfigHandle.allChannelConfig[i][0].CH_CTRL);

        topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[i].write(status,topEnvConfigHandle.allChannelConfig[i][0].CH_SRCADDR);

        topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[i].write(status,topEnvConfigHandle.allChannelConfig[i][0].CH_DESADDR);

        topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[i].write(status,topEnvConfigHandle.allChannelConfig[i][0].CH_XSIZE);

        topEnvConfigHandle.regBlockHandle.CH_YSIZE_inst[i].write(status,topEnvConfigHandle.allChannelConfig[i][0].CH_YSIZE);
        topEnvConfigHandle.regBlockHandle.CH_INTREN_inst[i].write(status,topEnvConfigHandle.allChannelConfig[i][0].CH_INTREN);

        topEnvConfigHandle.regBlockHandle.CH_LINKADDR_inst[i].write(status,topEnvConfigHandle.allChannelConfig[i][0].CH_LINKADDR);

        topEnvConfigHandle.regBlockHandle.CH_YADDRSTRIDE_inst[i].write(status,topEnvConfigHandle.allChannelConfig[i][0].CH_YADDRSTRIDE);

        topEnvConfigHandle.regBlockHandle.CH_TRIGOUTCFG_inst[i].write(status,topEnvConfigHandle.allChannelConfig[i][0].CH_TRIGOUTCFG);
        topEnvConfigHandle.regBlockHandle.CH_TMPLTCFG_inst[i].write(status,topEnvConfigHandle.allChannelConfig[i][0].CH_TMPLTCFG);
        topEnvConfigHandle.regBlockHandle.CH_SRCTMPLT_inst[i].write(status,topEnvConfigHandle.allChannelConfig[i][0].CH_SRCTMPLT); 
        topEnvConfigHandle.regBlockHandle.CH_DESTMPLT_inst[i].write(status,topEnvConfigHandle.allChannelConfig[i][0].CH_DESTMPLT);
 
        //topEnvConfigHandle.regBlockHandle.CH_DESTMPLT_inst[i].write(status,.value('h3F));
        
        topEnvConfigHandle.regBlockHandle.CH_DESTRIGINCFG_inst[i].write(status,topEnvConfigHandle.allChannelConfig[i][0].CH_DESTRIGINCFG);

        topEnvConfigHandle.regBlockHandle.CH_DESTRANSCFG_inst[i].write(status,topEnvConfigHandle.allChannelConfig[i][0].CH_DESTRANSCFG);

        topEnvConfigHandle.regBlockHandle.CH_SRCTRANSCFG_inst[i].write(status,topEnvConfigHandle.allChannelConfig[i][0].CH_SRCTRANSCFG);
        topEnvConfigHandle.regBlockHandle.CH_FILLVAL_inst[i].write(status,topEnvConfigHandle.allChannelConfig[i][0].CH_FILLVAL);
        topEnvConfigHandle.regBlockHandle.CH_AUTOCFG_inst[i].write(status,topEnvConfigHandle.allChannelConfig[i][0].CH_AUTOCFG);
        topEnvConfigHandle.regBlockHandle.CH_XADDRINC_inst[i].write(status,topEnvConfigHandle.allChannelConfig[i][0].CH_XADDRINC);
      end
      for(int i=0;i<NUM_CHANNELS;i++)begin 
        topEnvConfigHandle.regBlockHandle.CH_CMD_inst[i].write(status,.value(topEnvConfigHandle.allChannelConfig[i][0].CH_CMD));
      end 
    end
                                                                              

    begin : terminating
      int noChannels;
      forever begin
        for(int i = 0;i< dmaGlobalPkg::NUM_CHANNELS; i++) begin //need to optimize this
          if(executedCommand[i] == topEnvConfigHandle.numberOfCommandPerChannel[i]) begin 
            noChannels++;
          $display("INCR DONE 88 noChannels is %d and NUM_CHANNELS IS %d",noChannels,dmaGlobalPkg::NUM_CHANNELS);
          end 
        end
        if(noChannels == dmaGlobalPkg ::NUM_CHANNELS)begin
           $display("DISABLING THE REQ  88 ");
           disable terminating;
        end 
        configUnitInterruptSlaveOnlyVirtualSequenceHandle.start(p_sequencer.configUnitEnvVirtualSequencerHandle);
        toKillWhenInterrupt.suspend();
        for(int i = 0;i< dmaGlobalPkg::NUM_CHANNELS; i++) begin
          automatic int j = i;
          if(configUnitInterruptSlaveOnlyVirtualSequenceHandle.irqVector[i]==1)begin 
           j = i;
          end 
          else begin 
            continue;
          end 
          begin
            topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[j].read(status,temp);
            if(temp.STAT_ERR == 1) begin
              topEnvConfigHandle.regBlockHandle.CH_ERRINFO_inst[j].read(status,err);
              if(|err) begin //cfgerror & regvalerr
               $display("INCRRR");
                toKillWhenInterrupt.kill();
                executedCommand[j]++;
              end 
            end
            else begin
              if(temp.STAT_TRIGOUTACKWAIT) begin
                topEnvConfigHandle.regBlockHandle.CH_TRIGOUTCFG_inst[j].read(status,triggerOutType);
                if(triggerOutType.TRIGOUTTYPE ==0) begin
                  topEnvConfigHandle.allChannelConfig[j][executedCommand[j]].CH_CMD.SWTRIGOUTACK=1;
                  topEnvConfigHandle.regBlockHandle.CH_CMD_inst[j].write(status,.value(topEnvConfigHandle.allChannelConfig[j][executedCommand[j]].CH_CMD));
                end 
              end 
  
              if(temp.STAT_SRCTRIGINWAIT) begin //srctriginwait destrigin wait
                topEnvConfigHandle.regBlockHandle.CH_SRCTRIGINCFG_inst[j].read(status,triggerType);
                if(triggerType.SRCTRIGINTYPE == 0) begin
                  topEnvConfigHandle.allChannelConfig[j][executedCommand[j]].CH_CMD.SRCSWTRIGINTYPE=reqType; //req type          
                  topEnvConfigHandle.allChannelConfig[j][executedCommand[j]].CH_CMD.SRCSWTRIGINREQ=1; 
                  topEnvConfigHandle.regBlockHandle.CH_CMD_inst[j].write(status,.value(topEnvConfigHandle.allChannelConfig[i][0].CH_CMD));  
                end
              end
              if(temp.STAT_DESTRIGINWAIT==1) begin //destriginwait
                topEnvConfigHandle.regBlockHandle.CH_DESTRIGINCFG_inst[j].read(status, triggerType);
                if(triggerType.SRCTRIGINTYPE == 0) begin
                   
                  topEnvConfigHandle.allChannelConfig[j][executedCommand[j]].CH_CMD.DESSWTRIGINTYPE=reqType;
                  topEnvConfigHandle.allChannelConfig[j][executedCommand[j]].CH_CMD.DESSWTRIGINREQ=1;
                  topEnvConfigHandle.regBlockHandle.CH_CMD_inst[j].write(status,.value(topEnvConfigHandle.allChannelConfig[i][0].CH_CMD)); 
                end                    
              end
              if(temp.STAT_DONE==1)begin //STAT_DONE
                topEnvConfigHandle.regBlockHandle.CH_STATUS_inst[j].write(status,.value('h10000));
                executedCommand[j]++; 
              end
              if(temp.STAT_STOPPED == 1) begin 
                topEnvConfigHandle.regBlockHandle.CH_CMD_inst[j].write(status,.value(topEnvConfigHandle.allChannelConfig[j][executedCommand[j]].CH_CMD)); 
              end    
              if(temp.STAT_PAUSED == 1 && !temp.STAT_DONE)begin 
           
                topEnvConfigHandle.allChannelConfig[j][executedCommand[j]].CH_WRKREGPTR =1;
                topEnvConfigHandle.regBlockHandle.CH_WRKREGPTR_inst[j].write(status,.value(topEnvConfigHandle.allChannelConfig[j][executedCommand[j]].CH_WRKREGPTR));
                topEnvConfigHandle.regBlockHandle.CH_WRKREGVAL_inst[j].read(status,.value(srcAddr));

                topEnvConfigHandle.allChannelConfig[j][executedCommand[j]].CH_WRKREGPTR =3;
                topEnvConfigHandle.regBlockHandle.CH_WRKREGPTR_inst[j].write(status,.value(topEnvConfigHandle.allChannelConfig[j][executedCommand[j]].CH_WRKREGPTR));
                topEnvConfigHandle.regBlockHandle.CH_WRKREGVAL_inst[j].read(status,.value(desAddr));
 
                topEnvConfigHandle.allChannelConfig[j][executedCommand[j]].CH_WRKREGPTR =5;
                topEnvConfigHandle.regBlockHandle.CH_WRKREGPTR_inst[j].write(status,.value(topEnvConfigHandle.allChannelConfig[j][executedCommand[j]].CH_WRKREGPTR));
 
                topEnvConfigHandle.regBlockHandle.CH_WRKREGVAL_inst[j].read(status,.value(XSIZE.SRCXSIZE));

	            	topEnvConfigHandle.allChannelConfig[j][executedCommand[j]].CH_WRKREGPTR =6;
                topEnvConfigHandle.regBlockHandle.CH_WRKREGPTR_inst[j].write(status,.value(topEnvConfigHandle.allChannelConfig[j][executedCommand[j]].CH_WRKREGPTR));

                topEnvConfigHandle.regBlockHandle.CH_WRKREGVAL_inst[j].read(status,.value(XSIZE.DESXSIZE));
                    
                topEnvConfigHandle.allChannelConfig[j][executedCommand[j]].CH_WRKREGPTR =11;
                topEnvConfigHandle.regBlockHandle.CH_WRKREGPTR_inst[j].write(status,.value(topEnvConfigHandle.allChannelConfig[j][executedCommand[j]].CH_WRKREGPTR));

                topEnvConfigHandle.regBlockHandle.CH_WRKREGVAL_inst[j].read(status,.value(YSIZE.SRCYSIZE));
                 
                topEnvConfigHandle.allChannelConfig[j][executedCommand[j]].CH_WRKREGPTR =12;
                topEnvConfigHandle.regBlockHandle.CH_WRKREGPTR_inst[j].write(status,.value(topEnvConfigHandle.allChannelConfig[j][executedCommand[j]].CH_WRKREGPTR)); 
                topEnvConfigHandle.regBlockHandle.CH_WRKREGVAL_inst[j].read(status,.value(YSIZE.DESYSIZE));
                topEnvConfigHandle.regBlockHandle.CH_SRCADDR_inst[j].read(status,.value(curSrcAddr));
                topEnvConfigHandle.regBlockHandle.CH_DESADDR_inst[j].read(status,.value(curDesAddr));
                topEnvConfigHandle.regBlockHandle.CH_XSIZE_inst[j].read(status,.value(curXSIZE));
                topEnvConfigHandle.regBlockHandle.CH_YSIZE_inst[j].read(status,.value(curYSIZE));
                topEnvConfigHandle.allChannelConfig[j][executedCommand[j]].CH_CMD.RESUMECMD=1;
                topEnvConfigHandle.regBlockHandle.CH_CMD_inst[j].write(status,.value(topEnvConfigHandle.allChannelConfig[j][executedCommand[j]].CH_CMD));
                `uvm_info("MAIN VSEQ",$sformatf("PAUSE HAS OCCURED AND THE INITIAL SRCXSIZE IS %0d DESXSIZE IS %0D INITIAL SRCADDR IS %0d AND INITIAL DESADDR IS %0d",XSIZE.SRCXSIZE,XSIZE.DESXSIZE,srcAddr,desAddr),UVM_HIGH)
                `uvm_info("MAIN VSEQ",$sformatf("PAUSE HAS OCCURED AND THE CURRENT SRCXSIZE IS %0d DESXSIZE IS %0D CURRENT SRCADDR IS %0d AND CURRENT DESADDR IS %0d",curXSIZE.SRCXSIZE,curXSIZE.DESXSIZE,curSrcAddr,curDesAddr),UVM_HIGH)

              end 
 
            end                  
          end
        end
        toKillWhenInterrupt.resume();
      end
    end:terminating
               
  
    begin :axislave
      for(int i=0;i<axi4_globals_pkg::NO_OF_SLAVES+1;i++) begin
        automatic int j = i;
        fork
          peripheralAxiSlaveVirtualSequenceHandle[j].start(p_sequencer.peripheralEnvVirtualSequencerHandle[j]);
        join_none
      end
    end
    begin :hwtrigger
      for(int i=0;i<axi4_globals_pkg::NO_OF_SLAVES+1;i++) begin
        automatic int j = i;
        fork
          peripheralTriggerMasterOnlyVirtualSequenceHandle[j].start(p_sequencer.peripheralEnvVirtualSequencerHandle[j]); 
        join_none
      end
    end
  join

endtask :body


 
