`ifndef TOPAPBSUBSCOREBOARD_INCLUDED 
`define TOPAPBSUBSCOREBOARD_INCLUDED 

class topApbSubScoreboard extends uvm_component;
  
  `uvm_component_utils(topApbSubScoreboard)
 
  uvm_tlm_analysis_fifo #(apb_master_tx) configUnitApbPathAnalysisExport;

  extern function new(string name = "topApbSubScoreboard",uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern task handleApbTransaction();
  extern function int decodeTheChannelTask(apb_master_tx tx);
  
endclass

//Function name: new
//Description  : CONSTRUCTOR
function topApbSubScoreboard :: new(string  name = "topApbSubScoreboard",uvm_component parent=null);
  super.new(name,parent);
endfunction  

//Function name:build_phase
//Description  : build_phase one of the phases in uvm component
function void topApbSubScoreboard :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  configUnitApbPathAnalysisExport = new("configUnitApbPathAnalysisExport", this);
endfunction

//Function name: decodeTheChannelTask
//Description  : The function is used to determine the channel the Software is trying to write or
//read into based on the address.Which is determined based on the range inside which the address
//falls into
function int topApbSubScoreboard::decodeTheChannelTask(apb_master_tx tx);
  for (int i = 0; i < dmaGlobalPkg::NUM_CHANNELS; i++) begin
    if (tx.paddr >= ('h100 + ('h100 * (i))) &&
        (tx.paddr < ('h100 + ('h100 * (i + 1))))) begin
      return i ;
    end
  end
  return -1;
endfunction


task topApbSubScoreboard :: handleApbTransaction();
 forever begin
    apb_master_tx transaction;
    int selectedChannel;
    
    configUnitApbPathAnalysisExport.get(transaction);
    selectedChannel = decodeTheChannelTask(transaction);
   
    if (selectedChannel < 0) begin
      `uvm_warning("TOP_SCOREBOARD", $sformatf("Invalid channel decode for address 0x%0h", transaction.paddr))
      continue;
    end
    
    if (transaction.pwrite == 0) begin
      // READ operation - compare with local mirror
      int selectedRegStartAddress;
      int closestChannelBaseAddress;
      bit [(apb_global_pkg::DATA_WIDTH)-1:0] expected_data; 

      for (int i = 0; i <dmaGlobalPkg::NUM_CHANNELS; i++) begin
        if (transaction.paddr >= ('h100 + ('h100 * (i))) && 
            (transaction.paddr < ('h100 + ('h100 * (i + 1))))) begin
          closestChannelBaseAddress = ('h100 + ('h100 * (i)));
          break;
        end
      end
     
      `uvm_info("TOP_SCOREBOARD",$sformatf("APB READ HAPPENING FOR CHANNEL %0D ITS BASE ADDRESS IS %0h",selectedChannel,closestChannelBaseAddress),UVM_HIGH);
      selectedRegStartAddress = (transaction.paddr - closestChannelBaseAddress) * 8;
    
      `uvm_info("TOP_SCOREBOARD",$sformatf("APB READ IS BEING DONE FROM %0d BIT POSITION",selectedRegStartAddress),UVM_HIGH); 
      for (int i = 0; i < (apb_global_pkg::DATA_WIDTH / 8); i++) begin
        expected_data[((8 * i) + 7) -: 8] = sharedResource :: dmaChannelRegHandle[selectedChannel][(selectedRegStartAddress) + ((8 * i)) +: 8];
      end
      
      
      if (expected_data !== transaction.prdata) begin
        `uvm_error("TOP_SCOREBOARD", $sformatf(" APB CHANNEL[%0d] Read data mismatch at addr 0x%0h: Expected=0x%0h, Got=0x%0h",selectedChannel, transaction.paddr, expected_data, transaction.prdata))
      end else begin
        `uvm_info("TOP_SCOREBOARD", $sformatf("APB CHANNEL[%0d] Expected Read data [%0d] matches at addr 0x%0h: Actual Data=0x%0h",selectedChannel, expected_data ,transaction.paddr, transaction.prdata), UVM_HIGH)
      end
      
    end else begin
      // WRITE operation - update local mirror
      int selectedRegStartAddress;
      int closestChannelBaseAddress;
      
      for (int i = 0; i < dmaGlobalPkg::NUM_CHANNELS; i++) begin
        if (transaction.paddr >= ('h100 + ('h100 * (i))) && 
            (transaction.paddr < ('h100 + ('h100 * (i + 1))))) begin
          closestChannelBaseAddress = ('h100 + ('h100 * (i)));
          break;
        end
      end
      
      `uvm_info("TOP_SCOREBOARD",$sformatf("APB WRITE HAPPENING FOR CHANNEL %0D ITS BASE ADDRESS IS %0h",selectedChannel,closestChannelBaseAddress),UVM_HIGH);
      selectedRegStartAddress = (transaction.paddr - closestChannelBaseAddress) * 8;

      `uvm_info("TOP_SCOREBOARD",$sformatf("APB WRITE IS BEING DONE FROM %0d BIT POSITION",selectedRegStartAddress),UVM_HIGH);
 
      for (int i = 0; i < (apb_global_pkg::DATA_WIDTH / 8); i++) begin
        sharedResource :: dmaChannelRegHandle[selectedChannel][(selectedRegStartAddress) + ((8 * i)) +: 8] = transaction.pwdata[((8 * i) + 7) -: 8];
      end
      
      `uvm_info("TOP_SCOREBOARD", $sformatf("Channel[%0d] Write to addr 0x%0h: Data=0x%0h",selectedChannel, transaction.paddr, transaction.pwdata), UVM_HIGH)
      
      if(sharedResource :: dmaChannelRegHandle[selectedChannel].CH_WRKREGPTR.WRKREGPTR==1) begin 
        sharedResource ::dmaChannelRegHandle[selectedChannel].CH_WRKREGVAL = sharedResource ::initialSrcAddress[selectedChannel];
      end 
      
      if(sharedResource ::dmaChannelRegHandle[selectedChannel].CH_WRKREGPTR.WRKREGPTR==2) begin
        sharedResource ::dmaChannelRegHandle[selectedChannel].CH_WRKREGVAL = sharedResource ::initialDesAddress[selectedChannel];
      end

      if(sharedResource ::dmaChannelRegHandle[selectedChannel].CH_WRKREGPTR.WRKREGPTR==5) begin
        sharedResource ::dmaChannelRegHandle[selectedChannel].CH_WRKREGVAL = sharedResource ::initialSrcXsize[selectedChannel];
      end
      
      if(sharedResource ::dmaChannelRegHandle[selectedChannel].CH_WRKREGPTR.WRKREGPTR==6) begin
        sharedResource ::dmaChannelRegHandle[selectedChannel].CH_WRKREGVAL = sharedResource ::initialDesXsize[selectedChannel];
      end

      if(sharedResource ::dmaChannelRegHandle[selectedChannel].CH_WRKREGPTR.WRKREGPTR==11) begin
        sharedResource ::dmaChannelRegHandle[selectedChannel].CH_WRKREGVAL = sharedResource ::initialSrcYsize[selectedChannel];
      end

      if(sharedResource ::dmaChannelRegHandle[selectedChannel].CH_WRKREGPTR.WRKREGPTR==12) begin
        sharedResource ::dmaChannelRegHandle[selectedChannel].CH_WRKREGVAL = sharedResource ::initialDesYsize[selectedChannel];
      end

     
      // Check if channel is being enabled
      if(sharedResource ::dmaChannelRegHandle[selectedChannel].CH_CMD.ENABLECMD == 1 && sharedResource::dmaChannelRegHandle[selectedChannel].CH_STATUS.STAT_DONE==0) begin
        sharedResource ::dmaChannelRegHandle[selectedChannel].CH_STATUS.STAT_STOPPED =0;
        sharedResource ::dmaChannelRegHandle[selectedChannel].CH_STATUS.STAT_DISABLED=0;
        sharedResource ::disableChannel[selectedChannel] = 0;
        if((sharedResource ::dmaChannelRegHandle[selectedChannel].CH_CTRL.TRANSIZE > dmaGlobalPkg ::DATA_WIDTH_CFG)|| (sharedResource ::dmaChannelRegHandle[selectedChannel].CH_SRCTRIGINCFG.SRCTRIGINSEL>sharedResource ::dmaInfoHandle.DMA_BUILDCFG1.NUM_TRIGGER_IN) || (sharedResource ::dmaChannelRegHandle[selectedChannel].CH_DESTRIGINCFG.DESTRIGINSEL>sharedResource ::dmaInfoHandle.DMA_BUILDCFG1.NUM_TRIGGER_IN) || (sharedResource ::dmaChannelRegHandle[selectedChannel].CH_TRIGOUTCFG.TRIGOUTSEL>sharedResource::dmaInfoHandle.DMA_BUILDCFG1.NUM_TRIGGER_OUT)) begin
          `uvm_error("TOP_SCOREBOARD",$sformatf("REG VALL ERR CAUSED WHEN TRANSIZE IS %0D AND DATA WIDTH IS %0d , SRCTRIGSEL IS %0d , DESTRIGSEL IS %0d , TRIGOUTSEL IS %0d and NUM OF TRIGPORTS IS %0d",sharedResource ::dmaChannelRegHandle[selectedChannel].CH_CTRL.TRANSIZE,dmaGlobalPkg ::DATA_WIDTH_CFG,sharedResource ::dmaChannelRegHandle[selectedChannel].CH_SRCTRIGINCFG.SRCTRIGINSEL,sharedResource ::dmaChannelRegHandle[selectedChannel].CH_DESTRIGINCFG.DESTRIGINSEL,sharedResource ::dmaChannelRegHandle[selectedChannel].CH_TRIGOUTCFG.TRIGOUTSEL,sharedResource ::dmaInfoHandle.DMA_BUILDCFG1.NUM_TRIGGER_IN))
          sharedResource ::dmaChannelRegHandle[selectedChannel].CH_ERRINFO.ERRINFO.REGVALERR=1;
          sharedResource ::dmaChannelRegHandle[selectedChannel].CH_ERRINFO.CFGERR=1;
          sharedResource ::dmaChannelRegHandle[selectedChannel].CH_STATUS.STAT_ERR =1;
          if(sharedResource ::dmaChannelRegHandle[selectedChannel].CH_INTREN.INTREN_ERR ==1) begin
            sharedResource ::raiseError(selectedChannel, "CONFIG ERROR");
          end
          continue;      
 
        end
        fork
          if(sharedResource ::dmaChannelRegHandle[selectedChannel].CH_CTRL.USESRCTRIGIN==1)begin                 if(sharedResource ::triggerSrcTaskCall[selectedChannel] == 0)begin  
              sharedResource ::numberOfReadReq[selectedChannel] = sharedResource ::determineNumberOfReads(selectedChannel);
              sharedResource ::numberOfWriteReq[selectedChannel] = sharedResource ::determineNumberOfWrites(selectedChannel);
              if((sharedResource::dmaChannelRegHandle[selectedChannel].CH_CTRL.XTYPE==X_FILL || sharedResource::dmaChannelRegHandle[selectedChannel].CH_CTRL.YTYPE==Y_FILL) && sharedResource::numberOfReadReq[selectedChannel]==0) begin 
                //sharedResource::commandStatusPerChannel[selectedChannel].readDone=1;
                sharedResource::commandStatusPerChannel[selectedChannel].readCounter.push_back(sharedResource ::initialDesXsize[selectedChannel]);
                sharedResource::commandStatusPerChannel[selectedChannel].count = sharedResource ::initialDesYsize[selectedChannel];
              end 
	      sharedResource ::setUp1DAddress(selectedChannel);
	      `uvm_info("TOP_SCOREBOARD",$sformatf("THE COMMAND IN CHANNEL[%0D] HAS %0D AND %0d NUMBER OF EXPECTED READS AND WRITES",selectedChannel,sharedResource::numberOfReadReq[selectedChannel],sharedResource :: numberOfWriteReq[selectedChannel]),UVM_HIGH)
              sharedResource ::initiateSrcTriggerTransfer(selectedChannel);
            sharedResource::reloadCount[selectedChannel]=sharedResource::dmaChannelRegHandle[selectedChannel].CH_AUTOCFG.CMDRESTARTCNT;
            end 
          end 
          else begin 
            sharedResource ::channelPriority priorityStack;
            int selectedInterface;
            `uvm_info("TOP_SCOREBOARD","EXPECTED READ AXI TRANSFERS WITHOUT TRIGGER AS TRIGGER IS DISABLED IN CTRL",UVM_HIGH)
            sharedResource ::dmaChannelRegHandle[selectedChannel].CH_STATUS.STAT_SRCTRIGINWAIT = 0;
            sharedResource ::dmaChannelRegHandle[selectedChannel].CH_STATUS.INTR_SRCTRIGINWAIT = 0;
            sharedResource ::numberOfReadReq[selectedChannel] = sharedResource ::determineNumberOfReads(selectedChannel);
            sharedResource ::numberOfWriteReq[selectedChannel] = sharedResource ::determineNumberOfWrites(selectedChannel);
            sharedResource ::setUp1DAddress(selectedChannel);
	    `uvm_info("TOP_SCOREBOARD",$sformatf("THE COMMAND IN CHANNEL[%0D] HAS %0D AND %0d NUMBER OF EXPECTED READS AND WRITES",selectedChannel,sharedResource::numberOfReadReq[selectedChannel],sharedResource::numberOfWriteReq[selectedChannel]),UVM_HIGH)
            sharedResource ::trigSrcInfoChannel[selectedChannel] = BLOCK;
            sharedResource ::initialSrcXsize[selectedChannel]=sharedResource ::dmaChannelRegHandle[selectedChannel].CH_XSIZE.SRCXSIZE;
            sharedResource ::initialSrcAddress[selectedChannel]= sharedResource ::dmaChannelRegHandle[selectedChannel].CH_SRCADDR;
            sharedResource ::initialSrcYsize[selectedChannel]=sharedResource ::dmaChannelRegHandle[selectedChannel].CH_YSIZE.SRCYSIZE;
            for(int i=0;i<(axi4_globals_pkg :: NO_OF_SLAVES);i++) begin
              if(sharedResource ::dmaChannelRegHandle[selectedChannel].CH_SRCADDR>= sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].min_address && sharedResource ::dmaChannelRegHandle[selectedChannel].CH_SRCADDR<sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].max_address) begin
                selectedInterface=i;
                break;
              end
            end
            sharedResource ::triggerSrcTaskCall[selectedChannel]=1;
            priorityStack.srcAddr = sharedResource ::dmaChannelRegHandle[selectedChannel].CH_SRCADDR;
            priorityStack.desAddr = sharedResource ::dmaChannelRegHandle[selectedChannel].CH_DESADDR;
            priorityStack.commandStart =1;
            priorityStack.commandDone = 0;
            priorityStack.channelPri = sharedResource ::dmaChannelRegHandle[selectedChannel].CH_CTRL.CHPRIO;
            sharedResource ::prioritySrcPerChannel[selectedInterface][selectedChannel] = priorityStack;
          end
          
          if(sharedResource ::dmaChannelRegHandle[selectedChannel].CH_CTRL.USEDESTRIGIN==1)begin 
            if(sharedResource ::triggerDesTaskCall[selectedChannel] == 0)begin
              sharedResource ::initiateDesTriggerTransfer(selectedChannel);
            end
          end 
          else begin
             sharedResource ::channelPriority priorityStack;
             int selectedInterface;
             `uvm_info("TOP_SCOREBOARD","EXPECTED AXI WRITE TRANSFERS WITHOUT TRIGGER AS TRIGGER IS DISABLED IN CTRL",UVM_HIGH)
             sharedResource ::initialDesAddress[selectedChannel] = sharedResource ::dmaChannelRegHandle[selectedChannel].CH_DESADDR;
             sharedResource ::initialDesXsize[selectedChannel]=sharedResource ::dmaChannelRegHandle[selectedChannel].CH_XSIZE.DESXSIZE;
             sharedResource ::initialDesYsize[selectedChannel]=sharedResource ::dmaChannelRegHandle[selectedChannel].CH_YSIZE.DESYSIZE;
             sharedResource ::dmaChannelRegHandle[selectedChannel].CH_STATUS.STAT_DESTRIGINWAIT = 0;
             sharedResource ::dmaChannelRegHandle[selectedChannel].CH_STATUS.INTR_DESTRIGINWAIT = 0;
             sharedResource ::triggerDesTaskCall[selectedChannel]=1;
             sharedResource ::trigDesInfoChannel[selectedChannel] = BLOCK;
             sharedResource ::numberOfReadReq[selectedChannel] = sharedResource ::determineNumberOfReads(selectedChannel);
             sharedResource ::numberOfWriteReq[selectedChannel] = sharedResource ::determineNumberOfWrites(selectedChannel);
             sharedResource ::setUp1DAddress(selectedChannel);
	     `uvm_info("TOP_SCOREBOARD",$sformatf("THE COMMAND IN CHANNEL[%0D] HAS %0D AND %0d NUMBER OF EXPECTED READS AND WRITES",selectedChannel,sharedResource ::numberOfReadReq[selectedChannel],sharedResource ::numberOfWriteReq[selectedChannel]),UVM_HIGH)
             for(int i=0;i<(axi4_globals_pkg :: NO_OF_SLAVES);i++) begin
               if(sharedResource ::dmaChannelRegHandle[selectedChannel].CH_DESADDR>= sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].min_address && sharedResource ::dmaChannelRegHandle[selectedChannel].CH_DESADDR<sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].max_address) begin
                 selectedInterface=i;
                 break;
               end
             end 
            priorityStack.srcAddr = sharedResource ::dmaChannelRegHandle[selectedChannel].CH_SRCADDR;
            priorityStack.desAddr = sharedResource ::dmaChannelRegHandle[selectedChannel].CH_DESADDR;
            priorityStack.commandStart = 1;
            priorityStack.commandDone = 0;
            priorityStack.channelPri = sharedResource ::dmaChannelRegHandle[selectedChannel].CH_CTRL.CHPRIO;
            sharedResource ::priorityDesPerChannel[selectedInterface][selectedChannel] = priorityStack;
          end 
          
          if(sharedResource ::dmaChannelRegHandle[selectedChannel].CH_CTRL.USETRIGOUT)begin 
            if(sharedResource ::triggerOutTaskCall[selectedChannel]==0) begin
              sharedResource ::initiateTriggerOutTransfer(selectedChannel);
            end 
          end 
        join
        
        /*if(sharedResource ::dmaChannelRegHandle[selectedChannel].CH_STATUS.STAT_DONE==1) begin 
          if(sharedResource ::dmaChannelRegHandle[selectedChannel].CH_LINKADDR.LINKADDREN && sharedResource ::dmaChannelRegHandle[selectedChannel].CH_LINKADDR.LINKADDR >0)begin 
            sharedResource ::channelRequestingLink = selectedChannel;
          end  
          endI/   
                     
        if(sharedResource ::dmaChannelRegHandle[selectedChannel].CH_CMD.STOPCMD==1)begin
          int selectedInterface;
          `uvm_info("TOP_SCOREBOARD",$sformatf("The command in channel[%0d] has been stopped",selectedChannel),UVM_HIGH) 
          sharedResource ::stopChannel[selectedChannel]=1;
          sharedResource ::dmaChannelRegHandle[selectedChannel].CH_CMD.ENABLECMD=0;

          for(int i=0;i<(axi4_globals_pkg :: NO_OF_SLAVES);i++) begin
            if(sharedResource::dmaChannelRegHandle[selectedChannel].CH_SRCADDR>= sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].min_address && sharedResource::dmaChannelRegHandle[selectedChannel].CH_SRCADDR<sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].max_address) begin
              selectedInterface=i;
              break;
            end
          end
          sharedResource::prioritySrcPerChannel[selectedInterface][selectedChannel].commandStart=0;
          sharedResource::prioritySrcPerChannel[selectedInterface][selectedChannel].commandDone=0;
          for(int i=0;i<(axi4_globals_pkg :: NO_OF_SLAVES);i++) begin
            if(sharedResource::dmaChannelRegHandle[selectedChannel].CH_SRCADDR>= sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].min_address && sharedResource::dmaChannelRegHandle[selectedChannel].CH_SRCADDR<sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].max_address) begin
              selectedInterface=i;
              break;
            end
          end
          sharedResource::priorityDesPerChannel[selectedInterface][selectedChannel].commandStart=    0;
          sharedResource::priorityDesPerChannel[selectedInterface][selectedChannel].commandDone=0    ;
          sharedResource::commandStatusPerChannel[selectedInterface].readDone =0;
          sharedResource::waitForResp[selectedChannel]=0;
          sharedResource::dmaChannelRegHandle[selectedChannel].CH_STATUS.STAT_SRCTRIGINWAIT = 0;
          if(sharedResource::dmaChannelRegHandle[selectedChannel].CH_INTREN.INTREN_SRCTRIGINWAIT==1) begin
             sharedResource::dmaChannelRegHandle[selectedChannel].CH_STATUS.INTR_SRCTRIGINWAIT=0;
          end

          sharedResource::dmaChannelRegHandle[selectedChannel].CH_STATUS.STAT_DESTRIGINWAIT = 0;
          if(sharedResource::dmaChannelRegHandle[selectedChannel].CH_INTREN.INTREN_DESTRIGINWAIT==1) begin
            sharedResource::dmaChannelRegHandle[selectedChannel].CH_STATUS.INTR_DESTRIGINWAIT=0;
          end
          sharedResource::commandDone[sharedResource ::dmaChannelRegHandle[selectedChannel].CH_SRCTRIGINCFG.SRCTRIGINSEL] = 1;
      sharedResource::commandDone[sharedResource ::dmaChannelRegHandle[selectedChannel].CH_DESTRIGINCFG.DESTRIGINSEL] = 1;
          if (sharedResource::readWriteTriggerMap[sharedResource ::dmaChannelRegHandle[selectedChannel].CH_SRCTRIGINCFG.SRCTRIGINSEL] == 0)begin 
            sharedResource ::triggerSrcTaskCall[selectedChannel] =0;
          end 
          else begin 
            sharedResource ::triggerDesTaskCall[selectedChannel]=0;
          end
          sharedResource ::triggerOutTaskCall[selectedChannel]=0;
          sharedResource ::dmaChannelRegHandle[selectedChannel].CH_STATUS.STAT_STOPPED =1;
        end
 
        if(sharedResource ::dmaChannelRegHandle[selectedChannel].CH_CMD.RESUMECMD==1) begin
          `uvm_info("TOP_SCOREBOARD",$sformatf("The command in channel[%0d] has been resumed",selectedChannel),UVM_HIGH)
          sharedResource ::pauseChannel[selectedChannel] =0;
          sharedResource ::dmaChannelRegHandle[selectedChannel].CH_STATUS.STAT_PAUSED=0;
          sharedResource ::dmaChannelRegHandle[selectedChannel].CH_STATUS.STAT_RESUMEWAIT =0;   
          sharedResource ::dmaChannelRegHandle[selectedChannel].CH_CMD.RESUMECMD=0;
        end
       
        /*if(sharedResource ::dmaChannelRegHandle[selectedChannel].CH_CMD.DISABLECMD==1) begin
          `uvm_info("TOP_SCOREBOARD",$sformatf("The command in channel[%0d] has been disabled",selectedChannel),UVM_HIGH)
          sharedResource ::dmaChannelRegHandle[selectedChannel].CH_CMD.DISABLECMD=0;
          sharedResource ::disableChannel[selectedChannel] = 0;
          sharedResource ::dmaChannelRegHandle[selectedChannel].CH_CMD.ENABLECMD=1;
          sharedResource ::dmaChannelRegHandle[selectedChannel].CH_STATUS.STAT_DISABLED=0;
        end*/ 
        if(sharedResource ::dmaChannelRegHandle[selectedChannel].CH_CMD.PAUSECMD==1 || (sharedResource ::dmaChannelRegHandle[selectedChannel].CH_STATUS.STAT_DONE && sharedResource ::dmaChannelRegHandle[selectedChannel].CH_CTRL.DONEPAUSEEN)) begin 
          `uvm_info("TOP_SCOREBOARD",$sformatf("The command in channel[%0d] has been paused",selectedChannel),UVM_HIGH)
          sharedResource ::pauseChannel[selectedChannel] =1;
          sharedResource ::dmaChannelRegHandle[selectedChannel].CH_STATUS.STAT_PAUSED=1;
          sharedResource ::dmaChannelRegHandle[selectedChannel].CH_STATUS.STAT_RESUMEWAIT =1;
        end 
      end
    end
   if(transaction.pwrite==1)begin   
     int selectedRegStartAddress;
      int closestChannelBaseAddress;
      
      for (int i = 0; i < dmaGlobalPkg::NUM_CHANNELS; i++) begin
        if (transaction.paddr >= ('h100 + ('h100 * (i))) && 
            (transaction.paddr < ('h100 + ('h100 * (i + 1))))) begin
          closestChannelBaseAddress = ('h100 + ('h100 * (i)));
          break;
        end
      end
      
      `uvm_info("TOP_SCOREBOARD",$sformatf("APB WRITE HAPPENING FOR CHANNEL %0D ITS BASE ADDRESS IS %0h",selectedChannel,closestChannelBaseAddress),UVM_HIGH);
      selectedRegStartAddress = (transaction.paddr - closestChannelBaseAddress) * 8;
      if(selectedRegStartAddress == 32)begin 
        if(transaction.pwdata=='h 10000)begin 
          sharedResource::dmaChannelRegHandle[selectedChannel].CH_STATUS.STAT_DONE=0;
          sharedResource::dmaChannelRegHandle[selectedChannel].CH_STATUS.INTR_DONE=0;
        end 
      end 

   end 
  end
endtask
 
`endif
