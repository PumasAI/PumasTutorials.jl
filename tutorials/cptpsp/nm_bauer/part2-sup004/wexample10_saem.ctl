$PROB  wexample10 (from F_FLAG04est2a.ctl)
$INPUT C ID DOSE=AMT TIME DV WT TYPE
$DATA wexample10.csv IGNORE=@

$SUBROUTINES  ADVAN2 TRANS2

$PK
   MU_1=THETA(1)
   KA=EXP(MU_1+ETA(1))
   MU_2=THETA(2)
   V=EXP(MU_2+ETA(2))
   MU_3=THETA(3)
   CL=EXP(MU_3+ETA(3))
   S2=V/1000

$THETA  
1.6 ; [LN(KA)]
2.3 ; [LN(V)]
0.7 ; [LN(CL)]
0.1 ; [INTRCEPT]
0.1 ; [SLOPE]

$OMEGA BLOCK(3) VALUES(0.3,0.01) ; [P]

;Because THETA(4) and THETA(5) have no inter-subject variability associated with them, the
; algorithm must use a more computationally expensive gradient evaluation for these two parameters

$SIGMA
0.1; [P]

$ERROR
    IPRED=A(2)/S2
    EXPP=THETA(4)+IPRED*THETA(5)
; Put a limit on this, as it will be exponentiated, to avoid floating overflow
    IF(EXPP.GT.40.0) EXPP=40.0
IF (TYPE.EQ.0) THEN
; PK Data
    F_FLAG=0
    Y=IPRED+IPRED*ERR(1) ; a prediction
 ELSE
; Categorical data
    F_FLAG=1
; IF EXPP>40, then A>1.0d+17, A/B=1, and Y=DV
    AA=EXP(EXPP)
    B=1+AA
    Y=DV*AA/B+(1-DV)/B      ; a likelihood
 ENDIF

; Although SAEM does not use Laplace method, this opption is required so NMTRAN can prepare for all methods
$EST METHOD=ITS INTER LAP NITER=0 NOABORT
$EST METHOD=SAEM INTER LAP AUTO=1 NITER=300 PRINT=10 
; Because of categorical data, which can make conditional density highly non-normal, select a t-distribution
; with 4 degrees of freedom for importance sampling proposal density
$EST METHOD=IMP EONLY=1 NITER=5 ISAMPLE=1000 PRINT=1 DF=4 IACCEPT=1.0

$COV UNCONDITIONAL PRINT=E MATRIX=R SIGL=10
$TABLE ID DOSE WT TIME TYPE DV AA NOPRINT FILE=wexample10_saem.tab
