##Yvette Hastings
##Geog 6165 Lab 7 Kernel Density
##Code written on 2/26/22; last updated on 

##load libraries
library(sparr) 
library(readxl) 
library(dplyr) 
library(sf)

##load data and convert sf object
tweets <- read_xlsx("W7_Exercise_Data/data/tweets/Tweet_2019_12_6424.xlsx") %>% 
  subset(., select=c("x", "y", "adverse")) %>% 
  st_as_sf(., coords = c("x","y"))

##Convert coordinates in WGS84
st_crs(tweets) = 4326

##Transform coordinates to US Atlas Equal Area
tweets_proj <- st_transform(tweets, crs = 2163) %>% 
  st_coordinates(.) %>% 
  cbind(.,tweets$adverse) %>% 
  as.data.frame(.) 
colnames(tweets_proj) <- c("x", "y", "adv")

##load US boundary shapefile and set to US Atlas Equal Area
conus <- st_read("W7_Exercise_Data/data/tweets/CONUS_diss.shp") %>% 
  st_transform(., crs=2163)

##Reformat data tweets data into point pattern cases vs. controls
tw_ppp <- ppp(tweets_proj$x, tweets_proj$y, 
              marks = as.factor(tweets_proj$adv), 
              window = as.owin(conus)) ##error was given the first time, used 'update.packages(ask = FALSE)' to fix issue

##calculate global bandwidth with oversmoothing principle
h0 <- OS(tw_ppp,nstar="geometric")

##split ppp object into object for cases and controls
twAdv <- tw_ppp[tw_ppp$marks == "1"] #adverse tweets 
twNor <- tw_ppp[tw_ppp$marks == "0"] #normal tweets


##bandwidth regimes to compute kernel density estimates
##Fixed Symmetric bandwidth (bandwidth is the same across study area)
tweet_dens1 <- risk(f=twAdv, g=twNor, h0=h0, tolerate=TRUE, doplot=TRUE)

##Asymmetric Adaptive Bandwidths (bandwidths vary and are adapted to case and control densities)
##not recommended as it causes artifacts shown as halos of increased risk
tweet_dens2 <- risk(f=twAdv, g=twNor, h0=h0, adapt=TRUE, hp=OS(tw_ppp)/2, 
                    tolerate=TRUE, davies.baddeley=0.05, doplot=TRUE)

##Symmetric (pooled) Adaptive Bandwidth (adapted to underlying point data) - fixed
tweet_dens3 <- risk(f=twAdv, g=twNor, h0=h0, adapt=TRUE, tolerate=TRUE, hp=OS(tw_ppp)/2, 
                    pilot.symmetry="pooled", davies.baddeley=0.05, doplot=TRUE)

##Symmetric Bandwidths adaptive
f <- bivariate.density(twAdv,h0=h0,hp=2,adapt=TRUE,pilot.density=twNor, verbose=FALSE) 
g <- bivariate.density(twNor,h0=h0,hp=2,adapt=TRUE,pilot.density=twNor, verbose=FALSE) 
tweet_dens4 <- risk(f=f,g=g,tolerate=TRUE,log=TRUE,doplot=TRUE)


