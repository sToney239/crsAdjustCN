test_that("wgs_gcj works", {
  expect_equal(wgs_gcj(114,34), list(X = 114.0059209413134, Y = 33.99857469688111))
  expect_equal(wgs_gcj(110,37), list(X = 110.00546236264104, Y = 37.00035167780469))
  expect_equal(wgs_gcj(117,31), list(X = 117.0052788140384, Y = 30.997790596293385))
})

test_that("gcj_bd works", {
  expect_equal(gcj_bd(114,34), list(X = 114.00641459750307, Y = 34.00634695018671))
  expect_equal(gcj_bd(110,37), list(X = 110.00657191657601, Y = 37.005840521911786))
  expect_equal(gcj_bd(117,31), list(X = 117.0064237422443, Y = 31.00635543603301))
})


test_that("bd_gcj works", {
  expect_equal(bd_gcj(114,34), list(X = 113.99357738487251, Y = 33.99367204433013))
  expect_equal(bd_gcj(110,37), list(X = 109.99339706603841, Y = 36.99424468268465))
  expect_equal(bd_gcj(117,31), list(X = 116.99356873760645, Y = 30.993664141337568))
})

test_that("wgs_bd works", {
  expect_equal(wgs_bd(114,34), list(X = 114.01234107395413, Y = 34.00490555888876))
  expect_equal(wgs_bd(110,37), list(X = 110.01200472740814, Y = 37.00627946689159))
  expect_equal(wgs_bd(117,31), list(X = 117.01170709653843, Y = 31.004132990701603))
})

test_that("gcj_wgs_accu works", {
  expect_equal(gcj_wgs_accu(114,34), list(X = 113.99409561234593, Y = 34.0014428916941))
  expect_equal(gcj_wgs_accu(110,37), list(X = 109.99455807823944, Y = 36.99966507765484))
  expect_equal(gcj_wgs_accu(117,31), list(X = 116.99474233768531, Y = 31.00222404927289))
})


test_that("bd_wgs_accu works", {
  expect_equal(bd_wgs_accu(114,34), list(X = 113.98769150750734, Y = 33.995135571383706))
  expect_equal(bd_wgs_accu(110,37), list(X = 109.98798013421104, Y = 36.99393358309542))
  expect_equal(bd_wgs_accu(117,31), list(X = 116.98833743503397, Y = 30.99591114130899))
})

test_that("bd_wgs works", {
  expect_equal(bd_wgs(114,34), list(X = 113.987675237651, Y = 33.9951212669992))
  expect_equal(bd_wgs(110,37), list(X = 109.987960019925, Y = 36.9939163025965))
  expect_equal(bd_wgs(117,31), list(X = 116.988316582797, Y = 30.9959007241231))
})

test_that("gcj_wgs works", {
  expect_equal(gcj_wgs(114,34), list(X = 113.994079058687, Y = 34.0014282925507))
  expect_equal(gcj_wgs(110,37), list(X = 109.994537637359, Y = 36.9996474675748))
  expect_equal(gcj_wgs(117,31), list(X = 116.994721185962, Y = 31.0022133335362))
})
