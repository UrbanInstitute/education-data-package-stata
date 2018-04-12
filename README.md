# Education Data Portal - Package for Stata

Welcome to the Education Data Portal Stata Package repository. You'll need an internet connection to install and use the package.

### Install the Package

If you don't have `libjson` installed, the package will prompt you to install it. Or, you can type `ssc install libjson`.

```stata
net install educationdata, replace from("https://ui-research.github.io/education-data-package-stata/")
```

If you have trouble with this command, uninstall any existing installations using the instructions below, close and re-open Stata, then re-run the command above.

### Testing the package

First, ensure you are connected to the internet. Then run one of the simpler examples, such as:

```stata
educationdata using "college-university ipeds directory", sub("year=2011 cbsa=33860")
```

### Uninstall the Package

```stata
ado uninstall educationdata
```

If you recieve the error `criterion matches more than one package` and you're running Stata 14 or newer, run the following:

```stata
adoupdate
ado uninstall educationdata
```

### Changes

To view the changes made to the package over time, see the [changelog](https://github.com/UI-Research/education-data-package-stata/blob/master/changelog.md).

## Personal notes on building a Stata package, and using this one in general

- I couldn't figure out how to get the Markdoc Stata package to work, so I made the STHLP file manually - here's an example - https://github.com/haghish/github/blob/master/github.sthlp
- Produce a TOC manually - easy - here's an example - https://github.com/haghish/markdoc/blob/master/stata.toc
- Produce a PKG file manually - easy - here's an example - https://github.com/haghish/markdoc/blob/master/markdoc.pkg
- When testing, just cd to the directory and type: do educationdata.ado and that will register the command with Stata
- IMPORTANT - every time to change the program, you must run: "clear all" to drop it from memory, and then rerun: "do educationdata.ado" to reregister in memory
- To install once it's in the docs folder in Github, run: net install educationdata, from("https://ui-research.github.io/education-data-package-stata/")
- To install on your local computer, run: net install educationdata, force from("D:/Users/GMacDonald/Documents/education-data-package-stata/educationdata/")
- To uninstall, run: ado uninstall educationdata
- If you get the error "criterion matches more than one package", run: adoupdate Then run: ado uninstall educationdata
- Example call: educationdata using "college-university ipeds directory", sub("year=2011 cbsa=33860")