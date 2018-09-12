context("test-frequency.R")

test_that("test of frequency method", {
  expect_equal(flag_frequency(c("p","b","s","b","u","e","b")),"b")
  expect_equal(flag_frequency(c("p","u","c","d","u","b")),"u")
  expect_equal(flag_frequency(c("p","b","p","u","b")),c("b","p"))
  expect_equal(flag_frequency(c(NA,NA,NA)),NA)
})