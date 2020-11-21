Tue 03/12/2019 
10:16 AM
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

$OMEGA BLOCK(3) VALUES(0.5,0.01) ;[P]

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

$EST METHOD=ITS INTER LAP AUTO=1 PRINT=5 SIGL=6
$EST METHOD=COND LAP INTER MAXEVAL=9999 PRINT=1 NOHABORT
$COV UNCONDITIONAL PRINT=E MATRIX=R SIGL=10
$TABLE ID DOSE WT TIME TYPE DV AA NOPRINT FILE=wexample10_lap.tab
  
NM-TRAN MESSAGES 
  
 WARNINGS AND ERRORS (IF ANY) FOR PROBLEM    1
             
 (WARNING  2) NM-TRAN INFERS THAT THE DATA ARE POPULATION.
             
 (WARNING  3) THERE MAY BE AN ERROR IN THE ABBREVIATED CODE. THE FOLLOWING
 ONE OR MORE RANDOM VARIABLES ARE DEFINED WITH "IF" STATEMENTS THAT DO NOT
 PROVIDE DEFINITIONS FOR BOTH THE "THEN" AND "ELSE" CASES. IF ALL
 CONDITIONS FAIL, THE VALUES OF THESE VARIABLES WILL BE ZERO.
  
   AA B

             
 (WARNING  87) WITH "LAPLACIAN" AND "INTERACTION", "NUMERICAL" AND "SLOW"
 ARE ALSO REQUIRED ON $ESTIM RECORD, AND "SLOW" IS REQUIRED ON $COV
 RECORD. NM-TRAN HAS SUPPLIED THESE OPTIONS.
             
 (WARNING  87) WITH "LAPLACIAN" AND "INTERACTION", "NUMERICAL" AND "SLOW"
 ARE ALSO REQUIRED ON $ESTIM RECORD, AND "SLOW" IS REQUIRED ON $COV
 RECORD. NM-TRAN HAS SUPPLIED THESE OPTIONS.
  
License Registered to: IDS NONMEM 7 TEAM
Expiration Date:     2 JUN 2030
Current Date:       12 MAR 2019
Days until program expires :4095
1NONLINEAR MIXED EFFECTS MODEL PROGRAM (NONMEM) VERSION 7.4.3
 ORIGINALLY DEVELOPED BY STUART BEAL, LEWIS SHEINER, AND ALISON BOECKMANN
 CURRENT DEVELOPERS ARE ROBERT BAUER, ICON DEVELOPMENT SOLUTIONS,
 AND ALISON BOECKMANN. IMPLEMENTATION, EFFICIENCY, AND STANDARDIZATION
 PERFORMED BY NOUS INFOSYSTEMS.

 PROBLEM NO.:         1
 wexample10 (from F_FLAG04est2a.ctl)
0DATA CHECKOUT RUN:              NO
 DATA SET LOCATED ON UNIT NO.:    2
 THIS UNIT TO BE REWOUND:        NO
 NO. OF DATA RECS IN DATA SET:     4608
 NO. OF DATA ITEMS IN DATA SET:   9
 ID DATA ITEM IS DATA ITEM NO.:   2
 DEP VARIABLE IS DATA ITEM NO.:   5
 MDV DATA ITEM IS DATA ITEM NO.:  9
0INDICES PASSED TO SUBROUTINE PRED:
   8   4   3   0   0   0   0   0   0   0   0
0LABELS FOR DATA ITEMS:
 C ID DOSE TIME DV WT TYPE EVID MDV
0(NONBLANK) LABELS FOR PRED-DEFINED ITEMS:
 AA
0FORMAT FOR DATA:
 (7E9.0,2F2.0)

 TOT. NO. OF OBS RECS:     4320
 TOT. NO. OF INDIVIDUALS:      288
0LENGTH OF THETA:   5
0DEFAULT THETA BOUNDARY TEST OMITTED:    NO
0OMEGA HAS BLOCK FORM:
  1
  1  1
  1  1  1
0DEFAULT OMEGA BOUNDARY TEST OMITTED:    NO
0SIGMA HAS SIMPLE DIAGONAL FORM WITH DIMENSION:   1
0DEFAULT SIGMA BOUNDARY TEST OMITTED:    NO
0INITIAL ESTIMATE OF THETA:
   0.1600E+01  0.2300E+01  0.7000E+00  0.1000E+00  0.1000E+00
0INITIAL ESTIMATE OF OMEGA:
 BLOCK SET NO.   BLOCK                                                                    FIXED
        1                                                                                   NO
                  0.5000E+00
                  0.1000E-01   0.5000E+00
                  0.1000E-01   0.1000E-01   0.5000E+00
0INITIAL ESTIMATE OF SIGMA:
 0.1000E+00
0COVARIANCE STEP OMITTED:        NO
 R MATRIX SUBSTITUTED:          YES
 S MATRIX SUBSTITUTED:           NO
 EIGENVLS. PRINTED:             YES
 COMPRESSED FORMAT:              NO
 GRADIENT METHOD USED:       SLOW
 SIGDIGITS ETAHAT (SIGLO):                  -1
 SIGDIGITS GRADIENTS (SIGL):                10
 EXCLUDE COV FOR FOCE (NOFCOV):              NO
 TURN OFF Cholesky Transposition of R Matrix (CHOLROFF): NO
 KNUTHSUMOFF:                                -1
 RESUME COV ANALYSIS (RESUME):               NO
 SIR SAMPLE SIZE (SIRSAMPLE):              -1
 NON-LINEARLY TRANSFORM THETAS DURING COV (THBND): 1
 PRECONDTIONING CYCLES (PRECOND):        0
 PRECONDTIONING TYPES (PRECONDS):        TOS
 FORCED PRECONDTIONING CYCLES (PFCOND):0
 PRECONDTIONING TYPE (PRETYPE):        0
 FORCED POS. DEFINITE SETTING: (FPOSDEF):0
0TABLES STEP OMITTED:    NO
 NO. OF TABLES:           1
 SEED NUMBER (SEED):    11456
 RANMETHOD:             3U
 MC SAMPLES (ESAMPLE):    300
 WRES SQUARE ROOT TYPE (WRESCHOL): EIGENVALUE
0-- TABLE   1 --
0RECORDS ONLY:    ALL
04 COLUMNS APPENDED:    YES
 PRINTED:                NO
 HEADERS:               YES
 FILE TO BE FORWARDED:   NO
 FORMAT:                S1PE11.4
 LFORMAT:
 RFORMAT:
 FIXED_EFFECT_ETAS:
0USER-CHOSEN ITEMS:
 ID DOSE WT TIME TYPE DV AA
1DOUBLE PRECISION PREDPP VERSION 7.4.3

 ONE COMPARTMENT MODEL WITH FIRST-ORDER ABSORPTION (ADVAN2)
0MAXIMUM NO. OF BASIC PK PARAMETERS:   3
0BASIC PK PARAMETERS (AFTER TRANSLATION):
   ELIMINATION RATE (K) IS BASIC PK PARAMETER NO.:  1
   ABSORPTION RATE (KA) IS BASIC PK PARAMETER NO.:  3

 TRANSLATOR WILL CONVERT PARAMETERS
 CLEARANCE (CL) AND VOLUME (V) TO K (TRANS2)
