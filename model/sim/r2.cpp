$NMEXT
run = "r2"
project=here::here("model","nonmem")
olabels = c("ECL", "EV")
slabels = c("PROP")

$PKMODEL ncmt=1, depot=FALSE
  
$MAIN
double TVCL = THETA1;
double TVV  = THETA2;

double CL  = TVCL * exp(ECL);
double V   = TVV * exp(EV); 

$TABLE
double IPRED = F ;
double Y  = IPRED * (1 + PROP); 

$CAPTURE CP Y
  
$SET delta=0.1, end=40