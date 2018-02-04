context("cloc works")
test_that("core bits are functioning as expected", {

  res <- cloc(system.file("extdata", "App.java", package="cloc"))

  expect_equal(res$file_count[1], 1)
  expect_equal(res$loc[1], 8)
  expect_equal(res$blank_lines[1], 1)
  expect_equal(res$comment_lines[1], 4)

})
