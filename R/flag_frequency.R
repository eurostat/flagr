#' Flag aggregation by the frequency count method
#'
#' @param f A vector of flags containing the flags of a series for a given period.
#' @return \code{flag_frequency} returns a character with a single character flag in case the highest frequency count
#'  is unique, or multiple character in case there are several flags with the highest frequency count.
#' @examples
#' \dontrun{
#' library(tidyr)
#' flags <- spread(test_data[, c(1:3)], key = time, value = flags)
#' flag_frequency(flags[,5])
#' apply(flags[, c(2:ncol(flags))],2, flag_frequency)
#'}
#'

#' @export

flag_frequency<-function(f){
  f<-f[!is.na(f)]
  f<-strsplit(paste0(f,collapse = ""),split = "")[[1]]
  max_count<-(sort(table(f),decreasing=T)[1])
  names(sort(table(f),decreasing=T)[sort(table(f),decreasing=T)==max_count])
}




