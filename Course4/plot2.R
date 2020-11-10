library(ggplot2)
library(lubridate)
library(data.table)

# get data
path <- getwd()
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, file.path(path, "dataset.zip"))
unzip(zipfile = "dataset.zip")

# load dataset
power <- data.table::fread(input = "household_power_consumption.txt",
                           na.strings="?")

# change chars to numerics
power[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]

# create parseable time object for x-axis
power[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# subset of dates
start_date <- as.Date("2007-02-01")
end_date <- as.Date("2007-02-03")
power_subset <- power[(dateTime >= start_date) & (dateTime < end_date)]

## Plot 2 (my weekdays are in Portuguese, sorry about that)
png("plot2.png", width=480, height=480)

plot(x = power_subset[, dateTime]
     , y = power_subset[, Global_active_power]
     , type="l", xlab="", ylab="Global Active Power (kilowatts)")

dev.off()