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

    gridpoints <- c(abs(diff(sort(unique(data$x)))), abs(diff(sort(unique(data$y)))))
    gridsize <- min(gridpoints, na.rm = TRUE)
    if (is.null(vecsize)) {
      # Detect if x and y form a grid
      vecsize <- if (length(unique(round(gridpoints, 2))) > 2) 0 else 1
    }
    data$veclength <- with(data, sqrt(u ^ 2 + v ^ 2))
    data$vectorsize <- if (vecsize == 0) 1 else gridsize / max(data$veclength, na.rm = TRUE) * vecsize

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