0COMPARTMENT ATTRIBUTES
 COMPT. NO.   FUNCTION   INITIAL    ON/OFF      DOSE      DEFAULT    DEFAULT
                         STATUS     ALLOWED    ALLOWED    FOR DOSE   FOR OBS.
    1         DEPOT        OFF        YES        YES        YES        NO
    2         CENTRAL      ON         NO         YES        NO         YES
    3         OUTPUT       OFF        YES        NO         NO         NO
1
 ADDITIONAL PK PARAMETERS - ASSIGNMENT OF ROWS IN GG
 COMPT. NO.                             INDICES
              SCALE      BIOAVAIL.   ZERO-ORDER  ZERO-ORDER  ABSORB
                         FRACTION    RATE        DURATION    LAG
    1            *           *           *           *           *
    2            4           *           *           *           *
    3            *           -           -           -           -
             - PARAMETER IS NOT ALLOWED FOR THIS MODEL
             * PARAMETER IS NOT SUPPLIED BY PK SUBROUTINE;
               WILL DEFAULT TO ONE IF APPLICABLE
0DATA ITEM INDICES USED BY PRED ARE:
   EVENT ID DATA ITEM IS DATA ITEM NO.:      8
   TIME DATA ITEM IS DATA ITEM NO.:          4
   DOSE AMOUNT DATA ITEM IS DATA ITEM NO.:   3

0PK SUBROUTINE CALLED WITH EVERY EVENT RECORD.
 PK SUBROUTINE NOT CALLED AT NONEVENT (ADDITIONAL OR LAGGED) DOSE TIMES.
0ERROR SUBROUTINE CALLED WITH EVERY EVENT RECORD.
0ERROR SUBROUTINE INDICATES THAT DERIVATIVES OF COMPARTMENT AMOUNTS ARE USED.
1
 
 
 #TBLN:      1
 #METH: Iterative Two Stage (No Prior)
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               SLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    YES
 NUMERICAL 2ND DERIVATIVES:               YES
 NO. OF FUNCT. EVALS. ALLOWED:            528
 NO. OF SIG. FIGURES REQUIRED:            3
 INTERMEDIATE PRINTOUT:                   YES
 ESTIMATE OUTPUT TO MSF:                  NO
 IND. OBJ. FUNC. VALUES SORTED:           NO
 NUMERICAL DERIVATIVE
       FILE REQUEST (NUMDER):               NONE
 MAP (ETAHAT) ESTIMATION METHOD (OPTMAP):   0
 ETA HESSIAN EVALUATION METHOD (ETADER):    0
 INITIAL ETA FOR MAP ESTIMATION (MCETA):    3
 SIGDIGITS FOR MAP ESTIMATION (SIGLO):      6
 GRADIENT SIGDIGITS OF
       FIXED EFFECTS PARAMETERS (SIGL):     6
 NOPRIOR SETTING (NOPRIOR):                 ON
 NOCOV SETTING (NOCOV):                     OFF
 DERCONT SETTING (DERCONT):                 OFF
 FINAL ETA RE-EVALUATION (FNLETA):          ON
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      OFF
 RAW OUTPUT FILE (FILE): wexample10_lap.ext
 EXCLUDE TITLE (NOTITLE):                   NO
 EXCLUDE COLUMN LABELS (NOLABEL):           NO
 FORMAT FOR ADDITIONAL FILES (FORMAT):      S1PE12.5
 PARAMETER ORDER FOR OUTPUTS (ORDER):       TSOL
 WISHART PRIOR DF INTERPRETATION (WISHTYPE):0
 KNUTHSUMOFF:                               0
 INCLUDE LNTWOPI:                           NO
 INCLUDE CONSTANT TERM TO PRIOR (PRIORC):   NO
 INCLUDE CONSTANT TERM TO OMEGA (ETA) (OLNTWOPI):NO
 EM OR BAYESIAN METHOD USED:                ITERATIVE TWO STAGE (ITS)
 MU MODELING PATTERN (MUM):
 GRADIENT/GIBBS PATTERN (GRD):
 AUTOMATIC SETTING FEATURE (AUTO):          ON
 CONVERGENCE TYPE (CTYPE):                  3
 CONVERGENCE INTERVAL (CINTERVAL):          1
 CONVERGENCE ITERATIONS (CITER):            10
 CONVERGENCE ALPHA ERROR (CALPHA):          5.000000000000000E-02
 ITERATIONS (NITER):                        500
 ANEAL SETTING (CONSTRAIN):                 1

 
 THE FOLLOWING LABELS ARE EQUIVALENT
 PRED=PREDI
 RES=RESI
 WRES=WRESI
 IWRS=IWRESI
 IPRD=IPREDI
 IRS=IRESI
 
 EM/BAYES SETUP:
 THETAS THAT ARE MU MODELED:
   1   2   3
 THETAS THAT ARE SIGMA-LIKE:
 
 
 MONITORING OF SEARCH:

 iteration            0 OBJ=   14961.5911441353
 iteration            5 OBJ=   10120.5371227598
 iteration           10 OBJ=   10043.5589739003
 iteration           15 OBJ=   10043.1919606305
 iteration           20 OBJ=   10043.2075523527
 iteration           25 OBJ=   10043.2086441518
 Convergence achieved
 iteration           28 OBJ=   10043.2087039223
 iteration           28 OBJ=   10043.2087212924
 
 #TERM:
 OPTIMIZATION WAS COMPLETED


 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:        -3.4376E-08 -5.0083E-09 -1.2078E-09
 SE:             1.4404E-02  1.5600E-02  1.6953E-02
 N:                     288         288         288
 
 P VAL.:         1.0000E+00  1.0000E+00  1.0000E+00
 
 ETASHRINKSD(%)  1.6449E+01  2.8186E+00  1.6152E+00
 ETASHRINKVR(%)  3.0192E+01  5.5577E+00  3.2044E+00
 EBVSHRINKSD(%)  1.6449E+01  2.8186E+00  1.6152E+00
 EBVSHRINKVR(%)  3.0192E+01  5.5577E+00  3.2044E+00
 EPSSHRINKSD(%)  1.2870E+01
 EPSSHRINKVR(%)  2.4084E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):         2880
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    5293.08595125891     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    10043.2087212924     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       15336.2946725513     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                           864
  
 #TERE:
 Elapsed estimation  time in seconds:     7.27
 Elapsed covariance  time in seconds:     0.19
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 #OBJT:**************                        FINAL VALUE OF OBJECTIVE FUNCTION                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************    10043.209       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         1.07E+00  3.39E+00  2.44E+00 -6.48E-01  8.06E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3     
 
 ETA1
+        8.59E-02
 
 ETA2
+        3.65E-03  7.45E-02
 
 ETA3
+        3.60E-02  3.00E-02  8.58E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        2.27E-02
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3     
 
 ETA1
+        2.93E-01
 
 ETA2
+        4.56E-02  2.73E-01
 
 ETA3
+        4.19E-01  3.75E-01  2.93E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.51E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                          STANDARD ERROR OF ESTIMATE (S)                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         2.29E-02  1.67E-02  1.76E-02  9.97E-02  7.19E-03
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3     
 
 ETA1
+        9.97E-03
 
 ETA2
+        6.30E-03  6.41E-03
 
 ETA3
+        7.19E-03  5.17E-03  7.29E-03
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        7.78E-04
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3     
 
 ETA1
+        1.70E-02
 
 ETA2
+        7.81E-02  1.17E-02
 
 ETA3
+        6.10E-02  5.31E-02  1.24E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        2.58E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                        COVARIANCE MATRIX OF ESTIMATE (S)                       ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM22      OM23      OM33      SG11  

 
 TH 1
