000100051123     H
000200051123     H*------------------------------------------------------------------------
000300051123     H* Test procedures for 4 int
000400051123     H*------------------------------------------------------------------------
000500051123     D* Prototype for this program
000600051123     D/COPY SMK41R4_P
000700051123     D* Prototype for called procedures
000800051123     D/COPY SMK21M1_P
000900051123     D*
001000051123     D* Parameters interface for this program
001100051123     D PGM_SMK41R4     Pi
001200051123     D* 1=Min, 2=Max
001300051123     D e_Action                       1a
001400051123     D e_Int1                        10i 0
001500051123     D e_Int2                        10i 0
001600051123     D e_Int3                        10i 0
001700051123     D e_Int4                        10i 0
001800051123     D e_IntRet                      10i 0
001900051123     D*--------
002000051123     D*
002100051123     C*
002200051123     C                   Select
002300051123     C*
002400051123     C*-- Min
002500051123     C                   When      e_Action = '1'
002600051123     C                   Eval      e_IntRet = Get_IntMin(
002700051123     C                             e_Int1:e_Int2:e_Int3:e_Int4)
002800051123     C*-- Max
002900051123     C                   When      e_Action = '2'
003000051123     C                   Eval      e_IntRet = Get_IntMax(
003100051123     C                             e_Int1:e_Int2:e_Int3:e_Int4)
003200051123     C*
003300051123     C                   Endsl
003400051123     C*
003500051123     C                   Eval      *INLR = '1'
003600051123     C                   Return
003700051123     C*---------------------------------------
