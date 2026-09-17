`ifndef DMABASETEST_INCLUDED
`define DMABASETEST_INCLUDED

class dmaBaseTest extends uvm_test;

  `uvm_component_utils(dmaBaseTest)

  topEnv topEnvHandle;
  topEnvConfig topEnvConfigHandle;
  bit[31:0]header;
  extern function new(string name = "dmaBaseTest", uvm_component parent = null);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void setUpConfigHeirarchy();
  extern  function void setupPeripheralEnvConfig();
  extern  function void setupAxi4MasterAgentConfig();
  extern function void setupAxi4SlaveAgentConfig();
  extern function void setupTriggerSlaveAgentConfig();
  extern function void setupTriggerMasterAgentConfig();
  extern function void setupConfigUnitEnvConfig();
  extern function void setupApbMasterAgentConfig();
  extern function void setupInterruptSlaveAgentConfig();
  extern function void setupBootMasterAgentConfig();
  extern function void setUpCommand();
  extern function string configuration_dump();
  extern function string format_struct(string raw);
  extern function string format_struct_compact(string raw);
  extern function string str_replace(string src, string pat, string repl);
  extern task dump_config_to_file();
endclass


function dmaBaseTest::new(string name = "dmaBaseTest",uvm_component parent = null);
  super.new(name,parent);
endfunction

function void dmaBaseTest :: build_phase(uvm_phase phase);
//  dmaReportServer srv;
  super.build_phase(phase);
//  srv = new();
  //uvm_report_server::set_server(srv);
  setUpConfigHeirarchy();
  uvm_config_db #(topEnvConfig) :: set(this,"topEnvHandle","topEnvConfigHandle",topEnvConfigHandle);
  topEnvHandle = topEnv :: type_id :: create("topEnvHandle",this);
endfunction

function void dmaBaseTest::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  uvm_root::get().print_topology(); // to be compliant with changes as per the IEEE 1800.2-2017
endfunction

// Prints, once, the whole picture of what this run is about to do: which test,
// where each AXI slave lives, and the command each channel is programmed with.
// Anyone opening the log can read the intent off the top instead of
// reconstructing it from the transactions further down.
function void dmaBaseTest::start_of_simulation_phase(uvm_phase phase);
  string                  banner;
  axi4_slave_agent_config slaveCfg;
  dmaChannelReg           cmdCfg;
  xTypeEnum               xType;
  yTypeEnum               yType;
  super.start_of_simulation_phase(phase);

  banner = "\n================================================================================\n";
  banner = {banner, $sformatf("  TEST          : %s\n", get_type_name())};
  banner = {banner, $sformatf("  DMA CHANNELS  : %0d\n", dmaGlobalPkg::NUM_CHANNELS)};
  banner = {banner, $sformatf("  AXI SLAVES    : %0d\n", axi4_globals_pkg::NO_OF_SLAVES + 1)};
  banner = {banner, "--------------------------- AXI SLAVE MEMORY MAP -------------------------------\n"};

  foreach (topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i]) begin
    slaveCfg = topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i];
    banner = {banner, $sformatf("    slave[%0d]    : 0x%0h .. 0x%0h\n", i, slaveCfg.min_address, slaveCfg.max_address)};
  end

  banner = {banner, "-------------------------- CHANNEL COMMAND PLAN --------------------------------\n"};
  foreach (topEnvConfigHandle.allChannelConfig[ch]) begin
    banner = {banner, $sformatf("    channel[%0d]  : %0d command(s)\n", ch, topEnvConfigHandle.numberOfCommandPerChannel[ch])};
    for (int cmd = 0; cmd < topEnvConfigHandle.allChannelConfig[ch].size(); cmd++) begin
      cmdCfg = topEnvConfigHandle.allChannelConfig[ch][cmd];
      xType  = xTypeEnum'(cmdCfg.CH_CTRL.XTYPE);
      yType  = yTypeEnum'(cmdCfg.CH_CTRL.YTYPE);
      banner = {banner, $sformatf("      cmd[%0d]  src=0x%0h des=0x%0h  srcXsize=%0d desXsize=%0d  %s %s  enable=%0d link=%0d\n", cmd, cmdCfg.CH_SRCADDR.SRCADDR, cmdCfg.CH_DESADDR.DESADDR, cmdCfg.CH_XSIZE.SRCXSIZE, cmdCfg.CH_XSIZE.DESXSIZE, xType.name(), yType.name(), cmdCfg.CH_CMD.ENABLECMD, cmdCfg.CH_LINKADDR.LINKADDREN)};
    end
  end

  banner = {banner, "================================================================================\n"};
  `uvm_info("DMA_TEST", banner, UVM_LOW)
