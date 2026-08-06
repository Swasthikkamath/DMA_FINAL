`ifndef DMAGLOBALPKG_INCLUDED
`define DMAGLOBALPKG_INCLUDED

package dmaGlobalPkg;
import axi4_globals_pkg :: *;
parameter noOfRegInChannel =32;
parameter NUM_CHANNELS = 2;
parameter M1_ENABLED =1;
parameter HAS_2D = 1;
parameter DATA_WIDTH_CFG = $clog2((axi4_globals_pkg :: DATA_WIDTH)/8);
parameter ADDRESS_WIDTH_CFG = $clog2((axi4_globals_pkg :: ADDRESS_WIDTH/8));

typedef enum{
  SINGLE,
  LAST_SINGLE,
  BLOCK,
  LAST_BLOCK
}trigReqEnum;

typedef enum bit[2:0]{
    X_DISABLE = 3'b000,
    X_CONTINUE= 3'b001,
    X_WRAP    = 3'b010,
    X_FILL    = 3'b011
  }xTypeEnum;

typedef enum bit[2:0]{
    Y_DISABLE = 3'b000,
    Y_CONTINUE= 3'b001,
    Y_WRAP    = 3'b010,
    Y_FILL    = 3'b011
  }yTypeEnum;



typedef struct packed{
  bit[6:0] reserved3;
  bit SWTRIGOUTACK;
  bit reserved2;
  bit [1:0] DESSWTRIGINTYPE;
  bit DESSWTRIGINREQ;
  bit reserved1;
  bit [1:0]SRCSWTRIGINTYPE;
  bit SRCSWTRIGINREQ;
  bit[9:0] reserved0;
  bit RESUMECMD;
  bit PAUSECMD;
  bit STOPCMD;
  bit DISABLECMD;
  bit CLEARCMD;
  bit ENABLECMD;
}CH_CMD_FIELD;

typedef struct packed{
  bit[7:0]reserved1;
  bit[7:0]SRCTRIGINBLKSIZE;
  bit[3:0]reserved0;
  bit[1:0]SRCTRIGINMODE;
  bit[1:0]SRCTRIGINTYPE;
  bit[7:0]SRCTRIGINSEL;
}CH_SRCTRIGINCFG_FIELD;

typedef struct packed{
  bit[7:0]reserved1;
  bit[7:0]DESTRIGINBLKSIZE;
  bit[3:0]reserved0;
  bit[1:0]DESTRIGINMODE;
  bit[1:0]DESTRIGINTYPE;
  bit[7:0]DESTRIGINSEL;


}CH_DESTRIGINCFG_FIELD;

typedef enum{cfgError,srcTrigInError,desTrigInError,trigOutError,busError}errorInfoEnum;
typedef struct packed{
  bit[4:0] reserved3;
  bit      STAT_TRIGOUTACKWAIT;
  bit      STAT_DESTRIGINWAIT;
  bit      STAT_SRCTRIGINWAIT;
  bit[1:0] reserved2;
  bit      STAT_RESUMEWAIT;
  bit      STAT_PAUSED;
  bit      STAT_STOPPED;
  bit      STAT_DISABLED;
  bit      STAT_ERR;
  bit      STAT_DONE;
  bit[4:0] reserved1;
  bit      INTR_TRIGOUTACKWAIT;
  bit      INTR_DESTRIGINWAIT;
  bit      INTR_SRCTRIGINWAIT;
  bit[3:0] reserved0;
  bit      INTR_STOPPED;
  bit      INTR_DISABLED;
  bit      INTR_ERR;
  bit      INTR_DONE;
}CH_STATUS_FIELD;


typedef struct packed{
  bit[20:0] reserved1;
  bit       INTREN_TRIGOUTACKWAIT;
  bit       INTREN_DESTRIGINWAIT;
  bit       INTREN_SRCTRIGINWAIT;
  bit[3:0] reserved0;
  bit      INTREN_STOPPED;
  bit      INTREN_DISABLED;
  bit      INTREN_ERR;
  bit      INTREN_DONE;
} CH_INTREN_FIELD;

typedef struct packed{
  bit[1:0] reserved3;
  bit      USESTREAM;
  bit      USEGPO;
  bit      USETRIGOUT;
  bit      USEDESTRIGIN;
  bit      USESRCTRIGIN;
  bit      DONEPAUSEEN;
  bit[2:0] DONETYPE;
  bit[2:0] REGRELOADTYPE;
  bit[2:0] reserved2;
  yTypeEnum YTYPE;
  xTypeEnum XTYPE;
  bit      reserved1;
  bit[3:0] CHPRIO;
  bit      reserved0;
  bit[2:0] TRANSIZE;
}CH_CTRL_FIELD;


