program jsontodataframe
version 1.0
// Beginning section and some structure borrowed from insheetjson - thanks!
mata: if (findexternal("libjson()")) {} else printf("{err: Error: The required JSON library (libjson) seems to be missing so this command will fail. Read the help file for more information.}\n");
mata: if (libjson::checkVersion((1,0,2))) {} else printf("{err: The JSON library version is not compatible with this command and so will likely fail. Please update libjson.}\n");
syntax [varlist] using/ , [COLumns(string)] [TABLEselector(string)] [LIMIT(integer 0)] [OFFSET(integer 0)] [PRINTonly] [REPlace] [DEBUG] [SAVECONtents(string)] [SHOWresponse] [FOLLOWurl(string)]
mata: 	dummy=todf("`using'", "`columns'", "`varlist'","`tableselector'", strtoreal("`limit'"), strtoreal("`offset'"), strlen("`printonly'"), strlen( "`replace'"),strlen( "`debug'"), st_local("followurl"), "`savecontents'");
end

mata	

	// Helper function that returns results node
	pointer (class libjson scalar) scalar getresults(string scalar url){
		pointer (class libjson scalar) scalar root
		pointer (class libjson scalar) scalar result
		root = libjson::webcall(url ,"");
		result = root->getNode("results")
		return(result)
	}

	// Helper function that returns matrix of variable information from API
	string matrix getvarinfo(string scalar url){
		pointer (class libjson scalar) scalar res
		pointer (class libjson scalar) scalar trow
		string scalar tempvar
		string scalar tempind
		res = getresults(url)
		numrows = res->arrayLength()
		varinfo = J(4,numrows,"")
		for (r=1; r<=numrows; r++) {
			trow = res->getArrayValue(r)
			varinfo[1,r] = trow->getString("variable", "")
			varinfo[2,r] = trow->getString("label", "")
			tempvar = trow->getString("data_type", "")
			if (tempvar == "integer") varinfo[3,r] = "long"
			else if (tempvar == "float") varinfo[3,r] = "float"
			else if (tempvar == "string"){ 
				varinfo[3,r] = "str" + trow->getString("string_length", "")
			}
			tempind = trow->getString("values", "")
			if (tempind == "None") varinfo[4,r] = "0"
			else varinfo[4,r] = "1"
		}
		return(varinfo)		
	}

	// Parse metadata to get api endpoint strings, years, and required selectors from enpoint URL
	string matrix endpointstrings(){
		pointer (class libjson scalar) scalar res1
		pointer (class libjson scalar) scalar trow
		string matrix endpointdata
		res1 = getresults("https://ed-data-portal.urban.org/api/v1/api-endpoints/")
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
		string rowvector returnyears
		string scalar yrs
		string scalar yrstring
		endpoints = endpointstrings()
		yrs = endpoints[3,matid]
		if (subinstr(subinstr(yrs, ",", ""), "–", "") == yrs){
			returnyears = (yrs)
		}
		else if (subinstr(yrs, "and", "") != yrs){
			yrs = subinstr(subinstr(yrs, " ", ""), "and", "")
			t = tokeninit(",")
			s = tokenset(t, yrs)
			getit = tokengetall(t)
			yrstring = subinstr(yrs, "," + getit[length(getit)], "")
			t = tokeninit("–")
			s = tokenset(t, getit[length(getit)])
			getit = tokengetall(t)
			for (y=strtoreal(getit[1]); y<=strtoreal(getit[2]); y++){
				yrstring = yrstring + "," + strofreal(y)
			}
			t = tokeninit(",")
			s = tokenset(t, yrstring)
			returnyears = tokengetall(t)
		}
		else {
			t = tokeninit("–")
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
		string scalar getstring
		string scalar tempadd
		string rowvector years
		real scalar isopt1
		real scalar spos1
		real scalar spos2
		endpoints = endpointstrings()
		t = tokeninit("=")
		s = tokenset(t, subset1)
		getit = tokengetall(t)
		vopts = parseurls(endpoints[2,epid], "optional")
		isopt1 = isvalid(getit[1], vopts)
		if (isopt1 == 1){
			grades = ("pk","k","1","2","3","4","5","6","7","8","9","10","11","12","99")
			levels = ("undergraduate","graduate","first-professional","post-baccalaureate")
			fedaids = ("fed","sub-stafford","no-pell-stafford")
			if (getit[1] == "year") years = parseyears(epid)
			if (subinstr(subinstr(getit[2], ",", ""), ":", "") == getit[2]){
				return((getit[2]))
			}
			else if (subinstr(getit[2], ",", "") != getit[2]){
				t = tokeninit(",")
				s = tokenset(t, getit[2])
				return(tokengetall(t))		
			}
			else{
				tempadd = ""
				if (getit[1] == "year") tlev = years
				else if (getit[1] == "grade"){
					tlev = grades
					tempadd = "grade-"
				}
				else if (getit[1] == "level_of_study") tlev = levels
				else if (getit[1] == "fed_aid_type") tlev = fedaids
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
					return(tokengetall(t))
				}
				else return(("Invalid Option selection: " + getit[1] + ":" + getit[2]))
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
			if (varinfo[3,c] == "string"){
				if (typ == "string") counting = counting + 1
			}
			else {
				if (typ != "string") counting = counting + 1
			}
		}
		varnametypes = J(1,counting,"")
		counter1 = 1
		for (c=1; c<=numvars; c++){
			if (varinfo[3,c] == "string"){
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
	string matrix getvardefs(string scalar var1){
		pointer (class libjson scalar) scalar result
		pointer (class libjson scalar) scalar trow
		string matrix vardefs
		string rowvector tokenstemp
		string scalar tempvar
		string scalar tempstring
		real scalar numrows
		real scalar startvar
		result = getresults("https://ed-data-portal.urban.org/api/v1/api-values/?format_name=" + var1)
		numrows = result->arrayLength()
		vardefs = J(2,numrows,"")
		for (r=1; r<=numrows; r++){
			trow = result->getArrayValue(r)
			vardefs[1,r] = trow->getString("code", "")
			tempvar = trow->getString("code_label", "")
			tokenstemp = tokens(tempvar, " - ")
			if (tokenstemp[1] == "-") startvar = 4
			else startvar = 3
			tempstring = ""
			for (i=startvar; i<=length(tokenstemp); i++){
				tempstring = tempstring + tokenstemp[i]
				if (i != length(tokenstemp)) tempstring = tempstring + " "
			}
			vardefs[2,r] = tempstring
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
		root = libjson::webcall(url ,"");
		result = root->getNode("results")
		numrows = result->arrayLength()
		st_addobs(numrows)
		endpos = startpos + numrows - 1
		svarnames = getvartypes("string", varinfo)
		rvarnames = getvartypes("other", varinfo)
		sdata = J(numrows,length(svarnames),"")
		rdata = J(numrows,length(rvarnames),.)
		for (r=1; r<=numrows; r++) {
			trow = result->getArrayValue(r);
			for(c=1; c<=length(svarnames); c++) {
				tval = trow->getString(svarnames[c],"");
				if (tval == "null") tval = ""
				sdata[r,c] = tval
			}
			for(c=1; c<=length(rvarnames); c++) {
				tval = trow->getString(rvarnames[c],"");
				if (tval == "null") rdata[r,c] = .
				else rdata[r,c] = strtoreal(tval)
			}
		}
		if (length(svarnames) > 0){
			st_sview(SV,(startpos..endpos)',svarnames)
			SV[.,.] = sdata[.,.]
		}
		if (length(rvarnames) > 0){
			st_view(V,(startpos..endpos)',rvarnames)
			V[.,.] = rdata[.,.]
		}
		nextpage = root->getString("next", "")
		return(nextpage)
	}

	// Gets all tables, using API to get the varlist and vartypes, and looping through all "nexts", calling gettable
	real scalar getalltables(string scalar url1, string scalar url2){
		pointer (class libjson scalar) scalar root
		pointer (class libjson scalar) scalar results1
		string matrix varinfo
		string matrix vardef
		string scalar nextpage
		string scalar labeldef
		real scalar spos
		real scalar pagesize
		real scalar totalpages
		real scalar countpage
		stata("clear")
		varinfo = getvarinfo(url1)
		temp1 = st_addvar(varinfo[3,.],varinfo[1,.])
		for (c=1; c<=length(varinfo[1,.]); c++){
			stata("label var " + varinfo[1,c] + " " + `"""' + varinfo[2,c] + `"""')
			if (varinfo[4,c] == "1"){
				vardef = getvardefs(varinfo[1,c])
				labeldef = "label define " + varinfo[1,c] + "df "
				for (r=1; r<=length(vardef[1,.]); r++){
					labeldef = labeldef + vardef[1,r] + " " + `"""' + vardef[2,r] + `"""'
					if (r != length(vardef[1,.])) labeldef = labeldef + " "
				}
				stata(labeldef)
				stata("label values " + varinfo[1,c] + " " + varinfo[1,c] + "df")
			}
		}
		spos = 1
		root = libjson::webcall(url2,"");
		results1 = root->getNode("results")
		pagesize = results1->arrayLength()
		totalpages = floor((strtoreal(root->getString("count", ""))) / pagesize) + 1
		countpage = 1
		printf("For %s\n", url2)
		printf("Downloading and appending page %s of %s from API\n", strofreal(countpage), strofreal(totalpages))
		nextpage = gettable(url2, spos, varinfo)
		if (nextpage!="null"){
			do {
				spos = spos + pagesize
				countpage = countpage + 1
				printf("Downloading and appending page %s of %s from API\n", strofreal(countpage), strofreal(totalpages))
				nextpage = gettable(nextpage, spos, varinfo)
			} while (nextpage!="null")
		}
		return(1)
	}
	result=getalltables("https://ed-data-portal.urban.org/api/v1/api-endpoint-varlist/?endpoint_id=20", "https://ed-data-portal.urban.org/api/v1/college-university/ipeds/grad-rates/2002/?page=2020")

end