#' 
#' Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008?
#' 
#' We will first create a new dataset to aggregate on both year and source type, then plot evolution of total emissions with ggplot2.
#' 
## ------------------------------------------------------------------------
NEIBaltimoreYearType <- aggregate(NEIWithCommonSourcesOnlyBaltimore$Emissions, list(year=NEIWithCommonSourcesOnlyBaltimore$year,type=NEIWithCommonSourcesOnlyBaltimore$type), sum)
library(ggplot2)
png(filename = "plot3.png", width = 640, height = 480, units = "px", res=72, bg = "white")
ggplot(data=NEIBaltimoreYearType, aes(x=year,y=x,group=type,color=type)) + geom_line() + geom_point() + ggtitle("Baltimore emissions per year and source type") + ylab("Total emssions (tons)") + xlab("Year")
dev.off()

#' 
#' 
#' <img src="plot3.png" />
#' 
#' We can see that NON-POINT and NON-ROAD have decreased steadily meanwhile POINT hasn't.
#' 