#' Quiver plots for ggplot2
#'
#' @description
#' Displays the direction and length of vectors on a graph.
#'
#' @inheritParams ggplot2::layer
#' @param center If \code{FALSE} (the default), the vector lines will start at the specified x and y. If \code{TRUE}, the arrows will be centered about x and y.
#' @param rescale If \code{FALSE} (the default), the vectors will not be rescaled. If \code{TRUE}, the vectors given by (u, v) will be rescaled using the \code{scale} function.
#' @param vecsize By default (NULL), vectors sizing is automatically determined. If a grid can be identified, they will be scaled to the grid, if not, the vectors will not be scaled. By specifying a numeric input here, the length of all arrows can be adjusted. Setting vecsize to zero will prevent scaling the arrows.
#'
#' @examples
#' library(ggplot2)
#' # Quiver plots of mathematical functions
#' field <- expand.grid(x=seq(0,pi,pi/12), y=seq(0,pi,pi/12))
#' ggplot(field, aes(x=x,y=y,u=cos(x),v=sin(y))) +
#'   geom_quiver()
#'
#' # Removing automatic scaling
#' ggplot(seals, aes(x=long, y=lat, u=delta_long, v=delta_lat)) +
#'   geom_quiver(vecsize=NULL) +
#'   borders("state")
#'
#' @importFrom ggplot2 layer
#'
#' @export
geom_quiver <- function(mapping = NULL, data = NULL,
                        stat = "quiver", position = "identity",
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
    stat = stat,
    geom = GeomQuiver,
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
GeomQuiver <- ggproto(
  "GeomQuiver", ggplot2::GeomSegment,
  draw_panel = function(
    data, panel_params, coord, 
    arrow = grid::arrow(), 
    lineend = "butt", na.rm = FALSE
  ) {
    # Apply coordinate transformations to get proper arrow lengths
    if(inherits(coord, "CoordMap")) {
      # Workaround for CoordMap transform method not transforming xend and yend
      t_data <- coord$transform(data[c("x", "y")], panel_params)
      t_data[c("xend", "yend")] <- coord$transform(
        `colnames<-`(data[c("xend", "yend")], c("x", "y")),
        panel_params
      )
    } else {
      t_data <- coord$transform(data, panel_params)
    }
    
    arrow$length <- arrow$length*10*with(t_data, sqrt((x - xend) ^ 2 + (y - yend) ^ 2) * 0.5)

    # Re-use segments to produce arrows
    ggplot2::GeomSegment$draw_panel(
      data, panel_params, coord,
      arrow = arrow, lineend = lineend
    )
  }
)
