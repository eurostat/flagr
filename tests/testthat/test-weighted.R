context("test-weigted.R")

test_that("test of frequency method", {
  expect_equal(flag_weighted(1, data.frame(f=c("pe","b","p","p","u","e","d"),stringsAsFactors = F), data.frame(w=c(10,3,7,12,31,9,54))),c("d","54"))
  expect_equal(flag_weighted(1, data.frame(f=c("pe","b","p","p","up","e","d"),stringsAsFactors = F), data.frame(w=c(10,3,7,12,31,9,54))),c("p","60"))
  expect_equal(flag_weighted(1, data.frame(f=c(NA,NA,NA,NA),stringsAsFactors = F), data.frame(w=c(NA,NA,NA,NA))),c(NA,NA))
  expect_equal(flag_weighted(1, data.frame(f=c(NA,"b",NA,NA),stringsAsFactors = F), data.frame(w=c(NA,NA,NA,NA))),c(NA,NA))
  expect_equal(flag_weighted(1, data.frame(f=c(NA,"b",NA,"b"),stringsAsFactors = F), data.frame(w=c(NA,NA,NA,8))),c("b","8"))
})