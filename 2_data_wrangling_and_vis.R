# ---
# title: 2. Data Wrangling and Visualisation
# author: Justin Chun-ting Ho
# last updated: 12 Jun 2021
# ---

####################################################################################
## Data Manipulation using dplyr                                                  ##
####################################################################################
# We're going to learn some of the most common `dplyr` functions:
# - `select()`: subset columns
# - `filter()`: subset rows on conditions
# - `mutate()`: create new columns by using information from other columns
# - `group_by()` and `summarize()`: create summary statistics on grouped data
# - `arrange()`: sort results

# Set Up
library(tidyverse)
scotelection <- read_csv("scotelection2021.csv")

# preview the data
View(scotelection)

####################################################################################
## Selecting columns and filtering rows                                           ##
####################################################################################
# To select columns of a data frame, use `select()`.
# The first argument is the dataframe and the subsequent are the columns to keep.
select(scotelection, likes, comments, shares)

# To choose rows based on a specific criteria, use `filter()`:
filter(scotelection, snsname == "Scottish National Party (SNP)")


####################################################################################
## Pipes                                                                          ##
####################################################################################
# What if you want to select and filter at the same time?
# There are three ways to do this: use intermediate steps, nested functions, or pipes.

# Intermediate steps
scotelection2 <- filter(scotelection, snsname == "Scottish National Party (SNP)")
scotelection_snp <- select(scotelection2, likes, comments, shares)

# Nest functions (i.e. one function inside of another)
scotelection_snp <- select(filter(scotelection, snsname == "Scottish National Party (SNP)"), likes, comments, shares)

## Pipes
# - take the output of one function and send it directly to the next
# - `%>%`
# - require the `magrittr` package
# - you can type the pipe with 'Ctrl' + 'Shift' + 'M' ('Cmd' + 'Shift' + 'M' for Mac)

scotelection %>%
  filter(snsname == "Scottish National Party (SNP)") %>%
  select(likes, comments, shares)

# If we want to create a new object with this smaller version of the data, we
# can assign it a new name:

scotelection_snp <- scotelection %>%
  filter(snsname == "Scottish National Party (SNP)") %>%
  select(likes, comments, shares)

scotelection_snp


########## Exercise ########## 
# Using pipes, subset the `scotelection` data to include data points
# where the post type were photo (`Photo`)
# and retain only the columns `likes` and `postlink`.

############################## 

####################################################################################
## Mutate                                                                         ##
####################################################################################

# Create new columns based on the values in existing columns

# We might be interested in the ratio of shares and likes:
scotelection %>%
  mutate(like_share_ratio = shares / likes)

# Or the total engagement:
scotelection %>%
  mutate(total_engagement = shares + likes + comments)

####################################################################################
## Split-apply-combine data analysis and the summarize() function                 ##
####################################################################################

# Many data analysis tasks can be approached using the *split-apply-combine* paradigm:
# 1. split the data into groups
# 2. apply some analysis to each group
# 3. combine the results.

# `group_by()` is often used together with `summarize()`, which collapses each
# group into a single-row summary of that group.  `group_by()` takes as arguments
# the column names that contain the categorical variables for which you want
# to calculate the summary statistics.

#So to compute the average likes by party:
scotelection %>%
  group_by(snsname) %>%
  summarize(mean_likes = mean(likes))

# You can also group by multiple columns:
scotelection %>%
  group_by(snsname, type) %>%
  summarize(mean_likes = mean(likes))

# You can also summarize multiple variables at the same time
scotelection %>%
  group_by(snsname, type) %>%
  summarize(mean_likes = mean(likes),
            mean_comments = mean(comments))

# You can rearrange the result of a query to inspect the values.
scotelection %>%
  group_by(snsname, type) %>%
  summarize(mean_likes = mean(likes),
            mean_comments = mean(comments)) %>% 
  arrange(mean_likes)

# To sort in descending order, add the `desc()` function.
scotelection %>%
  group_by(snsname, type) %>%
  summarize(mean_likes = mean(likes),
            mean_comments = mean(comments)) %>% 
  arrange(desc(mean_likes))

####################################################################################
## Counting                                                                       ##
####################################################################################
# When working with data, we often want to know the number of observations found
# for each factor or combination of factors.

scotelection %>%
  count(type)

# `count()` provides the `sort` argument
scotelection %>%
  count(type, sort = TRUE)

