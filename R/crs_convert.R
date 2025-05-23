
ee = 0.00669342162296594323
a = 6378245.0


transformlat = function(lon, lat){
  ret = -100.0 + 2.0 * lon + 3.0 * lat + 0.2 * lat * lat + 0.1 * lon * lat + 0.2 * sqrt(abs(lon))
  ret = ret + (20.0 * sin(6.0 * lon * pi) + 20.0 *  sin(2.0 * lon * pi)) * 2.0 / 3.0
  ret = ret + (20.0 * sin(lat * pi) + 40.0 * sin(lat / 3.0 * pi)) * 2.0 / 3.0
  ret = ret + (160.0 * sin(lat / 12.0 * pi) + 320 * sin(lat * pi / 30.0)) * 2.0 / 3.0
  return(ret)
}

transformlon = function(lon, lat){
  ret = 300.0 + lon + 2.0 * lat + 0.1 * lon * lon + 0.1 * lon * lat + 0.1 * sqrt(abs(lon))
  ret = ret + (20.0 * sin(6.0 * lon * pi) + 20.0 * sin(2.0 * lon * pi)) * 2.0 / 3.0
  ret = ret + (20.0 * sin(lon * pi) + 40.0 * sin(lon / 3.0 * pi)) * 2.0 / 3.0
  ret = ret + (150.0 * sin(lon / 12.0 * pi) + 300.0 * sin(lon / 30.0 * pi)) * 2.0 / 3.0
  return(ret)
}

#' WGS84 to gcj02 coordinate system
#'
#' @param lon A numeric scalar or vector of longitude with WGS84 as crs
#' @param lat A numeric scalar or vector of latitude with WGS84 as crs
#'
#' @returns list contining X and Y numeric vectors
#' @export
#'
#' @examples data.frame(wgs_gcj(105, 33))
wgs_gcj = function(lon, lat){
  dlat = transformlat(lon - 105.0, lat - 35.0)
  dlon = transformlon(lon - 105.0, lat - 35.0)
  radlat = lat / 180.0 * pi
  magic = sin(radlat)
  magic = 1 - ee * magic * magic
  sqrtmagic = sqrt(magic)
  dlat = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * pi)
  dlon = (dlon * 180.0) / (a / sqrtmagic * cos(radlat) * pi)
  list(
    X = lon + dlon,
    Y = lat + dlat
  )
}

#' gcj02 to bd09 coordinate system
#'
#' @param lon A numeric scalar or vector of longitude with gcj02 as crs
#' @param lat A numeric scalar or vector of latitude with gcj02 as crs
#'
#' @returns list contining X and Y numeric vectors
#' @export
#'
#' @examples data.frame(gcj_bd(105, 33))
gcj_bd = function(lon, lat) {
  z = sqrt(lon * lon + lat * lat) + 0.00002 * sin(lat * pi * 3000.0 / 180.0)
  theta = atan2(lat, lon) + 0.000003 * cos(lon * pi * 3000.0 / 180.0)
  list(
    X = z * cos(theta) + 0.0065 ,
    Y = z * sin(theta) + 0.006
  )
}

#' bd09 to gcj02 coordinate system
#'
#' @param lon A numeric scalar or vector of longitude with bd09 as crs
#' @param lat A numeric scalar or vector of latitude with bd09 as crs
#'
#' @returns list contining X and Y numeric vectors
#' @export
#'
#' @examples data.frame(bd_gcj(105, 33))
bd_gcj = function(lon, lat) {
  lon = lon - 0.0065
  lat = lat - 0.006
  z = sqrt(lon * lon + lat * lat) - 0.00002 * sin(lat * pi * 3000.0 / 180.0)
  theta = atan2(lat, lon) - 0.000003 * cos(lon * pi * 3000.0 / 180.0)
  return(
    list(
      X = z * cos(theta) ,
      Y = z * sin(theta)
    )
  )
}

