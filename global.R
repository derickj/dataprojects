library(shiny)
library(reshape2)
library(RCurl)

url <- "https://docs.google.com/spreadsheets/d/14EbD832LcfKEI2y4QIEJq8mvmkiVtFWNNPF3AEJap0Q/pub?output=csv"
urlData <- getURLContent(url)
cname <- read.table (textConnection(urlData), sep = ',', skip = 7, nrow = 1, stringsAsFactors = FALSE)
cname[1] <- "univ"
cname[2] <- "race"
cname[3:15] <- as.character(cname[3:15])
unidata <- read.table (textConnection(urlData), sep = ',', strip.white = TRUE, skip = 8, col.names = cname[1,], check.names = FALSE, stringsAsFactors = FALSE)
unidata <- unidata [1:nrow(unidata)-1,]
unidata[,1] <- as.factor(unidata[,1])
unidata[,2] <- as.factor(unidata[,2])
for (i in 3:15) {
  unidata[,i] <- as.integer(gsub("%","",unidata[,i]))
}
unidata <- melt(unidata,id.vars=c("univ","race"),measure.vars=cname[3:15], variable.name ="year", value.name ="perc")
