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

##plot3

# Load the NEI & SCC data frames.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Subset NEI data by Baltimore's fip.
baltimoreNEI <- NEI[NEI$fips=="24510",]

# Aggregate using sum the Baltimore emissions data by year
#aggTBalt <- aggregate(Emissions ~ year, baltimoreNEI,sum)

ggp <- ggplot(baltimoreNEI,aes(factor(year),Emissions,fill=type)) +
  geom_bar(stat="identity") +
  theme_bw() + guides(fill=FALSE)+
  facet_grid(.~type,scales = "free",space="free") + 
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
  labs(title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))

print(ggp)

dev.copy(png, file="plot3.png", height=480, width=480,units="px",bg="transparent")
dev.off()