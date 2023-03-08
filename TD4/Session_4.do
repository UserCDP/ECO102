clear all
use "/users/eleves-a/2022/daniela.cojocaru/TD4/ajrcomment.dta"

browse
describe

*** 1 ***
*a) An instrumental variable is a variable that is completely independent from the system, and that is used for regressions.
*b) There should be no reverse causality and no correlation
*c) They try to estimate the GDP based on the expropriation risk (institutions) of a contry.
*They measure it using the risk of expropriation as the measurement for institutions
*They use IV because of the reverse causality aka GDP can affect institutions and vice versa.

*** 2 ***
*a*
generate gdp = exp(loggdp)

*b*
graph twoway (scatter logmort0 loggdp) 
*, saving(TD4/graph1)

*c) By using log values it is easier to visualise the data

*** 3 ***
*a*
regress loggdp risk
regress loggdp risk latitude asia africa other
*c*
ivregress 2sls loggdp latitude (risk=logmort0), first
