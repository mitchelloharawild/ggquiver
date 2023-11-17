
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R-CMD-check](https://github.com/mitchelloharawild/ggquiver/workflows/R-CMD-check/badge.svg)](https://github.com/mitchelloharawild/ggquiver/actions)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/ggquiver)](https://cran.r-project.org/package=ggquiver)
[![Downloads](http://cranlogs.r-pkg.org/badges/ggquiver?color=brightgreen)](https://cran.r-project.org/package=ggquiver)
<!-- badges: end -->

# ggquiver

Quiver plots for ggplot2. An extension of ‘ggplot2’ to provide quiver
plots to visualise vector fields. This functionality is implemented
using a geom to produce a new graphical layer, which allows aesthetic
options. This layer can be overlaid on a map to improve visualisation of
mapped data.

## Installation

The **stable** version can be installed from CRAN:

``` r
install.packages("ggquiver")
```

The **development** version can be installed from GitHub using:

``` r
# install.packages("remotes")
remotes::install_github("mitchelloharawild/ggquiver")
```

## Usage

*ggquiver* introduces a new geom `geom_quiver()`, which produces a
quiver plot in *ggplot2*.

Quiver plots for functions can easily be produced using ggplot
aeshetics. When a grid is detected, the size of the vectors are
automatically adjusted to fit within the grid.

``` r
library(ggplot2)
library(ggquiver)
expand.grid(x=seq(0,pi,pi/12), y=seq(0,pi,pi/12)) %>%
  ggplot(aes(x=x,y=y,u=cos(x),v=sin(y))) +
  geom_quiver()
```

![](man/figures/README-quiverplot-1.png)<!-- -->

The *ggplot2* example for seal movements is easily reproduced, with
appropriately scaled arrowhead sizes. Here, the vecsize is set to zero
to not resize the vectors.

``` r
ggplot(seals, aes(x=long, y=lat, u=delta_long, v=delta_lat)) + 
  geom_quiver(vecsize=0) + 
  borders("state")
```

![](man/figures/README-sealplot-1.png)<!-- -->

Quiver plot arrows can be centered about x and y coordinates, which is
useful when working with maps and scaled vectors.

``` r
ggplot(seals, aes(x=long, y=lat, u=delta_long, v=delta_lat)) + 
  geom_quiver(vecsize=0, center = TRUE) + 
  borders("state")
```

![](man/figures/README-sealplot-centered-1.png)<!-- -->
