000100170131       // %CSTD==========================================================*
000200170131       //  Application. : SAM Arcad Sample application                   *
000300170131       //  Component. . : HSR200                        Type: RPG        *
000400170131       // ===============================================================*
000500170131       //  Sub-system . : TRD   Trade                                    *
000600170131       //  Function . . : SAL   Sales                                    *
000700170131       //  Sub-function :                                                *
000800170131       // %S=============================================================*
000900170131       //  Description of functionalities :                              *
001000170131       //                                                                *
001100170131       //                                                                *
001200170131       //                                                                *
001300170131       // %E=============================================================*
001400170131       //  AUTHOR:                           00:00                       *
001500170131       //  MODIFS: ** MARY      28/07/2000   12:09 V 1.00.B MR N[00/0506 *
001600170131       //            CR 00/0122 Sales Order Delivery Details             *
001700170131       // %ECSTD=========================================================*
001800170131       // %CSTD===========================================================*
001900170131       // * Application. : JAD        JAD                                 *
002000170131       // * Composant. . : HSR200                        Type: RPG        *
002100170131       // *===============================================================*
002200170131       // * Sous-syst}me :                                                *
002300170131       // * Fonction . . :                                                *
002400170131       // * Sous-fonction:                                                *
002500170131       // *%S=============================================================*
002600170131       // * Description des fonctionnalit{s:                              *
002700170131       // *                                                               *
002800170131       // *                                                               *
002900170131       // *                                                               *
003000170131       // *%E=============================================================*
003100170131       // * AUTEUR:                          00:00                        *
003200170131       // * MODIFS: ** JDESROCHES 06/08/2015   :    V 1.03.P    00/       *
003300170131       // *         01 JDESROCHES 06/07/2015 12:40  V 1.03.A    00/       *
003400170131       // %ECSTD==========================================================*
003500170131       // /TITLE Sales Order Entry / Maintenance / Inquiry
003600170131       //
003700170131       //  System        : HSV Control & Tracking
003800170131       //  Author        : Bob Lee (Intec Systems)
003900170131       //  Date          : January 1999
004000170131       //
004100170131       // ================================================================
004200170131       //  Indicator usage:
004300170131       //   20 - Order Valid for Despatch
004400170131       //   30 - 45 Input fields- DSPATR.
004500170131       //   62 - Control display/non-display of F10-Update.
004600170131       //   75 - 78 Program mode - Dispatch/Entry/Inquiry/Maintenance
004700170131       //   79 - MSGSFL (SFLCLR ETC...).
004800170131       //   99 - General CHAIN/SETLL result.
004900170131       //
005000170131       // ================================================================
005100170131       //  Maintenance   :
005200170131       //  Fix/Chg Ref. Date       Description.
005300170131       //  ------------ ---------- -----------------------------------
005400170131       // ================================================================
005500170131       Ctl-Opt DATEDIT(*YMD);
005600170131       Dcl-F HSLCUSTB   Keyed
005700170131                        RENAME(HSFCUST:HSFCUSTB);
005800170131       //  Customer Master by Post Code.
005900170131       //
006000170131       Dcl-F HSLCUSTA   Keyed;
006100170131       //  Customer Master by Customer Account.
006200170131       //
006300170131       // LTCUSTAIF  E           K        DISK
006400170131       //            HSFCUST                           KRENAMEALTCUSTF
006500170131       //  Customer Master by Customer Account.
006600170131       //
006700170131       Dcl-F HSLORDPA   Keyed;
006800170131       //  Sales Order Parameters.
006900170131       //
007000170131       Dcl-F HSLTRACB   Usage(*Update:*Delete) Keyed;
007100170131       //  Voucher Tracking by Product/Series/Serial No./Element No.
007200170131       //
007300170131       Dcl-F HSLEXPAA   Usage(*Update:*Delete:*Output) Keyed USROPN;
007400170131       //  Unbanded Order line file by Product/Series/Serial No.
007500170131       //
007600170131       Dcl-F HSLVCTLA   Usage(*Update:*Delete) Keyed;
007700170131       //  Voucher Control.
007800170131       //
007900170131       Dcl-F HSLVXRFB   Keyed;
008000170131       //  Agency Product Cross-Reference.
008100170131       //
008200170131       Dcl-F HSLORDHA   Usage(*Update:*Delete:*Output) Keyed;
008300170131       //  Sales Order Header.
008400170131       //
008500170131       Dcl-F HSLORDDB   Usage(*Update:*Delete:*Output) Keyed;
008600170131       //  Sales Order Detail.
008700170131       //
008800170131       Dcl-F HSLODELA   Usage(*Update:*Delete:*Output) Keyed;
008900170131       //  Sales Order Delivery Detail.
009000170131       //
009100170131       Dcl-F HSLSHPOA   Keyed;
009200170131       //  Ship Only.
009300170131       //
009400170131       Dcl-F HSLINVMA   Usage(*Update:*Delete) Keyed;
009500170131       //  Inventory Master.
009600170131       //
009700170131       Dcl-F HSLWHSEA   Keyed;
009800170131       //  Warehouse Master.
009900170131       //
010000170131       Dcl-F HSLCOMPA   Keyed;
010100170131       //  Company Master.
010200170131       //
010300170131       Dcl-F HSLPRODA   Keyed;
010400170131       //  Product Master.
010500170131       //
010600170131       Dcl-F HSLDISCA   Keyed;
010700170131       //  Customer Discount File
010800170131       //
010900170131       Dcl-F HSPINVT    Usage(*Update:*Delete:*Output) Keyed;
011000170131       //  Inventory Transactions.
011100170131       //
011200170131       Dcl-F ARTICLE    Keyed;
011300170131       //  FOR ARTCILE XREF
011400170131       //
011500170131       Dcl-F HSS200     WORKSTN INFDS(INFDS)
011600170131                                SFILE(HSS200C:RRNX);
011700170131       //  Screen file.
011800170131       // ================================================================
011900170131       //  Arrays.
012000170131       //
012100170131       //  Days in Month for date validation.
012200170131       Dcl-S DIM             Packed(2:0)     DIM(12) CTDATA PERRCD(12);
012300170131       // ================================================================
012400170131       //  Data Structures.
012500170131       //
012600170131       //  Screen Information DS.
012700170131       Dcl-Ds INFDS;
012800170131         KEY             Char(1)         Pos(369);
012900170131         CSRLOC          BinDec(4:0)     Pos(370);
012901170131       End-Ds;
013000170131       //
013100170131       Dcl-Ds XXXSDS PSDS Len(429);
013200170131         XPGMID          *PROC;
013300170131         XJOBNO          Char(10)        Pos(244);
013400170131         XUSRID          Char(10)        Pos(254);
013401170131       End-Ds;
013500170131       //
013600170131       //  General DDMMCCYY date format.
013700170131       Dcl-Ds *n;
013800170131         DD              Zoned(2:0)      Pos(1) INZ;
013900170131         MM              Zoned(2:0)      Pos(3) INZ;
014000170131         CC              Zoned(2:0)      Pos(5) INZ;
014100170131         YY              Zoned(2:0)      Pos(7) INZ;
014200170131         DMCY            Zoned(8:0)      Pos(1);
014201170131       End-Ds;
014300170131       //
014400170131       //  General CCYYMMDD date format.
014500170131       Dcl-Ds *n;
014600170131         CCC             Zoned(2:0)      Pos(1) INZ;
014700170131         YYY             Zoned(2:0)      Pos(3) INZ;
014800170131         MMM             Zoned(2:0)      Pos(5) INZ;
014900170131         DDD             Zoned(2:0)      Pos(7) INZ;
015000170131         CYMD            Zoned(8:0)      Pos(1);
015001170131       End-Ds;
015100170131       //
015200170131       //  Input order date format.
015300170131       Dcl-Ds *n;
015400170131         JDD             Zoned(2:0)      Pos(1) INZ;
015500170131         JMM             Zoned(2:0)      Pos(3) INZ;
015600170131         JCC             Zoned(2:0)      Pos(5) INZ;
015700170131         JYY             Zoned(2:0)      Pos(7) INZ;
015800170131         XJORDD          Zoned(8:0)      Pos(1);
015801170131       End-Ds;
015900170131       //
016000170131       //  Output order date format.
016100170131       Dcl-Ds *n;
016200170131         WKC             Zoned(2:0)      Pos(1) INZ;
016300170131         WKY             Zoned(2:0)      Pos(3) INZ;
016400170131         WKM             Zoned(2:0)      Pos(5) INZ;
016500170131         WKD             Zoned(2:0)      Pos(7) INZ;
016600170131         WKORDD          Zoned(8:0)      Pos(1);
016601170131       End-Ds;
016700170131       //
016800170131       // ----------------------------------------------------------------
016900170131       //  Constants.
017000170131       //
017100170131       //  Named hexidecimal constants for function keys.
017200170131       Dcl-C F03             CONST(X'33');
017300170131       Dcl-C F04             CONST(X'34');
017400170131       Dcl-C F06             CONST(X'36');
017500170131       Dcl-C F07             CONST(X'37');
017600170131       Dcl-C F10             CONST(X'3A');
017700170131       Dcl-C F11             CONST(X'3B');
017800170131       Dcl-C F12             CONST(X'3C');
017900170131       //
018000170131       //  Zeros to "SETOF" error indicators.
018100170131       Dcl-C XZEROS          CONST('0000000000000000000');
018101170131       Dcl-S ATag            Char(14);
018102170131       Dcl-S WKORDN          Packed(8:0);
018103170131       Dcl-S ORDERX          Packed(8:0)     DtaAra('HSAORDERNO');
018104170131       Dcl-S TOT             Packed(20:5);
018105170131       Dcl-S SHONLY          Char(1);
018106170131       Dcl-S RRNS            Packed(5:0);
018107170131       Dcl-S RRNT            Packed(5:0);
018108170131       Dcl-S pAToArrStr      Pointer;
018109170131       Dcl-S AToArrStr       Char(65535)     Based(pAToArrStr);
018110170131       Dcl-S TPROD1          Char(13);
018111170131       Dcl-S TQTYN1          Packed(15:0);
018112170131       Dcl-S TKPRIC          Packed(9:2);
018113170131       Dcl-S TKVALU          Packed(9:2);
018114170131       Dcl-S TNDESC          Char(19);
018115170131       Dcl-S TSELC           Char(1);
018116170131       Dcl-S TPROD           Char(13);
018117170131       Dcl-S TPRIC           Packed(9:2);
018118170131       Dcl-S TQTYN           Packed(9:0);
018119170131       Dcl-S TDESC           Char(19);
018120170131       Dcl-S XQUAN           Packed(9:0);
018121170131       Dcl-S XJUMP           Char(1);
018122170131       Dcl-S XFIRST          Char(1);
018123170131       Dcl-S RRNXX           Packed(5:0);
018124170131       Dcl-S OPROD           Char(13);
018125170131       Dcl-S OSERC           Char(3);
018126170131       Dcl-S OSERN           Packed(9:0);
018127170131       Dcl-S XXSERF          Packed(9:0);
018128170131       Dcl-S XXRES           Packed(9:0);
018129170131       Dcl-S XXSERC          Char(3);
018130170131       Dcl-S XXSERN          Packed(9:0);
018131170131       Dcl-S XJUMP1          Char(1);
018132170131       Dcl-S DIF             Packed(9:0);
018133170131       Dcl-S DSERN           Packed(9:0);
018134170131       Dcl-S RES             Packed(9:0);
018135170131       Dcl-S KKSERC          Char(3);
018136170131       Dcl-S KKSERT          Packed(9:0);
018137170131       Dcl-S XJCLIM          Packed(15:0);                                      // Credit Limit
018138170131       Dcl-S XJTYSL          Packed(20:5);                                      // Last Year Sales
018139170131       Dcl-S REM             Packed(4:0);
018140170131       Dcl-S LEAP            Char(1);
018141170131       Dcl-S M               Packed(2:0);
018142170131       Dcl-S CCYY            Packed(4:0);
018143170131       Dcl-S YRTNC           Char(1);
018144170131       Dcl-S YNUMBR          Char(15);
018145170131       Dcl-S FILEY           Char(10);
018146170131       Dcl-S NAMEY           Char(6);
018147170131       Dcl-S NUMBRY          Char(6);
018148170131       Dcl-S LINY            Packed(3:0);
018149170131       Dcl-S COLY            Packed(3:0);
018150170131       Dcl-S ROW             Packed(2:0);
018151170131       Dcl-S COL             Packed(2:0);
018152170131       Dcl-S TEMP            Packed(9:0);
018153170131       Dcl-S WKTOTV          Like(XKVALU);
018154170131       Dcl-S WKSERC          Like(XKSERC);
018155170131       Dcl-S WKSERN          Like(BSERNN);
018156170131       Dcl-S WKQTYN          Like(XKQTYN);
018157170131       Dcl-S WKSUBC          Like(DSUBC);
018158170131       Dcl-S WKRANG          Like(XNO);
018159170131       Dcl-S WKVCTL          Like(XNO);
018160170131       Dcl-S UPDAT           Like(XNO);
018161170131       Dcl-S XNO             Char(1);
018162170131       Dcl-S XYES            Char(1);
018163170131       Dcl-S XERROR          Char(1);
018164170131       Dcl-S XUPDAT          Char(1);
018165170131       Dcl-S XDELET          Char(1);
018166170131       Dcl-S ORDPRM          Char(8);
018167170131       Dcl-S RRNX            Packed(5:0);
018168170131       Dcl-S RRNVAL          Packed(5:0);
018169170131       Dcl-S RRNLIN          Packed(5:0);
018170170131       Dcl-S RRNQ            Packed(5:0);
018171170131       Dcl-S RRNP            Packed(5:0);
018172170131       Dcl-S P0PGMQ          Char(10);                                          // Program queu
018173170131       Dcl-S P0PGRL          Char(5);                                           // Rel queue
018174170131       Dcl-S P0MSID          Char(7);                                           // Message ID
018175170131       Dcl-S P0MSGF          Char(10);                                          // Message file
018176170131       Dcl-S P0MSDA          Char(132);                                         // Message data
018177170131       Dcl-S P0MSTP          Char(7);                                           // Message type
018178170131       // Prototype for HSC200A
018179170131       Dcl-Pr Pgm_HSC200A ExtPgm('HSC200A') End-Pr;
018180170131       // Prototype for HSR200
018181170131       Dcl-Pr Pgm_HSR200 ExtPgm('HSR200');
018182170131         YMODE           Char(1);                                               // Mode
018183170131         YORDNO          Char(8);                                               // Sales Order No.
018184170131         YTYPE           Char(3);                                               // Order Type
018185170131         YCUST           Char(8);                                               // Customer No.
018186170131       End-Pr;
018187170131       // Procedure interface for HSR200
018188170131       Dcl-Pi Pgm_HSR200;
018189170131         YMODE           Char(1);                                               // Mode
018190170131         YORDNO          Char(8);                                               // Sales Order No.
018191170131         YTYPE           Char(3);                                               // Order Type
018192170131         YCUST           Char(8);                                               // Customer No.
018193170131       End-Pi;
018194170131       // Prototype for HSR220
018195170131       Dcl-Pr Pgm_HSR220 ExtPgm('HSR220');
018196170131         ORDPRM          Char(8);
018197170131       End-Pr;
018198170131       // Prototype for HSR230
018199170131       Dcl-Pr Pgm_HSR230 ExtPgm('HSR230');
018200170131         ORDPRM          Char(8);
018201170131       End-Pr;
018202170131       // Prototype for HSR341
018203170131       Dcl-Pr Pgm_HSR341 ExtPgm('HSR341');
018204170131         YRTNC           Char(1);
018205170131         YNUMBR          Char(15);
018206170131         FILEY           Char(10);
018207170131         NAMEY           Char(6);
018208170131         NUMBRY          Char(6);
018209170131         LINY            Packed(3:0);
018210170131         COLY            Packed(3:0);
018211170131       End-Pr;
018212170131       // Prototype for HSR342
018213170131       Dcl-Pr Pgm_HSR342 ExtPgm('HSR342') End-Pr;
018214170131       // Prototype for RMVMSGC
018215170131       Dcl-Pr Pgm_RMVMSGC ExtPgm('RMVMSGC') End-Pr;
018216170131       // Prototype for SNDMSGC
018217170131       Dcl-Pr Pgm_SNDMSGC ExtPgm('SNDMSGC');
018218170131         P0PGMQ          Char(10);                                              // Program queue
018219170131         P0PGRL          Char(5);                                               // Rel queue
018220170131         P0MSID          Char(7);                                               // Message ID
018221170131         P0MSGF          Char(10);                                              // Message file
018222170131         P0MSDA          Char(132);                                             // Message data
018223170131         P0MSTP          Char(7);                                               // Message type
018224170131       End-Pr;
018225170131       //
018300170131       // ================================================================
018400170131       //  M A I N L I N E
018500170131       // ================================================================
018600170131       //
018700170131       //  Dispatch mode
018800170131       If YMODE = 'D';
018900170131         *IN75 = *ON;
019000170131       Else;
019100170131         *IN75 = *OFF;
019200170131       EndIf;
019300170131       Read ARTICLE;
019301170131       *IN99 = %Eof;
019400170131       //
019500170131       //  Entry mode
019600170131       If YMODE = 'E';
019700170131         *IN76 = *ON;
019800170131       Else;
019900170131         *IN76 = *OFF;
020000170131       EndIf;
020100170131       //
020200170131       //  Inquiry mode
020300170131       If YMODE = 'I';
020400170131         *IN77 = *ON;
020500170131       Else;
020600170131         *IN77 = *OFF;
020700170131       EndIf;
020800170131       //
020900170131       //  Maintenance mode
021000170131       If YMODE = 'M';
021100170131         *IN78 = *ON;
021200170131       Else;
021300170131         *IN78 = *OFF;
021400170131       EndIf;
021500170131       //
021600170131       //  Program mode
021601170131       DoU ATag <> 'START' and ATag <> 'HDR'
021602170131         and ATag <> 'DET';
021701170131         If ATag = 'START' or ATag = *Blanks;
021702170131           ATag = *Blanks;
021800170131           If YMODE = 'I'
021900170131             or YMODE = 'D'
022000170131             or YMODE = 'M';
022100170131             If YORDNO <> *BLANKS;
022200170131               XJSORD = %Dec(%XLate(' ':'0':
022201170131                     YORDNO):8:0);
022300170131               WKORDN = %Dec(%XLate(' ':'0':
022301170131                     YORDNO):8:0);
022400170131               Chain WKORDN HSLORDHA;
022401170131               *IN99 = not %Found;
022500170131             EndIf;
022600170131           EndIf;
022700170131           //
022800170131           If YMODE = 'D';
022900170131             XJTYPE = JTYPE;
023000170131             XJCUST = JCUST;
023100170131             WKORDD = JORDD;
023200170131             JCC = WKC;
023300170131             JYY = WKY;
023400170131             JMM = WKM;
023500170131             JDD = WKD;
023600170131             XJORDR = JORDR;
023700170131             XJSORD = JSORD;
023800170131             If JSTAT = 'A'
023900170131               or JSTAT = ' ';
024000170131               *IN20 = *ON;
024100170131             Else;
024200170131               *IN20 = *OFF;
024300170131               P0MSID = 'HSV2015';
024400170131               Exsr YSNDMG;
024500170131             EndIf;
024600170131             Chain JCUST HSLCUSTA;
024601170131             *IN13 = not %Found;
024700170131             XJPCDE = EPCDE;
024800170131             XENAM1 = ENAM1;
024900170131             Setll JSORD HSLORDDB;
025000170131             ReadE JSORD HSLORDDB;
025001170131             *IN99 = %Eof;
025100170131             DoW *IN99 = *OFF;
025200170131               XVQTY += KQTYN;
025300170131               ReadE JSORD HSLORDDB;
025301170131               *IN99 = %Eof;
025400170131             EndDo;
025500170131             XJDISP = KDISP;
025600170131           Else;
025700170131             Exsr YCLRSC;
025800170131           EndIf;
025900170131           //
026000170131           //  Dispatch mode.
026100170131           If YMODE = 'D';
026200170131             Chain JSORD HSLODELA;
026201170131             *IN99 = not %Found;
026300170131             If VNAM1 = *BLANKS;
026400170131               XXNAM1 = ENAM1;
026500170131               XXNAM2 = ENAM2;
026600170131               XXADR1 = EADR1;
026700170131               XXADR2 = EADR2;
026800170131             Else;
026900170131               XXNAM1 = VNAM1;
027000170131               XXNAM2 = *Blanks;
027100170131               XXADR1 = VADR1;
027200170131               XXADR2 = VADR2;
027300170131             EndIf;
027400170131           EndIf;
027500170131           //
027600170131           //  Dispatch, or Inquiry, or Maintenance mode.
027700170131           If YMODE = 'I'
027800170131             or YMODE = 'D'
027900170131             or YMODE = 'M';
028000170131             XJCUST = YCUST;
028100170131             XJTYPE = YTYPE;
028200170131           EndIf;
028201170131         EndIf;
028301170131         If ATag = 'HDR' or ATag = *Blanks;
028302170131           ATag = *Blanks;
028400170131           *IN47 = *OFF;
028500170131           //  Display screen to receive Customer No. until F03/F10
028600170131           DoU KEY = F03
028700170131             or KEY = F10
028800170131             and XERROR = XNO;
028900170131             //
029000170131             //  Exit if F03 pressed.
029100170131             If KEY = F03;
029200170131               *INLR = *ON;
029300170131               Leave;
029400170131             EndIf;
029500170131             //
029600170131             //  Display messages.
029700170131             Write MSGCTL;
029800170131             //
029900170131             XXTME = %Dec(%Time);
030000170131             Exfmt HSS200A;
030100170131             //
030200170131             Chain XJTYPE HSLORDPA;
030201170131             *IN99 = not %Found;
030300170131             If MSALE = 'C';
030400170131               *IN30 = *ON;
030500170131               XERROR = XYES;
030600170131               P0MSID = 'HSV2027';
030700170131               Exsr YSNDMG;
030800170131               Iter;
030900170131             EndIf;
031000170131             //
031100170131             Clear XVQTY;
031200170131             If *IN20 = *OFF
031300170131               and YMODE = 'D';
031400170131               Iter;
031500170131             EndIf;
031600170131             //
031700170131             RCDNBR = 1;
031800170131             //
031900170131             //  Clear messages.
032000170131             Exsr YCLRMG;
032100170131             //
032200170131             //  Process the various function keys available on the screen.
032300170131             //
032400170131             //  Process Despatch if F07 pressed.
032500170131             If KEY = F07;
032600170131               //
032700170131               //  Validate that Order Type is a valid Type.
032800170131               Chain XJTYPE HSLORDPA;
032801170131               *IN99 = not %Found;
032900170131               If *IN99 = *ON;
033000170131                 *IN30 = *ON;
033100170131                 XERROR = XYES;
033200170131                 P0MSID = 'HSV2001';
033300170131                 Exsr YSNDMG;
033401170131                 ATag = 'START';
033402170131                 Leave;
033500170131               EndIf;
033600170131             EndIf;
033700170131             //
033800170131             If YMODE = 'D'
033900170131               and WKORDN <> XJSORD;
034000170131               WKORDN = XJSORD;
034100170131               Chain XJSORD HSLORDHA;
034101170131               *IN99 = not %Found;
034200170131               If *IN99 = *ON;
034300170131                 *IN20 = *OFF;
034400170131                 P0MSID = 'HSV2017';
034500170131                 Exsr YSNDMG;
034600170131               Else;
034700170131                 XJTYPE = JTYPE;
034800170131                 XJCUST = JCUST;
034900170131                 WKORDD = JORDD;
035000170131                 JCC = WKC;
035100170131                 JYY = WKY;
035200170131                 JMM = WKM;
035300170131                 JDD = WKD;
035400170131                 XJORDR = JORDR;
035500170131                 XJSORD = JSORD;
035600170131                 If JSTAT = 'A'
035700170131                   or JSTAT = ' ';
035800170131                   *IN20 = *ON;
035900170131                 Else;
036000170131                   *IN20 = *OFF;
036100170131                   P0MSID = 'HSV2015';
036200170131                   Exsr YSNDMG;
036300170131                 EndIf;
036400170131               EndIf;
036500170131               Chain JCUST HSLCUSTA;
036501170131               *IN13 = not %Found;
036600170131               XJPCDE = EPCDE;
036700170131               XENAM1 = ENAM1;
036800170131               Setll JSORD HSLORDDB;
036900170131               ReadE JSORD HSLORDDB;
036901170131               *IN99 = %Eof;
037000170131               DoW *IN99 = *OFF;
037100170131                 XVQTY += KQTYN;
037200170131                 ReadE JSORD HSLORDDB;
037201170131                 *IN99 = %Eof;
037300170131               EndDo;
037400170131               XJDISP = KDISP;
037501170131               ATag = 'HDR';
037502170131               Leave;
037600170131             EndIf;
037700170131             //
037800170131             //  Program in inquiry, dispatch or maintenance mode
037900170131             If YMODE = 'I'
038000170131               or YMODE = 'M'
038100170131               or YMODE = 'D';
038200170131               //
038300170131               //  Initialise subfile
038400170131               *In70 = '1';
038401170131               *In71 = '0';
038402170131               *In72 = '0';
038403170131               *In73 = '1';
038500170131               Write HSS200B;
038600170131               If XJSORD <> 0;
038700170131                 RRNX = 0;
038800170131                 Setll XJSORD HSLORDDB;
038900170131                 DoU *IN97 = *ON;
039000170131                   ReadE XJSORD HSLORDDB;
039001170131                   *IN97 = %Eof;
039100170131                   //
039200170131                   //  Build subfile from existing order.
039300170131                   If *IN97 = *OFF;
039400170131                     RRNX += 1;
039500170131                     Chain RRNX HSS200C;
039501170131                     *IN99 = not %Found;
039600170131                     XOLIN = KLINE;
039700170131                     XSELC = KLTYP;
039800170131                     XKPROD = KPROD;
039900170131                     XNDESC = KDESC;
040000170131                     XKSERC = KSERC;
040100170131                     XKSERF = KSERNF;
040200170131                     XKSERT = KSERNT;
040300170131                     XKQTYN = KQTYN;
040400170131                     XKPRIC = KPRIC;
040500170131                     XKVALU = KVALU;
040600170131                     XXQTYN = XKQTYN;
040700170131                     //
040800170131                     //  Ship Only - set line value to zero.
040900170131                     If SHONLY = 'Y'
041000170131                       and XSELC = 'S';
041100170131                       XKVALU = 0;
041200170131                     EndIf;
041300170131                     //
041400170131                     //           #KVALU    MULT MVATP     #KVATA
041500170131                     //
041600170131                     //  Extended value
041700170131                     If XSELC = 'S'
041800170131                       or XSELC = 'N';
041900170131                       XKVALU = XKPRIC * XKQTYN;
042000170131                       //
042100170131                       //  Ship Only - set line value to zero.
042200170131                       If SHONLY = 'Y'
042300170131                         and XSELC = 'S';
042400170131                         XKVALU = 0;
042500170131                       EndIf;
042600170131                       //
042700170131                       //           #KVALU    MULT MVATP     #KVATA
042800170131                       //
042900170131                     EndIf;
043000170131                     //
043100170131                     //  Write subfile record.
043200170131                     If *IN99 = *OFF;
043300170131                       Update HSS200C;
043400170131                     Else;
043500170131                       Write HSS200C;
043600170131                     EndIf;
043700170131                   EndIf;
043800170131                 EndDo;
043900170131               EndIf;
044000170131               Leave;
044100170131             EndIf;
044200170131             //
044300170131             //  Program mode - Entry
044400170131             If YMODE = 'E';
044500170131               //
044600170131               //  Execute search if F04 pressed.
044700170131               If KEY = F04;
044800170131                 Exsr YSERCH;
044900170131                 Iter;
045000170131                 Exsr YCLRMG;
045100170131               EndIf;
045200170131               //
045300170131               //  Validate header screen fields.
045400170131               Exsr VALIDH;
045500170131               //
045600170131               //  Validate ship only requirements.
045700170131               Exsr SHPONL;
045800170131               //
045900170131             EndIf;
046000170131             //
046100170131             //  Process Despatch if F07 pressed.
046200170131             If KEY = F07;
046300170131               //
046400170131               Leave;
046500170131             EndIf;
046600170131             //
046700170131             //  End of DO loops for F03/F10 key checks.
046800170131           EndDo;
046801170131           If ATag = 'START' or ATag = 'HDR';
046802170131             Iter;
046803170131           EndIf;
046900170131           *IN61 = *OFF;
047000170131           //
047100170131           //  Clear messages.
047200170131           Exsr YCLRMG;
047300170131           //
047400170131           //  Exit if F03 pressed.
047500170131           If KEY = F03;
047600170131             //  Exit program.
047700170131             *INLR = *ON;
047800170131             Return;
047900170131           EndIf;
048000170131           //
048100170131           // -------------------------------------------------------
048200170131           //
048300170131           //  Program mode - Entry
048400170131           //  Retrieve order number.
048500170131           If YMODE = 'E';
048700170131             In *LOCK ORDERX;
048800170131             ORDERX += 1;
048900170131             Out ORDERX;
049000170131             XJSORD = ORDERX;
049100170131           EndIf;
049200170131           //
049300170131           //  Display screen to receive Order Details until F10/F12
049301170131         EndIf;
049401170131         // branch when ATag = 'DET'
049402170131         ATag = *Blanks;
049500170131         //
049600170131         //  Program in inquiry, or dispatch, or maintenance mode
049700170131         If YMODE = 'I'
049800170131           or YMODE = 'M'
049900170131           or YMODE = 'D'
050000170131           or KEY = F12;
050100170131           *IN73 = *OFF;
050200170131         Else;
050300170131           *IN73 = *ON;
050400170131         EndIf;
050500170131         //
050600170131         DoU KEY = F10
050700170131           and XERROR = XNO
050800170131           or KEY = F12;
050900170131           //
051000170131           //  Display messages.
051100170131           Write MSGCTL;
051200170131           //
051300170131           //  Read subfile to accumulate order value.
051400170131           If RRNX > 0;
051500170131             RRNVAL = 1;
051600170131             XKTVAL = 0;
051700170131             DoU *IN98 = *ON
051800170131               or RRNVAL = 100
051900170131               or XSELC = *BLANK;
052000170131               Chain RRNVAL HSS200C;
052001170131               *IN98 = not %Found;
052100170131               If XSELC <> *BLANK
052200170131                 and XKPROD <> *BLANK
052300170131                 and *IN98 = *OFF
052400170131                 or XSELC <> *BLANK
052500170131                 and XNDESC <> *BLANK
052600170131                 and *IN98 = *OFF;
052700170131                 XKTVAL += XKVALU;
052800170131               EndIf;
052900170131               RRNVAL += 1;
053000170131             EndDo;
053100170131           EndIf;
053200170131           //
053300170131           //  Dispatch mode.
053400170131           If YMODE = 'D';
053500170131             Chain XJCUST HSLCUSTA;
053501170131             *IN99 = not %Found;
053600170131             //  ...load Customer record into screen 2 fields.
053700170131             XJNAM1 = ENAM1;                                                    // Name 1
053800170131             XJNAM2 = ENAM2;                                                    // Name 2
053900170131             XJADR1 = EADR1;                                                    // Address 1
054000170131             XJADR2 = EADR2;                                                    // Address 2
054100170131           EndIf;
054200170131           //
054300170131           //
054400170131           //  Display footer.
054500170131           If KEY <> F07;
054600170131             Write HSS200E;
054700170131           EndIf;
054800170131           //
054900170131           XXTME = %Dec(%Time);
055000170131           *In70 = '0';
055001170131           *In71 = '1';
055002170131           *In72 = '1';
055100170131           //
055200170131           If KEY <> F07;
055300170131             Exfmt HSS200B;
055400170131             XJUMP1 = XNO;
055500170131             //
055600170131             If KEY <> F10;
055700170131               Exsr YDELT;
055800170131             EndIf;
055900170131             //
056000170131           EndIf;
056100170131           //
056200170131           *IN73 = *OFF;
056300170131           *IN86 = *OFF;
056400170131           //
056500170131           //  Clear messages (Only if an error has not been repeated)
056600170131           //
056700170131           If XERROR = XNO;
056800170131             //  Clear messages.
056900170131             Exsr YCLRMG;
057000170131           EndIf;
057100170131           //
057200170131           //  Process the various function keys available on the screen.
057300170131           //
057400170131           //  Exit if F12 pressed.
057500170131           If KEY = F12;
057601170131             ATag = 'HDR';
057602170131             Leave;
057700170131           EndIf;
057800170131           //
057900170131           //  Execute search if F04 pressed.
058000170131           If KEY = F04;
058100170131             Exsr YSERSF;
058200170131             Iter;
058300170131           EndIf;
058400170131           //
058500170131           //  Check for agency cross-references.
058600170131           If MXREF = 'Y';
058700170131             Exsr AGXREF;
058800170131           EndIf;
058900170131           //
059000170131           //  Validate order detail screen fields (only re-validate data
059100170131           //  if it has been changed. Otherwise re-display error message).
059200170131           If XERROR = XYES;
059300170131             Chain RRNS HSS200C;
059301170131             *IN98 = not %Found;
059400170131             If XSELC <> TSELC
059500170131               or XKPROD <> TPROD
059600170131               or XKPRIC <> TPRIC
059700170131               or XKQTYN <> TQTYN
059800170131               or XNDESC <> TDESC;
059900170131               *IN93 = *ON;
060000170131             EndIf;
060100170131           EndIf;
060200170131           //
060300170131           If *IN93 = *ON
060400170131             or XERROR = XNO;
060500170131             //
060600170131             //  Validate order detail screen fields.
060700170131             Exsr VALIDD;
060800170131           EndIf;
060900170131           //
061000170131           //  Discount retrieval.
061100170131           Exsr DISCNT;
061200170131           //
061300170131           //  Stock allocation preview
061400170131           //                  - with banded allocation and manual allocation.
061500170131           //           MSALE     IFEQ 'S'
061600170131           //                     EXSR ALLOCS
061700170131           //                     ENDIF
061800170131           //
061900170131           //  Process Dispatch if F07 pressed.
062000170131           If KEY = F07;
062100170131             //
062200170131             Leave;
062300170131           EndIf;
062400170131           //
062500170131           //  End of DO loops for F10/F12 key checks.
062600170131         EndDo;
062601170131         If ATag = 'HDR';
062602170131           Iter;
062603170131         EndIf;
062700170131         //
062800170131         // -------------------------------------------------------
062900170131         //  Confirm order - prompt for delivery details.
063000170131         //                - file updates when F10 pressed.
063100170131         DoU KEY = F10
063200170131           and XERROR = XNO
063300170131           or KEY = F12;
063400170131           //
063500170131           //  Clear messages.
063600170131           Exsr YCLRMG;
063700170131           //
063800170131           //  Process the various function keys available on the screen.
063900170131           //
064000170131           //  Exit if F12 pressed.
064100170131           //           KEY       IFEQ F12
064200170131           //                     GOTO DET
064300170131           //                     ENDIF
064400170131           //
064500170131           //  Check for minimum order value.
064600170131           If KEY <> F07;
064700170131             If MORDV > 0;
064800170131               Exsr MINVAL;
064900170131             EndIf;
065000170131             //
065100170131             //  Credit limit check.... Warning only.
065200170131             TOT = XKTVAL + XJTYSL;
065300170131             If TOT > XJCLIM;
065400170131               *IN46 = *ON;
065500170131               P0MSID = 'HSV2019';
065600170131               Exsr YSNDMG;
065700170131             EndIf;
065800170131           EndIf;
065900170131           //
066000170131           //  Display messages.
066100170131           Write MSGCTL;
066200170131           //
066300170131           //  Display key text footer.
066400170131           //                     WRITEHSS200E
066500170131           If KEY <> F07;
066600170131             Write HSS200F;
066700170131           EndIf;
066800170131           //
066900170131           //  Delivery address prompt screen.
067000170131           XXTME = %Dec(%Time);
067100170131           //
067200170131           //  Program in inquiry, dispatch or maintenance mode
067300170131           If YMODE = 'I'
067400170131             or YMODE = 'M'
067500170131             or YMODE = 'D';
067600170131             Chain WKORDN HSLODELA;
067601170131             *IN99 = not %Found;
067700170131             //
067800170131             //  Write fields for order delivery detail record.
067900170131             If *IN99 = *OFF;
068000170131               XVNAM1 = VNAM1;
068100170131               XVADR1 = VADR1;
068200170131               XVADR2 = VADR2;
068300170131               XVADR3 = VADR3;
068400170131               XVPCDE = VPCDE;
068500170131               XVDIN1 = VDIN1;
068600170131               XVDIN2 = VDIN2;
068700170131               XVDIN3 = VDIN3;
068800170131             EndIf;
068900170131           EndIf;
069000170131           //
069100170131           //  Write order delivery details record.
069200170131           If KEY <> F07;
069300170131             Exfmt HSS200D;
069400170131           EndIf;
069500170131           //
069600170131           //  Exit if F12 pressed.
069700170131           If KEY = F12;
069800170131             Exsr YDELT;
069901170131             ATag = 'DET';
069902170131             Leave;
070000170131           EndIf;
070100170131           //
070200170131           //  Clear messages.
070300170131           If *IN47 = *OFF;
070400170131             Exsr YCLRMG;
070500170131           EndIf;
070600170131           //
070700170131           //  Update all files, if no errors exist.
070800170131           If KEY = F10
070900170131             and XERROR = XNO
071000170131             or KEY = F07;
071100170131             RRNX = 1;
071200170131             DoU *IN98 = *ON
071300170131               or RRNX = 100
071400170131               or XSELC = *BLANK;
071500170131               Chain RRNX HSS200C;
071501170131               *IN98 = not %Found;
071600170131               If XSELC <> *BLANK
071700170131                 and XKPROD <> *BLANK
071800170131                 and *IN98 = *OFF
071900170131                 or XSELC <> *BLANK
072000170131                 and XNDESC <> *BLANK
072100170131                 and *IN98 = *OFF;
072200170131                 //
072300170131                 //  Save RRN for current order line.
072400170131                 RRNLIN = RRNX;
072500170131                 //
072600170131                 //  Update Voucher Control if in entry mode....
072700170131                 If YMODE = 'E'
072800170131                   and MSALE = 'S';
072900170131                   Exsr UPPVCT;
073000170131                 EndIf;
073100170131                 //
073200170131                 //  Re-position to required subfile line
073300170131                 RRNX = RRNLIN;
073400170131                 Chain RRNX HSS200C;
073401170131                 *IN98 = not %Found;
073500170131                 //
073600170131                 //  Create/Update order details if in Entry,Maint,or Dispatch mode.
073700170131                 If YMODE = 'E'
073800170131                   or YMODE = 'D'
073900170131                   or YMODE = 'M';
074000170131                   Exsr UPORDD;
074100170131                 EndIf;
074200170131                 //
074300170131                 //  Update voucher tracking if in Entry or Dispatch mode.
074400170131                 //  Stock lines only.
074500170131                 If YMODE = 'E'
074600170131                   and XSELC = 'S'
074700170131                   or YMODE = 'D'
074800170131                   and XSELC = 'S';
074900170131                   Exsr UPTRAC;
075000170131                 EndIf;
075100170131                 //
075200170131                 //  Allocate inventory if in Entry mode.
075300170131                 //  Stock lines only.
075400170131                 If YMODE = 'E'
075500170131                   and XSELC = 'S';
075600170131                   //  Update inventory allocations.
075700170131                   Exsr UPINVA;
075800170131                 EndIf;
075900170131                 //
076000170131                 //  Sell inventory if in Dispatch mode.
076100170131                 //  Stock lines only.
076200170131                 If YMODE = 'D'
076300170131                   and XSELC = 'S';
076400170131                   //  Update inventory sales.
076500170131                   Exsr UPINVS;
076600170131                   //
076700170131                   //  Create inventory sales transaction.
076800170131                   Exsr UPINVT;
076900170131                 EndIf;
077000170131               EndIf;
077100170131               RRNX += 1;
077200170131             EndDo;
077300170131             //
077400170131             //  Create/Update order header if in Entry,Maint,or Dispatch mode.
077500170131             If YMODE = 'E'
077600170131               or YMODE = 'D'
077700170131               or YMODE = 'M';
077800170131               Exsr UPORDH;
077900170131               //
078000170131               //  Create/update delivery record if in Entry,Maint or Dispat.mode.
078100170131               Exsr UPODEL;
078200170131             EndIf;
078300170131             //
078400170131             //  Ship to all delivery points if in Entry mode.
078500170131             If YMODE = 'E'
078600170131               and MALLP = 'Y';
078700170131               Exsr SHPALL;
078800170131             EndIf;
078900170131             //
079000170131             //  Print delivery note if in Entry mode, and charges only not set.
079100170131             If YMODE = 'E'
079200170131               and MINVC <> 'Y';
079300170131               Exsr PRTDEL;
079400170131             EndIf;
079500170131             //
079600170131             //  Print Invoice if in Entry mode, and Immediate print required.
079700170131             If YMODE = 'E'
079800170131               and MINVP = 'I';
079900170131               Exsr PRTINV;
080000170131             EndIf;
080100170131             //
080200170131           EndIf;
080300170131           //  Process Despatch if F07 pressed.
080400170131           If KEY = F07;
080500170131             Exsr YCLRSC;
080600170131             //
080700170131             Leave;
080800170131           EndIf;
080900170131           //
081000170131           //  End of Confirmation.
081100170131         EndDo;
081101170131         If ATag = 'DET';
081102170131           Iter;
081103170131         EndIf;
081200170131         //
081300170131         //  Return to order details if F12 pressed.
081400170131         If KEY = F12;
081501170131           ATag = 'DET';
081502170131           Iter;
081600170131         EndIf;
081700170131         //
081800170131         //  Clear Subfile
081900170131         *In70 = '1';
081901170131         *In71 = '0';
081902170131         *In72 = '0';
081903170131         *In73 = '0';
082000170131         Write HSS200B;
082100170131         //
082200170131         //  Clear contents of HSPEXPA.
082300170131         Exsr YDELT;
082400170131         //
082500170131         //  Return to order header.
082601170131         ATag = 'HDR';
082602170131         Iter;
082603170131       EndDo;
082700170131       //
082800170131       // ****************************************************************
082900170131       // ----------------------------------------------------------------
083000170131       //  @CLRSC - Clear screen fields.
083100170131       // ----------------------------------------------------------------
083200170131       //
083300170131       BegSr YCLRSC;
083400170131         //
083500170131         //  Clear header screen fields.
083600170131         If YMODE <> 'E';
083700170131           Clear XJTYPE;
083800170131         EndIf;
083900170131         If YMODE = 'D';
084000170131           Clear XJSORD;
084100170131           Clear XENAM1;
084200170131           Clear XVQTY;
084300170131         EndIf;
084400170131         Clear XJCOMP;
084500170131         Clear XJWHSE;
084600170131         Clear XJPCDE;
084700170131         Clear XJCUST;
084800170131         Clear XJDISP;
084900170131         Clear XJORDD;
085000170131         Clear XJORDR;
085100170131         //
085200170131         //  Clear delivery screen fields.
085300170131         Clear XVNAM1;
085400170131         Clear XVADR1;
085500170131         Clear XVADR2;
085600170131         Clear XVADR3;
085700170131         Clear XVPCDE;
085800170131         Clear XVDIN1;
085900170131         Clear XVDIN2;
086000170131         Clear XVDIN3;
086100170131       EndSr;
086200170131       //
086300170131       // ----------------------------------------------------------------
086400170131       //  SHPONL - Validate ship only requirements.
086500170131       // ----------------------------------------------------------------
086600170131       BegSr SHPONL;
086700170131         //
086800170131         //  Check if a ship only record exists for this customer
086900170131         Chain XJCUST HSLSHPOA;
086901170131         *IN99 = not %Found;
087000170131         If *IN99 = *OFF;
087100170131           SHONLY = 'Y';
087200170131         Else;
087300170131           SHONLY = ' ';
087400170131         EndIf;
087500170131       EndSr;
087600170131       //
087700170131       // ----------------------------------------------------------------
087800170131       //  AGXREF - Check for agency cross-references.
087900170131       // ----------------------------------------------------------------
088000170131       BegSr AGXREF;
088100170131         Chain (CCYY : XJCUST : XKPROD) HSLVXRFB;
088101170131         *IN99 = not %Found;
088200170131         If *IN99 = *OFF;
088300170131           KPROD = HPROD;
088400170131           XKPROD = HPROD;
088500170131         EndIf;
088600170131       EndSr;
088700170131       //
088800170131       // ----------------------------------------------------------------
088900170131       //  VALIDD - Validate order detail screen fields.
089000170131       // ----------------------------------------------------------------
089100170131       BegSr VALIDD;
089200170131         //
089300170131         //  Order Detail validation:
089400170131         //
089500170131         //  Reset work values.
089600170131         //                     Z-ADD0         RRN#
089700170131         RRNS = 0;
089800170131         RRNT = 1;
089900170131         Reset XERROR;
090000170131         *IN61 = *OFF;                                                          // Hide F10/F11
090100170131         //
090200170131         //  Reset error indicators.
090300170131         pAToArrStr = %Addr(*IN(30));
090301170131         %Subst(AToArrStr:1:19) = XZEROS;
090400170131         //
090500170131         //  Read all Records from subfile and validate contents.
090600170131         DoU *IN99 = *ON;                                                       // ..Do1
090700170131           //
090800170131           //  Process the subfile in one of two modes depending on whether
090900170131           //  a previous change to the subfile has been made....
091000170131           //
091100170131           If *IN82 = *OFF;
091200170131             ReadC HSS200C;
091201170131             *IN99 = %Eof;
091300170131             RRNT = RRNX;
091400170131             RRNT += 1;
091500170131           Else;
091600170131             If RRNT = 101;
091700170131               Leave;
091800170131             EndIf;
091900170131             Chain RRNT HSS200C;
091901170131             *IN99 = not %Found;
092000170131             RRNT += 1;
092100170131           EndIf;
092200170131           //
092300170131           //                     READCHSS200C                  99
092400170131           //  Retrieve subfile record.
092500170131           If *IN99 = *OFF;                                                     // ...If2
092600170131             TPROD1 = XKPROD;
092700170131             TQTYN1 = %Dec(%Subst(%EditC(TQTYN1:'X'):1:6)
092701170131                    + %EditC(XKQTYN:'X')
092702170131                       :15:0);
092800170131             *IN82 = *ON;
092900170131             //
093000170131             //  Reset subfile error indicators.
093100170131             *In36 = '0';
093101170131             *In37 = '0';
093102170131             *In38 = '0';
093103170131             *In39 = '0';
093104170131             *In40 = '0';
093105170131             *In41 = '0';
093106170131             *In42 = '0';
093107170131             *In43 = '0';
093200170131             //
093300170131             If XSELC <> *BLANK                                                 // ....If3
093400170131               or XKPROD <> *BLANK                                              // ....If3
093500170131               or XNDESC <> *BLANK                                              // ....If3
093600170131               or XKPRIC <> *ZEROS                                              // ....If3
093700170131               or XKQTYN <> *ZEROS                                              // ....If3
093800170131               or XKVALU <> *ZEROS                                              // ....If3
093900170131               or XKVATA <> *ZEROS                                              // ....If3
094000170131               or XKSERC <> *BLANKS                                             // ....If3
094100170131               or XKSERF <> *ZEROS                                              // ....If3
094200170131               or XKSERT <> *ZEROS;                                             // ....If3
094300170131               //
094400170131               //  Count active subfile records.
094500170131               //                     ADD  1         RRN#
094600170131               RRNS += 1;
094700170131               //
094800170131               //  Validate Selection code.
094900170131               If XSELC <> 'S'
095000170131                 and XSELC <> 'N'
095100170131                 and XSELC <> 'T'
095200170131                 //
095300170131                 //  Validate Selection code / Product code / Text combination
095400170131                 or XSELC = *BLANK
095500170131                 and XKPROD <> *BLANKS
095600170131                 or XSELC = *BLANK
095700170131                 and XNDESC <> *BLANKS
095800170131                 or XSELC = *BLANK
095900170131                 and XKPRIC <> 0
096000170131                 or XSELC = *BLANK
096100170131                 and XKQTYN <> 0
096200170131                 or XSELC = 'T'
096300170131                 and XKPROD <> *BLANKS
096400170131                 or XSELC = 'T'
096500170131                 and XKPRIC <> 0
096600170131                 or XSELC = 'T'
096700170131                 and XKQTYN <> 0
096800170131                 or XSELC = 'T'
096900170131                 and XKSERC <> *BLANKS
097000170131                 or XSELC = 'T'
097100170131                 and XKSERF <> 0
097200170131                 or XSELC = 'T'
097300170131                 and XKSERT <> 0
097400170131                 or XSELC = 'S'
097500170131                 and XKQTYN = 0
097600170131                 //           #SELC     OREQ 'S'
097700170131                 //           #KPRIC    ANDEQ0
097800170131                 or XSELC = 'N'
097900170131                 and XKQTYN = 0
098000170131                 or XSELC = 'N'
098100170131                 and XKPRIC = 0;
098200170131                 *IN36 = *ON;
098300170131                 XERROR = XYES;
098400170131                 P0MSID = 'HSV2006';
098500170131                 Exsr YSNDMG;
098600170131               EndIf;
098700170131               //
098800170131               //  Validate Selection code for Invoice Charge Only order type.
098900170131               If XSELC = 'S'
099000170131                 and MINVC = 'Y';
099100170131                 *IN36 = *ON;
099200170131                 XERROR = XYES;
099300170131                 P0MSID = 'HSV2014';
099400170131                 Exsr YSNDMG;
099500170131               EndIf;
099600170131               //
099700170131               If YMODE = 'D'
099800170131                 and XKQTYN > XXQTYN;
099900170131                 XERROR = XYES;
100000170131                 P0MSID = 'HSV2020';
100100170131                 Exsr YSNDMG;
100200170131                 Leave;
100300170131               Else;
100400170131                 Exsr YCLRMG;
100500170131               EndIf;
100600170131               //
100700170131               //  Validate Product.
100800170131               If XSELC = 'S';
100900170131                 If XKPROD <> *BLANKS;
101000170131                   Chain XKPROD HSLPRODA;
101001170131                   *IN99 = not %Found;
101100170131                   If *IN99 = *ON;
101200170131                     *IN37 = *ON;
101300170131                     XERROR = XYES;
101400170131                     P0MSID = 'HSV2007';
101500170131                     Exsr YSNDMG;
101600170131                   Else;
101700170131                     XNDESC = NDESC;
101800170131                     XKPRIC = NPRIC;
101900170131                   EndIf;
102000170131                 EndIf;
102100170131               EndIf;
102200170131               //
102300170131               //  Reverse price for Credit
102400170131               If MSALE = 'C';
102500170131                 XKPRIC = 0 - XKPRIC;
102600170131               EndIf;
102700170131               //
102800170131               //  Extended value
102900170131               If XSELC = 'S'
103000170131                 or XSELC = 'N';
103100170131                 XKVALU = XKPRIC * XKQTYN;
103200170131                 //
103300170131                 //           #KVALU    MULT MVATP     #KVATA
103400170131               EndIf;
103500170131               //
103600170131               //  Save Price, Value and Description field contents....
103700170131               TKPRIC = XKPRIC;
103800170131               TKVALU = XKVALU;
103900170131               TNDESC = XNDESC;
104000170131               //
104100170131               //  Check quantity against allocated serial numbers.
104200170131               //           #KQTYN    IFNE 0
104300170131               //           #KSERF    ANDNE0
104400170131               //           #KSERT    ANDNE0
104500170131               //           #KSERT    SUB  #KSERF    WKQTYN
104600170131               //                     ADD  1         WKQTYN
104700170131               //           #KQTYN    IFNE WKQTYN
104800170131               //                     MOVEA'1011'    *IN,40
104900170131               //                     MOVE #YES      #ERROR
105000170131               //                     MOVEL'HSV2013' P0MSID
105100170131               //                     EXSR @SNDMG
105200170131               //                     ENDIF
105300170131               //                     ENDIF
105400170131               //
105500170131               //  Check voucher control if not yet allocated
105600170131               If XSELC = 'S'
105700170131                 and XKQTYN > 0;
105800170131                 //           #KSERC    IFEQ *BLANKS
105900170131                 //           #KSERF    ANDEQ0
106000170131                 //           #KSERT    ANDEQ0
106100170131                 WKVCTL = 'U';
106200170131                 Exsr UPVCTL;
106300170131               EndIf;
106400170131               //                     ENDIF
106500170131               //
106600170131               //  Update subfile record with DSPATR settings and set SFLRCDNBR.
106700170131               RCDNBR = RRNX;
106800170131               XKPRIC = TKPRIC;
106900170131               XKVALU = TKVALU;
107000170131               XNDESC = TNDESC;
107100170131               Update HSS200C;                                                  // SFL
107200170131               *In36 = '0';
107201170131               *In37 = '0';
107202170131               *In38 = '0';
107203170131               *In39 = '0';
107204170131               *In40 = '0';
107205170131               *In41 = '0';
107206170131               *In42 = '0';
107207170131               *In43 = '0';
107300170131               //
107400170131               //  If errors encountered in subfile then exit subfile validation.
107500170131               If XERROR = XYES;
107600170131                 TSELC = XSELC;
107700170131                 TPROD = XKPROD;
107800170131                 TPRIC = XKPRIC;
107900170131                 TQTYN = XKQTYN;
108000170131                 TDESC = XNDESC;
108100170131                 //                     Z-ADDRRN#      RRNS    50
108200170131                 Leave;
108300170131               EndIf;
108400170131               //
108500170131               //  End of non-blank subfile check.
108600170131             EndIf;                                                             // ....EndIf3
108700170131             //
108800170131             //  End of Subfile CHAIN check.
108900170131           EndIf;                                                               // ...EndIf2
109000170131           //
109100170131           //  End of loop for next subfile record.
109200170131         EndDo;                                                                 // ..EndDo1
109300170131         //
109400170131         //  Save last RRN number used.
109500170131         //                     Z-ADDRRN#      SAVRRN
109600170131         //
109700170131         //  If no errors found...
109800170131         If XERROR = XNO;
109900170131           //  ...display "Data valid.Press F10 to update" message...
110000170131           P0MSID = 'HSV9006';
110100170131           Exsr YSNDMG;
110200170131           //  ...activate F10 key (*IN61=*ON).
110300170131           *IN61 = *ON;
110400170131         EndIf;
110500170131         If XJUMP1 = XYES
110600170131           and *IN52 = *ON;
110701170131           Pgm_HSR342();
110800170131         EndIf;
110900170131         *IN52 = *OFF;
111000170131       EndSr;
111100170131       //
111200170131       // ----------------------------------------------------------------
111300170131       //  DISCNT - Discount retrieval.
111400170131       // ----------------------------------------------------------------
111500170131       //
111600170131       BegSr DISCNT;
111700170131         //
111800170131         //  If customer discount is not entered on header screen either
111900170131         //  caluclate from HSPDISC file keyed on Order Value or default
112000170131         //  according to Customer Type.
112100170131         //
112200170131         If XJDISP = 0;
112300170131           //
112400170131           //  Setup key list for HSPDISC
112500170131           //
112600170131           PFAMT = XKTVAL;
112700170131           //
112800170131           //  SETLL on HSLDISCA
112900170131           //
113000170131           Setll (ECTYP : PFAMT) HSLDISCA;
113001170131           *IN99 = %Equal;
113100170131           //
113200170131           //  If record not found READP
113300170131           //
113400170131           If *IN99 = *OFF;
113500170131             ReadP HSLDISCA;
113501170131             *IN99 = %Eof;
113600170131             //
113700170131             //  If not BOF
113800170131             //
113900170131             If *IN99 = *OFF
114000170131               and PCTYP = ECTYP;
114100170131               KDISP = PDISC;
114200170131               //
114300170131               //  Else calculate discount according to Customer Type
114400170131               //
114500170131             Else;
114600170131               //
114700170131               Select;
114800170131                   //
114900170131                   //  If Customer Type is '001' - Z-ADD 10 to discount
115000170131                   //
115100170131                 When ECTYP = '001';
115200170131                   KDISP = 10;
115300170131                   //
115400170131                   //  If Customer Type is '002' - Z-ADD 20 to discount
115500170131                   //
115600170131                 When ECTYP = '002';
115700170131                   KDISP = 20;
115800170131                   //
115900170131               EndSl;
116000170131               //
116100170131             EndIf;
116200170131             //
116300170131             //  Record found on SETLL
116400170131             //
116500170131           Else;
116600170131             //
116700170131             KDISP = PDISC;
116800170131             //
116900170131           EndIf;
117000170131           //
117100170131           //  #JDISP not equal to 0
117200170131           //
117300170131         Else;
117400170131           KDISP = XJDISP;
117500170131           //
117600170131         EndIf;
117700170131         //
117800170131       EndSr;
117900170131       //
118000170131       // ----------------------------------------------------------------
118100170131       //  Check for minimum order value.
118200170131       // ----------------------------------------------------------------
118300170131       BegSr MINVAL;
118400170131         WKTOTV = 0;
118500170131         RRNP = 1;
118600170131         //
118700170131         //  Accumulate order total value
118800170131         DoU *IN99 = *ON
118900170131           or RRNP = 100
119000170131           or XSELC = *BLANK;
119100170131           Chain RRNP HSS200C;
119101170131           *IN99 = not %Found;
119200170131           If *IN99 = *OFF;
119300170131             WKTOTV += XKVALU;
119400170131           EndIf;
119500170131           RRNP += 1;
119600170131         EndDo;
119700170131         //
119800170131         //  Compare order total value and minimum order value
119900170131         If WKTOTV < MORDV;
120000170131           XERROR = XYES;
120100170131           P0MSID = 'HSV2011';
120200170131           Exsr YSNDMG;
120300170131         EndIf;
120400170131         RRNP = 1;
120500170131         RRNX = 1;
120600170131       EndSr;
120700170131       //
120800170131       // ----------------------------------------------------------------
120900170131       //  Ship to all delivery points.
121000170131       // ----------------------------------------------------------------
121100170131       BegSr SHPALL;
121200170131         //
121300170131         //  SETLL on HSLCUSTA with Customer Number
121400170131         //
121500170131         Setll XJCUST HSLCUSTA;
121600170131         //
121700170131         //  READE on HSLCUSTA with Customer Number
121800170131         //
121900170131         ReadE XJCUST HSLCUSTA;
121901170131         *IN99 = %Eof;
122000170131         //
122100170131         //  If not EOF
122200170131         //
122300170131         DoW *IN99 = *OFF;
122400170131           //
122500170131           //  If ECGRP not equal to blanks
122600170131           //
122700170131           If ECGRP <> *BLANKS;
122800170131             //
122900170131             //  CHAIN to Customer File for Delivery Name and Address
123000170131             //
123100170131             //           ECGRP     CHAINALTCUSTF             13
123200170131             //
123300170131             //           *IN13     IFEQ *OFF
123400170131             //
123500170131             //  Write Order Header Record
123600170131             //
123700170131             Exsr UPORDH;
123800170131             //
123900170131             //  Set up Delivery Name and Address
124000170131             //
124100170131             XVNAM1 = ENAM1;
124200170131             XVADR1 = EADR1;
124300170131             XVADR2 = EADR2;
124400170131             XVADR3 = EADR3;
124500170131             XVPCDE = EPCDE;
124600170131             //
124700170131             //  Write Order Delivery Record
124800170131             //
124900170131             Exsr UPODEL;
125000170131             //
125100170131             //  Write Order Detail Record
125200170131             //
125300170131             Exsr UPORDD;
125400170131             //
125500170131             //  ECGRP equal to blanks
125600170131             //
125700170131             //                     ENDIF
125800170131             //
125900170131             //  Customer Record not found
126000170131             //
126100170131           EndIf;
126200170131           //
126300170131           //  Increment order number
126400170131           //
126500170131           In *LOCK ORDERX;
126600170131           ORDERX += 1;
126700170131           Out ORDERX;
126800170131           XJSORD = ORDERX;
126900170131           //
127000170131           //  READE on HSLCUSTA with Customer Number
127100170131           //
127200170131           ReadE XJCUST HSLCUSTA;
127201170131           *IN99 = %Eof;
127300170131           //
127400170131         EndDo;
127500170131         //
127600170131         //  EOF on HSLCUSTA
127700170131         //
127800170131       EndSr;
127900170131       //
128000170131       // ----------------------------------------------------------------
128100170131       //  Update voucher control.
128200170131       // ----------------------------------------------------------------
128300170131       BegSr UPVCTL;
128400170131         //
128500170131         *IN85 = *ON;
128600170131         //  Save order line values
128700170131         //
128800170131         XQUAN = 0;
128900170131         XJUMP = XNO;
129000170131         //  Clear flag for successful range allocation.
129100170131         WKRANG = *Blanks;
129200170131         //
129300170131         //  Clear flag for first tracking record found.
129400170131         XFIRST = XNO;
129500170131         //
129600170131         //  Get Serial number range.
129700170131         WKSERC = *Blanks;
129800170131         DoU *IN92 = *ON
129900170131           or WKRANG = 'Y';
130000170131           //
130100170131           //  Work back through the subfile checking for duplicate
130200170131           //  product codes.... If found validate data under DOUB subroutine.
130300170131           //
130400170131           RRNXX = RRNX;
130500170131           DoU RRNX = 0;
130600170131             RRNX -= 1;
130700170131             If RRNX = 0;
130800170131               Leave;
130900170131             EndIf;
131000170131             Chain RRNX HSS200C;
131001170131             *IN90 = not %Found;
131100170131             If XKPROD = TPROD1;
131200170131               RRNX = RRNXX;
131300170131               Exsr DOUB;
131400170131               *IN81 = *ON;
131500170131               Leave;
131600170131             EndIf;
131700170131           EndDo;
131800170131           //
131900170131           //  Reset subfile position.....
132000170131           RRNX = RRNXX;
132100170131           Chain RRNX HSS200C;
132101170131           *IN90 = not %Found;
132200170131           //
132300170131           //  Exit from subroutine if DOUB sr has been processed....
132400170131           //
132500170131           If *IN81 = *ON;
132600170131             XKSERF = XKSERF;
132700170131             XKSERC = XKSERC;
132800170131             XKSERT = XKSERT;
132900170131             *IN81 = *OFF;
133000170131             Leave;
133100170131           EndIf;
133200170131           //
133300170131           Setll (XKPROD : WKSERC) HSLVCTLA;
133400170131           ReadE XKPROD HSLVCTLA;
133401170131           *IN92 = %Eof;
133500170131           //
133600170131           //  Move pointer file values into temporary fields....
133700170131           //
133800170131           OPROD = BPROD;
133900170131           OSERC = BSERCC;
134000170131           OSERN = BSERNN;
134100170131           WKSERN = BSERNN;
134200170131           WKSERC = BSERCC;
134300170131           XXSERF = BSERNN;
134400170131           // *******             SUB  1         ##SERF
134500170131           //
134600170131           //
134700170131           If *IN92 = *OFF;
134800170131             //
134900170131             //  Scan voucher tracking file for first available voucher....
135000170131             //
135100170131             XKSERC = BSERCC;
135200170131             XKSERF = OSERN;
135300170131             //
135400170131             DoU *IN94 = *ON
135500170131               or XQUAN = XKQTYN;
135600170131               //
135700170131               If *IN85 = *ON;
135800170131                 Setll (XKPROD : XKSERC : XKSERF) HSLTRACB;
135900170131                 *IN85 = *OFF;
136000170131               EndIf;
136100170131               //
136200170131               ReadE XKPROD HSLTRACB;
136201170131               *IN94 = %Eof;
136300170131               //
136400170131               If *IN94 = *ON;
136500170131                 Leave;
136600170131               EndIf;
136700170131               //
136800170131               If ASERC <> WKSERC
136900170131                 or ASERN <> WKSERN
137000170131                 or AALLD <> *ZEROS;
137100170131                 DSERN += 1;
137200170131                 //
137300170131                 If *IN87 = *OFF;
137400170131                   XXRES = XXSERN + 1;
137500170131                   //           XXRES     IFNE ASERN
137600170131                   //                     MOVE ASERN     ##SERF
137700170131                   //                     ELSE
137800170131                   XXSERF = ASERN;
137900170131                   XXSERF += 1;
138000170131                   WKSERN += 1;
138100170131                   *IN85 = *ON;
138200170131                   XKSERF += 1;
138300170131                   //                     ENDIF
138400170131                 Else;
138500170131                   //
138600170131                   //  No previous error so add to HSPEXPA.....
138700170131                   XXSERC = WKSERC;
138800170131                   XXSERN = WKSERN;
138900170131                   WKSERN -= 1;
139000170131                   XJUMP = XYES;
139100170131                   XJUMP1 = XYES;
139200170131                   //
139300170131                   // ***       *IN87     IFEQ *ON
139400170131                   USERNS = XXSERF;
139500170131                   USERNE = WKSERN;
139600170131                   USERCC = WKSERC;
139700170131                   UPROD = XKPROD;
139800170131                   Open HSLEXPAA;
139900170131                   Write HSFEXPA;
140000170131                   Close HSLEXPAA;
140100170131                   // ****                ENDIF
140200170131                   //
140300170131                   XXSERF = ASERN;
140400170131                   DSERN += 1;
140500170131                   If DSERN <> ASERN;
140600170131                     DIF = ASERN - DSERN;
140700170131                     XXSERF += DIF;
140800170131                   EndIf;
140900170131                   //
141000170131                   XKSERF += 1;
141100170131                   WKSERN += 2;
141200170131                   *IN85 = *ON;
141300170131                   *IN87 = *OFF;
141400170131                   //
141500170131                   If ASERC <> WKSERC;
141600170131                     WKSERC = ASERC;
141700170131                     WKSERN = ASERN;
141800170131                     XKSERC = WKSERC;
141900170131                     XKSERF = WKSERN;
142000170131                     XXSERF = WKSERN;
142100170131                     *IN85 = *ON;
142200170131                   EndIf;
142300170131                   //
142400170131                   Iter;
142500170131                 EndIf;
142600170131                 //
142700170131                 If ASERC <> WKSERC;
142800170131                   WKSERC = ASERC;
142900170131                   WKSERN = ASERN;
143000170131                   XKSERC = WKSERC;
143100170131                   XKSERF = WKSERN;
143200170131                   XXSERF = WKSERN;
143300170131                   *IN85 = *ON;
143400170131                 EndIf;
143500170131                 //
143600170131               EndIf;
143700170131               //
143800170131               //
143900170131               If AALLD = *ZEROS;
144000170131                 // **        *IN87     IFEQ *OFF
144100170131                 // **                  ADD  1         ##SERF
144200170131                 // **                  ENDIF
144300170131                 *IN87 = *ON;
144400170131                 XQUAN += 1;
144500170131                 XFIRST = XYES;
144600170131                 WKSERC = ASERC;
144700170131                 DSERN = ASERN;
144800170131                 WKSERN += 1;
144900170131                 XKSERF += 1;
145000170131                 *IN85 = *ON;
145100170131                 Iter;
145200170131               Else;
145300170131                 Iter;
145400170131               EndIf;
145500170131               //
145600170131             EndDo;
145700170131             //
145800170131             If XFIRST = XNO;
145900170131               XERROR = XYES;
146000170131               P0MSID = 'HSV2024';
146100170131               Exsr YSNDMG;
146200170131               Clear XKSERC;
146300170131               Clear XKSERT;
146400170131               Clear XKSERF;
146500170131               Leave;
146600170131             EndIf;
146700170131             //
146800170131             If XQUAN <> XKQTYN;
146900170131               XERROR = XYES;
147000170131               P0MSID = 'HSV2025';
147100170131               Exsr YSNDMG;
147200170131               Clear XKSERC;
147300170131               Clear XKSERT;
147400170131               Clear XKSERF;
147500170131               // ****                MOVE *ON       *IN52
147600170131               Leave;
147700170131             EndIf;
147800170131             //
147900170131             *IN52 = *ON;
148000170131             //
148100170131             If XJUMP = XYES;
148200170131               // **                  MOVE #YES      #ERROR
148300170131               P0MSID = 'HSV2026';
148400170131               Exsr YSNDMG;
148500170131               //
148600170131               WKSERN -= 1;
148700170131               WKRANG = 'Y';
148800170131               //
148900170131               // ****                MOVE XXSERC    #KSERC
149000170131               // ****                MOVE XXSERN    #KSERF
149100170131               // ****      TRCKEY    CHAINHSLTRACB             99
149200170131               // ****      *IN99     IFEQ *OFF
149300170131               // ****                ADD  1         ##SERF
149400170131               // ****                ENDIF
149500170131               //
149600170131               USERNS = XXSERF;
149700170131               USERNE = WKSERN;
149800170131               USERCC = WKSERC;
149900170131               Open HSLEXPAA;
150000170131               Write HSFEXPA;
150100170131               Close HSLEXPAA;
150200170131               //
150300170131               Clear XKSERC;
150400170131               Clear XKSERT;
150500170131               Clear XKSERF;
150600170131               Exsr YJUMP;
150700170131               *IN86 = *ON;
150800170131               *IN61 = *ON;
150900170131               Leave;
151000170131             EndIf;
151100170131             //
151200170131             //  Series code found.
151300170131             XKSERC = BSERCC;
151400170131             //
151500170131             XKSERF = OSERN;
151600170131             WKSERN -= 1;
151700170131             XKSERT = WKSERN;
151800170131             //
151900170131             //  Flag successful range allocation.
152000170131             WKRANG = 'Y';
152100170131             //
152200170131             //  Update if required.
152300170131           EndIf;
152400170131         EndDo;
152500170131         //
152600170131         //  Unsuccessful range allocation.
152700170131         If WKRANG <> 'Y';
152800170131           *In41 = '1';
152801170131           *In42 = '1';
152802170131           *In43 = '1';
152900170131           // ***                 MOVE #YES      #ERROR
153000170131           P0MSID = 'HSV2012';
153100170131           Exsr YSNDMG;
153200170131         EndIf;
153300170131         //
153400170131       EndSr;
153500170131       //
153600170131       // ----------------------------------------------------------------
153700170131       //  Display contents of HSLEXPAA
153800170131       // ----------------------------------------------------------------
153900170131       //
154000170131       BegSr YJUMP;
154100170131       EndSr;
154200170131       //
154300170131       //
154400170131       // ----------------------------------------------------------------
154500170131       //  Delete contents of HSLEXPAA
154600170131       // ----------------------------------------------------------------
154700170131       //
154800170131       BegSr YDELT;
154901170131         Pgm_HSC200A();
155000170131       EndSr;
155100170131       //
155200170131       // ----------------------------------------------------------------
155300170131       //  Repeat of Product Code in a single order
155400170131       // ----------------------------------------------------------------
155500170131       //
155600170131       BegSr DOUB;
155700170131         //
155800170131         //  Get Serial number range.
155900170131         WKSERC = *Blanks;
156000170131         DoU *IN92 = *ON
156100170131           or WKRANG = 'Y';
156200170131           //
156300170131           Setll (XKPROD : WKSERC) HSLVCTLA;
156400170131           ReadE XKPROD HSLVCTLA;
156401170131           *IN92 = %Eof;
156500170131           If *IN92 = *OFF;
156600170131             //
156700170131             //  Get available series code.
156800170131             XXSERN = BSERNN + TQTYN1;
156900170131             //           ##SERN    IFGT BSERNE
157000170131             //                     MOVELBSERCN    WKSERC
157100170131             Iter;
157200170131           Else;
157300170131             //
157400170131             //  Work back through the subfile searching for duplicate
157500170131             //  product code/series code combination records......
157600170131             //
157700170131             RRNXX = RRNX;
157800170131             DoU RRNX = 0;
157900170131               RRNX -= 1;
158000170131               If RRNX = 0;
158100170131                 *IN83 = *ON;
158200170131                 Leave;
158300170131               EndIf;
158400170131               Chain RRNX HSS200C;
158401170131               *IN90 = not %Found;
158500170131               If XKSERC = BSERCC;
158600170131                 RES = XKSERT + TQTYN1;
158700170131                 //           RES       IFLE BSERNE
158800170131                 KKSERC = XKSERC;
158900170131                 KKSERT = XKSERT;
159000170131                 Leave;
159100170131               Else;
159200170131                 *IN84 = *ON;
159300170131                 Leave;
159400170131               EndIf;
159500170131               //                     ENDIF
159600170131             EndDo;
159700170131             //
159800170131             //  Reset the subfile pointer position.....
159900170131             RRNX = RRNXX;
160000170131             Chain RRNX HSS200C;
160001170131             *IN90 = not %Found;
160100170131             //
160200170131             If *IN84 = *OFF
160300170131               and *IN83 = *OFF;
160400170131               //  Series code found.
160500170131               XKSERC = KKSERC;
160600170131               //
160700170131               //  Set To serial number for the order.
160800170131               XKSERT = RES;
160900170131               //
161000170131               //  Set From Serial Number for the order.
161100170131               XKSERF = KKSERT + 1;
161200170131               //
161300170131               //  Set Next Serial Number for the voucher control.
161400170131               BSERNN += TQTYN1;
161500170131               //
161600170131               //  Flag successful range allocation.
161700170131               WKRANG = 'Y';
161800170131               Iter;
161900170131             EndIf;
162000170131             //
162100170131             If *IN83 = *ON
162200170131               and *IN84 = *OFF;
162300170131               *IN83 = *OFF;
162400170131               //
162500170131               //  Series code found.
162600170131               XKSERC = BSERCC;
162700170131               //
162800170131               //  Set To serial number for the order.
162900170131               XKSERT = BSERNN + TQTYN1;
163000170131               XKSERT -= 1;
163100170131               //
163200170131               //  Set From Serial Number for the order.
163300170131               XKSERF = BSERNN;
163400170131               //
163500170131               //  Set Next Serial Number for the voucher control.
163600170131               BSERNN += TQTYN1;
163700170131               //
163800170131               //  Flag successful range allocation.
163900170131               WKRANG = 'Y';
164000170131               Iter;
164100170131             EndIf;
164200170131             *IN84 = *OFF;
164300170131             //                     MOVELBSERCN    WKSERC
164400170131             //
164500170131             //                     ENDIF
164600170131           EndIf;
164700170131         EndDo;
164800170131       EndSr;
164900170131       // ----------------------------------------------------------------
165000170131       //  Update voucher tracking.
165100170131       // ----------------------------------------------------------------
165200170131       BegSr UPTRAC;
165300170131         //
165400170131         //  Reverse order date before update.
165500170131         If YMODE = 'E';
165600170131           WKD = JDD;
165700170131           WKM = JMM;
165800170131           WKC = JCC;
165900170131           WKY = JYY;
166000170131           ADFIS = WKORDD;
166100170131         EndIf;
166200170131         //
166300170131         //  Locate voucher record.
166400170131         Setll (XKPROD : XKSERC : XKSERF) HSLTRACB;
166500170131         DoU XKPROD <> APROD
166600170131           or *IN99 = *ON;
166700170131           Read HSLTRACB;
166701170131           *IN99 = %Eof;
166800170131           If *IN99 = *OFF;
166900170131             //
167000170131             //  Exit if product code or series code does not match.
167100170131             If XKPROD <> APROD
167200170131               or XKSERC <> ASERC;
167300170131               Leave;
167400170131             EndIf;
167500170131             //
167600170131             //  Update vouchers in the serial number range.
167700170131             If XKSERF <= ASERN
167800170131               and XKSERT >= ASERN;
167900170131               If YMODE = 'D';
168000170131                 ACUST = XJCUST;
168100170131                 ADSPB = 0;
168200170131               Else;
168300170131                 //
168400170131                 ASORD = XJSORD;
168500170131                 ADFIS = WKORDD;
168600170131                 Update HSFTRAC;
168700170131               EndIf;
168800170131             EndIf;
168900170131           EndIf;
169000170131         EndDo;
169100170131       EndSr;
169200170131       //
169300170131       // ----------------------------------------------------------------
169400170131       //  Update inventory allocations.
169500170131       // ----------------------------------------------------------------
169600170131       BegSr UPINVA;
169700170131         //
169800170131         //  Update stock quantities.
169900170131         Chain (XKPROD : WKSUBC) HSLINVMA;
169901170131         *IN99 = not %Found;
170000170131         If *IN99 = *OFF;
170100170131           //
170200170131           //  Increase allocated quantity and reduce available quantity.
170300170131           DQTYR += XKQTYN;
170400170131           DQTYF -= XKQTYN;
170500170131           Update HSFINVM;
170600170131         EndIf;
170700170131       EndSr;
170800170131       //
170900170131       // ----------------------------------------------------------------
171000170131       //  Update inventory sales.
171100170131       // ----------------------------------------------------------------
171200170131       BegSr UPINVS;
171300170131         //
171400170131         //  Update stock quantities.
171500170131         Chain (XKPROD : WKSUBC) HSLINVMA;
171501170131         *IN99 = not %Found;
171600170131         If *IN99 = *OFF;
171700170131           //
171800170131           //  Reduce allocated quantity and reduce on-hand quantity.
171900170131           DQTYR -= XKQTYN;
172000170131           DQTYO -= XKQTYN;
172100170131           Update HSFINVM;
172200170131         EndIf;
172300170131       EndSr;
172400170131       //
172500170131       // ----------------------------------------------------------------
172600170131       //  Print delivery note.
172700170131       // ----------------------------------------------------------------
172800170131       BegSr PRTDEL;
172900170131         ORDPRM = %EditC(XJSORD:'X');
173001170131         Pgm_HSR230(ORDPRM);
173200170131       EndSr;
173300170131       //
173400170131       // ----------------------------------------------------------------
173500170131       //  Print invoice.
173600170131       // ----------------------------------------------------------------
173700170131       BegSr PRTINV;
173800170131         ORDPRM = %EditC(XJSORD:'X');
173901170131         Pgm_HSR220(ORDPRM);
174100170131       EndSr;
174200170131       //
174300170131       // ----------------------------------------------------------------
174400170131       //  Create order details.
174500170131       // ----------------------------------------------------------------
174600170131       BegSr UPORDD;
174700170131         //
174800170131         //  Order line already exists
174900170131         UPDAT = ' ';
175000170131         If XOLIN > 0;
175100170131           Chain (XJSORD : XOLIN) HSLORDDB;
175101170131           *IN98 = not %Found;
175200170131           KLINE = XOLIN;
175300170131         EndIf;
175400170131         //
175500170131         //  Write fields for order detail record.
175600170131         KLTYP = XSELC;
175700170131         KCOMP = XJCOMP;
175800170131         KTYPE = XJTYPE;
175900170131         KSORD = XJSORD;
176000170131         KLINE = RRNX;
176100170131         KCUST = XJCUST;
176200170131         KPROD = XKPROD;
176300170131         KSERC = XKSERC;
176400170131         KSERNF = XKSERF;
176500170131         KELEMF = 0;
176600170131         KSERNT = XKSERT;
176700170131         KELEMT = 0;
176800170131         KQTYN = XKQTYN;
176900170131         KCOST = NCOST;
177000170131         KPRIC = XKPRIC;
177100170131         KVALU = XKVALU;
177200170131         //
177300170131         //  Obtain VAT% from Order Type record.
177400170131         //           #KVALU    MULT .175      KVATA
177500170131         //           #KVALU    MULT MVATP     KVATA
177600170131         //           KVATA     DIV  100       KVATA     H
177700170131         KCRTD = CYMD;
177800170131         KCRTT = XXTME;
177900170131         %Subst(KDESC:1:19) = XNDESC;
178000170131         KCRTS = XJOBNO;
178100170131         KCRTU = XUSRID;
178200170131         KCRTP = XPGMID;
178300170131         KDELT = *Blanks;
178400170131         //
178500170131         //  Update order detail record.
178600170131         If XOLIN > 0;
178700170131           If *IN98 = *OFF;
178800170131             UPDAT = 'Y';
178900170131             Update HSFORDD;
179000170131           EndIf;
179100170131         Else;
179200170131           //
179300170131           //  Write order detail record.
179400170131           Write HSFORDD;
179500170131         EndIf;
179600170131       EndSr;
179700170131       //
179800170131       // ----------------------------------------------------------------
179900170131       //  Create order header.
180000170131       // ----------------------------------------------------------------
180100170131       BegSr UPORDH;
180200170131         //
180300170131         //  Program mode - Maintenance, or Dispatch
180400170131         If YMODE = 'M'
180500170131           or YMODE = 'D';
180600170131           //
180700170131           //  Access order header record.
180800170131           Chain XJSORD HSLORDHA;
180801170131           *IN99 = not %Found;
180900170131         EndIf;
181000170131         //
181100170131         //  Write fields for order header record.
181200170131         JCOMP = XJCOMP;
181300170131         JCUST = XJCUST;
181400170131         JCUSB = *Blanks;
181500170131         JORDR = XJORDR;
181600170131         JTYPE = XJTYPE;
181700170131         JSORD = XJSORD;
181800170131         JORDD = WKORDD;
181900170131         JINVN = *Blanks;
182000170131         JINVD = 0;
182100170131         JDELN = *Blanks;
182200170131         JDELD = 0;
182300170131         JCRTD = CYMD;
182400170131         JCRTT = XXTME;
182500170131         JCRTS = XJOBNO;
182600170131         JCRTU = XUSRID;
182700170131         JCRTP = XPGMID;
182800170131         JDELT = *Blanks;
182900170131         //
183000170131         //  Program mode - Entry
183100170131         If YMODE = 'E';
183200170131           //
183300170131           //  Write order header record.
183400170131           JSTAT = 'A';
183500170131           Write HSFORDH;
183600170131         EndIf;
183700170131         //
183800170131         //  Program mode - Maintenance, or Dispatch
183900170131         If YMODE = 'M'
184000170131           or YMODE = 'D';
184100170131           If YMODE = 'D';
184200170131             JDELD = *DATE;
184300170131             JSTAT = 'D';
184400170131           EndIf;
184500170131           //
184600170131           //  Update order header record.
184700170131           If *IN99 = *OFF;
184800170131             Update HSFORDH;
184900170131           EndIf;
185000170131         EndIf;
185100170131       EndSr;
185200170131       //
185300170131       // ----------------------------------------------------------------
185400170131       //  Create order delivery details.
185500170131       BegSr UPODEL;
185600170131         //
185700170131         //  Program mode - Maintenance, or Dispatch
185800170131         If YMODE = 'M'
185900170131           or YMODE = 'D';
186000170131           //
186100170131           Chain XJSORD HSFODEL;
186101170131           *IN99 = not %Found;
186200170131         EndIf;
186300170131         //
186400170131         //  Write fields for order delivery detail record.
186500170131         VCOMP = XJCOMP;
186600170131         VTYPE = XJTYPE;
186700170131         VSORD = XJSORD;
186800170131         VNAM1 = XVNAM1;
186900170131         VADR1 = XVADR1;
187000170131         VADR2 = XVADR2;
187100170131         VADR3 = XVADR3;
187200170131         VPCDE = XVPCDE;
187300170131         VDIN1 = XVDIN1;
187400170131         VDIN2 = XVDIN2;
187500170131         VDIN3 = XVDIN3;
187600170131         VDELT = *Blanks;
187700170131         //
187800170131         //  Program mode - Entry
187900170131         If YMODE = 'E';
188000170131           //
188100170131           //  Write order delivery details record.
188200170131           Write HSFODEL;
188300170131         EndIf;
188400170131         //
188500170131         //  Program mode - Maintenance, or Dispatch
188600170131         If YMODE = 'M'
188700170131           or YMODE = 'D';
188800170131           //
188900170131           //  Update order delivery details record.
189000170131           If *IN99 = *OFF;
189100170131             Update HSFODEL;
189200170131           EndIf;
189300170131         EndIf;
189400170131         //
189500170131       EndSr;
189600170131       // ----------------------------------------------------------------
189700170131       //  Create inventory sales transaction.
189800170131       // ----------------------------------------------------------------
189900170131       BegSr UPINVT;
190000170131         //
190100170131         //  Write fields for inventory sales transaction record.
190200170131         CCOMP = XJCOMP;
190300170131         CWHSE = XJWHSE;
190400170131         CPROD = XKPROD;
190500170131         CSUBCF = *Blanks;
190600170131         CSUBCT = *Blanks;
190700170131         CVTYP = *Blanks;
190800170131         CSERC = XKSERC;
190900170131         CSERNF = XKSERF;
191000170131         CELEMF = 0;
191100170131         CSERNT = XKSERT;
191200170131         CELEMT = 0;
191300170131         CQTYN = XKQTYN;
191400170131         CBATC = 0;
191500170131         CDELN = %EditC(XJSORD:'X');
191600170131         CREAS = *Blanks;
191700170131         CTDAT = CYMD;
191800170131         CTYPE = MTTYP;
191900170131         CSUPP = *Blanks;
192000170131         CCUST = XJCUST;
192100170131         CAREA = *Blanks;
192200170131         CAISL = *Blanks;
192300170131         CBAYR = *Blanks;
192400170131         CLEVL = *Blanks;
192500170131         CINVN = *Blanks;
192600170131         CCRTD = CYMD;
192700170131         CCRTT = XXTME;
192800170131         CCRTS = XJOBNO;
192900170131         CCRTU = XUSRID;
193000170131         CCRTP = XPGMID;
193100170131         CDELT = *Blanks;
193200170131         //
193300170131         //  Write inventory sales transaction record.
193400170131         Write HSFINVT;
193500170131       EndSr;
193600170131       //
193700170131       // ----------------------------------------------------------------
193800170131       //  VALIDH - Validate header screen.
193900170131       // ----------------------------------------------------------------
194000170131       //
194100170131       BegSr VALIDH;
194200170131         //
194300170131         //  Screen Header validation:
194400170131         //
194500170131         //  Reset work values.
194600170131         Reset XERROR;
194700170131         *IN61 = *OFF;                                                          // Hide F10/F11
194800170131         //
194900170131         //  Reset error indicators.
195000170131         pAToArrStr = %Addr(*IN(30));
195001170131         %Subst(AToArrStr:1:19) = XZEROS;
195100170131         //
195200170131         //  Validate that Order Type is a valid Type.
195300170131         Chain XJTYPE HSLORDPA;
195301170131         *IN99 = not %Found;
195400170131         If *IN99 = *ON;
195500170131           *IN30 = *ON;
195600170131           XERROR = XYES;
195700170131           P0MSID = 'HSV2001';
195800170131           Exsr YSNDMG;
195900170131         EndIf;
196000170131         //
196100170131         //  Validate that Company is valid.
196200170131         If XJCOMP <> *BLANKS;
196300170131           Chain XJCOMP HSLCOMPA;
196301170131           *IN99 = not %Found;
196400170131           If *IN99 = *ON;
196500170131             *IN31 = *ON;
196600170131             XERROR = XYES;
196700170131             P0MSID = 'HSV2002';
196800170131             Exsr YSNDMG;
196900170131           EndIf;
197000170131         EndIf;
197100170131         //
197200170131         //  Validate that Warehouse is valid.
197300170131         If XJWHSE <> *BLANKS;
197400170131           Chain XJWHSE HSLWHSEA;
197401170131           *IN99 = not %Found;
197500170131           If *IN99 = *ON;
197600170131             *IN32 = *ON;
197700170131             XERROR = XYES;
197800170131             P0MSID = 'HSV0006';
197900170131             Exsr YSNDMG;
198000170131           EndIf;
198100170131         EndIf;
198200170131         //
198300170131         //  Validate Post Code
198400170131         If XJCUST = *BLANKS;
198500170131           If XJPCDE <> *BLANKS;
198600170131             Chain XJPCDE HSLCUSTB;
198601170131             *IN99 = not %Found;
198700170131             If *IN99 = *ON;
198800170131               *IN33 = *ON;
198900170131               XERROR = XYES;
199000170131               P0MSID = 'HSV2003';
199100170131               Exsr YSNDMG;
199200170131             EndIf;
199300170131             //
199400170131             //  If Customer is found
199500170131             If *IN99 = *OFF;
199600170131               //  ...load Customer record into screen fields.
199700170131               XJNAM1 = ENAM1;                                                  // Name 1
199800170131               XJNAM2 = ENAM2;                                                  // Name 2
199900170131               XJADR1 = EADR1;                                                  // Address 1
200000170131               XJADR2 = EADR2;                                                  // Address 2
200100170131               XJCUST = ECUST;                                                  // Cust No.
200200170131               XJCLIM = ECLIM;                                                  // Credit Limit
200300170131               XJTYSL = ETYSL;                                                  // Last Year Sales
200400170131             EndIf;
200500170131             //
200600170131           EndIf;
200700170131         EndIf;
200800170131         //
200900170131         //  Validate Customer Number
201000170131         //           #JCUST    IFNE *BLANKS
201100170131         Chain XJCUST HSLCUSTA;
201101170131         *IN99 = not %Found;
201200170131         If *IN99 = *ON;
201300170131           *IN34 = *ON;
201400170131           XERROR = XYES;
201500170131           P0MSID = 'HSV2004';
201600170131           Exsr YSNDMG;
201700170131         EndIf;
201800170131         //
201900170131         //  If Customer is found
202000170131         If *IN99 = *OFF;
202100170131           //  ...load Customer record into screen fields.
202200170131           XJNAM1 = ENAM1;                                                      // Name 1
202300170131           XJNAM2 = ENAM2;                                                      // Name 2
202400170131           XJADR1 = EADR1;                                                      // Address 1
202500170131           XJADR2 = EADR2;                                                      // Address 2
202600170131           XJPCDE = EPCDE;                                                      // Post Code
202700170131           XJCLIM = ECLIM;                                                      // Credit Limit
202800170131           XJTYSL = ETYSL;                                                      // Last Year Sales
202900170131           //
203000170131           //  Check customer's credit rating allows order entry......
203100170131           If ECRAT = '01 ';
203200170131             *IN34 = *ON;
203300170131             XERROR = XYES;
203400170131             P0MSID = 'HSV2018';
203500170131             Exsr YSNDMG;
203600170131           EndIf;
203700170131           //
203800170131         EndIf;
203900170131         //                     ENDIF
204000170131         //
204100170131         //  Maximum discount is 40%
204200170131         If XJDISP > 40;
204300170131           *IN36 = *ON;
204400170131           XERROR = XYES;
204500170131           P0MSID = 'HSV0142';
204600170131           Exsr YSNDMG;
204700170131         EndIf;
204800170131         //
204900170131         //  Check order date
205000170131         If XJORDD = 0;
205100170131           Exsr YDATEC;
205200170131         Else;
205300170131           //
205400170131           //  a) Check for leap year and adjust number of days in February
205500170131           //     in Days in Month array.
205600170131           REM = JYY / 4;
205700170131           If REM = 0;
205800170131             LEAP = 'Y';
205900170131           Else;
206000170131             LEAP = ' ';
206100170131           EndIf;
206200170131           Select;
206300170131             When LEAP = ' ';
206400170131               DIM(2) = 28;
206500170131             When LEAP = 'Y';
206600170131               DIM(2) = 29;
206700170131           EndSl;
206800170131           //  Day
206900170131           If JDD > 31
207000170131             or JDD < 01
207100170131             //  Month
207200170131             or JMM > 12
207300170131             or JMM < 01;
207400170131             //
207500170131             //  If date error found...
207600170131             *IN35 = *ON;
207700170131             XERROR = XYES;
207800170131             P0MSID = 'HSV2005';
207900170131             Exsr YSNDMG;
208000170131           EndIf;
208100170131           //
208200170131           //  Validate Day within month.
208300170131           M = JMM;
208400170131           If JDD < 1
208500170131             or JMM >= 1
208600170131             and JMM <= 12
208700170131             and JDD > DIM(M);
208800170131             //
208900170131             //  If date error found...
209000170131             *IN35 = *ON;
209100170131             XERROR = XYES;
209200170131             P0MSID = 'HSV2005';
209300170131             Exsr YSNDMG;
209400170131           EndIf;
209500170131         EndIf;
209600170131         //
209700170131         //  If no errors found...
209800170131         If XERROR = XNO;
209900170131           //  ...display "Data valid.Press F10 to update" message...
210000170131           P0MSID = 'HSV9006';
210100170131           Exsr YSNDMG;
210200170131           //  ...activate F10 key (*IN61=*ON).
210300170131           *IN61 = *ON;
210400170131         EndIf;
210500170131         //
210600170131       EndSr;
210700170131       //
210800170131       // ----------------------------------------------------------------
210900170131       //  @DATEC - Date Check Routine
211000170131       // ----------------------------------------------------------------
211100170131       //
211200170131       BegSr YDATEC;
211300170131         //
211400170131         //  Convert six-digit system date to eight digits, with century.
211500170131         DD = UDAY;
211600170131         MM = UMONTH;
211700170131         YY = UYEAR;
211800170131         If YY > 80;
211900170131           CC = 19;
212000170131         Else;
212100170131           CC = 20;
212200170131         EndIf;
212300170131         CCYY = %Dec(%EditC(CC:'X')
212301170131                 + %Subst(%EditC(CCYY:'X'):3:2)
212302170131                 :4:0);
212400170131         CCYY = %Dec(%Subst(%EditC(CCYY:'X'):1:2)
212401170131                + %EditC(YY:'X')
212402170131                   :4:0);
212500170131         //
212600170131         //  Set default date for order entry.
212700170131         If XJORDD = 0;
212800170131           XJORDD = DMCY;
212900170131         EndIf;
213000170131         //
213100170131         //  Set date for transaction audit field.
213200170131         DDD = DD;
213300170131         MMM = MM;
213400170131         CCC = CC;
213500170131         YYY = YY;
213600170131       EndSr;
213700170131       //
213800170131       // ----------------------------------------------------------------
213900170131       //  @SERCH - F4 prompt control.
214000170131       // ----------------------------------------------------------------
214100170131       //
214200170131       BegSr YSERCH;
214300170131         //
214400170131         //  Check that cursor is in a valid field for prompting.
214500170131         If CSRRCD = 'HSS200A'
214600170131           and CSRFLD = 'XJCUST'
214700170131           or CSRRCD = 'HSS200A'
214800170131           and CSRFLD = 'XJTYPE'
214900170131           or CSRRCD = 'HSS200A'
215000170131           and CSRFLD = 'XJCOMP'
215100170131           or CSRRCD = 'HSS200A'
215200170131           and CSRFLD = 'XJWHSE'
215300170131           or CSRRCD = 'HSS200A'
215400170131           and CSRFLD = 'XJPCDE'
215500170131           or CSRRCD = 'HSS200C'
215600170131           and CSRFLD = 'XKPROD';
215700170131           //
215800170131           //  Move appropriate data to parameter fields depending upon search
215900170131           //  field chosen.
216000170131           Select;
216100170131               //
216200170131               //  Customer No.
216300170131             When CSRFLD = 'XJCUST';
216400170131               FILEY = 'HSLCUSTA';
216500170131               NAMEY = 'ENAM1';
216600170131               NUMBRY = 'ECUST';
216700170131               //
216800170131               //  Post Code
216900170131             When CSRFLD = 'XJPCDE';
217000170131               FILEY = 'HSLCUSTB';
217100170131               NAMEY = 'ENAM1';
217200170131               NUMBRY = 'EPCDE';
217300170131               //
217400170131               //  Order Type.
217500170131             When CSRFLD = 'XJTYPE';
217600170131               FILEY = 'HSLORDPA';
217700170131               NAMEY = 'MODES';
217800170131               NUMBRY = 'MOTYP';
217900170131               //
218000170131               //  Company Code
218100170131             When CSRFLD = 'XJCOMP';
218200170131               FILEY = 'HSLCOMPA';
218300170131               NAMEY = 'WODES';
218400170131               NUMBRY = 'WCOMP';
218500170131               //
218600170131               //  Warehouse Code
218700170131             When CSRFLD = 'XJWHSE';
218800170131               FILEY = 'HSLWHSEA';
218900170131               NAMEY = 'PODES';
219000170131               NUMBRY = 'PWHSE';
219100170131               //
219200170131               //  Product Code
219300170131             When CSRFLD = 'XKPROD';
219400170131               FILEY = 'HSLPRODA';
219500170131               NAMEY = 'NDESC';
219600170131               NUMBRY = 'NPROD';
219700170131               //
219800170131           EndSl;
219900170131           //
220000170131           //  Call system window program to retrieve data.  If Return Code is
220100170131           //  *OFF then load retrieved data into screen fields.
220200170131           LINY = 10;
220300170131           COLY = 8;
220401170131           Pgm_HSR341(YRTNC : YNUMBR : FILEY : NAMEY : NUMBRY : LINY :
220402170131                 COLY);
220500170131           //
220600170131           //  If Return Code is *OFF then load retrieved data into
220700170131           //  appropriate screen fields.
220800170131           If YRTNC = *OFF;                                                     // ..If2
220900170131             //
221000170131             Select;
221100170131                 //
221200170131                 //  Customer No.
221300170131               When CSRFLD = 'XJCUST';
221400170131                 XJCUST = YNUMBR;
221500170131                 //
221600170131                 //  Post Code
221700170131               When CSRFLD = 'XJPCDE';
221800170131                 XJPCDE = YNUMBR;
221900170131                 //
222000170131                 //  Customer Type.
222100170131               When CSRFLD = 'XJTYPE';
222200170131                 XJTYPE = YNUMBR;
222300170131                 //
222400170131                 //  Company Code
222500170131               When CSRFLD = 'XJCOMP';
222600170131                 XJCOMP = YNUMBR;
222700170131                 //
222800170131                 //  Warehouse Code
222900170131               When CSRFLD = 'XJWHSE';
223000170131                 XJWHSE = YNUMBR;
223100170131                 //
223200170131                 //  Product Code
223300170131               When CSRFLD = 'XKPROD';
223400170131                 XKPROD = YNUMBR;
223500170131                 //
223600170131             EndSl;
223700170131           EndIf;                                                               // ..EndIf2
223800170131           //
223900170131           //  otherwise cursor is in wrong format/field so display message.
224000170131         Else;                                                                  // .ElseIf1
224100170131           P0MSID = 'HSV9009';
224200170131           Exsr YSNDMG;
224300170131         EndIf;                                                                 // .EndIf1
224400170131         //
224500170131       EndSr;
224600170131       //
224700170131       // ----------------------------------------------------------------
224800170131       //  @SERSF - F4 prompt control for order detail subfile.
224900170131       // ----------------------------------------------------------------
225000170131       //
225100170131       BegSr YSERSF;
225200170131         //  Clear row / column control.
225300170131         CSRROW = 0;
225400170131         CSRCOL = 0;
225500170131         //
225600170131         //  Retrieve the current cursor position.
225700170131         ROW = CSRLOC / 256;
225800170131         COL = %Rem(CSRLOC : 256);
225900170131         CSRROW = ROW;
226000170131         CSRCOL = COL;
226100170131         //
226200170131         //  Execute search.
226300170131         Exsr YSERCH;
226400170131         //
226500170131         //  Flag subfile record to return value.
226600170131         Chain CSRRRN HSS200C;
226601170131         *IN99 = not %Found;
226700170131         If *IN99 = *OFF;
226800170131           *IN37 = *ON;
226900170131           If YNUMBR <> *BLANKS;
227000170131             XKPROD = YNUMBR;
227100170131           EndIf;
227200170131           Update HSS200C;
227300170131           *IN37 = *OFF;
227400170131         EndIf;
227500170131       EndSr;
227600170131       //
227700170131       // ----------------------------------------------------------------
227800170131       //  @SNDMG - Send message to this program's MSGQ.
227900170131       // ----------------------------------------------------------------
228000170131       //
228100170131       BegSr YSNDMG;
228200170131         //
228301170131         Pgm_SNDMSGC(P0PGMQ : P0PGRL : P0MSID : P0MSGF : P0MSDA :
228302170131               P0MSTP);
229000170131         //
229100170131       EndSr;
229200170131       //
229300170131       // ----------------------------------------------------------------
229400170131       //  @CLRMG - Clear message(s) from this program's MSGQ.
229500170131       // ----------------------------------------------------------------
229600170131       //
229700170131       BegSr YCLRMG;
229800170131         //
229901170131         Pgm_RMVMSGC();
230000170131         //
230100170131       EndSr;
230200170131       //
230300170131       // ----------------------------------------------------------------
230400170131       //  *UPPVCT- Update the voucher control
230500170131       // ----------------------------------------------------------------
230600170131       //
230700170131       BegSr UPPVCT;
230800170131         RRNQ = 1;
230900170131         Chain RRNQ HSS200C;
230901170131         *IN97 = not %Found;
231000170131         DoW *IN97 = *OFF;
231100170131           //
231200170131           RRNQ += 1;
231300170131           If XSELC <> *BLANK
231400170131             or XKPROD <> *BLANK
231500170131             or XNDESC <> *BLANK
231600170131             or XKPRIC <> *ZEROS
231700170131             or XKQTYN <> *ZEROS
231800170131             or XKVALU <> *ZEROS
231900170131             or XKVATA <> *ZEROS
232000170131             or XKSERC <> *BLANKS
232100170131             or XKSERF <> *ZEROS
232200170131             or XKSERT <> *ZEROS;
232300170131             WKSERC = XKSERC;
232400170131             TEMP = XKSERT;
232500170131             TEMP += 1;
232600170131             Setll (XKPROD : WKSERC) HSLVCTLA;
232700170131             ReadE XKPROD HSLVCTLA;
232701170131             *IN92 = %Eof;
232800170131             BSERNN = TEMP;
232900170131             Update HSFVCTL;
233000170131           EndIf;
233100170131           //
233200170131           If RRNQ = 100;
233300170131             Leave;
233400170131           EndIf;
233500170131           Chain RRNQ HSS200C;
233501170131           *IN97 = not %Found;
233600170131         EndDo;
233700170131       EndSr;
233800170131       //
233900170131       // ----------------------------------------------------------------
234000170131       //  *INZSR - Initialization.
234100170131       // ----------------------------------------------------------------
234200170131       //
234300170131       BegSr *INZSR;
234400170131         //
234500170131         //  Dummy read to open file.
234600170131         Read HSPINVT;
234601170131         *IN99 = %Eof;
234700170131         Update HSFINVT;
234800170131         Open HSLEXPAA;
234900170131         Read HSLEXPAA;
234901170131         *IN99 = %Eof;
235000170131         Close HSLEXPAA;
235100170131         //
235200170131         //  Key lists.
235300170131         //  Key List for Voucher Control.
235800170131         //  Key List for Voucher Cross-Reference.
236400170131         //  Key List for Sales Order.
236900170131         //  Key List for Inventory Masterfile.
237300170131         WKSUBC = *Blanks;
237400170131         //
237500170131         //  Key List for Voucher Tracking.
238100170131         //  Key List for Customer Discount File.
238600170131         //  Parameter Lists.
238700170131         //  Entry parameter list.
239300170131         //
239400170131         //  List for Call to HSR341 - Search program.
240400170131         //  Field definitions
241400170131         //  Variable declarations.
241500170131         XNO = '0';
241600170131         XYES = '1';
241700170131         XERROR = XNO;
241800170131         XUPDAT = XNO;
241900170131         XDELET = XNO;
242000170131         ORDPRM = *Blanks;
242100170131         RCDNBR = 1;
242200170131         RRNX = 0;
242300170131         RRNVAL = 0;
242400170131         RRNLIN = 0;
242500170131         RRNQ = 0;
242600170131         RRNP = 0;
242700170131         //
242800170131         //  Prepare message subfile.
242900170131         *IN79 = *ON;
243000170131         P0PGMQ = XPGMID;                                                       // Program queu
243100170131         %Subst(P0PGRL:1:4) = '*PRV';                                           // Rel queue
243200170131         P0MSID = *Blanks;                                                      // Message ID
243300170131         %Subst(P0MSGF:1:6) = 'HSM001';                                         // Message file
243400170131         P0MSDA = *Blanks;                                                      // Message data
243500170131         %Subst(P0MSTP:1:5) = '*INFO';                                          // Message type
243600170131         //
243700170131         Exsr YDATEC;
243800170131         //
243900170131       EndSr;
244000990215** Days in Month array DIM.
244100990215312831303130313130313031
