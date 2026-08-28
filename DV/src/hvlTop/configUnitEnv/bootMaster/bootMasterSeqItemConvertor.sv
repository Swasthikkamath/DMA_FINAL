`ifndef BOOT_MASTER_SEQ_ITEM_CONVERTER_INCLUDED
`define BOOT_MASTER_SEQ_ITEM_CONVERTER_INCLUDED

  class bootMasterSeqItemConverter;

    extern function new(string name="bootMasterSeqItemConverter");

    extern static function fromClass(input bootMasterTx bootMasterTxHandle,output bootStructPacket bootStructPacketHandle);

    extern static function toClass(input bootStructPacket bootStructPacketHandle,inout bootMasterTx bootMasterTxHandle);

  endclass

  function bootMasterSeqItemConverter :: new(string name="bootMasterSeqItemConverter");
    super.new(name);
  endfunction 

  function bootMasterSeqItemConverter :: fromClass(input bootMasterTx bootMasterTxHandle,output bootStructPacket bootStructPacketHandle);
    bootStructPacketHandle.bootEn = bootMasterTxHandle.bootEn;
    bootStructPacketHandle.bootAddr = bootMasterTxHandle.bootAddr;

  endfunction 

  function bootMasterSeqItemConverter :: toClass(input bootStructPacket bootStructPacketHandle,inout bootMasterTx bootMasterTxHandle);
    bootMasterTxHandle.bootEn = bootStructPacketHandle.bootEn;
    bootMasterTxHandle.bootAddr = bootStructPacketHandle.bootAddr;
  endfunction 
`endif    
