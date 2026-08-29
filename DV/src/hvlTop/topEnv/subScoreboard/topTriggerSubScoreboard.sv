`ifndef TOPTRIGGERSUBSCOREBOARD_INCLUDED
`define TOPTRIGGERSUBSCOREBOARD_INCLUDED

class topTriggerSubScoreboard extends uvm_component;
  `uvm_component_utils(topTriggerSubScoreboard)

// Analysis FIFOs - Trigger Path
  uvm_tlm_analysis_fifo #(triggerMasterTx)peripheralUnitTriggerMasterPathAnalysisExport[];
  uvm_tlm_analysis_fifo #(triggerSlaveTx) peripheralUnitTriggerSlavePathAnalysisExport[];

  // Analysis FIFOs - Trigger Path
  uvm_tlm_analysis_fifo #(triggerMasterTx) peripheralUnitTriggerOutMasterPathAnalysisExport[];
  uvm_tlm_analysis_fifo #(triggerSlaveTx) peripheralUnitTriggerOutSlavePathAnalysisExport[];

extern function new(string name="topTriggerSubScoreboard",uvm_component parent=null);
extern virtual function void build_phase(uvm_phase phase);
extern task handleTriggers();
extern task handleTriggerOut();


endclass

function void topTriggerSubScoreboard :: build_phase(uvm_phase phase);
  peripheralUnitTriggerMasterPathAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES+1];
  peripheralUnitTriggerSlavePathAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES+1];
  
  peripheralUnitTriggerOutMasterPathAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES+1];
  peripheralUnitTriggerOutSlavePathAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES+1];

  foreach(peripheralUnitTriggerMasterPathAnalysisExport[i]) begin
    peripheralUnitTriggerMasterPathAnalysisExport[i] =new($sformatf("peripheralUnitTriggerMasterPathAnalysisExport[%0d]", i), this);
    peripheralUnitTriggerSlavePathAnalysisExport[i] = new($sformatf("peripheralUnitTriggerSlavePathAnalysisExport[%0d]", i), this);
    peripheralUnitTriggerOutMasterPathAnalysisExport[i] =new($sformatf("peripheralUnitTriggerOutMasterPathAnalysisExport[%0d]", i), this);
    peripheralUnitTriggerOutSlavePathAnalysisExport[i] =new($sformatf("peripheralUnitTriggerOutSlavePathAnalysisExport[%0d]", i), this);
  end 
endfunction 

function topTriggerSubScoreboard::new(string name="topTriggerSubScoreboard", uvm_component parent =null);
  super.new(name,parent);
endfunction

task topTriggerSubScoreboard::handleTriggers();
  foreach (peripheralUnitTriggerSlavePathAnalysisExport[i]) begin
    automatic int triggerNum = i;
    automatic bit flag=0;
    automatic bit check=0;
    automatic int done =0; //unique for each trigger thread
    process thread;
    fork
      forever begin
        triggerSlaveTx triggerTx;
        int channel;
        sharedResource::channelPriority priorityStack;
        int selectedInterface;
        sharedResource::semaPhoreTriggerHandle[triggerNum].get(1);

        channel = sharedResource::triggerPortChannelMap[triggerNum];
        fork
          begin  
            thread = process::self;
            while(sharedResource::dmaChannelRegHandle[channel].CH_STATUS.STAT_DONE == 0)begin : triggerBlk1 
              if(sharedResource::flowControl[triggerNum]==1 && flag==0)begin
                 if (sharedResource::readWriteTriggerMap[triggerNum] == 0) begin
                   // Read operation (source trigger)
                  sharedResource ::dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE =sharedResource ::numberOfReadReq[channel];
                  sharedResource::trigSrcInfoChannel[channel] = trigReqEnum'(sharedResource::topEnvConfigHandle.peripheralEnvConfigHandle.triggerSlaveAgentConfigHandle[triggerNum].srcReqType);
                  `uvm_info("TOP_SCOREBOARD",$sformatf("TRIGGER TYPE RECEIVED IN SOURCE END IS %s",sharedResource ::trigSrcInfoChannel[channel]),UVM_NONE)
                  for(int i=0;i<(axi4_globals_pkg :: NO_OF_SLAVES);i++) begin
                    if(sharedResource::dmaChannelRegHandle[channel].CH_SRCADDR>= sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].min_address && sharedResource::dmaChannelRegHandle[channel].CH_SRCADDR<sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].max_address) begin
                      selectedInterface=i;
                      break;
                    end
                  end

                  `uvm_info("TOP_SCOREBOARD",$sformatf("A HW trigger For SRC has been received for channel[%0d] and selected interface is %0d",channel,selectedInterface),UVM_HIGH)
                  sharedResource::dmaChannelRegHandle[channel].CH_STATUS.STAT_SRCTRIGINWAIT = 0;
                  sharedResource::dmaChannelRegHandle[channel].CH_STATUS.INTR_SRCTRIGINWAIT = 0;
                  priorityStack.srcAddr = sharedResource::dmaChannelRegHandle[channel].CH_SRCADDR;
                  priorityStack.desAddr = sharedResource::dmaChannelRegHandle[channel].CH_DESADDR;
                  priorityStack.commandStart =1;
                  priorityStack.commandDone = 0;
                  priorityStack.channelPri = sharedResource::dmaChannelRegHandle[channel].CH_CTRL.CHPRIO;
                  sharedResource::prioritySrcPerChannel[selectedInterface][channel] = priorityStack;
                end else begin
                  sharedResource::trigDesInfoChannel[channel] = trigReqEnum'(sharedResource::topEnvConfigHandle.peripheralEnvConfigHandle.triggerSlaveAgentConfigHandle[triggerNum].desReqType);
                  for(int i=0;i<(axi4_globals_pkg :: NO_OF_SLAVES);i++) begin
                    if(sharedResource::dmaChannelRegHandle[channel].CH_DESADDR>= sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].min_address && sharedResource::dmaChannelRegHandle[channel].CH_DESADDR<sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].max_address) begin
                      selectedInterface=i;
                      break;
                    end
                  end
                  `uvm_info("TOP_SCOREBOARD",$sformatf("A HW trigger For DES has been received for channel[%0d] and selected interface is %0d",channel,selectedInterface),UVM_HIGH)
                  // Write operation (destination trigger)
                  sharedResource::dmaChannelRegHandle[channel].CH_STATUS.STAT_DESTRIGINWAIT = 0;
                  sharedResource::dmaChannelRegHandle[channel].CH_STATUS.INTR_DESTRIGINWAIT = 0;
                  priorityStack.srcAddr = sharedResource::dmaChannelRegHandle[channel].CH_SRCADDR;
                  priorityStack.desAddr = sharedResource::dmaChannelRegHandle[channel].CH_DESADDR;
                  priorityStack.commandStart = 1;
                  priorityStack.commandDone = 0;
                  priorityStack.channelPri = sharedResource::dmaChannelRegHandle[channel].CH_CTRL.CHPRIO;
                  sharedResource::priorityDesPerChannel[selectedInterface][channel] = priorityStack;
                end

                flag=1;
              end 
              $display("STARTED PACKET WAIT FOR TRIGGER %d channel is %d",triggerNum,channel); 
              
              peripheralUnitTriggerSlavePathAnalysisExport[triggerNum].get(triggerTx);         
              
              $display("TRIGGER GOT AT SCB @%t for trigger %d",$time(),triggerNum);
              
              if(sharedResource::pauseChannel[channel]==1)begin
                `uvm_error("TOP_SCOREBOARD",$sformatf("OBTAINED TRIGGER PACKET AT PORT %d INSPITE OF PAUSE",triggerNum))
                continue;
              end 

              if(sharedResource::stopChannel[channel]==1)begin
                `uvm_error("TOP_SCOREBOARD",$sformatf("OBTAINED TRIGGER PACKET AT PORT %d INSPITE OF STOP",triggerNum))
                continue;
              end

              if(done >0 && sharedResource::flowControl[triggerNum]==0) begin
               `uvm_error("TOP_SCOREBOARD",$sformatf("MULTIPLE REQ ACK HANDSHAKE TAKING PLACE @%0t for port %0d",$time(),triggerNum))
              end 
              done++;  
              `uvm_info("TOP_SCOREBOARD",  $sformatf("Trigger %0d received for channel %0d", triggerNum, channel), UVM_MEDIUM)
              if(flag==1) begin // for each subblock expecting a packet 
                for(int i=0;i<(axi4_globals_pkg :: NO_OF_SLAVES);i++) begin
                  if(sharedResource::dmaChannelRegHandle[channel].CH_DESADDR>= sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].min_address && sharedResource::dmaChannelRegHandle[channel].CH_DESADDR<sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].max_address) begin
                    selectedInterface=i;
                    break;
                  end
                end
                if(sharedResource::respRef[selectedInterface].bresp!=0) begin 
                  `uvm_error("TOP_SCOREBOARD","RECEIVED TRIG ACK INSPITE OF HAVING BUS ERROR WHEN HAVING TRIG MODE AS FLOW CONTROL MODE")
                end 
                flag=0; //is this necessary ?
                continue; 
              end 

              if (sharedResource::readWriteTriggerMap[triggerNum] == 0) begin
                // Read operation (source trigger)
                sharedResource ::dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE =sharedResource ::numberOfReadReq[channel];
                sharedResource::trigSrcInfoChannel[channel] = trigReqEnum'(triggerTx.reqType);
                `uvm_info("TOP_SCOREBOARD",$sformatf("TRIGGER TYPE RECEIVED IN SOURCE END IS %s",sharedResource ::trigSrcInfoChannel[channel]),UVM_NONE)
                for(int i=0;i<(axi4_globals_pkg :: NO_OF_SLAVES);i++) begin 
                  if(sharedResource::dmaChannelRegHandle[channel].CH_SRCADDR>= sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].min_address && sharedResource::dmaChannelRegHandle[channel].CH_SRCADDR<sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].max_address) begin
                    selectedInterface=i;             
                    break;
                  end 
                end 

                `uvm_info("TOP_SCOREBOARD",$sformatf("A HW trigger For SRC has been received for channel[%0d] and selected interface is %0d",channel,selectedInterface),UVM_HIGH)
                sharedResource::dmaChannelRegHandle[channel].CH_STATUS.STAT_SRCTRIGINWAIT = 0;
                sharedResource::dmaChannelRegHandle[channel].CH_STATUS.INTR_SRCTRIGINWAIT = 0;
                priorityStack.srcAddr = sharedResource::dmaChannelRegHandle[channel].CH_SRCADDR;
                priorityStack.desAddr = sharedResource::dmaChannelRegHandle[channel].CH_DESADDR;
                priorityStack.commandStart =1;
                priorityStack.commandDone = 0;
                priorityStack.channelPri = sharedResource::dmaChannelRegHandle[channel].CH_CTRL.CHPRIO;
                sharedResource::prioritySrcPerChannel[selectedInterface][channel] = priorityStack;
              end else begin
                sharedResource::trigDesInfoChannel[channel] = trigReqEnum'(triggerTx.reqType);
                for(int i=0;i<(axi4_globals_pkg :: NO_OF_SLAVES);i++) begin
                  if(sharedResource::dmaChannelRegHandle[channel].CH_DESADDR>= sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].min_address && sharedResource::dmaChannelRegHandle[channel].CH_DESADDR<sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].max_address) begin
                    selectedInterface=i;
                    break;
                  end
                end
                `uvm_info("TOP_SCOREBOARD",$sformatf("A HW trigger For DES has been received for channel[%0d] and selected interface is %0d",channel,selectedInterface),UVM_HIGH)
            // Write operation (destination trigger)
                sharedResource::dmaChannelRegHandle[channel].CH_STATUS.STAT_DESTRIGINWAIT = 0;
                sharedResource::dmaChannelRegHandle[channel].CH_STATUS.INTR_DESTRIGINWAIT = 0;
                priorityStack.srcAddr = sharedResource::dmaChannelRegHandle[channel].CH_SRCADDR;
                priorityStack.desAddr = sharedResource::dmaChannelRegHandle[channel].CH_DESADDR;
                priorityStack.commandStart = 1;
                priorityStack.commandDone = 0;
                priorityStack.channelPri = sharedResource::dmaChannelRegHandle[channel].CH_CTRL.CHPRIO;
                sharedResource::priorityDesPerChannel[selectedInterface][channel] = priorityStack;
              end
            end
          end 
          begin 
            wait(sharedResource::commandDone[triggerNum]==1) begin
              //sharedResource::triggerAccessed[triggerNum] = 0;
              thread.kill();
            end 
          end 
        join
        $display("DISABLE FOR TRIGGER %d",triggerNum);
        if(done==0 && !sharedResource::pauseChannel[channel] && !sharedResource::stopChannel[channel] ) begin 
          `uvm_error("TOP_SCOREBOARD",$sformatf("THE TRIGGER PORT %d HANDSHAKE HAS NOT TAKEN PLACE",triggerNum))
        end 
        done=0;
        // Release trigger port
        if (sharedResource::readWriteTriggerMap[triggerNum] == 0)begin 
          sharedResource ::triggerSrcTaskCall[channel] =0;
        end 
        else begin 
          sharedResource ::triggerDesTaskCall[channel]=0;
        end 
        sharedResource::triggerAccessed[triggerNum] = 0;
        $display("TRIGGER PORT[%d] HAS BEEN RELEASED",triggerNum);
        `uvm_info("TOP_SCOREBOARD",$sformatf("TRIGGER PORT[%d] HAS BEEN RELEASED",triggerNum),UVM_HIGH)
        sharedResource::commandDone[triggerNum] =0;
      end
    join_none
  end
