# ---
# title: 1. Introduction to R
# author: Justin Chun-ting Ho
# last updated: 12 Jun 2021
# ---

####################################################################################
## Installing packages                                                            ##
####################################################################################
install.packages("tidyverse")

####################################################################################
## Creating objects in R                                                          ##
####################################################################################

# You can get output from R simply by typing math in the console.
# 
# However, to do useful and interesting things, we need to assign values to
# objects. To create an object, we need to give it a name followed by the
# assignment operator `<-`, and the value we want to give it:
# 
# In RStudio, typing 'Alt' + '-' will write `<- ` in a single keystroke in a
# PC, while typing 'Option' + '-' does the same in a Mac.
# 
# Objects Name:
# - Any name such as `x`, `current_temperature`, or `subject_id`
# - Explicit and not too long. 
# - Cannot start with a number (`2x` is not valid, but `x2` is).
# - Case sensitive
# - Names of fundamental functions can't be used (eg 'if', 'else', 'for')
# - Best to not use other function names (e.g., `c`, `T`, `mean`, `data`, `df`, `weights`)
# - Recommended to use nouns for object names, and verbs for function names.
# - Popular coding style guides: Google's (https://google.github.io/styleguide/Rguide.xml) and the tidyverse's (http://style.tidyverse.org/).

# When assigning a value to an object, R does not print anything. You
# can force R to print the value by using parentheses or by typing
# the object name:

area_hectares <- 1.0    # doesn't print anything
(area_hectares <- 1.0)
area_hectares

# Now that R has `area_hectares` in memory, we can do arithmetic with it. 
# For instance, we may want to convert this area into acres 
# (area in acres is 2.47 times the area in hectares):

2.47 * area_hectares

# We can also change an object's value by assigning it a new one:
area_hectares <- 2.5
2.47 * area_hectares

# Assigning a value to one object does not change the values of
# other objects  For example, let's store the plot's area in acres
# in a new object, `area_acres`:

area_acres <- 2.47 * area_hectares

# and then change `area_hectares` to 50.

area_hectares <- 50

########## Question: ########## 
# What do you think is the current content of the object `area_acres`? 123.5 or 6.175?

###############################

####################################################################################
## Comments                                                                       ##
####################################################################################
# All programming languages allow the programmer to include comments in their code. 
# To do this in R we use the `#` character.
# Anything to the right of the `#` sign and up to the end of the line is treated 
# as a comment and is ignored by R. You can start lines with comments
# or include them after any code on the line.

area_acres <- area_hectares * 2.47	# convert to acres
area_acres				# print land area in acres.

## Tips:
# RStudio makes it easy to comment or uncomment a paragraph: after selecting the
# lines you  want to comment, press at the same time on your keyboard
# 'Ctrl' + 'Shift' + 'C'. 


########## Exercise 0 ########## 
# Create two variables `length` and `width` and assign them values.
# Create a third variable `area` and give it a value based on 
# the current values of `length` and `width`.

##############################

####################################################################################
## Vectors and data types                                                         ##
####################################################################################

## Vector
# - composed by a series of values, can be either numbers or characters. 
# - can be assigned using the `c()` function.

# A vector can contain characters. 
# For example, we can have a vector of the party that participate in 
# the 2021 Scottish Parliament election (`parties`):

parties <- c("Scottish National Party", "Scottish Conservatives", "Scottish Labour")
parties

# The quotes around "Scottish National Party", etc. are essential here. 
# Without the quotes R will assume there are objects called 
# "Scottish National Party", "Scottish Conservatives", "Scottish Labour". 
# As these objects don't exist in R's memory, there will be an error message.

# A vector can also contain numbers, we can create a vector of the seats they won:                            
seats <- c(63, 31, 24)
seats

# You can use the `c()` function to add other elements to your vector:
# Take the party names as an example
parties

parties <- c(parties, "Scottish Greens") # add to the end of the vector
parties

parties <- c("Scottish Liberal Democrats", parties) # add to the beginning of the vector
parties

# You could also use the slicing operater to get a part of a vector:
# Remember this time you only have to specify the index (not row and column) 
parties[1] # Get the first element
parties[1:2] # From the first to the second
parties[-1] # everything except the first

# Vectors are one of the many **data structures** that R uses. 
# Other important ones are data frames (`data.frame`), lists (`list`), 
# matrices (`matrix`), factors (`factor`) and arrays (`array`).


####################################################################################
## Loading dataset as dataframes                                                  ##
####################################################################################

# The following code will load a dataset into R's memory and stored an object named 'scotelection'.

scotelection <- read.csv("scotelection2021.csv", stringsAsFactors = FALSE)

# When assigning a value to an object, R does not print anything. 
# You can print the value by typing the object name:

scotelection

# However, print a large object directly is often not a good idea,
# as you can see, the output is simply too large to display in one page.
# Sometimes, you might even crash your R if the object is too large.
# To safely view a portion of an object, you could use the 'head()' function

