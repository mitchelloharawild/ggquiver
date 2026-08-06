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
#' @section Vector fields from functions:
#' No special handling is needed to plot the vector field of a mathematical function: \code{u} and \code{v} are ordinary aesthetics, so a grid of coordinates from \code{expand.grid()} can be mapped through them directly, e.g. \code{aes(u = cos(x), v = sin(y))}. The automatic grid-based \code{vecsize} scaling detects the spacing of the generated grid and sizes the arrows to fit, so the resolution of the grid can be changed freely without arrows overlapping. When \code{u} and \code{v} are more naturally computed together from a single \code{function(x, y)} (for example, a system of differential equations), evaluate it once over the grid and bind the result instead — see the last example below.
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
#' # Vector field from a joint function of x and y
#' spiral <- function(x, y) data.frame(u = -y - 0.3*x, v = x - 0.3*y)
#' field <- expand.grid(x=seq(-2,2,length.out=11), y=seq(-2,2,length.out=11))
#' field <- cbind(field, spiral(field$x, field$y))
#' ggplot(field, aes(x, y, u=u, v=v)) +
#'   geom_quiver()
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
    lineend = "butt"
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