endtask

task topTriggerSubScoreboard :: handleTriggerOut();
  foreach (peripheralUnitTriggerOutSlavePathAnalysisExport[i]) begin
    automatic int triggerNum = i;
    fork
      forever begin 
        triggerSlaveTx triggerTx;
        int channel;
        sharedResource::semaPhoreTriggerOutHandle[triggerNum].get(1);
        channel = sharedResource::triggerOutPortChannelMap[triggerNum];
        `uvm_info("TOP_SCOREBOARD",$sformatf("STARTED HW TRIGOUT WAIT FOR TRIGGER PORT %0d FOR CHANNEL %0d",triggerNum,channel),UVM_HIGH)
        peripheralUnitTriggerOutSlavePathAnalysisExport[triggerNum].get(triggerTx);
        `uvm_info("TOP_SCOREBOARD",$sformatf("GOT HW TRIGOUT WAIT FOR TRIGGER PORT %0d FOR CHANNEL %0d",triggerNum,channel),UVM_HIGH)

        if(sharedResource::numberOfWriteReq[channel] ==0) begin
         if(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.DONETYPE==1) begin
           sharedResource::dmaChannelRegHandle[channel].CH_STATUS.STAT_DONE=1;
           if(sharedResource::dmaChannelRegHandle[channel].CH_INTREN.INTREN_DONE ==1) begin
             sharedResource::dmaChannelRegHandle[channel].CH_STATUS.INTR_DONE =1;
             sharedResource::raiseInterrupt(channel,"DONE INTERRUPT RAISED");
           end
         end
        end

       if((sharedResource::dmaChannelRegHandle[channel].CH_LINKADDR.LINKADDREN != 1 || sharedResource::dmaChannelRegHandle[channel].CH_LINKADDR.LINKADDR ==0) && sharedResource::numberOfWriteReq[channel]==0) begin
          if(sharedResource::numberOfReadReq[channel]==0)
            sharedResource::dmaChannelRegHandle[channel].CH_CMD.ENABLECMD=0;
          end
       if(sharedResource::dmaChannelRegHandle[channel].CH_LINKADDR.LINKADDREN == 1 && sharedResource::dmaChannelRegHandle[channel].CH_LINKADDR.LINKADDR >0 && sharedResource::numberOfWriteReq[channel]==0) begin
        int slave_id;
        for(int i=0;i<(axi4_globals_pkg :: NO_OF_SLAVES);i++) begin
          if(sharedResource::dmaChannelRegHandle[channel].CH_SRCADDR>= sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].min_address && sharedResource::dmaChannelRegHandle[channel].CH_SRCADDR<sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].max_address) begin
            slave_id =i;
            break;
          end
        end

        $displa("STARTED LINK EN FOR ARBIT FOR CHANNEL %d",channel);
        sharedResource::dmaChannelRegHandle[channel].CH_CMD.ENABLECMD=1;
        sharedResource::prioritySrcPerChannel[slave_id][channel].commandStart=1;
        sharedResource::prioritySrcPerChannel[slave_id][channel].commandDone=0;
        sharedResource::commandStatusPerChannel[channel].readDone=0;
       end
       else begin 
          if(sharedResource::numberOfReadReq[channel]==0)
            sharedResource::dmaChannelRegHandle[channel].CH_CMD.ENABLECMD=0;
       end 
 
        if((sharedResource::numberOfWriteReq[channel]==0)&& sharedResource::numberOfReadReq[channel]==0&&(sharedResource ::dmaChannelRegHandle[channel].CH_CMD.PAUSECMD==1 || (sharedResource ::dmaChannelRegHandle[channel].CH_STATUS.STAT_DONE && sharedResource ::dmaChannelRegHandle[channel].CH_CTRL.DONEPAUSEEN))) begin 
          `uvm_info("TOP_SCOREBOARD",$sformatf("The command in channel[%0d] has been paused",channel),UVM_HIGH)
          sharedResource ::pauseChannel[channel] =1;
          sharedResource ::dmaChannelRegHandle[channel].CH_STATUS.STAT_PAUSED=1;
          sharedResource ::dmaChannelRegHandle[channel].CH_STATUS.STAT_RESUMEWAIT =1;
        end

        if(sharedResource ::dmaChannelRegHandle[channel].CH_CMD.DISABLECMD==1) begin
          `uvm_info("TOP_SCOREBOARD",$sformatf("The command in channel[%0d] has been disabled",channel),UVM_HIGH)
         sharedResource ::disableChannel[channel] = 1;
         sharedResource ::dmaChannelRegHandle[channel].CH_CMD.ENABLECMD=0;
         sharedResource ::dmaChannelRegHandle[channel].CH_STATUS.STAT_DISABLED=1;
         if(sharedResource::dmaChannelRegHandle[channel].CH_INTREN.INTREN_DISABLED) begin
            sharedResource::dmaChannelRegHandle[channel].CH_STATUS.INTR_DISABLED=1;
         end
       end


       sharedResource::triggerOutAccessed[triggerNum]=0;
      
        $display("TRIGGER ACCESSED CHECK AT SRC IS %d",sharedResource::triggerAccessed[0]);
       if(sharedResource::numberOfReadReq[channel] == 0) begin
         `uvm_info("TOP SCOREBOARD","NUMBER OF EXPECTED READS HAS TAKEN PLACE",UVM_HIGH)
       end
       else if(sharedResource::numberOfReadReq[channel] < 0)begin
         `uvm_error("TOP SCOREBOARD","MORE READ HAS OCCURED THAN EXPECTED ")
       end
       else begin 
         `uvm_error("TOP SCOREBOARD","NUMBER OF EXPECTED READS HAS NOT TAKEN PLACE")
       end 

       if(sharedResource::numberOfWriteReq[channel] == 0) begin
         `uvm_info("TOP SCOREBOARD","NUMBER OF EXPECTED WRITES HAS TAKEN PLACE",UVM_HIGH)
       end
       else if(sharedResource::numberOfWriteReq[channel] < 0)begin
         `uvm_error("TOP SCOREBOARD","MORE WRITES HAS OCCURED THAN EXPECTED ")
       end
       else begin
         `uvm_error("TOP SCOREBOARD","NUMBER OF EXPECTED WRITES HAS NOT TAKEN PLACE")
       end
       
       if(sharedResource::dmaChannelRegHandle[channel].CH_SRCTRIGINCFG.SRCTRIGINTYPE ==2'b 10) begin
         sharedResource::commandDone[sharedResource ::dmaChannelRegHandle[channel].CH_SRCTRIGINCFG.SRCTRIGINSEL] = 1;
       end 
       if(sharedResource::dmaChannelRegHandle[channel].CH_DESTRIGINCFG.DESTRIGINTYPE ==2'b 10) begin
         sharedResource::commandDone[sharedResource ::dmaChannelRegHandle[channel].CH_DESTRIGINCFG.DESTRIGINSEL] = 1;
       end 
        sharedResource::triggerAccessed[sharedResource ::dmaChannelRegHandle[channel].CH_DESTRIGINCFG.DESTRIGINSEL]=0; 
        sharedResource::triggerAccessed[sharedResource ::dmaChannelRegHandle[channel].CH_SRCTRIGINCFG.SRCTRIGINSEL]=0;
      if(sharedResource::disableChannel[channel]==0 && sharedResource::stopChannel[channel]==0)begin 
        if(sharedResource ::dmaChannelRegHandle[channel].CH_AUTOCFG.CMDRESTARTINFEN==1)begin
          if(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.DONETYPE==3)begin 
           sharedResource::dmaChannelRegHandle[channel].CH_STATUS.STAT_DONE=1;
            if(sharedResource::dmaChannelRegHandle[channel].CH_INTREN.INTREN_DONE ==1) begin
              sharedResource::dmaChannelRegHandle[channel].CH_STATUS.INTR_DONE =1;
              sharedResource::raiseInterrupt(channel,"DONE INTERRUPT RAISED");
            end
          end 

          sharedResource ::dmaChannelRegHandle[channel].CH_CMD.ENABLECMD=1;
          case(sharedResource ::dmaChannelRegHandle[channel].CH_CTRL.REGRELOADTYPE) 
            1: begin 
              sharedResource ::dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE = sharedResource::initialSrcXsize[channel];
              sharedResource ::dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE = sharedResource::initialDesXsize[channel];
              sharedResource ::dmaChannelRegHandle[channel].CH_DESADDR = sharedResource ::dmaChannelRegHandle[channel].CH_DESADDR +((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE)))-(((((sharedResource::dmaChannelRegHandle[channel].CH_DESADDR-sharedResource::initialDesAddress[channel]))%((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))))==0)? ((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))) : ((((sharedResource::dmaChannelRegHandle[channel].CH_DESADDR-sharedResource::initialDesAddress[channel]))%((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))))));
			  sharedResource ::dmaChannelRegHandle[channel].CH_SRCADDR = sharedResource ::dmaChannelRegHandle[channel].CH_SRCADDR +((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE)))-(((((sharedResource::dmaChannelRegHandle[channel].CH_SRCADDR-sharedResource::initialSrcAddress[channel]))%((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))))==0)? ((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))) : ((((sharedResource::dmaChannelRegHandle[channel].CH_SRCADDR-sharedResource::initialSrcAddress[channel]))%((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))))));
                           
            end 
         
            3: begin 
              sharedResource ::dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE = sharedResource::initialSrcXsize[channel];
              sharedResource ::dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE = sharedResource::initialDesXsize[channel];
              sharedResource ::dmaChannelRegHandle[channel].CH_SRCADDR = sharedResource::initialSrcAddress[channel];
              sharedResource ::dmaChannelRegHandle[channel].CH_DESADDR = sharedResource ::dmaChannelRegHandle[channel].CH_DESADDR +((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE)))-(((((sharedResource::dmaChannelRegHandle[channel].CH_DESADDR-sharedResource::initialDesAddress[channel]))%((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))))==0)? ((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))) : ((((sharedResource::dmaChannelRegHandle[channel].CH_DESADDR-sharedResource::initialDesAddress[channel]))%((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))))));
                
			end 
            5: begin 
              sharedResource ::dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE = sharedResource::initialSrcXsize[channel];
              sharedResource ::dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE = sharedResource::initialDesXsize[channel];
              sharedResource ::dmaChannelRegHandle[channel].CH_DESADDR = sharedResource::initialDesAddress[channel];
              sharedResource ::dmaChannelRegHandle[channel].CH_SRCADDR = sharedResource ::dmaChannelRegHandle[channel].CH_SRCADDR +((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE)))-(((((sharedResource::dmaChannelRegHandle[channel].CH_SRCADDR-sharedResource::initialSrcAddress[channel]))%((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))))==0)? ((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))) : ((((sharedResource::dmaChannelRegHandle[channel].CH_SRCADDR-sharedResource::initialSrcAddress[channel]))%((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))))));
               
            end 
  
            7:begin 
              sharedResource ::dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE = sharedResource::initialSrcXsize[channel];
              sharedResource ::dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE = sharedResource::initialDesXsize[channel];
              sharedResource ::dmaChannelRegHandle[channel].CH_DESADDR = sharedResource::initialDesAddress[channel];
              sharedResource ::dmaChannelRegHandle[channel].CH_SRCADDR = sharedResource::initialSrcAddress[channel];
            end 
            0: begin
              `uvm_info("TOP_SCOREBOARD","THE INFINITE LEN COMMAND IS INITIATED BUT NO RELOADING OF REGISTER IS DONE",UVM_HIGH)
            end 
            default : begin
              sharedResource ::dmaChannelRegHandle[channel].CH_ERRINFO.ERRINFO.REGVALERR=1;
              sharedResource ::dmaChannelRegHandle[channel].CH_ERRINFO.CFGERR=1;
              sharedResource ::dmaChannelRegHandle[channel].CH_STATUS.STAT_ERR =1;
              if(sharedResource ::dmaChannelRegHandle[channel].CH_INTREN.INTREN_ERR ==1) begin
                sharedResource ::raiseError(channel, "CONFIG ERROR");
              end 
            end 
          endcase
	        sharedResource ::triggerSrcTaskCall[channel]=0;
	        sharedResource ::triggerDesTaskCall[channel]=0;
	        sharedResource ::triggerOutTaskCall[channel]=0;
	        sharedResource::expectedReadAddr[channel].delete();
	        sharedResource::expectedWriteAddr[channel].delete();
	        sharedResource::numberOfReadReq[channel] = sharedResource::determineNumberOfReads(channel);
	        sharedResource::numberOfWriteReq[channel] = sharedResource::determineNumberOfWrites(channel);
	        sharedResource::setUp1DAddress(channel);
	        sharedResource :: setUpTrigger(channel);
        end 
        else if(sharedResource::reloadCount[channel] !=0) begin 
          if(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.DONETYPE==3)begin 
           sharedResource::dmaChannelRegHandle[channel].CH_STATUS.STAT_DONE=1;
            if(sharedResource::dmaChannelRegHandle[channel].CH_INTREN.INTREN_DONE ==1) begin
              sharedResource::dmaChannelRegHandle[channel].CH_STATUS.INTR_DONE =1;
              sharedResource::raiseInterrupt(channel,"DONE INTERRUPT RAISED");
            end
          end 

          sharedResource ::dmaChannelRegHandle[channel].CH_CMD.ENABLECMD=1;
          case(sharedResource ::dmaChannelRegHandle[channel].CH_CTRL.REGRELOADTYPE) 
            1: begin 
              sharedResource ::dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE = sharedResource::initialSrcXsize[channel];    
              sharedResource ::dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE = sharedResource::initialDesXsize[channel];
              $display("SRC ADDR IS %d",sharedResource ::dmaChannelRegHandle[channel].CH_SRCADDR);
              $display("EXCESS IS %d",(( sharedResource ::dmaChannelRegHandle[channel].CH_SRCADDR - sharedResource::initialSrcAddress[channel])%((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource ::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE)))));
              $display("MODULUS IS %d of %d",(sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE)*(2**(sharedResource ::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE)),sharedResource ::dmaChannelRegHandle[channel].CH_SRCADDR);
              $display("cond is %d",((sharedResource ::dmaChannelRegHandle[channel].CH_SRCADDR %((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))))==0));
              $display("brotehr sub is %d",(((sharedResource ::dmaChannelRegHandle[channel].CH_SRCADDR %((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource ::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))))==0) ? ((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource ::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))):(((sharedResource::dmaChannelRegHandle[channel].CH_SRCADDR-sharedResource::initialSrcAddress[channel]))%((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE)))))); 
            /*  sharedResource::dmaChannelRegHandle[channel].CH_DESADDR = sharedResource::dmaChannelRegHandle[channel].CH_DESADDR + ((sharedResource::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE) * (2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))) - ((sharedResource::dmaChannelRegHandle[channel].CH_DESADDR %(((sharedResource::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE) * (2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE)))))==0? (((sharedResource::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE) * (2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE)))):(((sharedResource::dmaChannelRegHandle[channel].CH_DESADDR - sharedResource::initialDesAddress[channel])) % ((sharedResource::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE) * (2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE)))));
*/
               
              sharedResource ::dmaChannelRegHandle[channel].CH_DESADDR = sharedResource ::dmaChannelRegHandle[channel].CH_DESADDR +((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE)))-(((((sharedResource::dmaChannelRegHandle[channel].CH_DESADDR-sharedResource::initialDesAddress[channel]))%((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))))==0)? ((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))) : ((((sharedResource::dmaChannelRegHandle[channel].CH_DESADDR-sharedResource::initialDesAddress[channel]))%((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))))));
               
              sharedResource ::dmaChannelRegHandle[channel].CH_SRCADDR = sharedResource ::dmaChannelRegHandle[channel].CH_SRCADDR +((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE)))-(((((sharedResource::dmaChannelRegHandle[channel].CH_SRCADDR-sharedResource::initialSrcAddress[channel]))%((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))))==0)? ((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))) : ((((sharedResource::dmaChannelRegHandle[channel].CH_SRCADDR-sharedResource::initialSrcAddress[channel]))%((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))))));
              $display("SRC ADDR IS %d",sharedResource ::dmaChannelRegHandle[channel].CH_SRCADDR);
            end 
         
            3: begin 
              sharedResource ::dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE = sharedResource::initialSrcXsize[channel];
              sharedResource ::dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE = sharedResource::initialDesXsize[channel];
              sharedResource ::dmaChannelRegHandle[channel].CH_SRCADDR = sharedResource::initialSrcAddress[channel];
              sharedResource ::dmaChannelRegHandle[channel].CH_DESADDR = sharedResource ::dmaChannelRegHandle[channel].CH_DESADDR +((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE)))-(((((sharedResource::dmaChannelRegHandle[channel].CH_DESADDR-sharedResource::initialDesAddress[channel]))%((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))))==0)? ((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))) : ((((sharedResource::dmaChannelRegHandle[channel].CH_DESADDR-sharedResource::initialDesAddress[channel]))%((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))))));
                  
			end 
            5: begin 
              sharedResource ::dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE = sharedResource::initialSrcXsize[channel];
              sharedResource ::dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE = sharedResource::initialDesXsize[channel];
              sharedResource ::dmaChannelRegHandle[channel].CH_DESADDR = sharedResource::initialDesAddress[channel];
              $display("SRC ADDR IS %d",sharedResource ::dmaChannelRegHandle[channel].CH_SRCADDR);
              sharedResource ::dmaChannelRegHandle[channel].CH_SRCADDR = sharedResource ::dmaChannelRegHandle[channel].CH_SRCADDR +((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE)))-(((((sharedResource::dmaChannelRegHandle[channel].CH_SRCADDR-sharedResource::initialSrcAddress[channel]))%((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))))==0)? ((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))) : ((((sharedResource::dmaChannelRegHandle[channel].CH_SRCADDR-sharedResource::initialSrcAddress[channel]))%((sharedResource ::dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE))))));
              
                   
            end 
  
            7:begin 
              sharedResource ::dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE = sharedResource::initialSrcXsize[channel];
              sharedResource ::dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE = sharedResource::initialDesXsize[channel];
              sharedResource ::dmaChannelRegHandle[channel].CH_DESADDR = sharedResource::initialDesAddress[channel];
              sharedResource ::dmaChannelRegHandle[channel].CH_SRCADDR = sharedResource::initialSrcAddress[channel];
            end 
            0: begin
              `uvm_info("TOP_SCOREBOARD","THE FINITE LEN COMMAND IS INITIATED BUT NO RELOADING OF REGISTER IS DONE",UVM_HIGH)
            end 
            default : begin
              sharedResource ::dmaChannelRegHandle[channel].CH_ERRINFO.ERRINFO.REGVALERR=1;
              sharedResource ::dmaChannelRegHandle[channel].CH_ERRINFO.CFGERR=1;
              sharedResource ::dmaChannelRegHandle[channel].CH_STATUS.STAT_ERR =1;
              if(sharedResource ::dmaChannelRegHandle[channel].CH_INTREN.INTREN_ERR ==1) begin
                sharedResource ::raiseError(channel, "CONFIG ERROR");
              end 
            end 
          endcase
	        sharedResource ::triggerSrcTaskCall[channel]=0;
	        sharedResource ::triggerDesTaskCall[channel]=0;
	        sharedResource ::triggerOutTaskCall[channel]=0;
	        sharedResource::expectedReadAddr[channel].delete();
	        sharedResource::expectedWriteAddr[channel].delete();
	        sharedResource::numberOfReadReq[channel] = sharedResource::determineNumberOfReads(channel);
	        sharedResource::numberOfWriteReq[channel] = sharedResource::determineNumberOfWrites(channel);
	        sharedResource::setUp1DAddress(channel);
	        sharedResource :: setUpTrigger(channel);
          sharedResource::reloadCount[channel] = sharedResource::reloadCount[channel]-1;
        end 
      end 

       if(sharedResource::numberOfWriteReq[channel] ==0) begin
         if(sharedResource::dmaChannelRegHandle[channel].CH_CTRL.DONETYPE==1) begin
           sharedResource::dmaChannelRegHandle[channel].CH_STATUS.STAT_DONE=1;
           if(sharedResource::dmaChannelRegHandle[channel].CH_INTREN.INTREN_DONE ==1) begin
             sharedResource::dmaChannelRegHandle[channel].CH_STATUS.INTR_DONE =1;
             sharedResource::raiseInterrupt(channel,"DONE INTERRUPT RAISED");
           end
         end
       end
       sharedResource::dmaChannelRegHandle[channel].CH_STATUS.INTR_TRIGOUTACKWAIT=0;
       sharedResource::dmaChannelRegHandle[channel].CH_STATUS.STAT_TRIGOUTACKWAIT=0;

      end 
    join_none
  end 

endtask


`endif

 
