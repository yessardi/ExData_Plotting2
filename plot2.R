## Read the datasets into R workspace
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Generate the result dataframe required for plot
library(dplyr)

result2 <-  NEI %>%
    filter(fips == "24510") %>%
    group_by(year) %>%
    summarize(total = sum(Emissions))

## Make plot on screen device
with(result2,{
    plot(year,total,type = "b", lty = 1,lwd = 3, pch = 19, cex = 2,col = "red", 
         xaxt = "n", ylim = range(total), xlab = "", ylab = "")  
    axis(1,at=year,labels=year)
    title(main = "Yearly Emissions - Baltimore", xlab = "Year",
          ylab = "PM2.5 Emissions (tons)")
    text(year, total, floor(total), cex=0.8, pos=1, col="black")
}) 

## Copy the plot to png device
dev.copy(png, file = "plot2.png",width = 480, height = 480)
dev.off()
