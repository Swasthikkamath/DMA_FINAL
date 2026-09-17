`ifndef APB_MASTER_DRIVER_PROXY_INCLUDED_
`define APB_MASTER_DRIVER_PROXY_INCLUDED_

class apb_master_driver_proxy extends uvm_driver #(apb_master_tx);
  `uvm_component_utils(apb_master_driver_proxy)

  apb_master_tx apb_master_tx_h;
  virtual apb_if vif;
  apb_master_agent_config apb_master_agent_cfg_h;

  extern function new(string name = "apb_master_driver_proxy", uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task wait_for_preset_n();
  extern virtual task drive_outputs_low();
  extern virtual task drive_idle_state();
  extern virtual task drive_transaction(apb_master_tx req);

endclass : apb_master_driver_proxy

function apb_master_driver_proxy::new(string name = "apb_master_driver_proxy",uvm_component parent);
  super.new(name, parent);
endfunction : new

function void apb_master_driver_proxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(virtual apb_if)::get(this,"","apb_if", vif)) begin
    `uvm_fatal("FATAL_MDP_CANNOT_GET_APB_IF","cannot get() apb_if");
  end
endfunction : build_phase

function void apb_master_driver_proxy::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

function void apb_master_driver_proxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
endfunction : end_of_elaboration_phase

task apb_master_driver_proxy::wait_for_preset_n();
  @(negedge vif.preset_n);
  `uvm_info(get_type_name(), $sformatf("SYSTEM RESET DETECTED"), UVM_HIGH)
  @(posedge vif.preset_n);
  `uvm_info(get_type_name(), $sformatf("SYSTEM RESET DEACTIVATED"), UVM_HIGH)
endtask

task apb_master_driver_proxy::drive_outputs_low();
  vif.psel    = 1'b0;
  vif.penable = 1'b0;
  vif.paddr   = '0;
  vif.pwrite  = 1'b0;
  vif.pstrb   = '0;
  vif.pwdata  = '0;
  vif.pprot   = '0;
endtask

task apb_master_driver_proxy::drive_idle_state();
  drive_outputs_low();
  @(vif.masterDrvCb);
  vif.masterDrvCb.psel    <= 1'b0;
  vif.masterDrvCb.penable <= 1'b0;
  vif.masterDrvCb.paddr   <= '0;
  vif.masterDrvCb.pwrite  <= 1'b0;
  vif.masterDrvCb.pstrb   <= '0;
  vif.masterDrvCb.pwdata  <= '0;
  vif.masterDrvCb.pprot   <= '0;
endtask

task apb_master_driver_proxy::drive_transaction(apb_master_tx req);
  vif.masterDrvCb.psel    <= 1'b1;
  vif.masterDrvCb.penable <= 1'b0;
  vif.masterDrvCb.paddr   <= req.paddr;
  vif.masterDrvCb.pwrite  <= req.pwrite;
  vif.masterDrvCb.pprot   <= req.pprot;
  if(req.pwrite == WRITE) begin
    vif.masterDrvCb.pwdata <= req.pwdata;
    vif.masterDrvCb.pstrb  <= req.pstrb;
  end
  else begin
    vif.masterDrvCb.pstrb <= '0;
  end

  @(vif.masterDrvCb);
  vif.masterDrvCb.penable <= 1'b1;

  @(vif.masterDrvCb);
  req.no_of_wait_states_detected = 0;
  while(vif.masterDrvCb.pready == 0) begin
    @(vif.masterDrvCb);
    req.no_of_wait_states_detected++;
  end
  req.pslverr = slave_error_e'(vif.masterDrvCb.pslverr);
  req.prdata  = vif.masterDrvCb.prdata;

  vif.masterDrvCb.penable <= 1'b0;
  vif.masterDrvCb.psel    <= 1'b0;
  @(vif.masterDrvCb);
endtask

task apb_master_driver_proxy::run_phase(uvm_phase phase);
  drive_outputs_low();
  wait_for_preset_n();
  drive_idle_state();

  forever begin
    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name(), $sformatf("REQ-MASTER_TX \n %s",req.sprint),UVM_DEBUG);
    drive_transaction(req);
    `uvm_info(get_type_name(), $sformatf("AFTER :: received req packet \n %s", req.sprint()), UVM_DEBUG);
    seq_item_port.item_done(req);
  end
endtask : run_phase

`endif
