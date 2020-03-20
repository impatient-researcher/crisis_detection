// replicate rrose 1996 data cleaning very weird

clear all
set more off

use datav6.dta

encode country, gen(countryn)

sort countryn date

compress

* First, create an indicator variable for the event

gen dle=100.*(log(pdol)-log(pdol[_n-1])) if countryn==countryn[_n-1]


replace dle=. if countryn~=countryn[_n-1]

gen byte event=0

replace event=1 if ((dle>25&dle~=.)&((dle-dle[_n-1]>10)&dle[_n-1]~=.))&(countryn==countryn[_n-1])

sort countryn date

* window out adjacent cirsis
replace event=. if (event[_n-1]==1)&(countryn==countryn[_n-1])
replace event=. if (event[_n-2]==1)&(countryn==countryn[_n-2])
replace event=. if (event[_n-3]==1)&(countryn==countryn[_n-3])
replace event=. if (event[_n+1]==1)&(countryn==countryn[_n+1])
replace event=. if (event[_n+2]==1)&(countryn==countryn[_n+2])
replace event=. if (event[_n+3]==1)&(countryn==countryn[_n+3])

replace reservem=reservem*100.

g comrat=100.*comdebt/totdebt
g conrat=100.*condebt/totdebt
g varrat=100.*vardebt/totdebt
g pubrat=100.*pubdebt/totdebt
g defrat=(100.*def)/gnp
g dly=100.*(log(gnppc)-log(gnppc[_n-1])) if countryn==countryn[_n-1]

replace dly=. if countryn~=countryn[_n-1]


g dlcred=100.*(log(cred)-log(cred[_n-1])) if countryn==countryn[_n-1]
replace dlcred=. if countryn~=countryn[_n-1]


g dlres=100.*(log(res)-log(res[_n-1])) if countryn==countryn[_n-1]


replace dlres=. if countryn~=countryn[_n-1]

g fdistock=100.*fdi/totdebt

g prtstock=100.*portf/totdebt

* Real Exchange Rate; take deviations from country-specific average
g q=log(price/(usprice*pdol))

g overvaln=100.*q

local countrylist "ARG BDI BEN BFA BGD BLZ BOL BRA BRB BTN BWA CAF CHL CHN CIV CMR COG COL COM CPV CRI DOM DZA ECU EGY ETH FJI GAB GHA GIN GMB GNB GNQ GRD GTM GUY HND HTI HUN IDN IND IRN JAM JOR KEN KOR LAO LBN LBR LKA LSO MAR MDG MDV MEX MLI MLT MMR MRT MUS MWI MYS NER NGA NIC NPL OMN PAK PAN PER PHL PNG PRT PRY ROM RWA SDN SEN SLB SLE SLV SOM STP SWZ SYC SYR TCD TGO THA TTO TUN TUR TZA UGA URY VCT VEN VUT WSM YEM YUG ZAR ZMB ZWE"

foreach i in `countrylist' {

	quietly sum overvaln if country=="`i'"

	replace overvaln=overvaln-_result(3) if country=="`i'"

}



* Now lag it

replace overvaln=overvaln[_n-1] if country==country[_n-1]
replace overvaln=. if country~=country[_n-1]

* Non-Dollar Exchange Rate Variable Construction

g totshr=dolshr+dmshr+yenshr+ffrshr+swfshr+gbpshr

g dleb=-100.*(log(eb)-log(eb[_n-1])) if country==country[_n-1]

g dlef=100.*(log(ef)-log(ef[_n-1])) if country==country[_n-1]

g dleg=100.*(log(eg)-log(eg[_n-1])) if country==country[_n-1]

g dlej=100.*(log(ej)-log(ej[_n-1])) if country==country[_n-1]

g dles=100.*(log(es)-log(es[_n-1])) if country==country[_n-1]


g eexp=((dmshr/totshr)*dleg)+((yenshr/totshr)*dlej)+((ffrshr/totshr)*dlef)+((swfshr/totshr)*dles)+((gbpshr/totshr)*dleb)

* Foreign Interest Rate Variable Construction

g istar=((dolshr/totshr)*ius)+((dmshr/totshr)*ige)+((yenshr/totshr)*ija)+((ffrshr/totshr)*ifr)+((swfshr/totshr)*ich)+((gbpshr/totshr)*iuk)

dprobit event comrat conrat varrat fdistock shorttot pubrat multirat debty reservem cacc defrat dlcred dly istar overvaln
predict p

gen predicted = .
replace predicted = 1 if p > 0.5 & p != .
replace predicted = 0 if p <= 0.5 & p != .

save cleanrose
