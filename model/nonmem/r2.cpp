$NMEXT


$MAIN
double TVCL = THETA1;
double TVV  = THETA2;

double CL  = TVCL * exp(ETA1);
double V   = TVV * exp(ETA2); 

$ERROR
double IPRED = F ;
double Y  = IPRED * (1 + EPS1); 
