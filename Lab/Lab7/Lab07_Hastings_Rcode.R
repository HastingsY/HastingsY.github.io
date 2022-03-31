##Yvette Hastings
##Geog 6165 Lab 7 Kernel Density
##Code written on 2/26/22; last updated on 2/27/22

##load libraries
library(sparr) 
library(readxl) 
library(dplyr) 
library(sf)

##load data and convert sf object
sod <- st_read("W7_Exercise_Data/data/sod/sod_pts.shp") 
sod <- st_transform(sod, crs = 4326)

##Transform coordinates to US Atlas Equal Area
sod_proj <- st_transform(sod, crs = 2163) %>% 
  st_coordinates(.) %>% 
  cbind(.,sod$Presence_A) %>% 
  as.data.frame(.) 
colnames(sod_proj) <- c("x", "y", "pres")

##load US boundary shape file and set to US Atlas Equal Area
sod_boundary <- st_read("W7_Exercise_Data/data/sod/sod_boundary.shp")
sod_boundary <- st_transform(sod_boundary, crs=2163)

##Reformat data tweets data into point pattern cases vs. controls
sod_ppp <- ppp(sod_proj$x, sod_proj$y, 
              marks = as.factor(sod_proj$pres), 
              window = as.owin(sod_boundary)) ##error was given the first time, used 'update.packages(ask = FALSE)' to fix issue

##calculate global bandwidth with over smoothing principle
h1 <- OS(sod_ppp, nstar="geometric")

##split ppp object into object for cases and controls
sodP <- sod_ppp[sod_ppp$marks == "1"] #sod present
sodNP <- sod_ppp[sod_ppp$marks == "0"] #no sod present


##bandwidth regimes to compute kernel density estimates
##Fixed Symmetric bandwidth (bandwidth is the same across study area)
sod_dens1 <- risk(f=sodP, g=sodNP, h0=h1, tolerate=TRUE, doplot=TRUE)

##Asymmetric Adaptive Bandwidths (bandwidths vary and are adapted to case and control densities)
##not recommended as it causes artifacts shown as halos of increased risk
sod_dens2 <- risk(f=sodP, g=sodNP, h0=h1, adapt=TRUE, hp=OS(sod_ppp)/2, 
                    tolerate=TRUE, davies.baddeley=0.05, doplot=TRUE)

##Symmetric (pooled) Adaptive Bandwidth (adapted to underlying point data) - fixed
sod_dens3 <- risk(f=sodP, g=sodNP, h0=h1, adapt=TRUE, tolerate=TRUE, hp=OS(sod_ppp)/2, 
                    pilot.symmetry="pooled", davies.baddeley=0.05, doplot=TRUE)

##Symmetric Bandwidths adaptive
f <- bivariate.density(sodP,h0=h1,hp=2,adapt=TRUE,pilot.density=sodNP, verbose=FALSE) 
g <- bivariate.density(sodNP,h0=h1,hp=2,adapt=TRUE,pilot.density=sodNP, verbose=FALSE) 
sod_dens4 <- risk(f=f,g=g,tolerate=TRUE,log=TRUE,doplot=TRUE)

