convert_multipolygon <- function(obj_coord) {
  base_multipolygon = lapply(seq_len(max(obj_coord[,"L3"])), \(i){
    mat_split_by_L3 = obj_coord[obj_coord[,"L3"]==i, c("X","Y","L1","L2")]
    base_multipolygon_matrix = lapply(seq_len(max(mat_split_by_L3[,"L2"])), \(j){
      mat_split_by_L2 = mat_split_by_L3[mat_split_by_L3[,"L2"]==j, c("X","Y","L1")]
      lapply(seq_len(max(mat_split_by_L2[,"L1"])), \(k){
        mat_split_by_L2[mat_split_by_L2[,"L1"]==k, c("X","Y")]
      })
    })
    sf::st_multipolygon(base_multipolygon_matrix)
  })
  sf::st_sfc(base_multipolygon, crs = "WGS84")
}

convert_polygon <- function(obj_coord) {
  base_polygon = lapply(seq_len(max(obj_coord[,"L2"])), \(i){
    current_obj = obj_coord[obj_coord[,"L2"]==i, c("X","Y","L1")]
    base_polygon_matrix = lapply(seq_len(max(current_obj[,"L1"])), \(j){
      current_obj[current_obj[,"L1"]==j, c("X","Y")]
    })
    sf::st_polygon(base_polygon_matrix)
  })
  sf::st_sfc(base_polygon, crs = "WGS84")
}

convert_multilinestring <- function(obj_coord) {
  base_multilinestring = lapply(seq_len(max(obj_coord[,"L2"])), \(i){
    current_obj = obj_coord[obj_coord[,"L2"]==i, c("X","Y","L1")]
    base_multilinestring_matrix = lapply(seq_len(max(current_obj[,"L1"])), \(j){
      current_obj[current_obj[,"L1"]==j, c("X","Y")]
    })
    sf::st_multilinestring(base_multilinestring_matrix)
  })
  sf::st_sfc(base_multilinestring, crs = "WGS84")
}

convert_linestring <- function(obj_coord) {
  base_linestring = lapply(seq_len(max(obj_coord[,"L1"])), \(i){
    sf::st_linestring(obj_coord[obj_coord[,"L1"]==i, c("X","Y")])
  })
  sf::st_sfc(base_linestring, crs = "WGS84")
}

convert_multipoint <- function(obj_coord) {
  base_multipoint = lapply(seq_len(max(obj_coord[,"L1"])), \(i){
    sf::st_linestring(obj_coord[obj_coord[,"L1"]==i, c("X","Y")])
  })
  sf::st_sfc(base_multipoint, crs = "WGS84")
}

convert_point <- function(obj_coord) {
  sf::st_set_crs(sfheaders::sfc_point(obj_coord), 4326)
}

