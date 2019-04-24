#' Flag aggregation by the weighted frequency method
#' @description This method can be used when you want to derive the flag of an aggregate that is a weighted average,
#' index, quantile, etc.
#' @param i An integer column identifier of data.frame or a matrix containing the flags and weights used to derived
#' the flag for the aggregates.
#' @param f A data.frame or a matrix containing the flags of the series (one column per period)
#' @param w A data.frame or a matrix with same size and dimesion as \code{f} containing the corresponding weights
#'  for each flags.
#' @return \code{flag_weighted} Returns a character vector with the flag that has the highest weighted frequency or multiple flags in alphabetical 
#' order (in case there are more than one flag with the same highest weight) as the first value, and the sum of weights for the given flag(s) as 
#' the second value for the given columns of \code{f,w} defined by the parameter \code{i}.
#'
#' @seealso \code{\link{flag_divide}}
#' @examples
#' flag_weighted(1, 
#'               data.frame(f=c("pe","b","p","p","u","e","d"), stringsAsFactors = FALSE), 
#'               data.frame(w=c(10,3,7,12,31,9,54)))
#' flag_weighted(1, 
#'               data.frame(f=c("pe","b","p","p","up","e","d"), stringsAsFactors = FALSE),
#'               data.frame(w=c(10,3,7,12,31,9,54)))
#' flag_weighted(1, 
#'               data.frame(f=c("pe",NA,"pe",NA,NA,"d"), stringsAsFactors = FALSE),
#'               data.frame(w=c(10,3,7,12,31,9)))
#' 
#' 
#' flags <- tidyr::spread(test_data[, c(1:3)], key = time, value = flags)
#' weights <- tidyr::spread(test_data[, c(1, 3:4)], key = time, value = values)
#' flag_weighted(7,flags[, c(2:ncol(flags))],weights[, c(2:ncol(weights))])
#'
#' weights<-apply(weights[, c(2:ncol(weights))],2,function(x) x/sum(x,na.rm=TRUE))
#' weights[is.na(weights)] <- 0
#' flags<-flags[, c(2:ncol(flags))]
#' sapply(1:ncol(flags),flag_weighted,f=flags,w=weights)
#'
#' @export

flag_weighted<-function(i,f,w){
  inp<-as.matrix(cbind(as.character(f[,i]),w[,i]),stringsAsFactors = F)
  inp<-inp[(!is.na(inp[,1]))&(!is.na(inp[,2])),]
  if (NROW(inp)*NCOL(inp)==0){
    c(NA,NA)
  }else{
    if (NROW(inp)*NCOL(inp)==2){
      tmp1<-flag_divide(inp)
    }else{
      if (any(nchar(inp[,1])>1)){
        tmp1<-do.call(rbind, apply(inp,1,flag_divide))
      }else{
        tmp1<-inp
      }  
    }
    rownames(tmp1)<-c()
    tmp1<-as.data.frame(tmp1,stringsAsFactors = F)
    tmp1[,2]<-as.numeric(as.character(tmp1[,2]))
    w_sum<-stats::aggregate(tmp1[,2],by=list(tmp1[,1]),FUN=sum) #  aggregate(V2~V1,tmp1,sum)
    max_w<-w_sum[order(-w_sum$x),][1,2]
    c(paste0(sort(as.character(w_sum[w_sum$x==max_w,1])),collapse=", "), as.numeric(max_w))
  }
}
