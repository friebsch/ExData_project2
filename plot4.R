## Question 4
## Across the United States, how have emissions from coal combustion-related 
## sources changed from 1999-2008?
##

## Answe: 
## No big change beween 1999 and 2005. 
##slight increase between 2002 and 2005 
## Big decrease between 2005 and 2008.

dir.create("./figures", showWarnings=FALSE)
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
scc <- readRDS("./data/Source_Classification_Code.rds")
names(NEI) <- tolower(names(NEI))
names(scc) <- tolower(names(scc))



s
scc.coal <- grep("coal", scc$short.name, ignore.case = TRUE)
scc.coal <- scc[scc.coal, ]
NEI.coal <- NEI[NEI$scc %in% scc.coal$scc, ]

coal.sum <- aggregate(emissions ~ year, NEI.coal, sum)


coal.sum$emissions <- coal.sum$emissions/10000

## Plot data
png(file = "./figures/plot4.png", width = 577, height = 380)
par(mar=c(5.1,4.1,4.1,2.1))
with(coal.sum, barplot(height = emissions,
                       names.arg = year,
                       ylim = c(0, 70),
                       xlab = "Year",
                       ylab = expression(paste("PM"[2.5],
                                               " Emissions (10,000 Tons)")),
                       main = expression(paste("Total ", 
                                               "PM"[2.5],
                                               "Emissions From Coal", 
                                               ", 1999-2008"))))
dev.off()

