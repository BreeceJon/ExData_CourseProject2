install.packages("dplyr")
library(dplyr)

#Read in PM2.5 data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Group by year and sum total by year
grp_yr_NEI <- group_by(NEI, year)
grp_yr_NEI <- summarise(grp_yr_NEI, total_emissions = sum(Emissions))

#Make plot1
png(filename = "plot1.png", width = 8, height = 8, units = "in", res= 2400)
with(grp_yr_NEI, plot(year, total_emissions, main = "Total PM2.5 Emissions by Year Decreasing", xlab = "Year", ylab = "Total Emissions (in tons)", ylim=c(0, 10000000), yaxt = "n"))
axis(2, at= seq(0,10000000, 1000000), labels = format(seq(0,10000000, 1000000), scientific = FALSE))
lm1 <- lm(total_emissions ~ year, data = grp_yr_NEI)
abline(lm1, lwd = 2, col = "red")
text(grp_yr_NEI$year, grp_yr_NEI$total_emissions, grp_yr_NEI$year, cex=0.6, pos=1, col="blue")
dev.off()