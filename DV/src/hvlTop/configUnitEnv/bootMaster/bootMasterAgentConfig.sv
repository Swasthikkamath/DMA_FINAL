`ifndef BOOT_MASTER_AGENT_CONFIG
`define BOOT_MASTER_AGENT_CONFIG
  class bootMasterAgentConfig extends uvm_object;
    `uvm_object_utils(bootMasterAgentConfig)


    extern function new(string name="bootMasterAgentConfig");
   
    virtual bootInterface vif;

    uvm_active_passive_enum is_active;
   
 endclass

 function bootMasterAgentConfig :: new(string name="bootMasterAgentConfig");
   super.new(name);
 endfunction 

`endif
