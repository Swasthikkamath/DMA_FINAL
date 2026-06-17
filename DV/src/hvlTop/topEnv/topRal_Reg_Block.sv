class reg_block_top extends uvm_reg_block;
  `uvm_object_utils(reg_block_top)
 
  uvm_reg_map address_map;
  rand CH_CMD          CH_CMD_inst[];
  rand CH_STATUS       CH_STATUS_inst[];
  rand CH_INTREN       CH_INTREN_inst[];
  rand CH_CTRL         CH_CTRL_inst[];
  rand CH_SRCADDR      CH_SRCADDR_inst[];
  rand CH_SRCADDRHI    CH_SRCADDRHI_inst[];
  rand CH_DESADDR      CH_DESADDR_inst[];
  rand CH_DESADDRHI    CH_DESADDRHI_inst[];
  rand CH_XSIZE        CH_XSIZE_inst[];
  rand CH_XSIZEHI      CH_XSIZEHI_inst[];
  rand CH_SRCTRANSCFG  CH_SRCTRANSCFG_inst[];
  rand CH_DESTRANSCFG  CH_DESTRANSCFG_inst[];
  rand CH_XADDRINC     CH_XADDRINC_inst[];
  rand CH_YADDRSTRIDE  CH_YADDRSTRIDE_inst[];
  rand CH_FILLVAL      CH_FILLVAL_inst[];
  rand CH_YSIZE        CH_YSIZE_inst[];
  rand CH_TMPLTCFG     CH_TMPLTCFG_inst[];
  rand CH_SRCTMPLT     CH_SRCTMPLT_inst[];
  rand CH_DESTMPLT     CH_DESTMPLT_inst[];
  rand CH_SRCTRIGINCFG CH_SRCTRIGINCFG_inst[];
  rand CH_DESTRIGINCFG CH_DESTRIGINCFG_inst[];
  rand CH_TRIGOUTCFG   CH_TRIGOUTCFG_inst[];
  rand CH_GPOEN0       CH_GPOEN0_inst[];
  rand CH_GPOVAL0      CH_GPOVAL0_inst[];
  rand CH_STREAMINTCFG CH_STREAMINTCFG_inst[];
  rand CH_LINKATTR     CH_LINKATTR_inst[];
  rand CH_AUTOCFG      CH_AUTOCFG_inst[];
  rand CH_LINKADDR     CH_LINKADDR_inst[];
  rand CH_LINKADDRHI   CH_LINKADDRHI_inst[];
  rand CH_GPOREAD0     CH_GPOREAD0_inst[];
  rand CH_WRKREGPTR    CH_WRKREGPTR_inst[];
  rand CH_WRKREGVAL    CH_WRKREGVAL_inst[];
  rand CH_ERRINFO      CH_ERRINFO_inst[];
  rand CH_IIDR         CH_IIDR_inst[];
  rand CH_AIDR         CH_AIDR_inst[];
  rand CH_ISSUECAP     CH_ISSUECAP_inst[];
  rand CH_BUILDCFG0    CH_BUILDCFG0_inst[];
  rand CH_BUILDCFG1    CH_BUILDCFG1_inst[];

  function new(string name = "reg_block_top");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

  function void build();
    // Allocate dynamic arrays
    CH_CMD_inst          = new[NUM_CHANNELS];
    CH_STATUS_inst       = new[NUM_CHANNELS];
    CH_INTREN_inst       = new[NUM_CHANNELS];
    CH_CTRL_inst         = new[NUM_CHANNELS];
    CH_SRCADDR_inst      = new[NUM_CHANNELS];
    CH_SRCADDRHI_inst    = new[NUM_CHANNELS];
    CH_DESADDR_inst      = new[NUM_CHANNELS];
    CH_DESADDRHI_inst    = new[NUM_CHANNELS];
    CH_XSIZE_inst        = new[NUM_CHANNELS];
    CH_XSIZEHI_inst      = new[NUM_CHANNELS];
    CH_SRCTRANSCFG_inst  = new[NUM_CHANNELS];
    CH_DESTRANSCFG_inst  = new[NUM_CHANNELS];
    CH_XADDRINC_inst     = new[NUM_CHANNELS];
    CH_YADDRSTRIDE_inst  = new[NUM_CHANNELS];
    CH_FILLVAL_inst      = new[NUM_CHANNELS];
    CH_YSIZE_inst        = new[NUM_CHANNELS];
    CH_TMPLTCFG_inst     = new[NUM_CHANNELS];
    CH_SRCTMPLT_inst     = new[NUM_CHANNELS];
    CH_DESTMPLT_inst     = new[NUM_CHANNELS];
    CH_SRCTRIGINCFG_inst = new[NUM_CHANNELS];
    CH_DESTRIGINCFG_inst = new[NUM_CHANNELS];
    CH_TRIGOUTCFG_inst   = new[NUM_CHANNELS];
    CH_GPOEN0_inst       = new[NUM_CHANNELS];
    CH_GPOVAL0_inst      = new[NUM_CHANNELS];
    CH_STREAMINTCFG_inst = new[NUM_CHANNELS];
    CH_LINKATTR_inst     = new[NUM_CHANNELS];
    CH_AUTOCFG_inst      = new[NUM_CHANNELS];
    CH_LINKADDR_inst     = new[NUM_CHANNELS];
    CH_LINKADDRHI_inst   = new[NUM_CHANNELS];
    CH_GPOREAD0_inst     = new[NUM_CHANNELS];
    CH_WRKREGPTR_inst    = new[NUM_CHANNELS];
    CH_WRKREGVAL_inst    = new[NUM_CHANNELS];
    CH_ERRINFO_inst      = new[NUM_CHANNELS];
    CH_IIDR_inst         = new[NUM_CHANNELS];
    CH_AIDR_inst         = new[NUM_CHANNELS];
    CH_ISSUECAP_inst     = new[NUM_CHANNELS];
    CH_BUILDCFG0_inst    = new[NUM_CHANNELS];
    CH_BUILDCFG1_inst    = new[NUM_CHANNELS];

     // Create address map
    address_map = create_map("address_map", 0, apb_global_pkg :: DATA_WIDTH, UVM_LITTLE_ENDIAN);

    // Per-channel creation and mapping
    for (int ch = 0; ch < NUM_CHANNELS; ch++) begin
      int base = 'h100 + 'h 0100 * (ch);
      
      CH_CMD_inst[ch] = CH_CMD::type_id::create($sformatf("CH_CMD_ch%0d", ch));
      CH_CMD_inst[ch].build(); CH_CMD_inst[ch].configure(this);
      address_map.add_reg(CH_CMD_inst[ch],base + 'h00, "RW");
 
      CH_STATUS_inst[ch] = CH_STATUS::type_id::create($sformatf("CH_STATUS_ch%0d", ch));
      CH_STATUS_inst[ch].build(); CH_STATUS_inst[ch].configure(this);
      address_map.add_reg(CH_STATUS_inst[ch],base + 'h04, "RW");

      CH_INTREN_inst[ch] = CH_INTREN::type_id::create($sformatf("CH_INTREN_ch%0d", ch));
      CH_INTREN_inst[ch].build(); CH_INTREN_inst[ch].configure(this);
      address_map.add_reg(CH_INTREN_inst[ch],base + 'h08, "RW");

      CH_CTRL_inst[ch] = CH_CTRL::type_id::create($sformatf("CH_CTRL_ch%0d", ch));
      CH_CTRL_inst[ch].build(); CH_CTRL_inst[ch].configure(this);
      address_map.add_reg(CH_CTRL_inst[ch],base + 'h0C, "RW");

      CH_SRCADDR_inst[ch] = CH_SRCADDR::type_id::create($sformatf("CH_SRCADDR_ch%0d", ch));
      CH_SRCADDR_inst[ch].build(); CH_SRCADDR_inst[ch].configure(this);
      address_map.add_reg(CH_SRCADDR_inst[ch],      base + 'h10, "RW");

      CH_SRCADDRHI_inst[ch] = CH_SRCADDRHI::type_id::create($sformatf("CH_SRCADDRHI_ch%0d", ch));
      CH_SRCADDRHI_inst[ch].build(); CH_SRCADDRHI_inst[ch].configure(this);
      address_map.add_reg(CH_SRCADDRHI_inst[ch],    base + 'h14, "RW");

      CH_DESADDR_inst[ch] = CH_DESADDR::type_id::create($sformatf("CH_DESADDR_ch%0d", ch));
      CH_DESADDR_inst[ch].build(); CH_DESADDR_inst[ch].configure(this);
      address_map.add_reg(CH_DESADDR_inst[ch],base + 'h18, "RW");

      CH_DESADDRHI_inst[ch] = CH_DESADDRHI::type_id::create($sformatf("CH_DESADDRHI_ch%0d", ch));
      CH_DESADDRHI_inst[ch].build(); CH_DESADDRHI_inst[ch].configure(this);
      address_map.add_reg(CH_DESADDRHI_inst[ch],base + 'h1C, "RW");

      CH_XSIZE_inst[ch] = CH_XSIZE::type_id::create($sformatf("CH_XSIZE_ch%0d", ch));
      CH_XSIZE_inst[ch].build(); CH_XSIZE_inst[ch].configure(this);
      address_map.add_reg(CH_XSIZE_inst[ch],base + 'h20, "RW");

      CH_XSIZEHI_inst[ch] = CH_XSIZEHI::type_id::create($sformatf("CH_XSIZEHI_ch%0d", ch));
      CH_XSIZEHI_inst[ch].build(); CH_XSIZEHI_inst[ch].configure(this);
      address_map.add_reg(CH_XSIZEHI_inst[ch],base + 'h24, "RW");

      CH_SRCTRANSCFG_inst[ch]  = CH_SRCTRANSCFG::type_id::create($sformatf("CH_SRCTRANSCFG_ch%0d", ch));
      CH_SRCTRANSCFG_inst[ch].build(); CH_SRCTRANSCFG_inst[ch].configure(this);
      address_map.add_reg(CH_SRCTRANSCFG_inst[ch],  base + 'h28, "RW");

      CH_DESTRANSCFG_inst[ch]  = CH_DESTRANSCFG::type_id::create($sformatf("CH_DESTRANSCFG_ch%0d", ch));
      CH_DESTRANSCFG_inst[ch].build(); CH_DESTRANSCFG_inst[ch].configure(this);
      address_map.add_reg(CH_DESTRANSCFG_inst[ch],  base + 'h2C, "RW");

      CH_XADDRINC_inst[ch] = CH_XADDRINC::type_id::create($sformatf("CH_XADDRINC_ch%0d", ch));
      CH_XADDRINC_inst[ch].build(); CH_XADDRINC_inst[ch].configure(this);
      address_map.add_reg(CH_XADDRINC_inst[ch],base + 'h30, "RW");

      CH_YADDRSTRIDE_inst[ch] = CH_YADDRSTRIDE::type_id::create($sformatf("CH_YADDRSTRIDE_ch%0d", ch));
      CH_YADDRSTRIDE_inst[ch].build(); CH_YADDRSTRIDE_inst[ch].configure(this);
      address_map.add_reg(CH_YADDRSTRIDE_inst[ch],base + 'h34, "RW");

      CH_FILLVAL_inst[ch] = CH_FILLVAL::type_id::create($sformatf("CH_FILLVAL_ch%0d", ch));
      CH_FILLVAL_inst[ch].build(); CH_FILLVAL_inst[ch].configure(this);
      address_map.add_reg(CH_FILLVAL_inst[ch],base + 'h38, "RW");

      CH_YSIZE_inst[ch] = CH_YSIZE::type_id::create($sformatf("CH_YSIZE_ch%0d", ch));
      CH_YSIZE_inst[ch].build(); CH_YSIZE_inst[ch].configure(this);
      address_map.add_reg(CH_YSIZE_inst[ch],base + 'h3C, "RW");

      CH_TMPLTCFG_inst[ch] = CH_TMPLTCFG::type_id::create($sformatf("CH_TMPLTCFG_ch%0d", ch));
      CH_TMPLTCFG_inst[ch].build(); CH_TMPLTCFG_inst[ch].configure(this);
      address_map.add_reg(CH_TMPLTCFG_inst[ch],base + 'h40, "RW");

      CH_SRCTMPLT_inst[ch] = CH_SRCTMPLT::type_id::create($sformatf("CH_SRCTMPLT_ch%0d", ch));
      CH_SRCTMPLT_inst[ch].build(); CH_SRCTMPLT_inst[ch].configure(this);
      address_map.add_reg(CH_SRCTMPLT_inst[ch],base + 'h44, "RW");

      CH_DESTMPLT_inst[ch]  = CH_DESTMPLT::type_id::create($sformatf("CH_DESTMPLT_ch%0d", ch));
      CH_DESTMPLT_inst[ch].build(); CH_DESTMPLT_inst[ch].configure(this);
      address_map.add_reg(CH_DESTMPLT_inst[ch],base + 'h48, "RW");

      CH_SRCTRIGINCFG_inst[ch] = CH_SRCTRIGINCFG::type_id::create($sformatf("CH_SRCTRIGINCFG_ch%0d", ch));
      CH_SRCTRIGINCFG_inst[ch].build(); CH_SRCTRIGINCFG_inst[ch].configure(this);
      address_map.add_reg(CH_SRCTRIGINCFG_inst[ch], base + 'h4C, "RW");

      CH_DESTRIGINCFG_inst[ch] = CH_DESTRIGINCFG::type_id::create($sformatf("CH_DESTRIGINCFG_ch%0d", ch));
      CH_DESTRIGINCFG_inst[ch].build(); CH_DESTRIGINCFG_inst[ch].configure(this);
      address_map.add_reg(CH_DESTRIGINCFG_inst[ch], base + 'h50, "RW");

      CH_TRIGOUTCFG_inst[ch]   = CH_TRIGOUTCFG::type_id::create($sformatf("CH_TRIGOUTCFG_ch%0d", ch));
      CH_TRIGOUTCFG_inst[ch].build(); CH_TRIGOUTCFG_inst[ch].configure(this);
      address_map.add_reg(CH_TRIGOUTCFG_inst[ch],   base + 'h54, "RW");

      CH_GPOEN0_inst[ch]       = CH_GPOEN0::type_id::create($sformatf("CH_GPOEN0_ch%0d", ch));
      CH_GPOEN0_inst[ch].build(); CH_GPOEN0_inst[ch].configure(this);
      address_map.add_reg(CH_GPOEN0_inst[ch],       base + 'h58, "RW");

      CH_GPOVAL0_inst[ch]      = CH_GPOVAL0::type_id::create($sformatf("CH_GPOVAL0_ch%0d", ch));
      CH_GPOVAL0_inst[ch].build(); CH_GPOVAL0_inst[ch].configure(this);
      address_map.add_reg(CH_GPOVAL0_inst[ch],      base + 'h60, "RW");

      CH_STREAMINTCFG_inst[ch] = CH_STREAMINTCFG::type_id::create($sformatf("CH_STREAMINTCFG_ch%0d", ch));
      CH_STREAMINTCFG_inst[ch].build(); CH_STREAMINTCFG_inst[ch].configure(this);
      address_map.add_reg(CH_STREAMINTCFG_inst[ch], base + 'h68, "RW");

      CH_LINKATTR_inst[ch] = CH_LINKATTR::type_id::create($sformatf("CH_LINKATTR_ch%0d", ch));
      CH_LINKATTR_inst[ch].build(); CH_LINKATTR_inst[ch].configure(this);
      address_map.add_reg(CH_LINKATTR_inst[ch], base + 'h70, "RW");

      CH_AUTOCFG_inst[ch] = CH_AUTOCFG::type_id::create($sformatf("CH_AUTOCFG_ch%0d", ch));
      CH_AUTOCFG_inst[ch].build(); CH_AUTOCFG_inst[ch].configure(this);
      address_map.add_reg(CH_AUTOCFG_inst[ch], base + 'h74, "RW");

      CH_LINKADDR_inst[ch] = CH_LINKADDR::type_id::create($sformatf("CH_LINKADDR_ch%0d", ch));
      CH_LINKADDR_inst[ch].build(); CH_LINKADDR_inst[ch].configure(this);
      address_map.add_reg(CH_LINKADDR_inst[ch], base + 'h78, "RW");

      CH_LINKADDRHI_inst[ch] = CH_LINKADDRHI::type_id::create($sformatf("CH_LINKADDRHI_ch%0d", ch));
      CH_LINKADDRHI_inst[ch].build(); CH_LINKADDRHI_inst[ch].configure(this);
      address_map.add_reg(CH_LINKADDRHI_inst[ch], base + 'h7C, "RW");

      CH_GPOREAD0_inst[ch] = CH_GPOREAD0::type_id::create($sformatf("CH_GPOREAD0_ch%0d", ch));
      CH_GPOREAD0_inst[ch].build(); CH_GPOREAD0_inst[ch].configure(this);
      address_map.add_reg(CH_GPOREAD0_inst[ch], base + 'h80, "RO");

      CH_WRKREGPTR_inst[ch] = CH_WRKREGPTR::type_id::create($sformatf("CH_WRKREGPTR_ch%0d", ch));
      CH_WRKREGPTR_inst[ch].build(); CH_WRKREGPTR_inst[ch].configure(this);
      address_map.add_reg(CH_WRKREGPTR_inst[ch], base + 'h88, "RW");

      CH_WRKREGVAL_inst[ch] = CH_WRKREGVAL::type_id::create($sformatf("CH_WRKREGVAL_ch%0d", ch));
      CH_WRKREGVAL_inst[ch].build(); CH_WRKREGVAL_inst[ch].configure(this);
      address_map.add_reg(CH_WRKREGVAL_inst[ch], base + 'h8C, "RO");

      CH_ERRINFO_inst[ch] = CH_ERRINFO::type_id::create($sformatf("CH_ERRINFO_ch%0d", ch));
      CH_ERRINFO_inst[ch].build(); CH_ERRINFO_inst[ch].configure(this);
      address_map.add_reg(CH_ERRINFO_inst[ch], base + 'h90, "RO");

      CH_IIDR_inst[ch] = CH_IIDR::type_id::create($sformatf("CH_IIDR_ch%0d", ch));
      CH_IIDR_inst[ch].build(); CH_IIDR_inst[ch].configure(this);
      address_map.add_reg(CH_IIDR_inst[ch], base + 'hC8, "RO");

      CH_AIDR_inst[ch] = CH_AIDR::type_id::create($sformatf("CH_AIDR_ch%0d", ch));
      CH_AIDR_inst[ch].build(); CH_AIDR_inst[ch].configure(this);
      address_map.add_reg(CH_AIDR_inst[ch], base + 'hCC, "RO");

      CH_ISSUECAP_inst[ch] = CH_ISSUECAP::type_id::create($sformatf("CH_ISSUECAP_ch%0d", ch));
      CH_ISSUECAP_inst[ch].build(); CH_ISSUECAP_inst[ch].configure(this);
      address_map.add_reg(CH_ISSUECAP_inst[ch], base + 'hE8, "RW");

      CH_BUILDCFG0_inst[ch] = CH_BUILDCFG0::type_id::create($sformatf("CH_BUILDCFG0_ch%0d", ch));
      CH_BUILDCFG0_inst[ch].build(); CH_BUILDCFG0_inst[ch].configure(this);
      address_map.add_reg(CH_BUILDCFG0_inst[ch], base + 'hF8, "RO");

      CH_BUILDCFG1_inst[ch] = CH_BUILDCFG1::type_id::create($sformatf("CH_BUILDCFG1_ch%0d", ch));
      CH_BUILDCFG1_inst[ch].build(); CH_BUILDCFG1_inst[ch].configure(this);
      address_map.add_reg(CH_BUILDCFG1_inst[ch], base + 'hFC, "RO");
    end // for channels

    lock_model();
  endfunction
endclass
