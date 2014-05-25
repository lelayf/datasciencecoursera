#' 
#' Have total emissions from $PM_{2.5}$ decreased in the *Baltimore City*, Maryland (fips == "24510") from 1999 to 2008?
#' 
## ------------------------------------------------------------------------
NEIWithCommonSourcesOnlyBaltimore <- NEIWithCommonSourcesOnly[NEIWithCommonSourcesOnly$fips=="24510",]
TotalEmissionsBaltimore <-  aggregate(NEIWithCommonSourcesOnlyBaltimore$Emissions, list(year=NEIWithCommonSourcesOnlyBaltimore$year), sum)
png(filename = "plot2.png", width = 480, height = 480, units = "px", res=72, bg = "white")
plot(TotalEmissionsBaltimore$year,TotalEmissionsBaltimore$x,xlab="Year", ylab="Total emissions",pch=10)
title(main="Total emissions across sources active all years in Baltimore")
dev.off()

#' 
#' 
#' <img src="plot2.png" />
#' 
#' Although the emissions have not steadily decreased over time (emissions in 2005 are 36% higher than in 2002), the total emissions have decreased from 1999 to 2008 by 63%, from 2825 tons to 1033 tons.
#' 