+        5.26E-04
 
 TH 2
+        3.37E-05  2.79E-04
 
 TH 3
+        1.35E-04  1.19E-04  3.11E-04
 
 TH 4
+       -2.76E-05 -9.00E-05 -9.68E-05  9.94E-03
 
 TH 5
+        7.78E-06  6.39E-06  5.64E-06 -4.92E-04  5.17E-05
 
 OM11
+        7.32E-05  3.29E-06 -1.95E-06  6.66E-05 -2.51E-06  9.94E-05
 
 OM12
+        1.38E-05  5.85E-06  6.41E-06 -9.14E-05  4.18E-06  1.18E-05  3.97E-05
 
 OM13
+        2.21E-05  4.62E-06  1.94E-06 -2.00E-05  7.48E-07  5.52E-05  1.80E-05  5.17E-05
 
 OM22
+        8.30E-06 -2.27E-06  1.23E-06  3.14E-06  1.75E-06  6.14E-06  4.22E-06  5.04E-06  4.11E-05
 
 OM23
+        5.44E-06  1.45E-06  2.20E-06 -3.02E-05  3.42E-06  5.11E-06  1.49E-05  9.55E-06  1.49E-05  2.68E-05
 
 OM33
+        2.55E-06  3.29E-06  4.45E-06 -5.95E-05  1.44E-06  6.35E-06  1.21E-05  2.00E-05  3.80E-06  1.80E-05  5.31E-05
 
 SG11
+        2.42E-07  1.00E-06  2.51E-07  9.46E-07  2.87E-07 -5.20E-08 -2.84E-07  1.63E-07 -6.56E-07 -6.68E-07  3.15E-07  6.05E-07
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                        CORRELATION MATRIX OF ESTIMATE (S)                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM22      OM23      OM33      SG11  

 
 TH 1
+        2.29E-02
 
 TH 2
+        8.79E-02  1.67E-02
 
 TH 3
+        3.34E-01  4.03E-01  1.76E-02
 
 TH 4
+       -1.21E-02 -5.41E-02 -5.50E-02  9.97E-02
 
 TH 5
+        4.72E-02  5.32E-02  4.44E-02 -6.86E-01  7.19E-03
 
 OM11
+        3.20E-01  1.97E-02 -1.11E-02  6.70E-02 -3.50E-02  9.97E-03
 
 OM12
+        9.53E-02  5.56E-02  5.76E-02 -1.46E-01  9.22E-02  1.87E-01  6.30E-03
 
 OM13
+        1.34E-01  3.85E-02  1.53E-02 -2.78E-02  1.45E-02  7.70E-01  3.97E-01  7.19E-03
 
 OM22
+        5.64E-02 -2.12E-02  1.09E-02  4.91E-03  3.79E-02  9.60E-02  1.05E-01  1.09E-01  6.41E-03
 
 OM23
+        4.59E-02  1.67E-02  2.40E-02 -5.86E-02  9.18E-02  9.90E-02  4.57E-01  2.57E-01  4.50E-01  5.17E-03
 
 OM33
+        1.53E-02  2.70E-02  3.46E-02 -8.19E-02  2.75E-02  8.75E-02  2.64E-01  3.82E-01  8.12E-02  4.78E-01  7.29E-03
 
 SG11
+        1.36E-02  7.73E-02  1.83E-02  1.22E-02  5.12E-02 -6.70E-03 -5.79E-02  2.91E-02 -1.31E-01 -1.66E-01  5.55E-02  7.78E-04
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                    INVERSE COVARIANCE MATRIX OF ESTIMATE (S)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM22      OM23      OM33      SG11  

 
 TH 1
+        2.62E+03
 
 TH 2
+        2.38E+02  4.34E+03
 
 TH 3
+       -1.24E+03 -1.74E+03  4.43E+03
 
 TH 4
+       -6.84E+00  1.27E+01  1.84E+01  1.99E+02
 
 TH 5
+       -4.80E+02 -2.16E+02  1.81E+02  1.88E+03  3.76E+04
 
 OM11
+       -3.82E+03 -4.58E+02  1.97E+03 -1.88E+02  1.52E+02  3.51E+04
 
 OM12
+       -1.08E+03 -3.46E+02  9.47E+01  3.18E+02  1.82E+03  6.88E+03  3.87E+04
 
 OM13
+        3.65E+03  2.15E+02 -1.69E+03  1.37E+02 -3.36E+02 -4.21E+04 -1.85E+04  7.67E+04
 
 OM22
+       -2.79E+02  3.16E+02 -1.34E+02 -2.54E+01 -3.62E+02 -2.41E+02  4.84E+03 -2.29E+03  3.23E+04
 
 OM23
+        2.50E+02 -2.71E+02  2.01E+02 -3.72E+02 -6.05E+03 -1.73E+03 -2.17E+04  5.61E+03 -2.30E+04  7.75E+04
 
 OM33
+       -7.55E+02  4.79E+01  1.21E+02  2.05E+02  3.04E+03  1.05E+04  4.69E+03 -2.12E+04  5.23E+03 -2.22E+04  3.20E+04
 
 SG11
+       -2.15E+03 -6.74E+03  2.12E+03 -1.67E+03 -2.80E+04  1.16E+04  2.21E+03 -1.94E+04  9.53E+03  6.39E+04 -2.83E+04  1.78E+06
 
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                          ITERATIVE TWO STAGE (NO PRIOR)                        ********************
 ********************                    EIGENVALUES OF COR MATRIX OF ESTIMATE (S)                   ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             1         2         3         4         5         6         7         8         9        10        11        12

 
         1.33E-01  2.74E-01  3.50E-01  5.03E-01  6.95E-01  8.08E-01  8.82E-01  1.11E+00  1.33E+00  1.59E+00  1.75E+00  2.57E+00
 
1
 
 
 #TBLN:      2
 #METH: Laplacian Conditional Estimation with Interaction
 
 ESTIMATION STEP OMITTED:                 NO
 ANALYSIS TYPE:                           POPULATION
 NUMBER OF SADDLE POINT RESET ITERATIONS:      0
 GRADIENT METHOD USED:               SLOW
 CONDITIONAL ESTIMATES USED:              YES
 CENTERED ETA:                            NO
 EPS-ETA INTERACTION:                     YES
 LAPLACIAN OBJ. FUNC.:                    YES
 NUMERICAL 2ND DERIVATIVES:               YES
 NO. OF FUNCT. EVALS. ALLOWED:            9999
 NO. OF SIG. FIGURES REQUIRED:            3
 INTERMEDIATE PRINTOUT:                   YES
 ESTIMATE OUTPUT TO MSF:                  NO
 ABORT WITH PRED EXIT CODE 1:             NO
 IND. OBJ. FUNC. VALUES SORTED:           NO
 NUMERICAL DERIVATIVE
       FILE REQUEST (NUMDER):               NONE
 MAP (ETAHAT) ESTIMATION METHOD (OPTMAP):   0
 ETA HESSIAN EVALUATION METHOD (ETADER):    0
 INITIAL ETA FOR MAP ESTIMATION (MCETA):    0
 SIGDIGITS FOR MAP ESTIMATION (SIGLO):      6
 GRADIENT SIGDIGITS OF
       FIXED EFFECTS PARAMETERS (SIGL):     6
 NOPRIOR SETTING (NOPRIOR):                 OFF
 NOCOV SETTING (NOCOV):                     OFF
 DERCONT SETTING (DERCONT):                 OFF
 FINAL ETA RE-EVALUATION (FNLETA):          ON
 EXCLUDE NON-INFLUENTIAL (NON-INFL.) ETAS
       IN SHRINKAGE (ETASTYPE):             NO
 NON-INFL. ETA CORRECTION (NONINFETA):      OFF
 RAW OUTPUT FILE (FILE): wexample10_lap.ext
 EXCLUDE TITLE (NOTITLE):                   NO
 EXCLUDE COLUMN LABELS (NOLABEL):           NO
 FORMAT FOR ADDITIONAL FILES (FORMAT):      S1PE12.5
 PARAMETER ORDER FOR OUTPUTS (ORDER):       TSOL
 WISHART PRIOR DF INTERPRETATION (WISHTYPE):0
 KNUTHSUMOFF:                               0
 INCLUDE LNTWOPI:                           NO
 INCLUDE CONSTANT TERM TO PRIOR (PRIORC):   NO
 INCLUDE CONSTANT TERM TO OMEGA (ETA) (OLNTWOPI):NO
 ADDITIONAL CONVERGENCE TEST (CTYPE=4)?:    NO
 EM OR BAYESIAN METHOD USED:                 NONE

 
 THE FOLLOWING LABELS ARE EQUIVALENT
 PRED=PREDI
 RES=RESI
 WRES=WRESI
 IWRS=IWRESI
 IPRD=IPREDI
 IRS=IRESI
 
 MONITORING OF SEARCH:

 
