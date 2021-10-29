skip_if_not_installed("dplyr")

library(dplyr)
context("geom_quiver")

test_that("Simple trig quiver plot", {
  library(ggplot2)
  plotdata <- expand.grid(x = seq(0, pi, pi / 12), y = seq(0, pi, pi / 12)) %>%
    mutate(
      u = cos(x),
      v = sin(y)
    )

  plotdata %>%
    ggplot(aes(x = x, y = y, u = u, v = v)) +
    geom_quiver()

  plotdata %>%
    ggplot(aes(x = x, y = y, u = u, v = v)) +
    geom_quiver(rescale = TRUE)

  plotdata %>%
    ggplot(aes(x = x, y = y, u = u, v = v)) +
    geom_quiver(center = TRUE)

  plotdata %>%
    ggplot(aes(x = x, y = y, u = u, v = v)) +
    geom_quiver(vecsize = 0)

  data.frame(x = rnorm(10), y = rnorm(10)) %>%
    mutate(
      u = cos(x),
      v = sin(y)
    ) %>%
    ggplot(aes(x = x, y = y, u = u, v = v)) +
    geom_quiver()
})
