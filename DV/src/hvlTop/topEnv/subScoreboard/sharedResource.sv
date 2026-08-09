`ifndef SHAREDRESOURCE_INCLUDED
`define SHAREDRESOURCE_INCLUDED

class sharedResource extends uvm_object;
  `uvm_object_utils(sharedResource)

  //variable: flowControl
  //type: bit
  //used to as flag to indicate mode of trigger except command mode
  static bit flowControl[axi4_globals_pkg::NO_OF_SLAVES+1];

  //Variable: topEnvConfigHandle
  //Type : topEnvConfig
  //Description : Declaring a handle for topEnvConfig
  static topEnvConfig topEnvConfigHandle;

  //Variable: readCounter
  static int readCounter[dmaGlobalPkg::NUM_CHANNELS];
  //Variable: dmaInfotHandle
  //Type : dmaInfo
  //Description : Declaring a handle for dmaInfo
  static dmaInfo dmaInfoHandle;

  //Variable: initialSrcAddress
  //Type : anonymous
  //Description : Used for holding initial source address and accessed when using work registers
  static bit[31:0] initialSrcAddress[dmaGlobalPkg::NUM_CHANNELS];

  //Variable: initialDesAddress
  //Type : anonymous
  //Description : Used for holding initial destination address and accessed when using work register
  static bit[31:0] initialDesAddress[dmaGlobalPkg::NUM_CHANNELS];

  //Variable: initialSrcXsize
  //Type : anonymous
  //Description : Used for holding initial source XSIZE and accessed when using work registers
  static bit[31:0] initialSrcXsize[dmaGlobalPkg :: NUM_CHANNELS];

  //Variable: initialDesXsize
  //Type : anonymous
  //Description : Used for holding initial destination XSIZE and accessed when using work register
  static bit[31:0]initialDesXsize[dmaGlobalPkg::NUM_CHANNELS];


  //Variable: initialSrcYsize
  //Type : anonymous
  //Description : Used for holding initial source XSIZE and accessed when using work registers
  static bit[31:0] initialSrcYsize[dmaGlobalPkg :: NUM_CHANNELS];

  //Variable: initialDesYsize
  //Type : anonymous
  //Description : Used for holding initial destination XSIZE and accessed when using work register
  static bit[31:0]initialDesYsize[dmaGlobalPkg::NUM_CHANNELS];
   
  //Variable: expectedSrcxsize
  //Type : int 
  //Description : Used for holding expected src xsize which will update channel srcxsize when data 
  //read happens
  static int expectedSrcXsize[dmaGlobalPkg :: NUM_CHANNELS][$];

  //Variable: expectedDesxsize
  //Type : int
  //Description : Used for holding expected des xsize which will update channel desxsize when data 
  //write happens
  static int expectedDesXsize[dmaGlobalPkg :: NUM_CHANNELS][$];  

  //Variable: triggerPortChannelMap
  //Type : int
  //Description : Variable is used to hold the channel assoiated to a channel
  static int triggerPortChannelMap[axi4_globals_pkg::NO_OF_SLAVES+1];

  static int reloadCount[dmaGlobalPkg :: NUM_CHANNELS];

  //Variable: triggerOutPortChannelMap
  //Type : int
  //Description : Variable is used to hold the channel assoiated to a channel
  static int triggerOutPortChannelMap[axi4_globals_pkg::NO_OF_SLAVES+1];

  //Variable: triggerSrcTaskCall
  //Type : bit
  //Description :Variable is used as flag to indicate whether a source trigger sw/hw check has been i  //ntiated
  static bit triggerSrcTaskCall[dmaGlobalPkg::NUM_CHANNELS];  
 


  static bit waitForResp[dmaGlobalPkg::NUM_CHANNELS];

  //Variable: triggerOutTaskCall
  //Type : bit
  //Description :Variable is used as flag to indicate whether a trigger out sw/hw check has been   
  //intiated
  static bit triggerOutTaskCall[dmaGlobalPkg::NUM_CHANNELS];
 
  //Variable: triggerDesTaskCall
  //Type : bit
  //Description :Variable is used as flag to indicate whether a destination trigger sw/hw check has    //been intiated
  static bit triggerDesTaskCall[dmaGlobalPkg::NUM_CHANNELS];
   
  //Variable: commandDone
  //Type : bit
  //Description :Variable is used as flag to indicate whether a command is done and to leave the 
  //accessed trigger
  static bit commandDone[axi4_globals_pkg :: NO_OF_SLAVES+1];
  
  //Variable: pauseChannel
  //Type : bit
  //Description :Variable is used as flag to indicate whether a command is paused 
  static bit pauseChannel[dmaGlobalPkg :: NUM_CHANNELS];

  //Variable: stopChannel
  //Type : bit
  //Description :Variable is used as flag to indicate whether a command is stopped
  static bit stopChannel[dmaGlobalPkg :: NUM_CHANNELS];

  //Variable: disableChannel
  //Type : bit
  //Description :Variable is used as flag to indicate whether a command is disabled
  static bit disableChannel[dmaGlobalPkg :: NUM_CHANNELS];

  //Variable: dmaChannelRegHandle
  //Type : dmaChannelReg
  //Description : Variable is a local register structure for each channel 
  static dmaChannelReg dmaChannelRegHandle[dmaGlobalPkg::NUM_CHANNELS];
  
  //Variable: numberOfReadReq
  //Type : int 
  //Description : This variable is used to hold the expected number of read for each command of a
  // channel
  static int numberOfReadReq[dmaGlobalPkg :: NUM_CHANNELS];
  
  //Variable: numberOfWriteReq
  //Type : int
  //Description : This variable is used to hold the expected number of write for each command of a 
  // channel
  static int numberOfWriteReq[dmaGlobalPkg :: NUM_CHANNELS];
  
  //Variable: channelRequestingLinK
  //Type : int
  //Description : This variable is used to hold the expected channel that has command linking
  static int channelRequestingLink;
  
  //Variable: respref
  //Type : axi4_master_tx
  //Description : This handle is used to hold the expected response of axi4 transaction
  static axi4_master_tx respRef[axi4_globals_pkg::NO_OF_SLAVES+1];
  
  //Variable: channelQueue
  //Type : anonymous
  //Description : This variable is used as fifo structure by each channel and each channel has a 
  // queue which implements a first in first out policy
  static bit[axi4_globals_pkg::DATA_WIDTH-1:0] channelQueue[dmaGlobalPkg::NUM_CHANNELS][$];
  
  //Variable: triggerAccessed
  //Type : bit
  //Description : This handle is used as a flag to indicate whether currently trigger is accessed or   //not this is made zero when the trigger associated channel command is done
  static bit triggerAccessed[axi4_globals_pkg::NO_OF_SLAVES+1];

  //Variable: triggerOutAccessed
  //Type : bit
  //Description : This handle is used as a flag to indicate whether currently trigger is accessed or   //not this is made zero when the trigger associated channel command is done
  static bit triggerOutAccessed[axi4_globals_pkg::NO_OF_SLAVES+1];
 
  //Variable: peripheralMem
  //Type : axi4_slave_memory
  //Description : This handle is used as a pointer to a object which holds local memory which is 
  // pre-initialized 
  static axi4_slave_memory peripheralMem; // used as reference source and desti
  
  //Variable: trigSrcInfoChannel
  //Type : trigReqEnum
  //Description : This variable is used to keep track of the request type from the peripheral
  // through the trigger for the source side 
  static trigReqEnum trigSrcInfoChannel[dmaGlobalPkg::NUM_CHANNELS]; 

  //Variable: trigDesInfoChannel
  //Type : trigReqEnum
  //Description : This variable is used to keep track of the request type from the peripheral
  // through the trigger for the destination side
  static trigReqEnum trigDesInfoChannel[dmaGlobalPkg::NUM_CHANNELS];

  //type defination which is needed to keep track of channel when looking to qos based arbitration
  // and also whether a command has started or ended..is tracked for each slave axi interface as a 
  // source and destination with respected to channel 
  typedef struct packed{
    int channelPri;
    int srcAddr;
    int desAddr;
    bit axiAccessed;
    bit commandStart;
    bit commandDone;
  }channelPriority;

  typedef struct {
   bit readDone;
   int readCounter[$];
   int count;
  }commandStatus;

  static  bit managerWriteAccess;
 
  static  bit managerReadAccess;
 
  static commandStatus commandStatusPerChannel[dmaGlobalPkg :: NUM_CHANNELS];

  static bit[31:0]writeRoundRobinPtr,readRoundRobinPtr;

  //Variable: prioritySrcPerChannel
  //Type : channelPriority
  //Description : This variable is used to keep track of channel information for the read path for
  // each interface 
  static channelPriority prioritySrcPerChannel[][dmaGlobalPkg :: NUM_CHANNELS]; 

  //Variable: priorityDesPerChannel
  //Type : channelPriority
  //Description : This variable is used to keep track of channel information for the write path for
  // each interface 
  static channelPriority priorityDesPerChannel[][dmaGlobalPkg :: NUM_CHANNELS];

  //Variable: interruptControl
  //Type : semaphore
  //Description : This handle of semaphore is used to control when to get a packet of interrupt type   //ex in scenario when we are expecting an error and interrupt enable is asserted for an error  
  static semaphore interruptControl;
  
  //Variable: semaPhoreTriggerHandle
  //Type : semaphore
  //Description : This handle of semaphore is used to control when we can expect a trigger
  //key is allocated when we are expecting a harware based trigger and not during software one 
  static semaphore semaPhoreTriggerHandle[axi4_globals_pkg::NO_OF_SLAVES+1];
 
  static semaphore semaPhoreTriggerOutHandle[axi4_globals_pkg::NO_OF_SLAVES+1]; 
  //Variable: readWriteTriggerMap
  //Type : array of bits
  //Description : This variable is used to keep track of whether a trigger port is for source or is 
  // it for the destination side 
  static bit readWriteTriggerMap[axi4_globals_pkg::NO_OF_SLAVES+1];
 
  //Variable: interruptAccessed
  //Type : int 
  //Description : This variable is used to keep track whether an interrupt is being accessed
  static int interruptAccessed;
  
  //Variable: expectedReadAddr
  //Type : int 
  //Description :This variableisarray of channels whose elements are queue of expected read address 
  // for the associated channel
  static int expectedReadAddr[dmaGlobalPkg :: NUM_CHANNELS][$];  
 
  //Variable: expectedWriteAddr
  //Type : int
  //Description :This variable is array of channels whose elements are queue of expected writeaddress
  // for the associated channel 
  static int expectedWriteAddr[dmaGlobalPkg :: NUM_CHANNELS][$]; 

  extern function new(string name="sharedResource");
  extern static task initializeCommands();  
  extern static task initiateSrcTriggerTransfer(int channel);
  extern static task initiateDesTriggerTransfer(int channel);
  extern static task raiseError(int channel, string error_msg);
  extern static task raiseInterrupt(int channel, string info_msg); 
  extern static task setUp1DAddress(int channel);
  extern static function int determineNumberOfReads(int channel);  
  extern static function int determineNumberOfWrites(int channel);
  extern static task initiateTriggerOutTransfer(int channel);
  extern static task setUpTrigger(int selectedChannel);
endclass

task sharedResource :: setUpTrigger(int selectedChannel);
  sharedResource ::dmaChannelRegHandle[selectedChannel].CH_STATUS.STAT_DONE=0;
  sharedResource ::dmaChannelRegHandle[selectedChannel].CH_STATUS.INTR_DONE=0;
  if((sharedResource ::dmaChannelRegHandle[selectedChannel].CH_CTRL.TRANSIZE > dmaGlobalPkg ::DATA_WIDTH_CFG)|| (sharedResource ::dmaChannelRegHandle[selectedChannel].CH_SRCTRIGINCFG.SRCTRIGINSEL>sharedResource ::dmaInfoHandle.DMA_BUILDCFG1.NUM_TRIGGER_IN) || (sharedResource ::dmaChannelRegHandle[selectedChannel].CH_DESTRIGINCFG.DESTRIGINSEL>sharedResource ::dmaInfoHandle.DMA_BUILDCFG1.NUM_TRIGGER_IN) || (sharedResource ::dmaChannelRegHandle[selectedChannel].CH_TRIGOUTCFG.TRIGOUTSEL>sharedResource::dmaInfoHandle.DMA_BUILDCFG1.NUM_TRIGGER_OUT)) begin
    `uvm_error("TOP_SCOREBOARD",$sformatf("REG VALL ERR CAUSED WHEN TRANSIZE IS %0D AND DATA WIDTH IS %0d , SRCTRIGSEL IS %0d , DESTRIGSEL IS %0d , TRIGOUTSEL IS %0d and NUM OF TRIGPORTS IS %0d",sharedResource ::dmaChannelRegHandle[selectedChannel].CH_CTRL.TRANSIZE,dmaGlobalPkg ::DATA_WIDTH_CFG,sharedResource ::dmaChannelRegHandle[selectedChannel].CH_SRCTRIGINCFG.SRCTRIGINSEL,sharedResource ::dmaChannelRegHandle[selectedChannel].CH_DESTRIGINCFG.DESTRIGINSEL,sharedResource ::dmaChannelRegHandle[selectedChannel].CH_TRIGOUTCFG.TRIGOUTSEL,sharedResource ::dmaInfoHandle.DMA_BUILDCFG1.NUM_TRIGGER_IN))
    sharedResource ::dmaChannelRegHandle[selectedChannel].CH_ERRINFO.ERRINFO.REGVALERR=1;
    sharedResource ::dmaChannelRegHandle[selectedChannel].CH_ERRINFO.CFGERR=1;
    sharedResource ::dmaChannelRegHandle[selectedChannel].CH_STATUS.STAT_ERR =1;
    if(sharedResource ::dmaChannelRegHandle[selectedChannel].CH_INTREN.INTREN_ERR ==1) begin
      sharedResource ::raiseError(selectedChannel, "CONFIG ERROR");
    end
    disable setUpTrigger; //no need to allocate trigger if error has occured
  end
  fork
    if(sharedResource ::dmaChannelRegHandle[selectedChannel].CH_CTRL.USESRCTRIGIN==1)begin                 if(sharedResource ::triggerSrcTaskCall[selectedChannel] == 0)begin  
        sharedResource ::numberOfReadReq[selectedChannel] = sharedResource ::determineNumberOfReads(selectedChannel);
        sharedResource ::numberOfWriteReq[selectedChannel] = sharedResource ::determineNumberOfWrites(selectedChannel);
	sharedResource ::setUp1DAddress(selectedChannel);
	`uvm_info("TOP_SCOREBOARD",$sformatf("THE COMMAND IN CHANNEL[%0D] HAS %0D AND %0d NUMBER OF EXPECTED READS AND WRITES",selectedChannel,sharedResource::numberOfReadReq[selectedChannel],sharedResource :: numberOfWriteReq[selectedChannel]),UVM_HIGH)
        sharedResource ::initiateSrcTriggerTransfer(selectedChannel);
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
      sharedResource ::initialSrcYsize[selectedChannel]=sharedResource ::dmaChannelRegHandle[selectedChannel].CH_YSIZE.SRCYSIZE;
      sharedResource ::initialSrcAddress[selectedChannel]= sharedResource ::dmaChannelRegHandle[selectedChannel].CH_SRCADDR;
      sharedResource::reloadCount[selectedChannel]=sharedResource::dmaChannelRegHandle[selectedChannel].CH_AUTOCFG.CMDRESTARTCNT;
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
endtask
function sharedResource :: new(string name="sharedResource");
  super.new(name); //better to initialize semaphore here or in top scb
endfunction  

task sharedResource:: initializeCommands();
  for(int i=0;i<dmaGlobalPkg::NUM_CHANNELS;i++) begin
    dmaChannelRegHandle[i].CH_BUILDCFG1.HAS_TRIG       = 1;
    dmaChannelRegHandle[i].CH_BUILDCFG1.HAS_TRIGIN     = 1;
    dmaChannelRegHandle[i].CH_BUILDCFG1.HAS_TRIGOUT    = 1;
    dmaChannelRegHandle[i].CH_BUILDCFG1.HAS_TRIGSEL    = 1;
    dmaChannelRegHandle[i].CH_BUILDCFG1.HAS_CMDLINK    = 1;
    dmaChannelRegHandle[i].CH_BUILDCFG1.HAS_AUTO       = 0;
    dmaChannelRegHandle[i].CH_BUILDCFG1.HAS_WRAP       = 1;
    dmaChannelRegHandle[i].CH_BUILDCFG1.HAS_2D         = dmaGlobalPkg::HAS_2D;
    dmaChannelRegHandle[i].CH_BUILDCFG1.HAS_XSIZEHI    = 1;
    dmaChannelRegHandle[i].CH_BUILDCFG0.DATA_WIDTH =   dmaGlobalPkg::DATA_WIDTH_CFG;
    dmaChannelRegHandle[i].CH_BUILDCFG0.ADDR_WIDTH =   dmaGlobalPkg::ADDRESS_WIDTH_CFG;
    dmaChannelRegHandle[i].CH_BUILDCFG0.INC_WIDTH = 0;
  end
  dmaInfoHandle.DMA_BUILDCFG0.DATA_WIDTH  = dmaGlobalPkg::DATA_WIDTH_CFG;
  dmaInfoHandle.DMA_BUILDCFG0.ADDR_WIDTH  = dmaGlobalPkg::ADDRESS_WIDTH_CFG;
  dmaInfoHandle.DMA_BUILDCFG0.NUM_CHANNELS= dmaGlobalPkg::NUM_CHANNELS;
  dmaInfoHandle.DMA_BUILDCFG1.HAS_TRIGSEL = 1;
  dmaInfoHandle.DMA_BUILDCFG1.NUM_TRIGGER_OUT = axi4_globals_pkg::NO_OF_SLAVES;
  dmaInfoHandle.DMA_BUILDCFG1.NUM_TRIGGER_IN  = axi4_globals_pkg::NO_OF_SLAVES;
endtask


//Task name: initiateSrcTriggerTransfer
//Description : Used to check for the trigger and once trigger HW/SW is initiated (key allocated/Req
// received) assert a flag so that no future trigg check  takes place and for SW trigg if interrupt
// is enabled interrupt check is also done (for source ports)
task sharedResource::initiateSrcTriggerTransfer(int channel);
  int triggerPort; 
  // Initialize status
  dmaChannelRegHandle[channel].CH_STATUS.STAT_SRCTRIGINWAIT = 1;
  triggerPort = dmaChannelRegHandle[channel].CH_SRCTRIGINCFG.SRCTRIGINSEL;
  if(dmaChannelRegHandle[channel].CH_INTREN.INTREN_SRCTRIGINWAIT==1) begin
     dmaChannelRegHandle[channel].CH_STATUS.INTR_SRCTRIGINWAIT=1;
  end
  reloadCount[channel]=dmaChannelRegHandle[channel].CH_AUTOCFG.CMDRESTARTCNT;

  // need a guard so that this block is not entered when the pause or stop sw commands is given 
  // Handle source trigger 
  if (dmaChannelRegHandle[channel].CH_SRCTRIGINCFG.SRCTRIGINTYPE == 2'b10) begin
    // Hardware trigger
    triggerPort = dmaChannelRegHandle[channel].CH_SRCTRIGINCFG.SRCTRIGINSEL;
   
    if(dmaChannelRegHandle[channel].CH_SRCTRIGINCFG.SRCTRIGINMODE ==2 || dmaChannelRegHandle[channel].CH_SRCTRIGINCFG.SRCTRIGINMODE ==3) begin 
      flowControl[triggerPort]=1;
    end 
    $display("SRC CHECK STARTED TRIGGER");
    if (triggerAccessed[triggerPort] == 0 ) begin
      readWriteTriggerMap[triggerPort] = 0; // read operation
      semaPhoreTriggerHandle[triggerPort].put(1);
      `uvm_info("TOP_SCOREBOARD",$sformatf("The command in channel[%0d] is waiting for a source port hw trigger req through port %0d",channel,triggerPort),UVM_HIGH)
      initialSrcAddress[channel]= dmaChannelRegHandle[channel].CH_SRCADDR;
      initialSrcXsize[channel]=dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE;
      initialSrcYsize[channel]=dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE;
      triggerSrcTaskCall[channel]=1;
      triggerAccessed[triggerPort] = 1;
      triggerPortChannelMap[triggerPort] = channel;
      dmaChannelRegHandle[channel].CH_ERRINFO.SRCTRIGINSELERR=0;
    end else begin
    // Trigger port conflict - raise error
    
    dmaChannelRegHandle[channel].CH_ERRINFO.SRCTRIGINSELERR=1;
    if (dmaChannelRegHandle[channel].CH_INTREN.INTREN_ERR == 1) begin
      raiseError(channel, " SRC Trigger port conflict");
    end
  end    
  end else if (dmaChannelRegHandle[channel].CH_CMD.SRCSWTRIGINREQ == 1) begin
    // Software trigger
    channelPriority priorityStack;
    int selectedInterface;
    sharedResource ::dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE =sharedResource ::numberOfReadReq[channel];
    trigSrcInfoChannel[channel] = trigReqEnum'(dmaChannelRegHandle[channel].CH_CMD.SRCSWTRIGINTYPE);
    dmaChannelRegHandle[channel].CH_STATUS.STAT_SRCTRIGINWAIT = 0;
    dmaChannelRegHandle[channel].CH_STATUS.INTR_SRCTRIGINWAIT = 0;
    if(dmaChannelRegHandle[channel].CH_INTREN.INTREN_SRCTRIGINWAIT==1) begin
      dmaChannelRegHandle[channel].CH_STATUS.STAT_SRCTRIGINWAIT=0;
    end
    initialSrcYsize[channel]=dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE;
    initialSrcXsize[channel]=dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE;
    initialSrcAddress[channel]= dmaChannelRegHandle[channel].CH_SRCADDR;
    for(int i=0;i<(axi4_globals_pkg :: NO_OF_SLAVES);i++) begin
      if(dmaChannelRegHandle[channel].CH_SRCADDR>= topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].min_address && dmaChannelRegHandle[channel].CH_SRCADDR<topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].max_address) begin
        selectedInterface=i;
        break;
      end
    end
    `uvm_info("TOP_SCOREBOARD",$sformatf("A SW trigger For SRC has been received for channel[%0d] and selected interface is %0d",channel,selectedInterface),UVM_HIGH)
    triggerSrcTaskCall[channel]=1;
    priorityStack.srcAddr = dmaChannelRegHandle[channel].CH_SRCADDR;
    priorityStack.desAddr = dmaChannelRegHandle[channel].CH_DESADDR;
    priorityStack.commandStart =1;
    priorityStack.commandDone = 0;
    priorityStack.channelPri = dmaChannelRegHandle[channel].CH_CTRL.CHPRIO;
    prioritySrcPerChannel[selectedInterface][channel] = priorityStack;
  end else begin
    `uvm_info("TOP_SCOREBOARD",$sformatf("The command in channel[%0d] is waiting for a source port sw trigger req through port %0d",channel,triggerPort),UVM_HIGH)
    // No trigger - raise interrupt if enabled
    if (dmaChannelRegHandle[channel].CH_INTREN.INTREN_SRCTRIGINWAIT == 1) begin
      raiseInterrupt(channel, "Source trigger wait timeout");
    end
  end
  
