000100888888     /*%CSTD===========================================================*      */
000200888888     /** Application. : SAM ARCAD Sample application                   *      */
000300888888     /** Composant. . : HSC731                        Type: CLP        *      */
000400888888     /**===============================================================*      */
000500888888     /** Sous-système : TRD Trade                                      *      */
000600888888     /** Fonction . . : PRD Products                                   *      */
000700888888     /** Sous-fonction:                                                *      */
000800888888     /**%S=============================================================*      */
000900888888     /** Description des fonctionnalités:                              *      */
001000888888     /** Descriptif fonctionnel du composant HSC731.ligne 1            *      */
001100888888     /** Descriptif fonctionnel du composant HSC731.ligne 2            *      */
001200888888     /**%E=============================================================*      */
001300888888     /** AUTEUR:                          00:00                        *      */
001400888888     /** MODIFS: 01 SGOMES     11/05/2007 11:41  V 1.00.X FM N°07/0037 *      */
001500888888     /**           2007/00018 fportier 15/01/2007                      *      */
001600888888     /*%ECSTD==========================================================*      */
001700990202/********************************************************************/
001800990202/* Program     : HSC731                                             */
001900990202/* Purpose     : Create OPNQRYF for Voucher Control file HSLVCTLA   */
002000990202/* System      : HSV - Voucher Tracking and Control                 */
002100990202/* Date        : January 1999                                       */
002200990202/********************************************************************/
002300071113
002400000728             PGM        PARM(&XPROD &XPROD1 &XPGMID &XUSRID &XJOBNO)
002500000728             DCL        VAR(&XPROD) TYPE(*CHAR) LEN(13)
002600000728             DCL        VAR(&XPROD1) TYPE(*CHAR) LEN(13)
002700000728             DCL        VAR(&XPGMID) TYPE(*CHAR) LEN(10)
002800000728             DCL        VAR(&XUSRID) TYPE(*CHAR) LEN(10)
002900000728             DCL        VAR(&XJOBNO) TYPE(*CHAR) LEN(10)
003000990202             OVRDBF     FILE(HSLVCTLA) SHARE(*YES)
003100990202             OPNQRYF    FILE((HSLVCTLA)) QRYSLT('(''BPROD *GE ''" +
003200000728                          *CAT ''&XPROD1'' *CAT "'' '')') +
003300990202                          KEYFLD((BPROD)) SEQONLY(*NO) +
003400990202                          OPTIMIZE(*FIRSTIO 12)
003500990202   /*        OPNQRYF    FILE((HSLVCTLA)) QRYSLT('BPROD = %RANGE(' || + */
003600990202 /*              "'&£PROD'" |> "'&£PROD1'" || ')') KEYFLD((BPROD)) +   */
003700990202 /*                       SEQONLY(*NO) OPTIMIZE(*FIRSTIO 12)           */
003800990202             CPYFRMQRYF FROMOPNID(HSLVCTLA) TOFILE(*PRINT)
003900000728             CALL       PGM(HSR735) PARM(&XPROD &XPROD1 &XPGMID +
004000000728                          &XUSRID &XJOBNO)
004100070511             DLTOVR     FILE(HSLVCTLA)
004200070511             CLOF       OPNID(HSLVCTLA)
004300990202                          ENDPGM
