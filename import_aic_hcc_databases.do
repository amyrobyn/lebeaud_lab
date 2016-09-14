cd "C:\Users\Amy\Box Sync\DENV CHIKV project\Personalized Datasets\Amy\longitudinal_analysis_aug252016\output"

import excel "C:\Users\Amy\Box Sync\DENV CHIKV project\Personalized Datasets\Amy\longitudinal_analysis_aug252016\coast_HCC Follow-Up Data_20Jun15 - with Names not Merged.xls", sheet("HCC Follow-up Msambweni") firstrow clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "HCC Follow-up Msambweni", replace
import excel "C:\Users\Amy\Box Sync\DENV CHIKV project\Personalized Datasets\Amy\longitudinal_analysis_aug252016\coast_HCC Follow-Up Data_20Jun15 - with Names not Merged.xls", sheet("In Lab But No Data Msambweni") firstrow clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "In Lab But No Data Msambweni", replace
import excel "C:\Users\Amy\Box Sync\DENV CHIKV project\Personalized Datasets\Amy\longitudinal_analysis_aug252016\west_HCC_1st Followup.xls", sheet("Sheet1") firstrow clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "west_HCC_1st Followup", replace
import excel "C:\Users\Amy\Box Sync\DENV CHIKV project\Personalized Datasets\Amy\longitudinal_analysis_aug252016\west_HCC_2nd Followup.xls", sheet("Sheet1") firstrow clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "west_HCC_2nd Followup", replace
import excel "C:\Users\Amy\Box Sync\DENV CHIKV project\Personalized Datasets\Amy\longitudinal_analysis_aug252016\west_HCC_3rd Followup.xls", sheet("Sheet1") firstrow clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "west_HCC_3rd Followup", replace
import excel "C:\Users\Amy\Box Sync\DENV CHIKV project\Personalized Datasets\Amy\longitudinal_analysis_aug252016\west_HCC_Initial.xls", sheet("Sheet1") firstrow clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "west_HCC_Initial", replace
import excel "C:\Users\Amy\Box Sync\DENV CHIKV project\Personalized Datasets\Amy\longitudinal_analysis_aug252016\coast_HCC Follow-Up Data_20Jun15 - with Names not Merged.xlsx", sheet("HCC Follow-up Msambweni") firstrow clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "HCC Follow-up Msambweni", replace
import excel "C:\Users\Amy\Box Sync\DENV CHIKV project\Personalized Datasets\Amy\longitudinal_analysis_aug252016\coast_HCC Follow-Up Data_20Jun15 - with Names not Merged.xlsx", sheet("In Lab But No Data Msambweni") firstrow clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "In Lab But No Data Msambweni", replace
import excel "C:\Users\Amy\Box Sync\DENV CHIKV project\Personalized Datasets\Amy\longitudinal_analysis_aug252016\coast_HCC Initial Data_20Jun15 - without Names.xlsx", sheet("HCC Initial Msambweni") firstrow clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "HCC Initial Msambweni", replace
import excel "C:\Users\Amy\Box Sync\DENV CHIKV project\Personalized Datasets\Amy\longitudinal_analysis_aug252016\coast_HCC Initial Data_20Jun15 - without Names.xlsx", sheet("In Data Missing Lab - Msambweni") clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "In Data Missing Lab - Msambweni", replace
import excel "C:\Users\Amy\Box Sync\DENV CHIKV project\Personalized Datasets\Amy\longitudinal_analysis_aug252016\coast_HCC Initial Data_20Jun15 - without Names.xlsx", sheet("In Lab Missing Data - Msambweni") clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "In Lab Missing Data - Msambweni", replace
insheet using "C:\Users\Amy\Box Sync\DENV CHIKV project\Personalized Datasets\Amy\longitudinal_analysis_aug252016\Coast_AIC_Init-Katherine.csv", comma clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "Coast_AIC_Init-Katherine", replace
insheet using "C:\Users\Amy\Box Sync\DENV CHIKV project\Personalized Datasets\Amy\longitudinal_analysis_aug252016\FILE1   4 coast_aicfu_18apr16.csv", comma clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "FILE1   4 coast_aicfu_18apr16", replace
insheet using "C:\Users\Amy\Box Sync\DENV CHIKV project\Personalized Datasets\Amy\longitudinal_analysis_aug252016\FILE2  AIC Ukunda Malaria...  .csv", comma clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "FILE2  AIC Ukunda Malaria", replace
insheet using "C:\Users\Amy\Box Sync\DENV CHIKV project\Personalized Datasets\Amy\longitudinal_analysis_aug252016\Western_AICFU-Katherine.csv", comma clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "Western_AICFU-Katherine", replace
insheet using "C:\Users\Amy\Box Sync\DENV CHIKV project\Personalized Datasets\Amy\longitudinal_analysis_aug252016\West_AIC_INITIAL.csv", comma clear case
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "West_AIC_INITIAL", replace

append using "In Data Missing Lab - Msambweni.dta" "In Lab But No Data Msambweni.dta" "In Lab Missing Data - Msambweni.dta" "west_HCC_1st Followup.dta" "west_HCC_2nd Followup.dta" "west_HCC_3rd Followup.dta" "west_HCC_Initial.dta" "HCC Follow-up Msambweni.dta" "Coastal_aic_followup.dta" "Coastal_aic_initial.dta" "Coastal_aic_ukunda_malaria.dta" "Coast_AIC_Init-Katherine.dta" "West_AIC_INITIAL.dta" "Western_AICFU-Katherine.dta" "FILE2  AIC Ukunda Malaria.dta" "FILE1   4 coast_aicfu_18apr16.dta" "HCC Initial Msambweni.dta", gen(append) force

gen fevertemp =.
replace fevertemp = 1 if temperature >= 37.8
replace fevertemp = 0 if temperature < 37.8

foreach var of varlist *date*{
		capture gen double my`var'= date(`var',"DMY")
		capture format my`var' %td
		drop `var'
}
foreach var of varlist my*{
	gen `var'_year = year(`var')
	gen `var'_month = month(`var')
	gen `var'_day = day(`var')

}
gen day = myinterviewdate_day
gen month = myinterviewdate_month
gen year = myinterviewdate_year

			replace studyid = subinstr(studyid, ".", "",.) 
			replace studyid = subinstr(studyid, "/", "",.)
			replace studyid = subinstr(studyid, " ", "",.)
			drop if studyid ==""
			
	bysort  studyid: gen dup_merged = _n 
	tab dup_merged
	list studyid if dup_merged>1
	list studyid if dup_merged>1
	tempfile merged
	save merged, replace
	*keep those that i dropped for duplicate and show to elysse
	keep if dup_merged >1	
	outsheet using "dupinterviews", comma replace
	use merged.dta, clear
	drop if dup_merged >1
	
tempfile merged
save merged, replace


*take visit out of id
						forval i = 1/3 { 
							gen id`i' = substr(studyid, `i', 1) 
						}
*gen id_wid without visit						 
	rename id1 id_city  
	rename id2 id_cohort  
	rename id3 id_visit 
	tab id_visit 
	gen id_childnumber = ""
	replace id_childnumber = substr(studyid, +4, .)
	order id_cohort id_city id_visit id_childnumber studyid
	egen id_wide = concat(id_city id_cohort id_childnum)
				
save all_interviews, replace