endtask

//Task name: initiateDesTriggerTransfer
//Description : Used to check for the trigger and once trigger HW/SW is initiated (key allocated/Req
// received) assert a flag so that no future trigg check  takes place and for SW trigg if interrupt 
// is enabled interrupt check is also done (for destination ports)
task sharedResource :: initiateDesTriggerTransfer(int channel);
  int triggerPort;
  dmaChannelRegHandle[channel].CH_STATUS.STAT_DESTRIGINWAIT=1;
  triggerPort = dmaChannelRegHandle[channel].CH_DESTRIGINCFG.DESTRIGINSEL;
  if(dmaChannelRegHandle[channel].CH_INTREN.INTREN_DESTRIGINWAIT==1) begin
     dmaChannelRegHandle[channel].CH_STATUS.INTR_DESTRIGINWAIT=1;
  end

  if (dmaChannelRegHandle[channel].CH_DESTRIGINCFG.DESTRIGINTYPE == 2'b10) begin
    // Hardware trigger
    triggerPort = dmaChannelRegHandle[channel].CH_DESTRIGINCFG.DESTRIGINSEL;

    if(dmaChannelRegHandle[channel].CH_DESTRIGINCFG.DESTRIGINMODE ==2 || dmaChannelRegHandle[channel].CH_DESTRIGINCFG.DESTRIGINMODE ==3) begin
      flowControl[triggerPort]=1;
    end

    $display("DES CHECK STARTED TRIGGER triggerAccessed is %d",triggerAccessed[triggerPort]);
    if (triggerAccessed[triggerPort] == 0 ) begin
      readWriteTriggerMap[triggerPort] = 1; // Read operation
      semaPhoreTriggerHandle[triggerPort].put(1);
      `uvm_info("TOP_SCOREBOARD",$sformatf("The command in channel[%0d] is waiting for a destination port hw trigger req through port %0d",channel,triggerPort),UVM_HIGH)
      initialDesAddress[channel] = dmaChannelRegHandle[channel].CH_DESADDR;
      initialDesXsize[channel]=dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE;
      initialDesYsize[channel]=dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE;
      triggerDesTaskCall[channel]=1;
      triggerPortChannelMap[triggerPort] = channel;
      triggerAccessed[triggerPort] = 1;
      dmaChannelRegHandle[channel].CH_ERRINFO.DESTRIGINSELERR=0;
    end else begin
      // Trigger port conflict - raise error
      dmaChannelRegHandle[channel].CH_ERRINFO.DESTRIGINSELERR=1;
      if (dmaChannelRegHandle[channel].CH_INTREN.INTREN_ERR == 1) begin
        raiseError(channel, "DES Trigger port conflict");
      end
    end
  end else if (dmaChannelRegHandle[channel].CH_CMD.DESSWTRIGINREQ == 1) begin
    
    // Software trigger
    channelPriority priorityStack;
    int selectedInterface;
    sharedResource ::dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE =sharedResource ::numberOfWriteReq[channel];
    trigDesInfoChannel[channel] = trigReqEnum'(dmaChannelRegHandle[channel].CH_CMD.DESSWTRIGINTYPE);
    initialDesAddress[channel] = dmaChannelRegHandle[channel].CH_DESADDR;
    initialDesXsize[channel]=dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE;
    dmaChannelRegHandle[channel].CH_STATUS.STAT_DESTRIGINWAIT = 0;
    dmaChannelRegHandle[channel].CH_STATUS.INTR_DESTRIGINWAIT = 0;
    triggerDesTaskCall[channel]=1;
    for(int i=0;i<(axi4_globals_pkg :: NO_OF_SLAVES);i++) begin
      if(dmaChannelRegHandle[channel].CH_DESADDR>= topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].min_address && dmaChannelRegHandle[channel].CH_DESADDR<topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].max_address) begin
        selectedInterface=i;
        break;
      end
    end

    `uvm_info("TOP_SCOREBOARD",$sformatf("A SW trigger For Des has been received for channel[%0d] and selected interface is %0d",channel,selectedInterface),UVM_HIGH)

    // Write operation (destination trigger)
    
    priorityStack.srcAddr = dmaChannelRegHandle[channel].CH_SRCADDR;
    priorityStack.desAddr = dmaChannelRegHandle[channel].CH_DESADDR;
    priorityStack.commandStart = 1;
    priorityStack.commandDone = 0;
    priorityStack.channelPri = dmaChannelRegHandle[channel].CH_CTRL.CHPRIO;
    priorityDesPerChannel[selectedInterface][channel] = priorityStack;
  end else begin
   `uvm_info("TOP_SCOREBOARD",$sformatf("The command in channel[%0d] is waiting for a destination port sw trigger req through port %0d",channel,triggerPort),UVM_HIGH)
    // No trigger - raise interrupt if enabled
    if (dmaChannelRegHandle[channel].CH_INTREN.INTREN_DESTRIGINWAIT == 1) begin
      raiseInterrupt(channel, "Destination trigger wait timeout");
    end
  end
endtask 


task sharedResource::raiseError(int channel, string error_msg);
    dmaChannelRegHandle[channel].CH_STATUS.STAT_ERR = 1;
    dmaChannelRegHandle[channel].CH_STATUS.INTR_ERR = 1;
    `uvm_error("TOP_SCOREBOARD", $sformatf("Channel[%0d]: %s", channel, error_msg))
endtask


//Task name : raiseInterrupt 
//Description : Is used to handle interrupt port transaction
task sharedResource::raiseInterrupt(int channel, string info_msg);
    `uvm_info("TOP_SCOREBOARD", $sformatf("Channel[%0d]: %s", channel, info_msg), UVM_MEDIUM)
endtask


//Task name: setUp1DAddress
//Descriptipon : This task is used to determine the expected address for both write and read side
//for the channel for which the task is called based on the xtype and y type as well as based on 
//the srcxsize and desxsize and src/des ysize
task sharedResource::setUp1DAddress(int channel);
  int beat_bytes;
  int i;
  automatic int srcAddr;
  automatic int desAddr;
  automatic int srcXsize;
  automatic int desXsize;
  automatic xTypeEnum xType;
  automatic int tranSize;
  automatic yTypeEnum yType;
  automatic int srcYsize;
  automatic int desYsize;
  automatic int srcYaddrStride;
  automatic int desYaddrStride;
  automatic bit has2D;
  automatic int srcIncr,desIncr;

  int row_base;
  int totalTransfers;
  int calculateSrcXsize,calculateDesXsize;
  bit flagHasTemp;
  srcAddr= dmaChannelRegHandle[channel].CH_SRCADDR.SRCADDR;
  desAddr= dmaChannelRegHandle[channel].CH_DESADDR.DESADDR;
  srcXsize= dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE;
  desXsize= dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE;
  xType= dmaChannelRegHandle[channel].CH_CTRL.XTYPE;
  tranSize= dmaChannelRegHandle[channel].CH_CTRL.TRANSIZE;
  flagHasTemp = dmaChannelRegHandle[channel].CH_TMPLTCFG.DESTMPLTSIZE> 0 || dmaChannelRegHandle[channel].CH_TMPLTCFG.SRCTMPLTSIZE> 0;

  yType= dmaChannelRegHandle[channel].CH_CTRL.YTYPE;
  srcYsize= dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE;
  desYsize= dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE;
  srcYaddrStride = dmaChannelRegHandle[channel].CH_YADDRSTRIDE.SRCYADDRSTRIDE;
  desYaddrStride = dmaChannelRegHandle[channel].CH_YADDRSTRIDE.DESYADDRSTRIDE;
  has2D=dmaChannelRegHandle[channel].CH_BUILDCFG1.HAS_2D;
  if(dmaChannelRegHandle[channel].CH_XADDRINC.SRCXADDRINC[15]==1)begin //to support negative dir 
   srcIncr[31:16] = '1;
   srcIncr[15:0] = dmaChannelRegHandle[channel].CH_XADDRINC.SRCXADDRINC;
  end 
  else begin 
    srcIncr = dmaChannelRegHandle[channel].CH_XADDRINC.SRCXADDRINC;
  end 
  if(dmaChannelRegHandle[channel].CH_XADDRINC.DESXADDRINC[15]==1)begin 
    desIncr[31:16]='1;
    desIncr[15:0] = dmaChannelRegHandle[channel].CH_XADDRINC.DESXADDRINC;
  end 
  else begin 
    desIncr = dmaChannelRegHandle[channel].CH_XADDRINC.DESXADDRINC;
  end 
  calculateSrcXsize = determineNumberOfReads(channel);
  calculateDesXsize = determineNumberOfWrites(channel);;
  beat_bytes = 1 << tranSize;
  if(flagHasTemp) begin 
    if (xType == X_CONTINUE || xType==X_FILL) begin
      totalTransfers = (srcXsize<desXsize)?srcXsize:desXsize;
    end
    else begin
      totalTransfers = desXsize;
    end
  
    if(dmaChannelRegHandle[channel].CH_TMPLTCFG.SRCTMPLTSIZE> 0) begin 
      int validCheck=0;
       $display("V2 TRANSFER IS %0d",totalTransfers);
      for(int i=0;i<totalTransfers;i++) begin 
        if (dmaChannelRegHandle[channel].CH_SRCTMPLT[validCheck] !=1) begin 
             i--;
             srcAddr = srcAddr + beat_bytes; // skip this address 
             validCheck = ((validCheck+1)%(dmaChannelRegHandle[channel].CH_TMPLTCFG.SRCTMPLTSIZE+1));
             continue;
        end
        case (xType)
          X_CONTINUE: begin
            expectedReadAddr[channel].push_back(srcAddr);
            calculateSrcXsize--;
            expectedSrcXsize[channel].push_back(calculateSrcXsize);
          end
          X_WRAP: begin
             expectedReadAddr[channel].push_back(srcAddr);
             calculateSrcXsize--;
             expectedSrcXsize[channel].push_back(calculateSrcXsize);
          end
          X_FILL: begin
            if (i < srcXsize) begin
              expectedReadAddr[channel].push_back(srcAddr);
              calculateSrcXsize--;
              expectedSrcXsize[channel].push_back(calculateSrcXsize);
            end
          end
        endcase
        if(dmaChannelRegHandle[channel].CH_SRCTMPLT[validCheck] ==1)begin
          validCheck = ((validCheck+1)%(dmaChannelRegHandle[channel].CH_TMPLTCFG.SRCTMPLTSIZE+1));
          if(xType != X_WRAP) begin
            srcAddr = srcAddr + beat_bytes;
          end
          else if(i % srcXsize ==0) begin
           srcAddr = dmaChannelRegHandle[channel].CH_SRCADDR.SRCADDR;
          end

        end

        if(calculateSrcXsize == 1 && (determineNumberOfReads(channel) > srcXsize)) begin 
          calculateSrcXsize = (determineNumberOfReads(channel) +1);
        end 
      end      
    end 
    else begin 
      for (int i = 0; i < totalTransfers; i++) begin
        case (xType)

          X_CONTINUE: begin 
            expectedReadAddr[channel].push_back(srcAddr + (i * beat_bytes));
            calculateSrcXsize--;
            expectedSrcXsize[channel].push_back(calculateSrcXsize);
          end 
          X_WRAP: begin
            expectedReadAddr[channel].push_back(srcAddr + ((i % srcXsize) * beat_bytes));
            calculateSrcXsize--;
            expectedSrcXsize[channel].push_back(calculateSrcXsize);
          end 
          X_FILL: begin 
            if (i < srcXsize) begin 
              expectedReadAddr[channel].push_back(srcAddr + (i * beat_bytes));
              calculateSrcXsize--;
              expectedSrcXsize[channel].push_back(calculateSrcXsize);
            end 
          end
        endcase
        if(calculateSrcXsize == 1 && (determineNumberOfReads(channel) >srcXsize)) begin 
          calculateSrcXsize = (determineNumberOfReads(channel) +1);
        end 
        `uvm_info("TOP_SCOREBOARD",$sformatf("1D Excepted Write Addr:%p, Excepted Read Addr:%p",expectedWriteAddr,expectedReadAddr),UVM_NONE)
      end 
    end
    $display("V2 CHECK %p",expectedReadAddr[channel]);

    if(dmaChannelRegHandle[channel].CH_TMPLTCFG.DESTMPLTSIZE> 0) begin 
      int validCheck=0;
      for(int i=0;i<totalTransfers;i++) begin 
         if (dmaChannelRegHandle[channel].CH_DESTMPLT[validCheck] !=1) begin
             i--;
             desAddr = desAddr + beat_bytes; // skip this address
             validCheck = ((validCheck+1)%(dmaChannelRegHandle[channel].CH_TMPLTCFG.DESTMPLTSIZE+1));
             continue;
         end
         calculateDesXsize--;
         expectedDesXsize[channel].push_back(calculateDesXsize);
         expectedWriteAddr[channel].push_back(desAddr);
         desAddr = desAddr + beat_bytes; // skip this address
         validCheck = ((validCheck+1)%(dmaChannelRegHandle[channel].CH_TMPLTCFG.DESTMPLTSIZE+1));
      end      
    end 
    else begin 
      for (int i = 0; i < totalTransfers; i++) begin
        calculateDesXsize--;
        expectedDesXsize[channel].push_back(calculateDesXsize);
        expectedWriteAddr[channel].push_back(desAddr +(i * beat_bytes));
      end 
    end 
  end 
   $display("V2 DES IS %p",expectedWriteAddr[channel]); 
  if(!flagHasTemp) begin 
    if(yType == Y_DISABLE || (has2D == 0 || (has2D == 1 && srcYsize == 1)))begin 
      if (xType == X_CONTINUE) begin
        totalTransfers = (srcXsize<desXsize)?srcXsize:desXsize;
      end
      else begin
        totalTransfers = desXsize;
      end

      for (int i = 0; i < totalTransfers; i++) begin
        case (xType)

          X_CONTINUE: begin 
            expectedReadAddr[channel].push_back(srcAddr +  (srcIncr * i * beat_bytes));
            calculateSrcXsize--;
            expectedSrcXsize[channel].push_back(calculateSrcXsize);
          end 
          X_WRAP: begin
            expectedReadAddr[channel].push_back(srcAddr + ((i % srcXsize) * beat_bytes *srcIncr));
            calculateSrcXsize--;
            expectedSrcXsize[channel].push_back(calculateSrcXsize);
          end 
          X_FILL: begin 
            if(i < srcXsize) begin 
              expectedReadAddr[channel].push_back(srcAddr + (i * beat_bytes * srcIncr));
              calculateSrcXsize--;
              expectedSrcXsize[channel].push_back(calculateSrcXsize);
            end 
          end
        endcase
        calculateDesXsize--;
        expectedDesXsize[channel].push_back(calculateDesXsize);
        if(calculateSrcXsize == 1 && (determineNumberOfReads(channel) >srcXsize)) begin 
          calculateSrcXsize = (determineNumberOfReads(channel) +1);
        end 
        expectedWriteAddr[channel].push_back(desAddr +(i * beat_bytes));

        `uvm_info("TOP_SCOREBOARD",$sformatf("1D Excepted Write Addr:%p, Excepted Read Addr:%p",expectedWriteAddr,expectedReadAddr),UVM_NONE)
      end
    end
    
    else  begin //2d
      int totalTransferPerRow;
      int totalElements;
      int row_no=1;
      int push_addr;
      row_base = srcAddr; //1000 25  4
      push_addr = row_base;

      for(int i=0;i<numberOfReadReq[channel];i++) begin
        push_addr = push_addr + ( ((totalTransferPerRow==0 )|| (totalTransferPerRow%srcXsize)==0&& (i!=1)) ? 0 : (int'(beat_bytes *srcIncr)));
        totalTransferPerRow++; 
        totalElements++;
        expectedReadAddr[channel].push_back(push_addr);
        $display("PUSH ADDRESS = %d", push_addr);
       `uvm_info("TOP_SCOREBOARD",$sformatf("2D Excepted Read Addr:%p and qsize is %0d row_no=%0d srcysize=%0d noOfElem=%0d ytype %s",expectedReadAddr,expectedReadAddr[channel].size(),row_no,srcYsize,totalTransferPerRow,yType),UVM_NONE)
 
        calculateSrcXsize--;
        expectedSrcXsize[channel].push_back(calculateSrcXsize);
        if(calculateSrcXsize == 1 ) begin
          calculateSrcXsize = srcXsize;
        end
  
        if((yType==Y_WRAP  && totalElements == (srcXsize * srcYsize) && xType==X_CONTINUE) || (yType==Y_WRAP && ((totalTransferPerRow % desXsize)==0)&&(row_no==(srcYsize) && xType != X_CONTINUE) && (desXsize <= srcXsize))  || (yType==Y_WRAP && ((totalTransferPerRow % srcXsize)==0)&&(row_no==(srcYsize) && xType == X_FILL) && (desXsize > srcXsize)) || (yType==Y_WRAP && ((totalTransferPerRow % desXsize)==0)&&(row_no==(srcYsize) && xType == X_WRAP) && (desXsize > srcXsize)))begin //is not triggered for xtype fill/wrap and ytype in des is greater 
          row_base = srcAddr;
          row_no=1;
          push_addr = row_base;
          totalTransferPerRow=0;
          totalElements =0;
        end else if((totalTransferPerRow%desXsize)==0 && xType != X_CONTINUE)begin //should take con     tinue in consi
          row_base = row_base + (srcYaddrStride *beat_bytes);
          push_addr = row_base ;
          row_no++;
          totalTransferPerRow=0;
        end else if(((totalTransferPerRow % srcXsize) ==0)&& (xType==X_CONTINUE || xType==X_FILL))begin 
          row_base = row_base + (srcYaddrStride *beat_bytes);
          push_addr = row_base;
          row_no++;
          totalTransferPerRow=0;
        end  
        else if(((totalTransferPerRow % srcXsize) == 0 )&& (xType==X_WRAP)) begin //will execute when src < des and not when src==des
          push_addr = row_base; //dont make row elements zero here 
        end
      end 

      push_addr = desAddr;
      row_base = push_addr;
      for(int i=0;i<numberOfWriteReq[channel];i++) begin 
        push_addr = push_addr + ( ((i==0 )|| (i%desXsize)==0&& (i!=1)) ? 0 : (beat_bytes *desIncr));
        expectedWriteAddr[channel].push_back(push_addr);
        calculateDesXsize--;
        expectedDesXsize[channel].push_back(calculateDesXsize);
 
        if(((i % desXsize) ==(desXsize-1))&& i!=0) begin 
          row_base = row_base + (desYaddrStride * beat_bytes);
          push_addr = row_base;
        end 
      end 
      $display("DESTINATION ADDRESS=%p",expectedWriteAddr[channel]);
    end  
  end 
endtask


//Function name: determineNumberOfReads
//Description : This function is used to determine the number of reads transfer in general to be 
//expected for a channel based on the src and des XSIZE and src and des YSIZE and mainly the XTYPE 
// and YTPE of the channel 
function int sharedResource :: determineNumberOfReads(int channel);
  int numberOfRows;
  int numberOfColumns;
  int mul;
  int biggestColumn;
  int smallestRow;
  bit flagHasTemp;
  int totalTransfers;
  flagHasTemp =dmaChannelRegHandle[channel].CH_TMPLTCFG.DESTMPLTSIZE> 0 || dmaChannelRegHandle[channel].CH_TMPLTCFG.SRCTMPLTSIZE> 0;

  if(flagHasTemp)begin //we are checking 1d totaltransfer for template
    if (dmaChannelRegHandle[channel].CH_CTRL.XTYPE == X_CONTINUE || dmaChannelRegHandle[channel].CH_CTRL.XTYPE == X_FILL) begin
      totalTransfers = (dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE > dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE )? dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE : dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE ;
    end
    else begin
      totalTransfers = dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE;
    end
    return totalTransfers;
  end  

  if(dmaChannelRegHandle[channel].CH_BUILDCFG1.HAS_2D == 1)begin
    if((dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE == dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE)&& (dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE< dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE))begin 
      return (dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE *dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE);
    end 
    case(dmaChannelRegHandle[channel].CH_CTRL.YTYPE)
     Y_WRAP: begin 
       case(dmaChannelRegHandle[channel].CH_CTRL.XTYPE)
         X_WRAP : begin 
           return dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE * dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE;
         end 
         X_CONTINUE: begin 
           return dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE * dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE;
         end 
         X_FILL : begin 
            biggestColumn = (dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE > dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE)? dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE : dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE ;
            return dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE * biggestColumn;
         end 
         X_DISABLE: return  0;
       endcase
     end 
     Y_CONTINUE : begin 
       case(dmaChannelRegHandle[channel].CH_CTRL.XTYPE)
         X_WRAP : begin 
           smallestRow = (dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE > dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE) ? dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE : dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE;
           return dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE * smallestRow;
         end 
         X_CONTINUE: begin 
             $display("HHEY ITS HERE ");
             $display("SRCXSIZE %d desxsize %d srcysize %d  desysize %d",dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE,dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE,dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE,dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE);
           if((dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE * dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE) > (dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE * dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE)) begin 
              return (dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE * dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE); 
           end 
           else begin 
            return (dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE * dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE);
           end            
         end 
         X_FILL : begin 
           biggestColumn = (dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE > dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE)? dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE : dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE ;
           smallestRow = (dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE > dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE)? dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE : dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE;
           
            return biggestColumn * smallestRow;
         end  
         X_DISABLE :begin 
           return 0;
         end 
       endcase
     end
     Y_FILL : begin
       case(dmaChannelRegHandle[channel].CH_CTRL.XTYPE)
         X_FILL : begin 
           biggestColumn = (dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE > dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE)? dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE : dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE ;
           smallestRow = (dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE > dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE)? dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE : dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE;
           return biggestColumn * smallestRow;
         end  

         X_CONTINUE: begin 
           if((dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE * dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE) > (dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE * dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE)) begin
              return (dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE * dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE);
           end
           else begin
            return (dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE * dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE);
           end
         end 
         X_WRAP : begin
           smallestRow = (dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE > dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE )? dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE : dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE;
            return dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE * smallestRow;
         end 
       endcase      
     end
    endcase
  end
  else begin 
    if(dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE == 0) begin
      return dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE;  
    end
    case( dmaChannelRegHandle[channel].CH_CTRL.XTYPE) 
      X_CONTINUE: begin
        biggestColumn = (dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE > dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE) ? dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE : dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE ;
        return biggestColumn;
      end 
      X_WRAP: begin 
        return dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE;
      end 
      X_FILL :begin 
        biggestColumn = (dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE > dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE )? dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE : dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE ;
        return biggestColumn;
      end 
    endcase 
  end   
endfunction 

//Function name: determineNumberOfWrites
//Description : This function is used to determine the number of writes transfer in general to be
//expected for a channel based on the src and des XSIZE and src and des YSIZE and mainly the XTYPE
// and YTPE of the channel
function int sharedResource :: determineNumberOfWrites(int channel);
  int numberOfRows;
  int numberOfColumns;
  int biggestColumn;
  int lastRow;
  bit flagHasTemp;
  int totalTransfers;
  flagHasTemp =dmaChannelRegHandle[channel].CH_TMPLTCFG.DESTMPLTSIZE> 0 || dmaChannelRegHandle[channel].CH_TMPLTCFG.SRCTMPLTSIZE> 0;

  if(flagHasTemp)begin
    if (dmaChannelRegHandle[channel].CH_CTRL.XTYPE == X_CONTINUE) begin
      totalTransfers = (dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE > dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE ? dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE : dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE );
    end
    else begin
      totalTransfers = dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE;
    end
    return totalTransfers;
  end

  if(dmaChannelRegHandle[channel].CH_BUILDCFG1.HAS_2D == 1)begin
    if(dmaChannelRegHandle[channel].CH_CTRL.XTYPE  == X_CONTINUE && dmaChannelRegHandle[channel].CH_CTRL.YTYPE == Y_CONTINUE) begin 
      if((dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE * dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE) > (dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE * dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE)) begin
        return (dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE * dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE);
      end
      else begin
        return (dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE * dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE);
      end
    end 
    else if(dmaChannelRegHandle[channel].CH_CTRL.YTYPE  == Y_CONTINUE)begin 
     if(dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE > dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE) begin 
       return (dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE * dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE);
     end 
     else begin 
       return (dmaChannelRegHandle[channel].CH_YSIZE.SRCYSIZE * dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE);
     end 
    end 
    else begin 
     return (dmaChannelRegHandle[channel].CH_YSIZE.DESYSIZE * dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE);
    end
  end
  else begin 
    if(dmaChannelRegHandle[channel].CH_CTRL.XTYPE  == X_CONTINUE ) begin 
      biggestColumn = (dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE > dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE ? dmaChannelRegHandle[channel].CH_XSIZE.SRCXSIZE : dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE );
      return biggestColumn;  
    end
    else begin 
      return dmaChannelRegHandle[channel].CH_XSIZE.DESXSIZE;
    end   
  end  
endfunction


//Task name: initiateTriggerOutTransfer
//Description : Used to check for the trigger and once trigger HW/SW is initiated (key allocated/Req
task sharedResource::initiateTriggerOutTransfer(int channel);
  int triggerPort;
   triggerPort=dmaChannelRegHandle[channel].CH_TRIGOUTCFG.TRIGOUTSEL;
    if (dmaChannelRegHandle[channel].CH_TRIGOUTCFG.TRIGOUTTYPE == 2'b10) begin 
      if(triggerOutAccessed[triggerPort] == 0) begin
	triggerOutTaskCall[channel]=1;
        semaPhoreTriggerOutHandle[triggerPort].put(1); 
        triggerOutAccessed[triggerPort]=1;
        triggerOutPortChannelMap[triggerPort]=channel;
      end  
      else begin 
        dmaChannelRegHandle[channel].CH_ERRINFO.TRIGOUTSELERR=1;
        if (dmaChannelRegHandle[channel].CH_INTREN.INTREN_ERR == 1) begin
          raiseError(channel, "Trigger OUT port conflict");
        end
      end 
    end 
    else if(dmaChannelRegHandle[channel].CH_CMD.SWTRIGOUTACK == 1) begin 
      triggerOutAccessed[triggerPort]=0;
      triggerOutTaskCall[channel]=1;
      dmaChannelRegHandle[channel].CH_STATUS.STAT_TRIGOUTACKWAIT=0;
      dmaChannelRegHandle[channel].CH_STATUS.INTR_TRIGOUTACKWAIT=0;
      if(sharedResource::dmaChannelRegHandle[channel].CH_SRCTRIGINCFG.SRCTRIGINTYPE ==2'b 10) begin
         sharedResource::commandDone[sharedResource ::dmaChannelRegHandle[channel].CH_SRCTRIGINCFG.SRCTRIGINSEL] = 1;
      end
      if(sharedResource::dmaChannelRegHandle[channel].CH_DESTRIGINCFG.DESTRIGINTYPE ==2'b 10) begin
         sharedResource::commandDone[sharedResource ::dmaChannelRegHandle[channel].CH_DESTRIGINCFG.DESTRIGINSEL] = 1;
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
      if(sharedResource ::dmaChannelRegHandle[channel].CH_CMD.DISABLECMD==1) begin
       `uvm_info("TOP_SCOREBOARD",$sformatf("The command in channel[%0d] has been disabled",channel),UVM_HIGH)
       sharedResource ::disableChannel[channel] = 1;
       sharedResource ::dmaChannelRegHandle[channel].CH_CMD.ENABLECMD=0;
       sharedResource ::dmaChannelRegHandle[channel].CH_STATUS.STAT_DISABLED=1;
       if(sharedResource::dmaChannelRegHandle[channel].CH_INTREN.INTREN_DISABLED) begin
          sharedResource::dmaChannelRegHandle[channel].CH_STATUS.INTR_DISABLED=1;
       end
     end

     if(numberOfReadReq[channel] != 0) begin
       `uvm_error("TOP SCOREBOARD","NUMBER OF EXPECTED READS HAS NOT TAKEN PLACE")
     end
     else begin
       `uvm_info("TOP SCOREBOARD","NUMBER OF EXPECTED READS HAS TAKEN PLACE ",UVM_HIGH)
     end
     if(numberOfWriteReq[channel] != 0) begin
       `uvm_error("TOP SCOREBOARD","NUMBER OF EXPECTED WRITES HAS NOT TAKEN PLACE ")
     end
    else begin
      `uvm_info("TOP SCOREBOARD","NUMBER OF EXPECTED WRITES HAS TAKEN PLACE ",UVM_HIGH)
    end
    end 
    else begin 
      if (dmaChannelRegHandle[channel].CH_INTREN.INTREN_TRIGOUTACKWAIT == 1) begin
        raiseInterrupt(channel, "SW TRIG OUT ACK WAIT");
      end
    end 
endtask

`endif
 
