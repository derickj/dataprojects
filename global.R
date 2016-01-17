#
# Load the required libraries
#
library(shiny)
library(reshape2)
library(RCurl)

#
# Read the data
#
url <- "https://docs.google.com/spreadsheets/d/14EbD832LcfKEI2y4QIEJq8mvmkiVtFWNNPF3AEJap0Q/pub?output=csv"
urlData <- getURLContent(url)
#
# First just header row to get the variable names
#
cname <- read.table (textConnection(urlData), sep = ',', skip = 7, nrow = 1, stringsAsFactors = FALSE)
#
# Clean up column names
#
cname[1] <- "univ"
cname[2] <- "race"
cname[3:15] <- as.character(cname[3:15])
#
# Read the rest of the data
#
unidata <- read.table (textConnection(urlData), sep = ',', 
                       strip.white = TRUE, skip = 8, 
                       col.names = cname[1,], 
                       check.names = FALSE, 
                       stringsAsFactors = FALSE)
unidata <- unidata [1:nrow(unidata)-1,]   # Drop the last row which is an end of file marker
#
# Convert classification variables to factors and "nn%" to integer values
#
unidata[,1] <- as.factor(unidata[,1])
unidata[,2] <- as.factor(unidata[,2])
for (i in 3:15) {
  unidata[,i] <- as.integer(gsub("%","",unidata[,i]))
}
unidata <- melt(unidata,id.vars=c("univ","race"),measure.vars=cname[3:15], variable.name ="year", value.name ="perc")
