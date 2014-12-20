## Question 6
## Compare emissions from motor vehicle sources in Baltimore City with 
## emissions from motor vehicle sources in Los Angeles County, California 
## (fips == "06037"). Which city has seen greater changes over time in 
## motor vehicle emissions?

## Answer:
## Los Angeles PM2.5 emissions from motor vehicles is a lot bigger 

if (!(require(ggplot2, quietly=T))) {
    install.packages('ggplot2')
}
library(ggplot2)



dir.create("./data", showWarnings=FALSE) 
dir.create("./figures", showWarnings=FALSE)

if(!file.exists("./data/summarySCC_PM25.rds") & 
       !file.exists("./data/Source_Classification_Code.rds")) {
    url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(url, destfile = "./data/data.zip")
    unzip(zipfile="./data/data.zip", files = NULL, list = FALSE, overwrite = TRUE,
          junkpaths = FALSE, exdir = "./data", unzip = "internal",
          setTimes = FALSE)
}

## Read in data
NEI <- readRDS("./data/summarySCC_PM25.rds")
scc <- readRDS("./data/Source_Classification_Code.rds")
names(NEI) <- tolower(names(NEI))
names(scc) <- tolower(names(scc))



baltimore <- subset(NEI, fips == "24510")
angeles <- subset(NEI, fips == "06037")
scc.motor <- grep("motor", scc$short.name, ignore.case = TRUE)
scc.motor <- scc[scc.motor, ]

baltimore.motor <- baltimore[baltimore$scc %in% scc.motor$scc, ]
angeles.motor <- angeles[angeles$scc %in% scc.motor$scc, ]


baltimore.motor.sum <- aggregate(emissions ~ year, baltimore.motor, sum)
angeles.motor.sum <- aggregate(emissions ~ year, angeles.motor, sum)


df <- rbind(angeles.motor.sum, baltimore.motor.sum)
df$county <- c(rep("Los Angeles", each = 4), rep("Baltimore", each = 4)) 

## Plot
png(file = "./figures/Question6.png", width = 577, height = 380)

g <- ggplot(df, aes(x = year, y = emissions)) 
g <- g + geom_bar(aes(fill = county), stat="identity", position = "dodge")
g <- g + labs(title = expression(paste("Total ", 
                                       "PM"[2.5],
                                       " Emissions in Baltimore and Los Angeles,", 
                                       " 1999-2008")),
              x = "Year",
              y = expression(paste("PM"[2.5],
                                   " Emissions(Tons)"))) + 
    scale_x_continuous(breaks = c(1999, 2002, 2005, 2008))
g
dev.off()