typedef struct packed{
  bit[31:0] SRCADDR;
}CH_SRCADDR_FIELD;

typedef struct packed{
  bit[31:0] SRCADDRHI;
}CH_SRCADDRHI_FIELD;

typedef struct packed{
  bit[31:0]  DESADDR;
}CH_DESADDR_FIELD;

typedef struct packed{
  bit[31:0]  DESADDRHI;
}CH_DESADDRHI_FIELD;


typedef struct packed{
  bit[15:0] DESXSIZE;
  bit[15:0] SRCXSIZE;
}CH_XSIZE_FIELD;

typedef struct packed{
  bit[15:0] DESXSIZEHI;
  bit[15:0] SRCXSIZEHI;
}CH_XSIZEHI_FIELD;

typedef struct packed{
  bit[11:0] reserved1;
  bit[3:0] SRCMAXBURSTLEN;
  bit[3:0] reserved0;
  bit      SRCPRIVATTR;
  bit      SRCNONSECATTR;
  bit[1:0] SRCSHAREATTR;
  bit[3:0] SRCMEMATTRHI;
  bit[3:0] SRCMEMATTRLO;
}CH_SRCTRANSCFG_FIELD;

typedef struct packed{
  bit[11:0] reserved3;
  bit[3:0] DESMAXBURSTLEN;
  bit[3:0] reserved2;
  bit DESPRIVATTR;
  bit DESNONSECATTR;
  bit[1:0] DESSHAREATTR;
  bit[3:0] DESMEMATTRHI;
  bit[3:0] DESMEMATTRLO;
}CH_DESTRANSCFG_FIELD;


typedef struct packed{
  bit[15:0] DESXADDRINC;
  bit[15:0] SRCXADDRINC;
}CH_XADDRINC_FIELD;


typedef struct packed{
  bit[15:0] DESYADDRSTRIDE;
  bit[15:0] SRCYADDRSTRIDE;
}CH_YADDRSTRIDE_FIELD;

typedef struct packed{
  bit[31:0] FILLVAL;
}CH_FILLVAL_FIELD;

typedef struct packed{
  bit[15:0] DESYSIZE;
  bit[15:0] SRCYSIZE;
}CH_YSIZE_FIELD;

typedef struct packed{
  bit[10:0] reserved2;
  bit[4:0]  DESTMPLTSIZE;
  bit[2:0]  reserved1;
  bit[4:0]  SRCTMPLTSIZE;
  bit[7:0]  reserved0; 
}CH_TMPLTCFG_FIELD;

typedef struct packed{
  bit[30:0] SRCTMPLT;
  bit       SRCTMPLTLSB;
}CH_SRCTMPLT_FIELD;

typedef struct packed{
  bit[30:0] DESTMPLT;
  bit       DESTMPLTLSB;
}CH_DESTMPLT_FIELD;

typedef struct packed{
  bit[21:0]reserved1;
  bit[1:0]TRIGOUTTYPE;
  bit[1:0]reserved0;
  bit[5:0]TRIGOUTSEL;  
  }CH_TRIGOUTCFG_FIELD;

typedef struct packed{
  bit[31:0]GPOEN0;
  }CH_GPOEN0_FIELD;

typedef struct packed{
  bit[31:0]GPOVAL0;
  }CH_GPOVAL0_FIELD;


typedef struct packed{
  bit[20:0]reserved1;
  bit[1:0]STREAMTYPE;
  bit[8:0]reserved0;
    }CH_STREAMINTCFG_FIELD;

typedef struct packed{
  bit[21:0]reserved1;
  bit[1:0]LINKSHAREATTR;
  bit[3:0]LINKMEMATTRHI;
  bit[3:0]LINKMEMATTRLO;
    }CH_LINKATTR_FIELD;

typedef struct packed{
  bit[14:0]reserved1;
  bit CMDRESTARTINFEN;
  bit[15:0]CMDRESTARTCNT;
  }CH_AUTOCFG_FIELD;

