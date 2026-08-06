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
  draw_key = function(data, params, size) {
    # GeomSegment's draw_key already draws an arrowhead when an `arrow` is
    # present in params, but (unlike draw_panel) it never sees draw_panel's
    # default `arrow = grid::arrow()` unless the user set `arrow` explicitly
    # in the layer call. Fill in the same default here so quiver legend keys
    # look like arrows rather than plain lines.
    if (!"arrow" %in% names(params)) {
      params$arrow <- grid::arrow()
    }
    # The panel scales arrowhead length to each vector's length, but the key
    # has no such reference: an arrow sized for a full-length panel vector
    # (e.g. the default 0.25in) can dwarf the small legend key, especially
    # for "closed" arrowheads. Cap the key's arrowhead at a fraction of the
    # key size so it always reads as an arrow rather than a solid wedge.
    if (!is.null(params$arrow)) {
      max_length <- grid::unit(min(size) * 0.3, "mm")
      if (grid::convertUnit(params$arrow$length, "mm", valueOnly = TRUE) >
          grid::convertUnit(max_length, "mm", valueOnly = TRUE)) {
        params$arrow$length <- max_length
      }
    }
    ggplot2::GeomSegment$draw_key(data, params, size)
  },
  draw_panel = function(
    data, panel_params, coord,
    arrow = grid::arrow(),
    lineend = "butt"
  ) {
    # Arrow angles are only accurate for fixed-aspect coordinate systems.
    # Raise a console message if the angles are distorted by free aspect ratios.
    if (is.null(coord$aspect(panel_params))) {
      x_range <- panel_params$x.range
      y_range <- panel_params$y.range
      if (length(x_range) == 2 && length(y_range) == 2) {
        x_span <- diff(x_range)
        y_span <- diff(y_range)
        # Even a fairly small deviation from a 1:1 aspect ratio is enough to
        # visibly skew arrow angles, so this only tolerates spans that are
        # (nearly) equal rather than requiring some large mismatch.
        if (!is.na(x_span) && !is.na(y_span) && x_span > 0 && y_span > 0) {
          if (abs(x_span - y_span) > 0.01) {
            cli::cli_inform(c(
              "!" = "{.fn geom_quiver} arrow angles can be misleading with asymmetric aspect ratios.",
              "i" = "x and y are not drawn to the same scale, so on-screen arrow angles differ from the true angles.",
              "i" = "Use {.fn coord_fixed} or {.fn coord_equal} for accurate arrow angles."
            ))
          }
        }
      }
    }

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
