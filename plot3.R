## Read the datasets into R workspace
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Generate the result dataframe required for plot
library(dplyr)

result3 <-  NEI %>%
    filter(fips == "24510") %>%
    group_by(type,year) %>%
    summarize(total = sum(Emissions))

## Make plot on screen device
library(ggplot2)
ggplot(result3,       
       aes(x=year, y=total, color=type)) + 
    geom_line(size=2) + geom_point(size=4) +
    scale_x_continuous(breaks = seq(1999,2008,3)) +
    labs(title = "Baltimore Emissions by type",
         x = "Year", y = "PM2.5 Emissions (tons)") + theme_light() +
    theme(plot.title = element_text(size = "14", face="bold",colour = "brown"))+
    theme(axis.title = element_text(face="bold.italic", 
                                    size="11", color="brown"), 
          legend.position="bottom") + 
    geom_text(aes(label=floor(total)), color = "black",
              size=4, hjust=0.5, vjust=2.0, angle = 45)

## Copy the plot to png device
dev.copy(png, file = "plot3.png",width = 480, height = 480)
dev.off()

