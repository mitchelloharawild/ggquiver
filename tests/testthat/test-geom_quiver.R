test_that("Simple trig quiver plot", {
  skip_if_not_installed("vdiffr")
  library(ggplot2)
  plotdata <- expand.grid(x = seq(0, pi, pi / 12), y = seq(0, pi, pi / 12))
  plotdata$u <- cos(plotdata$x)
  plotdata$v <- sin(plotdata$y)

  p1 <- plotdata |>
    ggplot(aes(x = x, y = y, u = u, v = v)) +
    geom_quiver()
  vdiffr::expect_doppelganger("basic quiver plot", p1)

  p2 <- plotdata |>
    ggplot(aes(x = x, y = y, u = u, v = v)) +
    geom_quiver(rescale = TRUE)
  vdiffr::expect_doppelganger("quiver plot with rescale", p2)

  p3 <- plotdata |>
    ggplot(aes(x = x, y = y, u = u, v = v)) +
    geom_quiver(center = TRUE)
  vdiffr::expect_doppelganger("quiver plot with center", p3)

  p4 <- plotdata |>
    ggplot(aes(x = x, y = y, u = u, v = v)) +
    geom_quiver(vecsize = 0)
  vdiffr::expect_doppelganger("quiver plot with vecsize 0", p4)

  set.seed(123)
  randdata <- data.frame(x = rnorm(10), y = rnorm(10))
  randdata$u <- cos(randdata$x)
  randdata$v <- sin(randdata$y)
  
  p5 <- randdata |>
    ggplot(aes(x = x, y = y, u = u, v = v)) +
    geom_quiver()
  vdiffr::expect_doppelganger("quiver plot with random data", p5)
})

test_that("Custom arrows with grid::arrow", {
  skip_if_not_installed("vdiffr")
  library(ggplot2)
  plotdata <- expand.grid(x = seq(0, pi, pi / 12), y = seq(0, pi, pi / 12))
  plotdata$u <- cos(plotdata$x)
  plotdata$v <- sin(plotdata$y)

  p <- plotdata |>
    ggplot(aes(x = x, y = y, u = u, v = v)) +
    geom_quiver(arrow = grid::arrow(type = "closed"))
  vdiffr::expect_doppelganger("quiver plot with closed arrow", p)
})