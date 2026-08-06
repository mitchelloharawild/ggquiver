#' @rdname geom_quiver
#' @inheritParams ggplot2::stat_identity
#' @param na.rm If \code{FALSE} (the default), removes missing values with a warning. If \code{TRUE} silently removes missing values.
#' @section Computed variables:
#' \describe{
#' \item{x}{centered x start position for velocity arrow}
#' \item{y}{centered y start position for velocity arrow}
#' \item{xend}{centered x end position for velocity arrow}
#' \item{yend}{centered y end position for velocity arrow}
#' }
#' @export
stat_quiver <- function(mapping = NULL, data = NULL,
                        geom = "quiver", position = "identity",
                        center = FALSE,
                        rescale = FALSE,
                        vecsize = NULL,
                        na.rm = FALSE,
                        show.legend = NA,
                        inherit.aes = TRUE,
                        ...) {
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = StatQuiver,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      center = center,
      rescale = rescale,
      vecsize = vecsize,
      ...
    )
  )
}


#' @rdname geom_quiver
#'
#' @export
StatQuiver <- ggplot2::ggproto(
  "StatQuiver", ggplot2::Stat,
  required_aes = c("u", "v"),

  compute_panel = function(self, data, scales, center=FALSE, rescale=FALSE, vecsize=NULL, na.rm=FALSE) {
    if (rescale) {
      data$u <- as.numeric(scale(data$u))
      data$v <- as.numeric(scale(data$v))
    }
    
    # Invert scaling on positional aesthetics
    data$x <- scales$x$get_transformation()$inverse(data$x)
    data$y <- scales$y$get_transformation()$inverse(data$y)

    x_diffs <- abs(diff(sort(unique(data$x))))
    y_diffs <- abs(diff(sort(unique(data$y))))
    gridpoints <- c(x_diffs, y_diffs)
    # With a single distinct x value and a single distinct y value (e.g. one
    # data point), no spacing can be measured in either dimension and no
    # grid size can be identified.
    gridsize <- if (length(gridpoints) > 0) min(gridpoints, na.rm = TRUE) else NA_real_
    is_regular <- function(diffs) length(diffs) == 0 || length(unique(round(diffs, 2))) == 1
    if (is.null(vecsize)) {
      # Detect if x and y form a grid. Regularity is checked separately for
      # each dimension (rather than pooling x- and y-spacings together),
      # since irregular real-world data (e.g. GPS coordinates) can otherwise
      # be misclassified as a grid whenever the x- and y-spacings happen to
      # coincide.
      vecsize <- if (!is.na(gridsize) && is_regular(x_diffs) && is_regular(y_diffs)) 1 else 0
    }
    data$veclength <- with(data, sqrt(u ^ 2 + v ^ 2))
    maxveclength <- max(data$veclength, na.rm = TRUE)
    data$vectorsize <- if (vecsize == 0 || maxveclength == 0) {
      # When every vector has zero length there is nothing to scale against
      # (this would otherwise divide by zero and turn every position into NA).
      1
    } else if (is.na(gridsize)) {
      warning(
        "stat_quiver: could not determine a grid size to scale `vecsize` ",
        "against (at least two distinct x or y values are needed); ",
        "vectors will not be scaled.",
        call. = FALSE
      )
      1
    } else {
      gridsize / maxveclength * vecsize
    }

    # Compute vector start and end positions on original scale
    c <- if (center) 0.5 else 0
    data$xend <- with(data, x + (1 - c) * u * vectorsize)
    data$yend <- with(data, y + (1 - c) * v * vectorsize)
    data$x <- with(data, x - c * u * vectorsize)
    data$y <- with(data, y - c * v * vectorsize)

    # Apply scale transformations to vectors
    transform(
      data,
      x = scales$x$transform(x),
      y = scales$y$transform(y),
      xend = scales$x$transform(xend),
      yend = scales$y$transform(yend)
    )
  }
)
