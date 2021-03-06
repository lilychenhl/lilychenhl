000100000000      ****************************************************************
000200000727      * APPLICATION NAME...........: . ALL APPLICATIONS              *
000300000727      * COPY NAME..................: . FDINTYPREC                    *
000400000727      * TYPE OF COPY...............: . DEFINITION GENERAL FIELD      *
000500000727      * FUNCTION...................: . DESCRIPTION INFODI            *
000600000727      *         .                        TYPE OF RECEPTION           *
000700000727      * OTHER COPIES REQUIRED......: .                               *
000800000000      *         .                                                    *
000900000727      * COPY LOCATION..............: . INPUT-OUTPUT SECTION          *
001000000000      ****************************************************************
001100991026M01?V  01  FDIN-TYPREC.
001200881025           05  FDIN-TYPREC-CLEF.
001300881025               10  FDIN-TYPREC-CLEF-GEN  PIC X(18).
001400881025               10  FDIN-TYPREC-CLEF-TYP  PIC X(2).
001500920131      *****  LIBELLE RECEPTION                                   21,20
001600881025           05  FDIN-TYPREC-LIB           PIC X(20).
001700920131      *****  LIBELLE ETAT                                        41,15
001800881025           05  FDIN-TYPREC-ETYRC         PIC X(15).
001900920131      *****  ZONES RUPTURE ?                                     56,10
002000881025           05  FDIN-TYPREC-RCIDR         PIC X(2).
002100881025           05  FDIN-TYPREC-RAPP          PIC X(2).
002200881025           05  FDIN-TYPREC-RDEP          PIC X(2).
002300881025           05  FDIN-TYPREC-RRAY          PIC X(2).
002400881025           05  FDIN-TYPREC-RSEC          PIC X(2).
002500920131      *****  LIBELLE RUPTURE                                     66,30
002600881025           05  FDIN-TYPREC-LRUPT         PIC X(30).
002700920131      *****  ZONES AFFICHAGE ?                                   96,8
002800881025           05  FDIN-TYPREC-AVIG          PIC X(2).
002900881025           05  FDIN-TYPREC-APV           PIC X(2).
003000881025           05  FDIN-TYPREC-ATME          PIC X(2).
003100881025           05  FDIN-TYPREC-ATMG          PIC X(2).
003200920131      *****  NUMERO D'ENTREPOT OU MAGASIN                       104,2
003300881025           05  FDIN-TYPREC-NOCID         PIC X(2).
003400920131      *****  LIBELLE ECRAN                                      106,8
003500881025           05  FDIN-TYPREC-STYRC         PIC X(8).
003600920131      *****  ZONES GESTION   ?                                  114,11
003700881025           05  FDIN-TYPREC-GCIDR         PIC X.
003800881025           05  FDIN-TYPREC-GNENT         PIC X.
003900881025           05  FDIN-TYPREC-GAPP          PIC X.
004000881025           05  FDIN-TYPREC-GDEP          PIC X.
004100881025           05  FDIN-TYPREC-GRAY          PIC X.
004200881025           05  FDIN-TYPREC-GSEC          PIC X.
004300881025           05  FDIN-TYPREC-GCID          PIC X.
004400881025           05  FDIN-TYPREC-GVIG          PIC X.
004500881025           05  FDIN-TYPREC-GPV           PIC X.
004600881025           05  FDIN-TYPREC-GTME          PIC X.
004700881025           05  FDIN-TYPREC-GTMG          PIC X.
004800920131      *****  NB MOIS BON                                        125,2
004900881025           05  FDIN-TYPREC-NBMMB         PIC X(2).
005000920131      *****  NB MOIS FACTURE                                    127,2
005100881025           05  FDIN-TYPREC-NBMMF         PIC X(2).
005200920131      *****  CODE TVA SUR VIGNETTE                              129,2
005300881025           05  FDIN-TYPREC-TVAVG         PIC X(2).
005400920131      *****  CODE ECART FACTURE                                 131,2
005500881025           05  FDIN-TYPREC-ECAFT         PIC X(2).
005600920131      *****  LIMITE NUMERO D'ORDRE                              133,5
005700881025           05  FDIN-TYPREC-MNORD         PIC X(5).
005800920131      *****  LIMITE LIGNE                                       138,3
005900881025           05  FDIN-TYPREC-MLIG          PIC X(3).
006000920131      *****  DEBUT DES NUMERO D'ORDRE BIDONS                    141,5
006100881025           05  FDIN-TYPREC-NORD          PIC X(5).
006200920131      *****  EDITION DES ARRONDIS                               146,2
006300881209           05  FDIN-TYPREC-ARPRT         PIC X(2).
006400920131      *****  RECEPTIONS : MOINS                                 148,2
006500891122           05  FDIN-TYPREC-MOINS         PIC X(2).
006600920131      *****  RECEPTIONS : PLUS                                  150,2
006700891122           05  FDIN-TYPREC-PLUS          PIC X(2).
006800920131      *****  RECEPTIONS : PA / PR MAXI                          152,5
006900891127           05  FDIN-TYPREC-PA-SUR-PR.
007000891127               10  FDIN-TYPREC-PA-SUR-PR9   PIC 9(3)V9(2).
007100920131      *****  RECEPTIONS : PR / PA MAXI                          157,5
007200891127           05  FDIN-TYPREC-PR-SUR-PA.
007300891127               10  FDIN-TYPREC-PR-SUR-PA9   PIC 9(3)V9(2).
007400920131      *****  RECEPTIONS : MAJ DIFFEREES                         162,1
007500891127           05  FDIN-TYPREC-DIFFERE       PIC X.
007600920131      *****  RECEPTIONS : AFFICHAGE SFL ECRAN 2                 163,1
007700900124           05  FDIN-TYPREC-AFFSFL        PIC X.
007800920131      *****  RECEPTIONS : CONFORMITE DIRECTE PAR F5             164,1
007900900124           05  FDIN-TYPREC-CONFOR        PIC X.
008000920131      *****  RECEPTIONS : CONFIRMATION DES RECEPTIONS           165,1
008100900321           05  FDIN-TYPREC-CONFIRME      PIC X.
008200920131      *****  RECEPTIONS : GESTION PAR ENTREPOT SECONDAIRE       166,1
008300900920           05  FDIN-TYPREC-GESTION-NENT  PIC X.
008400920131      *****  DEFAUT EMBALLAGES : N=NON CONSIGNES, C=CONSIGNES   167,1
008500911009           05  FDIN-TYPREC-DEFAUT-EMB    PIC X.
008600920131      *****  CONTROLE RAYON UNIQUE ?                            168,1
008700911014           05  FDIN-TYPREC-RAY-UNIQUE    PIC X.
008800920131      *****  CONTROLE RAYON EMBALLAGE ?                         169,1
008900911014           05  FDIN-TYPREC-RAY-EMBAL     PIC X.
009000920131      *****  DATE DE DATE : F SI DATE FACTURE                   170,1
009100911017           05  FDIN-TYPREC-TYPE-DATE     PIC X.
009200920131      *****  DATE DE DATE : O SI REGROUPEMENT RAYONS DIFFER.    171,1
009300911029           05  FDIN-TYPREC-REGROUPE-RAY  PIC X.
009400920210      *****  SAISIE REGIE : O SI SAISIE REGIE A LA RECEPTION    172,1
009500920210           05  FDIN-TYPREC-SAISIE-REGIE  PIC X.
009600920818      *****  RECEPTION POSSIBLE SI EMPLACEMENT = BLANC ????     173,1
009700920818           05  FDIN-TYPREC-EMPL-BLANC    PIC X.
009800921201      *****  OUTQ SPECIFIQUE A UN TYPE DE RECEPTION             174,10
009900921201           05  FDIN-TYPREC-OUTQ          PIC X(10).
010000930211      *****  LG FAMILLE  2 OU 3                                 184,1
010100930211           05  FDIN-TYPREC-LGFAM         PIC X.
010200930622      *****  CREATION DE DUPLICATAS DE SLIMS  O/N               185,1
010300930622           05  FDIN-TYPREC-DUPLIQ-SLIM   PIC X.
010400930901      *****  INTERVALLE DE DATE DE FACTURE POUR COF             186,4
010500930901           05  FDIN-TYPREC-FACT-INF      PIC X(2).
010600930901           05  FDIN-TYPREC-FACT-SUP      PIC X(2).
010700930901      *****  SAISIE DU MAGASIN LIVRE / LIGNE                    190,1
010800930901      *****     O = OBLIGATOIRE  ,  F = FACULTATIF  ,  9 = SI 9996X
010900930901      *****     6 = SI 9996X AVEC CONTROLE REGION GEO
011000930901           05  FDIN-TYPREC-MAGLIG        PIC X(1).
011100930903      *****  MONTANT MAXIMUM COMPTEUR TRANSPORT                 191,1
011200930903      *****  SI 6 MAXI = 999999F99  SINON 99999F99
011300930903           05  FDIN-TYPREC-MAXITRS       PIC X(1).
011400941128      *****  MONTANT MAXIMUM FACTURE                            192,1
011500941128      *****  SI 6 MAXI = 999999F99  SINON 99999999F99
011600941128           05  FDIN-TYPREC-MAXIFACT      PIC X(1).
011700960529      *****  GESTION DES NOUVEAUX FICHIERS COMMANDES  O/N       193,1
011800960529           05  FDIN-TYPREC-FCX           PIC X(1).
011900960924      *****  REGLEMENT MANUEL POUR FOURNISSEURS CEE   O/N       194,1
012000960924      *****       N POUR DFO (TIGRE)
012100960924           05  FDIN-TYPREC-MANCEE        PIC X(1).
012200961209      *****  SAISIE POSSIBLE A LA FAMILLE            O/N       195,1
012300961209      *****    SI = N, ON PEUT JUSTE SAISIR QTE = 1 ET PA = 0,001
012400961209      *****            POUR PAYER LE TRANSPORT ET LES TAXES
012500961209           05  FDIN-TYPREC-SAIFAM        PIC X(1).
012600961210      *****  APPEL A LA CALCULETTE POSSIBLE          O/N       196,1
012700961210           05  FDIN-TYPREC-APPEL-CALC    PIC X(1).
012800961210      *                                                        197,60
012900961210           05  FILLER                    PIC X(60).
013000930901      *
