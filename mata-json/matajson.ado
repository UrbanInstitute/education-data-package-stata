program jsontodataframe
version 1.0
// Beginning section and some structure borrowed from insheetjson - thanks!
mata: if (findexternal("libjson()")) {} else printf("{err: Error: The required JSON library (libjson) seems to be missing so this command will fail. Read the help file for more information.}\n");
mata: if (libjson::checkVersion((1,0,2))) {} else printf("{err: The JSON library version is not compatible with this command and so will likely fail. Please update libjson.}\n");
syntax [varlist] using/ , [COLumns(string)] [TABLEselector(string)] [LIMIT(integer 0)] [OFFSET(integer 0)] [PRINTonly] [REPlace] [DEBUG] [SAVECONtents(string)] [SHOWresponse] [FOLLOWurl(string)]
mata: 	dummy=todataframe("`using'", "`columns'", "`varlist'","`tableselector'", strtoreal("`limit'"), strtoreal("`offset'"), strlen("`printonly'"), strlen( "`replace'"),strlen( "`debug'"), st_local("followurl"), "`savecontents'");
end

mata

	real scalar todataframe(string scalar url, string scalar  colnames, string scalar varnames, string scalar selector, real scalar limit, real scalar offset, real scalar printonlyf,  real scalar overwritef, real scalar debugf, string scalar savetofile, string scalar followurl,  real scalar showresf) {

	
	string scalar todf(string scalar url){
		pointer (class libjson scalar) scalar root
		root = libjson::webcall("http://www.grahamimac.com/ridingmetro/data.js","")
		if (root) {
			res = root->getString( libjson::parseSelector("Sunday") ,"")
			return(res)
		}
		else return(J(1,0,""));
	}
	
	string scalar todf(string scalar url){
		pointer (class libjson scalar) scalar root
		root = libjson::webcall("http://www.grahamimac.com/ridingmetro/data.js","")
		return(root)
	}	

	real scalar todf(string scalar url){
		pointer (class libjson scalar) scalar root
		pointer (class libjson scalar) scalar result
		pointer (class libjson scalar) scalar firstrow
		string rowvector varnames
		string scalar countres
		real scalar countreal
		real scalar pagelimit
		real scalar pages
		real scalar numvars
		pagelimit=100
		root=libjson::webcall(url ,"");
		countres = root->getString("count", "")
		numrecs = strtoreal(countres)
		pages = round(numrecs/pagelimit) + 1
		result = root->getNode("results")
		if (pages!=.) {
			firstrow = result->getArrayValue(1)
			varnames = firstrow->listAttributeNames(1)
			
		} 
		else {
			return(1)
		}
	}
	result=todf("https://ui-research.github.io/education-data-package-stata/example_json.json")

end