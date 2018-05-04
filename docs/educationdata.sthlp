{smcl}
{title:Education Data Package}{right:Version 0.1.4}

{title:Syntax}

{p 8 16 2}
{cmd: educationdata} {cmd: using} "{help educationdata##datasetname:{it:datasetname}}" [{cmd:,} {help educationdata##options:{it:options}}]
{p_end}

{title:Description}

The {bf:educationdata} package makes it easy for you to download and format
the school, school district, and college & university data from the 
{browse "https://ed-data-portal.urban.org/":Education Data Portal} Application Programming Interface (API). Per the 
"Installing Package Dependencies" section below, you will need to install 
the SSC package {bf:libjson} before using this package.

The package is simple - indicate which dataset you'd like to download by
substituting one of the "Dataset Options" enumerated below into the {bf:using}
statement of the {bf:educationdata} command.

    . educationdata using "dataset name here"

If you'd like to subset the data, or use other options, you can add options
statements as follows:

    . educationdata using "dataset name here", optionnamehere(optionvaluehere)

Or as follows:

    . educationdata using "dataset name here", optionnamehere(optionvaluehere) 
      anotheroptionhere

{marker datasetname}{...}
{title:Dataset Name Options}

The following are dataset names that should be inserted into quotes after
the {bf:using} command, as described in the description above.

{bf:"College"}

{bf:"college ipeds directory"}: This file contains directory information for
every institution in the IPEDS universe. Includes name, address, city, state,
zip code and various URL links to the institution's home page, admissions,
financial aid offices and the net price calculator. Identifies institutions as
currently active, institutions that participate in Title IV federal financial
aid programs for which IPEDS is mandatory. It also includes variables derived
from the Institutional Characteristics survey, such as control and level of
institution, highest level and highest degree offered and Carnegie
classifications.

{bf:"college ipeds institutional-characteristics"}: This endpoint contains
data on program and award level offerings, control and affiliation of
institution. It also contains information on special learning opportunities,
student services, disability services, tuition plans and athletic conference
associations. Services and programs for service members and veterans are also
included.

{bf:"college ipeds admissions-enrollment"}: This endpoint contains data on
applicants and admissions by sex and enrollees by sex and full-time/part-time
status. These data are limited to undergraduate first-time,
degree/certificate-seeking students.

{bf:"college ipeds admissions-requirements"}: This endpoint contains data on
admissions considerations for the undergraduate selection process. SAT and ACT
test scores are included for institutions, that require test scores for
admission. These data are applicable for institutions that do not have an open
admissions policy for entering first-time students. Writing scores for both SAT
and ACT are no longer collected. The possible values for the admission
consideration variables have changed from prior data. "Do not know" is no
longer an option and "considered but not required" was added.

{bf:"college ipeds enrollment-full-time-equivalent"}: This endpoint contains
data on instructional activity measured in total credit and/or contact hours
delivered by institutions during a 12-month period. The credit hour and contact
hour activity data are used to derive 12-month full-time equivalent (FTE)
enrollments for both undergraduate and graduate levels. The graduate level does
not include credit hours for doctoral professional practice students.
Institutions can choose to accept the derived FTE or report their own FTE. Both
reported and estimated/derived FTE are available in this data table. In
addition, the reported FTE of Doctoral Professional practice students are also
included.

{bf:"college ipeds fall-enrollment"}: This endpoint contains the number of
students enrolled in the fall, by full-time/part-time status, and level of
study. For undergraduates, this is further broken down by
degree-seeking/non-degree-seeking, and degree-seeking is broken down by class
level. Institutions with traditional academic year calendar systems (semester,
quarter, trimester or 4-1-4) report their enrollment as of October 15 or the
official fall reporting date of the institution. Institutions with calendar
systems that differ by program or allow continuous enrollment report students
that are enrolled at any time between August 1 and October 31. Available levels
of study are undergraduate, graduate, first-professional (through 2008 only),
and post-baccalaureate (through 1998 only).

{bf:"college ipeds fall-enrollment race"}: This endpoint contains the number
of students enrolled in the fall, by race, full-time/part-time status, and
level of study. For undergraduates, this is further broken down by
degree-seeking/non-degree-seeking, and degree-seeking is broken down by class
level. Institutions with traditional academic year calendar systems (semester,
quarter, trimester or 4-1-4) report their enrollment as of October 15 or the
official fall reporting date of the institution. Institutions with calendar
systems that differ by program or allow continuous enrollment report students
that are enrolled at any time between August 1 and October 31. Available levels
of study are undergraduate, graduate, first-professional (through 2008 only),
and post-baccalaureate (through 1998 only).

{bf:"college ipeds fall-enrollment sex"}: This endpoint contains the number
of students enrolled in the fall, by sex, full-time/part-time status, and level
of study. For undergraduates, this is further broken down by
degree-seeking/non-degree-seeking, and degree-seeking is broken down by class
level. Institutions with traditional academic year calendar systems (semester,
quarter, trimester or 4-1-4) report their enrollment as of October 15 or the
official fall reporting date of the institution. Institutions with calendar
systems that differ by program or allow continuous enrollment report students
that are enrolled at any time between August 1 and October 31. Available levels
of study are undergraduate, graduate, first-professional (through 2008 only),
and post-baccalaureate (through 1998 only).

{bf:"college ipeds fall-enrollment race sex"}: This endpoint contains the
number of students enrolled in the fall, by race, sex, full-time/part-time
status, and level of study. For undergraduates, this is further broken down by
degree-seeking/non-degree-seeking, and degree-seeking is broken down by class
level. Institutions with traditional academic year calendar systems (semester,
quarter, trimester or 4-1-4) report their enrollment as of October 15 or the
official fall reporting date of the institution. Institutions with calendar
systems that differ by program or allow continuous enrollment report students
that are enrolled at any time between August 1 and October 31. Available levels
of study are undergraduate, graduate, first-professional (through 2008 only),
and post-baccalaureate (through 1998 only).

{bf:"college ipeds fall-enrollment age"}: This endpoint contains the number
of students enrolled in the fall, by age categories, full-time/part-time status
and level of study. Institutions with traditional academic year calendar
systems (semester, quarter, trimester or 4-1-4) report their enrollment as of
October 15 or the official fall reporting date of the institution. Institutions
with calendar systems that differ by program or allow continuous enrollment
report students that are enrolled at any time between August 1 and October 31.
Submission of enrollment by age categories is optional in even-numbered years.
Available levels of study are undergraduate, graduate, and first-professional
(through 2008 only); in 2000, only undergraduate data are available.

{bf:"college ipeds fall-enrollment age sex"}: This endpoint contains the
number of students enrolled in the fall, by age categories, sex,
full-time/part-time status and level of study. Institutions with traditional
academic year calendar systems (semester, quarter, trimester or 4-1-4) report
their enrollment as of October 15 or the official fall reporting date of the
institution. Institutions with calendar systems that differ by program or allow
continuous enrollment report students that are enrolled at any time between
August 1 and October 31. Submission of enrollment by age categories is optional
in even-numbered years. Available levels of study are undergraduate, graduate,
and first-professional (through 2008 only); in 2000, only undergraduate data
are available.

{bf:"college ipeds enrollment-headcount"}: This endpoint contains the
unduplicated head count of students enrolled over a 12-month period for both
undergraduate and graduate levels. These enrollment data are particularly
valuable for institutions that use non-traditional calendar systems and offer
short-term programs. Because this enrollment measure encompasses an entire
year, it provides a more complete picture of the number of students these
schools serve. Counts are available by level of study, sex, and race/ethnicity.

{bf:"college ipeds fall-retention"}: The first-year retention rate data
measures the percentage of first-year students who had persisted in or
completed their educational program a year later.

{bf:"college ipeds student-faculty-ratio"}: Student-to-faculty ratio is
defined as total FTE students not in graduate or professional programs divided
by total FTE instructional staff not teaching in graduate or professional
programs. All data on this file is applicable only to institutions with
undergraduate students.

{bf:"college ipeds grad-rates-200pct"}: This endpoint contains the
graduation rate status as of August 31, at the end of the academic year, for
the cohort of full-time, first-time degree/certificate-seeking undergraduates.
Data for four year institutions include the number of bachelor degree-seeking
students who enrolled eight academic years prior, the number of bachelor degree
seeking students who completed a bachelor's degree within 100, 150 or 200
percent on normal time. Data for less than 4-year institutions include the
number of full-time, first-time students who enrolled four academic years
prior, the number of students who completed any degree/certificate within 100,
150, or 200 percent of normal time.

{bf:"college ipeds grad-rates"}: This endpoint contains the graduation rate
status as of August 31, at the end of the academic year, for the cohort of
full-time, first-time degree/certificate-seeking undergraduates, by race and
sex. Data for four year institutions include the number of bachelor
degree-seeking students who enrolled six academic years prior, the number of
bachelor degree seeking students who completed any degree/certificate within
150 percent of normal time, the number who completed a bachelor's degree within
100, 125 or 150 percent on normal time, and the number of bachelor's
degree-seeking students who transferred out. Data for students seeking a
degree/certificate other than a bachelor's degree are also included for four
year institutions. Data for two year institutions include the number of
full-time, first-time students who enrolled three academic years prior, the
number of students who completed any degree/certificate within 100 or 150
percent of normal time and the number of students who transferred out. The
number of students who completed a degree/certificate within 100 percent of
normal time is not available by race and sex.

{bf:"college ipeds grad-rates-pell"}: This endpoint contains the graduation
rate status as of August 31, at the end of the academic year, for three
subcohorts of full-time, first-time degree/certificate-seeking undergraduates.
The three subcohorts are students who received a Pell grant; students who
received a subsidized Stafford Loan and did "NOT" receive a Pell grant; and
students who did not receive either a Pell grant or Stafford Loan. In four year
institutions each of the subcohorts will include the number of bachelor
degree-seeking students who enrolled six academic years prior, the number of
bachelor degree seeking students who completed any degree/certificate within
150 percent of normal time, the number who completed a bachelor's degree within
150 percent on normal time. Data for students seeking a degree/certificate
other than a bachelor's degree are also included for four year institutions.
Data for two year and less-than 2-year institutions include the number of
full-time, first-time students who enrolled three academic years prior, the
number of students who completed any degree/certificate 150 percent of normal
time.

{bf:"college ipeds outcome-measures"}: This endpoint contains award and
enrollment data from degree-granting institutions on four undergraduate cohorts
that entered an institution eight academic years ago at two points in time: six
academic years after entry and eight academic years after entry. The four
cohorts of degree/certificate-seeking undergraduates are: full-time, first-time
entering; part-time, first-time entering; full-time, non-first-time entering;
and part-time, non-first-time entering.

{bf:"college ipeds completers"}: This endpoint contains the number of
students who completed any degree or certificate by race/ethnicity and gender.

{bf:"college ipeds completions-cip"}: This endpoint contains the number of
awards by type of program, level of award (certificate or degree), first or
second major and by race/ethnicity and gender. Type of program is categorized
according to the 2-digit Classification of Instructional Programs (CIP), a
detailed coding system for postsecondary instructional programs, which groups
the 6-digit CIPs into their families. There are some exceptions, such as law
and medical fields, which were reported as 6-digits by IPEDS. These data are
available from 1991 to 2015. IPEDS reported data at the 2-digit CIP level until
2001, after that, we collapsed the 6-digit CIP data to the 2-digit level until
2015.

{bf:"District"}

{bf:"district saipe"}: This endpoint contains district level data on the size
of the population, the size of the school age population, and the size of the
school age population that is in poverty.

{bf:"district ccd finance"}: This endpoint contains disctrict level finance
data including revenues from federal, state, and local governments and
expenditures.

{bf:"School"}

{bf:"school ccd directory"}: This endpoint contains school level information on
location, mailing addresses, school types, highest and lowest grades offered,
and free and reduced price lunch. This endpoint also contains the school level
data on the number of full-time eqivalent teachers.

{bf:"school ccd enrollment"}: This endpoint contains student membership data for each
school by grade. Only operational schools serving one or more grades are
required to report membership and only these are included in this endpoint.

{bf:"school ccd enrollment race"}: This endpoint contains student membership data for
each school by grade and race. Only operational schools serving one or more
grades are required to report membership and only these are included in this
endpoint.

{bf:"school ccd enrollment sex"}: This endpoint contains student membership data for
each school by grade and sex. Only operational schools serving one or more
grades are required to report membership and only these are included in this
endpoint.

{bf:"school ccd enrollment race sex"}: This endpoint contains student membership data
for each school by grade, race, and sex. Only operational schools serving one
or more grades are required to report membership and only these are included in
this endpoint.

{marker options}{...}
{title:Command Options}

The {bf:educationdata} command takes two options for only collecting a subset
of the dataset you request:

1. {bf:{opt sub:set(str)}}: Specifies a single subset or list of subsets of the dataset
along as many valid variables as the dataset contains. The string argument must be in
quotations, multiple subset variables must be separated by a space, and multiple
subset values for a variable must either take the form of a continuous list separated
by a colon, or a list of values separated by a comma. 

To be concrete, while not a complete list of options, subset conditions may take the 
form of sub(variable1=value1), sub(variable1=value1,value2), 
sub(variable1=value1:value5), sub(variable1=value1 variable2=value1,value4,value5,value6),
or sub(variable1=value4:value6 variable2=value1,value2), to name a few. Lists 
separated by a colon and a comma in a single variable are {bf:not supported}. For 
example, sub(variable1=value1:value3,value5) is {bf:not allowed}. 

To be even more concrete, valid values might include sub(year=2011), 
sub(year=2010:2015), sub(year=2012:2016 fips=12), etc. if year and fips were 
valid variables in the dataset specified after the "using" statement.

For {bf:grade}, the options include "pk", "k", 1 through 12, and 99 (total).
Optionally, you may substitute "-1" for "pk" and "0" for "k", so the grades run
from -1 to 12 or "pk","k", and 1 to 12.

For {bf:level_of_study}, the options include "undergraduate","graduate",
"first-professional", and "post-baccalaureate".

{bf:In general}, the code 99 indicates all categories combined, or "totals only".
For example, race=99 or sex=99 indicates all races or all genders, while grade=99
indicates total for all grades. Using the 99 filter can save time for those who
only wish to request totals, and don't need by race, by grade, or by gender
breakdowns.

{marker columns}{...}
2. {bf:{opt col:umns(str)}}: Specifies the variables you would like to select, if you only
want a subset of variables. So, you might say:

. educationdata using "college ipeds directory", col(unitid year)

{bf:In addition}, the {bf:{opt clear:}} option clears the current dataset in memory before
saving the new dataset. For example,

. educationdata using "college ipeds directory", col(unitid year) clear 

{bf:And the {opt meta:data}} option allows reads in the variable names, variable labels, 
and value labels, without reading in the data. For example,

. educationdata using "college ipeds directory", meta

{title:Installing package dependencies}

The SSC package {bf:libjson} is required to use the {bf:educationdata}
package. If you do not have {bf:libjson} installed, it will be installed automatically
after first running the {bf:educationdata} command. Or, before running the package,
you can install {bf:libjson} by running the following command:

    . ssc install libjson

{title:Examples}

{bf:Examples of downloading full datasets}: 

    Download the full directory of primary and secondary school information:
        . educationdata using "school ccd directory"

    Download the full primary and secondary school enrollment totals by grade:
        . educationdata using "school ccd enrollment"
        
{bf:Examples of subsetting datasets}:
        
    Download the full directory of colleges and universities for 2011
        . educationdata using "college ipeds directory", sub(year=2011)
        
    Download the full directory of colleges and universities for 2011 in Florida.
        . educationdata using "college ipeds directory", sub(year=2011 fips=12)

    Download the full directory for 2011 in Florida and keep only the unitid and year variables.
    	. educationdata using "college ipeds directory", sub(year=2011 fips=12) col(unitid year)

    Download graduate rates for totals only, not race and sex breakdowns, for all years
        . educationdata using "college ipeds grad-rates", sub(race=99 sex=99)

{bf:Getting only metadata}:

    Get metadata for the full directory of colleges and universities
        . educationdata using "college ipeds directory", meta
        
{title:Author}

Graham MacDonald 
Office of Data Science and Technology  
Urban Institute   
