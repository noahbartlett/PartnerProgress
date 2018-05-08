**   Partner Performance Report
**   COP FY17
**   Aaron Chafetz
**   Purpose: correct naming partner and mechanism names to offical source
**   Date: November 22, 2016
**   Updated: 5/8/2018

/* NOTES
	- Data source: FACTS Info, March 3, 2018
	- mechanism partner list COP 2016-2018
*/
********************************************************************************

global datetime "201803291002"

*import data
	import excel using "$data/FY16-18 Standard COP Matrix Report-${datetime}.xls", ///
		cellrange(A3) case(lower) clear

*rename variables
	rename A operatingunit
	rename B mechanismid

	local copyr 2016
	foreach v of varlist C E G {
		rename `v' primepartner`copyr'
		local copyr = `copyr' + 1
		}
		*end
		
	local copyr 2016
	foreach v of varlist D F H {
		rename `v' implementingmechanismname`copyr'
		local copyr = `copyr' + 1
		}
		*end

*figure out latest name for IM and partner (should both be from the same year)
	foreach y in primepartner implementingmechanismname{
		gen `y' = ""
		gen `y'yr =.
		foreach x in 2016 2017 2018{
			replace `y' = `y'`x' if `y'`x'!=""
			replace `y'yr = `x' if `y'`x'!=""
			}
			}
			*end

*keep only necessary infor	
	keep mechanismid implementingmechanismname primepartner  

*save 
	save "$output/officialnames.dta", replace

