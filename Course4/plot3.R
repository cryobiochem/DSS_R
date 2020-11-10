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


# PLOT 3
png("plot3.png", width=480, height=480)

plot(x = power_subset[, dateTime],
     y = power_subset[, Sub_metering_1],
     type="n", xlab="", ylab="Energy sub metering")

lines(x = power_subset[, dateTime],
      y = power_subset[, Sub_metering_1],
      type="l", col="black")

lines(x = power_subset[, dateTime],
      y = power_subset[, Sub_metering_2],
      type="l", col="red")

lines(x = power_subset[, dateTime],
      y = power_subset[, Sub_metering_3],
      type="l", col="blue")

legend("topright",
       legend=c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"),
       col=c("black", "red", "blue"),
       lty=c(1,1,1))

dev.off()