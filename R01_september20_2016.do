/************************************************************** *amy krystosik                  							  * *R01 results and discrepencies by strata (lab, antigen, test)* *lebeaud lab               				        		  * *last updated September 15, 2016  							  * **************************************************************/ /*to do+++ survival for hcc only	lag it by one visit (if they have positive eliza at b, that means they were infected at a).++++ prevalence/incidence only for aic	lag it by one visit (if they have positive eliza at b, that means they were infected at a).++++ #kids by number of visits	bysort subject: gen numvisits = count (visits)	tab numvisits666+ aic fever/igg pcr/igg igm/igg (ab bc cd de)	do the same thing that we did with pcr igm+++ -longitudinal nature of data- survival analysis- done by visit. do it by date+rain data- add the data from dan+ -sensisitivty by site (west vs coast)- done. put in tables and add the fever/igg lagged and igm/igg lagged+ -prnt n = 200. check the sensitivity analysis+ -rdt ns1+/+igm =+. compare that to stfd igg incidence.- done. add to tables+ -pcr + copmared to igg at next visit (ab/bc/cd)- done add to tables. updates after lab meeting sept 15: Get incidence and prevalence tables by cohort by site by visit using stanford only data to desiree by october 1  */
 
 set graphics on
 local import "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/longitudinal_analysis_sept152016/"cd "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/CSVs nov216/output"capture log close log using "R01_nov2_16.smcl", text replace set scrollbufsize 100000set more 1insheet using "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/CSVs nov216/chulaimbo aic.csv", comma clear namescapture drop *od* followupaliquotid_*
