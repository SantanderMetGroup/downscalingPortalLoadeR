downscalingPortal
=================

Here you can find some examples of the analysis of the downscaled data.

## loadDownscaling.R ##


The loadDownscaling.R function allows you to read .csv files produced in the portal.

```
source('/the/directory/where/you/have/the/script/loadDownscaling.R')
downscaling <- loadDownscaling('yourDownscaling.csv')
# display the structure
str(downscaling)
```

This data frame contains the dates in the first column and the downscaled values for different stations in the following ones.

```
data<-downscaling[[2]]
dates<-downscaling[[1]]
```

### Plot a histogram and compute basic statistics ###

```
hist(data)
mean(data,na.rm=TRUE)
sd(data)
quantile(data, c(.9,.95,.99))
summary(data)
```

### Time series calculations with zoo package ###

```
install.packages("zoo")
require(zoo)
```

Plot some time series

```
# original series
series <- zoo(downscaling[[2]], downscaling[[1]])
plot(series)

# Now we are going to aggregate the data at different temporal resolutions using the mean and the 95th percentile.
# First we define the aggregation functions that ignore missing values

namean<- function(x){
  mean(x,na.rm = TRUE)
}
p95<- function(x){
  quantile(x,.95,na.rm = TRUE)
}

# plot the monthly mean aggregated data
seriesmmean <- aggregate(series, as.Date(as.yearmon(time(series))), namean)
plot(seriesmmean)

# plot the yearly mean aggregated data
as.year <- function(x){
  as.Date(cut(x, 'year'))
}
seriesymean <- aggregate(series, as.Date(as.year(time(series))), namean)
plot(seriesymean)

# plot the seasonally aggregated data
as.season <- function(oDates){
  unlist(lapply(oDates, function(oDate) {
    monthDate <- cut(oDate, 'month')
    month <- as.numeric(format(oDate, "%m"))
    year <- as.numeric(format(oDate, "%Y"))
    if(month <= 2) return(as.Date(paste(year - 1, '-12-1', sep="")))
    if(month <= 5) return(as.Date(paste(year, '-3-1', sep="")))
    if(month <= 8) return(as.Date(paste(year, '-6-1', sep="")))
    if(month <= 11) return(as.Date(paste(year, '-9-1', sep="")))
    return(as.Date(paste(year, '-12-1', sep="")))
  }))
}
seriesSeasmean <- aggregate(series, as.Date(as.season(time(series))), namean)
plot(seriesSeasmean)


# plot the monthly 95th percentile aggregated data
seriesmmean95p <- aggregate(series, as.Date(as.yearmon(time(series))), p95)
plot(seriesmmean95p)

# plot the yearly 95th percentile aggregated data
seriesymean95p <- aggregate(series, as.Date(as.year(time(series))), p95)
plot(seriesymean95p)

# plot the seasonally 95th percentile aggregated data
seriesSeasmean95p <- aggregate(series, as.Date(as.season(time(series))), p95)
plot(seriesSeasmean95p)

```
