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
