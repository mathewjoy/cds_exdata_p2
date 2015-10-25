#download and unzip if file not already present
archiveDF <- "NEI_data.zip"
if(!file.exists(archiveDF)) {
  archiveURL <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(url=archiveURL,destfile=archiveDF,method="curl")
}

if(!(file.exists("summarySCC_PM25.rds") && 
       file.exists("Source_Classification_Code.rds"))) { 
  unzip(archiveDF) 
}

##plot1

# Load the data frames
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Aggregate by sum the total emissions by year
aggT <- aggregate(Emissions ~ year,NEI, sum)

#png("plot1.png",width=480,height=480,units="px",bg="transparent")

barplot(
  (aggT$Emissions)/10^6,
  names.arg=aggT$year,
  xlab="Year",
  ylab="PM2.5 Emissions (10^6 Tons)",
  main="Total PM2.5 Emissions From All US Sources"
)
dev.copy(png, file="plot1.png", height=480, width=480,units="px",bg="transparent")
dev.off()
