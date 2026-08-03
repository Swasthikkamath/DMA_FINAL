`ifndef TOPAXISUBSCOREBOARD_INCLUDED
  `define TOPAXISUBSCOREBOARD_INCLUDED


  class topAxiSubScoreboard extends uvm_component;
    `uvm_component_utils(topAxiSubScoreboard)

    uvm_tlm_analysis_fifo #(axi4_master_tx) peripheralUnitAxi4MasterPathWriteAddressAnalysisExport[];
    uvm_tlm_analysis_fifo #(axi4_master_tx) peripheralUnitAxi4MasterPathWriteDataAnalysisExport[];
    uvm_tlm_analysis_fifo #(axi4_master_tx) peripheralUnitAxi4MasterPathWriteResponseAnalysisExport[];
    uvm_tlm_analysis_fifo #(axi4_master_tx) peripheralUnitAxi4MasterPathReadAddressAnalysisExport[];
    uvm_tlm_analysis_fifo #(axi4_master_tx) peripheralUnitAxi4MasterPathReadDataAnalysisExport[];

    // Analysis FIFOs - AXI Slave Path
    uvm_tlm_analysis_fifo #(axi4_slave_tx) peripheralUnitAxi4SlavePathWriteAddressAnalysisExport[];
    uvm_tlm_analysis_fifo #(axi4_slave_tx) peripheralUnitAxi4SlavePathWriteDataAnalysisExport[];
    uvm_tlm_analysis_fifo #(axi4_slave_tx) peripheralUnitAxi4SlavePathWriteResponseAnalysisExport[];
    uvm_tlm_analysis_fifo #(axi4_slave_tx) peripheralUnitAxi4SlavePathReadAddressAnalysisExport[];
    uvm_tlm_analysis_fifo #(axi4_slave_tx) peripheralUnitAxi4SlavePathReadDataAnalysisExport[];

    extern function new(string name="topAxiSubScoreboard",uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern task handleAxi4MasterWrite(int master_id);
    extern task handleAxi4SlaveRead(int slave_id);
    extern task handleAxi4MasterWriteResp(int master_id);
    extern function int checkArbit(int slaveId,int writeOrRead,bit respCall=0);

  endclass

  function topAxiSubScoreboard :: new(string name="topAxiSubScoreboard",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void topAxiSubScoreboard :: build_phase(uvm_phase phase); 
    super.build_phase(phase);
    peripheralUnitAxi4MasterPathWriteAddressAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES+1];
    peripheralUnitAxi4MasterPathWriteDataAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES+1];
    peripheralUnitAxi4MasterPathWriteResponseAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES+1];
    peripheralUnitAxi4MasterPathReadAddressAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES+1];
    peripheralUnitAxi4MasterPathReadDataAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES+1];

    peripheralUnitAxi4SlavePathWriteAddressAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES+1];
    peripheralUnitAxi4SlavePathWriteDataAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES+1];
    peripheralUnitAxi4SlavePathWriteResponseAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES+1];
    peripheralUnitAxi4SlavePathReadAddressAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES+1];
    peripheralUnitAxi4SlavePathReadDataAnalysisExport = new[axi4_globals_pkg::NO_OF_SLAVES+1];


    foreach (peripheralUnitAxi4MasterPathWriteAddressAnalysisExport[i]) begin
      peripheralUnitAxi4MasterPathWriteAddressAnalysisExport[i] = 
        new($sformatf("peripheralUnitAxi4MasterPathWriteAddressAnalysisExport[%0d]", i), this);
      peripheralUnitAxi4MasterPathWriteDataAnalysisExport[i] = 
        new($sformatf("peripheralUnitAxi4MasterPathWriteDataAnalysisExport[%0d]", i), this);
      peripheralUnitAxi4MasterPathWriteResponseAnalysisExport[i] = 
        new($sformatf("peripheralUnitAxi4MasterPathWriteResponseAnalysisExport[%0d]", i), this);
      peripheralUnitAxi4MasterPathReadAddressAnalysisExport[i] = 
        new($sformatf("peripheralUnitAxi4MasterPathReadAddressAnalysisExport[%0d]", i), this);
      peripheralUnitAxi4MasterPathReadDataAnalysisExport[i] = 
        new($sformatf("peripheralUnitAxi4MasterPathReadDataAnalysisExport[%0d]", i), this);

      peripheralUnitAxi4SlavePathWriteAddressAnalysisExport[i] = 
        new($sformatf("peripheralUnitAxi4SlavePathWriteAddressAnalysisExport[%0d]", i), this);
      peripheralUnitAxi4SlavePathWriteDataAnalysisExport[i] = 
        new($sformatf("peripheralUnitAxi4SlavePathWriteDataAnalysisExport[%0d]", i), this);
      peripheralUnitAxi4SlavePathWriteResponseAnalysisExport[i] = 
        new($sformatf("peripheralUnitAxi4SlavePathWriteResponseAnalysisExport[%0d]", i), this);
      peripheralUnitAxi4SlavePathReadAddressAnalysisExport[i] = 
        new($sformatf("peripheralUnitAxi4SlavePathReadAddressAnalysisExport[%0d]", i), this);
      peripheralUnitAxi4SlavePathReadDataAnalysisExport[i] = 
        new($sformatf("peripheralUnitAxi4SlavePathReadDataAnalysisExport[%0d]", i), this);
    end 
  endfunction 

  //Task name:handleAxi4MasterWrite
  //Description :Handle AXI4 Master Write transactions
  task topAxiSubScoreboard::handleAxi4MasterWrite(int master_id);
    int transaction;
    automatic int numOfRows[dmaGlobalPkg::NUM_CHANNELS] ='{dmaGlobalPkg::NUM_CHANNELS{1}};
    automatic int numberOfTransfer[dmaGlobalPkg::NUM_CHANNELS];
    bit[axi4_globals_pkg :: DATA_WIDTH-1:0] writeData;
    forever begin
      axi4_master_tx wdata_tx;
      axi4_master_tx addressTx;
      bit[axi4_globals_pkg :: DATA_WIDTH-1:0]expectedData;
      int index;
      int arbitChannel;
      int expectedAddr;
      trigReqEnum  triggerType;
      bit[axi4_globals_pkg ::DATA_WIDTH-1:0] expected;
      bit[axi4_globals_pkg ::DATA_WIDTH-1:0]expectedCompr;
      peripheralUnitAxi4MasterPathWriteAddressAnalysisExport[master_id].get(addressTx);
      arbitChannel =  checkArbit(master_id,0);
      if(arbitChannel != addressTx.awid)begin 
        `uvm_error("TOP_SCOREBOARD",$sformatf("LOCAL WRITE CHANNEL GRANT GIVEN TO %d GOT ID IS %d pending write count is %d",arbitChannel,addressTx.awid,sharedResource::numberOfWriteReq[arbitChannel]))
      end 
      peripheralUnitAxi4MasterPathWriteDataAnalysisExport[master_id].get(wdata_tx);
      sharedResource::dmaChannelRegHandle[arbitChannel].CH_XSIZE.DESXSIZE=sharedResource::numberOfWriteReq[arbitChannel];
      sharedResource::managerWriteAccess=1;
      if(sharedResource::numberOfWriteReq[arbitChannel] ==0) begin
        `uvm_error("TOP_SCOREBOARD","EXPECTED ZERO WRITE FOR THE CHANNEL BUT GOT A READ PACKET")
      end
      if(sharedResource::pauseChannel[arbitChannel] == 1) begin
        `uvm_error("TOP_SCOREBOARD","PAUSE COMMAND GIVEN BUT RECEIVED A AXI WRITE TRANSFER")
      end
      if(sharedResource::stopChannel[arbitChannel] == 1) begin
        `uvm_error("TOP_SCOREBOARD","STOP COMMAND GIVEN BUT RECEIVED A AXI TRANSFER")
        sharedResource::numberOfWriteReq[arbitChannel]--;
        if(sharedResource::dmaChannelRegHandle[arbitChannel].CH_INTREN.INTREN_STOPPED ==1) begin
          sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.INTR_STOPPED =1;
          sharedResource::raiseInterrupt(arbitChannel,"STOP INTERRUPT RAISED");
        end

        if(sharedResource::numberOfWriteReq[arbitChannel] ==0) begin
          sharedResource::stopChannel[arbitChannel]=0;
          continue;
        end
      end       

      triggerType= sharedResource::trigDesInfoChannel[arbitChannel];

      writeData= wdata_tx.wdata[0]; 

      if((triggerType == SINGLE && addressTx.awlen != 0 && (sharedResource::flowControl[sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESTRIGINCFG.DESTRIGINSEL]))) begin
        `uvm_error("TOP_SCOREBOARD","THE TRIGGER TYPE IS SINGLE BUT BURST LEN IS MORE THAN 0")
      end

      if((addressTx.awlen > sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESTRANSCFG.DESMAXBURSTLEN)||(addressTx.awlen>=sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESTRIGINCFG.DESTRIGINBLKSIZE)) begin
        `uvm_error("TOP_SCOREBOARD",$sformatf("AWLEN ERROR FOR BLOCK BASED TRANSFER WHEN AWLEN IS %0d AND MAX LEN FOR BURST IS %0D AND BLK SIZE FOR SRC IS %0D",addressTx.awlen,sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESTRANSCFG.DESMAXBURSTLEN,sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESTRIGINCFG.DESTRIGINBLKSIZE))
      end 
      expectedAddr = sharedResource::expectedWriteAddr[arbitChannel].pop_front();
      if(addressTx.awaddr == expectedAddr) begin
        `uvm_info("TOP_SCOREBOARD","THE EXPECTED WRITE ADDR MATCHES WITH THE ACTUAL ADDRESS FOR WRITE PATH",UVM_HIGH)
      end

      for(int iter=0;iter <addressTx.awlen;iter++) begin
        if(!sharedResource::pauseChannel[arbitChannel] && !sharedResource::stopChannel[arbitChannel]) begin 
          //expectedAddr = sharedResource::expectedWriteAddr[arbitChannel].pop_front();
          sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESADDR = expectedAddr;
          $display("HEY BYE SRC %d DES %d transfer %d",sharedResource::initialSrcXsize[arbitChannel],sharedResource::initialDesXsize[arbitChannel],numberOfTransfer[arbitChannel]);
          if((sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.XTYPE == X_CONTINUE) &&(sharedResource::initialSrcXsize[arbitChannel] > sharedResource::initialDesXsize[arbitChannel])&&(numberOfTransfer[arbitChannel] == sharedResource::initialSrcXsize[arbitChannel]))begin 
            numOfRows[arbitChannel]++;
            $display("HELLO CHECK NUMBER OF ROWS %d",numOfRows[arbitChannel]);
            $display("HELLO CHECK NUMBER OF TRANSFER %d",numberOfTransfer[arbitChannel]);
            numberOfTransfer[arbitChannel]=0;
            $display("HEY BYE");
          end 
          else if((numberOfTransfer[arbitChannel] ==  sharedResource::initialSrcXsize[arbitChannel] )&&((sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.XTYPE == X_CONTINUE) &&(sharedResource::initialSrcXsize[arbitChannel] <= sharedResource::initialDesXsize[arbitChannel]))) begin 
            numOfRows[arbitChannel]++;
            $display("HELLO CHECK NUMBER OF ROWS %d",numOfRows[arbitChannel]);
            $display("HELLO CHECK NUMBER OF TRANSFER %d",numberOfTransfer[arbitChannel]);
            numberOfTransfer[arbitChannel]=0;
          end
          else if (sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.XTYPE != X_CONTINUE &&(numberOfTransfer[arbitChannel] == sharedResource::initialDesXsize[arbitChannel]))begin
            numOfRows[arbitChannel]++;
            numberOfTransfer[arbitChannel]=0;
          end 
          for(int i=0,j=0;i<(2**(addressTx.awsize));i++) begin
            if(!(expectedAddr inside {[sharedResource::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[master_id].min_address : sharedResource::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[master_id].max_address]})) begin 
              `uvm_error("TOP_SCOREBOARD",$sformatf("THE ADDRESS OF THE AXI MEMORY WRITE DOESNT FALL UNDER CORRECT SLAVE WHEN OBTAINED ADDRESS IS %0d and range is %0d and %0d",expectedAddr,sharedResource::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[master_id].min_address,sharedResource::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[master_id].max_address))
              sharedResource::respRef[master_id].bresp = WRITE_SLVERR;
            end 
            j = expectedAddr %((axi4_globals_pkg::DATA_WIDTH)/8);
            sharedResource::peripheralMem.mem_write(expectedAddr++,writeData[8*j +:8]);
            expectedCompr[8*j+:8]=writeData[8*j +:8];
          end 
          sharedResource::numberOfWriteReq[arbitChannel]--;
          numberOfTransfer[arbitChannel]++;        
          if(((numberOfTransfer[arbitChannel] > sharedResource::initialSrcXsize[arbitChannel]) && sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.XTYPE == X_FILL) || ((numOfRows[arbitChannel] > sharedResource::dmaChannelRegHandle[arbitChannel].CH_YSIZE.SRCYSIZE) && sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.YTYPE == Y_FILL))begin
            expectedAddr = expectedAddr - (2**(addressTx.awsize));
            for(int i=0,j=0;i<(2**(addressTx.awsize));i++) begin
              j =expectedAddr %((axi4_globals_pkg::DATA_WIDTH)/8);
              if(writeData[8*j +:8] != sharedResource::dmaChannelRegHandle[arbitChannel].CH_FILLVAL[8*i +:8]) begin 
                `uvm_error("TOP SCOREBOARD",$sformatf("FILL VAL CHECK FOR BYTE %d FAILED WHEN ACTUAL DATA IS %H AND FILL VAL IS %h",i,writeData,sharedResource::dmaChannelRegHandle[arbitChannel].CH_FILLVAL))
              end
              else begin 
                `uvm_info("TOP_SCOREBOARD","FILL VAL BYTE MATCHES",UVM_HIGH)
              end 
              expectedAddr++;
            end 
            sharedResource:: dmaChannelRegHandle[arbitChannel].CH_XSIZE.DESXSIZE= sharedResource::expectedDesXsize[arbitChannel].pop_front();
            expectedAddr = sharedResource::expectedWriteAddr[arbitChannel].pop_front();
            sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESADDR = expectedAddr;
            peripheralUnitAxi4MasterPathWriteDataAnalysisExport[master_id].get(wdata_tx);
            if(sharedResource::pauseChannel[arbitChannel] == 1) begin
              `uvm_error("TOP_SCOREBOARD","PAUSE COMMAND GIVEN BUT RECEIVED A AXI WRITE TRANSFER")
              continue;
            end
            if(sharedResource::stopChannel[arbitChannel] == 1) begin
              `uvm_error("TOP_SCOREBOARD","PAUSE COMMAND GIVEN BUT RECEIVED A AXI TRANSFER")
              if(sharedResource::dmaChannelRegHandle[arbitChannel].CH_INTREN.INTREN_STOPPED ==1) begin
                sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.INTR_STOPPED =1;
                sharedResource::raiseInterrupt(arbitChannel,"STOP INTERRUPT RAISED");
              end

              if(sharedResource::numberOfWriteReq[arbitChannel] ==0) begin
                sharedResource::stopChannel[arbitChannel]=0;
              end

              continue;
            end

            writeData= wdata_tx.wdata[0];
            continue; 
          end 
          sharedResource::dmaChannelRegHandle[arbitChannel].CH_XSIZE.DESXSIZE= sharedResource::expectedDesXsize[arbitChannel].pop_front();
          expected = sharedResource::channelQueue[arbitChannel].pop_front();
          if(expected!=writeData) begin
            `uvm_error("TOP SCOREBOARD",$sformatf("WRITE DATA DOESNT MATCH WITH EXPECTED FIFO DATA when expectedData=%0h and ACTUAL IS %0h",expected,writeData))
          end
          else begin 
            `uvm_info("TOP_SCOREBOARD",$sformatf("WRITE DATA MATCHES DATA IS %h",expected),UVM_HIGH)
          end 
        end 
        expectedAddr = sharedResource::expectedWriteAddr[arbitChannel].pop_front();
        sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESADDR = expectedAddr;
        peripheralUnitAxi4MasterPathWriteDataAnalysisExport[master_id].get(wdata_tx);
        if(sharedResource::pauseChannel[arbitChannel] == 1) begin
          `uvm_error("TOP_SCOREBOARD","PAUSE COMMAND GIVEN BUT RECEIVED A AXI WRITE TRANSFER")
          continue;
        end

        if(sharedResource::stopChannel[arbitChannel] == 1) begin
          `uvm_error("TOP_SCOREBOARD","STOP COMMAND GIVEN BUT RECEIVED A AXI TRANSFER")
          sharedResource::numberOfWriteReq[arbitChannel]--;
          if(sharedResource::dmaChannelRegHandle[arbitChannel].CH_INTREN.INTREN_STOPPED ==1) begin
            sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.INTR_STOPPED =1;
            sharedResource::raiseInterrupt(arbitChannel,"STOP INTERRUPT RAISED");
          end
          if(sharedResource::numberOfWriteReq[arbitChannel] ==0) begin
            sharedResource::stopChannel[arbitChannel]=0;
          end
          continue;
        end

        writeData= wdata_tx.wdata[0];
      end 

      if(sharedResource::numberOfWriteReq[arbitChannel]<=0) begin 
        `uvm_error("TOP_SCOREBOARD",$sformatf("BURST LEN IS GENERATED IN EXCESS FOR CHANNEL %d IN AXI INTERFACE %d",arbitChannel,master_id))
        //  continue;
      end 

      if(!sharedResource::pauseChannel[arbitChannel] && !sharedResource::stopChannel[arbitChannel]) begin
        sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESADDR = expectedAddr;
        if(!sharedResource::pauseChannel[arbitChannel] && !sharedResource::stopChannel[arbitChannel]) begin
          for(int i=0,j=0;i<(2**(addressTx.awsize));i++) begin
            j = expectedAddr %((axi4_globals_pkg::DATA_WIDTH)/8);
            sharedResource::peripheralMem.mem_write(expectedAddr++,writeData[8*j +:8]);
          end
        end  
        sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESADDR = expectedAddr;
        $display("HEY BYE SRC %d DES %d transfer %d",sharedResource::initialSrcXsize[arbitChannel],sharedResource::initialDesXsize[arbitChannel],numberOfTransfer[arbitChannel]);

        if((sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.XTYPE == X_CONTINUE) &&(sharedResource::initialSrcXsize[arbitChannel] > sharedResource::initialDesXsize[arbitChannel])&&(numberOfTransfer[arbitChannel] == sharedResource::initialSrcXsize[arbitChannel]))begin 
          numOfRows[arbitChannel]++;
          numberOfTransfer[arbitChannel]=0;
          $display("HEY BYE");
        end 
        else if((numberOfTransfer[arbitChannel] ==  sharedResource::initialSrcXsize[arbitChannel] )&&((sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.XTYPE == X_CONTINUE) &&(sharedResource::initialSrcXsize[arbitChannel] <= sharedResource::initialDesXsize[arbitChannel]))) begin 
          numOfRows[arbitChannel]++;
          $display("HELLO CHECK NUMBER OF TRANSFER %d",numberOfTransfer[arbitChannel]);
           
          $display("HELLO CHECK THIS %d",numOfRows[arbitChannel]);
          numberOfTransfer[arbitChannel]=0;

        end
        else if (sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.XTYPE != X_CONTINUE &&(numberOfTransfer[arbitChannel] == sharedResource::initialDesXsize[arbitChannel]))begin
          numOfRows[arbitChannel]++;
          numberOfTransfer[arbitChannel]=0;
        end   
        sharedResource::numberOfWriteReq[arbitChannel]--;
        numberOfTransfer[arbitChannel]++;

        sharedResource::dmaChannelRegHandle[arbitChannel].CH_XSIZE.DESXSIZE= sharedResource::expectedDesXsize[arbitChannel].pop_front();
        if(sharedResource::respRef[master_id].bresp != WRITE_OKAY) begin
          sharedResource::dmaChannelRegHandle[arbitChannel].CH_ERRINFO.ERRINFO.AXIWRRESPERR=1;
          sharedResource::dmaChannelRegHandle[arbitChannel].CH_ERRINFO.BUSERR = 1;
          if(sharedResource::dmaChannelRegHandle[arbitChannel].CH_INTREN.INTREN_ERR ==1) begin
            sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.INTR_ERR =1;
            sharedResource::raiseError(arbitChannel,"WRITE RESP RECEIVED IS NOT WRITE OKAY");
          end
        end

        if(((numberOfTransfer[arbitChannel] > sharedResource::initialSrcXsize[arbitChannel]) && sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.XTYPE == X_FILL) || (numOfRows[arbitChannel] > sharedResource::dmaChannelRegHandle[arbitChannel].CH_YSIZE.SRCYSIZE && sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.YTYPE == Y_FILL))begin
          expectedAddr = expectedAddr - (2**(addressTx.awsize));
          for(int i=0,j=0;i<(2**(addressTx.awsize));i++) begin
            j =expectedAddr %((axi4_globals_pkg::DATA_WIDTH)/8);
            if(writeData[8*j +:8] != sharedResource::dmaChannelRegHandle[arbitChannel].CH_FILLVAL    [8*i +:8]) begin
              `uvm_error("TOP SCOREBOARD",$sformatf("FILL VAL CHECK FOR BYTE %d FAILED WHEN ACTUA    L DATA IS %H AND FILL VAL IS %h",i,writeData,sharedResource::dmaChannelRegHandle[arbitChannel].CH_FILLVAL))
            end
            else begin 
              `uvm_info("TOP_SCOREBOARD","FILL VAL BYTE MATCHES",UVM_HIGH)
            end 
            expectedAddr++;
          end
        end
        else begin
          expected = sharedResource::channelQueue[arbitChannel].pop_front();
          if(expected !=writeData)begin 
            `uvm_error("TOP SCOREBOARD",$sformatf("WRITE DATA DOESNT MATCH WITH EXPECTED FIFO DATA when expectedData=%0h and ACTUAL IS %0h",expected,writeData))
          end
          else begin 
            `uvm_info("TOP_SCOREBOARD",$sformatf("WRITE DATA MATCHES DATA IS %h",expected),UVM_HIGH)
          end 
        end      
      end 
      $display("RESP ASSERT IS DONE");
      sharedResource::waitForResp[arbitChannel]=1; 
      if(sharedResource::numberOfWriteReq[arbitChannel] <= 0) begin
        //need to escape the arbitration here right
        `uvm_error("TOP_SCOREBOARD","write for channel done asserted")
        sharedResource::priorityDesPerChannel[master_id][arbitChannel].commandStart=0;
        sharedResource::priorityDesPerChannel[master_id][arbitChannel].commandDone=1;
      end
    end
  endtask

  //Task name: handleAxi4SlaveRead
  //Description :Handle AXI4 Slave Read transaction
  task topAxiSubScoreboard::handleAxi4SlaveRead(int slave_id);

    bit headerRead;
    bit[31:0]header;
    int addr;
    int arbitChannel; 
    int count;
    int subtract;
    bit[axi4_globals_pkg::DATA_WIDTH-1:0] expectedData;
    bit[axi4_globals_pkg::DATA_WIDTH-1:0] readData;
    forever begin
      axi4_slave_tx rdata_tx;
      axi4_slave_tx raddr_tx;
      trigReqEnum  triggerType; 
      int expectedAddr;
      sharedResource::managerReadAccess=0;
      peripheralUnitAxi4SlavePathReadAddressAnalysisExport[slave_id].get(raddr_tx);
     // if(!raddr_tx.araddr inside {sharedResource::topEnvConfigHandle.addressIfLinking[sharedResource::channelRequestingLink]}) begin 
        arbitChannel = checkArbit(slave_id,1); // here we get what channel becomes the owner base    d on the qos value
      //end 

  //    if((arbitChannel != raddr_tx.arid) && !(raddr_tx.araddr inside {sharedResource::topEnvConfigHandle.addressIfLinking[sharedResource::channelRequestingLink]}))begin 
        `uvm_error("TOP_SCOREBOARD",$sformatf("ARBIT:EXPECTED CHANNEL IS %d GOT CHANNEL IS %d ",arbitChannel,raddr_tx.arid))
      //  end 
      peripheralUnitAxi4SlavePathReadDataAnalysisExport[slave_id].get(rdata_tx);
      if(slave_id == axi4_globals_pkg::NO_OF_SLAVES) begin
        int selectedInterface;
        $display("HI BYE HELLO");
        sharedResource::dmaChannelRegHandle[arbitChannel].CH_ERRINFO.BUSERR = 1;
        sharedResource ::dmaChannelRegHandle[arbitChannel].CH_ERRINFO.ERRINFO.AXIRDRESPERR =1;
        sharedResource ::dmaChannelRegHandle[arbitChannel].CH_STATUS.STAT_ERR =1; //come out of arbitration
        if(sharedResource ::dmaChannelRegHandle[arbitChannel].CH_INTREN.INTREN_ERR ==1) begin
          sharedResource ::raiseError(arbitChannel, "BUS ERROR");
        end
        sharedResource::commandStatusPerChannel[arbitChannel].readDone=1;
        for(int i=0;i<(axi4_globals_pkg :: NO_OF_SLAVES);i++) begin
          if(sharedResource::initialSrcAddress[arbitChannel]>= sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].min_address && sharedResource::initialSrcAddress[arbitChannel]<sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].max_address) begin
            selectedInterface=i;
            break;
          end
        end

        sharedResource::priorityDesPerChannel[selectedInterface][arbitChannel].commandDone =1; //exiting the arbitChannel
        sharedResource::priorityDesPerChannel[selectedInterface][arbitChannel].commandStart =0; //exiting the arbitChannel
        sharedResource::prioritySrcPerChannel[selectedInterface][arbitChannel].commandDone =1; //exiting the arbitChannel
        continue;
      end  
      if((raddr_tx.araddr inside {sharedResource::topEnvConfigHandle.addressIfLinking[sharedResource::channelRequestingLink]}) && headerRead ==0) begin
        header = rdata_tx.rdata[0];
        headerRead =1;

        `uvm_info("TOP_SCOREBOARD",$sformatf("STARTED COMMAND LINKING FOR CHANNEL %0d",arbitChannel),UVM_HIGH) 
        sharedResource::commandDone[sharedResource ::dmaChannelRegHandle[arbitChannel].CH_SRCTRIGINCFG.SRCTRIGINSEL] = 0;
        sharedResource::commandDone[sharedResource ::dmaChannelRegHandle[arbitChannel].CH_DESTRIGINCFG.DESTRIGINSEL] =0;
        sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.STAT_DONE=0;
        sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.INTR_DONE =0;

        if(sharedResource::numberOfReadReq[arbitChannel] != 0) begin
          `uvm_error("TOP SCOREBOARD","NUMBER OF EXPECTED READS HAS NOT TAKEN PLACE")
        end
        else begin
          `uvm_info("TOP SCOREBOARD","NUMBER OF EXPECTED READS HAS TAKEN PLACE ",UVM_DEBUG)
        end
        if(sharedResource::numberOfWriteReq[arbitChannel] != 0) begin
          `uvm_error("TOP SCOREBOARD","NUMBER OF EXPECTED WRITES HAS NOT TAKEN PLACE ")
        end
        else begin
          `uvm_info("TOP SCOREBOARD","NUMBER OF EXPECTED WRITES HAS TAKEN PLACE ",UVM_DEBUG)
        end

        addr = raddr_tx.araddr;
        if($countones(header ==0))begin
          sharedResource::dmaChannelRegHandle[arbitChannel].CH_ERRINFO.ERRINFO.LINKHDERR=1;
          sharedResource::dmaChannelRegHandle[arbitChannel].CH_ERRINFO.CFGERR =1;
          sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.STAT_ERR =1;
          if(sharedResource::dmaChannelRegHandle[arbitChannel].CH_INTREN.INTREN_ERR ==1) begin
            sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.INTR_ERR =1;
            sharedResource::raiseError(arbitChannel,"header bit count is 0");
          end
        end
        if(sharedResource::dmaChannelRegHandle[sharedResource::channelRequestingLink].CH_LINKADDR.LINKADDREN != 1|| sharedResource::dmaChannelRegHandle[sharedResource::channelRequestingLink].CH_LINKADDR.LINKADDR ==0) begin 
          `uvm_error("TOP_SCOREBOARD",$sformatf("READING THE LINKED COMMAND INSPITE OF NOT MEETING NECCESSARY CONDITION EN IS %0d AND ADDR IS %0d",sharedResource::dmaChannelRegHandle[sharedResource::channelRequestingLink].CH_LINKADDR.LINKADDREN,sharedResource::dmaChannelRegHandle[sharedResource::channelRequestingLink].CH_LINKADDR.LINKADDR))
        end
        sharedResource ::triggerSrcTaskCall[arbitChannel]=0;
        sharedResource ::triggerDesTaskCall[arbitChannel]=0;
        sharedResource ::triggerOutTaskCall[arbitChannel]=0;
        if(sharedResource::disableChannel[arbitChannel] == 1) begin 
          sharedResource::disableChannel[arbitChannel]=0;
          `uvm_error("TOP_SCOREBOARD","DISABLE COMMAND IS PRESENT BUT DISCRIPTOR FETCH IS BEING DONE")
          if(sharedResource::dmaChannelRegHandle[arbitChannel].CH_INTREN.INTREN_DISABLED ==1) begin
            sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.INTR_DISABLED =1;
            sharedResource::raiseInterrupt(arbitChannel,"DISABLE INTERRUPT RAISED");
          end
        end

        continue;
      end  

      if(headerRead ==1) begin 
        int incrementer;
        bit[31:0] dynArr[];
        int str;
        sharedResource::disableChannel[arbitChannel]=0;
        if(raddr_tx.arlen+1 != $countones(header)) begin 
          `uvm_error("TOP_SCOREBOARD","THE BURST LEN FOR COMMAND LINKING DOESNT MATCH WITH EXPECTED LENGHT")
        end
        dynArr = new[32];
        if(raddr_tx.araddr != (addr+(2**raddr_tx.arsize)))
          `uvm_error("TOP_SCOREBOARD","ADDR IN LINK IS NOT AS EXPECTED")
        addr = addr +4;
        for(int i=0;i<32;i++)begin
          if(header[i]==1 || (count == raddr_tx.arlen+1))begin 
            if(i==0 || i==1 || i==23 || i==25 || i==27) begin 
              continue;
            end 
            count++;
            //dynArr[i]=rdata_tx.rdata[0];
            if(count ==1) begin 
              subtract = (2**(raddr_tx.arsize)) - (addr %(axi4_globals_pkg ::DATA_WIDTH /8));
            end 
            else begin 
              subtract = (2**(raddr_tx.arsize));
            end
            $display("THE SUB IS %0d",subtract);
            for(int j=0,k=0;j<subtract;j++,k++) begin     
              str= (addr %(axi4_globals_pkg ::DATA_WIDTH /8));

              sharedResource::peripheralMem.mem_read(addr++,dynArr[i][8*k +:8]); // config width is 32b
              if(rdata_tx.rdata[0][8*str +:8] != dynArr[i][8*k+:8])begin
                `uvm_error("TOP_SCOREBOARD",$sformatf("THE %0d LINK COMMAND OBTAINED DOESNT MATCH EXPECTED IS %h and ACTUAL OBTAINED IS %h",i,dynArr[i],rdata_tx.rdata[0]))
              end

              if((addr %4) ==0 && (addr %(axi4_globals_pkg ::DATA_WIDTH /8))!=0) begin 
                i++;
                k=-1;              
                while((i==0 || i==1 || i==23 || i==25 || i==27) && (header[i]==1)) begin
                  i++;
                end 

              end 
            end           
            if(count <= raddr_tx.arlen) begin
              peripheralUnitAxi4SlavePathReadDataAnalysisExport[slave_id].get(rdata_tx); 
            end 
          end 
        end
        for(int i=0;i<32;i++) begin
          if(header[i]==1 && !(i==0 || i==1 || i==23 || i==25 || i==27)) begin
            sharedResource::dmaChannelRegHandle[sharedResource ::channelRequestingLink][32*i +:32] = dynArr[i];
          end 
        end
        $display("NEW CONFIG IS %p",sharedResource::dmaChannelRegHandle);
        $display("TRIGG ACC IS %p",sharedResource::triggerAccessed);
        sharedResource::expectedReadAddr[sharedResource ::channelRequestingLink].delete();
        sharedResource::expectedWriteAddr[sharedResource ::channelRequestingLink].delete(); 
        sharedResource::numberOfReadReq[sharedResource::channelRequestingLink] = sharedResource::determineNumberOfReads(sharedResource::channelRequestingLink);
        sharedResource::numberOfWriteReq[sharedResource::channelRequestingLink] = sharedResource::determineNumberOfWrites(sharedResource::channelRequestingLink);
        sharedResource::setUp1DAddress(sharedResource::channelRequestingLink);
        sharedResource :: setUpTrigger(sharedResource::channelRequestingLink); 

        headerRead =0;
        header =0;
      end 
      else begin 
      //  arbitChannel = checkArbit(slave_id,1); // here we get what channel becomes the owner based on the qos value
        sharedResource::managerReadAccess=1;
        if(sharedResource::numberOfReadReq[arbitChannel] ==0) begin
          `uvm_error("TOP_SCOREBOARD","EXPECTED ZERO READ FOR THE CHANNEL BUT GOT A READ PACKET")
        end

        if(sharedResource::numberOfReadReq[arbitChannel]==0) begin
          `uvm_error("TOP_SCOREBOARD","NUMBER OF EXPECTED READ IS 0 BUT GOT NEW READ FROM AXI BUS")
        end

        triggerType= sharedResource::trigSrcInfoChannel[arbitChannel];
        if(triggerType == SINGLE && raddr_tx.arlen != 0 && (sharedResource::flowControl[sharedResource::dmaChannelRegHandle[arbitChannel].CH_SRCTRIGINCFG.SRCTRIGINSEL])) begin 
          `uvm_error("TOP_SCOREBOARD","THE TRIGGER TYPE IS SINGLE BUT BURST LEN IS MORE THAN 0")     
        end 
        if((triggerType == SINGLE )) begin
          if(sharedResource::pauseChannel[arbitChannel] == 1) begin
            `uvm_error("TOP_SCOREBOARD","PAUSE COMMAND GIVEN BUT RECEIVED A AXI READ TRANSFER")
            continue;
          end
          if(sharedResource::stopChannel[arbitChannel] == 1) begin
            `uvm_error("TOP_SCOREBOARD","STOP COMMAND GIVEN BUT RECEIVED A AXI TRANSFER")
            sharedResource::numberOfReadReq[arbitChannel]--;
            if(sharedResource::numberOfReadReq[arbitChannel] ==0) begin
              sharedResource::stopChannel[arbitChannel]=0;
            end
            if(sharedResource::dmaChannelRegHandle[arbitChannel].CH_INTREN.INTREN_STOPPED ==1) begin
              sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.INTR_STOPPED =1;
              sharedResource::raiseInterrupt(arbitChannel,"STOP INTERRUPT RAISED");
            end

            continue;
          end

          expectedAddr = sharedResource::expectedReadAddr[arbitChannel].pop_front();
          sharedResource::dmaChannelRegHandle[arbitChannel].CH_SRCADDR = expectedAddr;
          if(raddr_tx.araddr == expectedAddr) begin
            `uvm_info("TOP_SCOREBOARD","THE EXPECTED READ ADDR MATCHES WITH THE ACTUAL ADDRESS FOR READ PATH",UVM_HIGH)
          end
          else begin 
            `uvm_error("TOP_SCOREBOARD",$sformatf("READ CHANNEL ADDRESS DOESNT MATCH GOT ONE IS %d EXPECTED IS %d",raddr_tx.araddr,expectedAddr))
          end 
          sharedResource::numberOfReadReq[arbitChannel] = sharedResource::numberOfReadReq[arbitChannel]-1;
          for(int i=0,j=0;i<(2**(raddr_tx.arsize));i++) begin
            j = expectedAddr %((axi4_globals_pkg::DATA_WIDTH)/8);
            sharedResource::peripheralMem.mem_read(expectedAddr++,readData[8*j +:8]);
            if(readData[8*j +:8] != rdata_tx.rdata[0][8*j +:8]) begin 
              `uvm_error("TOP_SCOREBOARD",$sformatf("ERROR IN THE RDATA AT START ADDR %0d",raddr_tx.araddr))
            end
            else begin
              expectedData[8*j +:8] = rdata_tx.rdata[0][8*j +:8]; 
              `uvm_info("TOP_SCOREBOARd",$sformatf("PUSHING THE DATA INTO CHANNEL FIFO THE DATA IS %0h AND CHANNEL IS %0d",expectedData,arbitChannel),UVM_HIGH)
            end  
          end 
          sharedResource::dmaChannelRegHandle[arbitChannel].CH_XSIZE.SRCXSIZE= sharedResource::expectedSrcXsize[arbitChannel].pop_front();
          if(rdata_tx.rresp != READ_OKAY) begin
            sharedResource::dmaChannelRegHandle[arbitChannel].CH_ERRINFO.ERRINFO.AXIRDRESPERR=1;
            sharedResource::dmaChannelRegHandle[arbitChannel].CH_ERRINFO.BUSERR = 1;
            sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.STAT_ERR =1;
            if(sharedResource::dmaChannelRegHandle[arbitChannel].CH_INTREN.INTREN_ERR ==1) begin
              sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.INTR_ERR =1;
              sharedResource::raiseError(arbitChannel,"READ RESP RECEIVED IS NOT READOKAY");
            end
          end
          sharedResource::channelQueue[arbitChannel].push_back(expectedData); 
          if(sharedResource::numberOfReadReq[arbitChannel]==0) begin 
            sharedResource::prioritySrcPerChannel[slave_id][arbitChannel].commandStart=0;
            sharedResource::prioritySrcPerChannel[slave_id][arbitChannel].commandDone=1;
          end       
        end
        if(triggerType == BLOCK) begin 
          if(sharedResource::pauseChannel[arbitChannel] == 1) begin
            `uvm_error("TOP_SCOREBOARD","PAUSE COMMAND GIVEN BUT RECEIVED A AXI READ TRANSFER")
          end
          if(sharedResource::stopChannel[arbitChannel] == 1) begin
            `uvm_error("TOP_SCOREBOARD","STOP COMMAND GIVEN BUT RECEIVED A AXI TRANSFER")
            sharedResource::numberOfReadReq[arbitChannel]--;
            if(sharedResource::numberOfReadReq[arbitChannel] ==0) begin
              sharedResource::stopChannel[arbitChannel]=0;
            end
            if(sharedResource::dmaChannelRegHandle[arbitChannel].CH_INTREN.INTREN_STOPPED ==1) begin
              sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.INTR_STOPPED =1;
              sharedResource::raiseInterrupt(arbitChannel,"STOP INTERRUPT RAISED");
            end
          end

          if((raddr_tx.arlen >= sharedResource::dmaChannelRegHandle[arbitChannel].CH_SRCTRANSCFG.SRCMAXBURSTLEN)||(raddr_tx.arlen>=sharedResource::dmaChannelRegHandle[arbitChannel].CH_SRCTRIGINCFG.SRCTRIGINBLKSIZE)) begin 
            `uvm_error("TOP_SCOREBOARD",$sformatf("ARLEN ERROR FOR BLOCK BASED TRANSFER WHEN ARLEN IS %0d AND MAX LEN FOR BURST IS %0D AND BLK SIZE FOR SRC IS %0D",raddr_tx.arlen,sharedResource::dmaChannelRegHandle[arbitChannel].CH_SRCTRANSCFG.SRCMAXBURSTLEN,sharedResource::dmaChannelRegHandle[arbitChannel].CH_SRCTRIGINCFG.SRCTRIGINBLKSIZE))
          end 
          expectedAddr =sharedResource::expectedReadAddr[arbitChannel].pop_front();
          $display("EXPECTED READ ADDR Q IS %p",sharedResource::expectedReadAddr[arbitChannel]);
          if(raddr_tx.araddr == expectedAddr) begin
            `uvm_info("TOP_SCOREBOARD","THE EXPECTED READ ADDR MATCHES WITH THE ACTUAL ADDRESS FOR READ PATH",UVM_HIGH)
          end
          else begin 
            `uvm_error("TOP_SCOREBOARD",$sformatf("expectedAddr %D q is %p",expectedAddr,sharedResource::expectedReadAddr[arbitChannel]))
          end 

          for(int index =0 ; index < (raddr_tx.arlen);index++) begin //<3  0 1 2
            if(!sharedResource::pauseChannel[arbitChannel] && !sharedResource::stopChannel[arbitChannel])begin 
              // expectedAddr =sharedResource::expectedReadAddr[arbitChannel].pop_front();
              sharedResource::numberOfReadReq[arbitChannel] = sharedResource::numberOfReadReq[arbitChannel]-1;
              //sharedResource::dmaChannelRegHandle[arbitChannel].CH_SRCADDR = expectedAddr;
              for(int i=0,j=0;i<(2**(raddr_tx.arsize));i++) begin
                j = expectedAddr %((axi4_globals_pkg::DATA_WIDTH)/8);

                sharedResource::peripheralMem.mem_read(expectedAddr,readData[8*j +:8]);

                expectedAddr++;
                if(readData[8*j +:8] != rdata_tx.rdata[0][8*j +:8]) begin       
                  `uvm_error("TOP_SCOREBOARD",$sformatf(" ERROR IN THE RDATA AT START ADDR %0d EXPECTED DATA IS %0h and actual is %0h",raddr_tx.araddr,readData[8*j +:8],rdata_tx.rdata[0][8*j +:8]))
                end
                else begin
                  expectedData[8*j +:8] = rdata_tx.rdata[0][8*j +:8];
                  `uvm_info("TOP_SCOREBOARd",$sformatf("PUSHING THE DATA INTO CHANNEL FIFO THE DATA IS %h AND CHANNEL IS %0d slave is %d",expectedData,arbitChannel,slave_id),UVM_NONE)
                end
              end
              sharedResource::channelQueue[arbitChannel].push_back(expectedData);
              sharedResource::dmaChannelRegHandle[arbitChannel].CH_XSIZE.SRCXSIZE= sharedResource::expectedSrcXsize[arbitChannel].pop_front();     
              if(rdata_tx.rresp != READ_OKAY) begin
                sharedResource::dmaChannelRegHandle[arbitChannel].CH_ERRINFO.ERRINFO.AXIRDRESPERR=1;
                sharedResource::dmaChannelRegHandle[arbitChannel].CH_ERRINFO.BUSERR = 1;
                sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.STAT_ERR =1;
                if(sharedResource::dmaChannelRegHandle[arbitChannel].CH_INTREN.INTREN_ERR ==1) begin
                  sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.INTR_ERR =1;
                  sharedResource::raiseError(arbitChannel,"READ RESP RECEIVED IS NOT READ OKAY");
                end
              end
              if(sharedResource::numberOfReadReq[arbitChannel]==0) begin
                sharedResource::prioritySrcPerChannel[slave_id][arbitChannel].commandStart=0;
                sharedResource::prioritySrcPerChannel[slave_id][arbitChannel].commandDone=1;
                sharedResource::commandStatusPerChannel[arbitChannel].readDone=1;
              end
            end 
            expectedAddr =sharedResource::expectedReadAddr[arbitChannel].pop_front();
            $display("EXPECTED READ ADDR Q IS %p",sharedResource::expectedReadAddr[arbitChannel]);
            sharedResource::dmaChannelRegHandle[arbitChannel].CH_SRCADDR = expectedAddr;
            peripheralUnitAxi4SlavePathReadDataAnalysisExport[slave_id].get(rdata_tx);//2 3 4 
            if(sharedResource::numberOfReadReq[arbitChannel] ==0) begin
              `uvm_error("TOP_SCOREBOARD","EXPECTED ZERO READ FOR THE CHANNEL BUT GOT A READ PACKET")
            end 
            if(sharedResource::pauseChannel[arbitChannel] == 1) begin
              `uvm_error("TOP_SCOREBOARD","PAUSE COMMAND GIVEN BUT RECEIVED A AXI READ TRANSFER")
              continue;
            end
            if(sharedResource::stopChannel[arbitChannel] == 1) begin
              `uvm_error("TOP_SCOREBOARD","STOP COMMAND GIVEN BUT RECEIVED A AXI TRANSFER")
              sharedResource::numberOfReadReq[arbitChannel]--;
              if(sharedResource ::numberOfReadReq[arbitChannel] ==0) begin
                sharedResource::stopChannel[arbitChannel]=0;
              end
              if(sharedResource::dmaChannelRegHandle[arbitChannel].CH_INTREN.INTREN_STOPPED ==1) begin
                sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.INTR_STOPPED =1;
                sharedResource::raiseInterrupt(arbitChannel,"STOP INTERRUPT RAISED");
              end

              continue;
            end

          end

          if(!sharedResource::pauseChannel[arbitChannel] && !sharedResource::stopChannel[arbitChannel]) begin 
            sharedResource::numberOfReadReq[arbitChannel] = sharedResource::numberOfReadReq[arbitChannel]-1;
            //expectedAddr =sharedResource::expectedReadAddr[arbitChannel].pop_front();
            sharedResource::dmaChannelRegHandle[arbitChannel].CH_SRCADDR = expectedAddr;
            for(int i=0,j=0;i<(2**(raddr_tx.arsize));i++) begin
              j = expectedAddr %((axi4_globals_pkg::DATA_WIDTH)/8);
              sharedResource::peripheralMem.mem_read(expectedAddr++,readData[8*j +:8]);
              if(readData[8*j +:8] != rdata_tx.rdata[0][8*j +:8]) begin
                `uvm_error("TOP_SCOREBOARD",$sformatf(" ERROR IN THE RDATA AT START ADDR %0d EXPECTED DATA IS %0h and actual is %0h slave is %d",raddr_tx.araddr,readData[8*j +:8],rdata_tx.rdata[0][8*j +:8],slave_id))

              end
              else begin
                expectedData[8*j +:8] = rdata_tx.rdata[0][8*j +:8];
                `uvm_info("TOP_SCOREBOARd",$sformatf("PUSHING THE DATA INTO CHANNEL FIFO THE DATA IS %0h AND CHANNEL IS %0d slave is %d",expectedData,arbitChannel,slave_id),UVM_NONE)
              end
            end
            sharedResource::dmaChannelRegHandle[arbitChannel].CH_SRCADDR = expectedAddr;
            sharedResource::dmaChannelRegHandle[arbitChannel].CH_XSIZE.SRCXSIZE= sharedResource::expectedSrcXsize[arbitChannel].pop_front();
            if(rdata_tx.rresp != READ_OKAY) begin
              sharedResource::dmaChannelRegHandle[arbitChannel].CH_ERRINFO.ERRINFO.AXIRDRESPERR=1;
              sharedResource::dmaChannelRegHandle[arbitChannel].CH_ERRINFO.BUSERR = 1;
              sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.STAT_ERR =1;
              if(sharedResource::dmaChannelRegHandle[arbitChannel].CH_INTREN.INTREN_ERR ==1) begin
                sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.INTR_ERR =1;
                sharedResource::raiseError(arbitChannel,"READ RESP RECEIVED IS NOT READ OKAY");
              end
            end

            sharedResource::channelQueue[arbitChannel].push_back(expectedData);    
            if(sharedResource::numberOfReadReq[arbitChannel]==0) begin
              `uvm_error("TOP_SCOREBOARD","CHANNEL DONE ASSERTED")
              sharedResource:: prioritySrcPerChannel[slave_id][arbitChannel].commandStart=0;
              sharedResource::prioritySrcPerChannel[slave_id][arbitChannel].commandDone=1;
            end
            `uvm_info("TOP_SCOREBOARd",$sformatf("PUSHING THE DATA INTO CHANNEL FIFO THE DATA IS %0h AND CHANNEL IS %0d",expectedData,arbitChannel),UVM_HIGH)
          end 
        end    
      end 
    end
  endtask


  //Task name : handleAxi4MasterWriteResp
  //Description :Used to handle axi write resp
  task topAxiSubScoreboard :: handleAxi4MasterWriteResp(int master_id);
    forever begin 
      axi4_master_tx respTx;   
      axi4_master_tx addressTx;
      bit[axi4_globals_pkg :: DATA_WIDTH-1:0]expectedData;
      int index;
      int arbitChannel;
      int expectedAddr;
      trigReqEnum  triggerType;
      peripheralUnitAxi4MasterPathWriteResponseAnalysisExport[master_id].get(respTx);
      arbitChannel = checkArbit(master_id,0,1);
      if(master_id == axi4_globals_pkg::NO_OF_SLAVES) begin
        int selectedInterface;
        sharedResource::dmaChannelRegHandle[arbitChannel].CH_ERRINFO.BUSERR = 1;
        sharedResource ::dmaChannelRegHandle[arbitChannel].CH_ERRINFO.ERRINFO.AXIRDRESPERR =1;
        sharedResource ::dmaChannelRegHandle[arbitChannel].CH_STATUS.STAT_ERR =1; //come out of arbitration
        if(sharedResource ::dmaChannelRegHandle[arbitChannel].CH_INTREN.INTREN_ERR ==1) begin
          sharedResource ::raiseError(arbitChannel, "BUS ERROR");
        end
        for(int i=0;i<(axi4_globals_pkg :: NO_OF_SLAVES);i++) begin
          if(sharedResource::initialDesAddress[arbitChannel]>= sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].min_address && sharedResource::initialDesAddress[arbitChannel]<sharedResource ::topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].max_address) begin
            selectedInterface=i;
            break;
          end
        end

        sharedResource::priorityDesPerChannel[selectedInterface][arbitChannel].commandDone =1; //exiting the arbitChannel
        continue;
      end 
 
      sharedResource::waitForResp[arbitChannel]=0;
      sharedResource::managerWriteAccess=0;
      //should implement internal trigger logic here  
      if( (sharedResource::dmaChannelRegHandle[arbitChannel].CH_LINKADDR.LINKADDREN != 1 || sharedResource::dmaChannelRegHandle[arbitChannel].CH_LINKADDR.LINKADDR ==0) && sharedResource::numberOfWriteReq[arbitChannel]==0) begin
        sharedResource::dmaChannelRegHandle[arbitChannel].CH_CMD.ENABLECMD=0;
      end
      else if(sharedResource::dmaChannelRegHandle[arbitChannel].CH_LINKADDR.LINKADDREN == 1 && sharedResource::dmaChannelRegHandle[arbitChannel].CH_LINKADDR.LINKADDR >0 && sharedResource::numberOfWriteReq[arbitChannel]==0) begin
        sharedResource::dmaChannelRegHandle[arbitChannel].CH_CMD.ENABLECMD=1;
        sharedResource::commandStatusPerChannel[arbitChannel].readDone=0;
      end

      if(sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.USETRIGOUT==1 && sharedResource::numberOfWriteReq[arbitChannel]==0) begin
        sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.STAT_TRIGOUTACKWAIT=1;
        if(sharedResource::dmaChannelRegHandle[arbitChannel].CH_INTREN.INTREN_TRIGOUTACKWAIT) begin
          sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.INTR_TRIGOUTACKWAIT=1;
        end
      end
      if((sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.USETRIGOUT==0 && sharedResource::numberOfWriteReq[arbitChannel]==0)&&(sharedResource ::dmaChannelRegHandle[arbitChannel].CH_CMD.PAUSECMD==1 || (sharedResource ::dmaChannelRegHandle[arbitChannel].CH_STATUS.STAT_DONE && sharedResource ::dmaChannelRegHandle[arbitChannel].CH_CTRL.DONEPAUSEEN))) begin 
          `uvm_info("TOP_SCOREBOARD",$sformatf("The command in channel[%0d] has been paused",arbitChannel),UVM_HIGH)
          sharedResource ::pauseChannel[arbitChannel] =1;
          sharedResource ::dmaChannelRegHandle[arbitChannel].CH_STATUS.STAT_PAUSED=1;
          sharedResource ::dmaChannelRegHandle[arbitChannel].CH_STATUS.STAT_RESUMEWAIT =1;
      end 
      if(sharedResource ::dmaChannelRegHandle[arbitChannel].CH_CTRL.USETRIGOUT==0 && sharedResource::numberOfWriteReq[arbitChannel]==0)begin
        if(sharedResource::numberOfWriteReq[arbitChannel] ==0) begin
          if(sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.DONETYPE==1) begin 
            sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.STAT_DONE=1;
            if(sharedResource::dmaChannelRegHandle[arbitChannel].CH_INTREN.INTREN_DONE ==1) begin
              sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.INTR_DONE =1;
              sharedResource::raiseInterrupt(arbitChannel,"DONE INTERRUPT RAISED");
            end
          end 
        end
      end 
      if(sharedResource ::dmaChannelRegHandle[arbitChannel].CH_CTRL.USETRIGOUT==0 && sharedResource::numberOfWriteReq[arbitChannel]==0) begin 
        if(sharedResource ::dmaChannelRegHandle[arbitChannel].CH_CMD.DISABLECMD==1) begin
          `uvm_info("TOP_SCOREBOARD",$sformatf("The command in channel[%0d] has been disabled",arbitChannel),UVM_HIGH)
          sharedResource ::disableChannel[arbitChannel] = 1;
          sharedResource ::dmaChannelRegHandle[arbitChannel].CH_CMD.ENABLECMD=0;
          sharedResource ::dmaChannelRegHandle[arbitChannel].CH_STATUS.STAT_DISABLED=1;
          if(sharedResource::dmaChannelRegHandle[arbitChannel].CH_INTREN.INTREN_DISABLED) begin
            sharedResource::dmaChannelRegHandle[arbitChannel].CH_STATUS.INTR_DISABLED=1;
          end
        end
        sharedResource::commandDone[sharedResource ::dmaChannelRegHandle[arbitChannel].CH_SRCTRIGINCFG.SRCTRIGINSEL] = 1;
        sharedResource::commandDone[sharedResource ::dmaChannelRegHandle[arbitChannel].CH_DESTRIGINCFG.DESTRIGINSEL] = 1;
      end 

      if(respTx.bresp != sharedResource::respRef[master_id].bresp) begin 
        `uvm_error("TOP_SCOREBOARD",$sformatf("THE BRESP DOESNT MATCH WHEN THE EXPECT BRESP IS %s and ACTUAL IS %s",sharedResource ::respRef[master_id].bresp,respTx.bresp))
      end 


      if(sharedResource ::dmaChannelRegHandle[arbitChannel].CH_CTRL.USETRIGOUT==0 && sharedResource::numberOfWriteReq[arbitChannel]==0)begin 
        // if no trigout use this to reload the register for auto reload
        if(sharedResource::disableChannel[arbitChannel]==1 || sharedResource::stopChannel[arbitChannel]==1) begin 
          continue;
        end 
        if(sharedResource ::dmaChannelRegHandle[arbitChannel].CH_AUTOCFG.CMDRESTARTINFEN==1)begin
          case(sharedResource ::dmaChannelRegHandle[arbitChannel].CH_CTRL.REGRELOADTYPE) 
            1: begin 
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_XSIZE.SRCXSIZE = sharedResource::initialSrcXsize[arbitChannel];
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_XSIZE.DESXSIZE = sharedResource::initialDesXsize[arbitChannel];
              sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESADDR = sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESADDR + ((sharedResource::dmaChannelRegHandle[arbitChannel].CH_YADDRSTRIDE.DESYADDRSTRIDE) * (2**(sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.TRANSIZE))) - (((sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESADDR - sharedResource::initialDesAddress[arbitChannel]))% ((sharedResource::dmaChannelRegHandle[arbitChannel].CH_YADDRSTRIDE.DESYADDRSTRIDE) * (2**(sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.TRANSIZE))));
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_SRCADDR = sharedResource ::dmaChannelRegHandle[arbitChannel].CH_SRCADDR +((sharedResource ::dmaChannelRegHandle[arbitChannel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.TRANSIZE)))- (((sharedResource::dmaChannelRegHandle[arbitChannel].CH_SRCADDR-sharedResource::initialSrcAddress[arbitChannel]))%((sharedResource ::dmaChannelRegHandle[arbitChannel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.TRANSIZE))));
            end 

            3: begin 
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_XSIZE.SRCXSIZE = sharedResource::initialSrcXsize[arbitChannel];
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_XSIZE.DESXSIZE = sharedResource::initialDesXsize[arbitChannel];
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_SRCADDR = sharedResource::initialSrcAddress[arbitChannel];
              sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESADDR = sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESADDR + ((sharedResource::dmaChannelRegHandle[arbitChannel].CH_YADDRSTRIDE.DESYADDRSTRIDE) * (2**(sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.TRANSIZE))) - (((sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESADDR - sharedResource::initialDesAddress[arbitChannel])) % ((sharedResource::dmaChannelRegHandle[arbitChannel].CH_YADDRSTRIDE.DESYADDRSTRIDE) * (2**(sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.TRANSIZE)))); 
            end 
            5: begin 
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_XSIZE.SRCXSIZE = sharedResource::initialSrcXsize[arbitChannel];
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_XSIZE.DESXSIZE = sharedResource::initialDesXsize[arbitChannel];
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_DESADDR = sharedResource::initialDesAddress[arbitChannel];
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_SRCADDR = sharedResource ::dmaChannelRegHandle[arbitChannel].CH_SRCADDR +((sharedResource ::dmaChannelRegHandle[arbitChannel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.TRANSIZE)))- (((sharedResource::dmaChannelRegHandle[arbitChannel].CH_SRCADDR-sharedResource::initialSrcAddress[arbitChannel]))%((sharedResource ::dmaChannelRegHandle[arbitChannel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.TRANSIZE))));
                  
            end 

            7:begin 
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_XSIZE.SRCXSIZE = sharedResource::initialSrcXsize[arbitChannel];
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_XSIZE.DESXSIZE = sharedResource::initialDesXsize[arbitChannel];
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_DESADDR = sharedResource::initialDesAddress[arbitChannel];
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_SRCADDR = sharedResource::initialSrcAddress[arbitChannel];
            end 
            0: begin
              `uvm_info("TOP_SCOREBOARD","THE INFINITE LEN COMMAND IS INITIATED BUT NO RELOADING OF REGISTER IS DONE",UVM_HIGH)
            end 
            default : begin
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_ERRINFO.ERRINFO.REGVALERR=1;
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_ERRINFO.CFGERR=1;
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_STATUS.STAT_ERR =1;
              if(sharedResource ::dmaChannelRegHandle[arbitChannel].CH_INTREN.INTREN_ERR ==1) begin
                sharedResource ::raiseError(arbitChannel, "CONFIG ERROR");
              end 
            end 
          endcase
          sharedResource::triggerSrcTaskCall[arbitChannel]=0;
          sharedResource::triggerDesTaskCall[arbitChannel]=0;
          sharedResource::triggerOutTaskCall[arbitChannel]=0;
          sharedResource::expectedReadAddr[arbitChannel].delete();
          sharedResource::expectedWriteAddr[arbitChannel].delete();
          sharedResource::numberOfReadReq[arbitChannel] = sharedResource::determineNumberOfReads(arbitChannel);
          sharedResource::numberOfWriteReq[arbitChannel] = sharedResource::determineNumberOfWrites(arbitChannel);
          sharedResource::setUp1DAddress(arbitChannel);
          sharedResource:: setUpTrigger(arbitChannel);
        end 
        else begin  
          if(sharedResource::reloadCount[arbitChannel]==0)begin 
            continue;
          end 
          case(sharedResource ::dmaChannelRegHandle[arbitChannel].CH_CTRL.REGRELOADTYPE) 
            1: begin 
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_XSIZE.SRCXSIZE = sharedResource::initialSrcXsize[arbitChannel];
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_XSIZE.DESXSIZE = sharedResource::initialDesXsize[arbitChannel];
               sharedResource ::dmaChannelRegHandle[arbitChannel].CH_SRCADDR = sharedResource ::dmaChannelRegHandle[arbitChannel].CH_SRCADDR +((sharedResource ::dmaChannelRegHandle[arbitChannel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.TRANSIZE)))- (((sharedResource::dmaChannelRegHandle[arbitChannel].CH_SRCADDR-sharedResource::initialSrcAddress[arbitChannel]))%((sharedResource ::dmaChannelRegHandle[arbitChannel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.TRANSIZE))));
                
              sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESADDR = sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESADDR + ((sharedResource::dmaChannelRegHandle[arbitChannel].CH_YADDRSTRIDE.DESYADDRSTRIDE) * (2**(sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.TRANSIZE))) - (((sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESADDR - sharedResource::initialDesAddress[arbitChannel])) % ((sharedResource::dmaChannelRegHandle[arbitChannel].CH_YADDRSTRIDE.DESYADDRSTRIDE) * (2**(sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.TRANSIZE)))); 
            end 

            3: begin 
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_XSIZE.SRCXSIZE = sharedResource::initialSrcXsize[arbitChannel];
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_XSIZE.DESXSIZE = sharedResource::initialDesXsize[arbitChannel];
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_SRCADDR = sharedResource::initialSrcAddress[arbitChannel];
              sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESADDR = sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESADDR + ((sharedResource::dmaChannelRegHandle[arbitChannel].CH_YADDRSTRIDE.DESYADDRSTRIDE) * (2**(sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.TRANSIZE))) - (((sharedResource::dmaChannelRegHandle[arbitChannel].CH_DESADDR - sharedResource::initialDesAddress[arbitChannel])) % ((sharedResource::dmaChannelRegHandle[arbitChannel].CH_YADDRSTRIDE.DESYADDRSTRIDE) * (2**(sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.TRANSIZE))));
            end 
            5: begin 
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_XSIZE.SRCXSIZE = sharedResource::initialSrcXsize[arbitChannel];
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_XSIZE.DESXSIZE = sharedResource::initialDesXsize[arbitChannel];
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_DESADDR = sharedResource::initialDesAddress[arbitChannel];
               sharedResource ::dmaChannelRegHandle[arbitChannel].CH_SRCADDR = sharedResource ::dmaChannelRegHandle[arbitChannel].CH_SRCADDR +((sharedResource ::dmaChannelRegHandle[arbitChannel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.TRANSIZE)))- (((sharedResource::dmaChannelRegHandle[arbitChannel].CH_SRCADDR-sharedResource::initialSrcAddress[arbitChannel]))%((sharedResource ::dmaChannelRegHandle[arbitChannel].CH_YADDRSTRIDE.SRCYADDRSTRIDE)*(2**(sharedResource::dmaChannelRegHandle[arbitChannel].CH_CTRL.TRANSIZE))));
                             
            end 

            7:begin 
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_XSIZE.SRCXSIZE = sharedResource::initialSrcXsize[arbitChannel];
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_XSIZE.DESXSIZE = sharedResource::initialDesXsize[arbitChannel];
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_DESADDR = sharedResource::initialDesAddress[arbitChannel];
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_SRCADDR = sharedResource::initialSrcAddress[arbitChannel];
            end 
            0: begin
              `uvm_info("TOP_SCOREBOARD","THE FINITE LEN COMMAND IS INITIATED BUT NO RELOADING OF REGISTER IS DONE",UVM_HIGH)
            end 
            default : begin
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_ERRINFO.ERRINFO.REGVALERR=1;
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_ERRINFO.CFGERR=1;
              sharedResource ::dmaChannelRegHandle[arbitChannel].CH_STATUS.STAT_ERR =1;
              if(sharedResource ::dmaChannelRegHandle[arbitChannel].CH_INTREN.INTREN_ERR ==1) begin
                sharedResource ::raiseError(arbitChannel, "CONFIG ERROR");
              end 
            end 
          endcase
          sharedResource ::triggerSrcTaskCall[arbitChannel]=0;	
          sharedResource ::triggerDesTaskCall[arbitChannel]=0;
          sharedResource ::triggerOutTaskCall[arbitChannel]=0;
          sharedResource::expectedReadAddr[arbitChannel].delete();
          sharedResource::expectedWriteAddr[arbitChannel].delete();
          sharedResource::numberOfReadReq[arbitChannel] = sharedResource::determineNumberOfReads(arbitChannel);
          sharedResource::numberOfWriteReq[arbitChannel] = sharedResource::determineNumberOfWrites(arbitChannel);
          sharedResource::setUp1DAddress(arbitChannel);
          sharedResource :: setUpTrigger(arbitChannel);
          sharedResource::reloadCount[arbitChannel] = sharedResource::reloadCount[arbitChannel]-1;
        end 
      end 
    end 

  endtask 

  function int  topAxiSubScoreboard:: checkArbit(int slaveId,int writeOrRead,bit respCall=0);
    int maxQos;
    int returnChannel;
    bit firstCheck;
    bit flagForSamePri;
    int queueForSamePri[$];

    if(respCall==1)begin 
      if(writeOrRead==0) begin
        for(int i=0;i<NUM_CHANNELS;i++) begin
          if(sharedResource::dmaChannelRegHandle[i].CH_CMD.ENABLECMD==0 || sharedResource::waitForResp[i]==0)  // for single kind of transfer we need not have read done (make it 1 deafult at read path
            continue;

          return i;
        end  
        `uvm_error("TOP_SCOREBOARD",$sformatf("GOT RESP WHEN NOT EXPECTED resp is %d CMD IS %d",sharedResource::waitForResp[0],sharedResource::dmaChannelRegHandle[0].CH_CMD.ENABLECMD))  
      end 
    end 

    if(writeOrRead==0) begin// write
      bit firstPri;
      int maxPri;
      for(int i=0;i<NUM_CHANNELS;i++) begin 
        if(sharedResource::dmaChannelRegHandle[i].CH_CMD.ENABLECMD==0 ||(sharedResource::priorityDesPerChannel[slaveId][i].commandDone==1) || (sharedResource::priorityDesPerChannel[slaveId][i].commandStart==0))
          continue;
        if(firstPri==0) begin 
          maxPri = sharedResource::dmaChannelRegHandle[i].CH_CTRL.CHPRIO; //qos pri 
        end 
        else if(sharedResource::dmaChannelRegHandle[i].CH_CTRL.CHPRIO > maxPri)begin 
          maxPri = sharedResource::dmaChannelRegHandle[i].CH_CTRL.CHPRIO;
        end 
      end 

      for(int i=0;i<NUM_CHANNELS;i++) begin
        if(sharedResource::dmaChannelRegHandle[i].CH_CMD.ENABLECMD==0 || (sharedResource::priorityDesPerChannel[slaveId][i].commandDone==1) || (sharedResource::priorityDesPerChannel[slaveId][i].commandStart==0)) //srcxsize==0 desxsize>0 fill
          continue;
        if(sharedResource::dmaChannelRegHandle[i].CH_CTRL.CHPRIO ==maxPri)begin
          flagForSamePri =1;
          queueForSamePri.push_back(i);
        end 
      end 

      //use priority stack with thd commanddone flag to check whom to give ownership
      if(flagForSamePri ==1 && queueForSamePri.size()==1)begin 
        for(int i=0;i <dmaGlobalPkg :: NUM_CHANNELS; i++) begin
          if(sharedResource::priorityDesPerChannel[slaveId][i].commandStart==0 || (sharedResource::priorityDesPerChannel[slaveId][i].commandDone==1)) begin         
            continue;
          end 
          else begin 
            if(firstCheck==0) begin 
              maxQos = sharedResource::priorityDesPerChannel[slaveId][i].channelPri;
              sharedResource::writeRoundRobinPtr = (i+1)%NUM_CHANNELS;
              returnChannel =i;
              firstCheck=1;
            end 
            else begin 
              if(maxQos < sharedResource::priorityDesPerChannel[slaveId][i].channelPri) begin 
                maxQos = sharedResource::priorityDesPerChannel[slaveId][i].channelPri;
                sharedResource::writeRoundRobinPtr = (i+1)%NUM_CHANNELS;
                returnChannel =i;
              end 
            end 
          end
        end 
      end 
      else if(flagForSamePri ==1 && queueForSamePri.size()>1)begin
        for(int i=0;i<NUM_CHANNELS;i++) begin
          for(int j=0;j< queueForSamePri.size ;j++) begin 
            if(queueForSamePri[j] == (sharedResource::writeRoundRobinPtr+i)%NUM_CHANNELS)begin 
              sharedResource::writeRoundRobinPtr = (j+1)%NUM_CHANNELS; //maintain for write read sep
              return j;
            end 
          end
        end  
      end 
    end 
    else begin // read   
      bit firstPri;
      int maxPri;
      for(int i=0;i<NUM_CHANNELS;i++) begin
        if(sharedResource::dmaChannelRegHandle[i].CH_CMD.ENABLECMD==0 ||  sharedResource::commandStatusPerChannel[i].readDone==1 || sharedResource::prioritySrcPerChannel[slaveId][i].commandStart==0 || (sharedResource::prioritySrcPerChannel[slaveId][i].commandDone==1) )
          continue;
        if(firstPri==0) begin
          maxPri = sharedResource::dmaChannelRegHandle[i].CH_CTRL.CHPRIO;
        end
        else if(sharedResource::dmaChannelRegHandle[i].CH_CTRL.CHPRIO > maxPri)begin
          maxPri = sharedResource::dmaChannelRegHandle[i].CH_CTRL.CHPRIO;
        end
      end

      for(int i=0;i<NUM_CHANNELS;i++) begin
        if(sharedResource::dmaChannelRegHandle[i].CH_CMD.ENABLECMD==0 ||  sharedResource::commandStatusPerChannel[i].readDone==1 || sharedResource::prioritySrcPerChannel[slaveId][i].commandStart==0 || (sharedResource::prioritySrcPerChannel[slaveId][i].commandDone==1))
          continue;
        if(sharedResource::dmaChannelRegHandle[i].CH_CTRL.CHPRIO ==maxPri)begin
          flagForSamePri =1;
          queueForSamePri.push_back(i);
        end
      end

      $display("ARBIT QUEUE IS %p and round robin is %d",queueForSamePri,sharedResource::readRoundRobinPtr);

      if(sharedResource::managerReadAccess !=0) begin
        `uvm_error("TOP_SCOREBOARD","TRYING TO ACCESS THE MANAGER READ PATH WHEN ITS ALREADY BEING ACCESSED")
      end

      if(flagForSamePri==1 && queueForSamePri.size()==1)begin 
        for(int i=0;i <dmaGlobalPkg :: NUM_CHANNELS; i++) begin
          if(sharedResource::dmaChannelRegHandle[i].CH_CMD.ENABLECMD==0 || sharedResource::prioritySrcPerChannel[slaveId][i].commandStart==0 || (sharedResource::prioritySrcPerChannel[slaveId][i].commandDone==1) || sharedResource::prioritySrcPerChannel[slaveId][i].axiAccessed == 1 ) begin
            continue;
          end
          else begin
            if(firstCheck==0) begin
              maxQos = sharedResource::prioritySrcPerChannel[slaveId][i].channelPri;
              sharedResource::readRoundRobinPtr = (i+1)%NUM_CHANNELS;
              returnChannel =i;
              firstCheck=1;
            end
            else begin
              if(maxQos < sharedResource::prioritySrcPerChannel[slaveId][i].channelPri) begin
                maxQos = sharedResource::prioritySrcPerChannel[slaveId][i].channelPri;
                returnChannel =i;
                sharedResource::readRoundRobinPtr = (i+1)%NUM_CHANNELS;
              end
            end

          end
        end
      end 
      else if(flagForSamePri==1 && queueForSamePri.size()>1) begin 
        for(int i=0;i<NUM_CHANNELS;i++) begin
          for(int j=0;j< queueForSamePri.size ;j++) begin
            if(queueForSamePri[j] == (sharedResource::readRoundRobinPtr+i)%NUM_CHANNELS)begin
              sharedResource::readRoundRobinPtr = (j+1)%NUM_CHANNELS;
              return j;
            end
          end
        end
      end 
    end 

    return returnChannel;

  endfunction 


`endif

