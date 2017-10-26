000001888888      *%CSTD===========================================================*
000002888888      ** Application. : STS Arcad Sample application                   *
000003888888      ** Composant. . : HSR200ECS                     Type: RPGLE      *
000004888888      **===============================================================*
000005888888      ** Sous-système : TRD Trade                                      *
000006888888      ** Fonction . . :                                                *
000007888888      ** Sous-fonction:                                                *
000008888888      **%S=============================================================*
000009888888      ** Description des fonctionnalités:                              *
000011888888      **                                                               *
000012888888      **                                                               *
000013888888      **                                                               *
000014888888      **%E=============================================================*
000015888888      ** AUTEUR:                          00:00                        *
000016888888      ** MODIFS: 01 MICHEL     28/11/2012 15:28  V 4.00.E FM N°12/0045 *
000017888888      **           Adapt HSR200 to BAtch Process (remove screen)       *
000018888888      *%ECSTD==========================================================*
001800990122      */TITLE Sales Order Entry / Maintenance / Inquiry
001900990106      *
002000990106      * System        : HSV Control & Tracking
002100990122      * Author        : Bob Lee (Intec Systems)
002200990106      * Date          : January 1999
002300990106      *
002400990106      *================================================================
002500990106      * Indicator usage:
002600990219      *  20 - Order Valid for Despatch
002700990128      *  30 - 45 Input fields- DSPATR.
002800990128      *  79 - MSGSFL (SFLCLR ETC...).
002900990106      *  99 - General CHAIN/SETLL result.
003000990106      *
003100990106      *================================================================
003200990222     H DATEDIT(*YMD)
003300990125     FHSLCUSTB  IF   E           K DISK
003400990125     F                                     RENAME(HSFCUST:HSFCUSTB)
003500990125      * Customer Master by Post Code.
003600990125      *
003700990122     FHSLCUSTA  IF   E           K DISK
003800990125      * Customer Master by Customer Account.
003900990106      *
004000990318     F*LTCUSTAIF  E           K        DISK
004100990318     F*           HSFCUST                           KRENAMEALTCUSTF
004200990216      * Customer Master by Customer Account.
004300990216      *
004400990122     FHSLORDPA  IF   E           K DISK
004500990122      * Sales Order Parameters.
004600990302      *
004700990302     FHSLEXPAA  UF A E           K DISK    USROPN
004800990302      * Unbanded Order line file by Product/Series/Serial No.
004900990122      *
005000990127     FHSLVCTLA  UF   E           K DISK
005100990122      * Voucher Control.
005200990122      *
005300990223     FHSLVXRFB  IF   E           K DISK
005400990122      * Agency Product Cross-Reference.
005500990122      *
005600990203     FHSLORDHA  UF A E           K DISK
005700990122      * Sales Order Header.
005800990122      *
005900990211     FHSLORDDB  UF A E           K DISK
006000990122      * Sales Order Detail.
006100990122      *
006200990204     FHSLODELA  UF A E           K DISK
006300990122      * Sales Order Delivery Detail.
006400990122      *
006500990125     FHSLSHPOA  IF   E           K DISK
006600990122      * Ship Only.
006700990302      *
006800990128     FHSLINVMA  UF   E           K DISK
006900990122      * Inventory Master.
007000990122      *
007100990125     FHSLWHSEA  IF   E           K DISK
007200990122      * Warehouse Master.
007300990122      *
007400990125     FHSLCOMPA  IF   E           K DISK
007500990122      * Company Master.
007600990122      *
007700990126     FHSLPRODA  IF   E           K DISK
007800990122      * Product Master.
007900990122      *
008000990215     FHSLDISCA  IF   E           K DISK
008100990215      * Customer Discount File
008200990215      *
008300990217BL   FHSPINVT   UF A E           K DISK
008400990122      * Inventory Transactions.
008500990122      *
008600121128     F***200    CF   E             WORKSTN INFDS(INFDS)
008700121128     F***                                  SFILE(HSS200C:RRNX)
008800990106      * Screen file.
008900990106      *================================================================
009000990107      * Arrays.
009100990107      *
009200990215      * Days in Month for date validation.
009300990215     D DIM             S              2  0 DIM(12) CTDATA PERRCD(12)
009400990107      *================================================================
009500990301      * Data Structures.
009600990106      *
009700990106      * Screen Information DS.
009800990106     D INFDS           DS
009900990106     D  KEY                  369    369
010000990127     D  CSRLOC               370    371B 0
010100990106      *
010200000728     D XXXSDS         SDS           429
010300000728     D  XPGMID           *PROC
010400000728     D  XJOBNO               244    253
010500000728     D  XUSRID               254    263
010600990125      *
010700990121      * General DDMMCCYY date format.
010800990121     D                 DS
010900990204     D  DD                     1      2  0 INZ
011000990204     D  MM                     3      4  0 INZ
011100990204     D  CC                     5      6  0 INZ
011200990204     D  YY                     7      8  0 INZ
011300990125     D  DMCY                   1      8  0
011400990128      *
011500990128      * General CCYYMMDD date format.
011600990128     D                 DS
011700990204     D  CCC                    1      2  0 INZ
011800990204     D  YYY                    3      4  0 INZ
011900990204     D  MMM                    5      6  0 INZ
012000990204     D  DDD                    7      8  0 INZ
012100990128     D  CYMD                   1      8  0
012200990106      *
012300990128      * Input order date format.
012400990125     D                 DS
012500990126     D  JDD                    1      2  0 INZ
012600990126     D  JMM                    3      4  0 INZ
012700990126     D  JCC                    5      6  0 INZ
012800990126     D  JYY                    7      8  0 INZ
012900000728     D  XJORDD                 1      8  0
013000990125      *
013100990128      * Output order date format.
013200990128     D                 DS
013300990204     D  WKC                    1      2  0 INZ
013400990204     D  WKY                    3      4  0 INZ
013500990204     D  WKM                    5      6  0 INZ
013600990204     D  WKD                    7      8  0 INZ
013700990128     D  WKORDD                 1      8  0
013800990128      *
013900990106      *----------------------------------------------------------------
014000990106      * Constants.
014100990106      *
014200990106      * Named hexidecimal constants for function keys.
014300990119      *
014400990119      * Zeros to "SETOF" error indicators.
014500000728     D XZEROS          C                   CONST('0000000000000000000')
014600990106      *
014700990106      *================================================================
014800990106      * M A I N L I N E
014900990106      *================================================================
015000990210      *
015100990203      * Program mode
015200000728     C                   EXSR      YCLRSC
015300121121XXX  C                   MOVEL     YCUST         XJCUST
015400121128XXX  C                   MOVEL     YTYPE         XJTYPE            3
015500990225XXX  C                   MOVE      *OFF          *IN47
015600990225      *
015700121121ZZZ  C     XJTYPE        CHAIN     HSLORDPA                           99
015800990302ZZZ  C     MSALE         IFEQ      'C'
015900990302ZZZ  C                   MOVE      *ON           *IN30
016000990302ZZZ  C                   MOVEL     'HSV2027'     P0MSID
016100000728ZZZ  C                   EXSR      YSNDMG
016200121120     C                   MOVE      *ON           *INLR                          If Type not good out
016300990302ZZZ  C                   ENDIF
016400990302      *
016500990121      *
016600990122      * Validate header screen fields.
016700990122     C                   EXSR      VALIDH
016800990121      *
016900990122      * Validate ship only requirements.
017000990122     C                   EXSR      SHPONL
017100990225      *
017200990127      * Clear messages.
017300000728     C                   EXSR      YCLRMG
017400990204      *
017500990128      *-------------------------------------------------------
017600990215      * Program mode - Entry
017700990128      * Retrieve order number.
017800000728     C     *DTAARA       DEFINE    HSAORDERNO    ORDERX            8 0
017900000728     C     *LOCK         IN        ORDERX
018000000728     C                   ADD       1             ORDERX
018100000728     C                   OUT       ORDERX
018200000728     C                   Z-ADD     ORDERX        XJSORD
018300990128      *
018400990127     C     DET           TAG
018500121120     C                   MOVEL     *ON           *IN73
018600121128     C                   ADD       XKVALU        XKTVAL            9 2
018700121128     C                   TIME                    XXTME             6 0
018800990205     C                   MOVEA     '011'         *IN(70)
018900990127     C                   MOVEL     *OFF          *IN73
019000990302     C                   MOVEL     *OFF          *IN86
019100990122      *
019200990223      * Validate order detail screen fields.
019300990223     C                   EXSR      VALIDD
019400990122      *
019500990122      * Discount retrieval.
019600990122     C                   EXSR      DISCNT
019700990122      *
019800990122      * Check for minimum order value.
019900990225      *
020000990225XXX   * Credit limit check.... Warning only.
020100000728XXX  C     XKTVAL        ADD       XJTYSL        TOT              20 5
020200000728XXX  C     TOT           IFGT      XJCLIM
020300990225XXX  C                   MOVE      *ON           *IN46
020400990225XXX  C                   MOVEL     'HSV2019'     P0MSID
020500000728XXX  C                   EXSR      YSNDMG
020600990225XXX  C                   ENDIF
020700990225      *
020800990127      *
020900990122      *
021000990223      *
021100990122      *
021200990128      * Update all files, if no errors exist.
021300121121     C     XERROR        IFEQ      XNO
021400000728     C                   Z-ADD     1             RRNX
021500121120     C                   SETOFF                                       98
021600121120     C     XSELC         IFNE      *BLANK
021700121120     C     XKPROD        ANDNE     *BLANK
021800990211     C     *IN98         ANDEQ     *OFF
021900000728     C     XSELC         ORNE      *BLANK
022000000728     C     XNDESC        ANDNE     *BLANK
022100990211     C     *IN98         ANDEQ     *OFF
022200990225      *
022300990223      *
022400990225OWE   * Update Voucher Control if in entry mode....
022500121121BL   C     MSALE         IFEQ      'S'
022600990223OWE  C                   EXSR      UPPVCT
022700990223OWE  C                   ENDIF
022800990223      *
022900990218BL    * Create/Update order details if in Entry,Maint,or Dispatch mode.
023000990122     C                   EXSR      UPORDD
023100990218      *
023200990218BL    * Update voucher tracking if in Entry or Dispatch mode.
023300990218BL    * Stock lines only.
023400990219      *
023500990219BL    * Allocate inventory if in Entry mode.
023600990219BL    * Stock lines only.
023700121121BL   C     XSELC         IFEQ      'S'
023800990219      * Update inventory allocations.
023900990219     C                   EXSR      UPINVA
024000990219     C                   ENDIF
024100990218      *
024200990219BL    * Sell inventory if in Dispatch mode.
024300990218BL    * Stock lines only.
024400121121     C                   ENDIF                                                   ****?***
024500990211      *
024600990218BL    * Create/Update order header if in Entry,Maint,or Dispatch mode.
024700990211     C                   EXSR      UPORDH
024800990211      *
024900990218      * Create/update delivery record if in Entry,Maint or Dispat.mode.
025000990211     C                   EXSR      UPODEL
025100990128      *
025200990218BL    * Ship to all delivery points if in Entry mode.
025300121121BL   C     MALLP         IFEQ      'Y'
025400990128     C                   EXSR      SHPALL
025500990218BL   C                   ENDIF
025600990128      *
025700990218BL    * Print delivery note if in Entry mode, and charges only not set.
025800121121BL   C     MINVC         IFNE      'Y'
025900990128     C                   EXSR      PRTDEL
026000990218BL   C                   ENDIF
026100990128      *
026200990218BL    * Print Invoice if in Entry mode, and Immediate print required.
026300121121BL   C     MINVP         IFEQ      'I'
026400990128     C                   EXSR      PRTINV
026500990217BL   C                   ENDIF
026600990218      *
026700990128     C                   ENDIF
026800990302      *
026900121120     C                   SETON                                        LR
027000990122      *
027100990106      *****************************************************************
027200990120      *----------------------------------------------------------------
027300000728      * Ã CLRSC - Clear screen fields.
027400990120      *----------------------------------------------------------------
027500990120      *
027600000728     C     YCLRSC        BEGSR
027700990120      *
027800121121BL    * Clear header fields.
027900121128     C                   CLEAR                   XJCOMP            6
028000121128     C                   CLEAR                   XJWHSE            3
028100121128     C                   CLEAR                   XJPCDE           10
028200121128     C                   CLEAR                   XJCUST            8
028300121128     C                   CLEAR                   XJDISP            5 2
028400121128     C                   CLEAR                   XJORDD            8 0
028500121128     C                   CLEAR                   XJORDR           15
028600990120      *
028700121121BL    * Clear delivery fields.
028800121128BL   C                   CLEAR                   XVNAM1           30
028900121128BL   C                   CLEAR                   XVADR1           30
029000121128BL   C                   CLEAR                   XVADR2           30
029100121128BL   C                   CLEAR                   XVADR3           30
029200121128BL   C                   CLEAR                   XVPCDE           10
029300121128BL   C                   CLEAR                   XVDIN1           30
029400121128BL   C                   CLEAR                   XVDIN2           30
029500121128BL   C                   CLEAR                   XVDIN3           30
029600990120     C                   ENDSR
029700990122      *
029800990122      *----------------------------------------------------------------
029900990122      * SHPONL - Validate ship only requirements.
030000990122      *----------------------------------------------------------------
030100990122     C     SHPONL        BEGSR
030200990125      *
030300990125      * Check if a ship only record exists for this customer
030400000728     C     XJCUST        CHAIN     HSLSHPOA                           99
030500990125     C     *IN99         IFEQ      *OFF
030600990125     C                   MOVEL     'Y'           SHONLY            1
030700990218BL   C                   ELSE
030800990218BL   C                   MOVEL     ' '           SHONLY
030900990125     C                   ENDIF
031000990122     C                   ENDSR
031100990122      *
031200990122      *----------------------------------------------------------------
031300990122      * AGXREF - Check for agency cross-references.
031400990122      *----------------------------------------------------------------
031500990122     C     AGXREF        BEGSR
031600990223     C     KEYXRF        CHAIN     HSLVXRFB                           99
031700990126     C     *IN99         IFEQ      *OFF
031800990128     C                   MOVEL     HPROD         KPROD
031900000728     C                   MOVEL     HPROD         XKPROD
032000990126     C                   ENDIF
032100990122     C                   ENDSR
032200990122      *
032300990122      *----------------------------------------------------------------
032400121121      * VALIDD - Validate order detail
032500990122      *----------------------------------------------------------------
032600990122     C     VALIDD        BEGSR
032700990126      *
032800990126      * Order Detail validation:
032900990126      *
033000990223OWE   *
033100121128     C                   MOVEL     'N'           XSELC             1
033200121121     C                   MOVEL     YPROD         XKPROD
033300121121     C                   MOVEL     YTEXT         XNDESC
033400121121     C                   Z-ADD     YPRIC         XKPRIC
033500121121     C                   Z-ADD     YQTYN         XKQTYN
033600121128     C                   Z-ADD     0             XKVALU
033700121128     C***                MOVEL     *BLANK        XKSERC
033800121128     C***                Z-ADD     0             XKSERF
033900121128     C***                Z-ADD     0             XKSERT
034000990126      *
034100121120     C
034200000728     C     XSELC         IFNE      *BLANK                                       ....If3
034300000728     C     XKPROD        ORNE      *BLANK                                       ....If3
034400000728     C     XNDESC        ORNE      *BLANK                                       ....If3
034500000728     C     XKPRIC        ORNE      *ZEROS                                       ....If3
034600000728     C     XKQTYN        ORNE      *ZEROS                                       ....If3
034700000728     C     XKVALU        ORNE      *ZEROS                                       ....If3
034800000728     C     XKVATA        ORNE      *ZEROS                                       ....If3
034900121128     C***  XKSERC        ORNE      *BLANKS                                      ....If3
035000121128     C***  XKSERF        ORNE      *ZEROS                                       ....If3
035100121128     C***  XKSERT        ORNE      *ZEROS                                       ....If3
035200990126      *
035300990126      * Validate Selection code.
035400000728     C     XSELC         IFNE      'S'
035500000728     C     XSELC         ANDNE     'N'
035600000728     C     XSELC         ANDNE     'T'
035700990127      *
035800990127      * Validate Selection code / Product code / Text combination
035900000728     C     XSELC         OREQ      *BLANK
036000000728     C     XKPROD        ANDNE     *BLANKS
036100000728     C     XSELC         OREQ      *BLANK
036200000728     C     XNDESC        ANDNE     *BLANKS
036300000728     C     XSELC         OREQ      *BLANK
036400000728     C     XKPRIC        ANDNE     0
036500000728     C     XSELC         OREQ      *BLANK
036600000728     C     XKQTYN        ANDNE     0
036700000728     C     XSELC         OREQ      'T'
036800000728     C     XKPROD        ANDNE     *BLANKS
036900000728     C     XSELC         OREQ      'T'
037000000728     C     XKPRIC        ANDNE     0
037100000728     C     XSELC         OREQ      'T'
037200000728     C     XKQTYN        ANDNE     0
037300121128     C*    XSELC         OREQ      'T'
037400121128     C*    XKSERC        ANDNE     *BLANKS
037500121128     C*    XSELC         OREQ      'T'
037600121128     C*    XKSERF        ANDNE     0
037700121128     C*    XSELC         OREQ      'T'
037800121128     C*    XKSERT        ANDNE     0
037900000728     C     XSELC         OREQ      'S'
038000000728     C     XKQTYN        ANDEQ     0
038100000728     C     XSELC         OREQ      'N'
038200000728     C     XKQTYN        ANDEQ     0
038300000728     C     XSELC         OREQ      'N'
038400000728     C     XKPRIC        ANDEQ     0
038500990126     C                   MOVE      *ON           *IN36
038600000728     C                   MOVE      XYES          XERROR
038700990126     C                   MOVEL     'HSV2006'     P0MSID
038800000728     C                   EXSR      YSNDMG
038900990126     C                   ENDIF
039000990218      *
039100990218      * Validate Selection code for Invoice Charge Only order type.
039200000728     C     XSELC         IFEQ      'S'
039300990218     C     MINVC         ANDEQ     'Y'
039400990218     C                   MOVE      *ON           *IN36
039500000728     C                   MOVE      XYES          XERROR
039600990218     C                   MOVEL     'HSV2014'     P0MSID
039700000728     C                   EXSR      YSNDMG
039800990218     C                   ENDIF
039900990126      *
040000990126      * Validate Product.
040100000728     C     XSELC         IFEQ      'S'
040200000728     C     XKPROD        IFNE      *BLANKS
040300000728     C     XKPROD        CHAIN     HSLPRODA                           99
040400990126     C     *IN99         IFEQ      *ON
040500990126     C                   MOVE      *ON           *IN37
040600000728     C                   MOVE      XYES          XERROR
040700990126     C                   MOVEL     'HSV2007'     P0MSID
040800000728     C                   EXSR      YSNDMG
040900990127     C                   ELSE
041000000728     C                   MOVEL     NDESC         XNDESC
041100000728     C                   Z-ADD     NPRIC         XKPRIC
041200990201     C                   ENDIF
041300990201     C                   ENDIF
041400990201     C                   ENDIF
041500990127      *
041600990127      * Reverse price for Credit
041700990127     C     MSALE         IFEQ      'C'
041800000728     C                   Z-SUB     XKPRIC        XKPRIC
041900990127     C                   ENDIF
042000990127      *
042100990127      * Extended value
042200000728     C     XSELC         IFEQ      'S'
042300000728     C     XSELC         OREQ      'N'
042400000728     C     XKPRIC        MULT      XKQTYN        XKVALU
042500990126     C                   ENDIF
042600990223      *
042700990223OWE   * Save Price, Value and Description field contents....
042800000728OWE  C                   MOVE(P)   XKPRIC        TKPRIC            9 2
042900121128OWE  C                   MOVE(P)   XKVALU        TKVALU
043000000728OWE  C                   MOVE(P)   XNDESC        TNDESC           19
043100990223      *
043200990128      * Check voucher control if not yet allocated
043300990126      *
043400121120OWE  C                   MOVE      TKPRIC        XKPRIC
043500121128OWE  C                   MOVE      TKVALU        XKVALU
043600121120OWE  C                   MOVE      TNDESC        XNDESC
043700990126      *
043800990126     C                   ENDIF                                                  ....EndIf3
043900990126      *
044000990126      * If no errors found...
044100990122     C                   ENDSR
044200990122      *
044300990122      *----------------------------------------------------------------
044400990122      * DISCNT - Discount retrieval.
044500990122      *----------------------------------------------------------------
044600990216      *
044700990122     C     DISCNT        BEGSR
044800990216      *
044900121121      * If customer discount is not entered either
045000990216      * caluclate from HSPDISC file keyed on Order Value or default
045100990216      * according to Customer Type.
045200990216      *
045300000728     C     XJDISP        IFEQ      0
045400990216      *
045500990216      * Setup key list for HSPDISC
045600990216      *
045700000728     C                   Z-ADD     XKTVAL        PFAMT
045800990216      *
045900990216      * SETLL on HSLDISCA
046000990216      *
046100990216     C     DSCKEY        SETLL     HSLDISCA                               99
046200990216      *
046300990216      * If record not found READP
046400990216      *
046500990216     C     *IN99         IFEQ      *OFF
046600990215     C                   READP     HSLDISCA                               99
046700990216      *
046800990216      * If not BOF
046900990216      *
047000990216     C     *IN99         IFEQ      *OFF
047100990223BL   C     PCTYP         ANDEQ     ECTYP
047200990215     C                   Z-ADD     PDISC         KDISP
047300990216      *
047400990216      * Else calculate discount according to Customer Type
047500990216      *
047600990215     C                   ELSE
047700990216      *
047800990215     C                   SELECT
047900990216      *
048000990216      * If Customer Type is '001' - Z-ADD 10 to discount
048100990216      *
048200990215     C     ECTYP         WHENEQ    '001'
048300990215     C                   Z-ADD     10            KDISP
048400990216      *
048500990216      * If Customer Type is '002' - Z-ADD 20 to discount
048600990216      *
048700990215     C     ECTYP         WHENEQ    '002'
048800990215     C                   Z-ADD     20            KDISP
048900990216      *
049000990215     C                   ENDSL
049100990216      *
049200990215     C                   ENDIF
049300990216      *
049400990216      * Record found on SETLL
049500990216      *
049600990216     C                   ELSE
049700990216      *
049800990216     C                   Z-ADD     PDISC         KDISP
049900990216      *
050000990216     C                   ENDIF
050100990216      *
050200000728      * Â£JDISP not equal to 0
050300990216      *
050400990215     C                   ELSE
050500000728     C                   Z-ADD     XJDISP        KDISP
050600990216      *
050700990215     C                   ENDIF
050800990216      *
050900990122     C                   ENDSR
051000990122      *
051100990122      *
051200990122      *----------------------------------------------------------------
051300990122      * Ship to all delivery points.
051400990122      *----------------------------------------------------------------
051500990122     C     SHPALL        BEGSR
051600990216     C*
051700000728     C     XJCUST        SETLL     HSLCUSTA
051800000728     C     XJCUST        READE     HSLCUSTA                               99
051900990216     C*
052000121121     C     *IN99         DOWEQ     *OFF
052100990216     C*
052200990216     C* If ECGRP not equal to blanks
052300990216     C*
052400990216     C     ECGRP         IFNE      *BLANKS
052500990216     C*
052600990216     C* Write Order Header Record
052700990216     C*
052800990216     C                   EXSR      UPORDH
052900990216     C*
053000990216     C* Set up Delivery Name and Address
053100990216     C*
053200000728     C                   MOVEL     ENAM1         XVNAM1
053300000728     C                   MOVEL     EADR1         XVADR1
053400000728     C                   MOVEL     EADR2         XVADR2
053500000728     C                   MOVEL     EADR3         XVADR3
053600000728     C                   MOVEL     EPCDE         XVPCDE
053700990216     C*
053800990216     C* Write Order Delivery Record
053900990216     C*
054000990216     C                   EXSR      UPODEL
054100990216     C*
054200990216     C* Write Order Detail Record
054300990216     C*
054400990216     C                   EXSR      UPORDD
054500990216     C*
054600990216     C                   ENDIF
054700990216     C*
054800990216     C* Increment order number
054900990216     C*
055000000728     C     *LOCK         IN        ORDERX
055100000728     C                   ADD       1             ORDERX
055200000728     C                   OUT       ORDERX
055300000728     C                   Z-ADD     ORDERX        XJSORD
055400990216     C*
055500990216     C* READE on HSLCUSTA with Customer Number
055600990216     C*
055700000728     C     XJCUST        READE     HSLCUSTA                               99
055800990216     C*
055900121121     C                   ENDDO
056000990216     C*
056100990216     C* EOF on HSLCUSTA
056200990216     C*
056300990122     C                   ENDSR
056400990302      *
056500990302      *
056600990302      *----------------------------------------------------------------
056700990302      * Delete contents of HSLEXPAA
056800990302      *----------------------------------------------------------------
056900990302      *
057000000728     C     YDELT         BEGSR
057100990302     C                   CALL      'HSC200A'
057200990302     C                   ENDSR
057300990302      *
057400990122      *----------------------------------------------------------------
057500990122      * Update inventory allocations.
057600990122      *----------------------------------------------------------------
057700990122     C     UPINVA        BEGSR
057800990128      *
057900990128      * Update stock quantities.
058000990205     C     IVMKEY        CHAIN     HSLINVMA                           99
058100990128     C     *IN99         IFEQ      *OFF
058200990128      *
058300990128      * Increase allocated quantity and reduce available quantity.
058400000728     C                   ADD       XKQTYN        DQTYR
058500000728     C                   SUB       XKQTYN        DQTYF
058600990128     C                   UPDATE    HSFINVM
058700990128     C                   ENDIF
058800990122     C                   ENDSR
058900990219      *
059000990122      *----------------------------------------------------------------
059100990122      * Print delivery note.
059200990122      *----------------------------------------------------------------
059300990122     C     PRTDEL        BEGSR
059400000728BL   C                   MOVEL     XJSORD        ORDPRM
059500990217BL   C                   CALL      'HSR230'
059600990217BL   C                   PARM                    ORDPRM
059700990122     C                   ENDSR
059800990122      *
059900990122      *----------------------------------------------------------------
060000990122      * Print invoice.
060100990122      *----------------------------------------------------------------
060200990122     C     PRTINV        BEGSR
060300000728BL   C                   MOVEL     XJSORD        ORDPRM
060400990217BL   C                   CALL      'HSR220'
060500990217BL   C                   PARM                    ORDPRM
060600990122     C                   ENDSR
060700990122      *
060800990122      *----------------------------------------------------------------
060900990122      * Create order details.
061000990122      *----------------------------------------------------------------
061100990122     C     UPORDD        BEGSR
061200990215      *
061300990215      * Order line already exists
061400990215     C                   MOVEL     ' '           UPDAT
061500000728     C     XOLIN         IFGT      0
061600990215     C     KEYOLN        CHAIN     HSLORDDB                           98
061700000728     C                   Z-ADD     XOLIN         KLINE
061800990215     C                   ENDIF
061900990128      *
062000990128      * Write fields for order detail record.
062100000728     C                   MOVEL     XSELC         KLTYP
062200000728     C                   MOVEL     XJCOMP        KCOMP
062300000728     C                   MOVEL     XJTYPE        KTYPE
062400000728     C                   Z-ADD     XJSORD        KSORD
062500000728     C                   Z-ADD     RRNX          KLINE
062600000728     C                   MOVEL     XJCUST        KCUST
062700000728     C                   MOVEL     XKPROD        KPROD
062800121128     C*                  MOVEL     XKSERC        KSERC
062900121128     C*                  Z-ADD     XKSERF        KSERNF
063000990128     C                   Z-ADD     0             KELEMF
063100121128     C*                  Z-ADD     XKSERT        KSERNT
063200990128     C                   Z-ADD     0             KELEMT
063300000728     C                   Z-ADD     XKQTYN        KQTYN
063400990128     C                   Z-ADD     NCOST         KCOST
063500000728     C                   Z-ADD     XKPRIC        KPRIC
063600000728     C                   Z-ADD     XKVALU        KVALU
063700990208      *
063800990218BL    * Obtain VAT% from Order Type record.
063900990128     C                   Z-ADD     CYMD          KCRTD
064000000728     C                   Z-ADD     XXTME         KCRTT
064100000728     C                   MOVEL     XNDESC        KDESC
064200000728     C                   MOVEL     XJOBNO        KCRTS
064300000728     C                   MOVEL     XUSRID        KCRTU
064400000728     C                   MOVEL     XPGMID        KCRTP
064500990128     C                   MOVEL     *BLANK        KDELT
064600990215      *
064700990215      * Update order detail record.
064800000728     C     XOLIN         IFGT      0
064900990211     C     *IN98         IFEQ      *OFF
065000990211     C                   MOVEL     'Y'           UPDAT
065100990211     C                   UPDATE    HSFORDD
065200990211     C                   ENDIF
065300990211     C                   ELSE
065400990215      *
065500990128      * Write order detail record.
065600990128     C                   WRITE     HSFORDD
065700990211     C                   ENDIF
065800990122     C                   ENDSR
065900990122      *
066000990122      *----------------------------------------------------------------
066100990122      * Create order header.
066200990122      *----------------------------------------------------------------
066300990122     C     UPORDH        BEGSR
066400990215      *
066500990128      *
066600990128      * Write fields for order header record.
066700000728     C                   MOVEL     XJCOMP        JCOMP
066800000728     C                   MOVEL     XJCUST        JCUST
066900990128     C                   MOVEL     *BLANKS       JCUSB
067000000728     C                   MOVEL     XJORDR        JORDR
067100000728     C                   MOVEL     XJTYPE        JTYPE
067200000728     C                   Z-ADD     XJSORD        JSORD
067300990128     C                   Z-ADD     WKORDD        JORDD
067400990128     C                   MOVEL     *BLANKS       JINVN
067500990128     C                   Z-ADD     0             JINVD
067600990128     C                   MOVEL     *BLANKS       JDELN
067700990128     C                   Z-ADD     0             JDELD
067800990128     C                   Z-ADD     CYMD          JCRTD
067900000728     C                   Z-ADD     XXTME         JCRTT
068000000728     C                   MOVEL     XJOBNO        JCRTS
068100000728     C                   MOVEL     XUSRID        JCRTU
068200000728     C                   MOVEL     XPGMID        JCRTP
068300990128     C                   MOVEL     *BLANK        JDELT
068400990128      *
068500990211      *
068600990128      * Write order header record.
068700990217BL   C                   MOVEL     'A'           JSTAT
068800990217     C                   WRITE     HSFORDH
068900990211      *
069000990122     C                   ENDSR
069100990122      *
069200990128      *----------------------------------------------------------------
069300990128      * Create order delivery details.
069400990128     C     UPODEL        BEGSR
069500990215      *
069600990128      * Write fields for order delivery detail record.
069700000728     C                   MOVEL     XJCOMP        VCOMP
069800000728     C                   MOVEL     XJTYPE        VTYPE
069900000728     C                   Z-ADD     XJSORD        VSORD
070000000728     C                   MOVEL     XVNAM1        VNAM1
070100000728     C                   MOVEL     XVADR1        VADR1
070200000728     C                   MOVEL     XVADR2        VADR2
070300000728     C                   MOVEL     XVADR3        VADR3
070400000728     C                   MOVEL     XVPCDE        VPCDE
070500000728     C                   MOVEL     XVDIN1        VDIN1
070600000728     C                   MOVEL     XVDIN2        VDIN2
070700000728     C                   MOVEL     XVDIN3        VDIN3
070800990128     C                   MOVEL     *BLANKS       VDELT
070900990128      *
071000990211      * Write order delivery details record.
071100990211     C                   WRITE     HSFODEL
071200990211      *
071300990128     C                   ENDSR
071400990128      *
071500990107      *----------------------------------------------------------------
071600990122      * VALIDH - Validate header screen.
071700990107      *----------------------------------------------------------------
071800990107      *
071900990122     C     VALIDH        BEGSR
072000990108      *
072100990111      * Screen Header validation:
072200990114      *
072300990125      * Reset work values.
072400000728     C                   RESET                   XERROR
072500990125      *
072600990125      * Reset error indicators.
072700000728     C                   MOVEA     XZEROS        *IN(30)
072800990125      *
072900990125      * Validate that Order Type is a valid Type.
073000121120     C     YTYPE         CHAIN     HSLORDPA                           99
073100990125     C     *IN99         IFEQ      *ON
073200990125     C                   MOVE      *ON           *IN30
073300000728     C                   MOVE      XYES          XERROR
073400990125     C                   MOVEL     'HSV2001'     P0MSID
073500000728     C                   EXSR      YSNDMG
073600990125     C                   ENDIF
073700990125      *
073800990125      * Validate that Company is valid.
073900000728     C     XJCOMP        IFNE      *BLANKS
074000000728     C     XJCOMP        CHAIN     HSLCOMPA                           99
074100990125     C     *IN99         IFEQ      *ON
074200990125     C                   MOVE      *ON           *IN31
074300000728     C                   MOVE      XYES          XERROR
074400990125     C                   MOVEL     'HSV2002'     P0MSID
074500000728     C                   EXSR      YSNDMG
074600990125     C                   ENDIF
074700990125     C                   ENDIF
074800990125      *
074900990125      * Validate that Warehouse is valid.
075000000728     C     XJWHSE        IFNE      *BLANKS
075100000728     C     XJWHSE        CHAIN     HSLWHSEA                           99
075200990125     C     *IN99         IFEQ      *ON
075300990125     C                   MOVE      *ON           *IN32
075400000728     C                   MOVE      XYES          XERROR
075500990125     C                   MOVEL     'HSV0006'     P0MSID
075600000728     C                   EXSR      YSNDMG
075700990125     C                   ENDIF
075800990125     C                   ENDIF
075900990125      *
076000990125      * Validate Post Code
076100000728XXX  C     XJCUST        IFEQ      *BLANKS
076200000728     C     XJPCDE        IFNE      *BLANKS
076300000728     C     XJPCDE        CHAIN     HSLCUSTB                           99
076400990125     C     *IN99         IFEQ      *ON
076500990125     C                   MOVE      *ON           *IN33
076600000728     C                   MOVE      XYES          XERROR
076700990125     C                   MOVEL     'HSV2003'     P0MSID
076800000728     C                   EXSR      YSNDMG
076900990125     C                   ENDIF
077000990125      *
077100990125      * If Customer is found
077200990125     C     *IN99         IFEQ      *OFF
077300990125      * ...load Customer record into screen fields.
077400121128XXXM C                   MOVEL     ENAM1         XJNAM1           30            Name 1
077500121128XXXM C                   MOVEL     ENAM2         XJNAM2           30            Name 2
077600121128XXXM C                   MOVEL     EADR1         XJADR1           30            Address 1
077700121128XXXM C                   MOVEL     EADR2         XJADR2           30            Address 2
077800000728XXXM C                   MOVE      ECUST         XJCUST                         Cust No.
077900000728XXX  C                   MOVE      ECLIM         XJCLIM           15 0          Credit Limit
078000000728XXX  C                   MOVE      ETYSL         XJTYSL           20 5          Last Year Sales
078100990225XXX  C                   ENDIF
078200990125      *
078300990125     C                   ENDIF
078400990126     C                   ENDIF
078500990125      *
078600990125      * Validate Customer Number
078700000728XXXD C*          Â£JCUST    IFNE *BLANKS
078800000728     C     XJCUST        CHAIN     HSLCUSTA                           99
078900990125     C     *IN99         IFEQ      *ON
079000990125     C                   MOVE      *ON           *IN34
079100000728     C                   MOVE      XYES          XERROR
079200990125     C                   MOVEL     'HSV2004'     P0MSID
079300000728     C                   EXSR      YSNDMG
079400990125     C                   ENDIF
079500990125      *
079600990125      * If Customer is found
079700990125     C     *IN99         IFEQ      *OFF
079800990125      * ...load Customer record into screen fields.
079900000728XXXM C                   MOVEL     ENAM1         XJNAM1                         Name 1
080000000728XXXM C                   MOVEL     ENAM2         XJNAM2                         Name 2
080100000728XXXM C                   MOVEL     EADR1         XJADR1                         Address 1
080200000728XXXM C                   MOVEL     EADR2         XJADR2                         Address 2
080300000728XXXM C                   MOVE      EPCDE         XJPCDE                         Post Code
080400000728XXX  C                   MOVE      ECLIM         XJCLIM           15 0          Credit Limit
080500000728XXX  C                   MOVE      ETYSL         XJTYSL           20 5          Last Year Sales
080600990225XXX   *
080700990225XXX   * Check customer's credit rating allows order entry......
080800990225XXX  C     ECRAT         IFEQ      '01 '
080900990225XXX  C                   MOVE      *ON           *IN34
081000000728XXX  C                   MOVE      XYES          XERROR
081100990225XXX  C                   MOVEL     'HSV2018'     P0MSID
081200000728XXX  C                   EXSR      YSNDMG
081300990225XXX  C                   ENDIF
081400990205      *
081500990205     C                   ENDIF
081600990225XXXD C*                    ENDIF
081700990205      *
081800990205      * Maximum discount is 40%
081900000728     C     XJDISP        IFGT      40
082000990205     C                   MOVE      *ON           *IN36
082100000728     C                   MOVE      XYES          XERROR
082200990205     C                   MOVEL     'HSV0142'     P0MSID
082300000728     C                   EXSR      YSNDMG
082400990205     C                   ENDIF
082500990215      *
082600990128      * Check order date
082700000728     C     XJORDD        IFEQ      0
082800000728     C                   EXSR      YDATEC
082900990125     C                   ELSE
083000990215      *
083100990215      * a) Check for leap year and adjust number of days in February
083200990215      *    in Days in Month array.
083300990215     C     JYY           DIV       4             REM               4 0
083400990215     C     REM           IFEQ      0
083500990215     C                   MOVEL     'Y'           LEAP              1
083600990215     C                   ELSE
083700990215     C                   MOVEL     ' '           LEAP
083800990215     C                   ENDIF
083900990215     C                   SELECT
084000990215     C     LEAP          WHENEQ    ' '
084100990215     C                   MOVEA     28            DIM(2)
084200990215     C     LEAP          WHENEQ    'Y'
084300990215     C                   MOVEA     29            DIM(2)
084400990215     C                   ENDSL
084500990126      * Day
084600990126     C     JDD           IFGT      31
084700990126     C     JDD           ORLT      01
084800990126      * Month
084900990125     C     JMM           ORGT      12
085000990126     C     JMM           ORLT      01
085100990215      *
085200990215      * If date error found...
085300990215     C                   MOVE      *ON           *IN35
085400000728     C                   MOVE      XYES          XERROR
085500990215     C                   MOVEL     'HSV2005'     P0MSID
085600000728     C                   EXSR      YSNDMG
085700990215     C                   ENDIF
085800990215      *
085900990215      * Validate Day within month.
086000990215     C                   Z-ADD     JMM           M                 2 0
086100990215     C     JDD           IFLT      1
086200990215     C     JMM           ORGE      1
086300990215     C     JMM           ANDLE     12
086400990215     C     JDD           ANDGT     DIM(M)
086500990128      *
086600990128      * If date error found...
086700990125     C                   MOVE      *ON           *IN35
086800000728     C                   MOVE      XYES          XERROR
086900990125     C                   MOVEL     'HSV2005'     P0MSID
087000000728     C                   EXSR      YSNDMG
087100990125     C                   ENDIF
087200990125     C                   ENDIF
087300990125      *
087400990125      *
087500990107     C                   ENDSR
087600990125      *
087700990125      *----------------------------------------------------------------
087800000728      * Ã DATEC - Date Check Routine
087900990125      *----------------------------------------------------------------
088000990125      *
088100000728     C     YDATEC        BEGSR
088200990125      *
088300990128      * Convert six-digit system date to eight digits, with century.
088400990125     C                   MOVEL     UDAY          DD
088500990125     C                   MOVEL     UMONTH        MM
088600990125     C                   MOVEL     UYEAR         YY
088700990125     C     YY            IFGT      80
088800990125     C                   Z-ADD     19            CC
088900990125     C                   ELSE
089000990125     C                   Z-ADD     20            CC
089100990125     C                   ENDIF
089200990223     C                   MOVEL     CC            CCYY              4 0
089300990223     C                   MOVE      YY            CCYY
089400990128      *
089500990128      * Set default date for order entry.
089600000728     C     XJORDD        IFEQ      0
089700000728     C                   Z-ADD     DMCY          XJORDD
089800990125     C                   ENDIF
089900990128      *
090000990128      * Set date for transaction audit field.
090100990128     C                   Z-ADD     DD            DDD
090200990128     C                   Z-ADD     MM            MMM
090300990128     C                   Z-ADD     CC            CCC
090400990128     C                   Z-ADD     YY            YYY
090500990125     C                   ENDSR
090600990127      *
090700990106      *----------------------------------------------------------------
090800000728      * Ã SNDMG - Send message to this program's MSGQ.
090900990106      *----------------------------------------------------------------
091000990106      *
091100000728     C     YSNDMG        BEGSR
091200990106      *
091300990107     C                   CALL      'SNDMSGC'
091400990106     C                   PARM                    P0PGMQ                         Program queue
091500990106     C                   PARM                    P0PGRL                         Rel queue
091600990106     C                   PARM                    P0MSID                         Message ID
091700990106     C                   PARM                    P0MSGF                         Message file
091800990106     C                   PARM                    P0MSDA                         Message data
091900990106     C                   PARM                    P0MSTP                         Message type
092000990106      *
092100990106     C                   ENDSR
092200990106      *
092300990106      *----------------------------------------------------------------
092400000728      * Ã CLRMG - Clear message(s) from this program's MSGQ.
092500990106      *----------------------------------------------------------------
092600990106      *
092700000728     C     YCLRMG        BEGSR
092800990106      *
092900990107     C                   CALL      'RMVMSGC'
093000990106      *
093100990106     C                   ENDSR
093200990106      *
093300990223      *----------------------------------------------------------------
093400990223      * *UPPVCT- Update the voucher control
093500990223      *----------------------------------------------------------------
093600990223      *
093700990223     C     UPPVCT        BEGSR
093800121128     C*    XSELC         IFNE      *BLANK
093900121128     C*    XKPROD        ORNE      *BLANK
094000121128     C*    XNDESC        ORNE      *BLANK
094100121128     C*    XKPRIC        ORNE      *ZEROS
094200121128     C*    XKQTYN        ORNE      *ZEROS
094300121128     C*    XKVALU        ORNE      *ZEROS
094400121128     C*    XKVATA        ORNE      *ZEROS
094500121128     C*    XKSERC        ORNE      *BLANKS
094600121128     C*    XKSERF        ORNE      *ZEROS
094700121128     C*    XKSERT        ORNE      *ZEROS
094800121128     C*                  MOVE      XKSERC        WKSERC
094900121128     C*                  MOVE      XKSERT        TEMP              9 0
095000121128     C*                  ADD       1             TEMP
095100121128     C*    VCHKEY        SETLL     HSLVCTLA
095200121128     C*    XKPROD        READE     HSLVCTLA                               92
095300121128     C*                  MOVE      TEMP          BSERNN
095400121128     C*                  UPDATE    HSFVCTL
095500121128     C*                  ENDIF
095600990223      *
095700990223     C                   ENDSR
095800990223      *
095900990106      *----------------------------------------------------------------
096000990106      * *INZSR - Initialization.
096100990106      *----------------------------------------------------------------
096200990106      *
096300990106     C     *INZSR        BEGSR
096400990217BL    *
096500990217BL    * Dummy read to open file.
096600990217BL   C                   READ      HSPINVT                                99
096700990222BL   C                   UPDATE    HSFINVT
096800990302     C                   OPEN      HSLEXPAA
096900990302BL   C                   READ      HSLEXPAA                               99
097000990302     C                   CLOSE     HSLEXPAA
097100990127      *
097200990106      * Key lists.
097300990128      * Key List for Voucher Control.
097400121128     C*    VCHKEY        KLIST
097500121128     C*                  KFLD                    XKPROD
097600121128     C*                  KFLD                    WKSERC
097700990223      *
097800990223      * Key List for Voucher Cross-Reference.
097900990223     C     KEYXRF        KLIST
098000990223     C                   KFLD                    CCYY
098100000728     C                   KFLD                    XJCUST
098200000728     C                   KFLD                    XKPROD
098300990205      *
098400990211      * Key List for Sales Order.
098500990211     C     KEYOLN        KLIST
098600000728     C                   KFLD                    XJSORD
098700121128     C                   KFLD                    XOLIN             4 0
098800990211      *
098900990205      * Key List for Inventory Masterfile.
099000990205     C     IVMKEY        KLIST
099100000728     C                   KFLD                    XKPROD
099200990205     C                   KFLD                    WKSUBC
099300990205     C                   MOVE      *BLANKS       WKSUBC
099400990115      *
099500990215      *
099600990301      * Key List for Customer Discount File.
099700990215     C     DSCKEY        KLIST
099800990215     C                   KFLD                    ECTYP
099900990215     C                   KFLD                    PFAMT
100000990128      *
100100990115      * Parameter Lists.
100200990203      * Entry parameter list.
100300990203     C     *ENTRY        PLIST
100400000728     C                   PARM                    YTYPE             3            Order Type
100500000728     C                   PARM                    YCUST             8            Customer No.
100600121121     C                   PARM                    YPROD            13            Product Name
100700121121     C                   PARM                    YTEXT            40            Product description
100800121121     C                   PARM                    YPRIC            20 5          Price
100900121121     C                   PARM                    YQTYN            15 0          Quantity
101000121121     C                   PARM                    XJSORD            8 0          Commande £
101100990203      *
101200990127      *
101300990127      * Field definitions
101400121128     C     *LIKE         DEFINE    KVALU         TKVALU
101500121128     C     *LIKE         DEFINE    KVALU         XKVALU
101600121128     C     *LIKE         DEFINE    KVALU         WKTOTV
101700121128     C**   *LIKE         DEFINE    XKSERC        WKSERC
101800990128     C     *LIKE         DEFINE    BSERNN        WKSERN
101900121128     C     *LIKE         DEFINE    YQTYN         WKQTYN
102000121128     C     *LIKE         DEFINE    YQTYN         XKQTYN
102100990211     C     *LIKE         DEFINE    DSUBC         WKSUBC
102200000728     C     *LIKE         DEFINE    XNO           WKRANG
102300000728     C     *LIKE         DEFINE    XNO           WKVCTL
102400000728     C     *LIKE         DEFINE    XNO           UPDAT
102500121128     C     *LIKE         DEFINE    KPRIC         XKPRIC
102600121128     C     *LIKE         DEFINE    KPROD         XKPROD
102700121128     C*
102800121128     C     *LIKE         DEFINE    KVATA         XKVATA
102900121128     C     *LIKE         DEFINE    NDESC         XNDESC
103000990106      *
103100990106      * Variable declarations.
103200000728     C                   MOVE      '0'           XNO               1
103300000728     C                   MOVE      '1'           XYES              1
103400000728     C                   MOVE      XNO           XERROR            1
103500000728     C                   MOVE      XNO           XUPDAT            1
103600000728     C                   MOVE      XNO           XDELET            1
103700990217BL   C                   MOVEL     *BLANKS       ORDPRM            8
103800000728     C                   Z-ADD     0             RRNX              5 0
103900990211     C                   Z-ADD     0             RRNVAL            5 0
104000990225     C                   Z-ADD     0             RRNLIN            5 0
104100990225     C                   Z-ADD     0             RRNQ              5 0
104200990225     C                   Z-ADD     0             RRNP              5 0
104300990106      *
104400990106      * Prepare message subfile.
104500990106     C                   MOVE      *ON           *IN79
104600000728     C                   MOVE      XPGMID        P0PGMQ           10            Program queu
104700990111     C                   MOVEL     '*PRV'        P0PGRL            5            Rel queue
104800990106     C                   MOVE      *BLANKS       P0MSID            7            Message ID
104900990106     C                   MOVEL     'HSM001'      P0MSGF           10            Message file
105000990106     C                   MOVE      *BLANKS       P0MSDA          132            Message data
105100990106     C                   MOVEL     '*INFO'       P0MSTP            7            Message type
105200990204      *
105300000728     C                   EXSR      YDATEC
105400990106      *
105500990106     C                   ENDSR
105600121121     C     DUMMY1        BEGSR
105700121128     C*                  WRITE     MSGCTL
105800121128     C*                  WRITE     HSS200A
105900121128     C*                  WRITE     HSS200B
106000121128     C*                  WRITE     HSS200E
106100121128XXXM C*                  WRITE     HSS200F
106200121128     C*                  EXFMT     HSS200D
106300121128OWE  C*                  READC     HSS200C                                99
106400121121     C                   ENDSR
106500060103** Days in Month array DIM.
106600060103312831303130313130313031
