Exploratory Data Analysis - Course Project 2
============================================

Let's first download the datasets as described in the assignment.

```
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",destfile="exdata-NEI.zip",method="curl")
unzip("exdata-NEI.zip")
```


```r
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
```


### Question 1

Have total emissions from $PM_{2.5}$ decreased in the United States from 1999 to 2008? 

First let's create a specific dataset to compute total $PM_{2.5}$ emission from all sources per year.


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
dev.off()
```

```
## pdf 
##   2
```


<img src="plot1.png" />

This graph shows the total measured emissions across all sources have decreased from 1999 to 2002, 2002 to 2005 and 2005 to 2008. The total emissions range between 3,464,206 to 7,332,967. *One question comes to my mind* : are we comparing measurements from the same sources for all these years? 


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
png(filename = "plot1bis.png", width = 480, height = 480, units = "px", res = 72, 
    bg = "white")
plot(TotalEmissionsWithCommonSourcesOnly$year, TotalEmissionsWithCommonSourcesOnly$x, 
    xlab = "Year", ylab = "Total emissions", pch = 10)
title(main = "Total emissions across sources common to all years")
dev.off()
```

```
## pdf 
##   2
```


<img src="plot1bis.png" />

The plot also shows a decreasing profile but with a stronger relative drop from 1999 to 2002. Total emissions range between 2,888,186 tons and 6,037,076 tons.

*For the remaining part of the assignment I will use the datasets filtered on sources active all year to establish proper comparisons.*

### Question 2

Have total emissions from $PM_{2.5}$ decreased in the *Baltimore City*, Maryland (fips == "24510") from 1999 to 2008?


```r
NEIWithCommonSourcesOnlyBaltimore <- NEIWithCommonSourcesOnly[NEIWithCommonSourcesOnly$fips == 
    "24510", ]
TotalEmissionsBaltimore <- aggregate(NEIWithCommonSourcesOnlyBaltimore$Emissions, 
    list(year = NEIWithCommonSourcesOnlyBaltimore$year), sum)
png(filename = "plot2.png", width = 480, height = 480, units = "px", res = 72, 
    bg = "white")
plot(TotalEmissionsBaltimore$year, TotalEmissionsBaltimore$x, xlab = "Year", 
    ylab = "Total emissions", pch = 10)
title(main = "Total emissions across sources active all years in Baltimore")
dev.off()
```

```
## pdf 
##   2
```


<img src="plot2.png" />

Although the emissions have not steadily decreased over time (emissions in 2005 are 36% higher than in 2002), the total emissions have decreased from 1999 to 2008 by 63%, from 2825 tons to 1033 tons.

### Question 3

Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008?

We will first create a new dataset to aggregate on both year and source type, then plot evolution of total emissions with ggplot2.


```r
NEIBaltimoreYearType <- aggregate(NEIWithCommonSourcesOnlyBaltimore$Emissions, 
    list(year = NEIWithCommonSourcesOnlyBaltimore$year, type = NEIWithCommonSourcesOnlyBaltimore$type), 
    sum)
library(ggplot2)
png(filename = "plot3.png", width = 640, height = 480, units = "px", res = 72, 
    bg = "white")
ggplot(data = NEIBaltimoreYearType, aes(x = year, y = x, group = type, color = type)) + 
    geom_line() + geom_point() + ggtitle("Baltimore emissions per year and source type") + 
    ylab("Total emssions (tons)") + xlab("Year")
dev.off()
```

```
## pdf 
##   2
```


<img src="plot3.png" />

We can see that NON-POINT and NON-ROAD have decreased steadily meanwhile POINT hasn't.

### Question 4

Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?


```r
SCCCoal <- SCC[grep("Coal", SCC$SCC.Level.Three), ]
SCCCoalComb <- SCCCoal[grep("Combustion", SCCCoal$SCC.Level.One), ]
NEICoal <- NEIWithCommonSourcesOnly[NEIWithCommonSourcesOnly$SCC %in% SCCCoalComb$SCC, 
    ]
TotalEmissionsCoal <- aggregate(NEICoal$Emissions, list(year = NEICoal$year), 
    sum)
```


Now let's plot this :

```r
png(filename = "plot4.png", width = 640, height = 480, units = "px", res = 72, 
    bg = "white")
ggplot(data = TotalEmissionsCoal, aes(x = year, y = x)) + geom_line() + geom_point() + 
    ggtitle("USA coal combustion-related emissions for sources active all years") + 
    ylab("Total emssions (tons)") + xlab("Year")
dev.off()
```

```
## pdf 
##   2
```


<img src="plot4.png" />

The emissions where quite stable from 1999 to 2005 but sharply decreased afterwards for an overall 39.6% drop between 1999 and 2008.

### Question 5

How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?


```r
SCCMotorVeh <- SCC[grep("Veh", SCC$SCC.Level.Three), ]
NEIVehiclesBaltimore <- NEIWithCommonSourcesOnlyBaltimore[NEIWithCommonSourcesOnlyBaltimore$SCC %in% 
    SCCMotorVeh$SCC, ]
TotalEmissionsVeh <- aggregate(NEIVehiclesBaltimore$Emissions, list(year = NEIVehiclesBaltimore$year), 
    sum)
```


There is not much data to deal with here, I suspect restricting the data to sources active across all years might have been more restrictive than anticipated by the creator of the assignment. Here we only have vehicle emissions data for years 2005 and 2008, with equal totals amounting to 10.17 tons. Let's do it without the restriction on sources being common to all years.


```r
NEIVeh <- NEI[NEI$SCC %in% SCCMotorVeh$SCC, ]
NEIVehBaltimore <- NEIVeh[NEIVeh$fips == "24510", ]
TotalEmVeh <- aggregate(NEIVehBaltimore$Emissions, list(year = NEIVehBaltimore$year), 
    sum)
```


Now let's plot this :


```r
png(filename = "plot5.png", width = 640, height = 480, units = "px", res = 72, 
    bg = "white")
ggplot(data = TotalEmVeh, aes(x = year, y = x)) + geom_line() + geom_point() + 
    ggtitle("Baltimore vehicle emissions") + ylab("Total emssions (tons)") + 
    xlab("Year")
dev.off()
```

```
## pdf 
##   2
```


<img src="plot5.png" />

### Question 6

Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?


```r
NEIVehBaltimoreLA <- NEIVeh[NEIVeh$fips %in% c("24510", "06037"), ]
TotalEmVehBLA <- aggregate(NEIVehBaltimoreLA$Emissions, list(year = NEIVehBaltimoreLA$year, 
    city = NEIVehBaltimoreLA$fips), sum)
```


Now let's plot this :


```r
png(filename = "plot6.png", width = 640, height = 480, units = "px", res = 72, 
    bg = "white")
ggplot(data = TotalEmVehBLA, aes(x = year, y = x, group = city, color = city)) + 
    geom_line() + geom_point() + ggtitle("Baltimore vs LA vehicle emissions") + 
    ylab("Total emssions (tons)") + xlab("Year")
dev.off()
```

```
## pdf 
##   2
```


Over the 1999-2008 period Baltimore experienced the greatest change with a 77% decrease in emissions. Meanwhile LA emissions ended almost unchanged over the same period with ~2980 tons both in 1999 and 2008.

<img src="plot6.png" />
