`ifndef TOP_COVERAGE
`define TOP_COVERAGE

class topCoverage extends uvm_subscriber#(axi4_slave_tx);
  `uvm_component_utils(topCoverage)

  uvm_tlm_analysis_fifo#(apb_master_tx) coverageConfigUnitApbPathAnalysisExport;
  
   // Analysis  - AXI Slave Path
  axi4_slave_tx coveragePeripheralUnitAxi4SlavePathWriteAddressAnalysisExport[axi4_globals_pkg::NO_OF_SLAVES][$];
  uvm_tlm_analysis_fifo#(axi4_slave_tx) coveragePeripheralUnitAxi4SlavePathWriteDataAnalysisExport[axi4_globals_pkg::NO_OF_SLAVES];
  uvm_tlm_analysis_fifo#(axi4_slave_tx) coveragePeripheralUnitAxi4SlavePathWriteResponseAnalysisExport[axi4_globals_pkg::NO_OF_SLAVES];
  uvm_tlm_analysis_fifo#(axi4_slave_tx) coveragePeripheralUnitAxi4SlavePathReadAddressAnalysisExport[axi4_globals_pkg::NO_OF_SLAVES];
  uvm_tlm_analysis_fifo#(axi4_slave_tx) coveragePeripheralUnitAxi4SlavePathReadDataAnalysisExport[axi4_globals_pkg::NO_OF_SLAVES];
  
  uvm_tlm_analysis_fifo#(triggerSlaveTx) coveragePeripheralUnitTriggerSlavePathAnalysisExport[axi4_globals_pkg::NO_OF_SLAVES];
   // Analysis FIFOs - Trigger Path
  uvm_tlm_analysis_fifo#(triggerSlaveTx) coveragePeripheralUnitTriggerOutSlavePathAnalysisExport[axi4_globals_pkg::NO_OF_SLAVES];
  
  uvm_tlm_analysis_fifo#(interruptSlaveTx) coverageConfigUnitInterruptPathAnalysisExport;

  topEnvConfig topEnvConfigHandle;
  
  covergroup cg with function sample(apb_master_tx apbTx=null,axi4_slave_tx writeAddrTx=null,axi4_slave_tx writeDataTx=null,axi4_slave_tx writeRespTx=null,axi4_slave_tx readAddrTx=null,axi4_slave_tx readDataTx=null,triggerSlaveTx triggerTx=null,interruptSlaveTx interruptTx=null);
    coverpoint apbTx.paddr iff(apbTx != null){
      bins targetCh0 = {['h 100: 'h 1ff]}with (((item)%4==0 ));
      bins targetCh1 = {['h 200: 'h 2ff]}with (((item)%4==0 ));
      bins targetCh2= {['h 300: 'h 3ff]}with (((item)%4==0 ));
      bins targetCh3= {['h 400: 'h 4ff]}with (((item)%4==0 ));
      bins targetCh4 = {['h 500: 'h 5ff]}with (((item)%4==0 ));
      bins targetCh5 = {['h 600: 'h 6ff]}with (((item)%4==0 ));
      bins targetCh6 = {['h 700: 'h 7ff]}with (((item)%4==0 ));
      bins targetCh7 = {['h 800: 'h 8ff]}with (((item)%4==0 ));
    }

    LEGAL_ADDR: coverpoint apbTx.paddr iff(apbTx != null)
    {
      option.auto_bin_max = 2500; 
      bins addrApbFirstReg[] = {'h 100 ,'h 200,'h 300,'h 400,'h 500,'h 600,'h 700,'h 800};
      bins addrApbSecondReg[] = {'h 104 ,'h 204,'h 304,'h 404,'h 504,'h 604,'h 704,'h 804};
      bins addrApbThirdReg[] = {'h 108 ,'h 208,'h 308,'h 408,'h 508,'h 608,'h 708,'h 808};
      bins addrApbFourthReg[] = {'h 10c ,'h 20c,'h 30c,'h 40c,'h 50c,'h 60c,'h 70c,'h 80c};
      bins addrApbFifthReg[] = {'h 110 ,'h 210,'h 310,'h 410,'h 510,'h 610,'h 710,'h 810};
      bins addrApbSixthReg[] = {'h 114 ,'h 214,'h 314,'h 414,'h 514,'h 614,'h 714,'h 814};
      bins addrApbSeventhReg[] = {'h 118 ,'h 218,'h 318,'h 418,'h 518,'h 618,'h 718,'h 818};
      bins addrApbEighthReg[] = {'h 11c ,'h 21c,'h 31c,'h 41c,'h 51c,'h 61c,'h 71c,'h 81c};
      bins addrApbNinthReg[] = {'h 120 ,'h 220,'h 320,'h 420,'h 520,'h 620,'h 720,'h 820};
      bins addrApbTenthReg[] = {'h 124 ,'h 224,'h 324,'h 424,'h 524,'h 624,'h 724,'h 824};
      bins addrApbEleventhReg[] = {'h 128 ,'h 228,'h 328,'h 428,'h 528,'h 628,'h 728,'h 828};
      bins addrApbTwelfthReg[] = {'h 12c ,'h 22c,'h 32c,'h 42c,'h 52c,'h 62c,'h 72c,'h 82c};
      bins addrApbThirteenthReg[] = {'h 130 ,'h 230,'h 330,'h 430,'h 530,'h 630,'h 730,'h 830};
      bins addrApbFourteenthReg[] = {'h 134 ,'h 234,'h 334,'h 434,'h 534,'h 634,'h 734,'h 834};
      bins addrApbFifteenthReg[] = {'h 138 ,'h 238,'h 338,'h 438,'h 538,'h 638,'h 738,'h 838};
      bins addrApbSixteenthReg[] = {'h 13c,'h23c,'h33c,'h43c,'h53c,'h63c,'h73c,'h83c};
      bins addrApbSeventeenthReg[] = {'h 140,'h240,'h340,'h440,'h540,'h640,'h740,'h840};
      bins addrApbEighteenthReg[] = {'h 144,'h244,'h344,'h444,'h544,'h644,'h744,'h844};
      bins addrApbNineteenthReg[] = {'h 148,'h248,'h348,'h448,'h548,'h648,'h748,'h848};
      bins addrApbTwentiethReg[] = {'h 14c,'h24c,'h34c,'h44c,'h54c,'h64c,'h74c,'h84c};
      bins addrApbTwentyFirstReg[] = {'h 150,'h250,'h350,'h450,'h550,'h650,'h750,'h850};
      bins addrApbTwentySecondReg[] = {'h 154,'h254,'h354,'h454,'h554,'h654,'h754,'h854};
      bins addrApbTwentyThirdReg[] = {'h 158,'h258,'h358,'h458,'h558,'h658,'h758,'h858};
      bins addrApbTwentyFourthReg[] = {'h 15c,'h25c,'h35c,'h45c,'h55c,'h65c,'h75c,'h85c};
      bins addrApbTwentyFifthReg[] = {'h 160,'h260,'h360,'h460,'h560,'h660,'h760,'h860};
      bins addrApbTwentySixthReg[] = {'h 164,'h264,'h364,'h464,'h564,'h664,'h764,'h864};
      bins addrApbTwentySeventhReg[] = {'h 168,'h268,'h368,'h468,'h568,'h668,'h768,'h868};
      bins addrApbTwentyEighthReg[] = {'h 16c,'h26c,'h36c,'h46c,'h56c,'h66c,'h76c,'h86c};
      bins addrApbTwentyNinthReg[] = {'h 170,'h270,'h370,'h470,'h570,'h670,'h770,'h870};
      bins addrApbThirtiethReg[] = {'h 174,'h274,'h374,'h474,'h574,'h674,'h774,'h874};
      bins addrApbThirtyFirstReg[] = {'h 178,'h278,'h378,'h478,'h578,'h678,'h778,'h878};
      bins addrApbThirtySecondReg[] = {'h 17c,'h27c,'h37c,'h47c,'h57c,'h67c,'h77c,'h87c};
      bins addrApbThirtyThirdReg[] = {'h 180,'h280,'h380,'h480,'h580,'h680,'h780,'h880};
      bins addrApbThirtyFourthReg[] = {'h 184,'h284,'h384,'h484,'h584,'h684,'h784,'h884};
      bins addrApbThirtyFifthReg[] = {'h 188,'h288,'h388,'h488,'h588,'h688,'h788,'h888};
      bins addrApbThirtySixthReg[] = {'h 18c,'h28c,'h38c,'h48c,'h58c,'h68c,'h78c,'h88c};
      bins addrApbThirtySeventhReg[] = {'h 190,'h290,'h390,'h490,'h590,'h690,'h790,'h890};
      bins addrApbThirtyEighthReg[] = {'h 194,'h294,'h394,'h494,'h594,'h694,'h794,'h894};
      bins addrApbThirtyNinthReg[] = {'h 198,'h298,'h398,'h498,'h598,'h698,'h798,'h898};
      bins addrApbFortiethReg[] = {'h 19c,'h29c,'h39c,'h49c,'h59c,'h69c,'h79c,'h89c};
      bins addrApbFortyFirstReg[] = {'h 1a0,'h2a0,'h3a0,'h4a0,'h5a0,'h6a0,'h7a0,'h8a0};
      bins addrApbFortySecondReg[] = {'h 1a4,'h2a4,'h3a4,'h4a4,'h5a4,'h6a4,'h7a4,'h8a4};
      bins addrApbFortyThirdReg[] = {'h 1a8,'h2a8,'h3a8,'h4a8,'h5a8,'h6a8,'h7a8,'h8a8};
      bins addrApbFortyFourthReg[] = {'h 1ac,'h2ac,'h3ac,'h4ac,'h5ac,'h6ac,'h7ac,'h8ac};
      bins addrApbFortyFifthReg[] = {'h 1b0,'h2b0,'h3b0,'h4b0,'h5b0,'h6b0,'h7b0,'h8b0};
      bins addrApbFortySixthReg[] = {'h 1b4,'h2b4,'h3b4,'h4b4,'h5b4,'h6b4,'h7b4,'h8b4};
      bins addrApbFortySeventhReg[] = {'h 1b8,'h2b8,'h3b8,'h4b8,'h5b8,'h6b8,'h7b8,'h8b8};
      bins addrApbFortyEighthReg[] = {'h 1bc,'h2bc,'h3bc,'h4bc,'h5bc,'h6bc,'h7bc,'h8bc};
      bins addrApbFortyNinthReg[] = {'h 1c0,'h2c0,'h3c0,'h4c0,'h5c0,'h6c0,'h7c0,'h8c0};
      bins addrApbFiftiethReg[] = {'h 1c4,'h2c4,'h3c4,'h4c4,'h5c4,'h6c4,'h7c4,'h8c4};
      bins addrApbFiftyFirstReg[] = {'h 1c8,'h2c8,'h3c8,'h4c8,'h5c8,'h6c8,'h7c8,'h8c8};
      bins addrApbFiftySecondReg[] = {'h 1cc,'h2cc,'h3cc,'h4cc,'h5cc,'h6cc,'h7cc,'h8cc};
      bins addrApbFiftyThirdReg[] = {'h 1d0,'h2d0,'h3d0,'h4d0,'h5d0,'h6d0,'h7d0,'h8d0};
      bins addrApbFiftyFourthReg[] = {'h 1d4,'h2d4,'h3d4,'h4d4,'h5d4,'h6d4,'h7d4,'h8d4};
      bins addrApbFiftyFifthReg[] = {'h 1d8,'h2d8,'h3d8,'h4d8,'h5d8,'h6d8,'h7d8,'h8d8};
      bins addrApbFiftySixthReg[] = {'h 1dc,'h2dc,'h3dc,'h4dc,'h5dc,'h6dc,'h7dc,'h8dc};
      bins addrApbFiftySeventhReg[] = {'h 1e0,'h2e0,'h3e0,'h4e0,'h5e0,'h6e0,'h7e0,'h8e0};
      bins addrApbFiftyEighthReg[] = {'h 1e4,'h2e4,'h3e4,'h4e4,'h5e4,'h6e4,'h7e4,'h8e4};
      bins addrApbFiftyNinthReg[] = {'h 1e8,'h2e8,'h3e8,'h4e8,'h5e8,'h6e8,'h7e8,'h8e8};
      bins addrApbSixtiethReg[] = {'h 1ec,'h2ec,'h3ec,'h4ec,'h5ec,'h6ec,'h7ec,'h8ec};
      bins addrApbSixtyFirstReg[] = {'h 1f0,'h2f0,'h3f0,'h4f0,'h5f0,'h6f0,'h7f0,'h8f0};
      bins addrApbSixtySecondReg[] = {'h 1f4,'h2f4,'h3f4,'h4f4,'h5f4,'h6f4,'h7f4,'h8f4};
      bins addrApbSixtyThirdReg[] = {'h 1f8,'h2f8,'h3f8,'h4f8,'h5f8,'h6f8,'h7f8,'h8f8}; 
      bins addrApbSixtyFourthReg[] = {'h 1fc,'h2fc,'h3fc,'h4fc,'h5fc,'h6fc,'h7fc,'h8fc}; 
     }


  // data legal for each of the registers and then cross first adddress reg with legal data 

    LEGAL_VAL:coverpoint  apbTx.pwdata iff(apbTx !=null) {
      bins legalFirstRegval = {[0:$]} with((!(|item[15:6])) && (!(|item[31:25]))&& (item[23]==0) && (item[19]==0));
     
      bins legalSecondRegval = {[0:$]} with ((!(|item[31:27]) )&& (!(|item[23:22])) && (!(|item[15:11])) && (!(|item[7:4])));


      bins legalThirdRegval = {[0:$]} with ((!(|item[31:11]) )&&(!(|item[7:4])));

      bins legalFourthRegval ={[0:'h ffffffff]} with ((!(|item[31:30]) )&& (!(|item[17:15])) && (!(|item[8])) && (!(|item[3])));


      bins allLegalVal ={[0:$]}; //5 to 11 ,13,14,15,16,18,19,23,24,29,30,32,34

    
      bins legalEleventhRegVal = {[0:$]} with ((!(|item[31:20]) )&& (!(|item[15:12]))); //11
     
      bins legalTwelfthRegVal ={[0:$]}with ((!(|item[31:20]) )&& (!(|item[15:12]))); //12

      bins legalSeventeenthRegVal ={[0:$]} with((!(|item[31:21]) )&& (!(|item[15 :13])) && (!(|item[7:0]))); //17

      bins legalTwentiethRegVal ={[0:$]}with ((!(|item[31:24]) )&& (!(|item[15:12]))); //
      
      bins legalTwentyOneRegVal ={[0:$]}with ((!(|item[31:24]) )&& (!(|item[15:12])));

      bins legalTwentyTwoRegVal={[0:$]} with ((!(|item[31:10]) ));

      bins legalTwentyFiveRegVal ={[0:$]} with ((!(|item[31:11]) )&& (!(|item[8:0])));
      bins legalTwentySixRegVal ={[0:$]} with ((!(|item[31:10]) ));

      bins legalTwentySevenRegVal = {[0:$]} with ((!(|item[31:17])));

      bins legalTwentyEigthRegVal ={[0:$]}with ((!(|item[1])));

      bins legalThirtyOneRegVal ={[0:$]}with ((!(|item[31:4])));

      bins legalThirtyThreeRegVal={[0:$]} with((!(|item[15:8])) && (!(|item[6:5])));

      bins legalThirtyFiveRegVal ={[0:$]}with ((!(|item[31:8]) ));

      bins legalThirtySixRegVal ={[0:$]}with (!(|item[31:3]) );

      bins legalThirtySevenRegVal ={[0:$]}with((!(|item[31:30])) && (!(|item[25])));

      bins legalThirtyEigthRegVal={[0:$]} with((!(|item[31:26])) && (!(|item[17:13])));
   }

    cross LEGAL_ADDR,LEGAL_VAL{
      bins legalRegOne =binsof(LEGAL_ADDR.addrApbFirstReg) && binsof(LEGAL_VAL.legalFirstRegval);
      bins legalRegTwo = binsof(LEGAL_ADDR.addrApbSecondReg) && binsof(LEGAL_VAL.legalSecondRegval);
      bins legalRegThree = binsof(LEGAL_ADDR.addrApbThirdReg) && binsof(LEGAL_VAL.legalThirdRegval);
      bins legalRegFour = binsof(LEGAL_ADDR.addrApbFourthReg) && binsof(LEGAL_VAL.legalFourthRegval);
      bins legalRegFive = binsof(LEGAL_ADDR.addrApbFifthReg) && binsof(LEGAL_VAL.allLegalVal);
      bins legalRegSix = binsof(LEGAL_ADDR.addrApbSixthReg) && binsof(LEGAL_VAL.allLegalVal);
      bins legalRegSeven = binsof(LEGAL_ADDR.addrApbSeventhReg) && binsof(LEGAL_VAL.allLegalVal);
      bins legalRegEight = binsof(LEGAL_ADDR.addrApbEighthReg) && binsof(LEGAL_VAL.allLegalVal);
      bins legalRegNine = binsof(LEGAL_ADDR.addrApbNinthReg) && binsof(LEGAL_VAL.allLegalVal);
      bins legalRegTen = binsof(LEGAL_ADDR.addrApbTenthReg) && binsof(LEGAL_VAL.allLegalVal);
      bins legalRegEleven = binsof(LEGAL_ADDR.addrApbEleventhReg) && binsof(LEGAL_VAL.legalEleventhRegVal);
      bins legalRegTwelve = binsof(LEGAL_ADDR.addrApbTwelfthReg) && binsof(LEGAL_VAL.legalTwelfthRegVal);
      bins legalRegThirteen = binsof(LEGAL_ADDR.addrApbThirteenthReg) && binsof(LEGAL_VAL.allLegalVal);
      bins legalRegFourteen = binsof(LEGAL_ADDR.addrApbFourteenthReg) && binsof(LEGAL_VAL.allLegalVal);
      bins legalRegFifteen = binsof(LEGAL_ADDR.addrApbFifteenthReg) && binsof(LEGAL_VAL.allLegalVal);
      bins legalRegSixteen = binsof(LEGAL_ADDR.addrApbSixteenthReg) && binsof(LEGAL_VAL.allLegalVal);
      bins legalRegSeventeen = binsof(LEGAL_ADDR.addrApbSeventeenthReg) && binsof(LEGAL_VAL.legalSeventeenthRegVal);
      bins legalRegEighteen = binsof(LEGAL_ADDR.addrApbEighteenthReg) && binsof(LEGAL_VAL.allLegalVal);
      bins legalRegNineteen = binsof(LEGAL_ADDR.addrApbNineteenthReg) && binsof(LEGAL_VAL.allLegalVal);
      bins legalRegTwenty = binsof(LEGAL_ADDR.addrApbTwentiethReg) && binsof(LEGAL_VAL.legalTwentiethRegVal);
      bins legalRegTwentyOne = binsof(LEGAL_ADDR.addrApbTwentyFirstReg) && binsof(LEGAL_VAL.legalTwentyOneRegVal);
      bins legalRegTwentyTwo = binsof(LEGAL_ADDR.addrApbTwentySecondReg) && binsof(LEGAL_VAL.legalTwentyTwoRegVal);
      bins legalRegTwentyThree = binsof(LEGAL_ADDR.addrApbTwentyThirdReg) && binsof(LEGAL_VAL.allLegalVal);
      bins legalRegTwentyFour = binsof(LEGAL_ADDR.addrApbTwentyFifthReg) && binsof(LEGAL_VAL.allLegalVal);
      bins legalRegTwentyFive = binsof(LEGAL_ADDR.addrApbTwentySeventhReg) && binsof(LEGAL_VAL.legalTwentyFiveRegVal);
      bins legalRegTwentySix = binsof(LEGAL_ADDR.addrApbTwentyNinthReg) && binsof(LEGAL_VAL.legalTwentySixRegVal);
      bins legalRegTwentySeven = binsof(LEGAL_ADDR.addrApbThirtiethReg) && binsof(LEGAL_VAL.legalTwentySevenRegVal);
      bins legalRegTwentyEight = binsof(LEGAL_ADDR.addrApbThirtyFirstReg) && binsof(LEGAL_VAL.legalTwentyEigthRegVal);
      bins legalRegTwentyNine = binsof(LEGAL_ADDR.addrApbThirtySecondReg) && binsof(LEGAL_VAL.allLegalVal);
      bins legalRegThirty = binsof(LEGAL_ADDR.addrApbThirtyThirdReg) && binsof(LEGAL_VAL.allLegalVal);
      bins legalRegThirtyOne= binsof(LEGAL_ADDR.addrApbThirtyFifthReg) && binsof(LEGAL_VAL.legalThirtyOneRegVal);
      bins legalRegThirtyTwo = binsof(LEGAL_ADDR.addrApbThirtySixthReg) && binsof(LEGAL_VAL.allLegalVal);
      bins legalRegThirtyThree= binsof(LEGAL_ADDR.addrApbThirtySeventhReg) && binsof(LEGAL_VAL.legalThirtyThreeRegVal);
      bins legalRegThirtyFour = binsof(LEGAL_ADDR.addrApbFiftyFirstReg) && binsof(LEGAL_VAL.allLegalVal);
      bins legalRegThirtyFive= binsof(LEGAL_ADDR.addrApbFiftySecondReg) && binsof(LEGAL_VAL.legalTwentyFiveRegVal);
      bins legalRegThirtySix = binsof(LEGAL_ADDR.addrApbFiftyNinthReg) && binsof(LEGAL_VAL.legalThirtySixRegVal);
      bins legalRegThirtySeven = binsof(LEGAL_ADDR.addrApbSixtyThirdReg) && binsof(LEGAL_VAL.legalThirtySevenRegVal);
      bins legalRegThirtyEight = binsof(LEGAL_ADDR.addrApbSixtyFourthReg) && binsof(LEGAL_VAL.legalThirtyEigthRegVal);
    }


    coverpoint addressDecodeForSlave(writeAddrTx.awaddr)iff(writeAddrTx!=null){ //need to look any generic way
      bins destinationSlaveTargeted[] = {[0:NO_OF_SLAVES-1]}; //based on function return val we can increment the counter of finite slave bin
    }

    coverpoint writeAddrTx.awid iff(writeAddrTx!=null){
      bins channelInitiatedWrite[] = {[0:NUM_CHANNELS-1]};
    }

    coverpoint writeAddrTx.awburst iff(writeAddrTx !=null){
      bins burst0 = {0};
      bins burst1 = {0};
      illegal_bins burst23 = {2,3};
    }

    coverpoint writeAddrTx.awlen iff(writeAddrTx !=null){
      bins lowLen = {[0:100]};
      bins mediumLen = {[101:200]};
      bins highLen = {[201:255]}; //burst can be 0 to 255 (awburst 1 is legal so)
    }
    
    coverpoint addressDecodeForSlave(readAddrTx.araddr)iff(readAddrTx!=null){ //need to look any generic way
      bins sourceSlaveTargeted[] = {[0:NO_OF_SLAVES-1]}; //based on function return val we can increment the counter of finite slave bin
    }

    coverpoint readAddrTx.arid iff(readAddrTx!=null){
      bins channelInitiatedRead[] = {[0:NUM_CHANNELS-1]};
    }

    coverpoint readAddrTx.arburst iff(readAddrTx !=null){
      bins burst0 = {0};
      bins burst1 = {0};
      illegal_bins burst23 = {2,3};
    }

    coverpoint readAddrTx.arlen iff(readAddrTx !=null){
      bins lowLen = {[0:100]};
      bins mediumLen = {[101:200]};
      bins highLen = {[201:255]}; //burst can be 0 to 255 (awburst 1 is legal so)
    }
    
  endgroup
 

  extern function new(string name = "topCoverage",uvm_component parent=null);
  extern virtual function void  build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern function int addressDecodeForSlave(bit[31:0] addr);
  extern function int decodeTheChannelTask(apb_master_tx tx);
  extern function void write(axi4_slave_tx t);
endclass


function void topCoverage::write(axi4_slave_tx t);
  int slaveId;
  slaveId = addressDecodeForSlave(t.awaddr);
  coveragePeripheralUnitAxi4SlavePathWriteAddressAnalysisExport[slaveId].push_back(t);
endfunction

function int topCoverage::decodeTheChannelTask(apb_master_tx tx);
  for (int i = 0; i < dmaGlobalPkg::NUM_CHANNELS; i++) begin
    if (tx.paddr >= ('h100 + ('h100 * (i))) && (tx.paddr < ('h100 + ('h100 * (i + 1))))) begin
      return i ;
    end
  end
  return -1;
endfunction

task topCoverage::run_phase(uvm_phase phase);
  super.run_phase(phase);
  
  for(int i=0;i<axi4_globals_pkg::NO_OF_SLAVES;i++)begin 
    automatic int j = i;
    fork
      begin 
        forever begin 
         axi4_slave_tx tx1;
         wait(coveragePeripheralUnitAxi4SlavePathWriteAddressAnalysisExport[j].size()>0)
          tx1 = coveragePeripheralUnitAxi4SlavePathWriteAddressAnalysisExport[j].pop_front();
        end 
      end  

      begin 
        forever begin
          axi4_slave_tx tx2;
          coveragePeripheralUnitAxi4SlavePathWriteDataAnalysisExport[j].get(tx2); 
        end 
      end

      begin 
        forever begin 
          axi4_slave_tx tx3;
          coveragePeripheralUnitAxi4SlavePathWriteResponseAnalysisExport[j].get(tx3);
        end 
      end

      begin 
        forever begin 
          axi4_slave_tx tx4;
          coveragePeripheralUnitAxi4SlavePathReadAddressAnalysisExport[j].get(tx4);   
        end 
      end

      begin 
        forever begin 
          axi4_slave_tx tx5;
          coveragePeripheralUnitAxi4SlavePathReadDataAnalysisExport[j].get(tx5);
        end 
      end

      begin 
        forever begin 
          triggerSlaveTx tx1;
          coveragePeripheralUnitTriggerSlavePathAnalysisExport[j].get(tx1);
        end 
      end

      begin
        forever begin 
          triggerSlaveTx tx2;
          coveragePeripheralUnitTriggerOutSlavePathAnalysisExport[j].get(tx2);
        end
      end 
    join_none
  end  
  
  wait fork;
endtask

function topCoverage::new(string name="topCoverage",uvm_component parent=null);
   super.new(name,parent);
  cg =new();
endfunction 

function int topCoverage :: addressDecodeForSlave(bit[31:0] addr);
  for(int i=0;i<axi4_globals_pkg::NO_OF_SLAVES;i++)begin 
    if(addr inside {[topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].min_address : topEnvConfigHandle.peripheralEnvConfigHandle.axi4SlaveAgentConfigHandle[i].max_address]})
      return i;
  end
endfunction 

function void  topCoverage::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!(uvm_config_db #(topEnvConfig) :: get(this,"","topEnvConfigHandle",topEnvConfigHandle)))begin 
    `uvm_fatal("TOP_COVERAGE","COULDNT GET TOP ENV COVERAGE")
  end 
  coverageConfigUnitApbPathAnalysisExport = new("coverageConfigUnitApbPathAnalysisExport",this);
  coverageConfigUnitInterruptPathAnalysisExport = new("coverageConfigUnitInterruptPathAnalysisExport",this);
  for(int i=0;i<axi4_globals_pkg::NO_OF_SLAVES;i++)begin 
    coveragePeripheralUnitAxi4SlavePathWriteAddressAnalysisExport[i] = new[1];
    coveragePeripheralUnitAxi4SlavePathWriteDataAnalysisExport[i] = new($sformatf("coveragePeripheralUnitAxi4SlavePathWriteDataAnalysisExport[%0d]",i),this);
    coveragePeripheralUnitAxi4SlavePathWriteResponseAnalysisExport[i] = new($sformatf("coveragePeripheralUnitAxi4SlavePathWriteResponseAnalysisExport[%0d]",i),this);
    coveragePeripheralUnitAxi4SlavePathReadAddressAnalysisExport[i] = new($sformatf("coveragePeripheralUnitAxi4SlavePathReadAddressAnalysisExport",i),this);
    coveragePeripheralUnitAxi4SlavePathReadDataAnalysisExport[i] = new($sformatf("coveragePeripheralUnitAxi4SlavePathReadDataAnalysisExport",i),this);
    coveragePeripheralUnitTriggerSlavePathAnalysisExport[i] = new($sformatf("coveragePeripheralUnitTriggerSlavePathAnalysisExport",i),this);
    coveragePeripheralUnitTriggerOutSlavePathAnalysisExport[i] = new($sformatf("coveragePeripheralUnitTriggerOutSlavePathAnalysisExport",i),this);
  end 
endfunction
`endif
