********************************************************************************
*            Women labor force participation and IV - TD                       *
********************************************************************************

/*------------------------------------------------------------------------------/
	
	This TD reviews an application of IV to the estimation of the impact of
	family size on the labor force participation of women
	
   /------------------------------------------------------------------------------*/

   *Set the working directory correctly
   cd ....


/*----s1: Prepare the dataset -------*
    *------------------------*/

	clear all
	*Merge menlog and individual files using the idlog identifier 
	use menlog, clear
	merge 1:m idlog using "individu.dta", nogenerate

	* keep single-households dwellings 
	keep if nmen == 1
	
	* keep couples with their children
	keep if mtyla == "4" //household composed of a couple and othes
	keep if nlien == "1" | nlien == "2" | nlien == "3" //restricting to parents and their children

	* keep families with 2 or 3 kids
	keep if mne == 2 | mne == 3
	
	
	* identify twins among kids
	* twins are identified by age
	gen age = (nag + nag1) / 2
	gen age_kid = age if nlien == "3"
	sort idmen age_kid
	by idmen age_kid:  gen dup = cond(_N == 1, 0, _n)  if age_kid ! = .

	
	* identify families with same gender of first two kids: IV 1
	gen invage = -age
	sort idmen nlien invage
	bys idmen: gen nobs = _n
	gen girl1 = 1 if nsexe == "2" & nobs == 3
	gen girl2 = 1 if nsexe == "2" & nobs == 4
	egen mgirl1 = sum(girl1), by(idmen)
	egen mgirl2 = sum(girl2), by(idmen)
	gen mgirl_12 = mgirl1 + mgirl2
	gen same_gender = mgirl_12 != 1

	
	* drop twins if at first birth
	gen twin_first = dup > 0 & dup != . & nobs == 3
	egen hh_twin_first = sum(twin_first), by(idmen) // tag all family members in families with twins
	
	*COMPLETE THIS LINE
	drop if hh_twin_first == 1
	
	
	* identify families with twins after first birth: IV 2 
		
	*COMPLETE THESE LINES 
	gen twin = dup > 0 & dup != . & nobs == 4
	egen hh_twin = sum(twin), by(idmen)
	
	*Keep parents
	*COMPLETE THIS LINE
	keep if nobs < 3
	
	* keep mothers in couples with men
	gen mother = nsexe == "2"
	egen sum_mother = sum(mother), by(idmen)
	keep if sum_mother == 1

	* keep couples with working ability
	*COMPLETE THESE LINES
	egen min_age = min(nag), by(dmen)
	egen max_age = max(nag), by(idmen)
	
	keep if min_age > 15 & max_age < 61

	* Additional variables 
	gen large_family = mne1 > 2 
	gen mlarge = mother * large_family
	gen mhh_twin = mother * hh_twin
	gen msame_gender = mother * same_gender

	gen non_work = ntravail == "2" // codes 1 if the person is not working 
	gen non_work_extended = non_work == 1 | ntpp == "1" // codes 1 if the person is either not working, or working part-time 

	gen high_diploma = ndiplo > "4"
	gen ln_age = log(nag)
	

	*** Regressions
	reg non_work_extended mother large_family mlarge
	reg non_work_extended mother large_family mlarge ln_age high_diploma
	reghdfe non_work_extended mother large_family mlarge ln_age high_diploma, absorb(idmen)
	
	ivregress non_work_extended mother (mlarge=mhh_twin), absorb(idmen) first
