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

#MV_SCC <- unique(MV$SCC)

#Filter to find Baltimore City records
balt <- filter(NEI, fips == "24510")

#Select Baltimore motor vehicle-related records
balt_mv <- inner_join(balt, MV, "SCC", "SCC")

balt_mv_total <- balt_mv %>%
  group_by(year) %>%
  summarise(total_emissions = sum(Emissions))

#Make plot5
png(filename = "plot5.png")
g <- ggplot(balt_mv_total, aes(year, total_emissions))  + geom_point(size = 4) + geom_smooth(method = "lm", se = FALSE)
g + ggtitle("Motor Vehicle Emissions in Baltimore City Over Time") + ylab("Total Motor Vehicle-Related Emissions (in tons)") + xlab("Year") + scale_y_continuous(limits = c(0,1000))
dev.off()