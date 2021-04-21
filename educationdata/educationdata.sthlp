{smcl}
{title:Education Data Package}{right:Version 0.4.1}

{title:Syntax}

{p 8 16 2}
{cmd: educationdata} {cmd: using} "{help educationdata##datasetname:{it:datasetname}}" [{cmd:,} {help educationdata##options:{it:options}}]
{p_end}

{title:Examples}

{bf:Examples of downloading full datasets}: 

    (Note that when downloading full datasets we recommend using the "csv" option, 
    described above and with examples provided at the end of this section.)

    Download the full directory of primary and secondary school information:
        . educationdata using "school ccd directory"

    Download the full primary and secondary school enrollment totals by grade:
        . educationdata using "school ccd enrollment"
        
{bf:Examples of subsetting datasets}:
        
    Note that there can be no spaces around the equals sign (e.g., use sub(year=2011), not sub(year = 2011)).

    Download the full directory of colleges and universities for 2011:
        . educationdata using "college ipeds directory", sub(year=2011)
        
    Download the full directory of colleges and universities for 2011 to 2013 in Florida:
        . educationdata using "college ipeds directory", sub(year=2011:2013 fips=12)

    Download the full directory for 2011 to 2013 in Florida and keep only the unitid and year variables:
    	. educationdata using "college ipeds directory", sub(year=2011:2013 fips=12) col(unitid year)

    Download graduate rates for totals only, not race and sex breakdowns, for all years:
        . educationdata using "college ipeds grad-rates", sub(race=99 sex=99)

{bf:Examples of getting statistical summaries of a dataset}:
    
    Download enrollment totals by race and state in 2018: 
    . educationdata using "school ccd enrollment", summaries(sum enrollment using fips race) sub(year=2018) 

    Download total education expenditures by core-based statistical area in 2015: 
    . educationdata using "district ccd finance", summaries(sum exp_total by cbsa) sub(year=2015) 

    Download the average number of college admissions by gender in each state in 2018: 
    . educationdata using "college ipeds admissions-enrollment", summaries(avg number_admitted by sex fips) sub(year=2018)

    Download the average number of students who took at least one AP exams by race and disability in each year: 
    . educationdata using "school crdc ap-exams", summaries(avg students_AP_exam_oneormore by race disability)

{bf:Getting only metadata}:

    Get metadata for the full directory of colleges and universities:
        . educationdata using "college ipeds directory", meta

{bf:Downloading from CSV instead of the API}:

    First, set your working directory to a location where you have read-write access
        . cd D:/Users/[your username here]/Documents

    Download the full directory of colleges and universities
        . educationdata using "college ipeds directory", csv

    Download the full directory of colleges and universities for 2011 to 2013 in Florida.
        . educationdata using "college ipeds directory", sub(year=2011:2013 fips=12) csv   


{title:Description}

The {bf:educationdata} package makes it easy for you to download and format
the school, school district, and college & university data from the 
{browse "https://educationdata.urban.org/":Education Data Portal} Application Programming Interface (API). Per the 
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
the {bf:using} command, as described in the description above. For more
information, such as valid filter variables and values, please see the
"Read Complete Documentation" links provided.

{bf:College} - {browse "https://educationdata.urban.org/documentation/colleges.html":Read Complete Documentation}

{bf:"college ipeds directory"}: This file contains directory information for
every institution in the IPEDS universe. This includes name, address, city,
state, zip code, and various URL links to the institution's home page,
admissions, financial aid offices, and the net price calculator. Identifies
institutions as currently active and institutions that participate in Title IV
federal financial aid programs for which IPEDS is mandatory. It also includes
variables derived from the Institutional Characteristics survey, such as
control and level of institution, highest level and highest degree offered and
Carnegie classifications.

{bf:"college ipeds institutional-characteristics"}: This endpoint contains
data on program and award level offerings, control and affiliation of
institution. It also contains information on special learning opportunities,
student services, disability services, tuition plans and athletic conference
associations. Services and programs for service members and veterans are also
included.

{bf:"college ipeds admissions-enrollment"}: This endpoint contains data on
applicants and admissions by sex and enrollees by sex and full-time/part-time
status. These data are limited to undergraduate first-time, degree- or
certificate-seeking students.

{bf:"college ipeds admissions-requirements"}: This endpoint contains data on
admissions considerations for the undergraduate selection process. SAT and ACT
test scores are included for institutions that require test scores for
admission. These data are applicable for institutions that do not have an open
admissions policy for entering first-time students. Writing scores for both SAT
and ACT are no longer collected. The possible values for the admission
consideration variables have changed from prior data. "Do not know" is no
longer an option and "considered but not required" was added.

{bf:"college ipeds academic-year-tuition"}: This endpoint contains data on
tuition and fees for institutions that offer primarily academic programs.

{bf:"college ipeds academic-year-tuition-prof-program"}: This endpoint
contains data on tuition and fees for professional degree programs at
institutions that offer primarily academic programs.

{bf:"college ipeds academic-year-room-board-other"}: This endpoint contains
data on room, board, and other expenses for institutions that offer primarily
academic programs.

{bf:"college ipeds program-year-tuition-cip"}: This endpoint contains data
on tuition fees for the largest programs at institutions that offer primarily
occupational programs.

{bf:"college ipeds program-year-room-board-other"}: This endpoint contains
data on room, board, and other expenses for institutions that offer primarily
occupational programs.

{bf:"college ipeds enrollment-full-time-equivalent"}: This endpoint contains
data on instructional activity measured in total credit and/or contact hours
delivered by institutions during a 12-month period. The credit hour and contact
hour activity data are used to derive 12-month full-time equivalent (FTE)
enrollments for both undergraduate and graduate levels. The graduate level does
not include credit hours for doctoral professional practice students.
Institutions can choose to accept the derived FTE or report their own FTE. Both
reported and estimated/derived FTE are available in this data table for 2003
and later. In addition, the reported FTE of doctoral professional practice
students are also included. These data are only available at the undergraduate,
graduate, and first professional level.

{bf:"college ipeds fall-enrollment race sex"}: This endpoint contains the
number of students enrolled in the fall by race, sex, full-time/part-time
status, and level of study. For undergraduates, this is further broken down by
degree-seeking/non–degree-seeking, and degree-seeking is broken down by
class level. Institutions with traditional academic year calendar systems
(semester, quarter, trimester, or 4-1-4) report their enrollment as of October
15 or the official fall reporting date of the institution. Institutions with
calendar systems that differ by program or allow continuous enrollment report
students who are enrolled at any time between August 1 and October 31.
Available levels of study are undergraduate, graduate, first-professional
(through 2008 only), and postbaccalaureate (through 1998 only).

{bf:"college ipeds fall-enrollment age sex"}: This endpoint contains the
number of students enrolled in the fall by age categories, sex,
full-time/part-time status, and level of study.Â Institutions with traditional
academic year calendar systems (semester, quarter, trimester, orÂ 4-1-4) report
their enrollment as of October 15 or the official fall reporting date of the
institution. Institutions with calendar systems that differ by program or allow
continuous enrollment report students who are enrolled at any time between
August 1 and October 31. Submission of enrollment by age categories is optional
in even-numbered years. Available levels of study are undergraduate, graduate,
and first-professional (through 2008 only); in 2000, only undergraduate data
are available.

{bf:"college ipeds fall-enrollment residence"}: This endpoint contains the
number of first-time freshmen by state of residence, along with data on the
number who graduated from high school the previous year. Institutions with
traditional academic year calendar systems (i.e., semester, quarter, trimester,
or 4-1-4) report their enrollment as of October 15 or the institutionâ€™s
official fall reporting date. Institutions with calendar systems that differ by
program or allow continuous enrollment report students that are enrolled at any
time between August 1 and October 31. Submission of enrollment of first-time
undergraduate students by residency is mandatory in even-numbered years and
optional in odd-numbered years.

{bf:"college ipeds enrollment-headcount"}: This endpoint contains the
unduplicated head count of students enrolled over a 12-month period for both
undergraduate and graduate levels. These enrollment data are particularly
valuable for institutions that use non-traditional calendar systems and offer
short-term programs. Because this enrollment measure encompasses an entire
year, it provides a more complete picture of the number of students these
schools serve. Counts are available by level of study, sex, and race/ethnicity.

{bf:"college ipeds fall-retention"}: The first-year retention rate data
measures the percentage of first-year students who persisted in or completed
their educational program a year later. This is provided for full-time and
part-time students.

{bf:"college ipeds finance"}: This endpoint contains institutional finance
data, including institutional revenue by source, scholarships, expenditures by
functional and natural classifications, endowments, assets and liabilities, and
pensions. A user guide to these data can be found {browse "https://www.urban.org/research/publication/ipeds-finance-user-guide":here}.

{bf:"college ipeds student-faculty-ratio"}: Student-to-faculty ratio is
defined as total FTE students not in graduate or professional programs divided
by total FTE instructional staff not teaching in graduate or professional
programs. All data on this file is applicable only to institutions with
undergraduate students.

{bf:"college ipeds sfa-grants-and-net-price"}: This endpoint contains data
on net price, grant amounts, and total students receiving grant aid for
first-time, full-time degree-seeking students receiving Title IV aid or any
grant aid.

{bf:"college ipeds sfa-by-living-arrangement"}: This endpoint contains data
on total first-time, full-time degree-seeking students receiving Title IV aid
or any grant aid, by living arrangement.

{bf:"college ipeds sfa-by-tuition-type"}: This endpoint contains data on
total first-time, full-time degree-seeking students paying in-district,
in-state, or out-of-state tuition.

{bf:"college ipeds sfa-all-undergraduates"}: This endpoint contains data on
total undergraduate students receiving different types of aid.

{bf:"college ipeds sfa-ftft"}: This endpoint contains data on total
first-time, full-time degree-seeking students receiving different types of aid.

{bf:"college ipeds grad-rates"}: This endpoint contains the graduation rate
status as of August 31, at the end of the academic year, for the cohort of
full-time, first-time degree- or certificate-seeking undergraduates, by race
and sex. Data for four-year institutions include the number of bachelor's
degree–seeking students who enrolled six academic years earlier, the
number of bachelor's degree–seeking students who completed any degree or
certificate within 150 percent of normal time, the number who completed a
bachelor's degree within 100, 125 or 150 percent on normal time, and the number
of bachelor's degree–seeking students who transferred out. Data for
students seeking a degree or certificate other than a bachelor's degree are
also included for four-year institutions. Data for two-year institutions
include the number of full-time, first-time students who enrolled three
academic years earlier, the number of students who completed any degree or
certificate within 100 or 150 percent of normal time and the number of students
who transferred out. The number of students who completed a degree or
certificate within 100 percent of normal time is not available by race and sex.

{bf:"college ipeds grad-rates-200pct"}: This endpoint contains the
graduation rate status as of August 31, at the end of the academic year, for
the cohort of full-time, first-time degree- or certificate-seeking
undergraduates. Data for four-year institutions include the number of
bachelor's degree–seeking students who enrolled eight academic years
earlier, the number of bachelor's degree–seeking students who completed a
bachelor's degree within 100, 150 or 200 percent on normal time. Data for less
than four-year institutions include the number of full-time, first-time
students who enrolled four academic years earlier, the number of students who
completed any degree or certificate within 100, 150, or 200 percent of normal
time.

{bf:"college ipeds grad-rates-pell"}: This endpoint contains the graduation
rate status as of August 31, at the end of the academic year, for three
subcohorts of full-time, first-time degree- or certificate-seeking
undergraduates. The three subcohorts are students who received a Pell grant,
students who received a subsidized Stafford loan and did not receive a Pell
grant, and students who did not receive either a Pell grant or Stafford loan.
In four-year institutions each of the subcohorts will include the number of
bachelor's degree–seeking students who enrolled six academic years
earlier, the number of bachelor's degree–seeking students who completed
any degree or certificate within 150 percent of normal time, the number who
completed a bachelor's degree within 150 percent on normal time. Data for
students seeking a degree or certificate other than a bachelor's degree are
also included for four-year institutions. Data for two-year and less-than
two-year institutions include the number of full-time, first-time students who
enrolled three academic years earlier and the number of students who completed
any degree or certificate 150 percent of normal time.

{bf:"college ipeds outcome-measures"}: This endpoint contains award and
enrollment data from degree-granting institutions on undergraduate cohorts that
entered an institution eight academic years ago. The two years of data
currently available have slightly different definitions for cohorts and
information available. In 2015, there is information on four cohorts collected
at two points in time: six academic years and eight academic years after entry.
The four cohorts of degree- or certificate-seeking undergraduates are
full-time, first-time entering; part-time, first-time entering; full-time,
non-first-time entering; and part-time, non-first-time entering. In 2016, there
is information on eight cohorts collected at three points in time: four
academic years, six academic years, and eight academic years after entry. The
eight cohorts are the four cohorts described for 2015, but for each, they
further disaggregate by Pell recipients and non-Pell recipients. Additionally,
in 2016, they collect more detailed information about the types of awards
completed, such as a certificate, Associate's degree, or Bachelor's degree.
Finally, the cohort definitions between the two years change. In 2015, the
completion rate at 6 and 8 years after entry uses the adjusted cohort from the
corresponding year after entry as the denominator, whereas in 2016, one
adjusted cohort is used as the denominator in all rates, regardless of years
after entry.

{bf:"college ipeds completers"}: This endpoint contains the number of
students who completed any degree or certificate by race and ethnicity and
gender.

{bf:"college ipeds completions-cip-2"}: This endpoint contains the number of
awards by type of program, level of award (certificate or degree), first or
second major, and by race and ethnicity and gender. Type of program is
categorized according to the 2-digit Classification of Instructional Programs
(CIP), a detailed coding system for postsecondary instructional programs, which
groups the 6-digit CIPs into their families. There are some exceptions, such as
law and medical fields, which were reported as 6-digits by the Integrated
Postsecondary Education Data System. IPEDS reported data at the 2-digit CIP
level until 2001; after that, the 6-digit CIP data were collapsed to the
2-digit level.

{bf:"college ipeds completions-cip-6"}: This endpoint contains the number of
awards by type of program, level of award (certificate or degree), first or
second major, and by race and ethnicity and gender. Type of program is
categorized according to the 6-digit Classification of Instructional Programs
(CIP), a detailed coding system for postsecondary instructional programs, which
changes over time.

{bf:"college ipeds academic-libraries"}: This endpoint contains information
on the academic institution's electronic and physical library, collections,
expenditures, and services. These data are available only for degree-granting
institutions, and expenditure data are available only for institutions with
total expenditures above $100,000.

{bf:"college ipeds salaries-instructional-staff"}: This endpoint contains
the number of staff, total salary outlays and average salaries of full-time,
nonmedical, instructional staff by academic rank, contract length, and sex.

{bf:"college ipeds salaries-noninstructional-staff"}: This endpoint contains
the number and salary outlays for full-time, nonmedical, noninstructional staff
by occupational category.

{bf:"college scorecard institutional-characteristics"}: This endpoint
contains institutional characteristics for each college or university,
primarily including flags for minority-serving institutions. To avoid
duplication, we exclude data that College Scorecard sourced from IPEDS. For
these data, you can see the other Institutional Characteristics and Directory
endpoints. Notably, most of the information contained in this endpoint can be
found in 2016 and aside from identification and year, only predominant degree
awarded is available in other years.

{bf:"college scorecard student-characteristics aid-applicants"}: This
endpoint contains detailed data on student aid applicants in each institution,
including income level, dependency status, number of college students sent Free
Application for Federal Student Aid (FAFSA) forms to, and other student
demographics. These data are produced for rolling two-year pooled entry cohorts
by the National Student Loan Data System (e.g., the 1997 data represent
information from two cohorts, assessment year 1996–97 and assessment year
1997–98).

{bf:"college scorecard student-characteristics home-neighborhood"}: This
endpoint contains detailed demographic information on cohorts of students,
based on when they enroll in college. These data describe the population
residing in the students' home zip codes, including information about race,
education level, nationality, poverty status, household income, and employment
status. The US Treasury Department calculated these data elements using census
data for two-year pooled cohorts at each institution (e.g., the 2005 file
includes the 2004–05 and 2005–06 earnings cohorts). Home zip codes
are determined using information from when the student first applied for
financial aid.

{bf:"college scorecard earnings"}: This endpoint contains information on
earnings for former students, by their pooled entry cohort and institution.
This information may be available 6, 7, 8, 9, and 10 years after the pooled
cohort entered college, but availability varies by cohort. For example, the
assessment year (AY) 1996–97 and AY 1997–98 pooled cohort has
earnings data available 6, 7, 8, 9, and 10 years after entry, but the AY
2001-02 and AY 2002–03 pooled cohort only has earnings data 10 years
after entry and the AY 2003–04 and AY 2004–05 pooled cohort only
has earnings data 8 years after entry.

{bf:"college scorecard default"}: This endpoint contains information on the
default rates by cohort for two or three years after students entered
repayment. The two-year default rate is available from 1996 to 2012, and the
three-year default rate is available starting in 2011. The cohorts are those
that entered repayment two or three years before the year of measurement. For
example, those who entered repayment between October 1, 2012, and September 30,
2013 (which we identify as cohort 2012, but corresponds with fiscal year 2013),
have their three-year default rate measured as of September 30, 2015 (year
2015).

{bf:"college scorecard repayment"}: This endpoint contains detailed
repayment data by pooled cohort and institution. These data are also available
by subgroup, including dependency status, Pell recipiency, first-generation
status, sex, and income level. These repayment rates are measured one, three,
five, and seven years after the cohort enters repayment. For example the
one-year repayment rate for fiscal year (FY) 2008 and FY 2009 cohorts
(cohort_year 2008) are measured in FY 2009 and FY 2010 (year 2009),
respectively.

{bf:"college nhgis census-2010"}: This endpoint contains geographic
variables corresponding to 2010 Census geographies for each IPEDS institution.
Geographies are merged on by latitude and longitude when available; when
unavailable, latitudes and longitudes were obtained from address information
using Urban's geocoder. The geocoder uses StreetMap Premium from Esri to
perform accurate offline geocoding. Geocode accuracy variables indicate the
degree of precision of this geocoding. Additional information on the match
accuracy can be found {browse "https://developers.arcgis.com/rest/geocode/api-reference/geocoding-service-output.htm":here}.
Geographies for older years of data or low-accuracy geocode matches should be
used with caution.

{bf:"college nhgis census-2000"}: This endpoint contains geographic
variables corresponding to 2000 Census geographies for each IPEDS institution.
Geographies are merged on by latitude and longitude when available; when
unavailable, latitudes and longitudes were obtained from address information
using Urban's geocoder. The geocoder uses StreetMap Premium from Esri to
perform accurate offline geocoding. Geocode accuracy variables indicate the
degree of precision of this geocoding. Additional information on the match
accuracy can be found {browse "https://developers.arcgis.com/rest/geocode/api-reference/geocoding-service-output.htm":here}.
Geographies for older years of data or low-accuracy geocode matches should be
used with caution.

{bf:"college nhgis census-1990"}: This endpoint contains geographic
variables corresponding to 1990 Census geographies for each IPEDS institution.
Geographies are merged on by latitude and longitude when available; when
unavailable, latitudes and longitudes were obtained from address information
using Urban's geocoder. The geocoder uses StreetMap Premium from Esri to
perform accurate offline geocoding. Geocode accuracy variables indicate the
degree of precision of this geocoding. Additional information on the match
accuracy can be found {browse "https://developers.arcgis.com/rest/geocode/api-reference/geocoding-service-output.htm":here}.
Geographies for older years of data or low-accuracy geocode matches should be
used with caution.

{bf:"college fsa financial-responsibility"}: This endpoint contains
financial responsibility composites scores for for-profit and nonprofit
institutions. These scores gauge an institution's financial health and help the
Department of Education assess an institution's financial responsibility
compliance. The scores are based on a primary reserve ratio, an equity ratio,
and a net income ratio. They are collected at the OPEID level, but we report
them at the UNITID level in order to facilitate merging with IPEDS data.

{bf:"college fsa grants"}: This endpoint contains data on Title IV grant
volume and total recipients by institution and year. These data are collected
by the Office of Federal Student Aid at the OPEID level, and we have provided
them at the unit ID level. Where these differ, amounts have been allocated to
each institution based on full-time equivalent students. To avoid
double-counting, users should use the _unitid variables; _opeid variables are
the original amounts and will lead to double-counting unless only one record
per OPEID year is kept.

{bf:"college fsa loans"}: This endpoint contains data on Title IV loan
volume and total recipients by institution and year. These data are collected
by the Office of Federal Student Aid at the OPEID level, and we have provided
them at the unit ID level. Where these differ, amounts have been allocated to
each institution based on full-time equivalent students. To avoid
double-counting, users should use the _unitid variables; _opeid variables are
the original amounts and will lead to double-counting unless only one record
per OPEID year is kept.

{bf:"college fsa campus-based-volume"}: This endpoint contains data on Title
IV campus-based programs volume and total recipients by institution and year.
These data are collected by the Office of Federal Student Aid at the OPEID
level, and we have provided them at the unit ID level. Where these differ,
amounts have been allocated to each institution based on full-time equivalent
students. To avoid double-counting, users should use the _unitid variables;
_opeid variables are the original amounts and will lead to double-counting
unless only one record per OPEID year is kept.

{bf:"college fsa 90-10-revenue-percentages"}: This endpoint contains the
amount and percentage of each proprietary institution's revenues from Title IV
sources and non–Title IV sources as provided by the institution in its
audited financial statements.

{bf:"college nacubo endowments"}: This endpoint contains data on annual
endowments.

{bf:"college nccs 990-forms"}: This endpoint contains data from 990 tax
forms filed annually by nonprofit organizations.

{bf:District} - {browse "https://educationdata.urban.org/documentation/school-districts.html":Read Complete Documentation}

{bf:"district ccd directory"}: This endpoint contains school district (local
education agency identification)-level geographic and mailing information,
agency type, highest and lowest grades offered, special education students and
English language learners, and full-time equivalent teachers and other staff.

{bf:"district ccd enrollment"}: This endpoint contains student membership data
for each school district by grade.

{bf:"district ccd enrollment race"}: This endpoint contains student membership
data for each school district by grade and race.

{bf:"district ccd enrollment sex"}: This endpoint contains student membership
data for each school district by grade and sex.

{bf:"district ccd enrollment race sex"}: This endpoint contains student
membership data for each school district by grade, race, and sex.

{bf:"district ccd finance"}: This endpoint contains district level finance data
including revenues from federal, state, and local governments and expenditures.

{bf:"district saipe"}: This endpoint contains district level data on the size
of the population, the size of the school age population, and the size of the
school age population that is in poverty.

{bf:"district edfacts assessments"}: This endpoint contains district-level
achievement results for state assessments in mathematics and reading or
language arts, by grade. It includes the number of students who completed each
assessment for whom a proficiency level was assigned and the proficiency share.
The proficiency share is reported as a range, unless there are more than 300
students in the subgroup, with the magnitude of the range decreasing as the
number of students reported increases. States can change their statewide
assessments, academic standards, or thresholds for proficiency levels, leading
to changes in the proficiency share from year to year. The proficiency shares
for Virginia's 2016–17 grade 5–8 math assessments are too low.
Users should instead refer to the Virginia Department of Education's Statistics
and Reports {browse "http://www.doe.virginia.gov/statistics_reports/index.shtml":website}
for accurate data.

{bf:"district edfacts assessments race"}: This endpoint contains district-level
achievement results for state assessments in mathematics and reading or
language arts, by grade and race or ethnicity. It includes the number of
students who completed each assessment for whom a proficiency level was
assigned and the proficiency share. The proficiency share is reported as a
range, unless there are more than 300 students in the subgroup, with the
magnitude of the range decreasing as the number of students reported increases.
States can change their statewide assessments, academic standards, or
thresholds for proficiency levels, leading to changes in the proficiency share
from year to year. Users are cautioned that the proficiency shares for
Virginia's 2016–17 grade 5–8 math assessments are too low. The
proficiency shares for Virginia's 2016–17 grade 5–8 math
assessments are too low. Users should instead refer to the Virginia Department
of Education's Statistics and Reports {browse "http://www.doe.virginia.gov/statistics_reports/index.shtml":website}
for accurate data.

{bf:"district edfacts assessments sex"}: This endpoint contains district-level
achievement results for state assessments in mathematics and reading or
language arts, by grade and sex. It includes the number of students who
completed each assessment for whom a proficiency level was assigned and the
proficiency share. The proficiency share is reported as a range, unless there
are more than 300 students in the subgroup, with the magnitude of the range
decreasing as the number of students reported increases. States can change
their statewide assessments, academic standards, or thresholds for proficiency
levels, leading to changes in the proficiency share from year to year. The
proficiency shares for Virginia's 2016–17 grade 5–8 math
assessments are too low. Users should instead refer to the Virginia Department
of Education's Statistics and Reports {browse "http://www.doe.virginia.gov/statistics_reports/index.shtml":website}
for accurate data.

{bf:"district edfacts assessments special-populations"}: This endpoint contains
district-level achievement results for state assessments in mathematics and
reading or language arts, by grade and special population subgroups. It
includes the number of students who completed each assessment for whom a
proficiency level was assigned and the proficiency share. The proficiency share
is reported as a range, unless there are more than 300 students in the
subgroup, with the magnitude of the range decreasing as the number of students
reported increases. Special population subgroups include children with one or
more disabilities, economically disadvantaged students, students who are
homeless, migrant students, and students with limited English proficiency.
Beginning in 2017, special population subgroups also include students who are
in foster care and students who are military connected. States can change their
statewide assessments, academic standards, or thresholds for proficiency
levels, leading to changes in the proficiency share from year to year. The
proficiency shares for Virginia's 2016–17 grade 5–8 math
assessments are too low. Users should instead refer to the Virginia Department
of Education's Statistics and Reports {browse "http://www.doe.virginia.gov/statistics_reports/index.shtml":website}
for accurate data.

{bf:"district edfacts grad-rates"}: This endpoint contains district-level
adjusted cohort graduation rates. The graduation rate is reported as a range,
with the magnitude of the range decreasing as the number of students reported
increases. Graduation rates are provided by race and special populations.

{bf:School} - {browse "https://educationdata.urban.org/documentation/schools.html":Read Complete Documentation}

{bf:"school ccd directory"}: This endpoint contains school-level information on
location, mailing addresses, school types, highest and lowest grades offered,
and free and reduced-price lunch. This endpoint also contains the school-level
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

{bf:"school crdc directory"}: This endpoint contains school-level geographic
information, grades offered, and information on school type (including charter,
magnet, and alternative schools).

{bf:"school crdc enrollment race sex"}: This endpoint contains student enrollment for
each school by students' race and sex. This includes only K–12 students.

{bf:"school crdc enrollment disability sex"}: This endpoint contains student
enrollment for each school by students' disability status and sex. This only
includes students in grades K-12.

{bf:"school crdc enrollment lep sex"}: This endpoint contains student enrollment for
each school by students' Limited English Proficiency status and sex. This only
includes students in grades K-12.

{bf:"school crdc discipline-instances"}: This endpoint contains the number of
discipline in schools

{bf:"school crdc discipline disability sex"}: This endpoint contains student
discipline information for each school, including suspensions, expulsions,
arrests, referrals, and corporal punishment by students' race and sex.

{bf:"school crdc discipline disability race sex"}: This endpoint contains student
discipline information for each school, including suspensions, expulsions,
arrests, referrals, and corporal punishment by students' disability status and
sex.

{bf:"school crdc discipline disability lep sex"}: This endpoint contains student
discipline information for each school, including suspensions, expulsions,
arrests, referrals, and corporal punishment by students' limited English
proficiency status and sex.

{bf:"school crdc harassment-or-bullying allegations"}: This endpoint contains the
number of allegations of harassment or bullying on the basis of sex; on the
basis of race, color, or national origin; or on the basis of disability. This
only includes students in grades K-12 and comparable ungraded levels.

{bf:"school crdc harassment-or-bullying race sex"}: This endpoint contains the number
of students who reported being harassed or bullied and the number of students
who were disciplined for harassment or bullying, by students' race and sex.
These reports and disciplines could be on the basis of sex; on the basis of
race, color, or national origin; or on the basis of disability. This includes
only students in grades K–12 and comparable ungraded levels.

{bf:"school crdc harassment-or-bullying disability sex"}: This endpoint contains the
number of students who reported being harassed or bullied and the number of
students who were disciplined for harassment or bullying, by students'
disability status and sex. These reports and disciplines could be on the basis
of sex, on the basis of race, color, or national origin, or on the basis of
disability. This only includes students in grades K-12 and comparable ungraded
levels.

{bf:"school crdc harassment-or-bullying lep sex"}: This endpoint contains the number
of students who reported being harassed or bullied and the number of students
who were disciplined for harassment or bullying, by students' limited English
proficiency status and sex. These reports and disciplines could be on the basis
of sex, on the basis of race, color, or national origin, or on the basis of
disability. This only includes students in grades K-12 and comparable ungraded
levels.

{bf:"school crdc chronic-absenteeism race sex"}: This endpoint contains the number of
students who were chronically absent, by race and sex. Chronic absenteeism is
defined as being absent 15 or more school days during the school year. A
student is absent if he or she is not physically on school grounds and is not
participating in instruction or instruction-related activities at an approved
off-grounds location for the school day. Chronically absent students include
students who are absent for any reason (e.g., illness, suspension, the need to
care for a family member), regardless of whether absences are excused or
unexcused.

{bf:"school crdc chronic-absenteeism disability sex"}: This endpoint contains the
number of students who were chronically absent, by disability status and sex.
Chronic absenteeism is defined as being absent 15 or more school days during
the school year. A student is absent if he or she is not physically on school
grounds and is not participating in instruction or instruction-related
activities at an approved off-grounds location for the school day. Chronically
absent students include students who are absent for any reason (e.g., illness,
suspension, the need to care for a family member), regardless of whether
absences are excused or unexcused.

{bf:"school crdc chronic-absenteeism lep sex"}: This endpoint contains the number of
students who were chronically absent, by limited English proficiency status and
sex. Chronic absenteeism is defined as being absent 15 or more school days
during the school year. A student is absent if he or she is not physically on
school grounds and is not participating in instruction or instruction-related
activities at an approved off-grounds location for the school day. Chronically
absent students include students who are absent for any reason (e.g., illness,
suspension, the need to care for a family member), regardless of whether
absences are excused or unexcused.

{bf:"school crdc restraint-and-seclusion instances"}: This endpoint contains the
number of instances of restraint or seclusion, by student's disability status.
This includes only students in grades K–12 and comparable ungraded
levels.

{bf:"school crdc restraint-and-seclusion disability sex"}: This endpoint contains the
number of students who were subjected to restraint or seclusion, by disability
status and sex. This includes only students in grades K–12 and comparable
ungraded levels.

{bf:"school crdc restraint-and-seclusion disability race sex"}: This endpoint contains
the number of students who were subjected to restraint or seclusion, by
disability status, race, and sex. This includes only students in grades
K–12 and comparable ungraded levels.

{bf:"school crdc restraint-and-seclusion disability lep sex"}: This endpoint contains
the number of students who were subjected to restraint or seclusion, by
disability status, limited English proficiency status, and sex. This includes
only students in grades K–12 and comparable ungraded levels.

{bf:"school crdc ap-ib-enrollment race sex"}: This endpoint contains the number of
students enrolled in Advanced Placement (AP) courses, the International
Baccalaureate (IB) Diploma Programme, and gifted and talented (GT) programs, by
race and sex.

{bf:"school crdc ap-ib-enrollment disability sex"}: This endpoint contains the number
of students enrolled in Advanced Placement (AP) courses, the International
Baccalaureate (IB) Diploma Programme, and gifted and talented (GT) programs, by
disability and sex.

{bf:"school crdc ap-ib-enrollment lep sex"}: This endpoint contains the number of
students enrolled in Advanced Placement (AP) courses, the International
Baccalaureate (IB) Diploma Programme, and gifted and talented (GT) programs, by
limited English proficiency status and sex.

{bf:"school crdc ap-exams race sex"}: This endpoint contains the number of students
taking AP exams, and the number of students passing AP exams, by students' race
and sex.

{bf:"school crdc ap-exams disability sex"}: This endpoint contains the number of
students taking AP exams, and the number of students passing AP exams, by
students' disability status and sex.

{bf:"school crdc ap-exams lep sex"}: This endpoint contains the number of students
taking AP exams, and the number of students passing AP exams, by students'
Limited English Proficiency status and sex.

{bf:"school crdc sat-act-participation race sex"}: This endpoint contains the number
of students taking the SAT or ACT, by race and sex.

{bf:"school crdc sat-act-participation disability sex"}: This endpoint contains the
number of students taking the SAT or ACT, by disability status and sex.

{bf:"school crdc sat-act-participation lep sex"}: This endpoint contains the number of
students taking the SAT or ACT, by limited English proficiency status and sex.

{bf:"school crdc teachers-staff"}: This endpoint contains data on the number of FTE
teachers and staff at each school.

{bf:"school crdc math-and-science race sex"}: This endpoint contains data on
enrollment in Biology, Chemistry, Advanced Math, Calculus, Algebra II, Physics,
and Geometry courses by race and sex.

{bf:"school crdc math-and-science disability sex"}: This endpoint contains data on
enrollment in Biology, Chemistry, Advanced Math, Calculus, Algebra II, Physics,
and Geometry courses by disability and sex.

{bf:"school crdc math-and-science lep sex"}: This endpoint contains data on enrollment
in Biology, Chemistry, Advanced Math, Calculus, Algebra II, Physics, and
Geometry courses by limited English proficiency status and sex.

{bf:"school crdc algebra1 race sex"}: This endpoint contains data on the number of
students enrolled in and passing Algebra I by race and sex.

{bf:"school crdc algebra1 disability sex"}: This endpoint contains data on the number
of students enrolled in and passing Algebra I by disability status and sex.

{bf:"school crdc algebra1 lep sex"}: This endpoint contains data on the number of
students enrolled in and passing Algebra I by Limited English Proficiency
status and sex.

{bf:"school crdc offenses"}: This endpoint contains data on the number of criminal
incidents in schools.

{bf:"school crdc dual-enrollment race sex"}: This endpoint contains data that
indicates whether the school has any students enrolled in a dual
enrollment/dual credit program by race and sex.

{bf:"school crdc dual-enrollment disability sex"}: This endpoint contains data that
indicates whether the school has any students enrolled in a dual
enrollment/dual credit program by disability and sex.

{bf:"school crdc dual-enrollment lep sex"}: This endpoint contains data that indicates
whether the school has any students enrolled in a dual enrollment/dual credit
program by limited English proficiency status and sex.

{bf:"school crdc credit-recovery"}: This endpoint contains data on student enrollment
in credit recovery.

{bf:"school crdc suspensions-days race sex"}: This endpoint contains the number of
days students missed due to suspensions by race and sex.

{bf:"school crdc suspensions-days disability sex"}: This endpoint contains the number
of days students missed due to suspensions by disability and sex.

{bf:"school crdc suspensions-days lep sex"}: This endpoint contains the number of days
students missed due to suspensions by limited English proficiency status and
sex.

{bf:"school crdc offerings"}: This endpoint contains details on the number and types
of classes offered in schools.

{bf:"school crdc school-finance"}: This endpoint contains school finance data.

{bf:"school crdc retention race sex"}: This endpoint contains data on the number of
students retained in a school.

{bf:"school crdc retention disability sex"}: This endpoint contains data on the number
of students retained in a school.

{bf:"school crdc retention lep sex"}: This endpoint contains data on the number of
students retained in a school.

{bf:"school edfacts assessments"}: This endpoint contains school-level achievement
results for state assessments in mathematics and reading or language arts, by
grade. It includes the number of students who completed each assessment for
whom a proficiency level was assigned and the proficiency share. The
proficiency share is reported as a range, unless there are more than 300
students in the subgroup, with the magnitude of the range decreasing as the
number of students reported increases. States can change their statewide
assessments, academic standards, or thresholds for proficiency levels, leading
to changes in the proficiency share from year to year. The proficiency shares
for Virginia's 2016–17 grade 5–8 math assessments are too low.
Users should instead refer to the Virginia Department of Education's Statistics
and Reports {browse "http://www.doe.virginia.gov/statistics_reports/index.shtml":website}
for accurate data.

{bf:"school edfacts assessments race"}: This endpoint contains school-level
achievement results for state assessments in mathematics and reading or
language arts, by grade and race or ethnicity. It includes the number of
students who completed each assessment for whom a proficiency level was
assigned and the proficiency share. The proficiency share is reported as a
range, unless there are more than 300 students in the subgroup, with the
magnitude of the range decreasing as the number of students reported increases.
States can change their statewide assessments, academic standards, or
thresholds for proficiency levels, leading to changes in the proficiency share
from year to year. The proficiency shares for Virginia's 2016–17 grade
5–8 math assessments are too low. Users should instead refer to the
Virginia Department of Education's Statistics and Reports {browse "http://www.doe.virginia.gov/statistics_reports/index.shtml":website}
for accurate data.

{bf:"school edfacts assessments sex"}: This endpoint contains school-level achievement
results for state assessments in mathematics and reading or language arts, by
grade and sex. It includes the number of students who completed each assessment
for whom a proficiency level was assigned and the proficiency share. The
proficiency share is reported as a range, unless there are more than 300
students in the subgroup, with the magnitude of the range decreasing as the
number of students reported increases. States can change their statewide
assessments, academic standards, or thresholds for proficiency levels, leading
to changes in the proficiency share from year to year. The proficiency shares
for Virginia's 2016–17 grade 5–8 math assessments are too low.
Users should instead refer to the Virginia Department of Education's Statistics
and Reports {browse "http://www.doe.virginia.gov/statistics_reports/index.shtml":website}
for accurate data.

{bf:"school edfacts assessments special-populations"}: This endpoint contains
school-level achievement results for state assessments in mathematics and
reading or language arts, by grade and special population subgroups. It
includes the number of students who completed each assessment for whom a
proficiency level was assigned and the proficiency share. The proficiency share
is reported as a range, unless there are more than 300 students in the
subgroup, with the magnitude of the range decreasing as the number of students
reported increases. Special population subgroups include children with one or
more disabilities, economically disadvantaged students, students who are
homeless, migrant students, and students with limited English proficiency.
Beginning in 2017, special population subgroups also include students who are
in foster care and students who are military connected. States can change their
statewide assessments, academic standards, or thresholds for proficiency
levels, leading to changes in the proficiency share from year to year. The
proficiency shares for Virginia's 2016–17 grade 5–8 math
assessments are too low. Users should instead refer to the Virginia Department
of Education's Statistics and Reports {browse "http://www.doe.virginia.gov/statistics_reports/index.shtml":website}
for accurate data.

{bf:"school edfacts grad-rates"}: This endpoint contains school-level adjusted cohort
graduation rates. The graduation rate is reported as a range, with the
magnitude of the range decreasing as the number of students reported increases.
Graduation rates are provided by race and special populations.

{bf:"school nhgis census-2010"}: This endpoint contains geographic variables
corresponding to 2010 Census geographies for each school in the CCD directory.
Geographies are merged on by latitude and longitude when available; when
unavailable, latitudes and longitudes were obtained from address information
using Urban's geocoder. The geocoder uses StreetMap Premium from Esri to
perform accurate offline geocoding. Geocode accuracy variables indicate the
degree of precision of this geocoding. Additional information on the match
accuracy can be found {browse "https://developers.arcgis.com/rest/geocode/api-reference/geocoding-service-output.htm":here}.
Geographies for older years of data or low-accuracy geocode matches should be
used with caution. In addition, we link schoolsâ€™ geographic locations to the
geographic boundaries of school districts.

{bf:"school nhgis census-2000"}: This endpoint contains geographic variables
corresponding to 2000 Census geographies for each school in the CCD directory.
Geographies are merged on by latitude and longitude when available; when
unavailable, latitudes and longitudes were obtained from address information
using Urban's geocoder. The geocoder uses StreetMap Premium from Esri to
perform accurate offline geocoding. Geocode accuracy variables indicate the
degree of precision of this geocoding. Additional information on the match
accuracy can be found {browse "https://developers.arcgis.com/rest/geocode/api-reference/geocoding-service-output.htm":here}.
Geographies for older years of data or low-accuracy geocode matches should be
used with caution. In addition, we link schoolsâ€™ geographic locations to the
geographic boundaries of school districts.

{bf:"school nhgis census-1990"}: This endpoint contains geographic variables
corresponding to 1990 Census geographies for each school in the CCD directory.
Geographies are merged on by latitude and longitude when available; when
unavailable, latitudes and longitudes were obtained from address information
using Urban's geocoder. The geocoder uses StreetMap Premium from Esri to
perform accurate offline geocoding. Geocode accuracy variables indicate the
degree of precision of this geocoding. Additional information on the match
accuracy can be found {browse "https://developers.arcgis.com/rest/geocode/api-reference/geocoding-service-output.htm":here}.
Geographies for older years of data or low-accuracy geocode matches should be
used with caution. In addition, we link schoolsâ€™ geographic locations to the
geographic boundaries of school districts.



{marker options}{...}
{title:Command Options}

The {bf:educationdata {opt csv}} option allows you to request CSV files instead of 
downloading data from the API directly. This is particularly useful in saving you time 
when you wish to download a large extract. Note that this option requires you
to have read and write privileges to the current working directory. If you do not have 
these priveleges, change to a working directory where you do. For example,

. cd D:/Users/[your username here]/Documents

The {bf:educationdata} command takes two options for only collecting a subset
of the dataset you request:

1. {bf:{opt sub:set(str)}}: Specifies a single subset or list of subsets of the dataset
along as many valid variables as the dataset contains. Multiple subset variables must be 
separated by a space (e.g., sub(variable1=value1 variable2=value2)), and multiple
subset values for a variable must either take the form of a continuous list separated
by a colon, or a list of values separated by a comma. Note that there can be no spaces
between the variable, the equals sign, and the value (e.g., sub(variable1=value1), not
sub(variable1 = value1)).

To be concrete, while not a complete list of options, subset conditions may take the 
form of sub(variable1=value1), sub(variable1=value1,value2), 
sub(variable1=value1:value5), sub(variable1=value1 variable2=value1,value4,value5,value6),
or sub(variable1=value4:value6 variable2=value1,value2), to name a few. Lists 
separated by a colon and a comma in a single variable are {bf:not supported}. For 
example, sub(variable1=value1:value3,value5) is {bf:not allowed}. 

To be even more concrete, valid values might include sub(year=2011), 
sub(year=2010:2015), sub(year=2012:2016 fips=12), etc. if year and fips were 
valid variables in the dataset specified after the "using" statement.

For {bf:grade}, the options include "pk", "k", 1 through 12, 13, 14 (adult education),
15, (ungraded), and 99 (total).

Optionally, you may substitute "-1" for "pk" and "0" for "k".

For {bf:level_of_study}, the options include "undergraduate","graduate",
"first-professional", "post-baccalaureate", and 99 (total).

All variables follow a similar pattern to {bf:level_of_study}. {bf:In general}, the code 
99 indicates all categories combined, or "totals only". For example, race=99 or sex=99 
indicates all races or all genders, while grade=99 indicates total for all grades. 
Using the 99 filter can save time for those who only wish to request totals, and don't 
need by race, by grade, or by gender breakdowns.

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

The {bf:{opt cache}} is for situations in which the data have been updated recently
on the portal, but you are still seeing the older data when you make a call. Typically,
the technical team will clear the cache on the server, so this will not be an issue. We
provide this option in case you are still seeing old data but think you should be seeing
new data. We do not recommend using this option in any other case, as it will lead to 
slower data download times.

. educationdata using "college ipeds directory", cache

{bf:The {opt clear}} option clears existing datasets from memory before
reading in the data from the Education Data Portal. For example,

. educationdata using "college ipeds directory", clear

{bf:And finally the {opt summaries}} option provides statistical summaries of a dataset using 
user-defined summary statistics and variables. The arguments are structured as 
"summaries ([statistic method] [variable of interest] by [grouping variable])", where 
the first argument indicates the summary statistic to be retrieved. Valid statistics include: 
"avg", "sum", "count", "median", "min", "max", "stddev", and "variance". The second argument is 
the variable to run the summary statistic on, and the third indicates the grouping variable to use. 
If there are multiple grouping variables, please separate them by one whitespace. 
For example, 

. educationdata using "school ccd enrollment", summaries(sum enrollment by fips race) sub(year=2000) 

This command takes the "schools/ccd/enrollment" endpoint, retrieves the sum of school enrollment 
by fips code, and filters to year 2000. 

More detailed instructions can be found in {browse "https://educationdata.urban.org/documentation":Education Data Portal Documentation}. 


{title:Installing package dependencies}

The SSC package {bf:libjson} is required to use the {bf:educationdata}
package. If you do not have {bf:libjson} installed, it will be installed automatically
after first running the {bf:educationdata} command. Or, before running the package,
you can install {bf:libjson} by running the following command:

    . ssc install libjson 
        
{title:Author}

Graham MacDonald 
Office of Data Science and Technology  
Urban Institute   
