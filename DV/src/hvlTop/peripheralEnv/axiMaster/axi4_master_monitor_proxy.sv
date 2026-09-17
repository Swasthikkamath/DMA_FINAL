`ifndef AXI4_MASTER_MONITOR_PROXY_INCLUDED_
`define AXI4_MASTER_MONITOR_PROXY_INCLUDED_

class axi4_master_monitor_proxy extends uvm_component;
  `uvm_component_utils(axi4_master_monitor_proxy)

  axi4_master_agent_config axi4_master_agent_cfg_h;
  axi4_master_tx req_rd;
  axi4_master_tx req_wr;
  virtual axi4_if vif;

  uvm_analysis_port#(axi4_master_tx) axi4_master_read_address_analysis_port;
  uvm_analysis_port#(axi4_master_tx) axi4_master_read_data_analysis_port;
  uvm_analysis_port#(axi4_master_tx) axi4_master_write_address_analysis_port;
  uvm_analysis_port#(axi4_master_tx) axi4_master_write_data_analysis_port;
  uvm_analysis_port#(axi4_master_tx) axi4_master_write_response_analysis_port;

  uvm_tlm_analysis_fifo #(axi4_master_tx) axi4_master_write_address_fifo_h;
  uvm_tlm_analysis_fifo #(axi4_master_tx) axi4_master_write_data_fifo_h;
  uvm_tlm_analysis_fifo #(axi4_master_tx) axi4_master_read_fifo_h;

  extern function new(string name = "axi4_master_monitor_proxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task wait_for_aresetn();
  extern virtual task axi4_write_address();
  extern virtual task axi4_write_data();
  extern virtual task axi4_write_response();
  extern virtual task axi4_read_address();
  extern virtual task axi4_read_data();

endclass : axi4_master_monitor_proxy

function axi4_master_monitor_proxy::new(string name = "axi4_master_monitor_proxy",
                                 uvm_component parent = null);
  super.new(name, parent);
  axi4_master_read_address_analysis_port   = new("axi4_master_read_address_analysis_port",this);
  axi4_master_read_data_analysis_port      = new("axi4_master_read_data_analysis_port",this);
  axi4_master_write_address_analysis_port  = new("axi4_master_write_address_analysis_port",this);
  axi4_master_write_data_analysis_port     = new("axi4_master_write_data_analysis_port",this);
  axi4_master_write_response_analysis_port = new("axi4_master_write_response_analysis_port",this);
  axi4_master_write_address_fifo_h= new("axi4_master_write_address_fifo_h",this);
  axi4_master_write_data_fifo_h= new("axi4_master_write_data_fifo_h",this);
  axi4_master_read_fifo_h = new("axi4_master_read_fifo_h",this);
endfunction : new

function void axi4_master_monitor_proxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
  vif = axi4_master_agent_cfg_h.vif;
endfunction : build_phase

function void axi4_master_monitor_proxy::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

function void axi4_master_monitor_proxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
endfunction : end_of_elaboration_phase

task axi4_master_monitor_proxy::wait_for_aresetn();
  @(negedge vif.aresetn);
  `uvm_info(get_type_name(),$sformatf("SYSTEM RESET DETECTED"),UVM_HIGH)
  @(posedge vif.aresetn);
  `uvm_info(get_type_name(),$sformatf("SYSTEM RESET DEACTIVATED"),UVM_HIGH)
endtask

task axi4_master_monitor_proxy::run_phase(uvm_phase phase);
  wait_for_aresetn();
  fork
    axi4_write_address();
    axi4_write_data();
    axi4_write_response();
    axi4_read_address();
    axi4_read_data();
  join
endtask : run_phase

task axi4_master_monitor_proxy::axi4_write_address();
  forever begin
    axi4_master_tx req_wr_clone_packet;
    req_wr = axi4_master_tx::type_id::create("req_wr");
    @(vif.monCb);
    while(vif.monCb.awvalid!==1 || vif.monCb.awready!==1) begin
      @(vif.monCb);
    end
    req_wr.awid    = awid_e'(vif.monCb.awid);
    req_wr.awaddr  = vif.monCb.awaddr;
    req_wr.awlen   = vif.monCb.awlen;
    req_wr.awsize  = awsize_e'(vif.monCb.awsize);
    req_wr.awburst = awburst_e'(vif.monCb.awburst);
    req_wr.awlock  = awlock_e'(vif.monCb.awlock);
    req_wr.awcache = awcache_e'(vif.monCb.awcache);
    req_wr.awprot  = awprot_e'(vif.monCb.awprot);
    axi4_master_write_address_fifo_h.write(req_wr);
    $cast(req_wr_clone_packet,req_wr.clone());
    axi4_master_write_address_analysis_port.write(req_wr_clone_packet);
  end
endtask

task axi4_master_monitor_proxy::axi4_write_data();
  forever begin
    axi4_master_tx req_wr_clone_packet;
    req_wr = axi4_master_tx::type_id::create("req_wr");
    do begin
      @(vif.monCb);
    end while((vif.monCb.wvalid!==1 || vif.monCb.wready!==1));
    req_wr.wdata.delete();
    req_wr.wstrb.delete();
    req_wr.wdata.push_back(vif.monCb.wdata);
    req_wr.wstrb.push_back(vif.monCb.wstrb);
    req_wr.wuser = vif.monCb.wuser;
    req_wr.wlast = vif.monCb.wlast;
    axi4_master_write_data_fifo_h.write(req_wr);
    $cast(req_wr_clone_packet,req_wr.clone());
    axi4_master_write_data_analysis_port.write(req_wr_clone_packet);
  end
endtask

task axi4_master_monitor_proxy::axi4_write_response();
  forever begin
    axi4_master_tx master_tx_clone_packet;
    req_wr = axi4_master_tx::type_id::create("req_wr");
    do begin
      @(vif.monCb);
    end while((vif.monCb.bvalid!==1 || vif.monCb.bready!==1));
    req_wr.bid   = bid_e'(vif.monCb.bid);
    req_wr.bresp = bresp_e'(vif.monCb.bresp);
    $cast(master_tx_clone_packet,req_wr.clone());
    axi4_master_write_response_analysis_port.write(master_tx_clone_packet);
  end
endtask

task axi4_master_monitor_proxy::axi4_read_address();
  forever begin
    axi4_master_tx req_rd_clone_packet;
    req_rd = axi4_master_tx::type_id::create("req_rd");
    do begin
      @(vif.monCb);
    end while((vif.monCb.arvalid!==1 || vif.monCb.arready!==1));
    req_rd.arid     = arid_e'(vif.monCb.arid);
    req_rd.araddr   = vif.monCb.araddr;
    req_rd.arlen    = vif.monCb.arlen;
    req_rd.arsize   = arsize_e'(vif.monCb.arsize);
    req_rd.arburst  = arburst_e'(vif.monCb.arburst);
    req_rd.arlock   = arlock_e'(vif.monCb.arlock);
    req_rd.arcache  = arcache_e'(vif.monCb.arcache);
    req_rd.arprot   = arprot_e'(vif.monCb.arprot);
    req_rd.arqos    = vif.monCb.arqos;
    req_rd.arregion = vif.monCb.arregion[0];
    req_rd.aruser   = vif.monCb.aruser[0];
    axi4_master_read_fifo_h.write(req_rd);
    $cast(req_rd_clone_packet,req_rd.clone());
    axi4_master_read_address_analysis_port.write(req_rd_clone_packet);
  end
endtask

task axi4_master_monitor_proxy::axi4_read_data();
  forever begin
    axi4_master_tx req_rd_clone_packet;
    req_rd = axi4_master_tx::type_id::create("req_rd");
    do begin
      @(vif.monCb);
    end while((vif.monCb.rvalid!==1 || vif.monCb.rready!==1));
    req_rd.rid = rid_e'(vif.monCb.rid);
    req_rd.rdata.delete();
    req_rd.rdata.push_back(vif.monCb.rdata);
    req_rd.ruser = vif.monCb.ruser;
    req_rd.rresp = rresp_e'(vif.monCb.rresp);
    req_rd.rlast = vif.monCb.rlast;
    $cast(req_rd_clone_packet,req_rd.clone());
    axi4_master_read_data_analysis_port.write(req_rd_clone_packet);
  end
endtask

`endif
