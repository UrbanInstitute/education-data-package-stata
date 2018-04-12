{smcl}
{title:Education Data Package}{right:Version 0.0.4}

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

    . educationdata using "dataset name here", optionnamehere("optionvaluehere")

{marker datasetname}{...}
{title:Dataset Name Options}

The following are dataset names that should be inserted into quotes after
the {bf:using} command, as described in the description above.

{bf:"College"}

{bf:"college ipeds directory"}: This file contains directory information for
institution in the IPEDS universe. Includes name, address, city, state, zip
and various URL links to the institution's home page, admissions, financial aid
and the net price calculator. Identifies institutions as currently active,
that participate in Title IV federal financial aid programs for which IPEDS is
It also includes variables derived from the Institutional Characteristics
such as control and level of institution, highest level and highest degree
and Carnegie classifications.

{bf:"college ipeds institutional-characteristics"}: This endpoint contains
on program and award level offerings, control and affiliation of institution.
also contains information on special learning opportunities, student services,
services, tuition plans and athletic conference associations. Services and
for service members and veterans are also included.

{bf:"college ipeds admissions-enrollment"}: This endpoint contains data on
and admissions by sex and enrollees by sex and full-time/part-time status.
data are limited to undergraduate first-time, degree/certificate-seeking
students.

{bf:"college ipeds admissions-requirements"}: This endpoint contains data on
considerations for the undergraduate selection process. SAT and ACT test scores
included for institutions, that require test scores for admission. These data
applicable for institutions that do not have an open admissions policy for
first-time students. Writing scores for both SAT and ACT are no longer
The possible values for the admission consideration variables have changed from
data. "Do not know" is no longer an option and "considered but not required"
added.

{bf:"college ipeds enrollment-full-time-equivalent"}: This endpoint contains
on instructional activity measured in total credit and/or contact hours
by institutions during a 12-month period. The credit hour and contact hour
data are used to derive 12-month full-time equivalent (FTE) enrollments for
undergraduate and graduate levels. The graduate level does not include credit
for doctoral professional practice students. Institutions can choose to accept
derived FTE or report their own FTE. Both reported and estimated/derived FTE
available in this data table. In addition, the reported FTE of Doctoral
practice students are also included.

{bf:"college ipeds fall-enrollment"}: This file contains the number of
enrolled in the fall, by full-time/part-time status, and level of study. For
this is further broken down by degree-seeking/non-degree-seeking, and
is broken down by class level. Institutions with traditional academic year
systems (semester, quarter, trimester or 4-1-4) report their enrollment as of
15 or the official fall reporting date of the institution. Institutions with
systems that differ by program or allow continuous enrollment report students
are enrolled at any time between August 1 and October 31.

{bf:"college ipeds fall-enrollment race"}: This file contains the number of
enrolled in the fall, by race, full-time/part-time status, and level of study.
undergraduates, this is further broken down by
and degree-seeking is broken down by class level. Institutions with traditional
year calendar systems (semester, quarter, trimester or 4-1-4) report their
as of October 15 or the official fall reporting date of the institution.
with calendar systems that differ by program or allow continuous enrollment
students that are enrolled at any time between August 1 and October 31.

{bf:"college ipeds fall-enrollment sex"}: This file contains the number of
enrolled in the fall, by sex, full-time/part-time status, and level of study.
undergraduates, this is further broken down by
and degree-seeking is broken down by class level. Institutions with traditional
year calendar systems (semester, quarter, trimester or 4-1-4) report their
as of October 15 or the official fall reporting date of the institution.
with calendar systems that differ by program or allow continuous enrollment
students that are enrolled at any time between August 1 and October 31.

{bf:"college ipeds fall-enrollment race sex"}: This file contains the number
students enrolled in the fall, by race, sex, full-time/part-time status, and
of study. For undergraduates, this is further broken down by
and degree-seeking is broken down by class level. Institutions with traditional
year calendar systems (semester, quarter, trimester or 4-1-4) report their
as of October 15 or the official fall reporting date of the institution.
with calendar systems that differ by program or allow continuous enrollment
students that are enrolled at any time between August 1 and October 31.