########## Exercise ########## 
# 1. Use `group_by()` and `summarize()` to find the mean, min, and max
# number of shares for each party. Also add the number of
# observations (hint: see `?n`).
# 2. What was the highest likes in each month?
# Tips: Attach the lubridate library using 'library(lubridate)' and
# use the following code: mutate(month = month(datetime))
############################## 
scotelection %>% mutate(month = month(datetime)) %>% group_by(month) %>% summarise(max(likes))

####################################################################################
## Data visualisation with ggplot2                                                ##
####################################################################################
# We start by loading the required package.
library(ggplot2)

# Building plots with **`ggplot2`** is typically an iterative process. 
# We start by defining the dataset we'll use:
ggplot(data = scotelection)

# lay out the axis(es), for example we can set up the axis for the Comments count ('comments'):
ggplot(data = scotelection, aes(x = comments))

# and finally choose a geom
ggplot(data = scotelection, aes(x = comments)) +
  geom_histogram()

# We could change the binwidth by adding arguments
ggplot(data = scotelection, aes(x = comments)) +
  geom_histogram(binwidth = 100)

# We could add a line showing the mean value by adding a geom
mean_likes <- mean(scotelection$likes)
mean_comments <- mean(scotelection$comments)
mean_shares <- mean(scotelection$shares)

ggplot(data = scotelection, aes(x = comments)) +
  geom_histogram(binwidth = 100) +
  geom_vline(xintercept=mean_comments, color = "red", linetype = "dashed")

# We could change color by adding arguments (fill means color of the filling in ggplot2)
ggplot(data = scotelection, aes(x = comments)) +
  geom_histogram(binwidth = 100,  fill = "red")

# How about making it transparent?
ggplot(data = scotelection, aes(x = comments)) +
  geom_histogram(binwidth = 100, fill = "red", alpha = 0.8)

########## Exercise 4 ########## 
# Using the codes above, create a histogram for Likes count ('likes')

##############################


####################################################################################
## Visualising two categorical variables                                          ##
####################################################################################

# We could create a bar plot:
ggplot(scotelection, aes(x = snsname)) + 
  geom_bar() +
  coord_flip()

# We could also create a plot for two categorical variables
# We color the bar by the sentiment of the posts
ggplot(scotelection, aes(x = snsname, fill = type)) + 
  geom_bar() +
  coord_flip()

# We can change how these bars are placed, 
# for example 'position = "dodge"' will place them side by side
ggplot(scotelection, aes(x = snsname, fill = type)) + 
  geom_bar(position = "dodge") +
  coord_flip()

# If we use 'position = "fill"', all bar will strech out to fill the whole y axis
# The y axis then become proportion
ggplot(scotelection, aes(x = snsname, fill = type)) + 
  geom_bar(position = "fill") +
  coord_flip() +
  labs(y = "proportion")

####################################################################################
## Visualising two continuous variables                                           ##
####################################################################################

# Creating a plot for two continuous variables (comments and likes):
ggplot(data = scotelection, aes(x = comments, y = likes))

# We could use geom_point() for scatter plot
ggplot(data = scotelection, aes(x = comments, y = likes)) +
  geom_point()

# Again, you can add the mean values 
ggplot(data = scotelection, aes(x = comments, y = likes)) +
  geom_point() +
  geom_vline(xintercept = mean_comment) +
  geom_hline(yintercept = mean_like)

# You can even add the same geom twice, with different values on the x and y axes
ggplot(data = scotelection, aes(x = comments, y = likes)) +
  geom_point() +
  geom_point(aes(x = mean_comment, y = mean_like), color = "red", size = 6)

# Use the argument 'color = "red"' for red dots
ggplot(data = scotelection, aes(x = comments, y = likes)) +
  geom_point(color = "red")

# Or coloring them by post type
ggplot(data = scotelection, aes(x = comments, y = likes)) +
  geom_point(aes(color = type)) 

# There are many things you can do by adding layers into the ggplot
# You could log them.
# PS: You will see a warning message, don't worry, it is just because our data contain zeros
ggplot(data = scotelection, aes(x = comments, y = likes, color = type)) +
  geom_point(alpha = 0.5) + # I made the points transparent for visiblity
  scale_x_log10() +
  scale_y_log10()


# Or fit a line
ggplot(data = scotelection, aes(x = comments, y = likes, color = type)) +
  geom_point(alpha = 0.5) +
  scale_x_log10() +
  scale_y_log10() +
  geom_smooth(method = "lm", se = FALSE)

# And add labels and legend
ggplot(data = scotelection, aes(x = comments, y = likes, color = type)) +
  geom_point(alpha = 0.5) +
  scale_x_log10() +
  scale_y_log10() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Comments Count", y = "Likes Count",
       title = "Comments and Likes",
       subtitle = "One post per dot")

