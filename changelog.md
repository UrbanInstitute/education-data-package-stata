# Changelog for educationdata Stata Package

#### 0.1.2 (Development Version, not yet released)

- 

#### 0.1.1 (Current Stable Version)

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