{bf:"college ipeds fall-enrollment age"}: This endpoint contains the number
students enrolled in the fall, by age categories, full-time/part-time status
level of study. Institutions with traditional academic year calendar systems
quarter, trimester or 4-1-4) report their enrollment as of October 15 or the
fall reporting date of the institution. Institutions with calendar systems that
by program or allow continuous enrollment report students that are enrolled at
time between August 1 and October 31. Submission of enrollment by age
is optional in even-numbered years.

{bf:"college ipeds fall-enrollment age sex"}: This endpoint contains the
of students enrolled in the fall, by age categories, sex, full-time/part-time
and level of study. Institutions with traditional academic year calendar
(semester, quarter, trimester or 4-1-4) report their enrollment as of October
or the official fall reporting date of the institution. Institutions with
systems that differ by program or allow continuous enrollment report students
are enrolled at any time between August 1 and October 31. Submission of
by age categories is optional in even-numbered years.

{bf:"college ipeds grad-rates-200pct"}: This endpoint contains the
rate status as of August 31, at the end of the academic year, for the cohort of
first-time degree/certificate-seeking undergraduates. Data for four year
include the number of bachelor degree-seeking students who enrolled eight
years prior, the number of bachelor degree seeking students who completed a
degree within 100, 150 or 200 percent on normal time. Data for less than 4-year
include the number of full-time, first-time students who enrolled four academic
prior, the number of students who completed any degree/certificate within 100,
or 200 percent of normal time.

{bf:"college ipeds grad-rates"}: This endpoint contains the graduation rate
as of August 31, at the end of the academic year, for the cohort of full-time,
degree/certificate-seeking undergraduates, by race and sex. Data for four year
include the number of bachelor degree-seeking students who enrolled six
years prior, the number of bachelor degree seeking students who completed any
within 150 percent of normal time, the number who completed a bachelor's degree
100, 125 or 150 percent on normal time, and the number of bachelor's
students who transferred out. Data for students seeking a degree/certificate
than a bachelor's degree are also included for four year institutions. Data for
year institutions include the number of full-time, first-time students who
three academic years prior, the number of students who completed any
within 100 or 150 percent of normal time and the number of students who
out. The number of students who completed a degree/certificate within 100
of normal time is not available by race and sex.

{bf:"college ipeds grad-rates-pell"}: This endpoint contains the graduation
status as of August 31, at the end of the academic year, for three subcohorts
full-time, first-time degree/certificate-seeking undergraduates. The three
are students who received a Pell grant; students who received a subsidized
Loan and did "NOT" receive a Pell grant; and students who did not receive
a Pell grant or Stafford Loan. In four year institutions each of the subcohorts
include the number of bachelor degree-seeking students who enrolled six
years prior, the number of bachelor degree seeking students who completed any
within 150 percent of normal time, the number who completed a bachelor's degree
150 percent on normal time. Data for students seeking a degree/certificate
than a bachelor's degree are also included for four year institutions. Data for
year and less-than 2-year institutions include the number of full-time,
students who enrolled three academic years prior, the number of students who
any degree/certificate 150 percent of normal time.

{bf:"college ipeds outcome-measures"}: This endpoint contains award and
data from degree-granting institutions on four undergraduate cohorts that
an institution eight academic years ago at two points in time: six academic
after entry and eight academic years after entry. The four cohorts of
undergraduates are: full-time, first-time entering; part-time, first-time
full-time, non-first-time entering; and part-time, non-first-time entering.

{bf:"college ipeds completions-cip"}: This endpoint contains the number of
by type of program, level of award (certificate or degree), first or second
and by race/ethnicity and gender. Type of program is categorized according to
2-digit Classification of Instructional Programs (CIP), a detailed coding
for postsecondary instructional programs, which groups the 6-digit CIPs into
families. There are some exceptions, such as law and medical fields, which were
as 6-digits by IPEDS. These data are available from 1991 to 2015. IPEDS
data at the 2-digit CIP level until 2001, after that, we collapsed the 6-digit
data to the 2-digit level until 2015.

{bf:"college ipeds completers"}: This endpoint contains the number of
who completed any degree or certificate by race/ethnicity and gender.

