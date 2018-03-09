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
		res = getresults(url)
		numrows = res->arrayLength()
		varinfo = J(3,numrows,"")
		for (r=1; r<=numrows; r++) {
			trow = res->getArrayValue(r)
			varinfo[1,r] = trow->getString("variable", "")
			varinfo[2,r] = trow->getString("label", "")
			tempvar = trow->getString("data_type", "")
			if (tempvar == "integer") varinfo[3,r] = "long"
			else if (tempvar == "float") varinfo[3,r] = "float"
			else if (tempvar == "string") varinfo[3,r] = "str255"
		}
		return(varinfo)		
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

	// Gets all tables, using API to get the varlist and vartypes, and looping through all "nexts", calling gettable
	real scalar getalltables(string scalar url1, string scalar url2){
		pointer (class libjson scalar) scalar root
		pointer (class libjson scalar) scalar results1
		string matrix varinfo
		string scalar nextpage
		real scalar spos
		real scalar pagesize
		real scalar totalpages
		real scalar countpage
		varinfo = getvarinfo(url1)
		temp1 = st_addvar(varinfo[3,.],varinfo[1,.])
		spos = 1
		root = libjson::webcall(url2,"");
		results1 = root->getNode("results")
		pagesize = results1->arrayLength()
		totalpages = floor((strtoreal(root->getString("count", ""))) / pagesize) + 1
		countpage = 1
		printf("For %s\n", url2)
		printf("On page %s of %s\n", strofreal(countpage), strofreal(totalpages))
		nextpage = gettable2(url2, spos, varinfo)
		if (nextpage!="null"){
			do {
				spos = spos + pagesize
				countpage = countpage + 1
				printf("On page %s of %s\n", strofreal(countpage), strofreal(totalpages))
				nextpage = gettable2(nextpage, spos, varinfo)
			} while (nextpage!="null")
		}
		return(1)
	}
	result=getalltables("https://ed-data-portal.urban.org/api/v1/api-endpoint-varlist/?endpoint_id=20", "https://ed-data-portal.urban.org/api/v1/college-university/ipeds/grad-rates/2002/?page=1")


	// Get table just gets data we need for one table, this appends results to the stata dataset
	string scalar gettable2(string scalar url, real scalar startpos, string matrix varinfo){
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
	result=gettable2("https://ed-data-portal.urban.org/api/v1/college-university/ipeds/grad-rates/2002/?page=2026", 1, varinfo)

	// Original Learning Experience
	real scalar gettable(string scalar url){
		pointer (class libjson scalar) scalar root
		pointer (class libjson scalar) scalar result
		pointer (class libjson scalar) scalar firstrow
		pointer (class libjson scalar) scalar trow
		string rowvector varnames
		string scalar countres
		string matrix dataframe
		real scalar pagelimit
		real scalar pages
		real scalar numvars
		real scalar numrows
		pagelimit=100
		root=libjson::webcall(url ,"");
		countres = root->getString("count", "")
		numrecs = strtoreal(countres)
		pages = round(numrecs/pagelimit) + 1
		result = root->getNode("results")
		if (pages!=.) {
			firstrow = result->getArrayValue(1)
			varnames = firstrow->listAttributeNames(0)
			numvars = length(varnames)
			numrows = result->arrayLength()
			dataframe = J(numrows,numvars,"")
			for (r=1; r<=numrows; r++) {
				trow = result->getArrayValue(r);
				for(c=1; c<=numvars; c++) {
					dataframe[r,c] = trow->getString(varnames[c],"");
				}
			}
			st_addobs(rows(dataframe))
			varids = st_addvar("str255", varnames)
			st_sview(V,(1..numrows)',varnames)
			for (r=1; r<=numrows; r++) {
				V[r,.]=dataframe[r,.]
			}
			return(1)
		} 
		else {
			return(0)
		}
	}
	result=gettable("https://ed-data-portal.urban.org/api/v1/college-university/ipeds/grad-rates/2002/")

end