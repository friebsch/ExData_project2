## Question 1
# Have total emissions from PM2.5 decreased in the 
# United States from 1999 to 2008? Using the base plotting system, 
# make a plot showing the total PM2.5 emission from all sources for 
# each of the years 1999, 2002, 2005, and 2008.
##

## Answer:
## It seems that PM2.5 Emissions have most certainly decreased since 1999.


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

## Reading the data

NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")
names(NEI) <- tolower(names(NEI))

## Plot1 1:


emissions.sum <- aggregate(emissions ~ year, NEI, sum)

emissions.sum$emissions <- emissions.sum$emissions/1000000

## Plot
png(file = "./figures/plot1.png", width = 577, height = 380)
par(mar=c(5.1,4.1,4.1,2.1))
with(emissions.sum, barplot(height = emissions,
                            names.arg = year,
                            ylim = c(0, 8),
                            xlab = "Year",
                            ylab = expression(paste("PM"[2.5],
                                                    " Emissions (Million Tons)")),
                            main = expression(paste("Total ", 
                                                    "PM"[2.5],
                                                    "Emissions By Year, 1999-2008"))))
dev.off()

