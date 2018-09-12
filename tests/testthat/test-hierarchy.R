context("test-hierarchy.R")

test_that("test of hierarchy method", {
  expect_equal(flag_hierarchy(c("p","b","s","b","u","e","b"), flag_list = c("e","s","t")),"e")
  expect_equal(flag_hierarchy(c("p","b","s","b","u","b"), flag_list = c("e","s","t")),"s")
  expect_equal(flag_hierarchy(c("p","b","b","u","b"), flag_list = c("e","s","t")),NA)
  expect_equal(flag_hierarchy(c(NA,NA,NA,NA), flag_list = c("e","s","t")),NA)
})