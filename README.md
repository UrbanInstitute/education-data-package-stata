# Notes on building a Stata package, and using this one in general

- I couldn't figure out how to get the Markdoc Stata package to work, so I made the STHLP file manually - here's an example - https://github.com/haghish/github/blob/master/github.sthlp
- Produce a TOC manually - easy - here's an example - https://github.com/haghish/markdoc/blob/master/stata.toc
- Produce a PKG file manually - easy - here's an example - https://github.com/haghish/markdoc/blob/master/markdoc.pkg
- When testing, just cd to the directory and type: do educationdata.ado and that will register the command with Stata
- IMPORTANT - every time to change the program, you must run: "clear all" to drop it from memory, and then rerun: "do educationdata.ado" to reregister in memory
- To install once it's in the docs folder in Github, run: net install numplusone, from("https://ui-research.github.io/education-data-package-stata/")
- To install on your local computer, run: net install educationdata, force from("D:/Users/GMacDonald/Documents/education-data-package-stata/educationdata/")
- To uninstall, run: ado uninstall educationdata
- If you get the error "criterion matches more than one package", run: adoupdate Then run: ado uninstall educationdata
- Example call: educationdata using "college-university ipeds directory", sub("year=2011 cbsa=33860")