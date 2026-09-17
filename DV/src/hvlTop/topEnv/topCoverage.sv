`ifndef TOP_COVERAGE
`define TOP_COVERAGE
 
class topCoverage extends uvm_subscriber#(axi4_slave_tx);
  `uvm_component_utils(topCoverage)
 
  uvm_tlm_analysis_fifo#(apb_master_tx) coverageConfigUnitApbPathAnalysisExport;
   // Analysis  - AXI Slave Path
  axi4_slave_tx coveragePeripheralUnitAxi4SlavePathWriteAddressAnalysisExport[axi4_globals_pkg::NO_OF_SLAVES+1][$];
  uvm_tlm_analysis_fifo#(axi4_slave_tx) coveragePeripheralUnitAxi4SlavePathWriteDataAnalysisExport[axi4_globals_pkg::NO_OF_SLAVES+1];
  uvm_tlm_analysis_fifo#(axi4_slave_tx) coveragePeripheralUnitAxi4SlavePathWriteResponseAnalysisExport[axi4_globals_pkg::NO_OF_SLAVES+1];
  uvm_tlm_analysis_fifo#(axi4_slave_tx) coveragePeripheralUnitAxi4SlavePathReadAddressAnalysisExport[axi4_globals_pkg::NO_OF_SLAVES+1];
  uvm_tlm_analysis_fifo#(axi4_slave_tx) coveragePeripheralUnitAxi4SlavePathReadDataAnalysisExport[axi4_globals_pkg::NO_OF_SLAVES+1];
  uvm_tlm_analysis_fifo#(triggerSlaveTx) coveragePeripheralUnitTriggerSlavePathAnalysisExport[axi4_globals_pkg::NO_OF_SLAVES+1];
   // Analysis FIFOs - Trigger Path
  uvm_tlm_analysis_fifo#(triggerSlaveTx) coveragePeripheralUnitTriggerOutSlavePathAnalysisExport[axi4_globals_pkg::NO_OF_SLAVES+1];
  uvm_tlm_analysis_fifo#(interruptSlaveTx) coverageConfigUnitInterruptPathAnalysisExport;
 
  topEnvConfig topEnvConfigHandle;
  covergroup cg with function sample(apb_master_tx apbTx=null,axi4_slave_tx writeAddrTx=null,axi4_slave_tx writeDataTx=null,axi4_slave_tx writeRespTx=null,axi4_slave_tx readAddrTx=null,axi4_slave_tx readDataTx=null,triggerSlaveTx triggerTx=null,interruptSlaveTx interruptTx=null);
    coverpoint decodeTheChannelTask(apbTx) iff(apbTx != null){
      bins targetCh0 = {0};
      bins targetCh1 = {1};
     /* bins targetCh2= {['h 300: 'h 3ff]}with (((item)%4==0 ));
      bins targetCh3= {['h 400: 'h 4ff]}with (((item)%4==0 ));
      bins targetCh4 = {['h 500: 'h 5ff]}with (((item)%4==0 ));
      bins targetCh5 = {['h 600: 'h 6ff]}with (((item)%4==0 ));
      bins targetCh6 = {['h 700: 'h 7ff]}with (((item)%4==0 ));
      bins targetCh7 = {['h 800: 'h 8ff]}with (((item)%4==0 ));*/
    }
 
    LEGAL_ADDR: coverpoint apbTx.paddr iff(apbTx != null)
    {
      option.auto_bin_max = 2500;
      bins addrApbFirstReg[] = {'h 100 ,'h 200};
      bins addrApbSecondReg[] = {'h 104 ,'h 204};
      bins addrApbThirdReg[] = {'h 108 ,'h 208};
      bins addrApbFourthReg[] = {'h 10c ,'h 20c};
      bins addrApbFifthReg[] = {'h 110 ,'h 210};
      bins addrApbSixthReg[] = {'h 114 ,'h 214};
      bins addrApbSeventhReg[] = {'h 118 ,'h 218};
      bins addrApbEighthReg[] = {'h 11c ,'h 21c};
      bins addrApbNinthReg[] = {'h 120 ,'h 220};
      bins addrApbTenthReg[] = {'h 124 ,'h 224};
      bins addrApbEleventhReg[] = {'h 128 ,'h 228};
      bins addrApbTwelfthReg[] = {'h 12c ,'h 22c};
      bins addrApbThirteenthReg[] = {'h 130 ,'h 230};
      bins addrApbFourteenthReg[] = {'h 134 ,'h 234};
      bins addrApbFifteenthReg[] = {'h 138 ,'h 238};
      bins addrApbSixteenthReg[] = {'h 13c,'h23c};
      bins addrApbSeventeenthReg[] = {'h 140,'h240};
      bins addrApbEighteenthReg[] = {'h 144,'h244};
      bins addrApbNineteenthReg[] = {'h 148,'h248};
      bins addrApbTwentiethReg[] = {'h 14c,'h24c};
      bins addrApbTwentyFirstReg[] = {'h 150,'h250};
      bins addrApbTwentySecondReg[] = {'h 154,'h254};
      bins addrApbTwentyThirdReg[] = {'h 158,'h258};
      bins addrApbTwentyFourthReg[] = {'h 15c,'h25c};
      bins addrApbTwentyFifthReg[] = {'h 160,'h260};
      bins addrApbTwentySixthReg[] = {'h 164,'h264};
      bins addrApbTwentySeventhReg[] = {'h 168,'h268};
      bins addrApbTwentyEighthReg[] = {'h 16c,'h26c};
      bins addrApbTwentyNinthReg[] = {'h 170,'h270};
      bins addrApbThirtiethReg[] = {'h 174,'h274};
      bins addrApbThirtyFirstReg[] = {'h 178,'h278};
      bins addrApbThirtySecondReg[] = {'h 17c,'h27c};
      bins addrApbThirtyThirdReg[] = {'h 180,'h280};
      bins addrApbThirtyFourthReg[] = {'h 184,'h284};
      bins addrApbThirtyFifthReg[] = {'h 188,'h288};
      bins addrApbThirtySixthReg[] = {'h 18c,'h28c};
      bins addrApbThirtySeventhReg[] = {'h 190,'h290};
      bins addrApbThirtyEighthReg[] = {'h 194,'h294};
      bins addrApbThirtyNinthReg[] = {'h 198,'h298};
      bins addrApbFortiethReg[] = {'h 19c,'h29c};
      bins addrApbFortyFirstReg[] = {'h 1a0,'h2a0};
      bins addrApbFortySecondReg[] = {'h 1a4,'h2a4};
      bins addrApbFortyThirdReg[] = {'h 1a8,'h2a8};
      bins addrApbFortyFourthReg[] = {'h 1ac,'h2ac};
      bins addrApbFortyFifthReg[] = {'h 1b0,'h2b0};
      bins addrApbFortySixthReg[] = {'h 1b4,'h2b4};
      bins addrApbFortySeventhReg[] = {'h 1b8,'h2b8};
      bins addrApbFortyEighthReg[] = {'h 1bc,'h2bc};
      bins addrApbFortyNinthReg[] = {'h 1c0,'h2c0};
      bins addrApbFiftiethReg[] = {'h 1c4,'h2c4};
      bins addrApbFiftyFirstReg[] = {'h 1c8,'h2c8};
      bins addrApbFiftySecondReg[] = {'h 1cc,'h2cc};
      bins addrApbFiftyThirdReg[] = {'h 1d0,'h2d0};
      bins addrApbFiftyFourthReg[] = {'h 1d4,'h2d4};
      bins addrApbFiftyFifthReg[] = {'h 1d8,'h2d8};
      bins addrApbFiftySixthReg[] = {'h 1dc,'h2dc};
      bins addrApbFiftySeventhReg[] = {'h 1e0,'h2e0};
      bins addrApbFiftyEighthReg[] = {'h 1e4,'h2e4};
      bins addrApbFiftyNinthReg[] = {'h 1e8,'h2e8};
      bins addrApbSixtiethReg[] = {'h 1ec,'h2ec};
      bins addrApbSixtyFirstReg[] = {'h 1f0,'h2f0};
      bins addrApbSixtySecondReg[] = {'h 1f4,'h2f4};
      bins addrApbSixtyThirdReg[] = {'h 1f8,'h2f8};
      bins addrApbSixtyFourthReg[] = {'h 1fc,'h2fc};
     }
 
 
  // data legal for each of the registers and then cross first adddress reg with legal data
 
  LEGAL_VAL: coverpoint apbTx.pwdata iff (apbTx != null) {
 
    wildcard bins legalFirstRegval       = {32'b0000000?0???0???0000000000??????}; // was item[15:6],item[31:25],item[23],item[19]
    wildcard bins legalSecondRegval      = {32'b00000???00??????00000???0000????}; // was item[31:27],item[23:22],item[15:11],item[7:4]
    wildcard bins legalThirdRegval       = {32'b000000000000000000000???0000????}; // was item[31:11],item[7:4]
    wildcard bins legalFourthRegval      = {32'b00????????????000??????0????0???}; // was item[31:30],item[17:15],item[8],item[3]
 
    bins allLegalVal = {[0:$]}; //5 to 11 ,13,14,15,16,18,19,23,24,29,30,32,34
 
    wildcard bins legalEleventhRegVal    = {32'b00000000000000000000????????????}; //11, was item[31:20],item[15:12]
    wildcard bins legalTwelfthRegVal     = {32'b00000000000000000000????????????}; //12, was item[31:20],item[15:12]
    wildcard bins legalSeventeenthRegVal = {32'b00000000000?000?????????00000000}; //17, was item[31:21],item[15:13],item[7:0]
    wildcard bins legalTwentiethRegVal   = {32'b00000000????????0000????????????}; // was item[31:24],item[15:12]
    wildcard bins legalTwentyOneRegVal   = {32'b00000000????????0000????????????}; // was item[31:24],item[15:12]
    wildcard bins legalTwentyTwoRegVal   = {32'b0000000000000000000000??????????}; // was item[31:10]
    wildcard bins legalTwentyFiveRegVal  = {32'b000000000000000000000??000000000}; // was item[31:11],item[8:0]
    wildcard bins legalTwentySixRegVal   = {32'b0000000000000000000000??????????}; // was item[31:10]
    wildcard bins legalTwentySevenRegVal = {32'b000000000000000?????????????????}; // was item[31:17]
    wildcard bins legalTwentyEigthRegVal = {32'b??????????????????????????????0?}; // was item[1]
    wildcard bins legalThirtyOneRegVal   = {32'b0000000000000000000000000000????}; // was item[31:4]
    wildcard bins legalThirtyThreeRegVal = {32'b????????????????00000000?00?????}; // was item[15:8],item[6:5]
    wildcard bins legalThirtyFiveRegVal  = {32'b000000000000000000000000????????}; // was item[31:8]
    wildcard bins legalThirtySixRegVal   = {32'b00000000000000000000000000000???}; // was item[31:3]
    wildcard bins legalThirtySevenRegVal = {32'b00????0?????????????????????????}; // was item[31:30],item[25]
    wildcard bins legalThirtyEigthRegVal = {32'b000000????????00000?????????????}; // was item[31:26],item[17:13]
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
      bins legalRegThirtyFive= binsof(LEGAL_ADDR.addrApbFiftySecondReg) && binsof(LEGAL_VAL.legalThirtyFiveRegVal);
      bins legalRegThirtySix = binsof(LEGAL_ADDR.addrApbFiftyNinthReg) && binsof(LEGAL_VAL.legalThirtySixRegVal);
      bins legalRegThirtySeven = binsof(LEGAL_ADDR.addrApbSixtyThirdReg) && binsof(LEGAL_VAL.legalThirtySevenRegVal);
      bins legalRegThirtyEight = binsof(LEGAL_ADDR.addrApbSixtyFourthReg) && binsof(LEGAL_VAL.legalThirtyEigthRegVal);
 
      // ---------------- Ignore everything not explicitly defined above ----------------
      // (1) For each address bin used above, ignore every LEGAL_VAL bin except the paired one
      ignore_bins igRegOne          = binsof(LEGAL_ADDR.addrApbFirstReg)          && !binsof(LEGAL_VAL.legalFirstRegval);
      ignore_bins igRegTwo          = binsof(LEGAL_ADDR.addrApbSecondReg)         && !binsof(LEGAL_VAL.legalSecondRegval);
      ignore_bins igRegThree        = binsof(LEGAL_ADDR.addrApbThirdReg)          && !binsof(LEGAL_VAL.legalThirdRegval);
      ignore_bins igRegFour         = binsof(LEGAL_ADDR.addrApbFourthReg)         && !binsof(LEGAL_VAL.legalFourthRegval);
      ignore_bins igRegFive         = binsof(LEGAL_ADDR.addrApbFifthReg)          && !binsof(LEGAL_VAL.allLegalVal);
      ignore_bins igRegSix          = binsof(LEGAL_ADDR.addrApbSixthReg)          && !binsof(LEGAL_VAL.allLegalVal);
      ignore_bins igRegSeven        = binsof(LEGAL_ADDR.addrApbSeventhReg)        && !binsof(LEGAL_VAL.allLegalVal);
      ignore_bins igRegEight        = binsof(LEGAL_ADDR.addrApbEighthReg)         && !binsof(LEGAL_VAL.allLegalVal);
      ignore_bins igRegNine         = binsof(LEGAL_ADDR.addrApbNinthReg)          && !binsof(LEGAL_VAL.allLegalVal);
      ignore_bins igRegTen          = binsof(LEGAL_ADDR.addrApbTenthReg)          && !binsof(LEGAL_VAL.allLegalVal);
      ignore_bins igRegEleven       = binsof(LEGAL_ADDR.addrApbEleventhReg)       && !binsof(LEGAL_VAL.legalEleventhRegVal);
      ignore_bins igRegTwelve       = binsof(LEGAL_ADDR.addrApbTwelfthReg)        && !binsof(LEGAL_VAL.legalTwelfthRegVal);
      ignore_bins igRegThirteen     = binsof(LEGAL_ADDR.addrApbThirteenthReg)     && !binsof(LEGAL_VAL.allLegalVal);
      ignore_bins igRegFourteen     = binsof(LEGAL_ADDR.addrApbFourteenthReg)     && !binsof(LEGAL_VAL.allLegalVal);
      ignore_bins igRegFifteen      = binsof(LEGAL_ADDR.addrApbFifteenthReg)      && !binsof(LEGAL_VAL.allLegalVal);
      ignore_bins igRegSixteen      = binsof(LEGAL_ADDR.addrApbSixteenthReg)      && !binsof(LEGAL_VAL.allLegalVal);
      ignore_bins igRegSeventeen    = binsof(LEGAL_ADDR.addrApbSeventeenthReg)    && !binsof(LEGAL_VAL.legalSeventeenthRegVal);
      ignore_bins igRegEighteen     = binsof(LEGAL_ADDR.addrApbEighteenthReg)     && !binsof(LEGAL_VAL.allLegalVal);
      ignore_bins igRegNineteen     = binsof(LEGAL_ADDR.addrApbNineteenthReg)     && !binsof(LEGAL_VAL.allLegalVal);
      ignore_bins igRegTwenty       = binsof(LEGAL_ADDR.addrApbTwentiethReg)      && !binsof(LEGAL_VAL.legalTwentiethRegVal);
      ignore_bins igRegTwentyOne    = binsof(LEGAL_ADDR.addrApbTwentyFirstReg)    && !binsof(LEGAL_VAL.legalTwentyOneRegVal);
      ignore_bins igRegTwentyTwo    = binsof(LEGAL_ADDR.addrApbTwentySecondReg)   && !binsof(LEGAL_VAL.legalTwentyTwoRegVal);
      ignore_bins igRegTwentyThree  = binsof(LEGAL_ADDR.addrApbTwentyThirdReg)    && !binsof(LEGAL_VAL.allLegalVal);
      ignore_bins igRegTwentyFour   = binsof(LEGAL_ADDR.addrApbTwentyFifthReg)    && !binsof(LEGAL_VAL.allLegalVal);
      ignore_bins igRegTwentyFive   = binsof(LEGAL_ADDR.addrApbTwentySeventhReg)  && !binsof(LEGAL_VAL.legalTwentyFiveRegVal);
      ignore_bins igRegTwentySix    = binsof(LEGAL_ADDR.addrApbTwentyNinthReg)    && !binsof(LEGAL_VAL.legalTwentySixRegVal);
      ignore_bins igRegTwentySeven  = binsof(LEGAL_ADDR.addrApbThirtiethReg)      && !binsof(LEGAL_VAL.legalTwentySevenRegVal);
      ignore_bins igRegTwentyEight  = binsof(LEGAL_ADDR.addrApbThirtyFirstReg)    && !binsof(LEGAL_VAL.legalTwentyEigthRegVal);
      ignore_bins igRegTwentyNine   = binsof(LEGAL_ADDR.addrApbThirtySecondReg)   && !binsof(LEGAL_VAL.allLegalVal);
      ignore_bins igRegThirty       = binsof(LEGAL_ADDR.addrApbThirtyThirdReg)    && !binsof(LEGAL_VAL.allLegalVal);
      ignore_bins igRegThirtyOne    = binsof(LEGAL_ADDR.addrApbThirtyFifthReg)    && !binsof(LEGAL_VAL.legalThirtyOneRegVal);
      ignore_bins igRegThirtyTwo    = binsof(LEGAL_ADDR.addrApbThirtySixthReg)    && !binsof(LEGAL_VAL.allLegalVal);
      ignore_bins igRegThirtyThree  = binsof(LEGAL_ADDR.addrApbThirtySeventhReg)  && !binsof(LEGAL_VAL.legalThirtyThreeRegVal);
      ignore_bins igRegThirtyFour   = binsof(LEGAL_ADDR.addrApbFiftyFirstReg)     && !binsof(LEGAL_VAL.allLegalVal);
      ignore_bins igRegThirtyFive   = binsof(LEGAL_ADDR.addrApbFiftySecondReg)    && !binsof(LEGAL_VAL.legalThirtyFiveRegVal);
      ignore_bins igRegThirtySix    = binsof(LEGAL_ADDR.addrApbFiftyNinthReg)     && !binsof(LEGAL_VAL.legalThirtySixRegVal);
      ignore_bins igRegThirtySeven  = binsof(LEGAL_ADDR.addrApbSixtyThirdReg)     && !binsof(LEGAL_VAL.legalThirtySevenRegVal);
      ignore_bins igRegThirtyEight  = binsof(LEGAL_ADDR.addrApbSixtyFourthReg)    && !binsof(LEGAL_VAL.legalThirtyEigthRegVal);
 
      // (2) Address bins not used in any cross bin above -> ignore completely
      ignore_bins igUnusedAddr = binsof(LEGAL_ADDR.addrApbTwentyFourthReg) ||
                                 binsof(LEGAL_ADDR.addrApbTwentySixthReg)  ||
                                 binsof(LEGAL_ADDR.addrApbTwentyEighthReg) ||
                                 binsof(LEGAL_ADDR.addrApbThirtyFourthReg) ||
                                 binsof(LEGAL_ADDR.addrApbThirtyEighthReg) ||
                                 binsof(LEGAL_ADDR.addrApbThirtyNinthReg)  ||
                                 binsof(LEGAL_ADDR.addrApbFortiethReg)     ||
                                 binsof(LEGAL_ADDR.addrApbFortyFirstReg)   ||
                                 binsof(LEGAL_ADDR.addrApbFortySecondReg)  ||
                                 binsof(LEGAL_ADDR.addrApbFortyThirdReg)   ||
                                 binsof(LEGAL_ADDR.addrApbFortyFourthReg)  ||
                                 binsof(LEGAL_ADDR.addrApbFortyFifthReg)   ||
                                 binsof(LEGAL_ADDR.addrApbFortySixthReg)   ||
                                 binsof(LEGAL_ADDR.addrApbFortySeventhReg) ||
                                 binsof(LEGAL_ADDR.addrApbFortyEighthReg)  ||
                                 binsof(LEGAL_ADDR.addrApbFortyNinthReg)   ||
                                 binsof(LEGAL_ADDR.addrApbFiftiethReg)     ||
                                 binsof(LEGAL_ADDR.addrApbFiftyThirdReg)   ||
                                 binsof(LEGAL_ADDR.addrApbFiftyFourthReg)  ||
                                 binsof(LEGAL_ADDR.addrApbFiftyFifthReg)   ||
                                 binsof(LEGAL_ADDR.addrApbFiftySixthReg)   ||
                                 binsof(LEGAL_ADDR.addrApbFiftySeventhReg) ||
                                 binsof(LEGAL_ADDR.addrApbFiftyEighthReg)  ||
                                 binsof(LEGAL_ADDR.addrApbSixtiethReg)     ||
                                 binsof(LEGAL_ADDR.addrApbSixtyFirstReg)   ||
                                 binsof(LEGAL_ADDR.addrApbSixtySecondReg);
    }
 
 
    coverpoint addressDecodeForSlave(writeAddrTx.awaddr)iff(writeAddrTx!=null){ //need to look any generic way
      bins destinationSlaveTargeted[] = {[0:NO_OF_SLAVES-1]}; //based on function return val we can increment the counter of finite slave bin
    }
 
    coverpoint writeAddrTx.awid iff(writeAddrTx!=null){
      bins channelInitiatedWrite[] = {[0:NUM_CHANNELS-1]};
    }
 
    coverpoint writeAddrTx.awburst iff(writeAddrTx !=null){
      bins burst0 = {0};
      bins burst1 = {1};
      illegal_bins burst23 = {2,3};
    }
 
    coverpoint writeAddrTx.awlen iff(writeAddrTx !=null){
      bins lowLen = {[0:100]};
    //  bins mediumLen = {[101:200]};
    //  bins highLen = {[201:255]}; //burst can be 0 to 255 (awburst 1 is legal so)
    }
    coverpoint addressDecodeForSlave(readAddrTx.araddr)iff(readAddrTx!=null){ //need to look any generic way
      bins sourceSlaveTargeted[] = {[0:NO_OF_SLAVES-1]}; //based on function return val we can increment the counter of finite slave bin
    }
 
    coverpoint readAddrTx.arid iff(readAddrTx!=null){
      bins channelInitiatedRead[] = {[0:NUM_CHANNELS-1]};
    }
 
    coverpoint readAddrTx.arburst iff(readAddrTx !=null){
      bins burst0 = {0};
      bins burst1 = {1};
      illegal_bins burst23 = {2,3};
    }
 
    coverpoint readAddrTx.arlen iff(readAddrTx !=null){
      bins lowLen = {[0:100]};
   //   bins mediumLen = {[101:200]};
    //  bins highLen = {[201:255]}; //burst can be 0 to 255 (awburst 1 is legal so)
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
	apb_master_tx tx1;
	coverageConfigUnitApbPathAnalysisExport.get(tx1);
	cg.sample(tx1);
      end
      end
      begin
        forever begin
         axi4_slave_tx tx1;
         wait(coveragePeripheralUnitAxi4SlavePathWriteAddressAnalysisExport[j].size()>0)
          tx1 = coveragePeripheralUnitAxi4SlavePathWriteAddressAnalysisExport[j].pop_front();
	  cg.sample(,tx1);
        end
      end  
 
      begin
        forever begin
          axi4_slave_tx tx2;
          coveragePeripheralUnitAxi4SlavePathWriteDataAnalysisExport[j].get(tx2);
	  cg.sample(,,tx2);
        end
      end
 
      begin
        forever begin
          axi4_slave_tx tx3;
          coveragePeripheralUnitAxi4SlavePathWriteResponseAnalysisExport[j].get(tx3);
	  cg.sample(,,,tx3);
        end
      end
 
      begin
        forever begin
          axi4_slave_tx tx4;
          coveragePeripheralUnitAxi4SlavePathReadAddressAnalysisExport[j].get(tx4);   
	  cg.sample(,,,,tx4);
        end
      end
 
      begin
        forever begin
          axi4_slave_tx tx5;
          coveragePeripheralUnitAxi4SlavePathReadDataAnalysisExport[j].get(tx5);
	  cg.sample(,,,,,tx5);
        end
      end
 
      begin
        forever begin
          triggerSlaveTx tx1;
          coveragePeripheralUnitTriggerSlavePathAnalysisExport[j].get(tx1);
	  cg.sample(,,,,,,tx1);
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
  for(int i=0;i<(axi4_globals_pkg::NO_OF_SLAVES+1);i++)begin
    //coveragePeripheralUnitAxi4SlavePathWriteAddressAnalysisExport[i] = new[1];
    coveragePeripheralUnitAxi4SlavePathWriteDataAnalysisExport[i] = new($sformatf("coveragePeripheralUnitAxi4SlavePathWriteDataAnalysisExport[%0d]",i),this);
    coveragePeripheralUnitAxi4SlavePathWriteResponseAnalysisExport[i] = new($sformatf("coveragePeripheralUnitAxi4SlavePathWriteResponseAnalysisExport[%0d]",i),this);
    coveragePeripheralUnitAxi4SlavePathReadAddressAnalysisExport[i] = new($sformatf("coveragePeripheralUnitAxi4SlavePathReadAddressAnalysisExport[%0d]",i),this);
    coveragePeripheralUnitAxi4SlavePathReadDataAnalysisExport[i] = new($sformatf("coveragePeripheralUnitAxi4SlavePathReadDataAnalysisExport[%0d]",i),this);
    coveragePeripheralUnitTriggerSlavePathAnalysisExport[i] = new($sformatf("coveragePeripheralUnitTriggerSlavePathAnalysisExport[%0d]",i),this);
    coveragePeripheralUnitTriggerOutSlavePathAnalysisExport[i] = new($sformatf("coveragePeripheralUnitTriggerOutSlavePathAnalysisExport[%0d]",i),this);
  end
endfunction
`endif
