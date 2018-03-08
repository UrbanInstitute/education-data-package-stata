program jsontodataframe
version 1.0
// Beginning section and some structure borrowed from insheetjson - thanks!
mata: if (findexternal("libjson()")) {} else printf("{err: Error: The required JSON library (libjson) seems to be missing so this command will fail. Read the help file for more information.}\n");
mata: if (libjson::checkVersion((1,0,2))) {} else printf("{err: The JSON library version is not compatible with this command and so will likely fail. Please update libjson.}\n");
syntax [varlist] using/ , [COLumns(string)] [TABLEselector(string)] [LIMIT(integer 0)] [OFFSET(integer 0)] [PRINTonly] [REPlace] [DEBUG] [SAVECONtents(string)] [SHOWresponse] [FOLLOWurl(string)]
mata: 	dummy=todf("`using'", "`columns'", "`varlist'","`tableselector'", strtoreal("`limit'"), strtoreal("`offset'"), strlen("`printonly'"), strlen( "`replace'"),strlen( "`debug'"), st_local("followurl"), "`savecontents'");
end

mata	

	string matrix todf(string scalar url){
		pointer (class libjson scalar) scalar root
		pointer (class libjson scalar) scalar result
		pointer (class libjson scalar) scalar firstrow
		pointer (class libjson scalar) scalar trow
		string rowvector varnames
		real rowvector varids
		string scalar countres
		string matrix dataframe
		real scalar pagelimit
		real scalar pages
		real scalar numvars
		real scalar numrows
		real scalar curpage
		pagelimit=100
		root=libjson::webcall(url ,"");
		countres = root->getString("count", "")
		numrecs = strtoreal(countres)
		pages = round(numrecs/pagelimit) + 1
		result = root->getNode("results")
		curpage = 1 
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
			varids = st_addvar("strL", varnames)
			st_store(.,varids,dataframe)
			return(dataframe)
		} 
		else {
			return(J(1,1,""))
		}
	}
	result=todf("https://ui-research.github.io/education-data-package-stata/example_json_test.json")

end