#' Quiver plots for ggplot2
#'
#' @description
#' Displays the direction and length of vectors on a graph.
#'
#' @inheritParams ggplot2::layer
#'
#' @examples
#'
#'  ggplot(seals, aes(x=long, y=lat, u=delta_long, v=delta_lat)) +
#'    geom_quiver() +
#'    borders("state") +
#'    coord_fixed()
#'
#' @importFrom ggplot2 layer
#'
#' @export
geom_quiver <- function(mapping = NULL, data = NULL,
                       stat = "quiver", position = "identity",
                       na.rm = FALSE,
                       show.legend = NA,
                       inherit.aes = TRUE,
                       ...) {
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomQuiver,
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
#' @export
GeomQuiver <- ggproto("GeomQuiver", ggplot2::GeomSegment,
                     draw_panel = function(data, panel_params, coord, arrow = NULL, lineend = "butt", na.rm = FALSE) {
                       trans <- coord$transform(data, panel_params) %>%
                         mutate(arrowsize = sqrt((x-xend)^2 + (y-yend)^2)*0.5)
                       grid::segmentsGrob(
                         trans$x, trans$y, trans$xend, trans$yend,
                         default.units = "native",
                         gp = grid::gpar(
                           col = alpha(trans$colour, trans$alpha),
                           lwd = trans$size * .pt,
                           lty = trans$linetype,
                           lineend = lineend),
                         arrow = grid::arrow(length = unit(trans$arrowsize, "npc"))
                       )
                     }
)
