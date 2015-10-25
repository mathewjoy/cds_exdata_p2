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

##plot2

# Load the data frames
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Subset NEI data for Baltimore.
baltimoreNEI <- NEI[NEI$fips=="24510",]

# total for batlimore
aggTBalt <- aggregate(Emissions ~ year, baltimoreNEI,sum)


barplot(
  aggTBalt$Emissions,
  names.arg=aggTBalt$year,
  xlab="Year",
  ylab="PM2.5 Emissions (Tons)",
  main="Total PM2.5 Emissions From all Baltimore City Sources"
)

dev.copy(png, file="plot2.png", height=480, width=480,units="px",bg="transparent")
dev.off()