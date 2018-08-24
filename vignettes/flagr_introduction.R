## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(flagr)

## ----head test_data------------------------------------------------------
head(test_data)

## ----summary test_data---------------------------------------------------
summary(test_data)

## ----hierarchy-----------------------------------------------------------
library(tidyr)
flags <- spread(test_data[, c(1:3)], key = time, value = flags)
propagate_flag(flags[, c(2:ncol(flags))],"hierarchy","puebscd")
propagate_flag(flags[, c(2:ncol(flags))],"hierarchy",c("b","c","d","e","p","s","u"))

## ----frequency-----------------------------------------------------------
library(tidyr)
flags <- spread(test_data[, c(1:3)], key = time, value = flags)
propagate_flag(flags[, c(2:ncol(flags))],"frequency")

## ----weighted------------------------------------------------------------
library(tidyr)
flags <- spread(test_data[, c(1:3)], key = time, value = flags)
weights <- spread(test_data[, c(1, 3:4)], key = time, value = values)

flags<-flags[, c(2:ncol(flags))]
weights<-weights[, c(2:ncol(weights))]
propagate_flag(flags,"weighted",flag_weights=weights)
propagate_flag(flags,"weighted",flag_weights=weights,threshold=0.1)