typedef struct packed{
  bit[29:0]LINKADDR;
  bit reserved0;
  bit LINKADDREN;
    }CH_LINKADDR_FIELD;

 typedef struct packed{
  bit[31:0]LINKADDRHI;
  }CH_LINKADDRHI_FIELD;

 typedef struct packed{
  bit[31:0]GPOREAD0;
  }CH_GPOREAD0_FIELD;

 typedef struct packed{
  bit[3:0]WRKREGPTR;
  bit[27:0]reserved0;
  }CH_WRKREGPTR_FIELD;

 typedef struct packed{
  bit[31:0]WRKREGVAL;
   }CH_WRKREGVAL_FIELD;



 typedef struct packed{
  bit[4:0]reserved1;
  bit CFGCONFLERR;
  bit REGVALERR;
  bit LINKHDERR;
  bit[1:0]reserved0;
  bit STRINEARLYTERM;
  bit STRINOVERRUN;
  bit STRINTSTRBERR;
  bit AXIRDPOISERR;
  bit AXIWRRESPERR;
  bit AXIRDRESPERR;
 }ERRINFO_FIELD;

 typedef struct packed{
  ERRINFO_FIELD ERRINFO;
  bit[7:0]reserved1;
  bit STREAMERR;
  bit[1:0]reserved0;
  bit TRIGOUTSELERR;
  bit DESTRIGINSELERR;
  bit SRCTRIGINSELERR;
  bit CFGERR;
  bit BUSERR;
   }CH_ERRINFO_FIELD;

 typedef struct packed{
  bit[11:0]PRODUCTID;
  bit[3:0]VARIANT;
  bit[3:0]REVISION;
  bit[11:0]IMPLEMENTER;
  } CH_IIDR_FIELD;

typedef struct packed{
  bit[23:0]PRODUCTID;
  bit[7:0]VARIANT;
  bit[7:0]REVISION;
  }CH_AIDR_FIELD;

typedef struct packed{
  bit[28:0]reserved0;
  bit[2:0]ISSUECAP;
  }CH_ISSUECAP_FIELD;

typedef struct packed{
  bit[1:0]reserved0;
  bit[3:0]INC_WIDTH;
  bit reserved1;
  bit[2:0]DATA_WIDTH;
  bit[5:0]ADDR_WIDTH;
  bit[7:0]CMD_BUFF_SIZE;
  bit[7:0]DATA_BUFF_SIZE;
  }CH_BUILDCFG0_FIELD;

  typedef struct packed{
  bit[5:0]reserved0;
  bit[6:0]GPO_WIDTH;
  bit HAS_GPOSEL;
  bit[4:0]reserved1;
  bit HAS_STREAMSEL;
  bit HAS_STREAM;
  bit HAS_WRKREG;
  bit HAS_AUTO;
  bit HAS_CMDLINK;
  bit HAS_TRIGSEL;
  bit HAS_TRIGOUT;
  bit HAS_TRIGIN;
  bit HAS_TRIG;
  bit HAS_TMPLT;
  bit HAS_2D;
  bit HAS_WRAP;
  bit HAS_XSIZEHI;
  } CH_BUILDCFG1_FIELD;

  typedef struct packed{
  bit[23:0]reserved0;
  bit[3:0]DES_0;
  bit[3:0]PART_1;
   }PIDR1_FIELD;

  typedef struct packed{
  bit[23:0]reserved0;
  bit[3:0]REVISION;
  bit JEDEC;
  bit[2:0]DES_1;
   }PIDR2_FIELD;

 typedef struct packed{
  bit[23:0]reserved0;
  bit[3:0]REVAND;
  bit[3:0]CMOD;
   }PIDR3_FIELD;

typedef struct {
  bit[6:0] reserved2;
  bit[4:0] CHID_WIDTH;
  bit      reserved1;
  bit[2:0] DATA_WIDTH;
  bit[5:0] ADDR_WIDTH;
  bit[5:0] NUM_CHANNELS =1;
  bit       reserved0;
  bit[2:0] FRAMETYPE;
}DMA_BUILDCFG0_FIELD;


typedef struct {
  bit[6:0] reserved2;
  bit      reserved1;
  bit[6:0] reserved0;
  bit      HAS_TRIGSEL = 1;
  bit[6:0] NUM_TRIGGER_OUT=(axi4_globals_pkg :: NO_OF_SLAVES);
  bit[8:0] NUM_TRIGGER_IN =(axi4_globals_pkg :: NO_OF_SLAVES);
}DMA_BUILDCFG1_FIELD;


typedef struct {
  bit[19:0] reserved3;
  bit       reserved2;
  bit       reserved1;
  bit       HAS_RET;
  bit       HAS_TZ;
  bit       HAS_GPOSEL;
  bit[6:0]  reserved0;
}DMA_BUILDCFG2_FIELD;


typedef struct packed{
  bit[11:0] PRODUCTID;
  bit[3:0]  VARIANT;
  bit[3:0]  REVISION;
  bit[11:0] IMPLEMENTER;
}IIDR_FIELD;

typedef struct packed{
  bit[23:0] reserved0;
  bit[3:0]  ARCH_MAJOR_REV;
  bit[3:0]  ARCH_MINOR_REV;
}AIDR_FIELD;


