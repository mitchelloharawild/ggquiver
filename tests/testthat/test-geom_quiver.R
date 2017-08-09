library(dplyr)
context("geom_quiver")

test_that("str_length is number of characters", {
  expand.grid(x=seq(0,pi,pi/12), y=seq(0,pi,pi/12)) %>%
    mutate(u = cos(x),
           v = sin(y)) %>%
    ggplot(aes(x=x,y=y,u=u,v=v)) +
    geom_quiver()
})
