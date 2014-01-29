#' @useDynLib rmongodb
#' @import RJSONIO
#'
.onUnload <- function(libpath)
    library.dynam.unload("rmongodb", libpath)


