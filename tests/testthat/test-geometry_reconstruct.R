output_mat = matrix(c(110,34, 1,1,1,
           112,34, 1,1,1,
           112,36, 1,1,1,
           110,36,1,1,1,
           110,34,1,1,1,
           110.5,34.5,2,1,1,
           111.5,34.5,2,1,1,
           111.5,35.5,2,1,1,
           110.5,35.5,2,1,1,
           110.5,34.5,2,1,1,
           113,33,1,2,1,
           114,33,1,2,1,
           114,34,1,2,1,
           113,34,1,2,1,
           113,33,1,2,1,
           110,34,1,1,2,
           112,34,1,1,2,
           112,36,1,1,2,
           110,36,1,1,2,
           110,34,1,1,2
  ), ncol = 5, byrow = TRUE)
colnames(output_mat) <- c("X","Y","L1","L2","L3")
output_mat2 = output_mat[,c("X","Y","L1")]
output_mat2[,"L1"] = c(rep(1, 5),rep(2, 5),rep(3, 5),rep(4, 5))

test_that("convert_multipolygon works", {
  expect_equal(sf::st_coordinates(convert_multipolygon(output_mat)), output_mat)
})


test_that("convert_polygon works", {
  expect_equal(sf::st_coordinates(convert_polygon(output_mat[1:15,])), output_mat[1:15,c("X","Y","L1","L2")])
})


test_that("convert_multilinestring works", {
  expect_equal(sf::st_coordinates(convert_multilinestring(output_mat[1:15,])), output_mat[1:15,c("X","Y","L1","L2")])
})

test_that("convert_linestring works", {
  expect_equal(sf::st_coordinates(convert_linestring(output_mat2)), output_mat2)
})

test_that("convert_multipoint works", {
  expect_equal(sf::st_coordinates(convert_multipoint(output_mat2)), output_mat2)
})