dropmiss, forcesave "chulaimbo_aic", replaceinsheet using "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/CSVs nov216/chulaimbo hcc.csv", comma clear namescapture drop *od* followupaliquotid_*
dropmiss, forcesave "chulaimbo_hcc", replaceinsheet using "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/CSVs nov216/kisumu aic.csv", comma clear namescapture drop *od* followupaliquotid_*
dropmiss, forcesave "kisuma_aic", replaceinsheet using "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/CSVs nov216/kisumu hcc.csv", comma clear namescapture drop *od* followupaliquotid_*
dropmiss, forcesave "kisumu_hcc", replaceinsheet using "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/csvsnov152016/milalani hcc.csv", comma clear namescapture drop *od* followupaliquotid_*
dropmiss, forcesave "milalani_hcc", replaceinsheet using "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/csvsnov152016/Msambweni  AIC.csv", comma clear namescapture drop *od* followupaliquotid_*dropmiss, forcesave "msambweni_aic", replaceinsheet using "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/csvsnov152016/nganja hcc.csv", comma clear namescapture drop *od* followupaliquotid_*dropmiss, forcesave "nganja_hcc", replaceinsheet using "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/CSVs nov216/ukunda aic.csv", comma clear namescapture drop *od* followupaliquotid_*dropmiss, forcesave "ukunda_aic", replaceinsheet using "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/CSVs nov216/ukunda hcc.csv", comma clear namescapture drop *od* followupaliquotid_*dropmiss, forcesave "ukunda_hcc", replaceclearforeach dataset in "chulaimbo_aic.dta" "kisumu_hcc.dta"  "chulaimbo_hcc.dta" "kisuma_aic.dta" "milalani_hcc.dta" "msambweni_aic.dta" "nganja_hcc.dta" "ukunda_aic.dta" "ukunda_hcc.dta"{use `dataset', clearcapture drop villhouse_acapture destring personid_a, replacesave `dataset', replace}append using "chulaimbo_aic.dta" "kisumu_hcc.dta"  "chulaimbo_hcc.dta" "kisuma_aic.dta" "milalani_hcc.dta" "msambweni_aic.dta" "nganja_hcc.dta" "ukunda_aic.dta"save temp, replacedropmiss*drop denvigg_e drop if studyid_a =="example"drop if studyid_a =="EXAMPLE"drop if studyid_a =="Example"save appended_september20.dta, replacereplace studyid_a = followupid_b if studyid_a ==""	/*foreach var of varlist date*{		capture confirm string var `var'			if _rc==0 {						gen double my`var'= date(`var',"DMY")						format my`var' %td						drop `var'						}			else {						gen double my`var'= `var'						format my`var' %td						#drop `var'				}							}	ds my*, not	foreach var of var `r(varlist)'{		tostring `var', replace 		replace `var'=lower(`var')		rename `var', lower		}							ds my*, not	foreach var of var `r(varlist)'{		tostring `var', replace		replace `var'=lower(`var')		rename `var', lower	}	*/				replace studyid_a= subinstr(studyid_a, ".", "",.) 			replace studyid_a= subinstr(studyid_a, "/", "",.)			replace studyid_a= subinstr(studyid_a, " ", "",.)*			drop if studyid_a==""			bysort  studyid_a: gen dup_merged = _n 	tab dup_merged	list studyid_a if dup_merged>1	tempfile merged	save merged, replace	*keep those that i dropped for duplicate and show to elysse	keep if dup_merged >1		export excel using "`save'dup", firstrow(variables) replace	use merged.dta, clear	gen dupkey = "dup" if dup_merged >1	egen studyid_adup = concat(studyid_a dupkey dup_merged) if dup_merged >1	replace studyid_a = studyid_adup if studyid_adup !=""	drop dupkey	drop if dup_merged >1	tempfile mergedsave merged, replace*take visit out of id						forval i = 1/3 { 							gen id`i' = substr(studyid_a, `i', 1) 						}*gen id_wid without visit						 	rename id1 city  	rename id2 id_cohort  	rename id3 id_visit 	tab id_visit 
		gen id_childnumber = ""	replace id_childnumber = substr(studyid_a, +4, .)	order id_cohort city id_visit id_childnumber studyid_a	egen id_wide = concat(city id_cohort id_childnum)ds, has(type string) foreach v of varlist `r(varlist)' { 	replace `v' = lower(`v') } tempfile widesave wide, replace	bysort id_wide: gen dup2 = _n 	save wide, replace		keep if dup2 >1		export excel using "dup2", firstrow(variables) replaceuse wide.dta, clear
	gen dupkey = "dup" if dup2 >1	egen id_widedup = concat(id_wide dupkey dup2) if dup2 >1	*replace id_wide = id_widedup if id_widedup !=""	drop if dup2>1
	*gen begindate = datesamplecollected_a if datesamplecollected_a !=.	reshape long chikvigg_ denvigg_  stanforddenvigg_  datesamplecollected_ datesamplerun_ studyid_ followupaliquotid_ chikviggod_ denviggod_ stanfordchikvod_  stanfordchikvigg_ stanforddenvod_ aliquotid_  chikvpcr_ chikvigm_ denvpcr_ denvigm_ stanforddenviggod_ followupid_ antigenused_ , i(id_wide) j(VISIT) string	*format datesamplecollected_* %td	*format begindate %td	tempfile long	save long, replace		use long.dta, clear	drop if id_wide==""/*	ds date*, not	foreach var of var `r(varlist)'{		tostring `var', replace 		replace `var'=lower(`var')		rename `var', lower
			}
	*/		capture drop _mergesave elisas, replace************************************add RDT data***********************************import excel "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/longitudinal_analysis_sept152016/DENGUE RDT RESULTS Aug 30th august 2016.xls", sheet("Sheet3") firstrow clear*import excel "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/RDT/sammy case control oct 23.xls", sheet("cases ") firstrow clear*insheet using "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/RDT/sammy data oct 23.csv", comma clear namesinsheet using "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/RDT/sammy data nov4.csv", comma clear namesrename studynumber study_idrename igm dengueigm_sammyrename igg dengue_igg_sammytempfile ns1save ns1, replace*take visit out of id						forval i = 1/3 { 							gen id`i' = substr(study_id, `i', 1) 						}*gen id_wid without visit						 	gen city  = id1 	gen id_cohort = id2 	gen VISIT = id3	tab VISIT	gen id_childnumber = ""	replace id_childnumber = substr(study_id, +4, .)	order id_cohort city study_id id_childnumber 	egen id_wide = concat(city id_cohort id_childnum)	foreach var of varlist _all{		rename `var', lower}	ds *t*, not	foreach var of var `r(varlist)'{		tostring `var', replace 		replace `var'=lower(`var')		rename `var', lower		}		foreach var of varlist date*{		*capture destring `var', replace		capture gen double my`var'= date(`var',"DMY")		capture format my`var' %td		drop `var'}	ds my*, not	foreach var of var `r(varlist)'{		tostring `var', replace 		replace `var'=lower(`var')		rename `var', lower	}		ds my*, not	foreach var of var `r(varlist)'{	replace `var' =trim(itrim(lower(`var')))	}replace nsi = "0" if nsi =="n eg"save ns1, replace
