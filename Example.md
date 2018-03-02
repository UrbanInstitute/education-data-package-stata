# Example

- http://haghish.com/statistics/stata-blog/reproducible-research/markdoc.php
ssc install markdoc, replace
ssc install weaver, replace
ssc install statax, replace
- Download example ado file - https://raw.githubusercontent.com/haghish/github/master/github.ado
- CD into download directory
markdoc github.ado, export(sthlp)
- It will give you an error, but the file will write out. File is named me.text, rename to the correct one.