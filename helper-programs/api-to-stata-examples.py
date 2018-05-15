import requests
import json
import re
import pandas as pd

# Python program to convert API endpoint to Stata help document
f = 'J:/API/Endpoints/ed-data-content-model.xlsx'
d = pd.read_excel(f, 'api_endpoints')
a = d.T.to_dict().values()
keep_str = []

# Translate from long name to short name
translate = {"college-university":"college", "schools":"school", "school-districts":"district"}

for i in a:
	res_str = ""
	ex_str = ""
	ep = i["endpoint_url"].replace('/api/v1/','').split('/')
	ex = i["example_endpoint_url"].replace('/api/v1/','').split('/')
	for j in range(len(ep)):
		if len(ep[j]) > 0:
			if ep[j][0] != '{':
				res_str = res_str + " " + ep[j]
			else:
				if len(ex_str) < 1: ex_str += ep[j].replace('{','').replace('}','') + "=" + ex[j].replace('grade-','')
				else: ex_str += " " + ep[j].replace('{','').replace('}','') + "=" + ex[j].replace('grade-','')
	res_str = res_str[1:]
	rsplit = res_str.split()
	term = translate[rsplit[0]]
	for j in range(1,len(rsplit)):
		term += " " + rsplit[j]
	keep_str.append({"endpoint_id":i["endpoint_id"],"stata_code":"educationdata using \\\"{}\\\", sub({})".format(term, ex_str)})

data = pd.DataFrame(keep_str)
data.sort_values("endpoint_id").to_csv("stata_code_example.csv", index = False)