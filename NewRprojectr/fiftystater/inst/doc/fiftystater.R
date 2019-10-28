## ----example, fig.show='hold'--------------------------------------------
library(ggplot2)
library(fiftystater)

data("fifty_states") # this line is optional due to lazy data loading

crimes <- data.frame(state = tolower(rownames(USArrests)), USArrests)

# map_id creates the aesthetic mapping to the state name column in your data
p <- ggplot(crimes, aes(map_id = state)) + 
  # map points to the fifty_states shape data
  geom_map(aes(fill = Assault), map = fifty_states) + 
  expand_limits(x = fifty_states$long, y = fifty_states$lat) +
  coord_map() +
  scale_x_continuous(breaks = NULL) + 
  scale_y_continuous(breaks = NULL) +
  labs(x = "", y = "") +
  theme(legend.position = "bottom", 
        panel.background = element_blank())

p
# add border boxes to AK/HI
p + fifty_states_inset_boxes() 

## ----example_colorplaner, fig.width=6------------------------------------
# Map a second variable to each state's fill color with colorplaner
library(colorplaner)
p + aes(fill2 = UrbanPop) + scale_fill_colorplane() +
  theme(legend.position = "right")

## ----makemap, message=FALSE, eval=FALSE----------------------------------
#  # Create map data with AK, HI inset.
#  library(maptools)
#  library(rgeos)
#  library(rgdal)
#  library(dplyr)
#  
#  transform_state <- function(object, rot, scale, shift){
#    object %>% elide(rotate = rot) %>%
#      elide(scale = max(apply(bbox(object), 1, diff)) / scale) %>%
#      elide(shift = shift)
#  }
#  
#  #state shape file from
#  # http://www.arcgis.com/home/item.html?id=f7f805eb65eb4ab787a0a3e1116ca7e5
#  loc <- file.path(tempdir(), "stats_dat")
#  unzip(system.file("extdata", "states_21basic.zip", package = "fiftystater"),
#        exdir = loc)
#  fifty_states_sp <- readOGR(dsn = loc, layer = "states", verbose = FALSE) %>%
#    spTransform(CRS("+init=epsg:2163"))
#  
#  alaska <- fifty_states_sp[fifty_states_sp$STATE_NAME == "Alaska", ] %>%
#    transform_state(-35, 2.5, c(-2400000, -2100000))
#  proj4string(alaska) <- proj4string(fifty_states_sp)
#  
#  hawaii <- fifty_states_sp[fifty_states_sp$STATE_NAME == "Hawaii", ] %>%
#    transform_state(-35, .75, c(-1170000,-2363000))
#  proj4string(hawaii) <- proj4string(fifty_states_sp)
#  
#  fifty_states <-
#    fifty_states_sp[!fifty_states_sp$STATE_NAME %in% c("Alaska","Hawaii"), ] %>%
#    rbind(alaska) %>%
#    rbind(hawaii) %>%
#    spTransform(CRS("+init=epsg:4326")) %>%
#    fortify(region = "STATE_NAME") %>%
#    mutate(id = tolower(id))

