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

test_that("Warns when coord isn't fixed and x/y aspect ratio isn't ~1:1", {
  library(ggplot2)
  d <- data.frame(x = c(0, 1000), y = c(0, 1), u = c(1, 1), v = c(1, 1))

  p <- ggplot(d, aes(x = x, y = y, u = u, v = v)) +
    geom_quiver()
  expect_message(
    ggplotGrob(p),
    "arrow angles can be misleading"
  )

  # coord_fixed() enforces a fixed aspect ratio, so no warning is needed
  p_fixed <- p + coord_fixed()
  expect_no_message(
    ggplotGrob(p_fixed),
    message = "arrow angles can be misleading"
  )

  # Even a fairly small (~20%) deviation from a 1:1 aspect ratio is enough
  # to visibly skew arrow angles, so it should still be flagged.
  d_small <- data.frame(x = c(0, 12), y = c(0, 10), u = c(1, 1), v = c(1, 1))
  p_small <- ggplot(d_small, aes(x = x, y = y, u = u, v = v)) +
    geom_quiver()
  expect_message(
    ggplotGrob(p_small),
    "arrow angles can be misleading"
  )
})

test_that("Legend key shows an arrowhead", {
  skip_if_not_installed("vdiffr")
  library(ggplot2)
  plotdata <- expand.grid(x = seq(0, pi, pi / 12), y = seq(0, pi, pi / 12))
  plotdata$u <- cos(plotdata$x)
  plotdata$v <- sin(plotdata$y)
  plotdata$g <- ifelse(plotdata$x < pi / 2, "a", "b")

  p <- plotdata |>
    ggplot(aes(x = x, y = y, u = u, v = v, colour = g)) +
    geom_quiver()
  vdiffr::expect_doppelganger("quiver plot with legend arrowhead", p)
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