#' WGS84 to bd09 coordinate system
#'
#' @param lon A numeric scalar or vector of longitude with WGS84 as crs
#' @param lat A numeric scalar or vector of latitude with WGS84 as crs
#'
#' @returns list contining X and Y numeric vectors
#' @export
#'
#' @examples data.frame(wgs_bd(105, 33))
wgs_bd <- function(lon, lat) {
  dlat = transformlat(lon - 105.0, lat - 35.0)
  dlon = transformlon(lon - 105.0, lat - 35.0)
  radlat = lat / 180.0 * pi
  magic = sin(radlat)
  magic = 1 - ee * magic * magic
  sqrtmagic = sqrt(magic)
  dlat = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * pi)
  dlon = (dlon * 180.0) / (a / sqrtmagic * cos(radlat) * pi)
  lon = lon + dlon
  lat = lat + dlat
  z = sqrt(lon * lon + lat * lat) + 0.00002 * sin(lat * pi * 3000.0 / 180.0)
  theta = atan2(lat, lon) + 0.000003 * cos(lon * pi * 3000.0 / 180.0)
  return(
    list(
      X = z * cos(theta) + 0.0065 ,
      Y = z * sin(theta) + 0.006
    )
  )
}


#' gcj02 to WGS84 coordinate system
#'
#' @param lon A numeric scalar or vector of longitude with gcj02 as crs
#' @param lat A numeric scalar or vector of latitude with gcj02 as crs
#'
#' @returns A list contining X and Y numeric vectors
#' @export
#'
#' @examples data.frame(gcj_wgs(105, 33))
gcj_wgs <- function (lon, lat) {
  dlat <- transformlat(lon - 105, lat - 35)
  dlon <- transformlon(lon - 105, lat - 35)
  radlat <- lat/180 * pi
  magic <- sin(radlat)
  magic <- 1 - ee * magic * magic
  dlat <- (dlat * 180)/((a * (1 - ee))/magic * sqrt(magic) * pi)
  dlon <- (dlon * 180)/(a/sqrt(magic) * cos(radlat) * pi)
  return(
    list(
      X = lon - dlon,
      Y = lat - dlat
    )
  )
}



#' bd09 to WGS84 coordinate system
#'
#' @param lon A numeric scalar or vector of longitude with bd09 as crs
#' @param lat A numeric scalar or vector of latitude with bd09 as crs
#'
#' @returns A list contining X and Y numeric vectors
#' @export
#'
#' @examples data.frame(bd_wgs(105, 33))
bd_wgs = function(lon, lat) {
  temp = bd_gcj(lon, lat)
  return(gcj_wgs(temp[["X"]], temp[["Y"]]))
}



#' gcj02 to WGS84 coordinate system with more accurate algorithm
#'
#' @param lon A numeric scalar or vector of longitude with gcj02 as crs
#' @param lat A numeric scalar or vector of latitude with gcj02 as crs
#'
#' @returns A list contining X and Y numeric vectors
#' @export
#'
#' @examples data.frame(gcj_wgs_accu(111:112,34:35))
gcj_wgs_accu = function(lon, lat) {
  lonlat = mapply(gcj_wgs_accu_, lon, lat)
  return(list(X = unname(lonlat["X",]),Y = unname(lonlat["Y",]))
  )
}

#' bd09 to WGS84 coordinate system with more accurate algorithm
#'
#' @param lon A numeric scalar or vector longitude with gcj02 as crs
#' @param lat A numeric scalar or vector latitude with gcj02 as crs
#'
#' @returns A list contining X and Y numeric vectors
#' @export
#'
#' @examples data.frame(bd_wgs_accu(lon = 111:112,lat = 34:35))
bd_wgs_accu = function(lon, lat) {
  lonlat = mapply(bd_wgs_accu_, lon, lat)
  return(list(X = unname(lonlat["X",]),Y = unname(lonlat["Y",])))
}

