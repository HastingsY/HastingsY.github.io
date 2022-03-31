##Yvette Hastings
##Geog 6165 Lab 2
##January 26, 2022

library(maps)
library(dplyr)
library(readxl)

##Part 1
##load data
costco <- read.csv("C:\\Users\\yhors\\Box\\Geography_MS\\Spring_2022_courses\\GEOG6165-DataViz\\Labs\\Lab2\\W2_Exercise_Data\\costcos-geocoded.csv", sep=',')


##map first layer: basemap
map(database='state')

##add second layer: Costco stores
##use symbols function in maps library
##smybols = TRUE indicates want symbols added to existing map instead of creating new map
symbols(costco$Longitude, costco$Latitude, circles = rep(1, length(costco$Longitude)), inches=0.05, add = TRUE)

##change state and dot colors
map(database = 'state', col='#cccccc') +
  symbols(costco$Longitude, costco$Latitude, bg="#e2373f", fg="#ffffff",lwd=0.5, circles=rep(1, length(costco$Longitude)), inches=0.05, add=TRUE)

##map world to see Alaska and Hawaii
map(database = 'world', col = "#cccccc")+
  symbols(costco$Longitude, costco$Latitude, bg="#e2373f", fg="#ffffff",lwd=0.3, circles=rep(1, length(costco$Longitude)), inches=0.03, add=TRUE)

##map specific regions
map(database="state", region=c("California", "Nevada", "Oregon", "Washington"),col="#cccccc") +
  symbols(costco$Longitude, costco$Latitude, bg="#e2373f", fg="#ffffff",lwd=0.5, circles=rep(1, length(costco$Longitude)), inches=0.05, add=TRUE)



##Part 2
##load data
fertility <- read.csv("C:\\Users\\yhors\\Box\\Geography_MS\\Spring_2022_courses\\GEOG6165-DataViz\\Labs\\Lab2\\W2_Exercise_Data\\adol-fertility.csv", sep=',')

##use SQURT to map fertility in symbols
map("world", fill=FALSE, col="#cccccc") +
  symbols(fertility$longitude, fertility$latitude, circles=sqrt(fertility$ad_fert_rate), add=TRUE, inches=0.15, bg="#93ceef", fg="#ffffff")




##Task 1: make my own dot map of whatever I want - earthquake epicenters
##load data
earthquake <- read_xls("C:\\Users\\yhors\\Box\\Geography_MS\\Spring_2022_courses\\GEOG6165-DataViz\\Labs\\Lab2\\earthquake.xls")

#filter data to magnitude >3.5
earthquake <- earthquake %>%
  filter(Mag > 2)

##map of earthquake epicenters in utah
map(database="state", region=c("Nevada", 'Utah', 'Colorado', 'Wyoming', "Idaho", 'Arizona')) +
  symbols(earthquake$Long, earthquake$Lat, bg="#e2373f", fg="#ffffff",lwd=0.03, circles=rep(1, length(earthquake$Long)), inches=0.05, add=TRUE)

map(database="state", regions = "Utah") +
  symbols(earthquake$Long, earthquake$Lat, bg="#CD3333", fg="#000000",lwd=0.03, circles=rep(1, length(earthquake$Long)), inches=0.05, add=TRUE) 

##Add a title
title('Earthquake Epicenters in Utah with Magnitude > 1.5')



##Task 2: make a graduated symbols map with my own data and change appearance of bubbles
earthquake$Mag1 <- earthquake$Mag *1000

map(database="state", regions = "Utah") +
  symbols(earthquake$Long, earthquake$Lat, circles=(earthquake$Mag1), add=TRUE, inches=0.15, bg="#CD3333", fg="#000000")

##Add a title
title('Earthquake Epicenters in Utah with Magnitude > 2')
