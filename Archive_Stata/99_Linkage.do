		
** Linkage **
		
	*linkage = TX_NEW/HTS_TST_POS
		keep if inlist(indicator, "HTS_TST_POS", "TX_NEW")

	*reshape long to allow dataset to become a timeseries & transform time variable to date format
		egen id = group(operatingunit primepartner fundingagency mechanismid ///
			implementingmechanismname indicator)
		reshape long fy, i(id) j(qtr, string)
		drop id
		
	*recode 0s to missing
		recode fy (0 = .)
		
	*reshape for calculation
		reshape wide fy, i(qtr operatingunit primepartner fundingagency mechanismid implementingmechanismname) j(indicator, string)
	
	*calc linkage
		gen fyLINKAGE = round(fyTX_NEW/fyHTS_TST_POS, .001)
	
	*reshape back to long & only keep linkage data
		reshape long
		keep if indicator=="LINKAGE" & fy!=.
		
	*reshape wide to append to original dataset	
		reshape wide fy, i(operatingunit primepartner fundingagency mechanismid implementingmechanismname indicator) j(qtr, string)
	
	*save
		replace indicator = "LINKAGE (HTS to TX)"
		save "$output/lnkgdata.dta", replace
		
** FINAL CLEANUP & EXPORT			
	* reopen 
		use "$output/nearfinaldata.dta", clear
		append using "$output/lnkgdata.dta"
		