0ITERATION NO.:    0    OBJECTIVE VALUE:   10043.2087126230        NO. OF FUNC. EVALS.:  13
 CUMULATIVE NO. OF FUNC. EVALS.:       13
 NPARAMETR:  1.0734E+00  3.3889E+00  2.4397E+00 -6.4846E-01  8.0564E-02  8.5892E-02  3.6481E-03  3.6012E-02  7.4473E-02  2.9960E-02
             8.5811E-02  2.2750E-02
 PARAMETER:  1.0000E-01  1.0000E-01  1.0000E-01 -1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01  1.0000E-01
             1.0000E-01  1.0000E-01
 GRADIENT:  -2.6559E+03 -7.0418E+02  3.8542E+03 -1.9322E-01 -2.1829E-01  3.5219E+00  1.8248E+00 -2.6725E+01  9.9456E-01  1.0186E+01
             5.7239E+00 -3.6322E+00
 
0ITERATION NO.:    1    OBJECTIVE VALUE:   10041.1614810231        NO. OF FUNC. EVALS.:  18
 CUMULATIVE NO. OF FUNC. EVALS.:       31
 NPARAMETR:  1.0788E+00  3.3934E+00  2.4222E+00 -6.4846E-01  8.0564E-02  8.5892E-02  3.6481E-03  3.6014E-02  7.4472E-02  2.9959E-02
             8.5812E-02  2.2750E-02
 PARAMETER:  1.0049E-01  1.0013E-01  9.9283E-02 -1.0000E-01  1.0000E-01  9.9999E-02  1.0000E-01  1.0000E-01  1.0000E-01  9.9998E-02
             9.9999E-02  1.0000E-01
 GRADIENT:  -1.8984E+03  2.7532E+03 -6.0452E+02 -9.7613E-01 -2.8032E+00  2.1689E+00  2.7855E+00 -4.4781E+01 -4.4182E-01  1.5628E+01
             7.9864E+00 -2.5346E+00
 
0ITERATION NO.:    2    OBJECTIVE VALUE:   10040.6134318901        NO. OF FUNC. EVALS.:  20
 CUMULATIVE NO. OF FUNC. EVALS.:       51
 NPARAMETR:  1.0821E+00  3.3782E+00  2.4246E+00 -6.4845E-01  8.0565E-02  8.5892E-02  3.6480E-03  3.6017E-02  7.4472E-02  2.9959E-02
             8.5814E-02  2.2750E-02
 PARAMETER:  1.0080E-01  9.9683E-02  9.9381E-02 -1.0000E-01  1.0000E-01  9.9999E-02  9.9999E-02  1.0001E-01  1.0000E-01  9.9996E-02
             9.9998E-02  1.0000E-01
 GRADIENT:  -1.8530E+03 -1.9614E+03  1.0113E+03 -2.8815E-01 -2.0775E-01  2.7712E+00  1.2529E+00 -3.8166E+01 -4.1675E-01  1.4720E+01
             8.4537E+00  3.5968E-01
 
0ITERATION NO.:    3    OBJECTIVE VALUE:   10039.7956015094        NO. OF FUNC. EVALS.:  17
 CUMULATIVE NO. OF FUNC. EVALS.:       68
 NPARAMETR:  1.1226E+00  3.3722E+00  2.4094E+00 -6.4845E-01  8.0567E-02  8.5891E-02  3.6479E-03  3.6046E-02  7.4473E-02  2.9951E-02
             8.5830E-02  2.2750E-02
 PARAMETER:  1.0458E-01  9.9506E-02  9.8758E-02 -9.9999E-02  1.0000E-01  9.9994E-02  9.9995E-02  1.0010E-01  1.0000E-01  9.9965E-02
             9.9981E-02  1.0000E-01
 GRADIENT:   6.7667E+02 -1.3289E+03 -4.0744E+03 -3.5100E+00 -8.6234E+00 -4.7660E+00  1.0029E+00 -2.9610E+01 -2.9251E+00  1.0906E+01
             6.3429E+00 -2.3438E+00
 
0ITERATION NO.:    4    OBJECTIVE VALUE:   10038.2125786877        NO. OF FUNC. EVALS.:  19
 CUMULATIVE NO. OF FUNC. EVALS.:       87
 NPARAMETR:  1.1400E+00  3.3825E+00  2.4300E+00 -6.4844E-01  8.0570E-02  8.5891E-02  3.6478E-03  3.6064E-02  7.4473E-02  2.9947E-02
             8.5840E-02  2.2750E-02
 PARAMETER:  1.0620E-01  9.9810E-02  9.9600E-02 -9.9997E-02  1.0001E-01  9.9993E-02  9.9993E-02  1.0014E-01  1.0000E-01  9.9947E-02
             9.9971E-02  1.0000E-01
 GRADIENT:   1.1340E+03 -4.4718E+02 -1.5132E+03 -5.3859E+00 -1.4748E+01 -8.2336E+00  1.0196E+00 -1.9899E+01 -2.7064E+00  2.1616E+01
             8.7288E+00 -9.2314E+00
 
0ITERATION NO.:    5    OBJECTIVE VALUE:   10038.1516035193        NO. OF FUNC. EVALS.:  17
 CUMULATIVE NO. OF FUNC. EVALS.:      104
 NPARAMETR:  1.1400E+00  3.3827E+00  2.4300E+00 -6.4647E-01  8.1251E-02  8.5954E-02  3.6452E-03  3.6806E-02  7.4492E-02  2.9494E-02
             8.6003E-02  2.2777E-02
 PARAMETER:  1.0620E-01  9.9815E-02  9.9603E-02 -9.9693E-02  1.0085E-01  1.0036E-01  9.9885E-02  1.0217E-01  1.0013E-01  9.8237E-02
             9.9253E-02  1.0060E-01
 GRADIENT:   1.1381E+03 -4.1714E+02 -1.5414E+03  1.4047E+01  3.6882E+01 -8.8846E+00 -2.0195E-01 -2.4476E-01 -9.8204E-01  5.4652E+00
             9.8163E+00 -5.7313E+00
 
