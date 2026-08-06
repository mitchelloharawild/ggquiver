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
