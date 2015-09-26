## Read the datasets into R workspace
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Generate the result dataframe required for plot
library(dplyr)

SCC$CoalSource <- as.factor(ifelse(grepl("coal",SCC$EI.Sector,ignore.case=TRUE),
                           1, 0))
NEISCC <- merge(NEI,SCC,by="SCC",all.x = TRUE)

result4 <-  NEISCC %>%
    filter(CoalSource == 1) %>%
    group_by(year) %>%
    summarize(total = sum(Emissions))

## Make plot on screen device
library(ggplot2)

ggplot(result4,       
       aes(x=year, y=total/1000)) + 
    geom_line(size=2,color = "red") + geom_point(size=4, color = "red") +
    scale_x_continuous(breaks = seq(1999,2008,3)) +
    labs(title = "Coal Source Emissions - US",
         x = "Year", y = "PM2.5 Emissions (kilotons)") + theme_light() +
    theme(plot.title = element_text(size = "14", face="bold",colour = "brown"))+
    theme(axis.title = element_text(face="bold.italic", 
                                    size="11", color="brown")) + 
    geom_text(aes(label=floor(total/1000)), color = "black",
              size=4, hjust=0.5, vjust=-1.0, angle = 45)

## Copy the plot to png device
dev.copy(png, file = "plot4.png",width = 480, height = 480)
dev.off()