0ITERATION NO.:    6    OBJECTIVE VALUE:   10038.1263808923        NO. OF FUNC. EVALS.:  18
 CUMULATIVE NO. OF FUNC. EVALS.:      122
 NPARAMETR:  1.1399E+00  3.3827E+00  2.4301E+00 -6.4851E-01  8.0607E-02  8.6020E-02  3.6441E-03  3.7320E-02  7.4503E-02  2.9177E-02
             8.6092E-02  2.2799E-02
 PARAMETER:  1.0619E-01  9.9817E-02  9.9604E-02 -1.0001E-01  1.0005E-01  1.0074E-01  9.9816E-02  1.0355E-01  1.0021E-01  9.7047E-02
             9.8503E-02  1.0109E-01
 GRADIENT:   1.1409E+03 -3.9615E+02 -1.5593E+03 -4.8291E+00 -1.2417E+01 -9.2413E+00 -9.4521E-01  1.2753E+01  3.1426E-01 -5.6117E+00
             1.0181E+01 -2.3463E+00
 
0ITERATION NO.:    7    OBJECTIVE VALUE:   10038.0740274721        NO. OF FUNC. EVALS.:  15
 CUMULATIVE NO. OF FUNC. EVALS.:      137
 NPARAMETR:  1.1405E+00  3.3831E+00  2.4306E+00 -6.4794E-01  8.0672E-02  8.7371E-02  3.6825E-03  3.7571E-02  7.4354E-02  2.9007E-02
             8.4212E-02  2.2949E-02
 PARAMETER:  1.0625E-01  9.9827E-02  9.9627E-02 -9.9920E-02  1.0013E-01  1.0853E-01  1.0009E-01  1.0344E-01  9.9202E-02  9.6534E-02
             8.3728E-02  1.0436E-01
 GRADIENT:   1.1193E+03 -3.5381E+02 -1.5107E+03 -2.3363E+00 -7.0309E+00 -3.7770E+00 -4.3573E-01 -5.5382E+00 -2.3899E-01 -8.1853E+00
            -3.6926E+00  2.4861E+01
 
0ITERATION NO.:    8    OBJECTIVE VALUE:   10038.0559355046        NO. OF FUNC. EVALS.:  16
 CUMULATIVE NO. OF FUNC. EVALS.:      153
 NPARAMETR:  1.1404E+00  3.3830E+00  2.4305E+00 -6.4811E-01  8.0672E-02  8.8005E-02  3.7008E-03  3.8366E-02  7.4269E-02  2.9292E-02
             8.4260E-02  2.2828E-02
 PARAMETER:  1.0623E-01  9.9826E-02  9.9622E-02 -9.9946E-02  1.0013E-01  1.1215E-01  1.0022E-01  1.0525E-01  9.8625E-02  9.7491E-02
             7.7448E-02  1.0171E-01
 GRADIENT:   1.1213E+03 -2.9170E+02 -1.5432E+03 -2.5666E+00 -6.7057E+00 -2.9694E+00 -5.9980E-01  6.7109E+00 -1.7470E+00  8.8538E-01
            -8.4879E+00  3.0540E+00
 
0ITERATION NO.:    9    OBJECTIVE VALUE:   10038.0538784148        NO. OF FUNC. EVALS.:  17
 CUMULATIVE NO. OF FUNC. EVALS.:      170
 NPARAMETR:  1.1404E+00  3.3830E+00  2.4306E+00 -6.4802E-01  8.0667E-02  8.8138E-02  3.7069E-03  3.8288E-02  7.4279E-02  2.9160E-02
             8.4079E-02  2.2812E-02
 PARAMETER:  1.0624E-01  9.9826E-02  9.9624E-02 -9.9933E-02  1.0013E-01  1.1291E-01  1.0031E-01  1.0496E-01  9.8691E-02  9.7029E-02
             7.7529E-02  1.0136E-01
 GRADIENT:   1.1186E+03 -2.9824E+02 -1.5320E+03 -2.4851E+00 -6.7763E+00 -2.5926E+00 -6.9800E-01  3.7748E+00 -1.3699E+00 -3.3370E+00
            -8.6864E+00  4.6062E-01
 
0ITERATION NO.:   10    OBJECTIVE VALUE:   10038.0467990717        NO. OF FUNC. EVALS.:  15
 CUMULATIVE NO. OF FUNC. EVALS.:      185
 NPARAMETR:  1.1406E+00  3.3831E+00  2.4306E+00 -6.4779E-01  8.0653E-02  8.9740E-02  3.7913E-03  3.8798E-02  7.4350E-02  2.9295E-02
             8.4637E-02  2.2813E-02
 PARAMETER:  1.0626E-01  9.9829E-02  9.9625E-02 -9.9897E-02  1.0011E-01  1.2191E-01  1.0167E-01  1.0540E-01  9.9137E-02  9.7359E-02
             8.0550E-02  1.0139E-01
 GRADIENT:   1.0951E+03 -2.8211E+02 -1.5124E+03 -2.1368E+00 -7.1946E+00  2.1680E+00 -6.5078E-01  5.3597E+00 -1.1474E+00 -5.9281E-01
            -5.6493E+00  2.9991E+00
 
0ITERATION NO.:   11    OBJECTIVE VALUE:   10038.0340469693        NO. OF FUNC. EVALS.:  15
 CUMULATIVE NO. OF FUNC. EVALS.:      200
 NPARAMETR:  1.1405E+00  3.3831E+00  2.4306E+00 -6.5803E-01  8.1138E-02  8.9742E-02  3.8959E-03  3.8819E-02  7.4328E-02  2.9296E-02
             8.4638E-02  2.2812E-02
 PARAMETER:  1.0624E-01  9.9829E-02  9.9627E-02 -1.0148E-01  1.0071E-01  1.2192E-01  1.0448E-01  1.0546E-01  9.8932E-02  9.7219E-02
             8.0662E-02  1.0138E-01
 GRADIENT:   1.0842E+03 -2.9251E+02 -1.4924E+03 -1.5196E+01 -2.0476E+00  2.2427E+00 -4.8405E-01  4.8595E+00 -1.3049E+00 -1.2579E+00
            -5.6600E+00  2.8376E+00
 
0ITERATION NO.:   12    OBJECTIVE VALUE:   10037.7330558154        NO. OF FUNC. EVALS.:  14
 CUMULATIVE NO. OF FUNC. EVALS.:      214
 NPARAMETR:  1.1365E+00  3.3833E+00  2.4314E+00 -6.5125E-01  8.0863E-02  8.9189E-02  5.9994E-03  3.9297E-02  7.3996E-02  2.9436E-02
             8.4776E-02  2.2794E-02
 PARAMETER:  1.0587E-01  9.9834E-02  9.9657E-02 -1.0043E-01  1.0037E-01  1.1883E-01  1.6139E-01  1.0709E-01  9.5099E-02  9.4701E-02
             8.1892E-02  1.0098E-01
 GRADIENT:   8.6985E+02 -4.7960E+02 -1.1074E+03 -5.1880E+00 -1.2366E+00  1.1718E+00  3.7266E+00 -4.5868E-01 -4.9506E+00 -1.1744E+01
            -4.6844E+00  2.5572E-02
 
