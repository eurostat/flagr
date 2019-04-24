#' Assignment of the weights for the multiple flags
#' @description This function is used when a single value has multiple flags. The same weight is repeated for each
#' single character.
#' @param x A vector with two items. The first item is a string of flags with several characters, the second is
#'  a single numerical value of the weight.
#' @return \code{flag_divide} returns a character matrix with the flags as single characters as the first column and the weight is
#'  repeated as the second column. The length of the list is equal to the length of the string of flags.
#' @seealso \code{\link{flag_weighted}}
#' @examples
#' flags <- tidyr::spread(test_data[, c(1:3)], key = time, value = flags)
#' weights <- tidyr::spread(test_data[, c(1, 3:4)], key = time, value = values)
#' input <- as.data.frame(cbind(flags[,5],weights[,5]),stringsAsFactors = FALSE)[!is.na(flags[,5]),]
#'
#' do.call(rbind, apply(input,1,flag_divide))
#'
#' @export


flag_divide <- function(x){
  out<-data.frame(cbind(unlist(f<-strsplit(x[1],split = "")),x[2]))
  colnames(out)<-c("f","w")
  return(out)
}



