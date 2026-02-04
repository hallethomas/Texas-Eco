library(dplyr)
library(leaflet)
library(sf)
library(tigris)
library(htmltools)
library(ggplot2)

here::i_am("analysis.R")
eco_path1 <- here::here("Data", "tx_eco_l3", "tx_eco_l3.shp")
eco_path2 <- here::here("Data", "tx_eco_l4", "tx_eco_l4.shp") 

eco_data1 <- st_read(eco_path1, quiet = TRUE)
eco_data2 <- st_read(eco_path2, quiet = TRUE)

## texas boundary from tigris
tx_boundary <- states(cb = TRUE) %>% 
  filter(STUSPS == "TX") %>%
  st_transform(st_crs(eco_data)) %>% 
  

eco_tx <- eco_data2 %>%
  st_transform(st_crs(tx_boundary)) %>%
  st_crop(tx_boundary) %>% 
  st_intersects(tx_boundary, sparse = FALSE) %>%
  eco_data[., ]

mapview::mapview(eco_tx, zcol = "US_L4NAME") 


pal <- colorFactor(topo.colors(length(unique(eco_tx$US_L4NAME))), eco_tx$US_L4NAME)

map <- leaflet() %>%
  addTiles() %>%
  addPolygons(
    data = st_transform(eco_tx, 4326),
    fillColor = ~pal(US_L4NAME),
    color = "black",
    weight = 1,
    opacity = 1,
    fillOpacity = 0.5,
    popup = ~htmlEscape(US_L4NAME),
    highlightOptions = highlightOptions(
      weight = 3,
      color = "#666",
      bringToFront = TRUE
    )
  )
map


