clear

*** 1) Define csv files to include
local filepath = "`c(pwd)'" // Save path to current folder in a local
di "`c(pwd)'" // Display path to current folder

local files : dir "`filepath'" files "*.csv" // Save name of all files in folder ending with .csv in a local
di `"`files'"' // Display list of files to import data from


*** 2) Loop over all files to import and append each file
tempfile master // Generate temporary save file to store data in
save `master', replace empty

foreach x of local files {
    di "`x'" // Display file name

	* 2A) Import each file
	qui: import delimited "`x'", delimiter(";")  case(preserve) clear // Import csv file
	qui: gen id = subinstr("`x'", ".csv", "", .)	// Generate id variable (same as file name but without .csv)

	* 2B) Append each file to masterfile
	append using `master'
	save `master', replace
}


*** 3) Exporting finaldata
order id, first
sort id Segment
save "csv_combined.dta", replace