0ITERATION NO.:   13    OBJECTIVE VALUE:   10037.7275801309        NO. OF FUNC. EVALS.:  14
 CUMULATIVE NO. OF FUNC. EVALS.:      228
 NPARAMETR:  1.1338E+00  3.3835E+00  2.4315E+00 -6.5107E-01  8.0899E-02  8.8639E-02  6.5001E-03  3.9265E-02  7.7487E-02  3.0797E-02
             8.5067E-02  2.2776E-02
 PARAMETER:  1.0563E-01  9.9839E-02  9.9664E-02 -1.0040E-01  1.0042E-01  1.1574E-01  1.7540E-01  1.0733E-01  1.1780E-01  9.6466E-02
             8.0539E-02  1.0058E-01
 GRADIENT:   7.2985E+02 -4.5315E+02 -9.2374E+02 -3.9093E+00  1.5342E+00  2.6370E-01  4.5174E+00 -4.2625E+00  1.8598E+01 -1.4772E+01
            -6.0959E+00 -2.2103E+00
 
0ITERATION NO.:   14    OBJECTIVE VALUE:   10037.0090103139        NO. OF FUNC. EVALS.:  15
 CUMULATIVE NO. OF FUNC. EVALS.:      243
 NPARAMETR:  1.1257E+00  3.3851E+00  2.4326E+00 -6.4986E-01  8.0816E-02  8.7349E-02  4.9735E-03  3.8480E-02  7.6000E-02  3.0125E-02
             8.5180E-02  2.2785E-02
 PARAMETER:  1.0487E-01  9.9887E-02  9.9709E-02 -1.0022E-01  1.0031E-01  1.0841E-01  1.3519E-01  1.0596E-01  1.0932E-01  9.7342E-02
             8.3752E-02  1.0078E-01
 GRADIENT:   3.0538E+02 -1.9978E+02 -3.5405E+02 -2.2151E+00  1.0637E+00 -6.4055E-01  1.8951E+00  8.1543E-02  1.0103E+01 -6.4189E+00
            -2.7160E+00 -1.3364E+00
 
0ITERATION NO.:   15    OBJECTIVE VALUE:   10036.8334753446        NO. OF FUNC. EVALS.:  14
 CUMULATIVE NO. OF FUNC. EVALS.:      257
 NPARAMETR:  1.1199E+00  3.3862E+00  2.4331E+00 -6.4809E-01  8.0708E-02  8.6792E-02  3.8092E-03  3.7865E-02  7.4378E-02  2.9406E-02
             8.5153E-02  2.2793E-02
 PARAMETER:  1.0433E-01  9.9921E-02  9.9729E-02 -9.9944E-02  1.0018E-01  1.0521E-01  1.0387E-01  1.0460E-01  9.9279E-02  9.7658E-02
             8.6657E-02  1.0094E-01
 GRADIENT:   2.4156E-01 -4.8219E+00 -6.4358E+00 -1.2076E-01  3.3220E-02 -4.0693E-01 -1.5667E-01  6.4603E-01 -3.3902E-01 -5.0043E-02
            -2.9261E-01 -4.5129E-01
 
0ITERATION NO.:   16    OBJECTIVE VALUE:   10036.8306309190        NO. OF FUNC. EVALS.:  14
 CUMULATIVE NO. OF FUNC. EVALS.:      271
 NPARAMETR:  1.1200E+00  3.3863E+00  2.4332E+00 -6.4793E-01  8.0702E-02  8.7046E-02  3.9607E-03  3.7937E-02  7.4489E-02  2.9488E-02
             8.5249E-02  2.2795E-02
 PARAMETER:  1.0434E-01  9.9923E-02  9.9733E-02 -9.9920E-02  1.0017E-01  1.0667E-01  1.0785E-01  1.0464E-01  9.9944E-02  9.7653E-02
             8.7367E-02  1.0099E-01
 GRADIENT:  -2.0021E-02  8.1547E+00  5.0005E+00  1.1096E-01 -1.1645E-01  3.7433E-01  7.3875E-02 -7.6440E-01  3.3448E-01 -3.6866E-02
             1.9542E-01  4.4497E-01
 
0ITERATION NO.:   17    OBJECTIVE VALUE:   10036.8306309190        NO. OF FUNC. EVALS.:  27
 CUMULATIVE NO. OF FUNC. EVALS.:      298
 NPARAMETR:  1.1200E+00  3.3863E+00  2.4332E+00 -6.4793E-01  8.0702E-02  8.7046E-02  3.9607E-03  3.7937E-02  7.4489E-02  2.9488E-02
             8.5249E-02  2.2795E-02
 PARAMETER:  1.0434E-01  9.9923E-02  9.9733E-02 -9.9920E-02  1.0017E-01  1.0667E-01  1.0785E-01  1.0464E-01  9.9944E-02  9.7653E-02
             8.7367E-02  1.0099E-01
 GRADIENT:  -2.9959E+01 -4.8981E+02 -2.6155E+02 -5.9758E-01 -2.8075E+00  4.0323E-01  1.3221E-01 -1.2067E+00  3.4094E-01 -4.2590E-01
             2.3563E-01  8.3425E-02
 
0ITERATION NO.:   18    OBJECTIVE VALUE:   10036.8037269417        NO. OF FUNC. EVALS.:  27
 CUMULATIVE NO. OF FUNC. EVALS.:      325
 NPARAMETR:  1.1208E+00  3.3876E+00  2.4346E+00 -6.4808E-01  8.0737E-02  8.7024E-02  3.9443E-03  3.7946E-02  7.4446E-02  2.9449E-02
             8.5219E-02  2.2798E-02
 PARAMETER:  1.0442E-01  9.9962E-02  9.9788E-02 -9.9942E-02  1.0021E-01  1.0654E-01  1.0742E-01  1.0468E-01  9.9663E-02  9.7568E-02
             8.7165E-02  1.0106E-01
 GRADIENT:  -1.5604E+01 -2.5060E+02 -1.2861E+02 -2.6163E-01 -1.3172E+00  2.6694E-01  5.0695E-02 -5.6755E-01  6.8367E-02 -8.3328E-01
             5.6160E-02  7.7583E-02
 
0ITERATION NO.:   19    OBJECTIVE VALUE:   10036.7945371920        NO. OF FUNC. EVALS.:  26
 CUMULATIVE NO. OF FUNC. EVALS.:      351
 NPARAMETR:  1.1217E+00  3.3890E+00  2.4359E+00 -6.4826E-01  8.0771E-02  8.6957E-02  3.9316E-03  3.7935E-02  7.4452E-02  2.9467E-02
             8.5234E-02  2.2801E-02
 PARAMETER:  1.0449E-01  1.0000E-01  9.9843E-02 -9.9970E-02  1.0026E-01  1.0616E-01  1.0711E-01  1.0469E-01  9.9706E-02  9.7643E-02
             8.7129E-02  1.0112E-01
 GRADIENT:   4.9865E-02 -2.1977E-01  5.3616E-01 -1.1861E-01  5.6083E-02  2.3641E-02  4.4039E-02  2.8535E-02  6.5172E-02 -1.3126E-01
             5.6673E-02 -9.2655E-02
 
