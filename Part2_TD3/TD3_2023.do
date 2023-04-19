********************************************************************************
*                            Segregation indices - TD                          *
********************************************************************************

/*------------------------------------------------------------------------------/
	
	This TD guides you in the construction of
	segregation indices across neighborhoods in Los Angeles
	
   /------------------------------------------------------------------------------*/

	cd Part2_TD3
	clear all

	
/*----s1: Prepare the dataset -------*
    *------------------------*/
	use "LA2020_Blocks_forTD.dta", clear
	keep if pop_block > 0
	
	egen tot_pop = sum(pop_block)
	egen pop_tract = sum(pop_block), bt(tract_OD)
	
	egen pop_tract_log = tag(tract_ID)
	replace pop_tract_tag=. if pop_tract_tag==0
	
	bysort tract_ID: generate N_block = _N
	
	tabstat pop_block, statistics(N mean sd min p25 median p75 max)
	
	tabstat pop_tract N_block if pop_tract_tag==1, statistics(N mean sd min p25 median p75 max)
	
/*----s2: Construct indices -------*
    *------------------------*/
	
	* 3a) Define main ethnic groups
	global ethnic "whi bla lat"

	
	* 3b) Compute tract dissimilarity index at the census block level
	
	******************************
	*Working with loops
	******************************
		* A small example
		foreach y of global ethnic {
			generate `y' = 0
		}
		
		*Another one
		foreach y of global ethnic {
			drop `y'
		}
	*******************************
	******************************
	
// 	egen whi_pop_tract = sum(whipop_d), by(tract_ID)
// 	generate whi_diff_index = abs(whipop_d / whi_pop_tract) - ((pop_block - whipop_d) / (pop_tract - whi_pop_tract))
// 	summarize whi_diff_index
//	
// 	egen whi_diss_index


	
	foreach y of global ethnic {	
	*Type your code here
	egen 'y'_pop_tract = sum('y'pop_d), by(tract_ID)
		generate 'y'_diff_index = abs(('y'pop_d / 'y'_pop_tract) - ((pop_block - 'y'pop_d) / (pop_tract - 'y)_pop_tract) ))
		egen 'y'_diss_index = sum('y'_diff_index), by(tract_ID)
		replace 'y'_diss_index = 0.5 * 'y'_diss_index
		summarize 'y'_diss_index if pop_tract_tag==1
	
	}
	
	
	
	
/*----s3: Statistical analysis -------*
    *------------------------*/

	**** Statistical analysis: what makes tracts more segregated?
	
	generate whi_frac_tract = whi_pop_tract / pop_tract
	
	binscatter whi_diss_index whi_frac_tract if pop_tract_tag==1
	
	regress whi_diss_index whi_frac_tract if pop_tract_tag==1
	
	bysort tract_ID: generate log_pop_tract = log(pop_tract)
	bysort tract_ID: egen ad_pop_tract = sd(pop_tract)
	
	reg whi_diss_index whi_frac_tract log_pop_tract if pop_tract_tag==1
	reg 
		
