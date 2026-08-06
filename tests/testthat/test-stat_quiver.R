test_that("vecsize automatic detection checks x/y spacing independently", {
  library(ggplot2)
  # x-spacing is irregular (0, 1, 3) while y-spacing is regular (0, 1, 2, 3).
  # Pooling both dimensions' spacings together previously misdetected this as
  # a grid, purely because the pooled set of spacings ({1, 2, 1, 1, 1})
  # happened to contain few unique values, and incorrectly rescaled the
  # vectors to fit the (non-existent) grid.
  df <- expand.grid(x = c(0, 1, 3), y = c(0, 1, 2, 3))
  df$u <- 3
  df$v <- 0

  d <- layer_data(ggplot(df, aes(x, y, u = u, v = v)) + geom_quiver())

  arrow_length <- sqrt((d$xend - d$x)^2 + (d$yend - d$y)^2)
  expect_equal(unique(arrow_length), 3)
})

test_that("all-zero vectors do not divide by zero", {
  library(ggplot2)
  # When every vector has zero magnitude, `gridsize / max(veclength) * vecsize`
  # previously divided by zero, turning every position into NA with no
  # warning at all.
  df <- data.frame(x = 1:3, y = 1:3, u = 0, v = 0)

  d <- expect_no_warning(
    layer_data(ggplot(df, aes(x, y, u = u, v = v)) + geom_quiver())
  )

  expect_equal(d$x, 1:3)
  expect_equal(d$y, 1:3)
  expect_equal(d$xend, 1:3)
  expect_equal(d$yend, 1:3)
})

test_that("a single data point does not corrupt positions", {
  library(ggplot2)
  # With only one distinct x value and one distinct y value, no grid spacing
  # can be measured. This previously produced `min(): no non-missing
  # arguments to min; returning Inf`, whose Inf/NaN then corrupted even the
  # arrow's start position (x, y), not just its length.
  df <- data.frame(x = 1, y = 1, u = 1, v = 1)

  d <- expect_no_warning(
    layer_data(ggplot(df, aes(x, y, u = u, v = v)) + geom_quiver())
  )
  expect_equal(d$x, 1)
  expect_equal(d$y, 1)
  expect_equal(d$xend, 2)
  expect_equal(d$yend, 2)

  # An explicit, non-zero `vecsize` cannot be honoured either (there is no
  # grid to scale against), but should warn and fall back gracefully rather
  # than producing Inf/NaN.
  expect_warning(
    d2 <- layer_data(ggplot(df, aes(x, y, u = u, v = v)) + geom_quiver(vecsize = 2)),
    "could not determine a grid size"
  )
  expect_equal(d2$xend, 2)
  expect_equal(d2$yend, 2)
})

test_that("missing x/y aesthetics give a clear error", {
  library(ggplot2)
  # x and y were missing from required_aes, so omitting them produced a
  # cryptic low-level error ("attempt to apply non-function") from deep
  # inside compute_panel() instead of ggplot2's standard missing-aesthetics
  # message.
  df <- data.frame(u = 1:3, v = 1:3)
  p <- ggplot(df, aes(u = u, v = v)) + geom_quiver()

  expect_error(layer_data(p), "requires the following missing aesthetics")
})