endfunction


function void dmaBaseTest::setUpConfigHeirarchy();
  topEnvConfigHandle  = topEnvConfig :: type_id :: create("topEnvConfigHandle");
  topEnvConfigHandle.hasScoreboard = 1;
  topEnvConfigHandle.hasCoverage = 1;
  topEnvConfigHandle.hasVirtualSequencer = 1;
  topEnvConfigHandle.regBlockHandle = reg_block_top :: type_id :: create("regBlockHandle");
  topEnvConfigHandle.regBlockHandle.build();
  topEnvConfigHandle.m1Enabled =M1_ENABLED;
  topEnvConfigHandle.randomize();
  //setupDmaControllerEnvConfig();
  setupPeripheralEnvConfig();
  setupConfigUnitEnvConfig();
endfunction

function void dmaBaseTest :: setupPeripheralEnvConfig();
  topEnvConfigHandle.peripheralEnvConfigHandle = peripheralEnvConfig :: type_id :: create("peripheralEnvConfigHandle");
  topEnvConfigHandle.peripheralEnvConfigHandle.hasScoreboard =0;
  topEnvConfigHandle.peripheralEnvConfigHandle.hasVirtualSequencer = 1;
  setupAxi4MasterAgentConfig();
  setupAxi4SlaveAgentConfig();
  setupTriggerSlaveAgentConfig();
  setupTriggerMasterAgentConfig();
endfunction