rename visit VISITbysort id_wide VISIT: gen dup =_n
drop if dup>1
drop dupmerge 1:1 id_wide VISIT using elisas.dta
rename VISIT visitpreservekeep if _merge ==1 export excel using "sammyonly", firstrow(variables) replacerestorebysort dengueigm_sammy visit: tab stanforddenvigg_bysort dengueigm_sammy visit: tab denvigg_preservekeep if _merge ==1 |_merge ==3keep study_id nsi stanforddenvigg_ denvigg_ dengueigm_sammy dengue_igg_sammy visit _merge export excel using "sammy_comparison", firstrow(variables) replacekeep if _merge ==3save sammy_jael, replace
restorecapture drop _mergesave elisas_PCR_RDT, replace************************************add PRNT data**********************************import excel "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/longitudinal_analysis_sept152016/LaBeaud RESULTS - july 2016.xls", sheet("2016 PRNT-Msambweni Results") cellrange(A2:E154) firstrow cleartempfile PRNT_Msambweni save PRNT_Msambweni, replaceimport excel "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/longitudinal_analysis_sept152016/LaBeaud RESULTS - july 2016.xls", sheet("2016 PRNT-Ukunda Results") cellrange(A2:F80) firstrow cleartempfile PRNT_Ukundasave PRNT_Ukunda, replaceforeach dataset in "PRNT_Msambweni" "PRNT_Ukunda"{use "`dataset'", clear		replace ALIQUOTELISAID= subinstr(ALIQUOTELISAID, " ", "",.)		*take visit out of id								forval i = 1/3 { 									gen id`i' = substr(ALIQUOTELISAID, `i', 1) 								}		*gen id_wid without visit						 			gen city  = id1 			gen id_cohort = id2 			gen visit = id3			tab visit			gen id_childnumber = ""			replace id_childnumber = substr(ALIQUOTELISAID, +4, .)			destring id_childnumber, replace			gen str4 id_childnumber4 = string(id_childnumber,"%04.0f")						order id_cohort city ALIQUOTELISAID id_childnumber4 			egen id_wide = concat(city id_cohort id_childnumber4)					*recode prnt values as pos(20+)/ neg	foreach var of varlist _all{		rename `var', lower}	foreach var of var _all{		tostring `var', replace 		replace `var'=lower(`var')		rename `var', lower		}		foreach var of var _all{		tostring `var', replace 		replace `var'=lower(`var')		rename `var', lower	}			foreach var of var _all{			replace `var' =trim(itrim(lower(`var')))	}		 foreach v of varlist  denv2 wnv chikv onnv{			  replace `v' = "pos" if `v' == "40"|`v' == ">80"|`v' == "20"			  replace `v' = "neg" if `v' == "10"|`v' == "<10"			  replace `v' = "" if `v' == "no sample"|`v' == "no sample received at cdc"|`v' == ""		   tab `v', m		   }   		   		   rename  denv2 denv_prnt		   rename  wnv wnv_prnt 		   rename  chikv chikv_prnt 		   rename  onnv onnv_prnt	save "`dataset'", replace}use "PRNT_Msambweni", clear*merge with elisas.dtacapture drop _mergemerge 1:m id_wide visit using elisas_PCR_RDT.dtadrop _mergetempfile elisas_PCR_RDT_PRNT1capture drop _mergesave elisas_PCR_RDT_PRNT1, replaceuse PRNT_Ukunda, clear*merge with elisas.dtacapture drop _mergemerge 1:m id_wide visit using elisas_PCR_RDT_PRNT1.dtadrop _mergetempfile elisas_PCR_RDT_PRNT2save elisas_PCR_RDT_PRNT2, replace*******declare data as panel data***********	ds my*, not	foreach var of var `r(varlist)'{		tostring `var', replace 		replace `var'=lower(`var')		replace `var' =trim(itrim(lower(`var')))		rename `var', lower	}	encode id_wide, gen(id)sort visitdrop if visit =="a2"encode visit, gen(visit_s)replace city ="c" if city =="r" bysort  id visit_s: gen dup_visit = _n 
drop if dup_visit >1xtset id visit_s	save longitudinal.dta, replace	   					replace city  = "Chulaimbo" if city == "c"						replace city  = "Msambweni" if city == "m"						replace city  = "Kisumu" if city == "k"						replace city  = "Ukunda" if city == "u"						replace city  = "Milani" if city == "l"						replace city  = "Nganja" if city == "g"					gen westcoast= "." 						replace westcoast = "Coast" if city =="Msambweni"|city =="Ukunda"|city =="Milani"|city =="Nganja"						replace westcoast = "West" if city =="Chulaimbo"|city =="Kisumu"					encode westcoast, gen(site)									drop stanforddenviggod_ stanfordchikvod_ stanforddenvod_foreach var of varlist stanford*{ 	replace `var' =trim(itrim(lower(`var')))	gen `var'_result =""	replace `var'_result = "neg" if strpos(`var', "neg")	replace `var'_result = "pos" if strpos(`var', "pos") 	drop `var'	rename `var'_result `var'	tab `var'}*simple prevalence/incidence by visitsave temp, replace*lagg igg by one visitdestring id visit_s, replace*xtset id visit_ssort id visit_s/*capture drop mydate_year mydate_month mydate_day*add year and month to merge with rain and vector dataforeach var of varlist my*{	gen `var'_year = year(`var')	gen `var'_month = month(`var')	gen `var'_day = day(`var')}rename  mydatesamplecollected__year yearrename mydatesamplecollected__month monthrename mydatesamplecollected__day day*/*merge m:1 year month day city using merged_enviro.dtacapture drop _merge*save lab_enviro, replacedrop visitrename visit_s visitcapture drop dup_mergeddrop v28

drop if visit ==2 
drop if visit >4
save lab, replace

use all_interviews.dta, clear
drop visit
encode id_visit, gen(visit)
*replace visit = visit +1
*replace visit = visit -1 if visit ==2
save all_interviews.dta, replace

merge 1:1 id_wide visit using lab.dta
drop _merge


*save lab_enviro_interviews, replace	foreach var in dengueigm_sammy nsi chikv_prnt denv_prnt denvpcr_ chikvpcr{			tab `var', gen(`var'encode)} capture gen igmns1pos=. replace igmns1 = 1 if dengueigm_sammyencode2 == 1 & nsiencode1 == 1  replace igmns1 = 0 if dengueigm_sammyencode2 == 0 & nsiencode1 == 0    gen season = . replace season =1 if month >=1 & month  <=3 & season ==.*label define 1 "hot no rain from mid december"replace season =2 if month >=4 & month  <=6 & season ==.*label define 2 "long rains"replace season =3 if month >=7 & month  <=10 & season ==.*label define 3 "less rain cool season"replace season =4 if month >=11 & month  <=12 & season ==.*label define 4 "short rains"*add time 0 so we can estimate the prevelance in the surival curve too. set dengue and chik =. capture drop x			expand 2 if visit == 1, gen(x)			gsort id visit -x			replace visit= visit- 1 if x == 1			foreach var of varlist *denv* {			tostring `var', replace 				replace `var'= "." if x == 1			}			foreach var of varlist *chikv* {			tostring `var', replace 				replace `var'= "." if x == 1				}			gen prevalentchikv = .gen prevalentdenv = .encode stanfordchikvigg_, gen(stanfordchikviggencode)rename stanfordchikviggencode CHIKVPOSreplace CHIKVPOS = . if CHIKVPOS==1replace CHIKVPOS = 1 if CHIKVPOS==3replace CHIKVPOS = 0 if CHIKVPOS==2tab CHIKVPOS, nolablabel define CHIKVPOS 0 "Negative" 1 "Positive", replaceencode stanforddenvigg_, gen(stanforddenviggencode)rename stanforddenviggencode DENVPOSreplace DENVPOS = . if DENVPOS ==1replace DENVPOS = 1 if DENVPOS ==3replace DENVPOS = 0 if DENVPOS ==2tab DENVPOS, nolablabel define DENVPOS 0 "Negative" 1 "Positive", replacedrop stanford* rename DENVPOS Stanford_DENV_IGGrename CHIKVPOS Stanford_CHIKV_IGGreplace prevalentdenv = 1 if  Stanford_DENV_IGG ==1 & visit ==1replace prevalentchikv = 1 if  Stanford_CHIKV_IGG ==1 & visit ==1replace id_cohort = "HCC" if id_cohort == "c"|id_cohort == "d"		replace id_cohort = "AIC" if id_cohort == "f"|id_cohort == "m" 		capture drop cohort		encode id_cohort, gen(cohort)		bysort cohort  city: sum Stanford_DENV_IGG Stanford_CHIKV_IGGsave prevalent, replace	*chikv matched prevalence	use prevalent, clear		keep if visit == 1 & Stanford_CHIKV_IGG!=.		save visit_a_chikv, replace	use prevalent, clear		keep if visit == 3 & Stanford_CHIKV_IGG!=.		save visit_b_chikv, replace				merge 1:1 id_wide using visit_a_chikv		rename _merge abvisit		keep abvisit visit id_wide		merge 1:1 id_wide visit using prevalent		keep if abvisit ==3 & Stanford_CHIKV_IGG!=.
		keep studyid  id_wide site visit antigenused_ city Stanford_CHIKV_IGG cohort gender datesamplecollected_ dob  agemonths childage age2 gender  Stanford_CHIK~G Stanford_DENV~G visit datesamplecol~_ 		export excel using "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/CSVs nov216/prevalent_visitab_chikv", firstrow(variables) replace		*denv matched prevalence	use prevalent, clear		keep if visit == 1 & Stanford_DENV_IGG!=.		save visit_a_denv, replace	use prevalent, clear		keep if visit == 3 & Stanford_DENV_IGG!=.		save visit_b_denv, replace				merge 1:1 id_wide using visit_a_denv		rename _merge abvisit		keep abvisit id_wide visit		merge 1:1 id_wide visit using prevalent		keep if abvisit ==3 & Stanford_DENV_IGG!=.		keep studyid  id_wide site visit antigenused_ city Stanford_DENV_IGG cohort gender datesamplecollected_ dob agemonths childage age2 gender  Stanford_CHIK~G Stanford_DENV~G visit datesamplecol~_		export excel using "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/CSVs nov216/prevalent_visitab_denv", firstrow(variables) replace		*denv prevlaneceuse prevalent, clear

rename denvpcr_ pcr_denv
rename chikvpcr_ pcr_chikv
rename denvigg_ igg_kenya_denv
rename chikvigg_ igg_kenya_chikv
rename dengue_igg_sammy igg_sammy_denv

foreach var in igg_kenya_chikv igg_kenya_denv pcr_chikv pcr_denv igg_sammy_denv{
capture drop dos`var'
encode `var', gen(dos`var')
drop `var'
rename dos`var' `var' 
}
replace igg_kenya_chikv = . if igg_kenya_chikv<402
replace igg_kenya_chikv = . if igg_kenya_chikv==403|igg_kenya_chikv == 404|igg_kenya_chikv == 405| igg_kenya_chikv == 406
replace igg_kenya_chikv = 408 if igg_kenya_chikv==409



save  prevalent, replace

*keep if Stanford_DENV_IGG!=.keep studyid id_wide site visit antigenused_ city village Stanford_DENV_IGG cohort age2 prevalentdenv studyid_ igg_* pcr_* gender datesamplecollected_ dob agemonths childage age2 gender  Stanford_CHIK~G Stanford_DENV~G visit datesamplecol~_*export excel using "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/CSVs nov216/prevalent_denv", firstrow(variables) replacesave prevalentdenv, replace*denv incidenceuse prevalentdenv, cleardrop if prevalentdenv == 1 keep studyid id_wide site visit antigenused_ city village Stanford_DENV_IGG cohort age2 studyid_ igg_* pcr_* gender datesamplecollected_ dob agemonths childage age2 gender  Stanford_CHIK~G Stanford_DENV~G visit datesamplecol~_*export excel using "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/CSVs nov216/incidentdenv", firstrow(variables) replacesave incidentdenv, replace*chikv prevalenceuse prevalent, clear*keep if Stanford_CHIKV_IGG!=.keep studyid  id_wide site visit antigenused_ city village Stanford_CHIKV_IGG cohort age2 prevalentchikv studyid_ igg_* pcr_* gender datesamplecollected_ dob agemonths childage age2 gender  Stanford_CHIK~G Stanford_DENV~G visit datesamplecol~_
*export excel using "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/CSVs nov216/prevalentchikv", firstrow(variables) replacesave prevalentchikv, replace*chikv incidenceuse prevalentchikv, cleardrop if prevalentchikv == 1 keep studyid id_wide site visit antigenused_ city village Stanford_CHIKV_IGG cohort age2 studyid_ igg_* pcr_* gender datesamplecollected_ dob agemonths childage age2 gender  Stanford_CHIK~G Stanford_DENV~G visit datesamplecol~_*export excel using "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/CSVs nov216/incidentchikv", firstrow(variables) replacesave incidentchikv, replace************************************************survival and longitudinal analysis********************************************foreach dataset in  "incidentdenv" "prevalentdenv"{use `dataset', clear		label variable cohort "Cohort"		label variable city "City"		label define City 1 "Chulaimbo" 2 "Kisumu" 3 "Milani" 5 "Nganja" 6 "Ukunda"save `dataset', replacedrop if visit ==0foreach v of varlist Stanford_DENV_IGG igg_* pcr_*{	tabout visit city `v' using `v'_tab.xls, replace}}foreach dataset in "incidentchikv" "prevalentchikv" "incidentdenv" "prevalentdenv"{use `dataset', clear		label variable cohort "Cohort"		label variable city "City"
		
		replace city = "Msambweni" if city =="Milani" | city =="Nganja"
				*label define City 1 "Chulaimbo" 2 "Kisumu" 3 "Milani" 5 "Nganja" 6 "Ukunda"save `dataset', replacedrop if visit ==0foreach v of varlist Stanford_* {	tabout visit city `v' using `v'_tab.xls, replace}}foreach dataset in "incidentchikv" "prevalentchikv" "incidentdenv" "prevalentdenv"{
	use `dataset', clear	
	
	foreach failvar of varlist Stanford_* pcr_denv igg_*{
											**********survival***************											preserve
						keep if cohort ==2						stset visit, id(id) failure(`failvar')				stdescribe
					
				if r(N_fail) > 0{
				display "number of failure events = "r(N_fail)							
				
										stsum						sts graph, cumhaz risktable censored(single) title(`failvar') ylabel(minmax, format(%5.3f)) ymtick(##5, tlength(scheme tick)) xlabel(, format(%td)) xlabel(, angle(45)) xmtick(##5, tlength(scheme tick)) 								graph export "cumhaz`dataset'`failvar'date.tif", width(4000) replace						sts graph, cumhaz risktable censored(single) title(`failvar') by(city) ylabel(minmax, format(%5.3f)) ymtick(##5, tlength(scheme tick)) xlabel(, format(%td)) xlabel(, angle(45)) xmtick(##5, tlength(scheme tick)) 								graph export "cumhaz`dataset'`failvar'citydate.tif", width(4000) replace						sts graph, cumhaz risktable censored(single) title(`failvar') by(site) ylabel(minmax, format(%5.3f)) ymtick(##5, tlength(scheme tick)) xlabel(, format(%td)) xlabel(, angle(45)) xmtick(##5, tlength(scheme tick)) 								graph export "cumhaz`dataset'`failvar'sitedate.tif", width(4000) replace												sts graph, survival risktable censored(single) title(`failvar') ylabel(minmax, format(%5.3f)) ymtick(##5, tlength(scheme tick)) xlabel(, format(%td)) xlabel(, angle(45)) xmtick(##5, tlength(scheme tick)) 						graph export "survival`dataset'`failvar'date.tif", width(4000) replace						sts list, survival						sts graph, risktable censored(single) title(`failvar') by(site) ylabel(minmax, format(%5.3f)) ymtick(##5, tlength(scheme tick)) xlabel(, format(%td)) xlabel(, angle(45)) xmtick(##5, tlength(scheme tick)) 						graph export "survivalsite`dataset'`failvar'date.tif", width(4000) replace						sts graph, risktable censored(single) title(`failvar') by(city) ylabel(minmax, format(%5.3f)) ymtick(##5, tlength(scheme tick)) xlabel(, format(%td)) xlabel(, angle(45)) xmtick(##5, tlength(scheme tick)) 						graph export "survivalcity`dataset'`failvar'date.tif", width(4000) replace												stset visit, id(id) failure(`failvar')						stdescribe						stsum						sts graph, cumhaz risktable tmax(11) censored(single) title(`failvar') ylabel(minmax, format(%5.3f))  ymtick(##5,  tlength(scheme tick))						graph export "cumhaz`dataset'`failvar'visit.tif", width(4000) replace						sts graph, survival risktable tmax(11) censored(single) title(`failvar')  ylabel(minmax, format(%5.3f))ymtick(##5,  tlength(scheme tick))						graph export "survival`dataset'`failvar'visit.tif", width(4000) replace						sts list, survival						sts graph, risktable tmax(11)  censored(single) title(`failvar') by(site) ylabel(minmax, format(%5.3f))ymtick(##5,  tlength(scheme tick))						graph export "survivalsite`dataset'`failvar'visit.tif", width(4000) replace						sts graph, risktable tmax(11) censored(single) title(`failvar') by(city) ylabel(minmax, format(%5.3f))ymtick(##5,  tlength(scheme tick))						graph export "survivalcity`dataset'`failvar'visit.tif", width(4000) replace
						}											
			restore
			}			
							destring `failvar', replace 			preserve																capture keep if date ==.									capture keep date id									outsheet using no_dates`var', comma replace			restore
			preserve											*drop if `failvar' >= .
														di missing(`failvar')
														di `failvar'							collapse (mean) `failvar' (count) n=`failvar' (sd) sd`failvar'=`failvar', by(cohort visit)
							egen axis = axis(visit)							generate hi`failvar'= `failvar' + invttail(n-1,0.025)*(sd`failvar'/ sqrt(n))							generate lo`failvar'= `failvar'- invttail(n-1,0.025)*(sd`failvar'/ sqrt(n))										graph twoway ///						   || (bar `failvar' axis, sort )(rcap hi`failvar' lo`failvar' axis) ///						   || scatter `failvar' axis, ms(i) mlab(n) mlabpos(2) mlabgap(2) mlabangle(45) mlabcolor(black) mlabsize(4) ///						   || , by(cohort) ylabel(, format(%5.3f)) ymtick(#4,  tlength(scheme tick)) legend(label(1 "`failvar'") label(2 "95% CI")) xlabel(0 (1) 3)   title(`dataset' by cohort and visit)						 graph export "`dataset'`failvar'visitcohort1.tif", width(4000) replace 			restore							preserve									*drop if `failvar' == .
							di missing(`failvar')
							di `failvar'							collapse (mean) `failvar' (count) n=`failvar' (sd) sd`failvar'=`failvar', by(cohort city)							egen axis = axis(city)							generate hi`failvar'= `failvar' + invttail(n-1,0.025)*(sd`failvar'/ sqrt(n))							generate lo`failvar'= `failvar'- invttail(n-1,0.025)*(sd`failvar'/ sqrt(n))						graph twoway ///						   || (bar `failvar' axis, sort )(rcap hi`failvar' lo`failvar' axis) ///						   || scatter `failvar' axis, ms(i) mlab(n) mlabpos(2) mlabgap(2) mlabangle(45) mlabcolor(black) mlabsize(4) ///						   || , by(cohort) ylabel(, format(%5.4f)) ymtick(#4,  tlength(scheme tick)) legend(label(1 "`failvar'") label(2 "95% CI")) xlabel(1(1)4, valuelabel  angle(45))  title(`dataset' by cohort and city)							graph export "`dataset'`failvar'citycohort.tif", width(4000) replace 			restore					}
						else {						display "no failure events"			
				}	
										foreach dataset in "incidentdenv" "prevalentdenv"{	use `dataset', clearforeach failvar of varlist Stanford_* pcr_denv igg_*{
										**********survival***************							
									stdescribe
					
				if r(N_fail) > 0{
				display "number of failure events = "r(N_fail)							
				

			preserve 						keep if cohort ==2						stset visit, id(id) failure(`failvar')						stdescribe						stsum						sts graph, cumhaz risktable censored(single) title(`failvar') ylabel(minmax, format(%5.3f)) ymtick(##5, tlength(scheme tick)) xlabel(, format(%td)) xlabel(, angle(45)) xmtick(##5, tlength(scheme tick)) 								graph export "cumhaz`dataset'`failvar'date.tif", width(4000) replace						sts graph, cumhaz risktable censored(single) title(`failvar') by(city) ylabel(minmax, format(%5.3f)) ymtick(##5, tlength(scheme tick)) xlabel(, format(%td)) xlabel(, angle(45)) xmtick(##5, tlength(scheme tick)) 								graph export "cumhaz`dataset'`failvar'citydate.tif", width(4000) replace						sts graph, cumhaz risktable censored(single) title(`failvar') by(site) ylabel(minmax, format(%5.3f)) ymtick(##5, tlength(scheme tick)) xlabel(, format(%td)) xlabel(, angle(45)) xmtick(##5, tlength(scheme tick)) 								graph export "cumhaz`dataset'`failvar'sitedate.tif", width(4000) replace												sts graph, survival risktable censored(single) title(`failvar') ylabel(minmax, format(%5.3f)) ymtick(##5, tlength(scheme tick)) xlabel(, format(%td)) xlabel(, angle(45)) xmtick(##5, tlength(scheme tick)) 						graph export "survival`dataset'`failvar'date.tif", width(4000) replace						sts list, survival						sts graph, risktable censored(single) title(`failvar') by(site) ylabel(minmax, format(%5.3f)) ymtick(##5, tlength(scheme tick)) xlabel(, format(%td)) xlabel(, angle(45)) xmtick(##5, tlength(scheme tick)) 						graph export "survivalsite`dataset'`failvar'date.tif", width(4000) replace						sts graph, risktable censored(single) title(`failvar') by(city) ylabel(minmax, format(%5.3f)) ymtick(##5, tlength(scheme tick)) xlabel(, format(%td)) xlabel(, angle(45)) xmtick(##5, tlength(scheme tick)) 						graph export "survivalcity`dataset'`failvar'date.tif", width(4000) replace												stset visit, id(id) failure(`failvar')						stdescribe						stsum						sts graph, cumhaz risktable tmax(11) censored(single) title(`failvar') ylabel(minmax, format(%5.3f))  ymtick(##5,  tlength(scheme tick))						graph export "cumhaz`dataset'`failvar'visit.tif", width(4000) replace						sts graph, survival risktable tmax(11) censored(single) title(`failvar')  ylabel(minmax, format(%5.3f))ymtick(##5,  tlength(scheme tick))						graph export "survival`dataset'`failvar'visit.tif", width(4000) replace						sts list, survival						sts graph, risktable tmax(11)  censored(single) title(`failvar') by(site) ylabel(minmax, format(%5.3f))ymtick(##5,  tlength(scheme tick))						graph export "survivalsite`dataset'`failvar'visit.tif", width(4000) replace						sts graph, risktable tmax(11) censored(single) title(`failvar') by(city) ylabel(minmax, format(%5.3f))ymtick(##5,  tlength(scheme tick))						graph export "survivalcity`dataset'`failvar'visit.tif", width(4000) replace															restore 
									destring `failvar', replace 								preserve																capture keep if date ==.									capture keep date id									outsheet using no_dates`var', comma replace								restore															preserve									*drop if `failvar' == .
														di missing(`failvar')
														di `failvar'							collapse (mean) `failvar' (count) n=`failvar' (sd) sd`failvar'=`failvar', by(cohort visit)							egen axis = axis(visit)							generate hi`failvar'= `failvar' + invttail(n-1,0.025)*(sd`failvar'/ sqrt(n))							generate lo`failvar'= `failvar'- invttail(n-1,0.025)*(sd`failvar'/ sqrt(n))						graph twoway ///						   || (bar `failvar' axis, sort )(rcap hi`failvar' lo`failvar' axis) ///						   || scatter `failvar' axis, ms(i) mlab(n) mlabpos(2) mlabgap(2) mlabangle(45) mlabcolor(black) mlabsize(4) ///						   || , by(cohort) ylabel(, format(%5.3f)) ymtick(#4,  tlength(scheme tick)) legend(label(1 "`failvar'") label(2 "95% CI")) xlabel(0 (1) 3)   						 graph export "`dataset'`failvar'visitcohort1.tif", width(4000) replace 				restore								preserve									*drop if `failvar' == .
													di missing(`failvar')
														di `failvar'							collapse (mean) `failvar' (count) n=`failvar' (sd) sd`failvar'=`failvar', by(cohort city)							egen axis = axis(city)							generate hi`failvar'= `failvar' + invttail(n-1,0.025)*(sd`failvar'/ sqrt(n))							generate lo`failvar'= `failvar'- invttail(n-1,0.025)*(sd`failvar'/ sqrt(n))						graph twoway ///						   || (bar `failvar' axis, sort )(rcap hi`failvar' lo`failvar' axis) ///						   || scatter `failvar' axis, ms(i) mlab(n) mlabpos(2) mlabgap(2) mlabangle(45) mlabcolor(black) mlabsize(4) ///						   || , by(cohort) ylabel(, format(%5.4f)) ymtick(#4,  tlength(scheme tick)) legend(label(1 "`failvar'") label(2 "95% CI")) xlabel(1(1)4, valuelabel  angle(45))  title(`dataset' by cohort and city)							graph export "`dataset'`failvar'citycohort.tif", width(4000) replace 				restore				}				
			else {						display "no failure events"			
				}		
							}	
			}						*masambweni hcc results with gps for donalcd "/Users/amykrystosik/Box Sync/DENV CHIKV project/Personalized Datasets/Amy/CSVs nov216/output"use incidentchikv, clear
