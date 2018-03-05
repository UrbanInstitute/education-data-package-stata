/*** DO NOT EDIT THIS LINE -----------------------------------------------------
Version: 0.0.1
Title: numplusone
Description: input a number, it will add one to it and print the output
[Education Data Package](http://www.github.com/UI-Research/education-data-package-stata) website
----------------------------------------------------- DO NOT EDIT THIS LINE ***/

prog define numplusone

	args num

	display `num' + 1

end