function void dmaBaseTest::setupAxi4MasterAgentConfig();
  bit [63:0]local_min_address;
  bit [63:0]local_max_address;
  topEnvConfigHandle.peripheralEnvConfigHandle.axi4MasterAgentConfigHandle = new[axi4_globals_pkg::NO_OF_SLAVES+1];
  foreach(topEnvConfigHandle.peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[i])begin
    topEnvConfigHandle.peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[i]=
    axi4_master_agent_config::type_id::create($sformatf("axi4_master_agent_cfg_h[%0d]",i));
    topEnvConfigHandle.peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[i].is_active   = uvm_active_passive_enum'(UVM_PASSIVE);
    topEnvConfigHandle.peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[i].has_coverage = 1;
    topEnvConfigHandle.peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[i].qos_mode_type = QOS_MODE_DISABLE;
    if(!(uvm_config_db #(virtual axi4_if) :: get(this , "" , $sformatf("axi4_if[%0d]",i),topEnvConfigHandle.peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[i].vif)))begin
      `uvm_fatal("TEST","FAILED TO GET THE MASTER AXI INTERFACE")
    end

  end

  for(int i =0; i<=axi4_globals_pkg::NO_OF_SLAVES;i++) begin
    if(i == 0) begin
      topEnvConfigHandle.peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[i].master_min_addr_range(i,0);
      local_min_address = topEnvConfigHandle.peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[i].master_min_addr_range_array[i];
      topEnvConfigHandle.peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[i].master_max_addr_range(i,2**(SLAVE_MEMORY_SIZE)-1 );
      local_max_address = topEnvConfigHandle.peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[i].master_max_addr_range_array[i];
    end
    else begin
      if(i==axi4_globals_pkg::NO_OF_SLAVES) begin
        topEnvConfigHandle.peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[i].master_min_addr_range(i,local_max_address + SLAVE_MEMORY_GAP);
        local_min_address = topEnvConfigHandle.peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[i].master_min_addr_range_array[i];
        topEnvConfigHandle.peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[i].master_max_addr_range(i, local_max_address + SLAVE_MEMORY_GAP);
        local_max_address = topEnvConfigHandle.peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[i].master_max_addr_range_array[i];
      end
      else begin
        topEnvConfigHandle.peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[i].master_min_addr_range(i,local_max_address + SLAVE_MEMORY_GAP);
        local_min_address = topEnvConfigHandle.peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[i].master_min_addr_range_array[i];
        topEnvConfigHandle.peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[i].master_max_addr_range(i,local_max_address+ 2**(SLAVE_MEMORY_SIZE)-1 + SLAVE_MEMORY_GAP);
        local_max_address = topEnvConfigHandle.peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[i].master_max_addr_range_array[i];
      end
    end
  end
endfunction

function void dmaBaseTest::setupAxi4SlaveAgentConfig();
  topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle= new[axi4_globals_pkg::NO_OF_SLAVES+1];
  foreach(topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i])begin
    topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i] =
    axi4_slave_agent_config::type_id::create($sformatf("axi4_slave_agent_cfg_h[%0d]",i));
    topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].slave_id = i;
    topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].min_address = topEnvConfigHandle.peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[i].master_min_addr_range_array[i];
    topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].max_address = topEnvConfigHandle.peripheralEnvConfigHandle.axi4MasterAgentConfigHandle[i].master_max_addr_range_array[i];
    topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].maximum_transactions = 3;
    topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].read_data_mode = SLAVE_MEM_MODE;
    topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].slave_response_mode = RESP_IN_ORDER;
    topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].qos_mode_type = QOS_MODE_DISABLE;

    if(SLAVE_AGENT_ACTIVE === 1) begin
      topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].is_active = uvm_active_passive_enum'(UVM_ACTIVE);
    end
    else begin
      topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].is_active = uvm_active_passive_enum'(UVM_PASSIVE);
    end
    topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].has_coverage = 1;

    if(!(uvm_config_db #(virtual axi4_if) :: get(this , "" , $sformatf("axi4_if[%0d]",i),topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].vif)))begin
      `uvm_fatal("TEST","FAILED TO GET THE SLAVE AXI INTERFACE")
    end
  end
endfunction

function void dmaBaseTest::setupTriggerSlaveAgentConfig();
  topEnvConfigHandle.peripheralEnvConfigHandle.triggerSlaveAgentConfigHandle = new[axi4_globals_pkg::NO_OF_SLAVES+1];
  foreach(topEnvConfigHandle.peripheralEnvConfigHandle.triggerSlaveAgentConfigHandle[i]) begin
    topEnvConfigHandle.peripheralEnvConfigHandle.triggerSlaveAgentConfigHandle[i]= triggerSlaveAgentConfig :: type_id :: create($sformatf("triggerSlaveAgentConfigHandle[%0d]",i));
    topEnvConfigHandle.peripheralEnvConfigHandle.triggerSlaveAgentConfigHandle[i].is_active =UVM_PASSIVE;
    if(!(uvm_config_db #(virtual triggerInterface) :: get(this , "" , $sformatf("triggerInterface[%0d]",i),topEnvConfigHandle.peripheralEnvConfigHandle.triggerSlaveAgentConfigHandle[i].vif)))begin
      `uvm_fatal("TEST","FAILED TO GET THE SLAVE TRIGGER INTERFACE")
    end
  end
endfunction

function void dmaBaseTest::setupTriggerMasterAgentConfig();
  topEnvConfigHandle.peripheralEnvConfigHandle.triggerMasterAgentConfigHandle = new[axi4_globals_pkg::NO_OF_SLAVES+1];
  foreach(topEnvConfigHandle.peripheralEnvConfigHandle.triggerMasterAgentConfigHandle[i]) begin
    topEnvConfigHandle.peripheralEnvConfigHandle.triggerMasterAgentConfigHandle[i]= triggerMasterAgentConfig :: type_id :: create($sformatf("triggerMasterAgentConfigHandle[%0d]",i));
    topEnvConfigHandle.peripheralEnvConfigHandle.triggerMasterAgentConfigHandle[i].is_active =UVM_ACTIVE;
    if(!(uvm_config_db #(virtual triggerInterface) :: get(this , "" , $sformatf("triggerInterface[%0d]",i),topEnvConfigHandle.peripheralEnvConfigHandle.triggerMasterAgentConfigHandle[i].vif)))begin
      `uvm_fatal("TEST","FAILED TO GET THE MASTER TRIGGER INTERFACE")
    end
  end
endfunction

function void dmaBaseTest :: setupConfigUnitEnvConfig();
  topEnvConfigHandle.configUnitEnvConfigHandle = configUnitEnvConfig :: type_id :: create("configUnitEnvConfig");
  topEnvConfigHandle.configUnitEnvConfigHandle.hasVirtualSequencer = 1;
  setupApbMasterAgentConfig();
  setupInterruptSlaveAgentConfig();
  setupBootMasterAgentConfig();
endfunction

function void dmaBaseTest :: setupBootMasterAgentConfig();
  topEnvConfigHandle.configUnitEnvConfigHandle.bootMasterAgentConfigHandle = bootMasterAgentConfig :: type_id :: create("bootMasterAgentConfigHandle");
  topEnvConfigHandle.configUnitEnvConfigHandle.bootMasterAgentConfigHandle.is_active = UVM_ACTIVE;
  if(!(uvm_config_db #(virtual bootInterface) :: get(this,"","bootInterface",topEnvConfigHandle.configUnitEnvConfigHandle.bootMasterAgentConfigHandle.vif)) )begin
    `uvm_fatal("TEST","FAILED TO GET BOOT INTERFACE")
  end

endfunction
function void dmaBaseTest::setupApbMasterAgentConfig();
  bit [63:0]local_min_address;
  bit [63:0]local_max_address;

  topEnvConfigHandle.configUnitEnvConfigHandle.apbMasterAgentConfigHandle =apb_master_agent_config::type_id::create("apbMasterAgentConfigHandle");

  if(apb_global_pkg::MASTER_AGENT_ACTIVE === 1) begin
    topEnvConfigHandle.configUnitEnvConfigHandle.apbMasterAgentConfigHandle.is_active = uvm_active_passive_enum'(UVM_ACTIVE);
  end
  else begin
    topEnvConfigHandle.configUnitEnvConfigHandle.apbMasterAgentConfigHandle.is_active = uvm_active_passive_enum'(UVM_PASSIVE);
  end
  topEnvConfigHandle.configUnitEnvConfigHandle.apbMasterAgentConfigHandle.no_of_slaves = NO_OF_SLAVES;
  topEnvConfigHandle.configUnitEnvConfigHandle.apbMasterAgentConfigHandle.has_coverage = 1;
endfunction

function void dmaBaseTest::setupInterruptSlaveAgentConfig();
  topEnvConfigHandle.configUnitEnvConfigHandle.interruptSlaveAgentConfigHandle = interruptSlaveAgentConfig :: type_id :: create("interruptSlaveAgentConfigHandle");
  topEnvConfigHandle.configUnitEnvConfigHandle.interruptSlaveAgentConfigHandle.is_active = UVM_ACTIVE;
endfunction

function void dmaBaseTest::setUpCommand();
  foreach(topEnvConfigHandle.addressIfLinking[i,j]) begin
    automatic longint baseAddress = topEnvConfigHandle.addressIfLinking[i][j];
    for(int m=-1;m < noOfRegInChannel ;m++) begin  // 39 number of reg in channel
      for(int n=0; n<4 ; n++ ) begin
        if(m==-1) begin
          axi4_slave_memory :: mem_write(baseAddress++,'1); // header all reg by deafult is expected to change
          header = '1;
        end
        else if((m!= 0) && (m!=1)&& (m!=23) && (m!=25) &&(m!=27)) begin
          if(header[m]==1)begin
            axi4_slave_memory :: mem_write(baseAddress++,topEnvConfigHandle.allChannelConfig[i][j][(m*(32))+(8*n) +:8]);
          end
        end
      end
    end
  end
endfunction


function string dmaBaseTest::configuration_dump();

  automatic string raw_cfg;
  automatic string pretty_cfg;
  automatic string full_log = "";

  // --------------------------------------------------
  // Header
  // --------------------------------------------------
  full_log = { full_log, "================ CHANNEL CONFIG DUMP ================\n" };

  // --------------------------------------------------
  // Iterate channels
  // --------------------------------------------------
  foreach (topEnvConfigHandle.allChannelConfig[grp, ch]) begin
    raw_cfg = $sformatf("%p", topEnvConfigHandle.allChannelConfig[grp][ch]);
    pretty_cfg = format_struct(raw_cfg);  // vertical configured parameter display statement
    //pretty_cfg = format_struct_compact(raw_cfg);  // horizontal configured parameter display statement
    // allChannelConfig is declared [NUM_CHANNELS][], so grp is the channel and
    // ch is the command index within it. The labels used to be the other way round.
    full_log = { full_log, $sformatf("\n=========== CHANNEL %0d COMMAND %0d ===========\n",grp,ch) };
    full_log = { full_log, pretty_cfg,"\n"};
    full_log = { full_log, "===================================================\n" };
  end

  return full_log;

endfunction

function string dmaBaseTest::format_struct(string raw);

  automatic string result = "";
  automatic int indent = 0;
  automatic int skip_depth = 0;
  automatic bit skip_mode = 0;
  automatic string token = "";
  byte c;

  for (int i = 0; i < raw.len(); i++) begin
    c = raw[i];

    // -------------------------------------------------
    // Build token (field name detector)
    // -------------------------------------------------
    if (!skip_mode) begin
      if ((c >= "A" && c <= "Z") ||
      (c >= "a" && c <= "z") ||
      (c == "_") || (c >= "0" && c <= "9")) begin
        token = {token, c};
      end
      else begin
        // check token hit
        if (token == "CH_BUILDCFG0" ||
        token == "CH_BUILDCFG1") begin
          skip_mode  = 1;
          skip_depth = 0;
          token = "";
          continue;
        end
        token = "";
      end
    end

    // -------------------------------------------------
    // SKIP MODE (robust nested skip)
    // -------------------------------------------------
    if (skip_mode) begin
      if (c == "{")
        skip_depth++;
      else if (c == "}") begin
        skip_depth--;
        if (skip_depth <= 0) begin
          skip_mode = 0;
        end
      end
      continue;
    end

    // -------------------------------------------------
    // NORMAL PRETTY PRINT
    // -------------------------------------------------
    if (c == "{") begin
      indent++;
      result = {result, "{\n"};
      for (int j = 0; j < indent; j++)
        result = {result, "   "};
    end
    else if (c == "}") begin
      indent--;
      result = {result, "\n"};
      for (int j = 0; j < indent; j++)
        result = {result, "   "};
      result = {result, "}"};
    end
    else if (c == ",") begin
      result = {result, ",\n"};
      for (int j = 0; j < indent; j++)
        result = {result, "   "};
    end
    else begin
      result = {result, c};
    end
  end

  // ------------------------------------------------
  // Remove CH_BUILDCFG0 / CH_BUILDCFG1 safely
  // ------------------------------------------------

  // handle different spacing styles
  result = str_replace(result, "CH_BUILDCFG0,", "");
  result = str_replace(result, "CH_BUILDCFG1,", "");

  result = str_replace(result, "CH_BUILDCFG0 ,", "");
  result = str_replace(result, "CH_BUILDCFG1 ,", "");

  result = str_replace(result, "CH_BUILDCFG0", "");
  result = str_replace(result, "CH_BUILDCFG1", "");

  return result;

endfunction

function string dmaBaseTest::format_struct_compact(string raw);
  automatic string s;
  automatic string result = "";
  automatic int depth = 0;
  byte c;


  // --------------------------------------------------
  // STEP 1: Remove BUILDCFG entries
  // --------------------------------------------------
  s = raw;
  s = str_replace(s, "CH_BUILDCFG0,", "");
  s = str_replace(s, "CH_BUILDCFG1,", "");
  s = str_replace(s, "CH_BUILDCFG0", "");
  s = str_replace(s, "CH_BUILDCFG1", "");

  // --------------------------------------------------
  // STEP 2: Remove newlines/tabs from %p
  // --------------------------------------------------
  s = str_replace(s, "\n", " ");
  s = str_replace(s, "\t", " ");

  // --------------------------------------------------
  // STEP 3: Add newline after each top-level comma
  // --------------------------------------------------

  for (int i = 0; i < s.len(); i++) begin
    c = s[i];

    if (c == "{") depth++;
    if (c == "}") depth--;

    if (c == "," && depth == 1) begin
      result = {result, ",\n      "};
    end
    else begin
      result = {result, c};
    end
  end

  // --------------------------------------------------
  // STEP 4: spacing cleanup
  // --------------------------------------------------
  result = str_replace(result, "  ", " ");
  result = str_replace(result, " ,", ",");
  result = str_replace(result, "{ ", "{ ");
  result = str_replace(result, ", }", " }");

  return result;

endfunction

function string dmaBaseTest::str_replace(string src, string pat, string repl);

  automatic string out = "";
  automatic int i = 0;
  automatic int pat_len = pat.len();

  while (i < src.len()) begin
    if (i + pat_len <= src.len() && src.substr(i, i + pat_len - 1) == pat) begin
      out = {out, repl};
      i += pat_len;
    end
    else begin
      out = {out, src[i]};
      i++;
    end
  end
  return out;

endfunction

task dmaBaseTest::dump_config_to_file();

  automatic int fd;
  automatic string dump;
  automatic string fname;

  fname = {get_type_name(), ".txt"};

  dump = configuration_dump();

  fd = $fopen(fname, "w");

  if (fd == 0) begin
    `uvm_error(get_type_name(),
    $sformatf("ERROR: Could not open file %s!", fname))
  end
  else begin
    $fwrite(fd, "%s", dump);
    $fclose(fd);
  end

endtask

task dmaBaseTest::run_phase(uvm_phase phase);
  super.run_phase(phase);
endtask

`endif
