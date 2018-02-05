context("cloc works")
test_that("core bits are functioning as expected", {

  res <- cloc(system.file("extdata", "App.java", package="cloc"))

  expect_equal(res$file_count[1], 1)
  expect_equal(res$loc[1], 8)
  expect_equal(res$blank_lines[1], 1)
  expect_equal(res$comment_lines[1], 4)

  langs <- cloc_reognized_languages()

  expect_equal(langs$lang[4], "ADSO/IDSM")

  nc <- cloc_remove_comments(system.file("extdata", "qrencoder.cpp", package="cloc"))

  expect_equal(nchar(nc), 4830)

  bf <- cloc_by_file(system.file("extdata", "qrencoder.cpp", package="cloc"))

  expect_equal(bf$loc, 142)

  skip_on_cran()

  cran <- cloc_cran("dplyr", "https://cran.rstudio.com")

  expect_equal(cran$language[1], "R")

})
