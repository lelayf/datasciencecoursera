#' 
#' Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
#' 
## ------------------------------------------------------------------------
SCCCoal <- SCC[grep("Coal",SCC$SCC.Level.Three),]
SCCCoalComb <- SCCCoal[grep("Combustion",SCCCoal$SCC.Level.One),]
NEICoal <- NEIWithCommonSourcesOnly[NEIWithCommonSourcesOnly$SCC %in% SCCCoalComb$SCC,]
TotalEmissionsCoal <- aggregate(NEICoal$Emissions, list(year=NEICoal$year), sum)

#' 
#' 
#' Now let's plot this :
## ------------------------------------------------------------------------
png(filename = "plot4.png", width = 640, height = 480, units = "px", res=72, bg = "white")
ggplot(data=TotalEmissionsCoal, aes(x=year,y=x)) + geom_line() + geom_point() + ggtitle("USA coal combustion-related emissions for sources active all years") + ylab("Total emssions (tons)") + xlab("Year")
dev.off()

#' 
#' 
#' <img src="plot4.png" />
#' 
#' The emissions where quite stable from 1999 to 2005 but sharply decreased afterwards for an overall 39.6% drop between 1999 and 2008.
#' 