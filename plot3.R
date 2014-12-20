
## Question 3:
# Of the four types of sources indicated by the type 
# (point, nonpoint, onroad, nonroad) variable, which of these four sources 
# have seen decreases in emissions from 1999-2008 for Baltimore City? 
# Which have seen increases in emissions from 1999-2008? Use the ggplot2 
# plotting system to make a plot answer this question.
## 

## Answer:
## point type = increase.
## nonpoint, onroad, nonroad decrease

if (!(require(ggplot2, quietly=T))) {
    install.packages('ggplot2')
}
library(ggplot2)



dir.create("./data", showWarnings=FALSE) 

if(!file.exists("./data/summarySCC_PM25.rds") & 
       !file.exists("./data/Source_Classification_Code.rds")) {
    url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(url, destfile = "./data/data.zip")
    unzip(zipfile="./data/data.zip", files = NULL, list = FALSE, overwrite = TRUE,
          junkpaths = FALSE, exdir = "./data", unzip = "internal",
          setTimes = FALSE)
}


NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")
names(NEI) <- tolower(names(NEI))




baltimore <- subset(NEI, fips == "24510")
baltimore.types <- aggregate(emissions ~ year * type, baltimore, sum)


png(file = "./figures/plot3.png", width = 577, height = 380)
g <- ggplot(baltimore.types, aes(x = year, y = emissions, fill = type))
g <- g + geom_bar(aes(fill = type), stat="identity", position = "dodge")
g <- g + labs(title = expression(paste("Total ", 
                                       "PM"[2.5],
                                       " Emissions in Baltimore By Source,", 
                                       " 1999-2008")),
              x = "Year",
              y = expression(paste("PM"[2.5],
                                   " Emissions(Tons)"))) + 
    scale_x_continuous(breaks = c(1999, 2002, 2005, 2008))
g
dev.off()

