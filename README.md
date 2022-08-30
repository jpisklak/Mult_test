# A Fun Multiplication Table Test using R!
The R script *MultTest.R* contains a function ```multTest()``` that will run a nifty test of your ability to complete a multiplication table of any size.  The function takes certain arguments (described below) but will work fine without specifying any.  Simply load the script: ```source("MultTest.R")``` and run the function ```multTest()```.

The function will ask you to specify the size of the multiplication table you want to test.  For example, if you input "5", it will test a 5 x 5 table.  A comma seperated values data file with your results will be saved into a data folder that is created when you complete the test.  

Every time you complete the test, a plot will be gernerated that combines all of the existing data of previous attempts.  This will allow you to see your learning/performance over time.

To make the test "fun", other R packages from the CRAN are employed.  They will be installed and loaded automatically with the function.

### Optional Arguments

id = A unique identifier (string or numeric) for the data file and plot.
tz = Timezone specification.  Input a Olson timezone ID as a string.  Default is "UTC".
show_table = Displays a multiplication table in the console each time you get a question wrong.  Takes a logical value.  Default is FALSE.
save_result = Logical value dictating whether you want to save an attempt's data. Default is TRUE.
seed = Seed input to determine random number generation.  Specifying a integer value will ensure that the same question ordering is used every attempt.

CRAN Packages used:
"beepr","cowsay","praise", "plyr", "ggplot2", "lubridate"
