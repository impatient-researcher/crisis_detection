// replicating rose 1996 results
// the goal is to do the following:
// 1. replicate the original probit results
// 2. use a panel setting (bias uncorrected)
// 3. use a panel setting (bias corrected)
// key ref: https://arxiv.org/pdf/1610.07714.pdf

clear all
set more off

log using rose.log, replace

use cleanrose.dta

drop p
drop predicted

// plain flavor probit
probit event comrat conrat varrat fdistock shorttot pubrat multirat debty reservem cacc defrat dlcred dly istar overvaln
outreg2 using regression.doc, replace ctitle(Plain) addtext(Country FE, No, Time FE, No)

/*predict p1
gen predicted1 = .
replace predicted1 = 1 if p1 > 0.5 & p1 != .
replace predicted1 = 0 if p1 <= 0.5 & p1 != .
*/

// then panel
egen country_id = group(country) 
tsset country_id date

// uncorrected
probitfe event comrat conrat varrat fdistock shorttot pubrat multirat debty reservem cacc defrat dlcred dly istar overvaln, noc
outreg2 using regression.doc, append ctitle(Panel Uncorrected) addtext(Country FE, Yes, Time FE, Yes)

// analytical 
probitfe event comrat conrat varrat fdistock shorttot pubrat multirat debty reservem cacc defrat dlcred dly istar overvaln, an
outreg2 using regression.doc, append ctitle(Panel Analytical) addtext(Country FE, Yes, Time FE, Yes)

// jacknife ss1
probitfe event comrat conrat varrat fdistock shorttot pubrat multirat debty reservem cacc defrat dlcred dly istar overvaln, jack ss1
outreg2 using regression.doc, append ctitle(Panel Jacknife ss1) addtext(Country FE, Yes, Time FE, Yes)

// jacknife ss2
probitfe event comrat conrat varrat fdistock shorttot pubrat multirat debty reservem cacc defrat dlcred dly istar overvaln, jack ss2
outreg2 using regression.doc, append ctitle(Panel Jacknife ss2) addtext(Country FE, Yes, Time FE, Yes)

// jacknife js
probitfe event comrat conrat varrat fdistock shorttot pubrat multirat debty reservem cacc defrat dlcred dly istar overvaln, jack js
outreg2 using regression.doc, append ctitle(Panel Jacknife js) addtext(Country FE, Yes, Time FE, Yes)

// jacknife jj
probitfe event comrat conrat varrat fdistock shorttot pubrat multirat debty reservem cacc defrat dlcred dly istar overvaln, jack jj
outreg2 using regression.doc, append ctitle(Panel Jacknife jj) addtext(Country FE, Yes, Time FE, Yes)


capture log close
