#' 
#' Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?
#' 
## ------------------------------------------------------------------------
NEIVehBaltimoreLA <- NEIVeh[NEIVeh$fips %in% c("24510","06037"),]
TotalEmVehBLA <- aggregate(NEIVehBaltimoreLA$Emissions,list(year=NEIVehBaltimoreLA$year,city=NEIVehBaltimoreLA$fips),sum)

#' 
#' 
#' Now let's plot this :
#' 
## ------------------------------------------------------------------------
png(filename = "plot6.png", width = 640, height = 480, units = "px", res=72, bg = "white")
ggplot(data=TotalEmVehBLA, aes(x=year,y=x,group=city,color=city)) + geom_line() + geom_point() + ggtitle("Baltimore vs LA vehicle emissions") + ylab("Total emssions (tons)") + xlab("Year")
dev.off()

#' 
#' 
#' Over the 1999-2008 period Baltimore experienced the greatest change with a 77% decrease in emissions. Meanwhile LA emissions ended almost unchanged over the same period with ~2980 tons both in 1999 and 2008.
#' 