## Functions:
# - Functions are "canned scripts"
# - (Pre)defined, or can be made available by importing R *packages*
# - A function usually gets one or more inputs called *arguments*
# - Can return a single value, and also a set of things, or even a dataset 

## Arguments:
# - can be anything (numbers, filenames, objects etc)
# - must be looked up in the documentation
# - Some functions take on a *default* value

# The 'head()' function will return the first sixth element of an object:
head(scotelection)

# We could also look at the help for this function using `?head`
?head

# We see that if we want a different size for the result, we can add an argument:
head(scotelection, n = 10)

# If you provide the arguments in the exact same order as they are defined you
# don't have to name them:
head(scotelection, 10)

########## Exercise 1 ########## 
# Using the 'tail()' function, find out the date of the last post in the dataset.
##############################

# Dataframes are representations of data in table format (like an Excel spreadsheet)
# There are functions to extract this information from dataframes.
# Here is a non-exhaustive list of some of these functions:
# 
# Size:
dim(scotelection) # returns number of rows, number of columns
nrow(scotelection) # returns the number of rows (post)
ncol(scotelection) # returns the number of columns (var)

# Summary:
names(scotelection) # name of all variables
str(scotelection) # structure of the object and information about the class, length and content of each column
summary(scotelection) # summary statistics for each column

# To extract a subset of the dataframe, we could use the slicing operater '[' and ']'
# Remember we have to specify the index for both the row and column:

scotelection[1,1] # First row, first column
scotelection[1,] # Frist row, all columns (leaving it empty means getting everything)
scotelection[,1] # Frist column, all row (leaving it empty means getting everything)
scotelection[1:6,] # The first six rows, this is same as the 'head()'

# Dataframes are comprised of vectors

# Since dataframes are comprised of vectors, 
# We can extract the whole column as a vector using '$':
scotelection$date
scotelection$likes

# We could use functions to gain information from the vector
# For example, 'mean()' will gives us the mean, 'max()' will give us the maximun value
length(scotelection$likes)
max(scotelection$likes)
mean(scotelection$likes)
table(scotelection$type)

########## Exercise 2 ########## 
# Using the 'mean()' function, alter the codes below and calculate 
# the mean value of likes, comments, and shares.
# Put the result into the follow objects: 'mean_like', 'mean_comment', 'mean_share'

mean_like <- # Fill in your codes here #
mean_comment <- # Fill in your codes here #
# Fill in your codes here for 'mean_share' #

##############################

# For more advanced usage of functions, we could use 'which.max()' to identify the element that
# contains the maximum value
which.max(scotelection$likes)

# The result is 1661, meaning that the 1661st post of the dataset has the most likes.
# We can then use the slicing operator ('[' and ']') to find the post:
scotelection[1661, ]

# We can combine them into one single line:
scotelection[which.max(scotelection$likes), ]

########## Exercise 3 ########## 
# Find out which post has most comments and shares

# Tricky Question: Could you find out how to just extract the link?
# Tips: start with extracting all the links ('scotelection$post_link'),
# then use the index to select the one we want

##############################

####################################################################################
## Factors                                                                        ##
####################################################################################

## Factors:
# - represent categorical data
# - stored as integers associated with labels 
# - can be ordered or unordered. 
# - look like character vectors, but actually treated as integer vectors

# Once created, factors can only contain a pre-defined set of values, known as
# *levels*. By default, R always sorts levels in alphabetical order. For
# instance, if you have a factor with 2 levels:
party <- factor(c("Labour", "Conservatives", "Conservatives", "Labour"))
party

# R will assign `1` to the level `"Conservatives"` and `2` to the level `"Labour"`
# (because `C` comes before `L`, even though the first element in this vector is
# `"Labour"`). You can see this by using the function `levels()` and you can find
# the number of levels using `nlevels()`:

levels(party)
nlevels(party)

# Reordering
party
party <- factor(party, levels = c("Labour", "Conservatives"))
party # after re-ordering

# Converting a factor to a character vector
as.character(party)

# Converting factors where the levels appear as numbers to a numeric vector
# It's a little trickier!
# The `as.numeric()` function returns the index values of the factor, not its levels

year_fct <- factor(c(1990, 1983, 1977, 1998, 1990))
as.numeric(year_fct)                     # Wrong! And there is no warning...
as.numeric(as.character(year_fct))       # Works...

####################################################################################
## Renaming factors                                                               ##
####################################################################################
# When your data is stored as a factor, you can use the `plot()` function to get a
# quick glance at the number of observations represented by each factor level:

# pull out the party names from dataset
party <- as.factor(scotelection$snsname)

# bar plot of the number of post captured per party:
plot(party)

# There are 3 levels
levels(party)

# replace the fifth one with "SNP"
levels(party)[5] <- "SNP"
head(party)

plot(party)

########## Exercise ########## 
# * Rename “Scottish Conservatives”, "Scottish Green Party", "Scottish Labour Party", and "Scottish Liberal Democrats"
#   to “CON”, "GREEN", "LAB", and "LIBDEM" respectively.
# * Now that we have renamed the factor levels, 
#   can you recreate the barplot such that “SNP” is first?

##############################
