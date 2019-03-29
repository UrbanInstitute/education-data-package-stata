# Education Data Portal - Package for Stata

Welcome to the [Education Data Portal](https://educationdata.urban.org) Stata Package repository. You'll need an internet connection to install and use the package.

### Install or Update the Package

*Before you install the package, run the following:*

```stata
ssc install libjson
```

Then, the following command will install, or if the package is already installed, update the education data package.

```stata
net install educationdata, replace from("https://urbaninstitute.github.io/education-data-package-stata/")
```

If you are having trouble, first try running the following:

```stata
adoupdate
```

If you're still having trouble with this command, uninstall any existing installations using the instructions below, close and re-open Stata, then re-run the commands above.

#### Error r(672) - Server refused to send file OR similar errors in installation

If you run into the error `server refused to send file` or similar errors, your firewall may be blocking access to Stata's ability to download content, or Stata may have a conflict with other programs installed on your operating system or in your organization. Note that this may also block your ability to download data via an API, so this may not solve all concerns, but in most tested cases, this method should solve the problem. First, download the zip file of the package, by copying the following to your browser:

```
https://urbaninstitute.github.io/education-data-package-stata/educationdata.zip
```

Unzip the file, and do one of two things:

1) Type `. personal` in Stata, and note the location of your personal ado directoy, i.e. `C:\ado\personal\`
2) Move all the extracted files from the zip file to that personal directory

OR

1) Note the filepath of the extracted files, e.g., `D:/Users/Username/Downloads/educationdata/`
2) Type `net install educationdata, force from("D:/Users/Username/Downloads/educationdata/")` in Stata, replacing the path in the `from()` command with the filepath you noted in step 1

### Testing the package

First, ensure you are connected to the internet. Then run one of the simpler examples, such as getting the metadata for a dataset:

```stata
educationdata using "college ipeds directory", meta
```

Next, try downloading a subset of the dataset:

```
educationdata using "college ipeds directory", sub(year=2011 fips=12)
```

Use the `help` command to read about all of the commands and dataset options:

```
help educationdata
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

To view the changes made to the package over time, see the [changelog](https://github.com/UrbanInstitute/education-data-package-stata/blob/master/changelog.md).

### License

This software is licensed under the [MIT License](https://github.com/UrbanInstitute/education-data-package-stata/blob/master/license.txt).
