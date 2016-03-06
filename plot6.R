install.packages("dplyr")
install.packages("ggplot2")
library(dplyr)
library(ggplot2)

#Read in PM2.5 data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Select motor vehicle-related SCC codes
MV <- filter(SCC, grepl('Mobile', EI.Sector))
MV$SCC <- as.character(MV$SCC)

#Filter to find Baltimore City records
balt <- filter(NEI, fips == "24510")

#Filer to find Los Angeles County records
la <- filter(NEI, fips == "06037")

#Select Baltimore motor vehicle-related records
balt_mv <- inner_join(balt, MV, "SCC", "SCC")

balt_mv_total <- balt_mv %>%
  group_by(year) %>%
  summarise(total_emissions = sum(Emissions))

#Select Los Angeles motor vehicle-related records
la_mv <- inner_join(la, MV, "SCC", "SCC")

la_mv_total <- la_mv %>%
  group_by(year) %>%
  summarise(total_emissions = sum(Emissions))

rng <- range(balt_mv_total$total_emissions, la_mv_total$total_emissions, na.rm = TRUE)

#Make plot6
png(filename = "plot6.png", width = 8, height = 8, units = "in", res= 2400)
par(mfrow = c(1,2))
with(balt_mv_total, plot(year, total_emissions, main = "Baltimore City", xlab = "Year", ylab = "Total Mobile Emissions (in tons)", ylim = rng))
with(la_mv_total, plot(year, total_emissions, main = "Los Angeles County", xlab = "Year", ylab = "Total Mobile Emissions (in tons)", ylim = rng))
dev.off()