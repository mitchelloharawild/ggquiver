context("geom_quiver")

test_that("Simple trig quiver plot", {
  library(ggplot2)
  plotdata <- expand.grid(x = seq(0, pi, pi / 12), y = seq(0, pi, pi / 12))
  plotdata$u <- cos(plotdata$x)
  plotdata$v <- sin(plotdata$y)

  plotdata |>
    ggplot(aes(x = x, y = y, u = u, v = v)) +
    geom_quiver()

  plotdata |>
    ggplot(aes(x = x, y = y, u = u, v = v)) +
    geom_quiver(rescale = TRUE)

  plotdata |>
    ggplot(aes(x = x, y = y, u = u, v = v)) +
    geom_quiver(center = TRUE)

  plotdata |>
    ggplot(aes(x = x, y = y, u = u, v = v)) +
    geom_quiver(vecsize = 0)

  randdata <- data.frame(x = rnorm(10), y = rnorm(10))
  randdata$u <- cos(randdata$x)
  randdata$v <- sin(randdata$y)
  
  randdata |>
    ggplot(aes(x = x, y = y, u = u, v = v)) +
    geom_quiver()
})

test_that("Custom arrows with grid::arrow", {
  library(ggplot2)
  plotdata <- expand.grid(x = seq(0, pi, pi / 12), y = seq(0, pi, pi / 12))
  plotdata$u <- cos(plotdata$x)
  plotdata$v <- sin(plotdata$y)

  p <- plotdata |>
    ggplot(aes(x = x, y = y, u = u, v = v)) +
    geom_quiver(arrow = grid::arrow(type = "closed"))
  vdiffr::expect_doppelganger("quiver plot with closed arrow", p)
})