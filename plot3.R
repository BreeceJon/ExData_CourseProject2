install.packages("dplyr")
install.packages("ggplot2")
library(dplyr)
library(ggplot2)

#Read in PM2.5 data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Select records for Baltimore City, group by year/type, and sum total by year/type
balt_type <- NEI %>% 
  filter(fips == "24510") %>%
  group_by(year, type) %>%
  summarise(total_emissions = sum(Emissions))


#Make plot3
png(filename = "plot3.png")
g <- ggplot(balt_type, aes(year, total_emissions))  + geom_point(size = 4) + geom_smooth(method = "lm", se = FALSE) + facet_grid(type~.)
g + ggtitle("Emissions by Type Over Time") + ylab("Total Emissions (in tons)") + xlab("Year")
dev.off()