typedef struct packed{
  bit[23:0] reserved0;
  bit[3:0] SIZE;
  bit[3:0] DES_2;
}PIDR4_FIELD;


typedef struct packed{
  bit[23:0] reserved0;
  bit[7:0] PART_0;
}PIDR0_FIELD;


typedef struct packed{
  bit[23:0] reserved0;
  bit[7:0] PRMBL_0;
}CIDR0_FIELD;


typedef struct packed{
  bit[23:0] reserved0;
  bit[3:0] CLASS;
  bit[3:0] PRMBL_1;
}CIDR1_FIELD;

typedef struct packed{
  bit[23:0] reserved0;
  bit[7:0] PRMBL_2;
}CIDR2_FIELD;

typedef struct packed{
  bit[23:0] reserved0;
  bit[7:0] PRMBL_3;
}CIDR3_FIELD;


typedef struct packed  {
 CH_BUILDCFG1_FIELD    CH_BUILDCFG1;
 CH_BUILDCFG0_FIELD    CH_BUILDCFG0;
 CH_ISSUECAP_FIELD     CH_ISSUECAP;
 CH_AIDR_FIELD         CH_AIDR;
 CH_IIDR_FIELD         CH_IIDR;
 CH_ERRINFO_FIELD      CH_ERRINFO;
 CH_WRKREGVAL_FIELD    CH_WRKREGVAL;
 CH_WRKREGPTR_FIELD    CH_WRKREGPTR;
 bit[31:0]reserved3;
 CH_GPOREAD0_FIELD     CH_GPOREAD0;
 CH_LINKADDRHI_FIELD   CH_LINKADDRHI;
 CH_LINKADDR_FIELD     CH_LINKADDR;
 CH_AUTOCFG_FIELD      CH_AUTOCFG;
 CH_LINKATTR_FIELD     CH_LINKATTR;
 bit[31:0]reserved2;
 CH_STREAMINTCFG_FIELD CH_STREAMINTCFG;
 bit [31:0] reserved1;
 CH_GPOVAL0_FIELD      CH_GPOVAL0;
 bit[31:0] reserved0;
 CH_GPOEN0_FIELD       CH_GPOEN0;
 CH_TRIGOUTCFG_FIELD   CH_TRIGOUTCFG;
 CH_DESTRIGINCFG_FIELD CH_DESTRIGINCFG;
 CH_SRCTRIGINCFG_FIELD CH_SRCTRIGINCFG;
 CH_DESTMPLT_FIELD     CH_DESTMPLT;
 CH_SRCTMPLT_FIELD     CH_SRCTMPLT;
 CH_TMPLTCFG_FIELD     CH_TMPLTCFG;
 CH_YSIZE_FIELD        CH_YSIZE;
 CH_FILLVAL_FIELD      CH_FILLVAL;
 CH_YADDRSTRIDE_FIELD  CH_YADDRSTRIDE;
 CH_XADDRINC_FIELD     CH_XADDRINC;
 CH_DESTRANSCFG_FIELD  CH_DESTRANSCFG;
 CH_SRCTRANSCFG_FIELD  CH_SRCTRANSCFG;
 CH_XSIZEHI_FIELD      CH_XSIZEHI;
 CH_XSIZE_FIELD        CH_XSIZE;
 CH_DESADDRHI_FIELD    CH_DESADDRHI;
 CH_DESADDR_FIELD      CH_DESADDR;
 CH_SRCADDRHI_FIELD    CH_SRCADDRHI;
 CH_SRCADDR_FIELD      CH_SRCADDR;
 CH_CTRL_FIELD         CH_CTRL;
 CH_INTREN_FIELD       CH_INTREN;
 CH_STATUS_FIELD       CH_STATUS;
 CH_CMD_FIELD          CH_CMD;
} dmaChannelReg;

typedef struct{
  DMA_BUILDCFG0_FIELD DMA_BUILDCFG0;
  DMA_BUILDCFG1_FIELD DMA_BUILDCFG1;
  DMA_BUILDCFG2_FIELD DMA_BUILDCFG2;
  IIDR_FIELD IIDR;
  AIDR_FIELD AIDR;
  PIDR4_FIELD PIDR4;
  PIDR0_FIELD PIDR0;
  PIDR1_FIELD PIDR1;
  PIDR2_FIELD PIDR2;
  PIDR3_FIELD PIDR3;
  CIDR0_FIELD CIDR0;
  CIDR1_FIELD CIDR1;
  CIDR2_FIELD CIDR2;
  CIDR3_FIELD CIDR3;
}dmaInfo;

typedef enum bit{emptyCommand,nonEmpty }initialCommandType;
endpackage

`endif
