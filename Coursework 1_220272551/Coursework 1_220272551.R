#' ---
#' title: Time Series Week NNN
#' author: You
#' date: Today
#' ---

# 1. R Scratchpad ------------------------------------------------------------
#   You will only write in R Markdown for code and results
#   that are more or less finalised.
#   In the meantime, you can use this R scratchpad.
#   Delete all this text and write your own code
#   Don't forget to add explanatory comments
#   And to separate out different bits with headings or
#   subheadings

# 2. Use Sectioning ----------------------------------------------------------
#   Comment lines start with #, they are not read by R
#   If you end comment lines with space and four minus signs -
#   they will be interpreted as section headings.
#   You can add more - to visually separate sections.
#   CTRL+SHIFT+R / ⌘+SHIFT+R creates a new section and adds the hyphens.
#
#   These sections are accessible in
#     - the drop-down list on the bottom left of the scripting area,
#       ALT+SHIFT+J / ⌘+SHIFT+J brings it up
#   and
#     - the outline section on the top-right corner of the scripting area
#       CTRL+SHIFT+O / ⌘+SHIFT+O brings it up

## 2.1 Subsection -----------------------------------
#   You can also have subsections
#   RStudio does not treat them differently from sections
#   but if you add a extra #, number or spaces they will look
#   different in the outline section.
#   This makes it easier to navigate your R file
#   I use less hyphens for subsections to help visually

### 2.1.1 Subsection -------------------
#   And sub-subsections,...

# 3. Folding sections -----------------------------------------------------
#   You can fold sections by clicking on the little grey down-arrow on the left
#   of the section heading. Or hitting ALT+L/⌘+ALT+L
#   This is useful to hide sections you are not working on
#   SHIFT+ALT+L / ⌘+SHIFT+⌥+L unfolds the section
#   ALT+O / ⌘+⌥+O folds all sections
#   SHIFT+ALT+O / ⌘+SHIFT+⌥+O unfolds all sections

# 4. Etiquette ------------------------------------------------------------
#   It is a good idea (valued in any business environment) to have a certain
#   etiquette when writing code (or anything else really).
#   For instance, I write a blank line before a section heading and not after
#   You can choose your own style, but be consistent, and have the least
#   amount of random variations in your style as possible.




# project ------------------------------------------

# Read CSV file
data <- read.csv("data/Dota 2 - Steam Charts.csv")
head(data) # View the first columes of data

# CVS has months in a format like "July 2012"
# Convert these into Date

# Sometimes occurs <NA>
# This because R’s current locale doesn’t recognize the English month name like "July"
# we need to force an English-based locale firstly (on windows):
Sys.setlocale("LC_TIME", "English_United States.1252")
# as.Date(as.yearmon("July 2012", format = "%B %Y"))

# Then we can continues dealing with data
data$Month <- zoo::as.Date(zoo::as.yearmon(data$Month, format = "%B %Y"))
# Convert the values of Peak.Players to numeric
data$Peak.Players <- as.numeric(gsub(",", "", data$Peak.Players))

colnames(data) <- c("ds", "y")
data <- data
head(data) # view the first columns of data

dota2.df = data.frame(data)
head(dota2.df)

# Weekly and daily seasonality is disable Since my data is monthly, improve the code)
m = prophet::prophet(dota2.df,
             yearly.seasonality = TRUE,
             weekly.seasonality = FALSE,
             daily.seasonality = FALSE)
f = prophet::make_future_dataframe(m, periods = 12, freq = "month")
p = predict(m, f)
plot(m,p)

# Check the structure to confirm the type of data
str(dota2.df)

# Check the summary
summary(dota2.df)

# Visualize the data
library(ggplot2)

ggplot(dota2.df, aes(x = ds, y = y)) + # 'ds' as x-axis and 'y' as y-axis
    geom_line() + # Add a line connecting data points
    geom_point() + # Draw a point at each data value
    labs(title = "Dota 2 Monthly Peak Players",
         x = "Date",
         y = "Peak Players") +
    theme_minimal()
?ggplot
