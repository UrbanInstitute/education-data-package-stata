*Use Urban Institute's Education Data Portal to pull number of graduates by race*gender in a specificied major*college, 1994-2016
*Source: IPEDS awards by 6-digit CIP code (Documentation: https://educationdata.urban.org/documentation/colleges.html#ipeds-awards-by-6-digit-cip-code)

*Install the educationdata Stata package if you do not already have it installed
*More information and troubleshooting is available here: https://github.com/UrbanInstitute/education-data-package-stata
ssc install libjson
net install educationdata, replace from("https://urbaninstitute.github.io/education-data-package-stata/")

*Choose a college, degree level, and major
global college 243744 // College: example is Stanford (look up "IPEDS ID" at https://nces.ed.gov/collegenavigator)
global level 7 // Level of degree: example is Bachelor's (see description of award_level at https://educationdata.urban.org/documentation/colleges.html#ipeds-awards-by-6-digit-cip-code for more)
global major 450601 // Major: example is "Economics, general" (see https://nces.ed.gov/ipeds/cipcode/Default.aspx?y=56 for others)

educationdata using "college ipeds completions-cip-6", sub(unitid=$college award_level=$level cipcode_6digit=$major year=1994:2016) clear // this gets degrees in chosen major by race and sex
save temp, replace
educationdata using "college ipeds completions-cip-6", sub(unitid=$college award_level=$level cipcode_6digit=99 year=1994:2016) clear // this gets all degrees by race and sex
append using temp
save awards, replace
erase temp.dta

*Build a chart showing a race*gender group as a percent of all students vs. of students in the specified major over time (modeled on chart in Grondin and Queiroz 2020: https://www.stanforddaily.com/2020/02/10/me-al-why-are-there-so-few-black-and-latinx-students-in-our-econ-classes/)

use awards, clear
drop if majornum==2 // drop data on second majors (only available 2000 onward)
drop unitid fips award_level majornum // drop extraneous variables
replace year=year+1 // define year as spring (when graduation generally occurs) instead of fall
lab var year "Academic year (spring)"

*Select race*gender group of interest
global sex 2 // example is female (1=Male 2=Female)
global race 2 // example is Black (1=White 2=Black 3=Hispanic 4=Asian 5=American Indian or Alaska Native 6=Native Hawaiian or other Pacific Islander 7=Two or more races 8=Nonresident alien 9=Unknown 99=Total)

gen group=1 if sex==$sex & race==$race
replace group=2 if sex==99 & race==99
drop if group==.

drop sex race
reshape wide awards, i(year cipcode_6digit) j(group)
gen percent = awards1/awards2
drop awards1 awards2

reshape wide percent, i(year) j(cipcode_6digit)
lab var percent99 "Share of all students"
lab var percent450601 "Share of economics majors" // Change variable label if you select a difference major

twoway connected percent99 year || connected percent450601 year, ytitle("Percent who are Black Women") // Change axis title if you select a different race*gender group
