$PROB RUN# r2compl Indirect Response Model (r2complb.ctl)
$INPUT C SET ID JID TIME DV=CONC DOSE=AMT RATE EVID MDV CMT
$DATA r2comp.csv IGNORE=C

$SUBROUTINES ADVAN13 TRANS1 TOL=6
$MODEL NCOMPARTMENTS=3

$PK
MU_1=THETA(1)
MU_2=THETA(2)
MU_3=THETA(3)
MU_4=THETA(4)
MU_5=THETA(5)
MU_6=THETA(6)
MU_7=THETA(7)
MU_8=THETA(8)
VC=EXP(MU_1+ETA(1))
K10=EXP(MU_2+ETA(2))
K12=EXP(MU_3+ETA(3))
K21=EXP(MU_4+ETA(4))
VM=EXP(MU_5+ETA(5))
KMC=EXP(MU_6+ETA(6))
K03=EXP(MU_7+ETA(7))
K30=EXP(MU_8+ETA(8))
S3=VC
S1=VC
KM=KMC*S1
A_0(3)=K03/K30

$DES
DADT(1) = -(K10+K12)*A(1) + K21*A(2) - VM*A(1)*A(3)/(A(1)+KM)
DADT(2) = K12*A(1) - K21*A(2)
DADT(3) =  -(VM-K30)*A(1)*A(3)/(A(1)+KM) - K30*A(3) + K03

$ERROR
ETYPE=1
IF(CMT.NE.1) ETYPE=0
IF(ETYPE==1) THEN
IPRED=A(1)/S1
Y = IPRED + IPRED*EPS(1)
ELSE
IPRED=A(3)/S3
Y = IPRED + IPRED*EPS(2)
ENDIF


$THETA (1.5)X8

$OMEGA BLOCK(8) VALUES(2.0,0.01) ;[P]

$SIGMA
0.1 ;[p]
0.1 ;[p]


$EST METHOD=IMP INTERACTION AUTO=1 PRINT=1 SIGL=6 MCETA=100
$COV MATRIX=R UNCONDITIONAL
