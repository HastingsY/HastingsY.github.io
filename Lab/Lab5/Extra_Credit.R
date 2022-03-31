##Yvette Hastings
##Week 5 Extra Credit 3D mapping
##February 16, 2022

setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) ##set working directory to lab 5 folder

##install packages and load libraries
install.packages("plotly") 
library(plotly) 

fig <- plot_ly(z = ~volcano) %>% add_surface( 
  contours = list( 
    z = list( 
      show=TRUE, 
      usecolormap=TRUE, 
      highlightcolor="#ff0000", 
      project=list(z=TRUE) 
      ) 
    ) 
  )

##change viewpoint position
fig <- fig %>% layout( 
  scene = list( 
    camera=list( 
      eye = list(x=1.87, y=0.88, z=-0.64) 
      ) 
    ) 
  ) 
fig

Sys.setenv("plotly_username"= "u1105374") 
Sys.setenv("plotly_api_key"="XsjKXpsE3vQdKDVBuOCJ") 
chart_link = api_create(fig, filename="volcano") 
chart_link


##Grandeur Peak
##load more libraries
library(raster) 
library(rgdal)

##load raster
dem <- raster(x = "Ex5_Extra_Credit_data/grandeur/w001001.adf")

dem
##Convert the raster to a matrix
dem_mat <- t(as.matrix(dem))

##setup and create ploty fig
Grand <- plot_ly(z = ~dem_mat) %>% add_surface( 
  contours = list(
  z = list( 
    show=TRUE, 
    usecolormap=TRUE, 
    highlightcolor="#ff0000", project=list(z=TRUE) 
    ) 
  ) 
  ) 
Grand <- Grand %>% layout( 
  scene = list( 
    camera=list( 
      eye = list(x=1.87, y=0.88, z=-0.64) 
      ) 
    ) 
)
Grand


##Extra Credit
##load raster
Baker <- raster(x = "Baker2/w001001.adf")

##Convert the raster to a matrix
Baker_mat <- t(as.matrix(Baker))

##setup and create ploty fig
Baker <- plot_ly(z = ~Baker_mat) %>% add_surface( 
  contours = list(
    z = list( 
      show=TRUE, 
      usecolormap=TRUE, 
      highlightcolor="#ff0000", project=list(z=TRUE) 
    ) 
  ) 
) 

##add custom grid
axx <- list(
  gridcolor='rgb(255, 255, 255)',
  zerolinecolor='rgb(255, 255, 255)',
  showbackground=TRUE,
  backgroundcolor='rgb(230, 230,230)'
)

Baker <- Baker %>% layout(
  title = "Mt Baker, Washington State",
  scene = list(aspectmode = 'cube'))
   # select the type of aspectmode
  # scene = list(domain=list(x=c(0,0.5),y=c(0.5,1)),
  #              xaxis=axx, yaxis=axx, zaxis=axx,
  #              
  #              # select the type of aspectmode
  #              aspectmode='cube'))

# Baker <- Baker %>% layout( 
#   scene = list( 
#     camera=list( 
#       eye = list(x=1.87, y=0.88, z=-0.64) 
#     ) 
#   ) 
# )

Baker








