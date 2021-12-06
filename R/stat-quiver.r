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
    gridpoints <- c(abs(diff(sort(unique(data$x)))), abs(diff(sort(unique(data$y)))))
    gridsize <- min(gridpoints, na.rm = TRUE)
    if (is.null(vecsize)) {
      # Detect if x and y form a grid
      vecsize <- if (length(unique(round(gridpoints, 2))) > 2) 0 else 1
    }
    center <- if (center) 0.5 else 0
    data <- data[with(data, u != 0 | v != 0),]
    data$veclength <- with(data, sqrt(u ^ 2 + v ^ 2))
    data$vectorsize <-  if (vecsize == 0) 1 else gridsize / max(data$veclength, na.rm = TRUE) * vecsize
    data$xend <- with(data, x + (1 - center) * u * vectorsize)
    data$yend <- with(data, y + (1 - center) * v * vectorsize)
    data$x <- with(data, x - center * u * vectorsize)
    data$y <- with(data, y - center * v * vectorsize)
    data
  }
)
