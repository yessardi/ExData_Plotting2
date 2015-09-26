## Read the datasets into R workspace
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Generate the result dataframe required for plot
library(dplyr)

SCC$MVSource <- as.factor(ifelse(grepl("vehicle",SCC$EI.Sector,ignore.case=TRUE)
                                 ,1, 0))
NEISCC <- merge(NEI,SCC,by="SCC",all.x = TRUE)

result6 <-  NEISCC %>%
    filter((fips == "24510" | fips == "06037") & MVSource == 1 ) %>%
    group_by(fips,year) %>%
    summarize(total = sum(Emissions))

## Make plot on screen device
library(ggplot2)

ggplot(result6, 
       aes(x=year, y=total, color = fips)) + 
    geom_line(size=2) + geom_point(size=4) +
    scale_x_continuous(breaks = seq(1999,2008,3)) +
    labs(title = "Motor Vehicle Emissions - Los Angeles v/s Baltimore",
         x = "Year", y = "PM2.5 Emissions (tons)") + theme_light() +
    theme(plot.title = element_text(size = "14", face="bold",colour = "brown"))+
    theme(axis.title = element_text(face="bold.italic", 
                                    size="11", color="brown"), 
          legend.position="bottom") + 
    geom_text(aes(label=floor(total)), color = "black",
              size=4, hjust=0.5, vjust=1.5, angle = 45)+
    scale_color_manual("",labels = c("Los Angeles", "Baltimore"), 
                       values = c("blue","red")) 

## Copy the plot to png device
dev.copy(png, file = "plot6.png",width = 480, height = 480)
dev.off()

