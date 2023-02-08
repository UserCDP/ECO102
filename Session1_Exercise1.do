sysuse auto

browse
describe

*1*
summarize price
summarize price, detail

*2*
codebook mpg

*3*
list make if rep78==.

*4*
list make if weight < 1800 | weight > 4300

*5*
tabulate foreign
tabulate foreign if rep78==3

*6*
bysort make: summarize mpg
*by foreign: summarize mpg

*7*
correlate mpg price

*8*
graph twoway (scatter mpg price)

*9*
graph twoway (scatter mpg weight, by(foreign))

