#' Quiver plots for ggplot2
#'
#' @description
#' Displays the direction and length of vectors on a graph.
#'
#' @inheritParams ggplot2::layer
#'
#' @examples
#'
#' expand.grid(x=seq(0,pi,pi/12), y=seq(0,pi,pi/12)) %>%
#'   mutate(u = cos(x),
#'          v = sin(y)) %>%
#'   ggplot(aes(x=x,y=y,u=u,v=v)) +
#'   geom_quiver()
#'
#' \dontrun{
#' library(ggmap)
#' wind_data <- wind %>% filter(between(lon, -96, -93) & between(lat, 28.7, 30))
#' qmplot(lon, lat, data=wind_data, extent="panel", geom = "blank", zoom=8, maptype = "toner-lite") +
#'   geom_quiver(aes(u=delta_lon, v=delta_lat, colour = spd))
#' }
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
                       trans <- CoordCartesian$transform(data, panel_params) %>%
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
