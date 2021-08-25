$PROB base 
; Drug X; one compartment
; estimat
$INPUT ID TIME AMT DROP DV MDV
$DATA ../../../data/dat1.csv ignore=@   

$SUBR ADVAN1 TRANS2
$EST MET=1 PRINT=5 NOABORT INTER 

$PK
    TVCL = THETA(1) 
    TVV  = THETA(2) 

    CL  = TVCL * EXP(ETA(1))
    V   = TVV * EXP(ETA(2)) 

    S1 = V 

$ERROR

IPRED = F 
Y  = IPRED * (1 + ERR(1)) 

$THETA 
(0, 5) ; CL 
(0, 20) ; V

$OMEGA 
0.1
0.1

$SIGMA 0.01
$COVR 
$TAB ID TIME AMT DV MDV IPRED PRED CWRES NOPRINT  NOAPPEND ONEHEADER FILE=r2.tab 
