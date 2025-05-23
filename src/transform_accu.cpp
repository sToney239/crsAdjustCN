#include <Rcpp.h>
#include <math.h>
#include <stdlib.h>
using namespace Rcpp;

double x_pi= 3.14159265358979324 * 3000.0/180.0;
double pi= 3.1415926535897932384626;
double ee= 0.00669342162296594323;
double a= 6378245.0;


double transformlat(double lng,double lat){
  double ret;
  ret = -100.0 + 2.0 * lng + 3.0 * lat + 0.2 * lat * lat + 0.1 * lng * lat + 0.2 * sqrt(abs(lng));
  ret += (20.0 * sin(6.0 * lng * pi) + 20.0 *  sin(2.0 * lng * pi)) * 2.0 / 3.0;
  ret += (20.0 * sin(lat * pi) + 40.0 * sin(lat / 3.0 * pi)) * 2.0 / 3.0;
  ret += (160.0 * sin(lat / 12.0 * pi) + 320 * sin(lat * pi / 30.0)) * 2.0 / 3.0;
  return ret;
  }

double transformlng(double lng,double lat){
  double ret;
  ret = 300.0 + lng + 2.0 * lat + 0.1 * lng * lng + 0.1 * lng * lat + 0.1 * sqrt(abs(lng));
  ret += (20.0 * sin(6.0 * lng * pi) + 20.0 * sin(2.0 * lng * pi)) * 2.0 / 3.0;
  ret += (20.0 * sin(lng * pi) + 40.0 * sin(lng / 3.0 * pi)) * 2.0 / 3.0;
  ret += (150.0 * sin(lng / 12.0 * pi) + 300.0 * sin(lng / 30.0 * pi)) * 2.0 / 3.0;
  return ret;
}

void wgs2gcj(double *lng, double *lat){
  double dlat,dlng,radlat,magic,sqrtmagic;
  dlat = transformlat(*lng - 105.0, *lat - 35.0);
  dlng = transformlng(*lng - 105.0, *lat - 35.0);
  radlat = *lat / 180.0 * pi;
  magic = sin(radlat);
  magic = 1 - ee * magic * magic;
  sqrtmagic = sqrt(magic);
  dlat = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * pi);
  dlng = (dlng * 180.0) / (a / sqrtmagic * cos(radlat) * pi);
  *lat = *lat + dlat;
  *lng = *lng + dlng;
}

void gcj2wgs1(double *lng, double *lat) {
  double dlat,dlng,g0lon,g0lat,g1lon,g1lat,w0lon,w0lat,w1lon,w1lat;
  g0lon = *lng;
  g0lat = *lat;
  w0lon = *lng;
  w0lat = *lat;
  g1lon = w0lon;
  g1lat = w0lat;

  wgs2gcj(&g1lon, &g1lat);

  w1lon = w0lon - (g1lon - g0lon);
  w1lat = w0lat - (g1lat - g0lat);

  dlng = abs(w1lon - w0lon);
  dlat = abs(w1lat - w0lat);

  while((dlng >= 1e-6) || (dlat >= 1e-6)){
    w0lon = w1lon;
    w0lat = w1lat;
    g1lon = w0lon;
    g1lat = w0lat;

    wgs2gcj(&g1lon, &g1lat);

    w1lon = w0lon - (g1lon - g0lon);
    w1lat = w0lat - (g1lat - g0lat);

    dlng = abs(w1lon - w0lon);
    dlat = abs(w1lat - w0lat);
  }
  *lng = w1lon;
  *lat = w1lat;
}


//' More accurately convert gcj02 to WGS84 coordinate system
//' @importFrom Rcpp sourceCpp
//' @useDynLib chinaCRS
//'
//' @param lon input longitude with gcj02 as crs
//' @param lat input latitude with gcj02 as crs
//' @return A numeric vector with 2 elements contining X and Y numeric vectors
// [[Rcpp::export]]
NumericVector  gcj_wgs_accu_(double lon, double lat) {
  NumericVector out = NumericVector::create(Named("X",0.0), Named("Y",0.0));
  gcj2wgs1(&lon, &lat);
  out[0] = lon;
  out[1] = lat;
  return out;
}


//' More accurately convert bd09 to WGS84 coordinate system
//' @importFrom Rcpp sourceCpp
//' @useDynLib chinaCRS
//'
//' @param lon input longitude with bd09 as crs
//' @param lat input latitude with bd09 as crs
//' @return A numeric vector with 2 elements contining X and Y numeric vectors
// [[Rcpp::export]]
NumericVector  bd_wgs_accu_(double lon, double lat) {
  NumericVector out = NumericVector::create(Named("X",0.0), Named("Y",0.0));
  double z, theta;
  lon = lon - 0.0065;
  lat = lat - 0.006;
  z = sqrt(lon * lon + lat * lat) - 0.00002 * sin(lat * pi * 3000.0 / 180.0);
  theta = atan2(lat, lon) - 0.000003 * cos(lon * pi * 3000.0 / 180.0);
  lon = z * cos(theta);
  lat = z * sin(theta);
  gcj2wgs1(&lon, &lat);
  out[0] = lon;
  out[1] = lat;
  return out;
}