encode city, gen(cityint)keep if cityint ==4 & cohort ==3 
sum Stanford_CHIKV_IGG cityint cohort visit gender datesamplecollected_ dob 
keep studyid id_wide visit village Stanford_CHIKV_IGG cityint cohort visit gender datesamplecollected_ dob agemonths childage age2 gender  Stanford_CHIK~G Stanford_DENV~G visit datesamplecol~_
keep if Stanford_CHIKV_IGG!=.
save masambweni_hcc_chik, replace

use incidentdenv, clear
encode city, gen(cityint)keep if cityint ==4 & cohort ==3 
sum Stanford_DENV_IGG cityint cohort visit gender datesamplecollected_ dob 
keep studyid id_wide visit village Stanford_DENV_IGG cityint cohort visit gender datesamplecollected_ dob agemonths childage age2 gender  Stanford_CHIK~G Stanford_DENV~G visit datesamplecol~_
keep if Stanford_DENV_IGG!=.
save masambweni_hcc_denv, replace

merge 1:1 id_wide visit using masambweni_hcc_chik
drop _merge cohort cityint 
*rename id_wide studyid
label drop _all
keep id_wide studyid visit village Stanford_DENV_IGG visit gender datesamplecollected_ agemonths childage gender  Stanford_CHIK~G Stanford_DENV~G visit datesamplecol~_

