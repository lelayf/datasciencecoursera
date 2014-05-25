Exploratory Data Analysis - Course Project 2
============================================

Let's first load the datasets as described in the assignment.


```r
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
    destfile = "exdata-NEI.zip", method = "curl")
unzip("exdata-NEI.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
```


#### Question 1

Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 

First let's create a specific dataset to compute total $PM_2.5$ emission from all sources per year.


```r
EmissionsByYear <- aggregate(NEI$Emissions, list(year = NEI$year), sum)
EmissionsByYear
```

```
##   year       x
## 1 1999 7332967
## 2 2002 5635780
## 3 2005 5454703
## 4 2008 3464206
```


Now let's use the base plotting system to make a plot showing the total  for each of the years 1999, 2002, 2005, and 2008.


```r
png(filename = "plot1.png", width = 480, height = 480, units = "px", res = 72, 
    bg = "white")
plot(EmissionsByYear$year, EmissionsByYear$x, xlab = "Year", ylab = "Total emissions", 
    pch = 10)
title(main = "Total emissions across all sources")
```


This graph shows the total measured emissions across all sources have decreased from 1999 to 2002, 2002 to 2005 and 2005 to 2008. The total emissions range between 3,464,206 to 7,332,967. One question comes to my mind : are we comparing measurements from the same sources for all these years? 


```r
NEI$SCC <- as.factor(NEI$SCC)
str(NEI$SCC)
```

```
##  Factor w/ 5386 levels "10100101","10100102",..: 26 27 30 88 96 99 100 155 159 162 ...
```


So we have 5386 sources in our entire dataset. Let's create a list of all sources used every year.


```r
sources1999 <- droplevels(unique(NEI[NEI$year == "1999", "SCC"]))
str(sources1999)
```

```
##  Factor w/ 4007 levels "10100101","10100102",..: 21 22 24 63 71 74 75 126 130 133 ...
```

```r
sources2002 <- droplevels(unique(NEI[NEI$year == "2002", "SCC"]))
str(sources2002)
```

```
##  Factor w/ 4373 levels "10100101","10100102",..: 143 158 1733 3535 141 152 153 3231 3263 3264 ...
```

```r
sources2005 <- droplevels(unique(NEI[NEI$year == "2005", "SCC"]))
str(sources2005)
```

```
##  Factor w/ 4277 levels "10100101","10100102",..: 3324 2886 3283 147 2095 2657 3576 3388 206 220 ...
```

```r
sources2008 <- droplevels(unique(NEI[NEI$year == "2008", "SCC"]))
str(sources2008)
```

```
##  Factor w/ 3668 levels "10100101","10100201",..: 2641 2999 2 83 2247 3102 2215 8 206 2554 ...
```


Big news, our factors for sources by year have a different number of levels (4007, 4373, 4277 and 3668 resp.). So the raw dataset does not allow us to use the same observational units from year to year. We should make comparisons based on the sources common to all measured years.


```r
inter1999_2002 <- intersect(sources1999, sources2002)
inter2005_2008 <- intersect(sources2005, sources2008)
sourcesCommonToAllYears <- intersect(inter1999_2002, inter2005_2008)
str(sourcesCommonToAllYears)
```

```
##  chr [1:2577] "10100401" "10100404" "10100501" "10200401" ...
```


We are now down to 2577 sources common to all years and the number of usable observations has nearly halved from 6.5+ million to 3 million measurements.


```r
NEIWithCommonSourcesOnly <- NEI[NEI$SCC %in% sourcesCommonToAllYears, ]
TotalEmissionsWithCommonSourcesOnly <- aggregate(NEIWithCommonSourcesOnly$Emissions, 
    list(year = NEIWithCommonSourcesOnly$year), sum)
plot(TotalEmissionsWithCommonSourcesOnly$year, TotalEmissionsWithCommonSourcesOnly$x, 
    xlab = "Year", ylab = "Total emissions", pch = 10)
title(main = "Total emissions across sources common to all years")
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7.png) 

```r
dev.off()
```

```
## quartz_off_screen 
##                 3
```


The plot also shows a decreasing profile but with a stronger relative drop from 1999 to 2002. Total emissions range between 2,888,186 and 6,037,076.




