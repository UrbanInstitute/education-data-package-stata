import requests
import json
import re

# Python program to convert API endpoint to Stata help document
url = 'https://ed-data-portal.urban.org/api/v1/api-endpoints/'
res = requests.get(url).text
data = json.loads(res)
keep_str = ""

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
			cur_line = ""
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
	keep_str = keep_str + '{bf:"' + res_str + '"}: ' + i["description"] + '\n'

with open('sthlp_table.txt', 'w') as f:
	f.write(keep_str)