gen villageid=""
replace villageid = substr(id_wide, +1, 1)
replace villageid = "3" if villageid =="g"
replace villageid = "4" if villageid =="l"
destring villageid, replace


gen houseid = ""
replace houseid = substr(studyid, +4, 4)

order studyid houseid villageid

save masambweni_hcc_chk_denv, replace

import excel "/Users/amykrystosik/Box Sync/DENV CHIKV project/Coast Cleaned/Demography/Demography Latest/Msambweni_coordinates complete Nov 21 2016.xls", sheet("Sheet1") firstrow clear
gen houseid  = string(House,"%04.0f")
rename Village villageid
order houseid villageid
drop if villageid ==.
bysort houseid villageid: gen dup =_n
egen duphouse = concat(houseid dup) if dup>1
replace houseid = duphouse if dup>1

merge 1:m villageid houseid using masambweni_hcc_chk_denv
keep id_wide studyid  visit villageid houseid Stanford_DENV_IGG visit gender datesamplecollected_ agemonths childage gender  Stanford_CHIK~G Stanford_DENV~G visit datesamplecol~_ X Y 
order id_wide studyid  visit Stanford_CHIK~G Stanford_DENV~G  X Y 
keep if id_wide!=""

replace childage = abs(childage)
replace agemonths = abs(agemonths)
save masambweni_hcc_chk_denv_xy, replace

