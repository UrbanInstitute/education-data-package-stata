# Changelog for educationdata Stata Package

### 0.0.4

- Skips validity checks for variable names if the endpoint returns no formatted variables, so no error is thrown that stops the program
- Removes API endpoints that are hidden because they are not yet available, from the Stata help file
- Fixes an error thrown when the length of the variable value definition is longer than 32 characters
- Removes the Stata "clear" command and returns an error if the user already has a dataset in memory
- Adds compression to the dataset after it is fully downloaded
- Modifies time estimate language to be more sensible English
- Adds a col() option to only keep certain variables once downloaded
- 

### 0.0.3

- Fixes the error that stopped the program when an API call returns no results

### 0.0.2

- Adding formats "-1", "-2", and "-3" to all numeric variables without a format value
- Providing a more useful time range estimate, given Stata can only measure the time when the program starts
- Printing more detailed progress to the console for the user when the data are downloading

### 0.0.1

Hello world!