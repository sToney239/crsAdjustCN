convert_multipolygon0 <- function(obj_coord) {
  # test_mat[test_mat[,"L3"]==4, c("X","Y")]
  obj_df = as.data.frame(obj_coord)
  splitted_L3 = split(obj_df, obj_df[["L3"]])
  splitted_multipolygon = lapply(splitted_L3, \(L3) {
    splitted_L2 = split(L3, L3[["L2"]])
    base_multipolygon = lapply(splitted_L2, \(L2){
      splitted_L1 = split(L2, L2[["L1"]])
      lapply(splitted_L1, \(L1){
        as.matrix(L1[,c("X","Y")])
      })
    })
    sf::st_multipolygon(base_multipolygon)
  })
  # final_multipolygon = Reduce(c, splitted_multipolygon)
  # sf::st_sfc(final_multipolygon, crs = 4326)
  sf::st_sfc(splitted_multipolygon, crs = 4326)
}

convert_polygon0 <- function(obj_coord) {
  obj_df = as.data.frame(obj_coord)
  splitted_L2 = split(obj_df, obj_df[["L2"]])
  base_polygon = lapply(splitted_L2, \(input_L2){
    splitted_L1 = split(input_L2, input_L2[["L1"]])
    base_polygon_matrix = lapply(splitted_L1, \(input_L1){
      as.matrix(input_L1[,c("X","Y")])
    })
    sf::st_polygon(base_polygon_matrix)
  })
  # final_polygon = Reduce(c, base_polygon)
  # sf::st_sfc(final_polygon, crs = 4326)
  sf::st_sfc(base_polygon, crs = 4326)
}
convert_multilinestring0 <- function(obj_coord) {
  obj_df = as.data.frame(obj_coord)
  splitted_L2 = split(obj_df, obj_df[["L2"]])
  base_multilinestring = lapply(splitted_L2, \(input_L2){
    splitted_L1 = split(input_L2, input_L2[["L1"]])
    base_multilinestring_matrix = lapply(splitted_L1, \(input_L1){
      as.matrix(input_L1[,c("X","Y")])
    })
    sf::st_multilinestring(base_multilinestring_matrix)
  })
  # final_polygon = Reduce(c, base_polygon)
  # sf::st_sfc(final_polygon, crs = 4326)
  sf::st_sfc(base_multilinestring, crs = 4326)
}

convert_linestring0 <- function(obj_coord) {
  obj_df = as.data.frame(obj_coord)

  splitted_L1 = split(obj_df, obj_df[["L1"]])
  base_linestring = lapply(splitted_L1, \(input_L1){
    sf::st_linestring(as.matrix(input_L1[,c("X","Y")]))
  })
  # final_polygon = Reduce(c, base_polygon)
  # sf::st_sfc(final_polygon, crs = 4326)
  sf::st_sfc(base_linestring, crs = 4326)
}
convert_multipoint0 <- function(obj_coord) {
  obj_df = as.data.frame(obj_coord)
  splitted_L1 = split(obj_df, obj_df[["L1"]])
  base_multipoint = lapply(splitted_L1, \(input_L1){
    sf::st_multipoint(as.matrix(input_L1[,c("X","Y")]))
  })
  sf::st_sfc(base_multipoint, crs = 4326)
}
tictoc::tic()
st_shift_modify(temp)
tictoc::toc()


