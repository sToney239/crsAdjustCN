convert_multipolygon <- function(obj_coord) {
  multipolygon = sfheaders::sfc_multipolygon(obj_coord,
                                             x = "X", y = "Y",
                                             multipolygon_id = "L3",
                                             polygon_id = "L2",
                                             linestring_id = "L1")
  sf::st_set_crs(multipolygon, 4326)
}

convert_polygon <- function(obj_coord) {
  polygon = sfheaders::sfc_polygon(obj_coord,
                                   x = "X", y = "Y",
                                   polygon_id = "L2",
                                   linestring_id = "L1")
  sf::st_set_crs(polygon, 4326)
}

convert_multilinestring <- function(obj_coord) {
  multilinestring = sfheaders::sfc_multilinestring(obj_coord,
                                                   x = "X", y = "Y",
                                                   multilinestring_id = "L2",
                                                   linestring_id = "L1")
  sf::st_set_crs(multilinestring, 4326)
}

convert_linestring <- function(obj_coord) {
  linestring = sfheaders::sfc_linestring(obj_coord,
                                         x = "X", y = "Y",
                                         linestring_id = "L1")
  sf::st_set_crs(linestring, 4326)
}

convert_multipoint <- function(obj_coord) {
  multipoint = sfheaders::sfc_multipoint(obj_coord,
                                         x = "X", y = "Y",
                                         multipoint_id = "L1")
  sf::st_set_crs(multipoint, 4326)
}

convert_point <- function(obj_coord) {
  sf::st_set_crs(sfheaders::sfc_point(obj_coord), 4326)
}

