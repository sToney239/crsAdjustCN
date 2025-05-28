#' Revert transformation of `sf` object among `gcj02`, `bd09` and `wgs` coordinate systems
#'
#' @param obj A `sf` class object to be transformed
#' @param from A string of the shortcut coordinate system name of `obj`, should be one of "gcj", "bd" and "wgs"
#' @param to A string of the shortcut coordinate system name of the output, should be one of "gcj", "bd" and "wgs"
#' @param accurate A logical scalar indicating whether to use a more accurate algorithm. \cr
#' The more accurate code is written in C++, theoretically it would be efficient. \cr
#' However, if execution time is excessive, consider switching to `FALSE` to use a less accurate but faster mode.
#'
#' @returns A `sf` class object, with modified geometry after transformation
#' @export
#'
#' @examples test_point = cbind(data.frame(x = 1), sf::st_sfc(sf::st_point(c(120,36))))
#' st_crs_adjust( sf::st_as_sf(test_point,crs = 4326))
st_crs_adjust = function(obj, from = "gcj", to = "wgs", accurate = TRUE) {
  if (!sf::st_is_longlat(obj)) {
    obj = sf::st_transform(obj, "WGS84")
  }
  check_within = all( sf::st_within(obj,sf::st_polygon(list(boundary_convex)),sparse=FALSE))
  if (!check_within) {
    stop("Input not within China Extent")
  }
  shift_fun = switch (paste0(from,"_",to),
                       "bd_gcj" = bd_gcj,
                       "bd_wgs" = ifelse(accurate, bd_wgs_accu, bd_wgs),
                       "gcj_bd" = gcj_bd,
                       "gcj_wgs" = ifelse(accurate, gcj_wgs_accu, gcj_wgs),
                       "wgs_bd" = wgs_bd,
                       "wgs_gcj" = wgs_gcj)
  geometry_reconstruct_fun = switch (as.character(sf::st_geometry_type(obj, by_geometry = FALSE)),
                       "POINT" = convert_point,
                       "MULTIPOLYGON" = convert_multipolygon,
                       "LINESTRING" = convert_linestring,
                       "POLYGON" = convert_polygon,
                       "MULTILINESTRING" = convert_multilinestring,
                       "MULTIPOINT" = convert_multipoint
  )
  obj_df = sf::st_coordinates(obj)
  after_modified = shift_fun(obj_df[,"X"],obj_df[,"Y"])
  obj_df[,"X"] = after_modified[["X"]]
  obj_df[,"Y"] = after_modified[["Y"]]
  base_df = sf::st_drop_geometry(obj)
  base_df[["geometry"]] = geometry_reconstruct_fun(obj_df)
  sf::st_as_sf(base_df)
}
