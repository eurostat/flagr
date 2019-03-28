context("test-propagate.R")



test_that("test of the propagate wrapper for error", {
  expect_error(propagate_flag(data.frame(f=c("pe","b","p","p","up","e","d"),stringsAsFactors = F)),"The method is incorrect! It should be either \"hierarchy\", \"frequency\" or \"weighted\".")
  expect_error(propagate_flag(data.frame(f=c("pe","b","p","p","up","e","d"),stringsAsFactors = F),"hierarchy"),"The codelist is missing.")
  expect_error(propagate_flag(data.frame(f=c("pe","b","p","p","up","e","d"),stringsAsFactors = F),"weighted"),"The weights are missing.")
  expect_error(propagate_flag(data.frame(f=c("pe","b","p","p","up","e","d"),stringsAsFactors = F),"hierarchy","abc"),"The following flags from the data set are not in the list of hierarchy: p, e, u, d.")
})

f<-data.frame(date1=c(NA,"sf",NA,"bs"),date2=c("sdc","scf","cbd",NA))
w1<-data.frame(date1=c(NA,0,NA,0.1),date2=c(NA,NA,NA,NA))
w2<-data.frame(date1=c(NA,NA,NA,NA),date2=c(NA,NA,NA,NA))
w3<-data.frame(date1=c(NA,0,NA,0),date2=c(NA,NA,NA,NA))
w4<-data.frame(date1=c(11,12,8,9),date2=c(0.4,0.1,0.3,0.2))


test_that("test of the propagate wrapper for multiple period", {
  expect_equal(propagate_flag(f,"weighted",flag_weights=w1),list(date1=list("b, s","1"),date2=list(as.character(NA),as.character(NA))))
  expect_equal(propagate_flag(f,"weighted",flag_weights=w2),list(date1=list(as.character(NA),as.character(NA)),date2=list(as.character(NA),as.character(NA))))
  expect_equal(propagate_flag(f,"weighted",flag_weights=w3),list(date1=list(as.character(NA),as.character(NA)),date2=list(as.character(NA),as.character(NA))))
  expect_equal(propagate_flag(f,"weighted",flag_weights=w4),list(date1=list("s","0.525"),date2=list("c","0.8")))
})

fs<-data.frame(date1=c(NA,"sf",NA,"bs"))
ws1<-data.frame(date2=c(NA,0,NA,0.1))
ws2<-data.frame(date3=c(NA,NA,NA,NA))
ws3<-data.frame(date4=c(NA,0,NA,0))
ws4<-data.frame(date4=c(0.3,0.2,NA,0.1))
  
test_that("test of the propagate wrapper for single period", {
  expect_equal(propagate_flag(fs,"weighted",flag_weights=ws1),list(date1=list("b, s","1")))
  expect_equal(propagate_flag(fs,"weighted",flag_weights=ws2),list(date1=list(as.character(NA),as.character(NA))))
  expect_equal(propagate_flag(fs,"weighted",flag_weights=ws3),list(date1=list(as.character(NA),as.character(NA))))
  expect_equal(propagate_flag(fs,"weighted",flag_weights=ws4),list(date1=list("s","0.5")))
  expect_equal(propagate_flag(f[,1],"weighted",flag_weights=w1[,1]),list(date0=list("b, s","1")))
  expect_equal(propagate_flag(f[,2],"weighted",flag_weights=w2[,2]),list(date0=list(as.character(NA),as.character(NA))))
  expect_equal(propagate_flag(f[,2],"weighted",flag_weights=w3[,1]),list(date0=list(as.character(NA),as.character(NA))))
})
