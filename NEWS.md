# ggquiver 0.5.0
* Fixed automatic `vecsize` grid detection incorrectly rescaling arrows for 
  irregularly spaced data (e.g. GPS coordinates) whenever the x- and y-spacings
  happened to coincide.
* Automatic `vecsize` grid detection now warns instead of erroring when a grid 
  size can't be determined (e.g. a single data point), leaving arrows unscaled.
* `geom_quiver()` now hints to use `coord_fixed()`/`coord_equal()` if needed (#10).
* Legend keys now show an arrowhead, matching the arrows drawn in the panel.


# ggquiver 0.4.0
* Arrows now respect scale transformations on x/y aesthetics (#13).
* Arrows now support `grid::arrow()` appearance options (#14).

# ggquiver 0.3.3
* Remove suggest for ggmap due to upstream api requirements.

# ggquiver 0.3.2 (6 December 2021)
* Improve usage of plot coordinate system when scaling arrow size (#9).
* Fixed angle of line when centered arrows are used.

# ggquiver 0.3.1 (25 November 2021)
* Fixed issue with plotting resized vectors using the `vecsize` option (#8).

# ggquiver 0.3.0 (29 October 2021)
* Improved handling of non cartesian coordinate systems.
* Fixed issue with plotting arrows on `ggmap::qmplot()` (#7).
* Performance improvements.

# Version 0.2.0 (5 February 2019)
* Changed ggplot2 to import
* Updated README to reflect ggmap changes

# Version 0.1.0 (9 August 2017)
* Added automatic grid detection
* Added a `NEWS.md`.
* Added `geom_quiver()` and `stat_quiver()`
* Added unit tests
