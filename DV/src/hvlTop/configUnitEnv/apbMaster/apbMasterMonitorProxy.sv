`ifndef APB_MASTER_MONITOR_PROXY_INCLUDED_
`define APB_MASTER_MONITOR_PROXY_INCLUDED_

class apb_master_monitor_proxy extends uvm_monitor;
  `uvm_component_utils(apb_master_monitor_proxy)

  virtual apb_if vif;
  apb_master_agent_config apb_master_agent_cfg_h;
  uvm_analysis_port#(apb_master_tx) apb_master_analysis_port;

  extern function new(string name = "apb_master_monitor_proxy", uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task sample_transaction(apb_master_tx tx);

endclass : apb_master_monitor_proxy

function apb_master_monitor_proxy::new(string name = "apb_master_monitor_proxy",uvm_component parent);
  super.new(name, parent);
  apb_master_analysis_port = new("apb_master_analysis_port",this);
endfunction : new

function void apb_master_monitor_proxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(virtual apb_if)::get(this,"","apb_if", vif)) begin
    `uvm_fatal("FATAL_MDP_CANNOT_GET_APB_IF","cannot get() apb_if");
  end
endfunction : build_phase

function void apb_master_monitor_proxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
endfunction : end_of_elaboration_phase

task apb_master_monitor_proxy::sample_transaction(apb_master_tx tx);
  @(vif.monCb);
  while(vif.monCb.psel != 1'b1 || vif.monCb.pready != 1'b1) begin
    @(vif.monCb);
  end

  tx.psel    = vif.monCb.psel;
  tx.pslverr = slave_error_e'(vif.monCb.pslverr);
  tx.pprot   = protection_type_e'(vif.monCb.pprot);
  tx.pwrite  = tx_type_e'(vif.monCb.pwrite);
  tx.paddr   = vif.monCb.paddr;
  tx.pstrb   = vif.monCb.pstrb;
  tx.pready  = vif.monCb.pready;
  tx.penable = vif.monCb.penable;
  if(tx.pwrite == WRITE)
    tx.pwdata = vif.monCb.pwdata;
  else
    tx.prdata = vif.monCb.prdata;
endtask

task apb_master_monitor_proxy::run_phase(uvm_phase phase);
  apb_master_tx apb_master_packet;
  `uvm_info(get_type_name(), $sformatf("Inside the master_monitor_proxy"), UVM_DEBUG);
  apb_master_packet = apb_master_tx::type_id::create("master_packet");

  forever begin
    apb_master_tx apb_master_clone_packet;
    sample_transaction(apb_master_packet);
    `uvm_info(get_type_name(),$sformatf("Received packet from master monitor: , \n %s", apb_master_packet.sprint()),UVM_DEBUG)
    $cast(apb_master_clone_packet, apb_master_packet.clone());
    apb_master_analysis_port.write(apb_master_clone_packet);
  end
endtask : run_phase

`endif
