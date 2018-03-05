# Example

- http://haghish.com/statistics/stata-blog/reproducible-research/markdoc.php
ssc install markdoc, replace
ssc install weaver, replace
ssc install statax, replace
- Download example ado file - https://raw.githubusercontent.com/haghish/github/master/github.ado
- CD into download directory
markdoc github.ado, export(sthlp)
- It will give you an error, but the file will write out. File is named me.text, rename to the correct one.
- Produce a TOC manually - easy - here's an example - https://github.com/haghish/markdoc/blob/master/stata.toc
- Produce a PKG file manually - easy - here's an example - https://github.com/haghish/markdoc/blob/master/markdoc.pkg
- To install: net install numplusone, force from("D:/path/to/file")
- To uninstall: ado uninstall numplusone
- BUT instead of doing that, just cd to the directory and type: do numplusone.ado and that will register the command with Stata
- IMPORTANT - every time to change the program, you must run: "capture program drop numplusone" to drop it from memory, and then rerun: "do numplusone.ado" to reregister in memory
- To install once it's in the docs folder in Github, run: net install numplusone, from("https://ui-research.github.io/education-data-package-stata/")