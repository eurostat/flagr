#' Flag aggregation by the hierarchical inheritance method
#'
#' @param f A vector of flags containing the flags of a series for a given set of flags.
#' @param flag_list The predefined hierarchy of allowed flags as a vector of single characters.
#' @return \code{flag_hierarchy} returns the flag as single character that is the highest place in the
#' predifined hierarchy order for the given set of flags.
#' @examples
#' \dontrun{
#' library(tidyr)
#' flags <- spread(test_data[, c(1:3)], key = time, value = flags)
#' flag_hierarchy(flags[,4],flag_list = c("p","b","s","c","u","e","d"))
#' apply(flags[, c(2:ncol(flags))],2, flag_hierarchy, flag_list = c("p","b","s","c","u","e","d"))
#'}


#wrap everything in a function

#' @export

flag_hierarchy <- function(f,flag_list){
  f<-f[!is.na(f)]
  f<-unique(strsplit(paste0(f,collapse = ""),split = "")[[1]])
  flag_list[min(unlist(lapply(f, function(x) which(flag_list==x))))]
}



