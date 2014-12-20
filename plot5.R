## Question 5
##How have emissions from motor vehicle sources changed from 1999-2008 in 
##Baltimore City?

## Answer: 
## 1999 = PM2.5 emissions were very low.
## Between 1999 and 2005, the emission levels increased strongly.
## Between 2005 and 2008, the emission levels decreased back


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


scc.motor <- grep("motor", scc$short.name, ignore.case = TRUE)
scc.motor <- scc[scc.motor, ]
baltimore.motor <- baltimore[baltimore$scc %in% scc.motor$scc, ]

motor.sum <- aggregate(emissions ~ year, baltimore.motor, sum)

## Plot 
png(file = "./figures/plot5.png", width = 577, height = 380)
par(mar=c(5.1,4.1,4.1,2.1))
with(motor.sum, barplot(height = emissions,
                        names.arg = year,
                        ylim = c(0, 12),
                        xlab = "Year",
                        ylab = expression(paste("PM"[2.5],
                                                " Emissions (Tons)")),
                        main = expression(paste("Total ", 
                                                "PM"[2.5],
                                                "Emissions From Motor Vehicles in Baltimore", 
                                                ", 1999-2008"))))
dev.off()

