//RAL for dma
//Registers

// CH_CMD 
class CH_CMD extends uvm_reg;
  `uvm_object_utils(CH_CMD)

  rand uvm_reg_field ENABLECMD;
  rand uvm_reg_field CLEARCMD;
  rand uvm_reg_field DISABLECMD;
  rand uvm_reg_field STOPCMD;
  rand uvm_reg_field PAUSECMD;
  rand uvm_reg_field RESUMECMD;
  rand uvm_reg_field reserved1;
  rand uvm_reg_field SRCSWTRIGINREQ;
  rand uvm_reg_field SRCSWTRIGINTYPE;
  rand uvm_reg_field reserved2;
  rand uvm_reg_field DESSWTRIGINREQ;
  rand uvm_reg_field DESSWTRIGINTYPE;
  rand uvm_reg_field reserved3;
  rand uvm_reg_field SWTRIGOUTACK;
  rand uvm_reg_field reserved4;

  function new(string name = "CH_CMD");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();

    ENABLECMD = uvm_reg_field::type_id::create("ENABLECMD");
    ENABLECMD.configure(this, 1, 0, "W1S", 0, 'h0, 1, 1, 1);

    CLEARCMD = uvm_reg_field::type_id::create("CLEARCMD");
    CLEARCMD.configure(this, 1, 1, "W1S", 0, 'h0, 1, 1, 1);

    DISABLECMD = uvm_reg_field::type_id::create("DISABLECMD", );
    DISABLECMD.configure(this, 1, 2, "W1S", 0, 'h0, 1, 1, 1);

    STOPCMD = uvm_reg_field::type_id::create("STOPCMD", );
    STOPCMD.configure(this, 1, 3, "W1S", 0, 'h0, 1, 1, 1);

    PAUSECMD = uvm_reg_field::type_id::create("PAUSECMD", );
    PAUSECMD.configure(this, 1, 4, "W1S", 0, 'h0, 1, 1, 1);

    RESUMECMD = uvm_reg_field::type_id::create("RESUMECMD", );
    RESUMECMD.configure(this, 1, 5, "W1S", 0, 'h0, 1, 1, 1);

    reserved1 = uvm_reg_field::type_id::create("reserved1", );
    reserved1.configure(this, 10, 6, "RO", 0, 'h0, 1, 0, 0);

    SRCSWTRIGINREQ = uvm_reg_field::type_id::create("SRCSWTRIGINREQ", );
    SRCSWTRIGINREQ.configure(this, 1, 16, "W1S", 0, 'h0, 1, 1, 1);

    SRCSWTRIGINTYPE = uvm_reg_field::type_id::create("SRCSWTRIGINTYPE", );
    SRCSWTRIGINTYPE.configure(this, 2, 17, "RW", 0, 'h0, 1, 1, 1);

    reserved2 = uvm_reg_field::type_id::create("reserved2", );
    reserved2.configure(this, 1, 19, "RO", 0, 'h0, 1, 0, 0);

    DESSWTRIGINREQ = uvm_reg_field::type_id::create("DESSWTRIGINREQ", );
    DESSWTRIGINREQ.configure(this, 1, 20, "W1S", 0, 'h0, 1, 1, 1);

    DESSWTRIGINTYPE = uvm_reg_field::type_id::create("DESSWTRIGINTYPE", );
    DESSWTRIGINTYPE.configure(this, 2, 21, "RW", 0, 'h0, 1, 1, 1);

    reserved3 = uvm_reg_field::type_id::create("reserved3", );
    reserved3.configure(this, 1, 23, "RO", 0, 'h0, 1, 0, 0);

    SWTRIGOUTACK = uvm_reg_field::type_id::create("SWTRIGOUTACK", );
    SWTRIGOUTACK.configure(this, 1, 24, "W1S", 0, 'h0, 1, 1, 1);

    reserved4 = uvm_reg_field::type_id::create("reserved4", );
    reserved4.configure(this, 7, 25, "RO", 0, 'h0, 1, 0, 0);

  endfunction
endclass
 
//CH_STATUS
class CH_STATUS extends uvm_reg;
  `uvm_object_utils(CH_STATUS)

  uvm_reg_field INTR_DONE;
  uvm_reg_field INTR_ERR;
  uvm_reg_field INTR_DISABLED;
  uvm_reg_field INTR_STOPPED;
  uvm_reg_field reserved1;
  uvm_reg_field INTR_SRCTRIGINWAIT;
  uvm_reg_field INTR_DESTRIGINWAIT;
  uvm_reg_field INTR_TRIGOUTACKWAIT;
  uvm_reg_field reserved2;
  uvm_reg_field STAT_DONE;
  uvm_reg_field STAT_ERR;
  uvm_reg_field STAT_DISABLED;
  uvm_reg_field STAT_STOPPED;
  uvm_reg_field STAT_PAUSED;
  uvm_reg_field STAT_RESUMEWAIT;
  uvm_reg_field reserved3;
  uvm_reg_field STAT_SRCTRIGINWAIT;
  uvm_reg_field STAT_DESTRIGINWAIT;
  uvm_reg_field STAT_TRIGOUTACKWAIT;
  uvm_reg_field reserved4;

  function new(string name = "CH_STATUS");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();

    INTR_DONE = uvm_reg_field::type_id::create("INTR_DONE", );
    INTR_DONE.configure(this, 1, 0, "RO", 0, 'h0, 1, 0, 1);

    INTR_ERR = uvm_reg_field::type_id::create("INTR_ERR", );
    INTR_ERR.configure(this, 1, 1, "RO", 0, 'h0, 1, 0, 1);

    INTR_DISABLED = uvm_reg_field::type_id::create("INTR_DISABLED", );
    INTR_DISABLED.configure(this, 1, 2, "RO", 0, 'h0, 1, 0, 1);

    INTR_STOPPED = uvm_reg_field::type_id::create("INTR_STOPPED", );
    INTR_STOPPED.configure(this, 1, 3, "RO", 0, 'h0, 1, 0, 1);

    reserved1 = uvm_reg_field::type_id::create("reserved1", );
    reserved1.configure(this, 4, 4, "RO", 0, 'h0, 1, 0, 0);

    INTR_SRCTRIGINWAIT = uvm_reg_field::type_id::create("INTR_SRCTRIGINWAIT", );
    INTR_SRCTRIGINWAIT.configure(this, 1, 8, "RO", 0, 'h0, 1, 0, 1);

    INTR_DESTRIGINWAIT = uvm_reg_field::type_id::create("INTR_DESTRIGINWAIT", );
    INTR_DESTRIGINWAIT.configure(this, 1, 9, "RO", 0, 'h0, 1, 0, 1);

    INTR_TRIGOUTACKWAIT = uvm_reg_field::type_id::create("INTR_TRIGOUTACKWAIT", );
    INTR_TRIGOUTACKWAIT.configure(this, 1, 10, "RO", 0, 'h0, 1, 0, 1);

    reserved2 = uvm_reg_field::type_id::create("reserved2", );
    reserved2.configure(this, 5, 11, "RO", 0, 'h0, 1, 0, 0);

    STAT_DONE = uvm_reg_field::type_id::create("STAT_DONE", );
    STAT_DONE.configure(this, 1, 16, "W1C", 0, 'h0, 1, 1, 1);

    STAT_ERR = uvm_reg_field::type_id::create("STAT_ERR", );
    STAT_ERR.configure(this, 1, 17, "W1C", 0, 'h0, 1, 1, 1);

    STAT_DISABLED = uvm_reg_field::type_id::create("STAT_DISABLED", );
    STAT_DISABLED.configure(this, 1, 18, "W1C", 0, 'h0, 1, 1, 1);

    STAT_STOPPED = uvm_reg_field::type_id::create("STAT_STOPPED", );
    STAT_STOPPED.configure(this, 1, 19, "W1C", 0, 'h0, 1, 1, 1);

    STAT_PAUSED = uvm_reg_field::type_id::create("STAT_PAUSED", );
    STAT_PAUSED.configure(this, 1, 20, "RO", 0, 'h0, 1, 0, 1);

    STAT_RESUMEWAIT = uvm_reg_field::type_id::create("STAT_RESUMEWAIT", );
    STAT_RESUMEWAIT.configure(this, 1, 21, "RO", 0, 'h0, 1, 0, 1);

    reserved3 = uvm_reg_field::type_id::create("reserved3", );
    reserved3.configure(this, 2, 22, "RO", 0, 'h0, 1, 0, 0);

    STAT_SRCTRIGINWAIT = uvm_reg_field::type_id::create("STAT_SRCTRIGINWAIT", );
    STAT_SRCTRIGINWAIT.configure(this, 1, 24, "RO", 0, 'h0, 1, 0, 1);

    STAT_DESTRIGINWAIT = uvm_reg_field::type_id::create("STAT_DESTRIGINWAIT", );
    STAT_DESTRIGINWAIT.configure(this, 1, 25, "RO", 0, 'h0, 1, 0, 1);

    STAT_TRIGOUTACKWAIT = uvm_reg_field::type_id::create("STAT_TRIGOUTACKWAIT", );
    STAT_TRIGOUTACKWAIT.configure(this, 1, 26, "RO", 0, 'h0, 1, 0, 1);

    reserved4 = uvm_reg_field::type_id::create("reserved4", );
    reserved4.configure(this, 5, 27, "RO", 0, 'h0, 1, 0, 0);

  endfunction
endclass

//CH_INTREN
class CH_INTREN extends uvm_reg;
  `uvm_object_utils(CH_INTREN)

  uvm_reg_field INTREN_DONE;
  uvm_reg_field INTREN_ERR;
  uvm_reg_field INTREN_DISABLED;
  uvm_reg_field INTREN_STOPPED;
  uvm_reg_field reserved1;
  uvm_reg_field INTREN_SRCTRIGINWAIT;
  uvm_reg_field INTREN_DESTRIGINWAIT;
  uvm_reg_field INTREN_TRIGOUTACKWAIT;
  uvm_reg_field reserved2;

  function new(string name = "CH_INTREN");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();

    INTREN_DONE = uvm_reg_field::type_id::create("INTREN_DONE", );
    INTREN_DONE.configure(this, 1, 0, "RW", 0, 'h0, 1, 1, 1);

    INTREN_ERR = uvm_reg_field::type_id::create("INTREN_ERR", );
    INTREN_ERR.configure(this, 1, 1, "RW", 0, 'h0, 1, 1, 1);

    INTREN_DISABLED = uvm_reg_field::type_id::create("INTREN_DISABLED", );
    INTREN_DISABLED.configure(this, 1, 2, "RW", 0, 'h0, 1, 1, 1);

    INTREN_STOPPED = uvm_reg_field::type_id::create("INTREN_STOPPED", );
    INTREN_STOPPED.configure(this, 1, 3, "RW", 0, 'h0, 1, 1, 1);

    reserved1 = uvm_reg_field::type_id::create("reserved1", );
    reserved1.configure(this, 4, 4, "RO", 0, 'h0, 1, 0, 0);

    INTREN_SRCTRIGINWAIT = uvm_reg_field::type_id::create("INTREN_SRCTRIGINWAIT", );
    INTREN_SRCTRIGINWAIT.configure(this, 1, 8, "RW", 0, 'h0, 1, 1, 1);

    INTREN_DESTRIGINWAIT = uvm_reg_field::type_id::create("INTREN_DESTRIGINWAIT", );
    INTREN_DESTRIGINWAIT.configure(this, 1, 9, "RW", 0, 'h0, 1, 1, 1);

    INTREN_TRIGOUTACKWAIT = uvm_reg_field::type_id::create("INTREN_TRIGOUTACKWAIT", );
    INTREN_TRIGOUTACKWAIT.configure(this, 1, 10, "RW", 0, 'h0, 1, 1, 1);

    reserved2 = uvm_reg_field::type_id::create("reserved2", );
    reserved2.configure(this, 21, 11, "RO", 0, 'h0, 1, 0, 0);

  endfunction
endclass

//CH_CTRL
// CH_CTRL Register Model
class CH_CTRL extends uvm_reg;
  `uvm_object_utils(CH_CTRL)

  uvm_reg_field TRANSIZE;
  uvm_reg_field reserved1;
  uvm_reg_field CHPRIO;
  uvm_reg_field reserved2;
  uvm_reg_field XTYPE;
  uvm_reg_field YTYPE;
  uvm_reg_field reserved3;
  uvm_reg_field REGRELOADTYPE;
  uvm_reg_field DONETYPE;
  uvm_reg_field DONEPAUSEEN;
  uvm_reg_field USESRCTRIGIN;
  uvm_reg_field USEDESTRIGIN;
  uvm_reg_field USETRIGOUT;
  uvm_reg_field USEGPO;
  uvm_reg_field USESTREAM;
  uvm_reg_field reserved4;

  function new(string name = "CH_CTRL");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();

    // TRANSIZE [2:0]
    TRANSIZE = uvm_reg_field::type_id::create("TRANSIZE", );
    TRANSIZE.configure(this, 3, 0, "RW", 0, 'h0, 1, 1, 1);

    // reserved [3]
    reserved1 = uvm_reg_field::type_id::create("reserved1", );
    reserved1.configure(this, 1, 3, "RO", 0, 'h0, 1, 0, 0);

    // CHPRIO [7:4]
    CHPRIO = uvm_reg_field::type_id::create("CHPRIO", );
    CHPRIO.configure(this, 4, 4, "RW", 0, 'h0, 1, 1, 1);

    // reserved [8]
    reserved2 = uvm_reg_field::type_id::create("reserved2", );
    reserved2.configure(this, 1, 8, "RO", 0, 'h0, 1, 0, 0);

    // XTYPE [11:9]
    XTYPE = uvm_reg_field::type_id::create("XTYPE", );
    XTYPE.configure(this, 3, 9, "RW", 0, 'h1, 1, 1, 1); // default 0x1

    // YTYPE [14:12]
    YTYPE = uvm_reg_field::type_id::create("YTYPE", );
    YTYPE.configure(this, 3, 12, "RW", 0, 'h0, 1, 1, 1);

    // reserved [17:15]
    reserved3 = uvm_reg_field::type_id::create("reserved3", );
    reserved3.configure(this, 3, 15, "RO", 0, 'h0, 1, 0, 0);

    // REGRELOADTYPE [20:18]
    REGRELOADTYPE = uvm_reg_field::type_id::create("REGRELOADTYPE", );
    REGRELOADTYPE.configure(this, 3, 18, "RW", 0, 'h0, 1, 1, 1);

    // DONETYPE [23:21]
    DONETYPE = uvm_reg_field::type_id::create("DONETYPE", );
    DONETYPE.configure(this, 3, 21, "RW", 0, 'h1, 1, 1, 1); // default 0x1

    // DONEPAUSEEN [24]
    DONEPAUSEEN = uvm_reg_field::type_id::create("DONEPAUSEEN", );
    DONEPAUSEEN.configure(this, 1, 24, "RW", 0, 'h0, 1, 1, 1);

    // USESRCTRIGIN [25]
    USESRCTRIGIN = uvm_reg_field::type_id::create("USESRCTRIGIN", );
    USESRCTRIGIN.configure(this, 1, 25, "RW", 0, 'h0, 1, 1, 1);

    // USEDESTRIGIN [26]
    USEDESTRIGIN = uvm_reg_field::type_id::create("USEDESTRIGIN", );
    USEDESTRIGIN.configure(this, 1, 26, "RW", 0, 'h0, 1, 1, 1);

    // USETRIGOUT [27]
    USETRIGOUT = uvm_reg_field::type_id::create("USETRIGOUT", );
    USETRIGOUT.configure(this, 1, 27, "RW", 0, 'h0, 1, 1, 1);

    // USEGPO [28]
    USEGPO = uvm_reg_field::type_id::create("USEGPO", );
    USEGPO.configure(this, 1, 28, "RW", 0, 'h0, 1, 1, 1);

    // USESTREAM [29]
    USESTREAM = uvm_reg_field::type_id::create("USESTREAM", );
    USESTREAM.configure(this, 1, 29, "RW", 0, 'h0, 1, 1, 1);

    // reserved [31:30]
    reserved4 = uvm_reg_field::type_id::create("reserved4", );
    reserved4.configure(this, 2, 30, "RO", 0, 'h0, 1, 0, 0);

  endfunction
endclass


//CH_SRCADDR

class CH_SRCADDR extends uvm_reg;
  `uvm_object_utils(CH_SRCADDR)

  uvm_reg_field SRCADDR;

  function new(string name = "CH_SRCADDR");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    SRCADDR = uvm_reg_field::type_id::create("SRCADDR", );
    SRCADDR.configure(this, 32, 0, "RW", 0, 'h0, 1, 0, 0);
  endfunction
endclass


//CH_SRCADDRHI

class CH_SRCADDRHI extends uvm_reg;
  `uvm_object_utils(CH_SRCADDRHI)

  uvm_reg_field SRCADDRHI;

  function new(string name = "CH_SRCADDRHI");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    SRCADDRHI = uvm_reg_field::type_id::create("SRCADDRHI", );
    SRCADDRHI.configure(this, 32, 0, "RW", 0, 'h0, 1, 0, 0);
  endfunction
endclass


//CH_DESADDR
class CH_DESADDR extends uvm_reg;
  `uvm_object_utils(CH_DESADDR)

  uvm_reg_field DESADDR;

  function new(string name = "CH_DESADDR");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    DESADDR = uvm_reg_field::type_id::create("DESADDR", );
    DESADDR.configure(this, 32, 0, "RW", 0, 'h0, 1, 0, 0);
  endfunction
endclass



//CH_DESADDRHI
class CH_DESADDRHI extends uvm_reg;
  `uvm_object_utils(CH_DESADDRHI)

  uvm_reg_field DESADDRHI;

  function new(string name = "CH_DESADDRHI");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    DESADDRHI = uvm_reg_field::type_id::create("DESADDRHI", );
    DESADDRHI.configure(this, 32, 0, "RW", 0, 'h0, 1, 0, 0);
  endfunction
endclass

//CH_XSIZE
class CH_XSIZE extends uvm_reg;
  `uvm_object_utils(CH_XSIZE)

  uvm_reg_field SRCXSIZE;
  uvm_reg_field DESXSIZE;

  function new(string name = "CH_XSIZE");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    SRCXSIZE = uvm_reg_field::type_id::create("SRCXSIZE", );
    SRCXSIZE.configure(this, 16, 0, "RW", 0, 'h0, 1, 0, 0);

    DESXSIZE = uvm_reg_field::type_id::create("DESXSIZE", );
    DESXSIZE.configure(this, 16, 16, "RW", 0, 'h0, 1, 0, 0);
  endfunction
endclass

//CH_XSIZEHI
class CH_XSIZEHI extends uvm_reg;
  `uvm_object_utils(CH_XSIZEHI)

  uvm_reg_field SRCXSIZEHI;
  uvm_reg_field DESXSIZEHI;

  function new(string name = "CH_XSIZEHI");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    SRCXSIZEHI = uvm_reg_field::type_id::create("SRCXSIZEHI");
    SRCXSIZEHI.configure(this, 16, 0, "RW", 0, 'h0, 1, 0, 0);

    DESXSIZEHI = uvm_reg_field::type_id::create("DESXSIZEHI");
    DESXSIZEHI.configure(this, 16, 16, "RW", 0, 'h0, 1, 0, 0);
  endfunction
endclass


//CH_SRCTRANSCFG
class CH_SRCTRANSCFG extends uvm_reg;
  `uvm_object_utils(CH_SRCTRANSCFG)

  uvm_reg_field SRCMEMATTRLO;
  uvm_reg_field SRCMEMATTRHI;
  uvm_reg_field SRCSHAREATTR;
  uvm_reg_field SRCNONSECATTR;
  uvm_reg_field SRCPRIVATTR;
  uvm_reg_field reserved1;
  uvm_reg_field SRCMAXBURSTLEN;
  uvm_reg_field reserved2;

  function new(string name = "CH_SRCTRANSCFG");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();

    // [3:0]
    SRCMEMATTRLO = uvm_reg_field::type_id::create("SRCMEMATTRLO");
    SRCMEMATTRLO.configure(this, 4, 0, "RW", 0, 'h0, 1, 0, 0);

    // [7:4]
    SRCMEMATTRHI = uvm_reg_field::type_id::create("SRCMEMATTRHI");
    SRCMEMATTRHI.configure(this, 4, 4, "RW", 0, 'h0, 1, 0, 0);

    // [9:8]
    SRCSHAREATTR = uvm_reg_field::type_id::create("SRCSHAREATTR");
    SRCSHAREATTR.configure(this, 2, 8, "RW", 0, 'h0, 1, 0, 0);

    // [10]
    SRCNONSECATTR = uvm_reg_field::type_id::create("SRCNONSECATTR");
    SRCNONSECATTR.configure(this, 1, 10, "RW", 0, 'h1, 1, 0, 0);

    // [11]
    SRCPRIVATTR = uvm_reg_field::type_id::create("SRCPRIVATTR");
    SRCPRIVATTR.configure(this, 1, 11, "RW", 0, 'h0, 1, 0, 0);

    // [15:12] Reserved
    reserved1 = uvm_reg_field::type_id::create("reserved1");
    reserved1.configure(this, 4, 12, "RO", 0, 'h0, 1, 0, 0);

    // [19:16]
    SRCMAXBURSTLEN = uvm_reg_field::type_id::create("SRCMAXBURSTLEN");
    SRCMAXBURSTLEN.configure(this, 4, 16, "RW", 0, 'hf, 1, 0, 0);

    // [31:20] Reserved
    reserved2 = uvm_reg_field::type_id::create("reserved2");
    reserved2.configure(this, 12, 20, "RO", 0, 'h0, 1, 0, 0);

  endfunction
endclass



//CH_DESTRANSCFG
class CH_DESTRANSCFG extends uvm_reg;
  `uvm_object_utils(CH_DESTRANSCFG)

  uvm_reg_field DESMEMATTRLO;
  uvm_reg_field DESMEMATTRHI;
  uvm_reg_field DESSHAREATTR;
  uvm_reg_field DESNONSECATTR;
  uvm_reg_field DESPRIVATTR;
  uvm_reg_field reserved1;
  uvm_reg_field DESMAXBURSTLEN;
  uvm_reg_field reserved2;

  function new(string name = "CH_DESTRANSCFG");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();

    // [3:0]
    DESMEMATTRLO = uvm_reg_field::type_id::create("DESMEMATTRLO");
    DESMEMATTRLO.configure(this, 4, 0, "RW", 0, 'h0, 1, 0, 0);

    // [7:4]
    DESMEMATTRHI = uvm_reg_field::type_id::create("DESMEMATTRHI");
    DESMEMATTRHI.configure(this, 4, 4, "RW", 0, 'h0, 1, 0, 0);

    // [9:8]
    DESSHAREATTR = uvm_reg_field::type_id::create("DESSHAREATTR");
    DESSHAREATTR.configure(this, 2, 8, "RW", 0, 'h0, 1, 0, 0);

    // [10]
    DESNONSECATTR = uvm_reg_field::type_id::create("DESNONSECATTR");
    DESNONSECATTR.configure(this, 1, 10, "RW", 0, 'h1, 1, 0, 0);

    // [11]
    DESPRIVATTR = uvm_reg_field::type_id::create("DESPRIVATTR");
    DESPRIVATTR.configure(this, 1, 11, "RW", 0, 'h0, 1, 0, 0);

    // [15:12] Reserved
    reserved1 = uvm_reg_field::type_id::create("reserved1");
    reserved1.configure(this, 4, 12, "RO", 0, 'h0, 1, 0, 0);

    // [19:16]
    DESMAXBURSTLEN = uvm_reg_field::type_id::create("DESMAXBURSTLEN");
    DESMAXBURSTLEN.configure(this, 4, 16, "RW", 0, 'hf, 1, 0, 0);

    // [31:20] Reserved
    reserved2 = uvm_reg_field::type_id::create("reserved2");
    reserved2.configure(this, 12, 20, "RO", 0, 'h0, 1, 0, 0);

  endfunction
endclass

//CH_XADDRINC
class CH_XADDRINC extends uvm_reg;
	`uvm_object_utils(CH_XADDRINC)
	
	rand uvm_reg_field SRCXADDRINC;
	rand uvm_reg_field DESXADDRINC;
	
	function new(string name = "CH_XADDRINC");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		SRCXADDRINC = uvm_reg_field::type_id::create("SRCXADDRINC");
		SRCXADDRINC.configure(.parent(this), 
							.size(16),
							.lsb_pos(0),
							.access("RW"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(1),
							.individually_accessible(1));
		DESXADDRINC = uvm_reg_field::type_id::create("DESXADDRINC");
		DESXADDRINC.configure(this, 16, 16, "RW", 0, 0, 1, 1, 1);
	endfunction 
endclass

//CH_YADDRSTRIDE
class CH_YADDRSTRIDE extends uvm_reg;
	`uvm_object_utils(CH_YADDRSTRIDE)
	
	rand uvm_reg_field SRCYADDRSTRIDE;
	rand uvm_reg_field DESYADDRSTRIDE;
	
	function new(string name = "CH_XADDRINC");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		SRCYADDRSTRIDE = uvm_reg_field::type_id::create("SRCYADDRSTRIDE");
		SRCYADDRSTRIDE.configure(.parent(this), 
							.size(16),
							.lsb_pos(0),
							.access("RW"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(1),
							.individually_accessible(1));
		DESYADDRSTRIDE = uvm_reg_field::type_id::create("DESYADDRSTRIDE");
		DESYADDRSTRIDE.configure(this, 16, 16, "RW", 0, 0, 1, 1, 1);
	endfunction 
endclass


//CH_FILLVAL
class CH_FILLVAL extends uvm_reg;
	`uvm_object_utils(CH_FILLVAL)
	
	rand uvm_reg_field FILLVAL;
	
	function new(string name = "CH_FILLVAL");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		FILLVAL = uvm_reg_field::type_id::create("FILLVAL");
		FILLVAL.configure(.parent(this), 
							.size(32),
							.lsb_pos(0),
							.access("RW"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(1),
							.individually_accessible(1));
	endfunction 
endclass

//CH_YSIZE
class CH_YSIZE extends uvm_reg;
	`uvm_object_utils(CH_YSIZE)
	
	rand uvm_reg_field SRCYSIZE;
	rand uvm_reg_field DESYSIZE;
	
	function new(string name = "CH_YSIZE");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		SRCYSIZE = uvm_reg_field::type_id::create("SRCYSIZE");
		SRCYSIZE.configure(.parent(this), 
							.size(16),
							.lsb_pos(0),
							.access("RW"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(1),
							.individually_accessible(1));
		DESYSIZE = uvm_reg_field::type_id::create("DESYSIZE");
		DESYSIZE.configure(this, 16, 16, "RW", 0, 0, 1, 1, 1);
	endfunction 
endclass


//CH_TMPLTCFG
class CH_TMPLTCFG extends uvm_reg;
	`uvm_object_utils(CH_TMPLTCFG)
	
	rand uvm_reg_field reserved1;
	rand uvm_reg_field SRCTMPLTSIZE;
	rand uvm_reg_field reserved2;
	rand uvm_reg_field DESTMPLTSIZE;
	rand uvm_reg_field reserved3;
	
	function new(string name = "CH_TMPLTCFG");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		reserved1 = uvm_reg_field::type_id::create("reserved1");
		reserved1.configure(.parent(this), 
							.size(8),
							.lsb_pos(0),
							.access("RW"),
							.volatile(1),
							.reset('h0),
							.has_reset(1),
							.is_rand(1),
							.individually_accessible(1));
		SRCTMPLTSIZE = uvm_reg_field::type_id::create("SRCTMPLTSIZE");
		SRCTMPLTSIZE.configure(this, 5, 8, "RW", 0, 0, 1, 1, 1);
		reserved2 = uvm_reg_field::type_id::create("reserved2");
		reserved2.configure(this, 3, 13, "RW", 1, 0, 1, 1, 1);
		DESTMPLTSIZE = uvm_reg_field::type_id::create("DESTMPLTSIZE");
		DESTMPLTSIZE.configure(this, 5, 16, "RW", 0, 0, 1, 1, 1);
		reserved3 = uvm_reg_field::type_id::create("reserved3");
		reserved3.configure(this, 11, 31, "RW", 1, 0, 1, 1, 1);
	endfunction 
endclass

//CH_SRCTMPLT
class CH_SRCTMPLT extends uvm_reg;
	`uvm_object_utils(CH_SRCTMPLT)
	
	uvm_reg_field SRCTMPLTLSB;
	rand uvm_reg_field SRCTMPLT;	
	
	function new(string name = "CH_SRCTMPLT");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		SRCTMPLTLSB = uvm_reg_field::type_id::create("SRCTMPLTLSB");
		SRCTMPLTLSB.configure(.parent(this), 
							.size(1),
							.lsb_pos(0),
							.access("RO"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(0),
							.individually_accessible(1));
		SRCTMPLT = uvm_reg_field::type_id::create("SRCTMPLT");
		SRCTMPLT.configure(this, 31, 1, "RW", 0, 0, 1, 1, 1);
	endfunction 
endclass

//CH_DESTMPLT

class CH_DESTMPLT extends uvm_reg;
	`uvm_object_utils(CH_DESTMPLT)
	
	uvm_reg_field DESTMPLTLSB;
	rand uvm_reg_field DESTMPLT;

	
	function new(string name = "CH_DESTMPLT");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		DESTMPLTLSB = uvm_reg_field::type_id::create("DESTMPLTLSB");
		DESTMPLTLSB.configure(.parent(this), 
							.size(1),
							.lsb_pos(0),
							.access("RO"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(0),
							.individually_accessible(1));
		DESTMPLT = uvm_reg_field::type_id::create("DESTMPLT");
		DESTMPLT.configure(this, 31, 1, "RW", 0, 0, 1, 1, 1);
	endfunction 
endclass


//CH_SRCTRIGINCFG

class CH_SRCTRIGINCFG extends uvm_reg;
	`uvm_object_utils(CH_SRCTRIGINCFG)
	
	rand uvm_reg_field SRCTRIGINSEL;
	rand uvm_reg_field SRCTRIGINTYPE;
	rand uvm_reg_field SRCTRIGINMODE;
	rand uvm_reg_field reserved1;
	rand uvm_reg_field SRCTRIGINBLKSIZE;
	rand uvm_reg_field reserved2;
	
	function new(string name = "CH_SRCTRIGINCFG");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		SRCTRIGINSEL = uvm_reg_field::type_id::create("SRCTRIGINSEL");
		SRCTRIGINSEL.configure(.parent(this), 
							.size(8),
							.lsb_pos(0),
							.access("RW"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(1),
							.individually_accessible(1));
		SRCTRIGINTYPE = uvm_reg_field::type_id::create("SRCTRIGINTYPE");
		SRCTRIGINTYPE.configure(this, 2, 8, "RW", 0, 0, 1, 1, 1);
		SRCTRIGINMODE = uvm_reg_field::type_id::create("SRCTRIGINMODE");
		SRCTRIGINMODE.configure(this, 2, 10, "RW", 0, 0, 1, 1, 1);
		reserved1 = uvm_reg_field::type_id::create("reserved1");
		reserved1.configure(this, 4, 12, "RW", 1, 0, 1, 1, 1);
		SRCTRIGINBLKSIZE = uvm_reg_field::type_id::create("SRCTRIGINBLKSIZE");
		SRCTRIGINBLKSIZE.configure(this, 8, 16, "RW", 0, 0, 1, 1, 1);
		reserved2 = uvm_reg_field::type_id::create("reserved2");
		reserved2.configure(this, 8, 24, "RW", 1, 0, 1, 1, 1);
	endfunction 
endclass

//CH_DESTRIGINCFG

class CH_DESTRIGINCFG extends uvm_reg;
	`uvm_object_utils(CH_DESTRIGINCFG)
	
	rand uvm_reg_field DESTRIGINSEL;
	rand uvm_reg_field DESTRIGINTYPE;
	rand uvm_reg_field DESTRIGINMODE;
	rand uvm_reg_field reserved1;
	rand uvm_reg_field DESTRIGINBLKSIZE;
	rand uvm_reg_field reserved2;
	
	function new(string name = "CH_SRCTRIGINCFG");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		DESTRIGINSEL = uvm_reg_field::type_id::create("DESTRIGINSEL");
		DESTRIGINSEL.configure(.parent(this), 
							.size(8),
							.lsb_pos(0),
							.access("RW"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(1),
							.individually_accessible(1));
		DESTRIGINTYPE = uvm_reg_field::type_id::create("DESTRIGINTYPE");
		DESTRIGINTYPE.configure(this, 2, 8, "RW", 0, 0, 1, 1, 1);
		DESTRIGINMODE = uvm_reg_field::type_id::create("DESTRIGINMODE");
		DESTRIGINMODE.configure(this, 2, 10, "RW", 0, 0, 1, 1, 1);
		reserved1 = uvm_reg_field::type_id::create("reserved1");
		reserved1.configure(this, 4, 12, "RW", 1, 0, 1, 1, 1);
		DESTRIGINBLKSIZE = uvm_reg_field::type_id::create("DESTRIGINBLKSIZE");
		DESTRIGINBLKSIZE.configure(this, 8, 16, "RW", 0, 0, 1, 1, 1);
		reserved2 = uvm_reg_field::type_id::create("reserved2");
		reserved2.configure(this, 8, 24, "RW", 1, 0, 1, 1, 1);
	endfunction 
endclass

//CH_TRIGOUTCFG

class CH_TRIGOUTCFG extends uvm_reg;
	`uvm_object_utils(CH_TRIGOUTCFG)
	
	rand uvm_reg_field TRIGOUTSEL;
	rand uvm_reg_field reserved1;
	rand uvm_reg_field TRIGOUTTYPE;
	rand uvm_reg_field reserved2;
	
	function new(string name = "CH_TRIGOUTCFG");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		TRIGOUTSEL = uvm_reg_field::type_id::create("TRIGOUTSEL");
		TRIGOUTSEL.configure(.parent(this), 
							.size(6),
							.lsb_pos(0),
							.access("RW"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(1),
							.individually_accessible(1));
		reserved1 = uvm_reg_field::type_id::create("reserved1");
		reserved1.configure(this, 2, 6, "RW", 1, 0, 1, 1, 1);
		TRIGOUTTYPE = uvm_reg_field::type_id::create("TRIGOUTTYPE");
		TRIGOUTTYPE.configure(this, 2, 8, "RW", 0, 0, 1, 1, 1);
		reserved2 = uvm_reg_field::type_id::create("reserved2");
		reserved2.configure(this, 22, 10, "RW", 1, 0, 1, 1, 1);
	endfunction 
endclass

//CH_GPOEN0

class CH_GPOEN0 extends uvm_reg;
	`uvm_object_utils(CH_GPOEN0)
	
	rand uvm_reg_field GPOEN0;
	
	function new(string name = "CH_GPOEN0");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		GPOEN0 = uvm_reg_field::type_id::create("GPOEN0");
		GPOEN0.configure(.parent(this), 
							.size(32),
							.lsb_pos(0),
							.access("RW"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(1),
							.individually_accessible(1));
	endfunction 
endclass

//CH_GPOVAL0

class CH_GPOVAL0 extends uvm_reg;
	`uvm_object_utils(CH_GPOVAL0)
	
	rand uvm_reg_field GPOVAL0;
	
	function new(string name = "CH_GPOVAL0");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		GPOVAL0 = uvm_reg_field::type_id::create("GPOVAL0");
		GPOVAL0.configure(.parent(this), 
							.size(32),
							.lsb_pos(0),
							.access("RW"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(1),
							.individually_accessible(1));
	endfunction 
endclass

// CH_STREAMINTCFG
class CH_STREAMINTCFG extends uvm_reg;
  `uvm_object_utils(CH_STREAMINTCFG)

  uvm_reg_field reserved1;
  uvm_reg_field STREAMTYPE;
  uvm_reg_field reserved2;

  function new(string name = "CH_STREAMINTCFG");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    // [8:0] Reserved
    reserved1 = uvm_reg_field::type_id::create("reserved1");
    reserved1.configure(this, 9, 0, "RO", 0, 'h0, 1, 0, 0);

    // [10:9] STREAMTYPE
    STREAMTYPE = uvm_reg_field::type_id::create("STREAMTYPE");
    STREAMTYPE.configure(this, 2, 9, "RW", 0, 'h0, 1, 0, 0);

    // [31:11] Reserved
    reserved2 = uvm_reg_field::type_id::create("reserved2");
    reserved2.configure(this, 21, 11, "RO", 0, 'h0, 1, 0, 0);
  endfunction
endclass
//CH_LINKATTR

class CH_LINKATTR extends uvm_reg;
	`uvm_object_utils(CH_LINKATTR)
	
	rand uvm_reg_field LINKMEMATTRLO;
	rand uvm_reg_field LINKMEMATTRHI;
	rand uvm_reg_field LINKSHAREATTR;
	rand uvm_reg_field reserved;
	
	function new(string name = "CH_LINKATTR");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		LINKMEMATTRLO = uvm_reg_field::type_id::create("LINKMEMATTRLO");
		LINKMEMATTRLO.configure(.parent(this), 
							.size(4),
							.lsb_pos(0),
							.access("RW"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(1),
							.individually_accessible(1));
		LINKMEMATTRHI = uvm_reg_field::type_id::create("LINKMEMATTRHI");
		LINKMEMATTRHI.configure(this, 4, 4, "RW", 0, 0, 1, 1, 1);
		LINKSHAREATTR = uvm_reg_field::type_id::create("LINKSHAREATTR");
		LINKSHAREATTR.configure(this, 2, 8, "RW", 0, 0, 1, 1, 1);
		reserved = uvm_reg_field::type_id::create("reserved");
		reserved.configure(this, 22, 10, "RW", 1, 0, 1, 1, 1);
	endfunction 
endclass

//CH_AUTOCFG

class CH_AUTOCFG extends uvm_reg;
	`uvm_object_utils(CH_AUTOCFG)
	
	rand uvm_reg_field CMDRESTARTCNT;
	rand uvm_reg_field CMDRESTARTINFEN;
	rand uvm_reg_field reserved;
	
	function new(string name = "CH_AUTOCFG");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		CMDRESTARTCNT = uvm_reg_field::type_id::create("CMDRESTARTCNT");
		CMDRESTARTCNT.configure(.parent(this), 
							.size(16),
							.lsb_pos(0),
							.access("RW"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(1),
							.individually_accessible(1));
		CMDRESTARTINFEN = uvm_reg_field::type_id::create("CMDRESTARTINFEN");
		CMDRESTARTINFEN.configure(this, 1, 16, "RW", 0, 0, 1, 1, 1);
		reserved = uvm_reg_field::type_id::create("reserved");
		reserved.configure(this, 15, 17, "RW", 1, 0, 1, 1, 1);
	endfunction 
endclass

//CH_LINKADDR
class CH_LINKADDR extends uvm_reg;
	`uvm_object_utils(CH_LINKADDR)
	
	rand uvm_reg_field LINKADDR;
	
	function new(string name = "CH_LINKADDR");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		LINKADDR = uvm_reg_field::type_id::create("LINKADDR");
		LINKADDR.configure(.parent(this), 
							.size(32),
							.lsb_pos(0),
							.access("RW"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(1),
							.individually_accessible(1));
	endfunction 
endclass

//CH_LINKADDRHI

class CH_LINKADDRHI extends uvm_reg;
	`uvm_object_utils(CH_LINKADDRHI)
	
	rand uvm_reg_field LINKADDRHI;
	
	function new(string name = "CH_LINKADDRHI");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		LINKADDRHI = uvm_reg_field::type_id::create("LINKADDRHI");
		LINKADDRHI.configure(.parent(this), 
							.size(32),
							.lsb_pos(0),
							.access("RW"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(1),
							.individually_accessible(1));
	endfunction 
endclass

//CH_GPOREAD0

class CH_GPOREAD0 extends uvm_reg;
	`uvm_object_utils(CH_GPOREAD0)
	
	uvm_reg_field GPOREAD0;
	
	function new(string name = "CH_GPOREAD0");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		GPOREAD0 = uvm_reg_field::type_id::create("GPOREAD0");
		GPOREAD0.configure(.parent(this), 
							.size(32),
							.lsb_pos(0),
							.access("RO"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(0),
							.individually_accessible(1));
	endfunction 
endclass

//CH_WRKREGPTR

class CH_WRKREGPTR extends uvm_reg;
	`uvm_object_utils(CH_WRKREGPTR)
	
	rand uvm_reg_field WRKREGPTR;
	rand uvm_reg_field reserved;
	
	function new(string name = "CH_WRKREGPTR");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		WRKREGPTR = uvm_reg_field::type_id::create("WRKREGPTR");
		WRKREGPTR.configure(.parent(this), 
							.size(4),
							.lsb_pos(0),
							.access("RW"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(1),
							.individually_accessible(1));
		reserved = uvm_reg_field::type_id::create("reserved");
		reserved.configure(this, 28, 4, "RW", 1, 0, 1, 1, 1);
	endfunction 
endclass

//CH_WRKREGVAL

class CH_WRKREGVAL extends uvm_reg;
	`uvm_object_utils(CH_WRKREGVAL)
	
	uvm_reg_field WRKREGVAL;
	
	function new(string name = "CH_WRKREGVAL");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		WRKREGVAL = uvm_reg_field::type_id::create("WRKREGVAL");
		WRKREGVAL.configure(.parent(this), 
							.size(32),
							.lsb_pos(0),
							.access("RO"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(0),
							.individually_accessible(1));
	endfunction 
endclass

//CH_ERRINFO

class CH_ERRINFO extends uvm_reg;
  `uvm_object_utils(CH_ERRINFO)

  uvm_reg_field BUSERR;
  uvm_reg_field CFGERR;
  uvm_reg_field SRCTRIGINSELERR;
  uvm_reg_field DESTRIGINSELERR;
  uvm_reg_field TRIGOUTSELERR;
  uvm_reg_field reserved1;
  uvm_reg_field STREAMERR;
  uvm_reg_field reserved2;
  uvm_reg_field ERRINFO;

  function new(string name = "CH_ERRINFO");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();

    // [0]
    BUSERR = uvm_reg_field::type_id::create("BUSERR");
    BUSERR.configure(this, 1, 0, "RO", 0, 'h0, 1, 0, 0);

    // [1]
    CFGERR = uvm_reg_field::type_id::create("CFGERR");
    CFGERR.configure(this, 1, 1, "RO", 0, 'h0, 1, 0, 0);

    // [2]
    SRCTRIGINSELERR = uvm_reg_field::type_id::create("SRCTRIGINSELERR");
    SRCTRIGINSELERR.configure(this, 1, 2, "RO", 0, 'h0, 1, 0, 0);

    // [3]
    DESTRIGINSELERR = uvm_reg_field::type_id::create("DESTRIGINSELERR");
    DESTRIGINSELERR.configure(this, 1, 3, "RO", 0, 'h0, 1, 0, 0);

    // [4]
    TRIGOUTSELERR = uvm_reg_field::type_id::create("TRIGOUTSELERR");
    TRIGOUTSELERR.configure(this, 1, 4, "RO", 0, 'h0, 1, 0, 0);

    // [6:5] Reserved
    reserved1 = uvm_reg_field::type_id::create("reserved1");
    reserved1.configure(this, 2, 5, "RO", 0, 'h0, 1, 0, 0);

    // [7]
    STREAMERR = uvm_reg_field::type_id::create("STREAMERR");
    STREAMERR.configure(this, 1, 7, "RO", 0, 'h0, 1, 0, 0);

    // [15:8] Reserved
    reserved2 = uvm_reg_field::type_id::create("reserved2");
    reserved2.configure(this, 8, 8, "RO", 0, 'h0, 1, 0, 0);

    // [31:16]
    ERRINFO = uvm_reg_field::type_id::create("ERRINFO");
    ERRINFO.configure(this, 16, 16, "RO", 0, 'h0, 1, 0, 0);

  endfunction
endclass

//CH_IIDR

class CH_IIDR extends uvm_reg;
	`uvm_object_utils(CH_IIDR)
	
	uvm_reg_field IMPLEMENTER;
	uvm_reg_field REVISION;
	uvm_reg_field VARIANT;
	uvm_reg_field PRODUCTID;
	
	function new(string name = "CH_IIDR");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		IMPLEMENTER = uvm_reg_field::type_id::create("IMPLEMENTER");
		IMPLEMENTER.configure(.parent(this), 
							.size(12),
							.lsb_pos(0),
							.access("RO"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(0),
							.individually_accessible(1));
		REVISION = uvm_reg_field::type_id::create("REVISION");
		REVISION.configure(this, 4, 12, "RO", 0, 0, 1, 0, 1);
		VARIANT = uvm_reg_field::type_id::create("VARIANT");
		VARIANT.configure(this, 4, 16, "RO", 0, 0, 1, 0, 1);
		PRODUCTID = uvm_reg_field::type_id::create("PRODUCTID");
		PRODUCTID.configure(this, 12, 20, "RO", 0, 0, 1, 0, 1);
	endfunction 
endclass

//CH_AIDR

class CH_AIDR extends uvm_reg;
	`uvm_object_utils(CH_AIDR)
	
	uvm_reg_field ARCH_MINOR_REV;
	uvm_reg_field ARCH_MAJOR_REV;
	rand uvm_reg_field reserved;
	
	function new(string name = "CH_AIDR");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		ARCH_MINOR_REV = uvm_reg_field::type_id::create("ARCH_MINOR_REV");
		ARCH_MINOR_REV.configure(.parent(this), 
							.size(4),
							.lsb_pos(0),
							.access("RO"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(0),
							.individually_accessible(1));
		ARCH_MAJOR_REV = uvm_reg_field::type_id::create("ARCH_MAJOR_REV");
		ARCH_MAJOR_REV.configure(this, 4, 4, "RO", 0, 0, 1, 0, 1);
		reserved = uvm_reg_field::type_id::create("reserved");
		reserved.configure(this, 24, 8, "RW", 1, 0, 1, 1, 1);
	endfunction 
endclass


//CH_ISSUECAP

class CH_ISSUECAP extends uvm_reg;
	`uvm_object_utils(CH_ISSUECAP)
	
	rand uvm_reg_field ISSUECAP;
	rand uvm_reg_field reserved;
	
	function new(string name = "CH_ISSUECAP");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		ISSUECAP = uvm_reg_field::type_id::create("ISSUECAP");
		ISSUECAP.configure(.parent(this), 
							.size(3),
							.lsb_pos(0),
							.access("RW"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(1),
							.individually_accessible(1));
		reserved = uvm_reg_field::type_id::create("reserved");
		reserved.configure(this, 29, 3, "RW", 1, 0, 1, 1, 1);
	endfunction 
endclass

//CH_BUILDCFG0

class CH_BUILDCFG0 extends uvm_reg;
	`uvm_object_utils(CH_BUILDCFG0)
	
	uvm_reg_field DATA_BUFF_SIZE;
	uvm_reg_field CMD_BUFF_SIZE;
	uvm_reg_field ADDR_WIDTH;
	uvm_reg_field DATA_WIDTH;
	rand uvm_reg_field reserved1;
	uvm_reg_field INC_WIDTH;
	rand uvm_reg_field reserved2;

	function new(string name = "CH_BUILDCFG0");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		DATA_BUFF_SIZE = uvm_reg_field::type_id::create("DATA_BUFF_SIZE");
		DATA_BUFF_SIZE.configure(.parent(this), 
							.size(8),
							.lsb_pos(0),
							.access("RO"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(0),
							.individually_accessible(1));
		CMD_BUFF_SIZE = uvm_reg_field::type_id::create("CMD_BUFF_SIZE");
		CMD_BUFF_SIZE.configure(this, 8, 8, "RO", 0, 0, 1, 0, 1);
		ADDR_WIDTH = uvm_reg_field::type_id::create("ADDR_WIDTH");
		ADDR_WIDTH.configure(this, 6, 16, "RO", 0, 0, 1, 0, 1);
		DATA_WIDTH = uvm_reg_field::type_id::create("DATA_WIDTH");
		DATA_WIDTH.configure(this, 3, 22, "RO", 0, 0, 1, 0, 1);
		reserved1 = uvm_reg_field::type_id::create("reserved1");
		reserved1.configure(this, 1, 25, "RW", 1, 0, 1, 1, 1);
		INC_WIDTH = uvm_reg_field::type_id::create("INC_WIDTH");
		INC_WIDTH.configure(this, 4, 26, "RO", 0, 0, 1, 0, 1);
		reserved2 = uvm_reg_field::type_id::create("reserved2");
		reserved2.configure(this, 2, 31, "RW", 1, 0, 1, 1, 1);
	endfunction 
endclass

//CH_BUILDCFG1

class CH_BUILDCFG1 extends uvm_reg;
	`uvm_object_utils(CH_BUILDCFG1)
	
	uvm_reg_field HAS_XSIZEHI;
	uvm_reg_field HAS_WRAP;
	uvm_reg_field HAS_2D;
	uvm_reg_field HAS_TMPLT;
	uvm_reg_field HAS_TRIG;
	uvm_reg_field HAS_TRIGIN;
	uvm_reg_field HAS_TRIGOUT;
	uvm_reg_field HAS_TRIGSEL;
	uvm_reg_field HAS_CMDLINK;
	uvm_reg_field HAS_AUTO;
	uvm_reg_field HAS_WRKREG;
	uvm_reg_field HAS_STREAM;
	uvm_reg_field HAS_STREAMSEL;
	rand uvm_reg_field reserved1;
	uvm_reg_field HAS_GPOSEL;
	uvm_reg_field GPO_WIDTH;
	rand uvm_reg_field reserved2;
	
	function new(string name = "CH_BUILDCFG1");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction 
	
	function void build;
		HAS_XSIZEHI = uvm_reg_field::type_id::create("HAS_XSIZEHI");
		HAS_XSIZEHI.configure(.parent(this), 
							.size(1),
							.lsb_pos(0),
							.access("RO"),
							.volatile(0),
							.reset('h0),
							.has_reset(1),
							.is_rand(0),
							.individually_accessible(1));
		HAS_WRAP = uvm_reg_field::type_id::create("HAS_WRAP");
		HAS_WRAP.configure(this, 1, 1, "RO", 0, 0, 1, 0, 1);
		HAS_2D = uvm_reg_field::type_id::create("HAS_2D");
		HAS_2D.configure(this, 1, 2, "RO", 0, 0, 1, 0, 1);
		HAS_TMPLT = uvm_reg_field::type_id::create("HAS_TMPLT");
		HAS_TMPLT.configure(this, 1, 3, "RO", 0, 0, 1, 0, 1);
		HAS_TRIG = uvm_reg_field::type_id::create("HAS_TRIG");
		HAS_TRIG.configure(this, 1, 4, "RO", 0, 0, 1, 0, 1);
		HAS_TRIGIN = uvm_reg_field::type_id::create("HAS_TRIGIN");
		HAS_TRIGIN.configure(this, 1, 5, "RO", 0, 0, 1, 0, 1);
		HAS_TRIGOUT = uvm_reg_field::type_id::create("HAS_TRIGOUT");
		HAS_TRIGOUT.configure(this, 1, 6, "RO", 0, 0, 1, 0, 1);
		HAS_TRIGSEL = uvm_reg_field::type_id::create("HAS_TRIGSEL");
		HAS_TRIGSEL.configure(this, 1, 7, "RO", 0, 0, 1, 0, 1);
		HAS_CMDLINK = uvm_reg_field::type_id::create("HAS_CMDLINK");
		HAS_CMDLINK.configure(this, 1, 8, "RO", 0, 0, 1, 0, 1);
		HAS_AUTO = uvm_reg_field::type_id::create("HAS_AUTO");
		HAS_AUTO.configure(this, 1, 9, "RO", 0, 0, 1, 0, 1);
		HAS_WRKREG = uvm_reg_field::type_id::create("HAS_WRKREG");
		HAS_WRKREG.configure(this, 1, 10, "RO", 0, 0, 1, 0, 1);
		HAS_STREAM = uvm_reg_field::type_id::create("HAS_STREAM");
		HAS_STREAM.configure(this, 1, 11, "RO", 0, 0, 1, 0, 1);
		HAS_STREAMSEL = uvm_reg_field::type_id::create("HAS_STREAMSEL");
		HAS_STREAMSEL.configure(this, 1, 12, "RO", 0, 0, 1, 0, 1);
		reserved1 = uvm_reg_field::type_id::create("reserved1");
		reserved1.configure(this, 5, 13, "RW", 1, 0, 1, 1, 1);
		HAS_GPOSEL = uvm_reg_field::type_id::create("HAS_GPOSEL");
		HAS_GPOSEL.configure(this, 1, 18, "RO", 0, 0, 1, 0, 1);
		GPO_WIDTH = uvm_reg_field::type_id::create("GPO_WIDTH");
		GPO_WIDTH.configure(this, 7, 19, "RO", 0, 0, 1, 0, 1);
		reserved2 = uvm_reg_field::type_id::create("reserved1");
		reserved2.configure(this, 6, 26, "RW", 1, 0, 1, 1, 1);
	endfunction 
endclass

