#rm(list = ls())

library(openair)
library(zoo)
library(ggplot2)
library(gridExtra)
library(grid)
library(scales)

# Complete information
Location <- "Capuaba"       # name of site

# Location of your data
input.path   <- "C:/Users/Mike/Desktop/Capuaba_ML_GPP.csv"

# Location to export the graph
output.path  <- paste("C:/Users/Mike/Desktop/GPP_", Location, ".tif", sep = "")

# Import your data
Station   <- read.table(input.path, header=TRUE, sep=",", na.strings="NA", dec=".", strip.white=TRUE, skip=0)

#----------------------------------------------------------------------------------------
## Format dates
Station$timestamp <- as.POSIXct(Station$timestamp, "%d-%m-%y %H:%M", tz="GMT")     
attributes(Station$timestamp)$tzone <- "America/Cuiaba"
Station$date <- as.Date(Station$timestamp, "%d-%m-%y %H:%M:%S", tz="GMT")

date1 <- Station$date[1]
date2 <- tail(Station$date, 1)

# Obtain daily averages
Station.daily <- timeAverage(Station, avg.time = "day", na.rm = TRUE) 

# Plot a time series of ET predicted with PT alpha and 

p <- ggplot(Station.daily, aes(x=date, y=Precip*48))+
     geom_bar(stat = "identity") +
     xlab("") + ylab(expression(paste(italic(P), " (mm ", "d"^{-1}, ")"), sep="")) +
     theme_bw() +
     ggtitle(expression(bold("A"))) + theme(plot.title=element_text(hjust=0)) +
     scale_x_date(breaks = date_breaks("3 months"), labels = date_format("%b-%y"), limits=c(date1, date2))+
     theme(axis.text.x = element_blank())

rs.ra <- ggplot() +
         geom_line(data=Station.daily, aes(x=date, y= Rs/(Ra*48*10^6/(24*3600)) )) +  
         xlab("") + ylab(expression(paste("R"[s], "/R"[a]) , sep=" ")) +
         theme_bw() +  labs("") +
         ggtitle(expression(bold("B"))) + theme(plot.title=element_text(hjust=0)) +
         scale_y_continuous(limits=c(0,1)) +
         scale_x_date(breaks = date_breaks("3 months"), labels = date_format("%b-%y"), limits=c(date1, date2))+
         theme(axis.text.x = element_blank()) 

gpp <- ggplot() +
       geom_line(data=Station.daily, aes(x=date, y= GPP)) + 
       xlab("") + ylab(expression(paste("GPP (", mu, "mol m"^{-2}, "s"^{-1}, ")") , sep=" ")) +
       theme_bw() +  labs("") +
       ggtitle(expression(bold("D"))) + theme(plot.title=element_text(hjust=0)) +
       #scale_y_continuous(limits=c(0,500)) +
       scale_x_date(breaks = date_breaks("3 months"), labels = date_format("%b-%y"), limits=c(date1, date2))+
       theme(axis.text.x = element_blank()) 

vwc <- ggplot() +
       geom_line(data=Station.daily, aes(x=date, y= VWC)) + 
       xlab("") + ylab(expression(paste(theta, " ( m"^{3}, "m"^{-1}, ")"), sep=" ")) + 
       theme_bw() +  labs("") +
       ggtitle(expression(bold("E"))) + theme(plot.title=element_text(hjust=0)) +
       scale_y_continuous(limits=c(0,0.4)) +
       scale_x_date(breaks = date_breaks("3 months"), labels = date_format("%b-%y"), limits=c(date1, date2))
       
grid.draw(rbind(ggplotGrob(p), ggplotGrob(rs.ra), ggplotGrob(gpp), ggplotGrob(vwc), size = "last"))

dev.print(tiff, file=output.path, width=1500, height=1500, res=150) 

## END ####