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
                        na.rm = FALSE,
                        show.legend = NA,
                        inherit.aes = TRUE,
                        ...)
{
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
      ...
    )
  )
}


#' @rdname geom_quiver
#'
#' @importFrom dplyr %>% filter mutate
#'
#' @export
StatQuiver <- ggplot2::ggproto(
  "StatQuiver", ggplot2::Stat,
  required_aes = c("u", "v"),

  compute_panel = function(self, data, scales, na.rm=FALSE) {
    gridsize <- min(abs(diff(unique(data$x))), abs(diff(unique(data$y))))
    data %>%
      filter(u!=0 | v!=0) %>%
      mutate(vecsize = sqrt(u^2 + v^2),
             vecscale = gridsize/max(vecsize),
             xend = x + u*vecscale, yend = y + v*vecscale)
  }
)
