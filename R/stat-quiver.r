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
                        scale = 1,
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
      center = center,
      scale = scale,
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

  compute_panel = function(self, data, scales, center=FALSE, scale=1, na.rm=FALSE) {
    gridsize <- min(abs(diff(unique(data$x))), abs(diff(unique(data$y))), na.rm = TRUE)
    center <- if(center) 0.5 else 0
    data %>%
      filter(u!=0 | v!=0) %>%
      mutate(vecsize = sqrt(u^2 + v^2),
             vecscale = if(is.null(scale)){1}else if(scale==0){1}else{gridsize/max(vecsize, na.rm=TRUE) * scale},
             xend = x + (1-center)*u*vecscale, yend = y + (1-center)*v*vecscale,
             x = x - center*u*vecscale, y = y - center*v*vecscale)
  }
)
