clear all
import excel "/users/eleves-a/2022/daniela.cojocaru/TD2/MRW_QJE1992.xlsx", sheet("Table 3") firstrow
*use MRW_QJE1992, clear

browse
describe

*3*
*drop if Number == .

*4*
*a* Non-oil- 98countries, intermediate pop >1m, OECD
*b*
generate CountryGroup = 0 if SampleN == 1
replace CountryGroup = 1 if SampleI == 1
replace CountryGroup = 2 if SampleO == 1

*c*
tabstat GDPperadult1960 GDPperadult1985 GrowthinGDP PopGrpwth IY if SampleN == 1
tabstat GDPperadult1960 GDPperadult1985 GrowthinGDP PopGrpwth IY if SampleI == 1
tabstat GDPperadult1960 GDPperadult1985 GrowthinGDP PopGrpwth IY if SampleO == 1

*5*
generate lnGDP85 = ln(GDPperadult1960)
* graph twoway (scatter GrowthinGDP lnGDP85 if SampleI == 1)

*6*
*a*
generate ln_save = ln(IY)
generate ln_ngd = ln(PopGrpwth + 5)

*b*
*foreach x of SampleN, SampleI, SampleO {
regress lnGDP85 ln_save ln_ngd if SampleN
regress lnGDP85 ln_save ln_ngd if SampleI
regress lnGDP85 ln_save ln_ngd if SampleO
*}

*7*
*a*
generate lnSchool = ln(School)
regress ln_save lnSchool

*b*
regress lnGDP85 ln_save ln_save ln_ngd lnSchool
regress lnGDP85 ln_save ln_save ln_ngd lnSchool if SampleN
regress lnGDP85 ln_save ln_save ln_ngd lnSchool if SampleI
regress lnGDP85 ln_save ln_save ln_ngd lnSchool if SampleO

*compare with and without school
regress lnGDP85 ln_save ln_save ln_ngd if SampleI
regress lnGDP85 ln_save ln_save ln_ngd lnSchool if SampleI
