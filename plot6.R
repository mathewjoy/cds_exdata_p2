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

##plot6
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Gather the subset of the NEI data which corresponds to vehicles
v <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vSCC <- SCC[v,]$SCC
vNEI <- NEI[NEI$SCC %in% vSCC,]

# Subset the vehicles NEI data by each city's fip and add city name.
baltVNEI <- vNEI[vNEI$fips=="24510",]
baltVNEI$city <- "Baltimore City"

LAVNEI <- vNEI[vNEI$fips=="06037",]
LAVNEI$city <- "Los Angeles County"

# merge - rowbind - the two subsets
combNEI <- rbind(baltVNEI,LAVNEI)

ggp <- ggplot(combNEI, aes(x=factor(year), y=Emissions, fill=city)) +
  geom_bar(aes(fill=year),stat="identity") +
  facet_grid(scales="free", space="free", .~city) +
  guides(fill=FALSE) + theme_bw() +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Kilo-Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))

print(ggp)

dev.copy(png, file="plot6.png", height=480, width=480,units="px",bg="transparent")
dev.off()