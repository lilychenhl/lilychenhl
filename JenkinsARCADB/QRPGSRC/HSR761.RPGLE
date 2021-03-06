000100990210      */TITLE Sales Order Details Reports
000200990203      * CRTRPGPGM
000300990203      *
000400990203      * System  :  High Street Vouchers Control and Tracking
000500990203      * Author  :  Owen Sarll  (Intec Systems Ltd)
000600990203      * Date    :  January 1999.
000700990203      *
000800990203      *================================================================
000900990203      * Indicator usage:
001000990119      *
001100990203      * 03 - The main controlling do-loop.
001200990216      * 32 - DSPATR (error) - From Customer Code.
001300990216      * 33 - DSPATR (error) - To Customer Code.
001400990216      * 34 - DSPATR (error) - From Product Code.
001500990216      * 35 - DSPATR (error) - To Product Code.
001600990216      * 36 - DSPATR (error) - From Order No.
001700990216      * 37 - DSPATR (error) - To Order No.
001800990216      * 38 - DSPATR (error) - From Order Value.
001900990216      * 39 - DSPATR (error) - To Order Value.
002000990203      * 73 - Do-loop that encompasses validation subroutine and is
002100990203      *      exited from if an error is found in the data to be
002200990203      *      entered for report generation.
002300990203      * 79 - MSGSFL (SFLCLR ETC...)
002400990210      * 94 - Chain Customer File.
002500990210      * 95 - Chain Product File.
002600990203      *
002700990203      *===============================================================
002800990210     FHSLCUSTAIF  E           K        DISK
002900990210      * Customer File by Customer Code.
003000990210     FHSLPRODAIF  E           K        DISK
003100990210      * Product Code file by Product Code.
003200990210     FHSS761  CF  E                    WORKSTN      KINFDS INFDS
003300990203      * Screen file.
003400990203      * ===============================================================
003500990203      * Arrays.
003600990122      *
003700990122      * OPNQRY command
003800990122      *
003900990210     E                    ARA     1   5 60
004000990203      *================================================================
004100990203      * Data Structures.
004200990125      *
004300990125     ICMA         DS
004400990125      *    OPNQRY command layout for parameter substitution
004500990210     I                                        1 300 ARA
004600000728     I                                       30  37 XCUST
004700000728     I                                       41  48 XCUST1
004800990210     I                                       52  59 ASORD
004900990210     I                                       63  70 ASORD1
005000000728     I                                       74  86 XPROD
005100000728     I                                       90 102 XPROD1
005200990210     I                                      106 125 AVALU
005300990210     I                                      129 148 AVALU1
005400000728     I                                      182 191 XPGMID
005500000728     I                                      195 204 XUSRID
005600000728     I                                      208 217 XJOBNO
005700990125      *
005800990210     ICMD         DS                            300
005900990125      *
006000990108     IINFDS       DS
006100990119     I                                    B 370 3710CSRLOC
006200990108     I                                      369 369 KEY
006300990108      *
006400000728     IXXXSDS     SDS                            429
006500000728     I                                     *STATUS  XSYSNM
006600000728     I                                     *PROGRAM APGMID
006700000728     I                                      244 253 AJOBNO
006800000728     I                                      254 263 AUSRID
006900990111      *
007000990111     I            DS
007100990111     I                                        1 132 P0MSDA
007200990111     I                                        1  15 WRK1
007300990111     I                                       16  25 WRK2
007400990203      *================================================================
007500990203      * Constants.
007600990203      *
007700990203      * Named hexadecimal constants for function keys.
007800990125      *
007900990108     I              X'33'                 C         F03
008000990108     I              X'34'                 C         F04
008100990108     I              X'3A'                 C         F10
008200990302     I              X'3C'                 C         F12
008300990112      *
008400990112      * Other constants.
008500990112      *
008600990210     I              'Customer Code'       C         CAC
008700990210     I              'Product Code'        C         PAC
008800990302     I              '999'                 C         SERCHI
008900990210     I              '99999999'            C         CUSTHI
009000990126     I              '9999999999999'       C         PRODHI
009100990216      *
009200990216      * Zeros to 'setoff' error indicators.
009300000728     I              '00000000'            C         XZEROE
009400990216      *
009500990203      *================================================================
009600990203      * M A I N L I N E
009700990203      *================================================================
009800990125      *
009900990111      * Controlling Do-loop.
010000990108      *
010100990203     C           KEY       DOUEQF03                        Do 1.
010200990302     C           KEY       OREQ F12                        Do 1.
010300990111      *
010400990111      * Write the message subfile
010500990111      *
010600990111     C                     WRITEMSGCTL
010700990111      *
010800990210     C                     EXFMTHSS761A
010900990111      *
011000990119      * Clear the message subfile.
011100990111      *
011200000728     C                     EXSR YCLRMG
011300990111      *
011400990203      * Process the various function keys available on the screen.
011500990203      *
011600990203      * Exit if F03 pressed.
011700990203     C           KEY       IFEQ F03
011800990302     C           KEY       OREQ F12
011900990203     C                     LEAVE
012000990203     C                     ENDIF
012100990203      *
012200990203      * Execute the data validation subroutine.
012300990121     C           KEY       IFNE F04
012400000728     C                     EXSR YVALD
012500990302     C*          KEY       IFEQ F10
012600990302     C           *IN73     IFEQ *OFF
012700990125     C                     ITER
012800990125     C                     ENDIF
012900990125     C                     MOVE *OFF      *IN73
013000990118     C                     ENDIF
013100990204      *
013200990204      * Execute search window subroutine.
013300990108     C           KEY       IFEQ F04
013400000728     C                     EXSR YPRMT
013500990111     C                     ITER
013600990108     C                     ENDIF
013700990111      *
013800990302     C*          KEY       IFEQ F10
013900000728     C                     EXSR YCONF
014000990126     C*                    ITER
014100990126     C                     LEAVE
014200990302     C*                    ENDIF
014300990108      *
014400990108      *
014500990108     C                     ENDDO
014600990126      *
014700990107     C                     SETON                         LR
014800990108     C                     RETRN
014900990107      *
015000990108      *-----------------------------------------------------------
015100990108      *                  SUBROUTINES
015200990108      *-----------------------------------------------------------
015300990112      *-----------------------------------------------------------
015400990108      *
015500990112      *
015600990112      * ----------------------------------------------------------
015700990121      * VALID Subroutine validate inputed data.
015800990112      * ----------------------------------------------------------
015900000728     C           YVALD     BEGSR
016000990112      * -----------------
016100990121      * The Do-loop below is merely a tool to process multiple
016200990121      * possibilities of inputing error by the user.
016300990121      *
016400990121     C           *IN73     DOWEQ*OFF
016500990216      *
016600990216      * Reset error indicators....
016700000728     C                     MOVEAXZEROE    *IN,32
016800990210      *
016900990210      * Error message preventing a 'From' Customer Code being added
017000990210      * which does not exist on the Customer file.
017100990210      * A blank entry is allowed.
017200990210      *
017300000728     C                     MOVE XCUST     ECUST
017400990210     C           ECUST     CHAINHSLCUSTA             94
017500000728     C           XCUST     IFNE *BLANKS
017600990210     C           *IN94     IFEQ *ON
017700990216     C                     MOVE *ON       *IN32
017800990210     C                     MOVELCAC       WRK1      P
017900000728     C                     MOVELXCUST     WRK2      P
018000990210     C                     MOVEL'HSV0096' P0MSID
018100990210     C                     EXSR SNDMSG
018200990210     C                     LEAVE
018300990210     C                     ENDIF
018400990210     C                     ENDIF
018500990210      *
018600990210      * Error message preventing a 'To' Customer Code being added
018700990210      * which does not exist on the Customer file.
018800990210      * A blank entry is allowed.
018900990210      *
019000000728     C                     MOVE XCUST1    ECUST
019100990210     C           ECUST     CHAINHSLCUSTA             94
019200000728     C           XCUST1    IFNE *BLANKS
019300990210     C           *IN94     IFEQ *ON
019400990216     C                     MOVE *ON       *IN33
019500990210     C                     MOVELCAC       WRK1      P
019600000728     C                     MOVELXCUST1    WRK2      P
019700990210     C                     MOVEL'HSV0096' P0MSID
019800990210     C                     EXSR SNDMSG
019900990210     C                     LEAVE
020000990210     C                     ENDIF
020100990210     C                     ENDIF
020200990210      *
020300990210      * Error message preventing a 'To' Customer code being entered
020400990210      * which is less than the 'From' Customer code.
020500990210      *
020600000728     C           XCUST     IFGT XCUST1
020700000728     C           XCUST1    ANDNE*BLANKS
020800990216     C                     MOVE *ON       *IN32
020900990216     C                     MOVE *ON       *IN33
021000990210     C                     MOVEL'HSV0097' P0MSID
021100990210     C                     EXSR SNDMSG
021200990210     C                     LEAVE
021300990210     C                     ENDIF
021400990216      *
021500990216      * Error message preventing a 'From' Product Code being added
021600990216      * which does not exist on the Product file.
021700990216      * A blank entry is allowed.
021800990216      *
021900000728     C                     MOVE XPROD     NPROD
022000990216     C           NPROD     CHAINHSLPRODA             95
022100000728     C           XPROD     IFNE *BLANKS
022200990216     C           *IN95     IFEQ *ON
022300990216     C                     MOVE *ON       *IN34
022400990216     C                     MOVELPAC       WRK1      P
022500000728     C                     MOVELXPROD     WRK2      P
022600990216     C                     MOVEL'HSV0048' P0MSID
022700990216     C                     EXSR SNDMSG
022800990216     C                     LEAVE
022900990216     C                     ENDIF
023000990216     C                     ENDIF
023100990216      *
023200990216      * Error message preventing a 'To' Product Code being added
023300990216      * which does not exist on the Product file.
023400990216      * A blank entry is allowed.
023500990216      *
023600000728     C                     MOVE XPROD1    NPROD
023700990216     C           NPROD     CHAINHSLPRODA             95
023800000728     C           XPROD1    IFNE *BLANKS
023900990216     C           *IN95     IFEQ *ON
024000990216     C                     MOVE *ON       *IN35
024100990216     C                     MOVELPAC       WRK1      P
024200000728     C                     MOVELXPROD1    WRK2      P
024300990216     C                     MOVEL'HSV0048' P0MSID
024400990216     C                     EXSR SNDMSG
024500990216     C                     LEAVE
024600990216     C                     ENDIF
024700990216     C                     ENDIF
024800990216      *
024900990216      * Error message preventing a 'To' Product code being entered
025000990216      * which is less than the 'From' Product code.
025100990216      *
025200000728     C           XPROD     IFGT XPROD1
025300000728     C           XPROD1    ANDNE*BLANKS
025400990216     C                     MOVE *ON       *IN34
025500990216     C                     MOVE *ON       *IN35
025600990216     C                     MOVEL'HSV0069' P0MSID
025700990216     C                     EXSR SNDMSG
025800990216     C                     LEAVE
025900990216     C                     ENDIF
026000990210      *
026100990210      * Error message preventing a 'To' Order number being entered
026200990210      * which is less than the 'From' Order number.
026300990210      *
026400990210     C                     Z-ADD0         TSORD   80
026500000728     C           XSORD     IFGT XSORD1
026600000728     C           XSORD1    ANDNETSORD
026700990216     C                     MOVE *ON       *IN36
026800990216     C                     MOVE *ON       *IN37
026900990210     C                     MOVEL'HSV0099' P0MSID
027000990210     C                     EXSR SNDMSG
027100990210     C                     LEAVE
027200990210     C                     ENDIF
027300990121      *
027400990210      * Error message preventing a 'To' Order Value being entered
027500990210      * which is less than the 'From' Order Value.
027600990121      *
027700990210     C                     Z-ADD0         TVALU  205
027800000728     C           XVALU     IFGT XVALU1
027900000728     C           XVALU1    ANDNETVALU
028000990216     C                     MOVE *ON       *IN38
028100990216     C                     MOVE *ON       *IN39
028200990210     C                     MOVEL'HSV0152' P0MSID
028300990121     C                     EXSR SNDMSG
028400990121     C                     LEAVE
028500990121     C                     ENDIF
028600990121      *
028700990121      * Reset chaining indicators.
028800990121      *
028900990121     C                     MOVE *OFF      *IN94
029000990121     C                     MOVE *OFF      *IN95
029100990121      *
029200990121      * Message: Data is valid, press F10 to process.
029300990121      *
029400990302     C*          KEY       IFNE F10
029500990121     C                     MOVEL'HSV9011' P0MSID
029600990121     C                     EXSR SNDMSG
029700990302     C*                    ENDIF
029800990125     C                     MOVE *ON       *IN73
029900990122     C                     ENDDO
030000990108     C                     ENDSR
030100990112      *
030200990112      * ---------------------------------------------------
030300990108      * SNDMSG Subroutine to send message to subfile.
030400990112      * ---------------------------------------------------
030500990108     C           SNDMSG    BEGSR
030600990112      * -----------------
030700990114     C                     CALL 'SNDMSGC'
030800990114     C                     PARM           P0PGMQ
030900990108     C                     PARM           P0PGRL
031000990114     C                     PARM           P0MSID
031100990108     C                     PARM           P0MSGF
031200990108     C                     PARM           P0MSDA
031300990108     C                     PARM           P0MSTP
031400990108     C                     ENDSR
031500990112      * --------------------------------------------------
031600990108      * CONF Subroutine to update file
031700990112      * --------------------------------------------------
031800000728     C           YCONF     BEGSR
031900990112      * -------------
032000990121      *
032100000728     C                     MOVE XPROD     XPROD
032200990121      *
032300000728     C           XPROD1    IFEQ *BLANKS
032400000728     C                     MOVE XPROD     XPROD1 13
032500990121     C                     ELSE
032600000728     C                     MOVE XPROD1    XPROD1
032700990121     C                     ENDIF
032800990121      *
032900000728     C           XSORD     IFEQ TSORD
033000000728     C                     MOVE *ZEROS    XSORD   80P
033100990122     C                     ELSE
033200000728     C                     MOVE XSORD     XSORD
033300990122     C                     ENDIF
033400990122      *
033500000728     C           XSORD1    IFEQ TSORD
033600000728     C                     MOVE XSORD     XSORD1  80
033700990122     C                     ELSE
033800000728     C                     MOVE XSORD1    XSORD1
033900990122     C                     ENDIF
034000990122      *
034100000728     C                     MOVE XCUST     XCUST
034200990122      *
034300000728     C           XCUST1    IFEQ *BLANKS
034400000728     C                     MOVE XCUST     XCUST1  8
034500990122     C                     ELSE
034600000728     C                     MOVE XCUST1    XCUST1
034700990122     C                     ENDIF
034800990122      *
034900000728     C           XVALU     IFEQ TVALU
035000000728     C                     MOVE *ZEROS    XVALU  205P
035100990122     C                     ELSE
035200000728     C                     MOVE XVALU     XVALU
035300990122     C                     ENDIF
035400990122      *
035500000728     C           XVALU1    IFEQ TVALU
035600000728     C                     MOVE XVALU     XVALU1 205
035700990122     C                     ELSE
035800000728     C                     MOVE XVALU1    XVALU1
035900990122     C                     ENDIF
036000990203      *
036100000728     C                     MOVE XVALU     AVALU  20
036200000728     C                     MOVE XVALU1    AVALU1 20
036300000728     C                     MOVE XSORD     ASORD   8
036400000728     C                     MOVE XSORD1    ASORD1  8
036500990125      *
036600990204      * Perform Submit Job.
036700990125      *
036800990126     C                     MOVELCMA       CMD       P
036900990125     C                     CALL 'QCMDEXC'                85
037000990125     C                     PARM           CMD
037100990210     C                     PARM 300       LEN    155
037200990125      *
037300990122     C                     ENDSR
037400990113      * -------------------------------------------------------
037500990113      * CLEAR MESSAGE Subroutine to clear out the message queue.
037600990113      * -------------------------------------------------------
037700000728     C           YCLRMG    BEGSR
037800990108     C                     CALL 'RMVMSGC'
037900990108     C                     ENDSR
038000990112      *
038100990112      * ----------------------------------------------------
038200990112      * Search Window Subroutine
038300990112      * ----------------------------------------------------
038400990112      *
038500000728     C           YPRMT     BEGSR
038600990113      * ----------------
038700990118     C                     SELEC
038800000728     C           CSRFLD    WHEQ 'XCUST'
038900000728     C                     MOVEL'HSLCUSTA'FILEY     P
039000000728     C                     MOVEL'ENAM2'   NAMEY     P
039100000728     C                     MOVEL'ECUST'   NUMBRY    P
039200000728     C                     Z-ADD10        LINY
039300000728     C                     Z-ADD07        COLY
039400990112     C                     CALL 'HSR341'  PL341
039500000728     C           YRTNC     IFEQ *OFF
039600000728     C                     MOVELYNUMBR    XCUST     P
039700990112     C                     ENDIF
039800990121      *
039900000728     C           CSRFLD    WHEQ 'XCUST1'
040000000728     C                     MOVEL'HSLCUSTA'FILEY     P
040100000728     C                     MOVEL'ENAM2'   NAMEY     P
040200000728     C                     MOVEL'ECUST'   NUMBRY    P
040300000728     C                     Z-ADD10        LINY
040400000728     C                     Z-ADD07        COLY
040500990121     C                     CALL 'HSR341'  PL341
040600000728     C           YRTNC     IFEQ *OFF
040700000728     C                     MOVELYNUMBR    XCUST1    P
040800990121     C                     ENDIF
040900990118      *
041000000728     C           CSRFLD    WHEQ 'XPROD'
041100000728     C                     MOVEL'HSLPRODA'FILEY     P
041200000728     C                     MOVEL'NDESC'   NAMEY     P
041300000728     C                     MOVEL'NPROD'   NUMBRY    P
041400000728     C                     Z-ADD10        LINY
041500000728     C                     Z-ADD07        COLY
041600990118     C                     CALL 'HSR341'  PL341
041700000728     C           YRTNC     IFEQ *OFF
041800000728     C                     MOVELYNUMBR    XPROD     P
041900990118     C                     ENDIF
042000990121      *
042100000728     C           CSRFLD    WHEQ 'XPROD1'
042200000728     C                     MOVEL'HSLPRODA'FILEY     P
042300000728     C                     MOVEL'NDESC'   NAMEY     P
042400000728     C                     MOVEL'NPROD'   NUMBRY    P
042500000728     C                     Z-ADD10        LINY
042600000728     C                     Z-ADD07        COLY
042700990121     C                     CALL 'HSR341'  PL341
042800000728     C           YRTNC     IFEQ *OFF
042900000728     C                     MOVELYNUMBR    XPROD1    P
043000990121     C                     ENDIF
043100990210     C                     ENDSL
043200990122      *
043300990113     C           PL341     PLIST
043400000728     C                     PARM           YRTNC   1
043500000728     C                     PARM           YNUMBR 15
043600000728     C                     PARM           FILEY  10
043700000728     C                     PARM           NAMEY   6
043800000728     C                     PARM           NUMBRY  6
043900000728     C                     PARM           LINY    30
044000000728     C                     PARM           COLY    30
044100990209     C                     ENDSR
044200990125      *
044300990112      * ----------------------------------------------------
044400990108      * Initialisation Subroutine
044500990112      * ----------------------------------------------------
044600990108     C           *INZSR    BEGSR
044700990112      *----------------
044800000728     C                     Z-ADD0         XSORD
044900000728     C                     Z-ADD0         XSORD1
045000000728     C                     Z-ADD0         XVALU
045100000728     C                     Z-ADD0         XVALU1
045200000728     C                     MOVE APGMID    XPGMID
045300000728     C                     MOVE AUSRID    XUSRID
045400000728     C                     MOVE AJOBNO    XJOBNO
045500990111     C                     MOVE *ON       *IN79
045600000728     C                     MOVEL'HSR761'  XPGMID
045700000728     C                     MOVE XPGMID    P0PGMQ 10        PGM queue
045800990111     C                     MOVEL'*PRV'    P0PGRL  5        Rel queue
045900990108     C                     MOVE *BLANKS   P0MSID  7        Message ID
046000990108     C                     MOVEL'HSM001'  P0MSGF 10        Message File
046100990108     C                     MOVE *BLANKS   P0MSDA132        Message Data
046200990108     C                     MOVEL'*INFO'   P0MSTP  7        Message Type
046300990108     C                     ENDSR
046400990121      *
046500990203**
046600990210SBMJOB CMD(CALL HSR763 PARM('12345678' '12345678' '12345678'
046700990210 '12345678' '1234567890123' '1234567890123' '123456789012345
04680099021067890' '12345678901234567890'
046900990210'1234567890' '1234567890' '1234567890'))
047000990210JOB(HSR761B) JOBD(MNJL0000)
