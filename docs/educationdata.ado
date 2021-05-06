program educationdata
version 11.0
mata: if (findfile("libjson.mlib") != "") {} else stata("ssc install libjson");
mata: if (libjson::checkVersion((1,0,2))) {} else printf("{err: The JSON library version is not compatible with this command and so will likely fail. Please update libjson by running the following: ado uninstall libjson, then run: ssc install libjson}\n");
syntax using/ , [SUBset(string)] [COLumns(string)] [SUMMARIES(string)] [CLEAR] [METAdata] [STAGING] [CSV] [CACHE] [DEBUG]
mata: 	dummy=getalldata("`using'", "`columns'", "`subset'", "`summaries'", strlen("`clear'"),strlen("`metadata'"),strlen("`staging'"),strlen("`csv'"),strlen("`cache'"),strlen("`debug'"));
end

mata

	// Beginning section above and some structure borrowed from insheetjson - thanks!;
	// Helper function that returns results node
	pointer (class libjson scalar) scalar getresults(string scalar url){
		pointer (class libjson scalar) scalar root
		pointer (class libjson scalar) scalar result
		if (st_global("debug_ind") == "1") printf(urlmode(url) + "\n")
		root = libjson::webcall(urlmode(url) ,"");
		result = root->getNode("results")
		return(result)
	}

	// Helper function that returns matrix of variable information from API
	string matrix getvarinfo(string scalar url){
		pointer (class libjson scalar) scalar res
		pointer (class libjson scalar) scalar trow
		pointer (class libjson scalar) scalar result
		string scalar tempvar
		string scalar tempind
		real scalar numrows
		real scalar numrowscheck
		res = getresults(url)
		numrows = res->arrayLength()
		if (numrows == 0){
			temp = raise_error()
			return("")
		}
		varinfo = J(6,numrows,"")
		for (r=1; r<=numrows; r++) {
			trow = res->getArrayValue(r)
			varinfo[1,r] = trow->getString("variable", "")
			varinfo[2,r] = trow->getString("label", "")
			tempvar = trow->getString("data_type", "")
			if (tempvar == "integer" || tempvar == "float") varinfo[3,r] = "double"
			else if (tempvar == "string"){
				varinfo[3,r] = "str" + trow->getString("string_length", "")
			}
			varinfo[5,r] = trow->getString("format", "")
			if (varinfo[5,r] != varinfo[1,r] && varinfo[5,r] != "string" && varinfo[5,r] != "numeric"){
				result = getresults(st_global("base_url") + "/api/v1/api-values/?format_name=" + varinfo[5,r])	
			}
			else result = getresults(st_global("base_url") + "/api/v1/api-values/?format_name=" + varinfo[1,r])
			numrowscheck = result->arrayLength()
			if (numrowscheck == 0) varinfo[4,r] = "0"
			else varinfo[4,r] = "1"
			varinfo[6,r] = trow->getString("is_filter", "")
		}
		return(varinfo)		
	}


	// Parse metadata to get api endpoint strings, years, and required selectors from enpoint URL
	string matrix endpointstrings(){
		pointer (class libjson scalar) scalar res1
		pointer (class libjson scalar) scalar trow
		string matrix endpointdata
		res1 = getresults(st_global("base_url") + "/api/v1/api-endpoints/")
		numrows = res1->arrayLength()
		endpointdata = J(3,numrows,"")
		for (r=1; r<=numrows; r++){
			trow = res1->getArrayValue(r)
			endpointdata[1,r] = trow->getString("endpoint_id", "")
			endpointdata[2,r] = trow->getString("endpoint_url", "")
			endpointdata[3,r] = trow->getString("years_available", "")
		}
		return(endpointdata)
	}
	
	// Helper function to parse url endpoint strings into required variables
	string rowvector parseurls(string scalar url, string scalar typevar){
		string rowvector splits
		string scalar splitr
		string scalar keepvars
		real scalar stopme
		url = subinstr(url, "/api/v1/", "")
		t = tokeninit("/")
		s = tokenset(t, url)
		splits = tokengetall(t)
		keepvars = ""
		if (typevar == "optional"){
			for (r=1; r<=length(splits); r++){
				splitr = subinstr(subinstr(splits[r], "{", ""), "}", "")
				if (splitr != splits[r]){
					if (keepvars == "") keepvars = keepvars + splitr
					else keepvars = keepvars + "," + splitr
				}
			}
		}
		else{
			for (r=1; r<=length(splits); r++){
				splitr = subinstr(subinstr(splits[r], "{", ""), "}", "")
				if (splitr == splits[r]){
					if (keepvars == "") keepvars = keepvars + splits[r]
					else keepvars = keepvars + "," + splits[r]
				}
			}
		}
		t = tokeninit(",")
		s = tokenset(t, keepvars)
		return(tokengetall(t))
	}
	
	// Helper function to parse required data as inputs, check validity, and return endpoint chosen
	real scalar validendpoints(string scalar eps){
		string matrix endpoints
		string rowvector epsind
		string rowvector parsedurls
		real scalar check
		real scalar permcheck
		endpoints = endpointstrings()
		epsind = tokens(eps)
		permcheck = 0
		for (c=1; c<=length(endpoints[2,.]); c++){
			parsedurls = parseurls(endpoints[2,c], "required")
			if (length(parsedurls) == length(epsind)){
				check = 1
				for (r=1; r<=length(epsind); r++){
					if (epsind[r] == parsedurls[r]) check = check * 1
					else check = check * 0
				}
				if (check == 1) permcheck = c
			}
		}
		return(permcheck)
	}
	
	// Helper function to parse years available for endpoint
	string rowvector parseyears(real scalar matid){
		string matrix endpoints
		string rowvector getit
		string rowvector getit2
		string rowvector returnyears
		string scalar yrs
		string scalar yrstring
		string scalar yrstring2
		endpoints = endpointstrings()
		yrs = endpoints[3,matid]
		if (subinstr(subinstr(yrs, ",", ""), "&ndash;", "") == yrs){
			returnyears = (yrs)
		}
		else if (subinstr(yrs, "and", "") != yrs){
			yrs = subinstr(subinstr(yrs, " ", ""), "and", "")
			t = tokeninit(",")
			s = tokenset(t, yrs)
			getit = tokengetall(t)
			yrstring = subinstr(yrs, "," + getit[length(getit)], "")
			t = tokeninit("&ndash;")
			s = tokenset(t, getit[length(getit)])
			getit = tokengetall(t)
			for (y=strtoreal(getit[1]); y<=strtoreal(getit[2]); y++){
				yrstring = yrstring + "," + strofreal(y)
			}
			t = tokeninit(",")
			s = tokenset(t, yrstring)
			returnyears = tokengetall(t)
		}
		else if (subinstr(yrs, ",", "") != yrs){
			t = tokeninit(", ")
			s = tokenset(t, yrs)
			getit = tokengetall(t)
			yrstring = ""
			for (c=1; c<=length(getit); c++){
				if (subinstr(getit[c], "&ndash;", "") != getit[c]){
					t = tokeninit("&ndash;")
					s = tokenset(t, getit[c])
					getit2 = tokengetall(t)
					if (c == 1) yrstring = getit2[c]
					else yrstring = yrstring + "," + getit2[1]
					for (y=strtoreal(getit2[1])+1; y<=strtoreal(getit2[2]); y++){
						yrstring = yrstring + "," + strofreal(y)
					}				
				}
				else{
					if (c == 1) yrstring = getit[c]
					else yrstring = yrstring + "," + getit[c]
				}
			}	
			t = tokeninit(",")
			s = tokenset(t, yrstring)
			returnyears = tokengetall(t)		
		}
		else {
			t = tokeninit("&ndash;")
			s = tokenset(t, yrs)
			getit = tokengetall(t)
			yrstring = getit[1]
			for (y=strtoreal(getit[1])+1; y<=strtoreal(getit[2]); y++){
				yrstring = yrstring + "," + strofreal(y)
			}
			t = tokeninit(",")
			s = tokenset(t, yrstring)
			returnyears = tokengetall(t)
		}
		return(returnyears)
	}
	
	// Helper function to validate a single option against the list of valid options
	real scalar isvalid(string scalar test, string rowvector vopts){
		real scalar isopt
		isopt = 0
		for (c = 1; c<=length(vopts); c++){
			if (vopts[c] == test) return(1)
		}
		return(0)
	}
	
	// Helper function to get the position of a string in a list
	real scalar stringpos(string scalar test, string rowvector tlist){
		for (r = 1; r<=length(tlist); r++){
			if (test == tlist[r]) return(r)
		}
		return(0)
	}

	// Helper function to check if item is in a list
	real scalar iteminlist(string scalar i, string rowvector tlist){
		real scalar isinlist
		isinlist = 0
		for (r=1; r<=length(tlist); r++){
			if (i == tlist[r]) isinlist = 1
		}
		return(isinlist)
	}

	// Helper function to check number of item in list
	real scalar iteminlistnum(string scalar i, string rowvector tlist){
		real scalar isinlist
		isinlist = 0
		for (r=1; r<=length(tlist); r++){
			if (i == tlist[r]) isinlist = r
		}
		return(isinlist)
	}

	// Helper function to add mode logging to URLs for API tracking
	string scalar urlmode(string scalar url3){
		string scalar strnum
		if (strpos(url3, "mode=stata") == 0){
			if (subinstr(url3, "?", "") == url3) url3 = url3 + "?mode=stata"
			else url3 = url3 + "&mode=stata"
		}
		strnum = strofreal(round(runiform(1,1)*100000))
		if (st_global("cc") == "1") url3 = url3 + "&a=" + strnum
		return(url3)
	}

	// Helper function to validate against list
	string rowvector checkinglist(string rowvector alist, string scalar tocheck, string rowvector yearlist){
		string rowvector tochecklist
		string rowvector toaddlist
		string rowvector validlist
		string scalar returnlist
		if (tocheck == "grade") { 
			tochecklist = ("grade-pk","grade-k","grade-1","grade-2","grade-3","grade-4","grade-5","grade-6","grade-7","grade-8","grade-9","grade-10","grade-11","grade-12","grade-13","grade-14","grade-15","grade-99","grade-999")
			toaddlist = ("pk","k","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","99","999")
		}
		else if (tocheck == "grade_edfacts") {
			tochecklist = ("grade-3","grade-4","grade-5","grade-6","grade-7","grade-8","grade-9","grade-99")
			toaddlist = ("3","4","5","6","7","8","9","99")
		}
		else if (tocheck == "level_of_study") tochecklist = ("undergraduate","graduate","first-professional","post-baccalaureate","1","2","3","4")
		else if (tocheck == "fed_aid_type") tochecklist = ("fed","sub-stafford","no-pell-stafford","1","2","3")
		else if (tocheck == "year") tochecklist = yearlist
		else return(alist)
		for (c=1; c<=length(alist); c++){
			if (iteminlist(alist[c],tochecklist) == 0) {
				if ((tocheck == "grade" || tocheck == "grade_edfacts") && (alist[c] == "-1" || alist[c] == "0")){
					if (alist[c] == "-1") alist[c] = "grade-pk"
					else alist[c] = "grade-k"
				}
				else if ((tocheck != "grade" && tocheck != "grade_edfacts") || iteminlist(alist[c],toaddlist) == 0){
					if (tocheck == "grade" || tocheck == "grade_edfacts") validlist = toaddlist
					else validlist = tochecklist
					for (r=1; r<=length(validlist); r++){
						if (r == 1) returnlist = validlist[r]
						else returnlist = returnlist + ", " + validlist[r]
					}
					return(("Error",alist[c],returnlist))	
				} 
				else alist[c] = "grade-" + alist[c]
			}
		}
		return(alist)
	}
	
	// Helper function to parse optional data as inputs, taking a single optional data argument, check validity, and return all chosen options
	string rowvector validoptions(string scalar subset1, real scalar epid){
		string matrix endpoints
		string rowvector grades
		string rowvector levels
		string rowvector fedaids
		string rowvector vopts
		string rowvector getit
		string rowvector tlev
		string rowvector years
		string rowvector checklist
		string scalar getstring
		string scalar tempadd
		string scalar keepg1
		real scalar isopt1
		real scalar spos1
		real scalar spos2
		real scalar isgrade
		endpoints = endpointstrings()
		t = tokeninit("=")
		s = tokenset(t, subset1)
		getit = tokengetall(t)
		vopts = parseurls(endpoints[2,epid], "optional")
		isopt1 = isvalid(getit[1], vopts)
		if (isopt1 == 1){
			grades = ("pk","k","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","99","999")
			grades_alt = ("-1","0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","99","999")
			gradesed = ("3","4","5","6","7","8","9","99")
			gradesed_alt = ("3","4","5","6","7","8","9","99")
			levels = ("undergraduate","graduate","first-professional","post-baccalaureate")
			fedaids = ("fed","sub-stafford","no-pell-stafford")
			if (getit[1] == "year") years = parseyears(epid)
			else years = ("fake","data")
			if (getit[2] != "alldata"){
				if (subinstr(subinstr(getit[2], ",", ""), ":", "") == getit[2]){
					checklist = checkinglist((getit[2]), getit[1], years)
					if (checklist[1] == "Error") return(("Invalid Option: " + checklist[2] + " in " + getit[1] + "\nValid options are: " + checklist[3], ""))
					else return(checklist)
				}
				else if (subinstr(getit[2], ",", "") != getit[2]){
					t = tokeninit(",")
					s = tokenset(t, getit[2])
					checklist = checkinglist(tokengetall(t), getit[1], years)
					if (checklist[1] == "Error") return(("Invalid Option: " + checklist[2] + " in " + getit[1] + "\nValid options are: " + checklist[3], ""))
					else return(checklist)	
				}
				else{
					tempadd = ""
					isgrade = 0
					if (getit[1] == "year") tlev = years
					else if (getit[1] == "grade"){
						tlev = grades
						tempadd = "grade-"
						isgrade = 1
					}
					else if (getit[1] == "grade_edfacts"){
						tlev = gradesed
						tempadd = "grade-"
						isgrade = 2				
					}
					else if (getit[1] == "level_of_study") tlev = levels
					else if (getit[1] == "fed_aid_type") tlev = fedaids
					keepg1 = getit[1]
					t = tokeninit(":")
					s = tokenset(t, getit[2])
					getit = tokengetall(t)
					if (isvalid(getit[1], tlev) == 1 && isvalid(getit[2], tlev) == 1){
						spos1 = stringpos(getit[1], tlev)
						spos2 = stringpos(getit[2], tlev)
						getstring = tempadd + tlev[spos1]
						for (c=spos1 + 1; c<=spos2; c++){
							getstring = getstring + "," + tempadd + tlev[c]
						}
						t = tokeninit(",")
						s = tokenset(t, getstring)
						checklist = checkinglist(tokengetall(t), getit[1], years)
						if (checklist[1] == "Error") return(("Invalid Option: " + checklist[2] + " in " + getit[1] + "\nValid options are: " + checklist[3], ""))
						else return(checklist)	
					}
					else if (isgrade == 1 && (isvalid(getit[1], grades_alt) == 1 && isvalid(getit[2], grades_alt) == 1)){
						spos1 = stringpos(getit[1], grades_alt)
						spos2 = stringpos(getit[2], grades_alt)
						getstring = tempadd + tlev[spos1]
						for (c=spos1 + 1; c<=spos2; c++){
							getstring = getstring + "," + tempadd + tlev[c]
						}
						t = tokeninit(",")
						s = tokenset(t, getstring)
						checklist = checkinglist(tokengetall(t), getit[1], years)
						if (checklist[1] == "Error") return(("Invalid Option: " + checklist[2] + " in " + getit[1] + "\nValid options are: " + checklist[3], ""))
						else return(checklist)	
					}
					else if (isgrade == 2 && (isvalid(getit[1], gradesed_alt) == 1 && isvalid(getit[2], gradesed_alt) == 1)){
						spos1 = stringpos(getit[1], gradesed_alt)
						spos2 = stringpos(getit[2], gradesed_alt)
						getstring = tempadd + tlev[spos1]
						for (c=spos1 + 1; c<=spos2; c++){
							getstring = getstring + "," + tempadd + tlev[c]
						}
						t = tokeninit(",")
						s = tokenset(t, getstring)
						checklist = checkinglist(tokengetall(t), getit[1], years)
						if (checklist[1] == "Error") return(("Invalid Option: " + checklist[2] + " in " + getit[1] + "\nValid options are: " + checklist[3], ""))
						else return(checklist)	
					}
					else {
						if (isvalid(getit[1], tlev) == 0){
							checklist = checkinglist((getit[1]),keepg1, years)
							return(("Invalid Option selection: " + getit[1] + " in " + keepg1 + "\nValid options are: " + checklist[3], ""))
						}
						else{
							checklist = checkinglist((getit[2]),keepg1, years)
							return(("Invalid Option selection: " + getit[2] + " in " + keepg1 + "\nValid options are: " + checklist[3], ""))
						}
					}
				}
			}
			else{
				tempadd = ""
				if (getit[1] == "year") tlev = years
				else if (getit[1] == "grade"){
					tlev = grades
					tempadd = "grade-"
				}
				else if (getit[1] == "grade_edfacts"){
					tlev = gradesed
					tempadd = "grade-"
				}
				else if (getit[1] == "level_of_study") tlev = levels
				else if (getit[1] == "fed_aid_type") tlev = fedaids	
				getstring = tempadd + tlev[1]
				for (c=2; c<=length(tlev); c++){
					getstring = getstring + "," + tempadd + tlev[c]
				}
				t = tokeninit(",")
				s = tokenset(t, getstring)
				return(tokengetall(t))		
			}
		}
		else return(("Invalid Option: " + getit[1]))
	}

	// Helper function that returns string and real/integer variable names
	string rowvector getvartypes(string scalar typ, string matrix varinfo){
		real scalar counting
		real scalar counter1
		string scalar varnametypes
		real scalar numvars
		numvars = length(varinfo[1,.])
		counting = 0
		for (c=1; c<=numvars; c++){
			if (subinstr(varinfo[3,c], "str", "") != varinfo[3,c]){
				if (typ == "string") counting = counting + 1
			}
			else {
				if (typ != "string") counting = counting + 1
			}
		}
		varnametypes = J(1,counting,"")
		counter1 = 1
		for (c=1; c<=numvars; c++){
			if (subinstr(varinfo[3,c], "str", "") != varinfo[3,c]){
				if (typ == "string") {
					varnametypes[1,counter1] = varinfo[1,c]
					counter1 = counter1 + 1
				}
			}
			else {
				if (typ != "string") {
					varnametypes[1,counter1] = varinfo[1,c]
					counter1 = counter1 + 1
				}
			}
		}
		return(varnametypes)
	}

	// Helper function to get variable value definitions
	string matrix getvardefs(string scalar var1, string scalar format1){
		pointer (class libjson scalar) scalar result
		pointer (class libjson scalar) scalar trow
		string matrix vardefs
		string rowvector tokenstemp
		string scalar tempvar
		string scalar tempstring
		real scalar numrows
		real scalar startvar
		if (format1 != var1 && format1 != "string" && format1 != "numeric"){
			result = getresults(st_global("base_url") + "/api/v1/api-values/?format_name=" + format1)	
		}
		else result = getresults(st_global("base_url") + "/api/v1/api-values/?format_name=" + var1)
		numrows = result->arrayLength()
		vardefs = J(2,numrows,"")
		for (r=1; r<=numrows; r++){
			trow = result->getArrayValue(r)
			vardefs[1,r] = trow->getString("code", "")
			tempvar = trow->getString("code_label", "")
			tokenstemp = tokens(tempvar, "-")
			if (tokenstemp[1] == "-") startvar = 4
			else startvar = 3
			tempstring = ""
			for (i=startvar; i<=length(tokenstemp); i++){
				tempstring = tempstring + tokenstemp[i]
				if (i != length(tokenstemp)) tempstring = tempstring + " "
			}
			vardefs[2,r] = subinstr(tempstring, "&ndash;", "–")
			vardefs[2,r] = subinstr(vardefs[2,r], "&mdash;", "—")
			vardefs[2,r] = subinstr(vardefs[2,r], " - ", "-")
			vardefs[2,r] = subinstr(vardefs[2,r], " – ", "–")
			vardefs[2,r] = subinstr(vardefs[2,r], " — ", "—")
		}
		return(vardefs)
	}

	// Get table just gets data we need for one table, this appends results to the stata dataset
	string scalar gettable(string scalar url, real scalar startpos, string matrix varinfo){
		pointer (class libjson scalar) scalar root
		pointer (class libjson scalar) scalar result
		pointer (class libjson scalar) scalar trow
		string matrix sdata
		string rowvector varnames
		string scalar nextpage
		string scalar tval
		real matrix rdata
		real scalar numrows
		real scalar endpos
		if (st_global("debug_ind") == "1") printf(urlmode(url) + "\n")
		root = libjson::webcall(urlmode(url) ,"");
		result = root->getNode("results")
		numrows = result->arrayLength()
		varinfotemp = J(6,length(varinfo[1,.]),"")
		for (c=1; c<=length(varinfo[1,.]); c++){
			varinfotemp[1,c] = strlower(varinfo[1,c])
			varinfotemp[3,c] = varinfo[3,c]
		}
		if (numrows > 0){
			st_addobs(numrows)
			endpos = startpos + numrows - 1
			svarnames = getvartypes("string", varinfo)
			rvarnames = getvartypes("other", varinfo)
			svarnamestemp = getvartypes("string", varinfotemp)
			rvarnamestemp = getvartypes("other", varinfotemp)
			sdata = J(numrows,length(svarnames),"")
			rdata = J(numrows,length(rvarnames),.)
			for (r=1; r<=numrows; r++) {
				trow = result->getArrayValue(r);
				for(c=1; c<=length(svarnames); c++) {
					tval = trow->getString(svarnames[c],"");
					if (tval == "null") tval = ""
					if (tval == `"""' + `"""') tval = ""
					sdata[r,c] = tval
				}
				for(c=1; c<=length(rvarnames); c++) {
					tval = trow->getString(rvarnames[c],"");
					if (tval == "null") rdata[r,c] = .
					else rdata[r,c] = strtoreal(tval)
				}
			}
			if (length(svarnames) > 0){
				st_sview(SV,(startpos..endpos)',svarnamestemp)
				SV[.,.] = sdata[.,.]
			}
			if (length(rvarnames) > 0){
				st_view(V,(startpos..endpos)',rvarnamestemp)
				V[.,.] = rdata[.,.]
			}
			nextpage = root->getString("next", "")
			return(nextpage)
		}
		else return("null")
	}


	string scalar gettable_summaries(string scalar url, real scalar startpos, string matrix varinfo){
		pointer (class libjson scalar) scalar root
		pointer (class libjson scalar) scalar result
		pointer (class libjson scalar) scalar trow
		string matrix sdata
		string rowvector varnames
		string scalar nextpage
		string scalar tval
		real matrix rdata
		real scalar numrows
		real scalar endpos
		if (st_global("debug_ind") == "1") printf(urlmode(url) + "\n")
		root = libjson::webcall(url ,"");
		result = root->getNode("results")
		numrows = result->arrayLength()
		varinfotemp = J(6,length(varinfo[1,.]),"")
		for (c=1; c<=length(varinfo[1,.]); c++){
			varinfotemp[1,c] = strlower(varinfo[1,c])
			varinfotemp[3,c] = varinfo[3,c]
		}
		if (numrows > 0){
			st_addobs(numrows)
			endpos = startpos + numrows - 1
			svarnames = getvartypes("string", varinfo)
			rvarnames = getvartypes("other", varinfo)
			svarnamestemp = getvartypes("string", varinfotemp)
			rvarnamestemp = getvartypes("other", varinfotemp)
			sdata = J(numrows,length(svarnames),"")
			rdata = J(numrows,length(rvarnames),.)
			for (r=1; r<=numrows; r++) {
				trow = result->getArrayValue(r);
				for(c=1; c<=length(svarnames); c++) {
					tval = trow->getString(svarnames[c],"");
					if (tval == "null") tval = ""
					if (tval == `"""' + `"""') tval = ""
					sdata[r,c] = tval
				}
				for(c=1; c<=length(rvarnames); c++) {
					tval = trow->getString(rvarnames[c],"");
					if (tval == "null") rdata[r,c] = .
					else rdata[r,c] = strtoreal(tval)
				}
			}
			if (length(svarnames) > 0){
				st_sview(SV,(startpos..endpos)',svarnamestemp)
				SV[.,.] = sdata[.,.]
			}
			if (length(rvarnames) > 0){
				st_view(V,(startpos..endpos)',rvarnamestemp)
				V[.,.] = rdata[.,.]
			}
			nextpage = root->getString("next", "")
			return(nextpage)
		}
		else return("null")
	}


	// Helper function to create query strings ?var=x for all potential subset combinations
	string scalar getquerystrings(string scalar additions){
		string rowvector result1
		string rowvector result2
		string rowvector result3
		string scalar staticstring
		string scalar dynamicstring
		real scalar countstatic
		if (additions == "") return("")
		t = tokeninit(";")
		s = tokenset(t, additions)
		result1 = tokengetall(t)
		countstatic = 1
		staticstring = ""
		for (c=1; c<=length(result1); c++){
			t = tokeninit("=")
			s = tokenset(t, result1[c])
			result2 = tokengetall(t)
			if (subinstr(result2[2], ":", "") == result2[2]){
				if (countstatic == 1) staticstring = staticstring + result1[c]
				else staticstring = staticstring + "&" + result1[c]
				countstatic = countstatic + 1
			}
			else{
				t = tokeninit(":")
				s = tokenset(t, result2[2])
				result3 = tokengetall(t)
				dynamicstring = ""
				for (r=strtoreal(result3[1]); r<=strtoreal(result3[2]); r++){
					if (r == strtoreal(result3[1])) dynamicstring = dynamicstring + result2[1] + "=" + strofreal(r)
					else dynamicstring = dynamicstring + "," + strofreal(r)
				}	
				if (countstatic == 1) staticstring = staticstring + dynamicstring
				else staticstring = staticstring + "&" + result1[c]
				countstatic = countstatic + 1
			}
		}
		return("?" + staticstring)
	}

	// Helper function to create dataset
	real scalar createdataset(string scalar eid){
		string matrix varinfo
		string matrix vardef
		string scalar labeldef
		string scalar labelshort
		varinfo = getvarinfo(st_global("base_url") + "/api/v1/api-endpoint-varlist/?endpoint_id=" + eid)
		for (c=1; c<=length(varinfo[1,.]); c++){
			varinfo[1,c] = strlower(varinfo[1,c])
		}
		temp1 = st_addvar(varinfo[3,.],varinfo[1,.])
		for (c=1; c<=length(varinfo[1,.]); c++){
			varinfo[2,c] = subinstr(varinfo[2,c], "&mdash;", "—")
			varinfo[2,c] = subinstr(varinfo[2,c], "&ndash;", "–")
			stata("qui label var " + varinfo[1,c] + " " + `"""' + varinfo[2,c] + `"""')
			if (strlen(varinfo[1,c]) > 30) labelshort = substr(varinfo[1,c], 1, 30) + "df"
			else labelshort = varinfo[1,c] + "df"
			if (varinfo[4,c] == "1"){
				vardef = getvardefs(varinfo[1,c], varinfo[5,c])
				labeldef = "qui label define " + labelshort + " "
				for (r=1; r<=length(vardef[1,.]); r++){
					labeldef = labeldef + vardef[1,r] + " " + `"""' + vardef[2,r] + `"""'
					if (r != length(vardef[1,.])) labeldef = labeldef + " "
				}
				labeldef = labeldef + ", replace"
				stata(labeldef)
				stata("qui label values " + varinfo[1,c] + " " + labelshort)
			}
			else if (varinfo[3,c] == "float"){
				labeldef = "qui label define " + labelshort + " -1 " + `"""' + "Missing/Not reported" + `"""' + " -2 " + `"""' + "Not applicable" + `"""' + " -3 " + `"""' + "Suppressed data" + `"""' + ", replace"
				stata(labeldef)
				stata("qui label values " + varinfo[1,c] + " " + labelshort)
			}
			else if (varinfo[3,c] == "double"){
				labeldef = "qui label define " + labelshort + " -1 " + `"""' + "Missing/Not reported" + `"""' + " -2 " + `"""' + "Not applicable" + `"""' + " -3 " + `"""' + "Suppressed data" + `"""' + ", replace"
				stata(labeldef)
				stata("qui label values " + varinfo[1,c] + " " + labelshort + ", nofix")
			}
		}
		return(1)
	}


	// Helper function to create dataset
	real scalar createdataset_summaries_ep(string matrix varinfo){
		string matrix vardef
		string scalar labeldef
		string scalar labelshort
		for (c=1; c<=length(varinfo[1,.]); c++){
			varinfo[1,c] = strlower(varinfo[1,c])
		}
		temp1 = st_addvar(varinfo[3,.],varinfo[1,.])
		for (c=1; c<=length(varinfo[1,.]); c++){
			varinfo[2,c] = subinstr(varinfo[2,c], "&mdash;", "—")
			varinfo[2,c] = subinstr(varinfo[2,c], "&ndash;", "–")
			stata("qui label var " + varinfo[1,c] + " " + `"""' + varinfo[2,c] + `"""')
			if (strlen(varinfo[1,c]) > 30) labelshort = substr(varinfo[1,c], 1, 30) + "df"
			else labelshort = varinfo[1,c] + "df"
			if (varinfo[4,c] == "1"){
				vardef = getvardefs(varinfo[1,c], varinfo[5,c])
				labeldef = "qui label define " + labelshort + " "
				for (r=1; r<=length(vardef[1,.]); r++){
					labeldef = labeldef + vardef[1,r] + " " + `"""' + vardef[2,r] + `"""'
					if (r != length(vardef[1,.])) labeldef = labeldef + " "
				}
				labeldef = labeldef + ", replace"
				stata(labeldef)
				stata("qui label values " + varinfo[1,c] + " " + labelshort)
			}
			else if (varinfo[3,c] == "float"){
				labeldef = "qui label define " + labelshort + " -1 " + `"""' + "Missing/Not reported" + `"""' + " -2 " + `"""' + "Not applicable" + `"""' + " -3 " + `"""' + "Suppressed data" + `"""' + ", replace"
				stata(labeldef)
				stata("qui label values " + varinfo[1,c] + " " + labelshort)
			}
			else if (varinfo[3,c] == "double"){
				labeldef = "qui label define " + labelshort + " -1 " + `"""' + "Missing/Not reported" + `"""' + " -2 " + `"""' + "Not applicable" + `"""' + " -3 " + `"""' + "Suppressed data" + `"""' + ", replace"
				stata(labeldef)
				stata("qui label values " + varinfo[1,c] + " " + labelshort + ", nofix")
			}
		}
		return(1)
	}

	// Helper function to translate short dataset name to full name
	string scalar shorttolongname(string scalar shortname, string matrix eps){
		string rowvector voptions
		string rowvector result1
		string scalar toreturn
		result1 = tokens(shortname)
		if (length(result1) < 2) return("Error1")
		if (result1[1] == "school") st1 = "schools"
		else if (result1[1] == "district") st1 = "school-districts"
		else if (result1[1] == "college") st1 = "college-university"
		else return("Error2")
		result1[1] = st1
		toreturn = ""
		for (r=1; r<=length(result1); r++){
			if (r == 1) toreturn = toreturn + result1[r]
			else toreturn = toreturn + " " + result1[r]
		}
		return(toreturn)
	}

	// Helper function to reformat summaries subcommand to endpoint URLs
	string scalar getsummariesurl(string scalar dataoptions, string scalar summaries_cmd){
		string scalar ep_url 
		string scalar agg_method
		string scalar var_to_agg
		string scalar agg_by
		string rowvector token_cmd

		ep_url = "/api/v1/"    
		for (c=1; c<=length(tokens(dataoptions)); c++){   
			ep_url = ep_url + tokens(dataoptions)[c] + "/"
		}
		ep_url = ep_url + "summaries/"

		token_cmd = tokens(summaries_cmd)
		agg_method = token_cmd[1]   
		var_to_agg = token_cmd[2]
		agg_by = ""

		for (c=4; c<=length(token_cmd); c++){
			if (c != length(token_cmd)){
				agg_by = agg_by + token_cmd[c] + ","
			} else {
				agg_by = agg_by + token_cmd[c]
			}
		}   

		ep_url = ep_url + "?stat=" + agg_method + "&by=" + agg_by + "&var=" + var_to_agg

		return(ep_url)
	}

	// Helper function for time taken
	string scalar timeit(real scalar timeper){
		string scalar timetaken
		if (hhC(timeper) == 0 && mmC(timeper) == 0) timetaken = "less than one minute"
		else if (hhC(timeper) == 0) timetaken = strofreal(mmC(timeper)) + " minute(s)"
		else timetaken = strofreal(hhC(timeper)) + " hour(s) and " + strofreal(mmC(timeper)) + " minute(s)"
		return(timetaken)
	}

	// Provide CSV download with numbered list of columns that should be strings
	string scalar numliststr(string matrix varinfo2){
		string rowvector varnames
		string scalar nliststr
		real scalar listnum
		varnames = st_varname((1..st_nvar()))
		nliststr = ""
		for (c=1; c<=length(varinfo2[1,.]); c++){
			if (varinfo2[5,c] == "string"){
				listnum = iteminlistnum(varinfo2[1,c], varnames)
				if (nliststr == "") nliststr = strofreal(listnum)
				else nliststr = nliststr + " " + strofreal(listnum)
			}
		}
		return(nliststr)
	}

	// Label CSV dataset appropriately when it is loaded in
	real scalar labelcsv(string matrix varinfo2, real scalar init1){
		string matrix vardef
		string scalar labeldef
		string scalar labelshort
		for (c=1; c<=length(varinfo2[1,.]); c++){
			stata("qui label var " + varinfo2[1,c] + " " + `"""' + varinfo2[2,c] + `"""')
			if (strlen(varinfo2[1,c]) > 30) labelshort = substr(varinfo2[1,c], 1, 30) + "df"
			else labelshort = varinfo2[1,c] + "df"
			if (varinfo2[4,c] == "1"){
				if (init1 == 1){
					vardef = getvardefs(varinfo2[1,c], varinfo2[5,c])
					labeldef = "qui label define " + labelshort + " "
					for (r=1; r<=length(vardef[1,.]); r++){
						labeldef = labeldef + vardef[1,r] + " " + `"""' + vardef[2,r] + `"""'
						if (r != length(vardef[1,.])) labeldef = labeldef + " "
					}
					labeldef = labeldef + ", replace"
					stata(labeldef)
				}
				stata("qui label values " + varinfo2[1,c] + " " + labelshort)
			}
			else if (varinfo2[3,c] == "float"){
				if (init1 == 1){
					labeldef = "qui label define " + labelshort + " -1 " + `"""' + "Missing/Not reported" + `"""' + " -2 " + `"""' + "Not applicable" + `"""' + " -3 " + `"""' + "Suppressed data" + `"""' + ", replace"
					stata(labeldef)
				}
				stata("qui label values " + varinfo2[1,c] + " " + labelshort)
			}
			else if (varinfo2[3,c] == "double"){
				if (init1 == 1){
					labeldef = "qui label define " + labelshort + " -1 " + `"""' + "Missing/Not reported" + `"""' + " -2 " + `"""' + "Not applicable" + `"""' + " -3 " + `"""' + "Suppressed data" + `"""' + ", replace"
					stata(labeldef)
				}
				stata("qui label values " + varinfo2[1,c] + " " + labelshort + ", nofix")
			}
		}
		return(1)		
	}

	// Correct grade list for subsetting CSV files
	string scalar correctgrade(string scalar vopt1){
		if (vopt1 == "grade-pk" || vopt1 == "pk") return("-1")
		else if (vopt1 == "grade-k" || vopt1 == "k") return("0")
		else return(subinstr(vopt1, "grade-", ""))
	}

	// Subset and keep relevant variables - keep if inlist(varname,val1,val2,etc.)
	real scalar subsetkeep(string matrix spops2, string scalar querystring2, real scalar epid2, string scalar vlist2){
		string rowvector spopsres
		string rowvector voptions
		string rowvector queryparams
		string rowvector queryparamvals
		string rowvector queryparamlist
		string scalar keepstate
		string scalar keepbase
		keepbase = "qui keep if inlist("
		for (r=1; r<=length(spops2[1,.]); r++){
			t = tokeninit("=")
			s = tokenset(t, spops2[2,r])
			spopsres = tokengetall(t)
			keepstate = keepbase + spops2[1,r]
			if (spopsres[2] != "alldata"){
				voptions = validoptions(spops2[2,r], epid2)
				for (c=1; c<=length(voptions); c++){
					keepstate = keepstate + "," + correctgrade(voptions[c])
				}
				keepstate = keepstate + ")"
				stata(keepstate)
			}
		}
		querystring2 = subinstr(querystring2, "?", "")
		t = tokeninit("&")
		s = tokenset(t, querystring2)
		queryparams = tokengetall(t)
		for (r=1; r<=length(queryparams); r++){
			t = tokeninit("=")
			s = tokenset(t, queryparams[r])
			queryparamvals = tokengetall(t)
			keepstate = keepbase + queryparamvals[1] + "," + queryparamvals[2] + ")"
			stata(keepstate)
		}
		if (vlist2 != "") stata("keep " + vlist2)
		return(1)
	}

	// Download Local CSV to parse column order, keep it
	real scalar copycsv(string scalar tval1, string scalar tbaseurl1){
		stata("qui copy " + tbaseurl1 + subinstr(tval1, " ", "") + " temp_eddata_file_gen_012345.csv, replace")
		stata("qui import delimited temp_eddata_file_gen_012345.csv, clear rowrange(1:1)")
		return(1)
	}

	// Download from CSV instead
	real scalar downloadcsv(string scalar eid1, string matrix spops1, string scalar ds1, real scalar epid1, string matrix varinfo1, string scalar querystring1, string scalar vlist1){
		pointer (class libjson scalar) scalar results1
		pointer (class libjson scalar) scalar trow
		string rowvector yearslist
		string rowvector relfiles
		string scalar tval
		string scalar tbaseurl
		string scalar addstrings
		string scalar liststrings
		string scalar relfilesstr
		real scalar dlyear
		real scalar numresults
		real scalar temp1
		real scalar temp2
		real scalar temp3
		real scalar countfiles
		tbaseurl = st_global("base_url") + "/csv/" + ds1 + "/"
		results1 = getresults(st_global("base_url") + "/api/v1/api-downloads/?endpoint_id=" + eid1)
		yearslist = validoptions(spops1[2,1], epid1)
		numresults = results1->arrayLength()
		temp1 = 0
		if (numresults == 1){
			return(0)
		}
		if (numresults == 2){
			printf("Downloading file, please wait...\n")
			tval = results1->getArrayValue(2)->getString("file_name", "")
			temp3 = copycsv(tval, tbaseurl)
			liststrings = numliststr(varinfo1)
			if (liststrings == "") addstrings = ""
			else addstrings = " stringcols(" + liststrings + ")"
			stata("clear")
			stata("qui import delimited temp_eddata_file_gen_012345.csv, clear" + addstrings)
			stata("qui rm temp_eddata_file_gen_012345.csv")
			temp1 = labelcsv(varinfo1, 1)
			temp2 = subsetkeep(spops1, querystring1, epid1, vlist1)
		}
		else{
			printf("Progress for each CSV file will print to your screen. Please wait...\n\n")
			relfilesstr = ""
			for (r=1; r<=numresults; r++){
				trow = results1->getArrayValue(r);
				tval = trow->getString("file_name","");
				dlyear = 0
				if (subinstr(tval, ".csv", "") != tval) dlyear = dlyear + 1
				else dlyear = -10
				for (c=1; c<=length(yearslist); c++){
					if (subinstr(tval, yearslist[c], "") != tval) dlyear = dlyear + 1
				}
				if (dlyear == 2){
					if (relfilesstr == "") relfilesstr = tval
					else relfilesstr = relfilesstr + ";" + tval
				}
			}
			t = tokeninit(";")
			s = tokenset(t, relfilesstr)
			relfiles = tokengetall(t)
			for (r=1; r<=length(relfiles); r++){
				if (r == 1){
					temp3 = copycsv(relfiles[r], tbaseurl)
					liststrings = numliststr(varinfo1)
					if (liststrings == "") addstrings = ""
					else addstrings = " stringcols(" + liststrings + ")"
					stata("clear")
				}
				printf("Processing file " + strofreal(r) + " of " + strofreal(length(relfiles)) + "\n")
				stata("qui preserve")
				if (r == 1) {
					stata("qui import delimited temp_eddata_file_gen_012345.csv, clear" + addstrings)
					stata("qui rm temp_eddata_file_gen_012345.csv")
				}
				else stata("qui import delimited " + tbaseurl + subinstr(relfiles[r], " ", "") + ", clear" + addstrings)
				if (temp1 == 0) temp1 = labelcsv(varinfo1, 1)
				else temp1 = labelcsv(varinfo1, 0)
				temp2 = subsetkeep(spops1, querystring1, epid1, vlist1)
				stata("qui save temp_eddata_file_gen_012345, replace")
				stata("qui restore")
				stata("qui append using temp_eddata_file_gen_012345")
			}
			stata("qui rm temp_eddata_file_gen_012345.dta")
		}
		stata("qui compress")
		return(1)
	}

	// Gets all tables, using API to get the varlist and vartypes, and looping through all "nexts", calling gettable
	real scalar getalltables(string scalar eid, string scalar url2, real scalar totallen1, real scalar epcount1){
		pointer (class libjson scalar) scalar root
		pointer (class libjson scalar) scalar results1
		string matrix varinfo
		string scalar nextpage
		string scalar timea
		string scalar timetaken1
		string scalar timetaken2
		real scalar pagesize
		real scalar totalpages
		real scalar countpage
		real scalar timeper1
		real scalar timeper2
		varinfo = getvarinfo(st_global("base_url") + "/api/v1/api-endpoint-varlist/?endpoint_id=" + eid)
		if (st_global("debug_ind") == "1") printf(urlmode(st_global("base_url") + url2) + "\n")
		root = libjson::webcall(urlmode(st_global("base_url") + url2),"");
		results1 = root->getNode("results")
		pagesize = results1->arrayLength()
		totalpages = floor((strtoreal(root->getString("count", ""))) / pagesize) + 1
		spos = 1
		if (st_nobs() > 0) spos = st_nobs() + 1
		countpage = 1
		if (epcount1 == 1){
			if (totalpages == .) totalpages = 1
			timeper1 = 1500 * totalpages * totallen1
			timeper2 = 10000 * totalpages * totallen1
			timetaken1 = timeit(timeper1)
			timetaken2 = timeit(timeper2)
			timea = "\nI estimate that the download for the entire file you requested will take "
			if (timetaken1 == "less than one minute" && timetaken2 == "less than one minute") printf(timea + "less than one minute.\n")
			else if (timetaken1 == "less than one minute" && timetaken2 != "less than one minute") printf(timea + "less than " + timetaken2 + ".\n")
			else printf(timea + "between %s and %s.\n", timetaken1, timetaken2)
			printf("This is only an estimate, so actual time may vary due to internet speed and file size differences.\n\n")
			printf("Progress for each endpoint and call to the API will print to your screen. Please wait...\n")
			printf("If this time is too long for you to wait, try adding the " + `"""' + "csv" + `"""' + " option to the end of your command to download the full csv directly.\n")
		}
		printf("\nGetting data from %s, endpoint %s of %s (%s records).\n", url2, strofreal(epcount1), strofreal(totallen1), root->getString("count", ""))
		nextpage = gettable(st_global("base_url") + url2, spos, varinfo)
		if (nextpage!="null"){
			do {
				spos = spos + pagesize
				countpage = countpage + 1
				printf("Endpoint %s of %s: On page %s of %s\n", strofreal(epcount1), strofreal(totallen1), strofreal(countpage), strofreal(totalpages))
				nextpage = gettable(nextpage, spos, varinfo)
			} while (nextpage!="null")
		}
		return(1)
	}

	real scalar raise_error(){
		printf("\nThis Stata command is invalid. Please open the URL above in a browser for detailed error messages. More instructions can be found on the Education Data Portal Documentation Website (https://educationdata.urban.org/documentation/).") 
		return(0)
	}

	// Gets all tables, using API to get the varlist and vartypes, and looping through all "nexts", calling gettable
	real scalar getalltables_summaries(string matrix varinfo, string scalar url2, real scalar totallen1, real scalar epcount1){
		pointer (class libjson scalar) scalar root
		pointer (class libjson scalar) scalar results1
		string scalar nextpage
		string scalar timea
		string scalar timetaken1
		string scalar timetaken2
		real scalar pagesize
		real scalar totalpages
		real scalar countpage
		real scalar timeper1
		real scalar timeper2
		if (st_global("debug_ind") == "1") printf(st_global("base_url") + url2 + "\n")
		root = libjson::webcall(st_global("base_url") + url2, "");
		if (root){
			results1 = root->getNode("results")
			pagesize = results1->arrayLength()
			totalpages = floor((strtoreal(root->getString("count", ""))) / pagesize) + 1
			spos = 1
			if (st_nobs() > 0) spos = st_nobs() + 1
			countpage = 1
			nextpage = gettable_summaries(st_global("base_url") + url2, spos, varinfo)
			return(1)
		} else{
			error=raise_error()
			return(0)
		}
	}

	// helper function to get data from summary endpoints 
	string scalar getsummarydata(string scalar dataoptions, string scalar summaries, string scalar opts, string scalar vlist){
		string matrix varinfo
		real scalar spos
		string matrix summary_ep_url
		string rowvector allopts
		string rowvector token_cmd
		string matrix varinfo1
		string matrix varinfo2
		string matrix varinfo_groupby_var
		real scalar tempdata
		real scalar totallen
		real scalar epcount
		summary_ep_url = getsummariesurl(dataoptions, summaries)
		allopts = tokens(opts)
		for (i=1; i<=length(allopts); i++){
			summary_ep_url = summary_ep_url + "&" + allopts[i]
		}
		printf("\n\nGetting data from: " + st_global("base_url") + summary_ep_url + "\n")
		token_cmd = tokens(summaries)
		var_to_agg = token_cmd[2]
		agg_by = ""
		for (c=4; c<=length(token_cmd); c++){
			if (c != length(token_cmd)){
				agg_by = agg_by + token_cmd[c] + ","
			} else {
				agg_by = agg_by + token_cmd[c]
			}
		}  
		if (strmatch(agg_by, "*,*") == 1) {
			groupby_lst = tokens(agg_by, ",")
		} else {
			groupby_lst = tokens(agg_by)
		}
		varinfo1 = getvarinfo(st_global("base_url") + "/api/v1/api-variables/?variable=year")
		varinfo_var_to_agg = getvarinfo(st_global("base_url") + "/api/v1/api-variables/?variable=" + var_to_agg)
		num_var = 2 + (length(groupby_lst) + 1)/2
		var_attr = 6 
		varinfo = J(var_attr, num_var, "")
		for (r=1; r<=var_attr; r++){
			varinfo[r, 1] = varinfo1[r, 1]
		}
		temp = 2 
		for (j=1; j<=length(groupby_lst); j++){
			if (groupby_lst[j] != ","){
				varinfo_groupby_var = getvarinfo(st_global("base_url") + "/api/v1/api-variables/?variable=" + groupby_lst[j])
				for (r=1; r<=var_attr; r++){
					varinfo[r, temp] = varinfo_groupby_var[r, 1]
				}
				temp = temp + 1 
			}
		}
		for (r=1; r<=var_attr; r++){
			varinfo[r, temp] = varinfo_var_to_agg[r, 1]
		}
		spos = 1
		epcount = 0
		totallen = 1
		tempdata = createdataset_summaries_ep(varinfo)
		for (i=1; i<=totallen; i++){
			epcount = epcount + 1
			alldata = getalltables_summaries(varinfo, summary_ep_url, totallen, epcount)
		}
		if (alldata == 1){
			stata("qui compress")
			if (vlist != "") stata("keep " + vlist)
			else printf("\n\nData successfully loaded into Stata and ready to use.")
		}
		return("")
	}

	// Main function to get data based on Stata request - calls other helper functions
	string scalar getalldata(string scalar dataoptions, string scalar vlist, string scalar opts, string scalar summaries, real scalar clearme, real scalar metadataonly, real scalar staging, real scalar csv, real scalar clearcache, real scalar debugind){
		string matrix endpoints
		string matrix spops
		string matrix varinfo
		string rowvector allopts
		string rowvector validopts
		string rowvector res2
		string rowvector respre
		string rowvector temp1
		string rowvector temp2
		string scalar eid
		string scalar urltemp
		string scalar urladds
		string scalar querystring
		string scalar dataoptions1
		string scalar validfilters
		string scalar ds
		string scalar summary_ep_url
		real scalar epid
		real scalar spos
		real scalar spos1
		real scalar hidereturn
		real scalar totallen
		real scalar epcount
		real scalar tempdata
		real scalar temp3
		real scalar test
		st_global("base_url","https://educationdata.urban.org")
		st_global("staging_url","https://educationdata-stg.urban.org")
		if (staging > 0) st_global("base_url", st_global("staging_url"))
		st_global("cc","0")
		if (clearcache > 0) st_global("cc","1")
		st_global("debug_ind", "0")
		if (debugind > 0) st_global("debug_ind", "1")
		X = st_data(.,.)
		if (clearme > 0) stata("clear")
		else{
			if (length(X[.,.]) > 0) {   
				printf("Error: You currently have data loaded in Stata. Please add " + `"""' + "clear" + `"""' + " to the end of this command if you wish to remove your current data.")
				return("")
			}
			else stata("clear")
		}
		endpoints = endpointstrings()
		dataoptions1 = shorttolongname(strlower(dataoptions), endpoints)

		if (strlen(summaries) > 0){  
			getsummarydata(dataoptions1, summaries, opts, vlist)
			return("")
		} 
		else{
			if (dataoptions1 == "Error1"){
				printf("Error: You must enter the complete name of a dataset in the 'using' statement. The first is the 'short' name for the data category, and the remaining words are the unique name of the dataset. E.g., using " + `"""' + "school directory" + `"""' + ". Type " + `"""' + "help educationdata" + `"""' + " to learn more.")
				return("")
			}
			else if (dataoptions1 == "Error2"){
				printf("Error: The option you selected was invalid. The three options are: " + `"""' + "school" + `"""' + ", " + `"""' + "district" + `"""' + ", and " + `"""' + "college" + `"""' + ". Type " + `"""' + "help educationdata" + `"""' + " to learn more.")
				return("")			
			}
			epid = validendpoints(dataoptions1)
			if (epid == 0 || dataoptions1 == "Error3"){
				printf("Error: The name of the category ('school', 'district', or 'college') is correct, but the name of the dataset you chose is not. Please verify the list of allowed options by typing " + `"""' + "help educationdata" + `"""' + ".")
				return("")			
			}
			eid = endpoints[1,epid]
			varinfo = getvarinfo(st_global("base_url") + "/api/v1/api-endpoint-varlist/?endpoint_id=" + eid)
			for (c=1; c<=length(varinfo[1,.]); c++){
				varinfo[1,c] = strlower(varinfo[1,c])
			}
			validfilters = ""
			for (c=1; c<=length(varinfo[6,.]); c++){    /* varinfo[6,c] indicates is_filter */ 
				if (varinfo[6,c] == "1" && varinfo[3,c] == "double"){       /* note that no float variables are filters per metadata */ 
					if (validfilters == "") validfilters = varinfo[1,c]
					else validfilters = validfilters + ", " + varinfo[1,c]
				}
			}
			t = tokeninit(", ")
			s = tokenset(t, validfilters)
			respre = tokengetall(t)
			allopts = tokens(opts)
			validopts = parseurls(endpoints[2,epid], "optional")
			spops = J(2,length(validopts),"")
			spops[1,.] = validopts[1,.]
			urladds = ""
			if (length(varinfo[1,.]) > 0){
				for (i=1; i<=length(allopts); i++){
					t = tokeninit("=")
					s = tokenset(t, allopts[i])
					res2 = tokengetall(t)
					spos = stringpos(res2[1], validopts)
					if (spos > 0) spops[2,spos] = allopts[i]
					else{
						spos1 = stringpos(res2[1], varinfo[1,.])
						if (spos1 > 0){
							if (res2[2] != subinstr(subinstr(res2[2], ":", ""), ",", "")){
								if (iteminlist(res2[1], respre) == 0){ 
									printf("Error, option " + allopts[i] + " is not valid, because it may only be filtered on a single value, not multiple values.\n")
									printf("Decimal variables may not be filtered at all. The variables that can be filtered on multiple values in this dataset are as follows:\n\n")
									printf(validfilters)
									return("\n\nDownload failed. Please try again.")
								}
							}
							if (urladds == "") {
								urladds = urladds + allopts[i]
							}
							else {
								urladds = urladds + ";" + allopts[i]
							}
						}
						else {
							printf("Error, option " + allopts[i] + " is not valid. Valid variable selections are as follows:\n")
							urladds = ""
							for (c=1; c<=length(varinfo[1,.]); c++){
								if (stringpos(strofreal(c),("1","6","11","16","21","26","31","36","41","46","51","56","61","66","71","76","81","86","91","96","101")) > 0) urladds = urladds + varinfo[1,c]
								else urladds = urladds + ", " + varinfo[1,c]
								if (stringpos(strofreal(c),("5","10","15","20","25","30","35","40","45","50","55","60","65","70","75","80","85","90","95","100")) > 0) urladds = urladds + "\n"
							}
							return("\n\nDownload failed. Please try again.")
						}
					}
				}
			}
			querystring = getquerystrings(urladds)
			for (i=1; i<=length(spops[1,.]); i++){
				if (spops[2,i] == "") spops[2,i] = spops[1,i] + "=alldata"
			}
			temp1 = validoptions(spops[2,1], epid)
			if (tokens(temp1[1])[1] == "Invalid"){ 
				printf(temp1[1])
				return("")
			}
			epcount = 0
			if (metadataonly <= 0) printf("Please be patient - downloading data.\n")
			if (csv > 0 && metadataonly <= 0){
				printf("\nNote that this function writes data to the current working directory.\n")
				printf("If you do not have read and write privileges to the current directory, please change your working directory.\n")
				printf("For example, you can enter " + `"""' + "cd D:/Users/[Your username here]/Documents" + `"""' + ".\n\n")
				ds = tokens(dataoptions)[2]
				temp3 = downloadcsv(eid,spops,ds,epid,varinfo,querystring,vlist)
				if (temp3 == 0){
					printf("Error: Sorry, there is no CSV file available for download for this dataset at this time.")
				}
			}
			else{
				tempdata = createdataset(eid)
				if (metadataonly <= 0){
					if (length(spops[1,.]) == 1){
						totallen = length(temp1)
						for (i=1; i<=length(temp1); i++){
							epcount = epcount + 1
							urltemp = subinstr(endpoints[2,epid], "{" + spops[1,1] + "}", temp1[i]) + querystring
							hidereturn = getalltables(eid, urltemp, totallen, epcount)
						}
					}
					else{
						temp2 = validoptions(spops[2,2], epid)
						if (tokens(temp2[1])[1] == "Invalid"){ 
							printf(temp2[1])
							return("")
						}
						totallen = length(temp1) * length(temp2)
						for (i=1; i<=length(temp1); i++){
							for (j=1; j<=length(temp2); j++){
								epcount = epcount + 1
								urltemp = subinstr(subinstr(endpoints[2,epid], "{" + spops[1,1] + "}", temp1[i]), "{" + spops[1,2] + "}", temp2[j]) + querystring
								hidereturn = getalltables(eid, urltemp, totallen, epcount)
							}
						}		
					}
					stata("qui compress")
				}
				if (metadataonly > 0) {
					printf("Metadata successfully loaded into Stata and ready to view. Remove the " + `"""' + "metadata" + `"""' + " argument if you want to load the data itself.\n\n")
					printf("Note: You may filter this dataset on any variable (as long as it does not have a decimal value) using a single value (e.g. grade=1), however only the following variables allow filtering on multiple values (e.g.grade=1:3 or grade=1,2):\n\n")
					printf(validfilters)
				}
			}
			if (vlist != "") stata("keep " + vlist)
			else printf("\nData successfully loaded into Stata and ready to use.")
			return("")
		}
	}

end