install.packages("dplyr")
library(dplyr)

#Read in PM2.5 data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Select only Baltimore City data, group by year, and sum total by year
balt <- NEI %>% 
  filter(fips == "24510") %>%
  group_by(year) %>%
  summarise(total_emissions = sum(Emissions))


#Make plot2
png(filename = "plot2.png", width = 8, height = 8, units = "in", res= 2400)
with(balt, plot(year, total_emissions, main = "Total PM2.5 Emissions by Year in Baltimore City, Maryland", xlab = "Year", ylab = "Total Emissions (in tons)", ylim=c(0, 5000), yaxt = "n"))
axis(2, at= seq(0,5000, 500), labels = format(seq(0,5000, 500), scientific = FALSE))
lm1 <- lm(total_emissions ~ year, data = balt)
abline(lm1, lwd = 2, col = "red")
text(balt$year, balt$total_emissions, balt$year, cex=0.6, pos=1, col="blue")
dev.off()