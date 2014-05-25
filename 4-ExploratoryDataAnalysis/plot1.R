#' 
#' Let's first download the datasets as described in the assignment.
#' 
#' ```
#' download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",destfile="exdata-NEI.zip",method="curl")
#' unzip("exdata-NEI.zip")
#' ```
#' 
## ------------------------------------------------------------------------
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#' 
#' 
#' ### Question 1
#' 
#' Have total emissions from $PM_{2.5}$ decreased in the United States from 1999 to 2008? 
#' 
#' First let's create a specific dataset to compute total $PM_{2.5}$ emission from all sources per year.
#' 
## ------------------------------------------------------------------------
EmissionsByYear <- aggregate(NEI$Emissions, list(year=NEI$year), sum)
EmissionsByYear

#' 
#' 
#' Now let's use the base plotting system to make a plot showing the total  for each of the years 1999, 2002, 2005, and 2008.
#' 
## ------------------------------------------------------------------------
png(filename = "plot1.png", width = 480, height = 480, units = "px", res=72, bg = "white")
plot(EmissionsByYear$year, EmissionsByYear$x, xlab="Year", ylab="Total emissions",pch=10)
title(main="Total emissions across all sources")
dev.off()

#' 
#' 
#' <img src="plot1.png" />
#' 
#' This graph shows the total measured emissions across all sources have decreased from 1999 to 2002, 2002 to 2005 and 2005 to 2008. The total emissions range between 3,464,206 to 7,332,967. *One question comes to my mind* : are we comparing measurements from the same sources for all these years? 
#' 
## ------------------------------------------------------------------------
NEI$SCC <- as.factor(NEI$SCC)
str(NEI$SCC)

#' 
#' 
#' So we have 5386 sources in our entire dataset. Let's create a list of all sources used every year.
#' 
## ------------------------------------------------------------------------
sources1999 <- droplevels(unique(NEI[NEI$year=="1999","SCC"]))
str(sources1999)
sources2002 <- droplevels(unique(NEI[NEI$year=="2002","SCC"]))
str(sources2002)
sources2005 <- droplevels(unique(NEI[NEI$year=="2005","SCC"]))
str(sources2005)
sources2008 <- droplevels(unique(NEI[NEI$year=="2008","SCC"]))
str(sources2008)

#' 
#' 
#' Big news, our factors for sources by year have a different number of levels (4007, 4373, 4277 and 3668 resp.). So the raw dataset does not allow us to use the same observational units from year to year. We should make comparisons based on the sources common to all measured years.
#' 
## ------------------------------------------------------------------------
inter1999_2002 <- intersect(sources1999,sources2002)
inter2005_2008 <- intersect(sources2005,sources2008)
sourcesCommonToAllYears <- intersect(inter1999_2002,inter2005_2008)
str(sourcesCommonToAllYears)

#' 
#' 
#' We are now down to 2577 sources common to all years and the number of usable observations has nearly halved from 6.5+ million to 3 million measurements.
#' 
## ------------------------------------------------------------------------
NEIWithCommonSourcesOnly <- NEI[NEI$SCC %in% sourcesCommonToAllYears,]
TotalEmissionsWithCommonSourcesOnly <- aggregate(NEIWithCommonSourcesOnly$Emissions, list(year=NEIWithCommonSourcesOnly$year), sum)
png(filename = "plot1bis.png", width = 480, height = 480, units = "px", res=72, bg = "white")
plot(TotalEmissionsWithCommonSourcesOnly$year,TotalEmissionsWithCommonSourcesOnly$x, xlab="Year", ylab="Total emissions",pch=10)
title(main="Total emissions across sources common to all years")
dev.off()

#' 
#' 
#' <img src="plot1bis.png" />
#' 
#' The plot also shows a decreasing profile but with a stronger relative drop from 1999 to 2002. Total emissions range between 2,888,186 tons and 6,037,076 tons.