0ITERATION NO.:   20    OBJECTIVE VALUE:   10036.7945194093        NO. OF FUNC. EVALS.:  26
 CUMULATIVE NO. OF FUNC. EVALS.:      377
 NPARAMETR:  1.1216E+00  3.3890E+00  2.4359E+00 -6.4816E-01  8.0766E-02  8.6940E-02  3.9001E-03  3.7919E-02  7.4439E-02  2.9458E-02
             8.5219E-02  2.2801E-02
 PARAMETER:  1.0449E-01  1.0000E-01  9.9843E-02 -9.9955E-02  1.0025E-01  1.0606E-01  1.0626E-01  1.0466E-01  9.9639E-02  9.7665E-02
             8.7052E-02  1.0113E-01
 GRADIENT:   1.3310E-01  1.5948E-01  2.4012E-01 -1.1633E-02  1.7565E-02 -4.8766E-02 -1.8853E-02  6.2340E-02  2.5857E-02  6.6418E-02
            -1.2599E-01 -1.9033E-02
 
0ITERATION NO.:   21    OBJECTIVE VALUE:   10036.7945142894        NO. OF FUNC. EVALS.:  26
 CUMULATIVE NO. OF FUNC. EVALS.:      403
 NPARAMETR:  1.1216E+00  3.3890E+00  2.4359E+00 -6.4815E-01  8.0766E-02  8.6949E-02  3.9050E-03  3.7920E-02  7.4436E-02  2.9457E-02
             8.5227E-02  2.2801E-02
 PARAMETER:  1.0449E-01  1.0000E-01  9.9843E-02 -9.9953E-02  1.0025E-01  1.0611E-01  1.0639E-01  1.0466E-01  9.9617E-02  9.7658E-02
             8.7135E-02  1.0113E-01
 GRADIENT:   1.5150E-01  2.0394E-01 -1.9736E-01 -2.4006E-02 -5.5434E-02 -6.6820E-02  1.4028E-02 -2.4763E-02 -1.4603E-02  1.1659E-02
            -1.7441E-02  1.2191E-02
 
0ITERATION NO.:   22    OBJECTIVE VALUE:   10036.7945046504        NO. OF FUNC. EVALS.:  26
 CUMULATIVE NO. OF FUNC. EVALS.:      429
 NPARAMETR:  1.1216E+00  3.3890E+00  2.4359E+00 -6.4814E-01  8.0766E-02  8.6967E-02  3.9032E-03  3.7924E-02  7.4435E-02  2.9455E-02
             8.5232E-02  2.2801E-02
 PARAMETER:  1.0449E-01  1.0000E-01  9.9843E-02 -9.9951E-02  1.0025E-01  1.0622E-01  1.0633E-01  1.0465E-01  9.9609E-02  9.7657E-02
             8.7183E-02  1.0113E-01
 GRADIENT:   2.6092E-02 -1.1507E-01 -3.1302E-01 -1.7172E-02  6.3403E-02  2.7747E-02 -2.0686E-02  2.1911E-02 -1.0608E-02 -3.9097E-02
             1.2436E-02  2.2861E-02
 
0ITERATION NO.:   23    OBJECTIVE VALUE:   10036.7945046504        NO. OF FUNC. EVALS.:   2
 CUMULATIVE NO. OF FUNC. EVALS.:      431
 NPARAMETR:  1.1216E+00  3.3890E+00  2.4359E+00 -6.4812E-01  8.0765E-02  8.6967E-02  3.9070E-03  3.7925E-02  7.4438E-02  2.9458E-02
             8.5232E-02  2.2801E-02
 PARAMETER:  1.0449E-01  1.0000E-01  9.9843E-02 -9.9951E-02  1.0025E-01  1.0622E-01  1.0633E-01  1.0465E-01  9.9609E-02  9.7657E-02
             8.7183E-02  1.0113E-01
 GRADIENT:   2.6092E-02 -1.1507E-01 -3.1302E-01 -1.7172E-02  6.3403E-02  2.7747E-02 -2.0686E-02  2.1911E-02 -1.0608E-02 -3.9097E-02
             1.2436E-02  2.2861E-02
 
 #TERM:
0MINIMIZATION SUCCESSFUL
 HOWEVER, PROBLEMS OCCURRED WITH THE MINIMIZATION.
 REGARD THE RESULTS OF THE ESTIMATION STEP CAREFULLY, AND ACCEPT THEM ONLY
 AFTER CHECKING THAT THE COVARIANCE STEP PRODUCES REASONABLE OUTPUT.
 NO. OF FUNCTION EVALUATIONS USED:      431
 NO. OF SIG. DIGITS IN FINAL EST.:  4.0

 ETABAR IS THE ARITHMETIC MEAN OF THE ETA-ESTIMATES,
 AND THE P-VALUE IS GIVEN FOR THE NULL HYPOTHESIS THAT THE TRUE MEAN IS 0.
 
 ETABAR:        -2.9202E-02  1.4909E-03  4.4756E-03
 SE:             1.4547E-02  1.5625E-02  1.6931E-02
 N:                     288         288         288
 
 P VAL.:         4.4707E-02  9.2398E-01  7.9151E-01
 
 ETASHRINKSD(%)  1.6140E+01  2.6421E+00  1.4117E+00
 ETASHRINKVR(%)  2.9675E+01  5.2144E+00  2.8035E+00
 EBVSHRINKSD(%)  1.6827E+01  2.8253E+00  1.6287E+00
 EBVSHRINKVR(%)  3.0823E+01  5.5707E+00  3.2308E+00
 EPSSHRINKSD(%)  1.2985E+01
 EPSSHRINKVR(%)  2.4283E+01
 
  
 TOTAL DATA POINTS NORMALLY DISTRIBUTED (N):         2880
 N*LOG(2PI) CONSTANT TO OBJECTIVE FUNCTION:    5293.08595125891     
 OBJECTIVE FUNCTION VALUE WITHOUT CONSTANT:    10036.7945046504     
 OBJECTIVE FUNCTION VALUE WITH CONSTANT:       15329.8804559093     
 REPORTED OBJECTIVE FUNCTION DOES NOT CONTAIN CONSTANT
  
 TOTAL EFFECTIVE ETAS (NIND*NETA):                           864
  
 #TERE:
 Elapsed estimation  time in seconds:    54.12
 Elapsed covariance  time in seconds:    36.12
 Elapsed postprocess time in seconds:     0.11
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                LAPLACIAN CONDITIONAL ESTIMATION WITH INTERACTION               ********************
 #OBJT:**************                       MINIMUM VALUE OF OBJECTIVE FUNCTION                      ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 





 #OBJV:********************************************    10036.795       **************************************************
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                LAPLACIAN CONDITIONAL ESTIMATION WITH INTERACTION               ********************
 ********************                             FINAL PARAMETER ESTIMATE                           ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         1.12E+00  3.39E+00  2.44E+00 -6.48E-01  8.08E-02
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3     
 
 ETA1
+        8.70E-02
 
 ETA2
+        3.90E-03  7.44E-02
 
 ETA3
+        3.79E-02  2.95E-02  8.52E-02
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        2.28E-02
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3     
 
 ETA1
+        2.95E-01
 
 ETA2
+        4.85E-02  2.73E-01
 
 ETA3
+        4.40E-01  3.70E-01  2.92E-01
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        1.51E-01
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                LAPLACIAN CONDITIONAL ESTIMATION WITH INTERACTION               ********************
 ********************                            STANDARD ERROR OF ESTIMATE                          ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 


 THETA - VECTOR OF FIXED EFFECTS PARAMETERS   *********


         TH 1      TH 2      TH 3      TH 4      TH 5     
 
         2.19E-02  1.66E-02  1.75E-02  9.50E-02  6.17E-03
 


 OMEGA - COV MATRIX FOR RANDOM EFFECTS - ETAS  ********


         ETA1      ETA2      ETA3     
 
 ETA1
+        1.09E-02
 
 ETA2