# Change the theme by adding theme_bw()
ggplot(data = scotelection, aes(x = comments, y = likes, color = type)) +
  geom_point(alpha = 0.5) +
  scale_x_log10() +
  scale_y_log10() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Comments Count", y = "Likes Count",
       title = "Comments and Likes",
       subtitle = "One post per dot") + 
  theme_bw()

# To save your graph, you could first define the graph as an object then use ggsave:
myplot <- ggplot(data = scotelection, aes(x = comments, y = likes, color = type)) +
  geom_point(alpha = 0.5) +
  scale_x_log10() +
  scale_y_log10() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Comments Count", y = "Likes Count",
       title = "Comments and Likes",
       subtitle = "One post per dot")
ggsave(myplot, filename = "my_plot.png")

# Facet to make small multiples
ggplot(data = scotelection, aes(x = comments, y = likes)) +
  geom_point(alpha = 0.5) +
  scale_x_log10() +
  scale_y_log10() +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(vars(snsname))

########## Exercise 5 ########## 
# Make a scatter plot of shares by comments count, log both axes,
# color them by party, change shape by post type (adding 'shape = type' in aes())
##############################


####################################################################################
## It's about time                                                                ##
####################################################################################
# We need this package
# install.packages("scales")
# install.packages("lubridate")
library(scales)
library(lubridate)

# To plot a time series, the first thing you have to do is to transform your data into time/date format
# There are many formats for time and date, but the simpliest way would probably be:

scotelection$date <- as.Date(scotelection$datetime) # Defining a new column called 'date'

# Simply plot the same scatter point, using 'date' as the x axis
ggplot(data = scotelection, aes(x = date, y = likes, color = snsname)) +
  geom_point()

# Changing the x scale using scale_x_date()
ggplot(data = scotelection, aes(x = date, y = likes, color = snsname)) +
  geom_point() +
  scale_x_date(labels = date_format("%m/%y"), date_breaks = "1 month")

# We could use line
ggplot(data = scotelection, aes(x = date, y = likes, color = snsname)) +
  geom_line() +
  scale_x_date(labels = date_format("%m/%y"), date_breaks = "1 month")

# Or use geom_smooth to fit a local regression line
ggplot(data = scotelection, aes(x = date, y = likes, color = snsname)) +
  geom_smooth(method = 'loess') +
  scale_x_date(labels = date_format("%m/%y"), date_breaks = "1 month")

# You could add two geoms on top of each other
ggplot(data = scotelection, aes(x = date, y = likes, color = snsname)) +
  geom_smooth(method = 'loess') +
  geom_point(alpha = 0.3) +
  scale_x_date(labels = date_format("%m/%y"), date_breaks = "1 month")

# You could also truncate the y axis (use with caution!)
ggplot(data = scotelection, aes(x = date, y = likes, color = snsname)) +
  geom_smooth(method = 'loess') +
  geom_point(alpha = 0.3) +
  scale_x_date(labels = date_format("%m/%y"), date_breaks = "1 month") +
  ylim(c(0, 3000))

# For some plots, it might be easier if you transform the data in advance
# To do so, we have to learn a few things:
# '%>%' is a pipping operator, it acts as a pipe line: 
# the output before the pipping operator will feed into the next function as the input

# We also need the following functions:
# group_by() is a function to split the data into groups
# summarise() is a function to make calculation and put the result into a new variable

library(dplyr)

scotelection %>% # Take 'scotelection', put into a pipe
  group_by(snsname, date=floor_date(date, "month")) %>% # split the data by snsname and by month
  summarise(total_likes = sum(likes)) -> # calculate total likes by taking the sum of likes count
  plot_data # assign to the new object 'plot_data'

# Have a look at the transformed data
ggplot(data = plot_data, aes(x = date, y = total_likes, color = snsname)) +
  geom_line()

########## Exercise 6 ########## 
# Using the above codes, aggregate comment counts by month.
# Plot an area plot (selection a sensibile position)

# TIPS:
# plot_data <- snp %>% 
#   group_by(type, date=floor_date(date, "month")) %>%
#   summarise(###### = sum(#######))  # Change the ########### into the variable names
##############################


####################################################################################
## What's next?                                                                   ##
####################################################################################

# You won't be able to learn everything about R in three hours,
# but I hope this workshop would give you a head start in your progarmming journey.
# If you would like to learn more, there are plenty (free) resources online:
# https://www.tidyverse.org/
# http://www.cookbook-r.com/
# https://socviz.co/