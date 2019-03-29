# Changelog for educationdata Stata Package

#### 0.2.6 (Development Version, not yet released) 

- 

#### 0.2.5  (Current Stable Version)

- Updated package help to include new endpoints from latest release

#### 0.2.4

- Remove instructions to quote strings in subset, clarify the no space requirement between = in documentation.

#### 0.2.3 

- Add multiple year examples, move examples to the top of the documentation, per user feedback

#### 0.2.2

- Add option to allow users to clear cache, for recent data updates when the technical team has not yet cleared the cache on the server

#### 0.2.1

- More clear instructions in the documentation and program for the csv option, specifically setting the working directory
- Clear documentation on additional resources available in the Stata help file
- Harmonize errors for invalid option selection so they are consistent, display correct list of options on error to help user
- Fix error subsetting grade options for csv
- Add mode=stata argument to all URLs to track usage of API from Stata

#### 0.2.0

- Add csv option to allow users of larger extracts to download from the CSV
- Improve error messages, fix error message errors for fields in which the user types invalid values
- Clear up documentation to add description of clear, csv options

#### 0.1.8

- Fix year parsing error in api-endpoints, that changed normal dash to ndash, to correctly parse years

#### 0.1.7 

- Fix year parsing error in api-endpoints, that changed mdash to normal dash, to correctly parse years

#### 0.1.6

- Small wording improvements to error messages
- Add staging option to give advanced users the option to test against the staging server, which may contain errors, bugs, or issues (do not use for normal purposes)

#### 0.1.5

- Functional change to underlying code to make it easy to change the base URL for launch
- Correct allowed values for grade and level_of_study in help file
- Add error messages when a list of multiple filtered values is not valid
- Update float values to double, so that short decimals are stored efficiently, accurately and are easier to view

#### 0.1.4

- Adds option to specify pre-k and k grades as "-1" and "0", as specified in the documentation, adds this to Stata help
- Fixes error in time estimate that produced blanks if the first API call had no records
- Adds the ability to get the variable names, labels, and values only via "meta" or "metadata" option

#### 0.1.3 

- Adds totals example to documentation, clarifies values for grade and level_of_study, and explains the use of 99 for totals only queries
- Fixes year parsing error that did not correctly give all years of data for endpoints that skip years, so all data should now be returned for these calls
- More helpful error message telling the user the specific option value that caused the error so they can correct it
- Literal strings showing up as "" in Stata datasets should now all be blank

#### 0.1.2 

- Fixes to documentation to ensure line-wraps are included
- Fixes to documentation to include working FIPS example
- Removes debugging statement from function that printed out the URL of each endpoint

#### 0.1.1 

- Update documentation to reflect that you do not need to use quotes around the `subset()` and `columns()` arguments
- Adds functionality that checks whether libjson is installed and installs it on first command if it is not
- Adds a "clear" option to the command to clear your current data in memory before adding additional data
- Properly formats variables whose names are not the same as their format names, such as Yes/No variables and Grade Offered
- Fixes a bug that didn't allow grade selection for grades 1-12 and total (99), now short grade=1 selection should work properly

#### 0.1.0

- Skips validity checks for variable names if the endpoint returns no formatted variables, so no error is thrown that stops the program
- Removes API endpoints that are hidden because they are not yet available, from the Stata help file
- Fixes an error thrown when the length of the variable value definition is longer than 32 characters
- Removes the Stata "clear" command and returns an error if the user already has a dataset in memory
- Adds compression to the dataset after it is fully downloaded
- Modifies time estimate language to be more sensible English
- Adds a col() option to only keep certain variables once downloaded
- Uses hard coded "short names" for college-university, school-districts, and schools
- Orders the datasets in the Stata help file in the order specified by the API
- Throws a helpful error when the user does not select a valid dataset name
- Labels no longer have spaces before and after hyphens
- Add feature that validates required options, and allows for shortened grade numbers (e.g., pk OR grade-pk) for grade inputs

#### 0.0.3

- Fixes the error that stopped the program when an API call returns no results

#### 0.0.2

- Adding formats "-1", "-2", and "-3" to all numeric variables without a format value
- Providing a more useful time range estimate, given Stata can only measure the time when the program starts
- Printing more detailed progress to the console for the user when the data are downloading

#### 0.0.1

Hello world!