+        6.09E-03  6.61E-03
 
 ETA3
+        6.89E-03  5.31E-03  7.35E-03
 


 SIGMA - COV MATRIX FOR RANDOM EFFECTS - EPSILONS  ****


         EPS1     
 
 EPS1
+        7.22E-04
 
1


 OMEGA - CORR MATRIX FOR RANDOM EFFECTS - ETAS  *******


         ETA1      ETA2      ETA3     
 
 ETA1
+        1.84E-02
 
 ETA2
+        7.51E-02  1.21E-02
 
 ETA3
+        6.22E-02  5.30E-02  1.26E-02
 


 SIGMA - CORR MATRIX FOR RANDOM EFFECTS - EPSILONS  ***


         EPS1     
 
 EPS1
+        2.39E-03
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                LAPLACIAN CONDITIONAL ESTIMATION WITH INTERACTION               ********************
 ********************                          COVARIANCE MATRIX OF ESTIMATE                         ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM22      OM23      OM33      SG11  

 
 TH 1
+        4.78E-04
 
 TH 2
+        3.16E-05  2.75E-04
 
 TH 3
+        1.41E-04  1.15E-04  3.07E-04
 
 TH 4
+        1.48E-06 -1.28E-06 -6.61E-07  9.02E-03
 
 TH 5
+        1.76E-06  1.06E-06  8.71E-07 -3.61E-04  3.80E-05
 
 OM11
+        3.26E-05 -1.13E-06 -5.44E-07 -9.10E-07  1.13E-07  1.18E-04
 
 OM12
+        4.55E-06  7.89E-07  6.51E-07 -6.63E-07  2.88E-08  7.38E-06  3.70E-05
 
 OM13
+        7.20E-06 -1.20E-06 -7.15E-07  3.67E-07 -9.79E-08  3.97E-05  1.69E-05  4.75E-05
 
 OM22
+        2.13E-06  3.35E-07 -3.83E-08 -1.96E-06  2.28E-07  6.33E-07  5.00E-06  2.27E-06  4.37E-05
 
 OM23
+       -6.37E-07 -2.94E-07 -4.65E-08 -8.50E-07  7.22E-08  2.23E-06  1.23E-05  7.43E-06  1.83E-05  2.81E-05
 
 OM33
+       -1.73E-06  3.98E-08  1.83E-07  9.54E-08 -4.03E-08  1.08E-05  9.11E-06  2.45E-05  7.67E-06  2.02E-05  5.41E-05
 
 SG11
+        2.86E-07  4.42E-07  3.78E-07 -3.72E-09  3.16E-08 -7.92E-07 -5.04E-08 -2.77E-08 -9.51E-08 -7.04E-08 -5.57E-08  5.22E-07
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                LAPLACIAN CONDITIONAL ESTIMATION WITH INTERACTION               ********************
 ********************                          CORRELATION MATRIX OF ESTIMATE                        ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM22      OM23      OM33      SG11  

 
 TH 1
+        2.19E-02
 
 TH 2
+        8.71E-02  1.66E-02
 
 TH 3
+        3.69E-01  3.96E-01  1.75E-02
 
 TH 4
+        7.13E-04 -8.10E-04 -3.97E-04  9.50E-02
 
 TH 5
+        1.30E-02  1.03E-02  8.06E-03 -6.17E-01  6.17E-03
 
 OM11
+        1.37E-01 -6.28E-03 -2.86E-03 -8.81E-04  1.69E-03  1.09E-02
 
 OM12
+        3.42E-02  7.81E-03  6.11E-03 -1.15E-03  7.67E-04  1.12E-01  6.09E-03
 
 OM13
+        4.77E-02 -1.05E-02 -5.92E-03  5.61E-04 -2.30E-03  5.30E-01  4.04E-01  6.89E-03
 
 OM22
+        1.47E-02  3.06E-03 -3.31E-04 -3.12E-03  5.59E-03  8.81E-03  1.24E-01  4.98E-02  6.61E-03
 
 OM23
+       -5.49E-03 -3.34E-03 -5.01E-04 -1.69E-03  2.21E-03  3.87E-02  3.80E-01  2.03E-01  5.21E-01  5.31E-03
 
 OM33
+       -1.07E-02  3.26E-04  1.42E-03  1.37E-04 -8.87E-04  1.36E-01  2.04E-01  4.84E-01  1.58E-01  5.17E-01  7.35E-03
 
 SG11
+        1.81E-02  3.69E-02  2.99E-02 -5.42E-05  7.08E-03 -1.01E-01 -1.15E-02 -5.56E-03 -1.99E-02 -1.84E-02 -1.05E-02  7.22E-04
 
1
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                LAPLACIAN CONDITIONAL ESTIMATION WITH INTERACTION               ********************
 ********************                      INVERSE COVARIANCE MATRIX OF ESTIMATE                     ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

            TH 1      TH 2      TH 3      TH 4      TH 5      OM11      OM12      OM13      OM22      OM23      OM33      SG11  

 
 TH 1
+        2.50E+03
 
 TH 2
+        2.34E+02  4.34E+03
 
 TH 3
+       -1.24E+03 -1.73E+03  4.48E+03
 
 TH 4
+       -6.64E+00 -5.05E+00  6.38E-01  1.79E+02
 
 TH 5
+       -1.51E+02 -1.36E+02  7.12E+00  1.70E+03  4.24E+04
 
 OM11
+       -8.09E+02 -1.11E+02  3.73E+02 -1.02E-01 -5.49E+01  1.28E+04
 
 OM12
+       -3.68E+02 -2.21E+02  1.19E+02  1.52E+00 -2.96E+01  3.26E+03  3.88E+04
 
 OM13
+        3.41E+02  2.47E+02 -8.90E+01  2.97E+00  1.65E+02 -1.33E+04 -1.75E+04  4.67E+04
 
 OM22
+       -2.20E+02 -1.18E+02  1.27E+02 -1.08E+00 -1.51E+02  2.49E+02  3.70E+03 -1.64E+03  3.25E+04
 
 OM23
+        2.72E+02  2.43E+02 -1.23E+02  5.90E-01  1.99E+01 -1.52E+03 -2.06E+04  1.15E+04 -2.60E+04  7.77E+04
 
 OM33
+        8.10E+01 -1.19E+02 -8.06E+01 -1.01E+00 -2.36E+01  3.42E+03  7.94E+03 -1.96E+04  5.17E+03 -2.67E+04  3.46E+04
 
 SG11
+       -1.90E+03 -2.72E+03 -5.32E+02 -9.41E+01 -2.47E+03  1.95E+04  6.82E+03 -2.05E+04  3.76E+03 -1.08E+03  6.07E+03  1.95E+06
 
1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ************************************************************************************************************************
 ********************                                                                                ********************
 ********************                LAPLACIAN CONDITIONAL ESTIMATION WITH INTERACTION               ********************
 ********************                      EIGENVALUES OF COR MATRIX OF ESTIMATE                     ********************
 ********************                                                                                ********************
 ************************************************************************************************************************
 

             1         2         3         4         5         6         7         8         9        10        11        12

 
         2.21E-01  3.83E-01  3.96E-01  4.94E-01  7.63E-01  8.20E-01  9.21E-01  1.02E+00  1.40E+00  1.59E+00  1.62E+00  2.37E+00
 
 Elapsed finaloutput time in seconds:     0.36
 #CPUT: Total CPU Time in Seconds,       95.707
Stop Time: 
Tue 03/12/2019 
10:18 AM
