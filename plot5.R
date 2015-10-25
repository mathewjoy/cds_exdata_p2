library(ggplot2)
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

##plot5
#load data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Gather the subset of the NEI data which corresponds to vehicles
v <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vSCC <- SCC[v,]$SCC
vNEI <- NEI[NEI$SCC %in% vSCC,]

# Subset data
baltVNEI <- vNEI[vNEI$fips=="24510",]

ggp <- ggplot(baltVNEI,aes(factor(year),Emissions)) +
  geom_bar(stat="identity",fill="grey",width=0.75) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore from 1999-2008"))

print(ggp)

dev.copy(png, file="plot5.png", height=480, width=480,units="px",bg="transparent")

dev.off()