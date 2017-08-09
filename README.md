<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/mitchelloharawild/ggquiver.svg?branch=master)](https://travis-ci.org/mitchelloharawild/ggquiver) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/ggquiver)](https://cran.r-project.org/package=ggquiver) [![Downloads](http://cranlogs.r-pkg.org/badges/ggquiver?color=brightgreen)](https://cran.r-project.org/package=ggquiver)

ggquiver
========

Quiver plots for ggplot2.

Installation
------------

The development version of ggquiver can be installed from Github using:

``` r
# install.packages("devtools")
devtools::install_github("mitchelloharawild/ggquiver")
```

Usage
-----

**ggquiver** introduces a new geom `geom_quiver()`, which produces a quiver plot in *ggplot2*.

``` r
expand.grid(x=seq(0,pi,pi/12), y=seq(0,pi,pi/12)) %>%
  mutate(u = cos(x),
         v = sin(y)) %>%
  ggplot(aes(x=x,y=y,u=u,v=v)) +
  geom_quiver()
```

![](man/figure/quiverplot-1.png)

``` r
library(ggmap)

wind_data <- wind %>% filter(between(lon, -96, -93) & between(lat, 28.7, 30))
qmplot(lon, lat, data=wind_data, extent="panel", geom = "blank", zoom=8, maptype = "toner-lite") + 
  geom_quiver(aes(u=delta_lon, v=delta_lat, colour = spd))
```

![](man/figure/windplot-1.png)
