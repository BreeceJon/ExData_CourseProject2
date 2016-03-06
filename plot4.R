install.packages("dplyr")
install.packages("ggplot2")
library(dplyr)
library(ggplot2)

#Read in PM2.5 data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Select coal combustion-related SCC codes
CoalComb <- filter(SCC, EI.Sector == "Fuel Comb - Electric Generation - Coal" | EI.Sector == "Fuel Comb - Comm/Institutional - Coal" | EI.Sector == "Fuel Comb - Industrial Boilers, ICEs - Coal")
CoalComb$SCC <- as.character(CoalComb$SCC)

#Select NEI coal combustion-related source records
CoalComb <- inner_join(NEI, CoalComb, "SCC", "SCC")

CoalTotal <- CoalComb %>%
  group_by(year) %>%
  summarise(total_emissions = sum(Emissions))

#Make plot4
png(filename = "plot4.png", width = 8, height = 8, units = "in", res= 2400)
g <- ggplot(CoalTotal, aes(year,total_emissions))  + geom_point(color = "red", size = 5, shape = 2) + geom_text(aes(label = round(total_emissions, 0)), vjust = 2)
g + ggtitle("Emissions by Coal Combustion Over Time") + ylab("Total Emissions (in tons)") + xlab("Year") + scale_y_continuous(limits = c(0,600000))
dev.off()