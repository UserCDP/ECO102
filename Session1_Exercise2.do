sysuse auto, clear

browse
describe

*1*
*drop expensive
generate expensive = 1 if price > 7000
replace expensive = 0 if price < 7000

*2*
label variable expensive "Can I buy this car?"
label define expensive_label 1 "Too expensive" 0 "Yes"
label values expensive expensive_label
describe

*3*
drop if expensive == 1

*4*
generate size = "Short" if length < 160
replace size = "Medium" if length > 160 & length < 199
replace size = "Long" if length > 199
drop if size == "Long"