{bf:"college ipeds enrollment-headcount"}: This endpoint contains the
head count of students enrolled over a 12-month period for both undergraduate
graduate levels. These enrollment data are particularly valuable for
that use non-traditional calendar systems and offer short-term programs.
this enrollment measure encompasses an entire year, it provides a more complete
of the number of students these schools serve. Counts are available by level of
sex, and race/ethnicity.

{bf:"District"}

{bf:"district saipe"}: This endpoint contains district level data on the size
the population, the size of the school age population, and the size of the
age population that is in poverty.

{bf:"district ccd finance"}: This endpoint contains disctrict level finance
including revenues from federal, state, and local governments and expenditures.

{bf:"School"}

{bf:"school ccd directory"}: This endpoint contains school level information on
mailing addresses, school types, highest and lowest grades offered, and free
reduced price lunch. This endpoint also contains the school level data on the
of full-time eqivalent teachers.

{bf:"school ccd enrollment"}: This endpoint contains student membership data for each
by grade. Only operational schools serving one or more grades are required to
membership and only these are included in this endpoint.

{bf:"school ccd enrollment race"}: This endpoint contains student membership data for
school by grade and race. Only operational schools serving one or more grades
required to report membership and only these are included in this endpoint.

{bf:"school ccd enrollment sex"}: This endpoint contains student membership data for
school by grade and sex. Only operational schools serving one or more grades
required to report membership and only these are included in this endpoint.

{bf:"school ccd enrollment race sex"}: This endpoint contains student membership data
each school by grade, race, and sex. Only operational schools serving one or
grades are required to report membership and only these are included in this
endpoint.

{marker options}{...}
{title:Command Options}

The {bf:educationdata} command takes two for only collecting a subset
of the dataset you request:

1. {bf:{opt sub:set(str)}}: Specifies a single subset or list of subsets of the dataset
along as many valid variables as the dataset contains. The string argument must be in
quotations, multiple subset variables must be separated by a space, and multiple
subset values for a variable must either take the form of a continuous list separated
by a colon, or a list of values separated by a comma. 

To be concrete, while not a complete list of options, subset conditions may take the 
form of sub("variable1=value1"), sub("variable1=value1,value2"), 
sub("variable1=value1:value5"), sub("variable1=value1 variable2=value1,value4,value5,value6"),
or sub("variable1=value4:value6 variable2=value1,value2"), to name a few. Lists 
separated by a colon and a comma in a single variable are {bf:not supported}. For 
example, sub("variable1=value1:value3,value5") is {bf:not allowed}. 

To be even more concrete, valid values might include sub("year=2011"), 
sub("year=2010:2015"), sub("year=2012:2016 cbsa=33860"), etc. if year and cbsa were 
valid variables in the dataset specified after the "using" statement.

{marker columns}{...}
2. {bf:{opt col:umns(str)}}: Specifies the variables you would like to select, if you only
want a subset of variables. So, you might say:

. educationdata using "college ipeds directory", col("unitid year")

{title:Installing package dependencies}

The SSC package {bf:libjson} is required to use the {bf:educationdata}
package. If you do not have {bf:libjson} installed, you will be prompted
to install it after running the {bf:educationdata} command. You can 
install {bf:libjson} by running the following command:

    . ssc install libjson

{title:Examples}

{bf:Examples of downloading full datasets}: 

    Download the full directory of primary and secondary school information:
        . educationdata using "school ccd directory"

    Download the full primary and secondary school enrollment totals by grade:
        . educationdata using "school ccd enrollment"
        
{bf:Examples of subsetting datasets}:
        
    Download the full directory of colleges and universities for 2011
        . educationdata using "college ipeds directory", sub("year=2011")
        
    Download the full directory of colleges and universities for 2011 in the Montgomery, AL metro area.
        . educationdata using "college ipeds directory", sub("year=2011 cbsa=33860")

    Download the full directory for 2011 in Montgomery, AL and keep only the unitid and year variables.
    	. educationdata using "college ipeds directory", sub("year=2011 cbsa=33860") col("unitid year")
        
{title:Author}

Graham MacDonald 
Office of Data Science and Technology  
Urban Institute   
