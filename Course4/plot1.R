library(ggplot2)
library(lubridate)

# get data
path <- getwd()
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, file.path(path, "dataset.zip"))
unzip(zipfile = "dataset.zip")
power <- read.csv("household_power_consumption.txt", sep=";", na.strings = "?")

# convert date and time to datetime objs
power$Date <- as.Date(power$Date, "%d/%m/%Y")
power$Time <- strptime(power$Time, "%H:%M:%S")

# subset
start_date <- as.Date("2007-02-01")
end_date <- as.Date("2007-02-03")
power_subset <- subset(power, (Date >= start_date & Date < end_date))


# PLOT 1

