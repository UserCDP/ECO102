clear all

cd "/users/eleves-a/2022/daniela.cojocaru/TD6/"

use "vsi-cleaned.dta"

merge 1:1 uid_state uid_district yr using "vd-cleaned.dta", nogenerate
merge 1:1 uid_state uid_district yr using "inv-cleaned.dta", nogenerate

label variable IMR "infant mortality rate"
label variable PM "particulate matter concentration"
label variable inversions "avg count of thermal inversions"
tabstat IMR PM inversions, statistics(count mean sd min max p25 p75) columns(statistics)

bysort yr: egen meanIMR=mean(IMR)
bysort yr: egen meanPM=mean(PM)
generate dmIMR = IMR - meanIMR
generate dmPM = PM - meanPM

regress dmIMR dmPM
estimates store ols1

generate PM2=PM if IMR!=.
bysort yr: egen meanPM2=mean(PM2)
generate dmPM2 = PM2 - meanPM2

regress dmIMR dmPM2
estimates store ols2

forvalues t=2001/2010 {
	generate dummy`t`= (yr==`t')
}

regress IMR PM dummy2001-dummy2010
estimates store ols3

regress IMR PM i.yr
estimates store ols4

*ssc install reghdfe

reghdfe IMR PM, absorb(uid_state##yr)
estimates store ols6

*ssc install estout
reghdfe PM inversions if IMR!=. & inversions!=., absorb(yr uid_district)
estimates store fs2

predict PMhat2

* Second stage with predicted

drop PMhat2
rename PMhat2 PMhat2
reghdfe IMR PMhat, absorb(yr uid_district)

estimates store iv2

* Second stage with ivreghdfe

