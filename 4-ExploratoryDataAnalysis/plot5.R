#' How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
#' 
## ------------------------------------------------------------------------
SCCMotorVeh <- SCC[grep("Veh",SCC$SCC.Level.Three),]
NEIVehiclesBaltimore <- NEIWithCommonSourcesOnlyBaltimore[NEIWithCommonSourcesOnlyBaltimore$SCC %in% SCCMotorVeh$SCC,]
TotalEmissionsVeh <- aggregate(NEIVehiclesBaltimore$Emissions,list(year=NEIVehiclesBaltimore$year),sum)

#' 
#' 
#' There is not much data to deal with here, I suspect restricting the data to sources active across all years might have been more restrictive than anticipated by the creator of the assignment. Here we only have vehicle emissions data for years 2005 and 2008, with equal totals amounting to 10.17 tons. Let's do it without the restriction on sources being common to all years.
#' 
## ------------------------------------------------------------------------
NEIVeh <- NEI[NEI$SCC %in% SCCMotorVeh$SCC,]
NEIVehBaltimore <- NEIVeh[NEIVeh$fips == "24510",]
TotalEmVeh <- aggregate(NEIVehBaltimore$Emissions,list(year=NEIVehBaltimore$year),sum)

#' 
#' 
#' Now let's plot this :
#' 
## ------------------------------------------------------------------------
png(filename = "plot5.png", width = 640, height = 480, units = "px", res=72, bg = "white")
ggplot(data=TotalEmVeh, aes(x=year,y=x)) + geom_line() + geom_point() + ggtitle("Baltimore vehicle emissions") + ylab("Total emssions (tons)") + xlab("Year")
dev.off()

#' 
#' 
#' <img src="plot5.png" />
