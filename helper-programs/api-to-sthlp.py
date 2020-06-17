import requests
import json
import re
from operator import itemgetter

# Python program to convert API endpoint to Stata help document
url = 'https://educationdata-stg.urban.org/api/v1/api-endpoints/'
res = requests.get(url).text
data = json.loads(res)
keep_str = []

# Temporarily hide endpoints
hide = ["college-university ipeds academic-charges-professional","college-university ipeds academic-charges-general","college-university ipeds program-year-charges","college-university ipeds program-year-charges-cip","college-university ipeds student-financial-aid"]

# Translate from long name to short name
translate = {"college-university":"college", "schools":"school", "school-districts":"district"}

# Break description up for Stata to read
def break_desc(t1, t2):
	max_len = 80
	lineone = len(t1)
	temp_str = ""
	tsplit = re.sub(' +', ' ', t2)
	tsplit = tsplit.split()
	cur_line = " " + t1
	for t in tsplit:
		test_str = cur_line + " " + t
		if len(test_str) > max_len:
			temp_str = temp_str + cur_line[1:] + '\n'
			cur_line = " " + t
		else:
			cur_line = cur_line + " " + t
	temp_str = temp_str + cur_line[1:] + '\n'
	return temp_str.replace(t1 + " ", '')

for i in data["results"]:
	res_str = ""
	ep = i["endpoint_url"].replace('/api/v1/','').split('/')
	for j in ep:
		if len(j) > 0:
			if j[0] != '{':
				res_str = res_str + " " + j
	res_str = res_str[1:]
	if i["description"] == "": i["description"] = "No description at this time."
	i["description"] = break_desc(res_str,i["description"])
	rsplit = res_str.split()
	term = translate[rsplit[0]]
	for j in range(1,len(rsplit)):
		term += " " + rsplit[j]
	if res_str not in hide and i["hide"] == 0:
		keep_str.append(['{bf:"' + term + '"}: ' + i["description"] + '\n'.replace('\n\n\n','\n\n').replace('\n\n\n','\n\n'),res_str.split()[0],int(i["order"])])

# To do - sort and convert to string, and convert long names to short
keep_str = sorted(keep_str, key=itemgetter(1,2))
prev_cat = ""
perm_str = ""
sover = 0
dsname = {"college":"colleges","district":"school-districts","school":"schools"}
for i in range(len(keep_str)):
	if keep_str[i][1] != prev_cat: 
		sover = 0
		prev_cat = keep_str[i][1]
	if sover == 0: 
		perm_str += '{bf:' + translate[keep_str[i][1]].title() + '} - {browse "https://educationdata.urban.org/documentation/' + dsname[translate[keep_str[i][1]]] + '.html":Read Complete Documentation}\n\n'
		sover = 1
	perm_str += keep_str[i][0]

# replace url from HTML to STATA helper function language 
urls = {"https://developers.arcgis.com/rest/geocode/api-reference/geocoding-service-output.htm": "here", 
		"https://www.urban.org/research/publication/ipeds-finance-user-guide": "here", 
		"http://www.doe.virginia.gov/statistics_reports/index.shtml": "website"} 

for url in urls:
	url_html = fr'<a\s+href="{url}">{urls[url]}</a>'
	url_sthlp = f'{{browse "{url}":{urls[url]}}}'
	perm_str = re.sub(url_html, url_sthlp, perm_str)

if 'href' in perm_str:
	raise ValueError('Please fix the HTML URLs in the text.')

with open('sthlp_table.txt', 'w') as f:
	f.write(perm_str)