outsheet using masambweni_hcc_chk_denv_xy1.csv, names comma replace


use masambweni_hcc_chk_denv_xy, clear


gen visitstring = ""
replace visitstring = "a" if visit ==1
replace visitstring = "b" if visit ==2
replace visitstring = "c" if visit ==3
replace visitstring = "d" if visit ==4
order visit visitstring


forval i = 1/2 { 							gen id`i' = substr(id_wide, `i', 1) 						}*gen id_wid without visit						 		gen id_childnumber = ""			replace id_childnumber = substr(id_wide, +3, .)			order id1 id2 visitstring id_childnumber studyid
			egen idfull = concat(id1 id2 visitstring id_childnumber)order idfull studyid
compare idfull studyid
replace studyid=idfull if studyid==""
outsheet using masambweni_hcc_chk_denv_xy2.csv, names comma replace

keep if childage != . | gender !=.
save temp, replace

keep if childage ==. | gender ==.
drop houseid
merge 1:1 studyid using all_interviews.dta
drop houseid
keep if _merge !=2
append using temp
*keep id_wide studyid  visit villageid houseid Stanford_DENV_IGG visit gender datesamplecollected_ agemonths childage gender  Stanford_CHIK~G Stanford_DENV~G visit datesamplecol~_ X Y 

outsheet using masambweni_hcc_chk_denv_xy3.csv, names comma replace

