## Question 2:
## Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
## (fips == "24510") from 1999 to 2008? Use the base plotting system to make 
## a plot answering this question.
##

##Answer:
## The totalemissions from PM2.5 have decreased.


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

NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")
names(NEI) <- tolower(names(NEI))



## Subset by fips value to get emissions values for Baltimore
baltimore <- subset(NEI, fips == "24510")
baltimore.sum <- aggregate(emissions ~ year, baltimore, sum)

## Turn the emissions back into 1,000 tons to prevent decimals
baltimore.sum$emissions <- baltimore.sum$emissions/1000
png(file = "./figures/plot2.png", width = 577, height = 380)
par(mar=c(5.1,4.1,4.1,2.1))
with(baltimore.sum, barplot(height = emissions,
                            names.arg = year,
                            ylim = c(0, 4.0),
                            xlab = "Year",
                            ylab = expression(paste("PM"[2.5],
                                                    " Emissions (1,000 Tons)")),
                            main = expression(paste("Total ", 
                                                    "PM"[2.5],
                                                    "Emissions in Baltimore By Year",
                                                    " 1999-2008"))))

dev.off()



