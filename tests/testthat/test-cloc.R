context("cloc works (get it?)")
test_that("core bits are functioning as expected", {

  langs <- cloc_recognized_languages()
  expect_equal(langs$lang[4], "ADSO/IDSM")

  expect_equal(cloc_version(), "1.86")

  expect_is(cloc_os(), "character")


})

context("cloc counts things properly")
test_that("core bits are functioning as expected", {

  res <- cloc(system.file("extdata", "qrencoder.cpp", package="cloc"))

  expect_equal(res$file_count[1], 1)
  expect_equal(res$loc[1], 142)
  expect_equal(res$blank_lines[1], 41)
  expect_equal(res$comment_lines[1], 63)

  nc <- cloc_remove_comments(system.file("extdata", "qrencoder.cpp", package="cloc"))

  expect_equal(nchar(nc), 4830)

  bf <- cloc_by_file(system.file("extdata", "qrencoder.cpp", package="cloc"))

  expect_equal(bf$loc[1], 142)

})

context("CRAN")
test_that("retrieving things from CRAN works", {

  skip_on_appveyor()
  skip_on_travis()
  skip_on_cran()

  cran <- cloc_cran("dplyr", "https://cran.rstudio.com", .progress=FALSE)
  expect_equal(cran$language[1], "R")

})

context("git remote works")
test_that("retrieving things from remote git works", {

  skip_on_appveyor()
  skip_on_travis()
  skip_on_cran()

  git <- cloc_git("git://github.com/hrbrmstr/cloc.git")
  expect_true("R" %in% git$language)

})
