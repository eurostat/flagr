#' Derive flags for an aggregates using diffrent methods
#' @description The wrapper function to use the different method and provide a structured return value independently
#'  from the method used.
#' @param flags A data.frame or a matrix containing the flags of the series (one column per period)
#' without row identifiers (e.g. country code).
#' @param method A string contains the method to to derive the flag for the aggregate. It can take the value,
#' "hierarchy", "frequency" or "weighted".
#' @param codelist A string or character vector defining the list of acceptable flags in case the method "hierarchy"
#' is chosen. In case of the string equals to "estat" or "sdmx" then the predefined standard Eurostat and SDMX codelist
#' is used, otherwise the characters in the sring will define the hierarchical order.
#' @param flag_weights A data.frame or a matrix containing the corresponding weights of the series (one column per
#' period) without row identifiers (e.g. country code). It has the same size and dimesion as the \code{flags} parameter.
#' @param threshold The threshold which above the should be the waights in order the aggregate to receive a flag.
#' Defalut value is 0.5, but can be changed to any value.
#' @return \code{propagate_flag} returns a list with the same size as the number of periods (columns) in the flags
#' parameter. In case of the methods is "hierarchy" or "frequency", then only the derived flag(s) is returned. In case
#' of weighted it returns the flag(s) and the sum of weights if it is above the threshold, otherwise the list contains
#' \code{NA} where the sum of weights are below the threshold.
#'
#' @seealso \code{\link{flag_hierarchy}}, \code{\link{flag_frequency}}, \code{\link{flag_weighted}}
#' @examples
#' flags <- tidyr::spread(test_data[, c(1:3)], key = time, value = flags)
#' weights <- tidyr::spread(test_data[, c(1, 3:4)], key = time, value = values)
#'
#' propagate_flag(flags[, c(2:ncol(flags))],"hierarchy","puebscd")
#' propagate_flag(flags[, c(2:ncol(flags))],"hierarchy","estat")
#' propagate_flag(flags[, c(2:ncol(flags))],"frequency")
#'
#' flags<-flags[, c(2:ncol(flags))]
#' weights<-weights[, c(2:ncol(weights))]
#' propagate_flag(flags,"weighted",flag_weights=weights)
#' propagate_flag(flags,"weighted",flag_weights=weights,threshold=0.1)
#'
#' @export


propagate_flag <- function(flags,
                           method = "",
                           codelist = NULL,
                           flag_weights = 0,
                           threshold = 0.5){

  estat_flags <- c("b", "d", "f", "e", "s", "p", "n", "u")
  sdmx_flags <- c("B", "J", "S", "D", "I", "F", "E", "P", "N", "U", "V", "G", "A")
  if (method=="hierarchy") {
    if (is.null(codelist)){
      stop("The codelist is missing.")
    } 
    codelist<-codelist[!is.na(codelist)]
    if (length(codelist)==0){
      stop("The codelist is missing.")
    }
    else if (length(codelist)==1){
      if (codelist=="estat"){
        ordinance<- estat_flags
        flags<-sapply(flags,function(x) gsub("c",NA,x))
      }
      else if (codelist=="sdmx"){
        ordinance<- sdmx_flags
      }
      else {
        ordinance<- strsplit(paste0(codelist,collapse = ""),split = "")[[1]]
      }
    }
    else {
      ordinance<- strsplit(paste0(codelist,collapse = ""),split = "")[[1]]
    }
    used_flags=strsplit(as.array(unique(strsplit(paste0(unique(flags[!is.na(flags)]),collapse = ""),split = "")[[1]])),split = "")
    if (!all(used_flags %in% ordinance)){
      if (sum(used_flags %in% ordinance == F) < 2){
        stop(paste0("The following flag from the data set is not in the list of hierarchy: ", paste(used_flags[used_flags %in% ordinance == F],collapse = ", "),".\n"))
      }
      else {
        stop(paste0("The following flags from the data set are not in the list of hierarchy: ", paste(used_flags[used_flags %in% ordinance == F],collapse = ", "),".\n"))
      }
    }
    else{
      as.list(apply(flags,2, flag_hierarchy, flag_list = ordinance))
    }
  }
  else if (method=="frequency"){
    as.list(apply(flags,2, flag_frequency))
  }
  else if(method=="weighted"){
    if (missing(flag_weights)){
      stop("The weights are missing.")
    }
    else if ("logical" %in% class(flag_weights)){
      if (is.null(colnames(flags))){
        weighted_flags<- list(date0=list(as.character(NA),as.character(NA)))
        weighted_flags
      }
      else{
        weighted_flags<-sapply(colnames(flags),function(x) list(list(as.character(NA),as.character(NA))))
        weighted_flags
      }
    }
    else{
      if ("numeric" %in% class(flag_weights)){
        if (sum(flag_weights,na.rm=T)!=1){
          flag_weights<-flag_weights/sum(flag_weights,na.rm=T)
          flag_weights[is.na(flag_weights)] <- 0
        }
        weighted_flags<-flag_weighted(1,data.frame(flags,stringsAsFactors=F),data.frame(flag_weights))
        weighted_flags[weighted_flags[2]<threshold]<-NA
        if (is.null(colnames(flags))){
          list(date0=list(weighted_flags[1],weighted_flags[2]))
        }
        else{
          list(list(weighted_flags[1],weighted_flags[2]))
        }
      }
      else{
        if (sum(colSums(flag_weights,na.rm = T))!=ncol(flag_weights)){
          flag_weights<-apply(flag_weights,2,function(x) x/sum(x,na.rm=T))
          flag_weights[is.na(flag_weights)] <- 0
        }
        weighted_flags<-sapply(1:ncol(flags),flag_weighted,f=data.frame(lapply(flags,as.character),stringsAsFactors=F),w=data.frame(flag_weights))
        colnames(weighted_flags)<-colnames(flags)
        weighted_flags[,weighted_flags[2,]<threshold]<-NA
        apply(weighted_flags, 2, as.list)
      }
    }
  }
  else {
    stop('The method is incorrect! It should be either "hierarchy", "frequency" or "weighted".')
  }
}
