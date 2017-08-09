library(dplyr)
context("geom_quiver")

test_that("str_length is number of characters", {
  expand.grid(x=seq(0,pi,pi/12), y=seq(0,pi,pi/12)) %>%
    mutate(u = cos(x),
           v = sin(y)) %>%
    ggplot(aes(x=x,y=y,u=u,v=v)) +
    geom_quiver()

  ggplot(seals, aes(long, lat)) +
    geom_segment(aes(xend = long + delta_long, yend = lat + delta_lat),
                 arrow = arrow(length = unit(0.1,"cm"))) +
    borders("state") + coord_fixed()

  ggplot(seals, aes(x=long, y=lat, u=delta_long, v=delta_lat)) +
    geom_quiver() +
    borders("state") + coord_fixed()
})
