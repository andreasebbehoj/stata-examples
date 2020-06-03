***** Redcap_API.do *****
version 16
clear
file close _all
set more off

*** Import secret API key
file open text using APIKEY_redcap.txt, read text // Txt file containing secret API key
file read text token // Store API key as local 'token'

*** cURL Settings (update to match your system and REDCap)
local curlpath "C:\Windows\System32\curl.exe" // Folder where cURL is installed
local apiurl "https://redcap.au.dk/api/" // Link to REDCap database
local outfile "redcap_export" // Name of the output file

*** Run cURL command
shell  `curlpath' 	///
	--output `outfile'.csv 		///
	--form token=`token'	///
	--form content=record 	///
	--form format=csv 		///
	--form type=flat 		///
	--form filterLogic="[ppgl]='1' or [algo_9l]='1'" ///
	`apiurl'

*** Convert CSV file to Stata format
import delimited `outfile', ///
	bindquote(strict) /// Fix quotes in text fields
	stringcols(2) // Import second variable as string (Optional. Relevant if 2nd var is an ID var with leading zeroes such as SSN, CPR or similar study ID)
erase `outfile'.csv // Delete csv file

** Apply value labels (Optional).
/* Download do-file containing the value labels from REDCap (Data export / export as Stata).
Rename the do file "RedcapValuelabel.do".
Delete the first 7 lines in the do-file (everything before the first "label define" command).
Save in same folder as this do-file.
Repeat these steps every time REDCap database has been changed.
*/
do RedcapValuelabel.do // Comment out to disable

** Save
save `outfile'.dta, replace
