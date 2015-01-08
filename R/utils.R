mongo.parse.ns <- function(ns)
{
  pos <- regexpr('\\.', ns)
  if (pos == 0 || pos == -1) {
    warning("mongo.parse.ns: No '.' in namespace")
    return(NULL)
  } else {
    db <- substr(ns, 1, pos-1)
    collection <- substr(ns, pos+1, nchar(ns))
    return(list(db=db, collection=collection))
  }
}

mongo.bson.from.argument <- function(arg) {
  bson <- switch( class(arg),
                  "mongo.bson" = arg,
                  "list" = mongo.bson.from.list(arg),
                  "character" = mongo.bson.from.JSON(arg),
                  stop("Can't convert to bson: argument should be one of 'list', 'mongo.bson' or 'character'(valid JSON)")
  )
  return(bson)
}

mongo.list.from.argument <- function(arg, simplify = T) {
  lst <- switch( class(arg),
                      "list" = arg,
                      "mongo.bson" = mongo.bson.to.list(arg, simplify = simplify),
                      "character" = {
                        if( !jsonlite::validate(I(arg)) ) stop("Not a valid JSON content: ", arg)
                        else jsonlite::fromJSON(arg)},
                      stop("Can't convert to list: argument should be one of 'list', 'mongo.bson' or 'character'(valid JSON)")
  )
  return(lst)
}

# make flat list without type coercion
# http://r.789695.n4.nabble.com/Feature-request-extend-functionality-of-unlist-by-args-delim-c-quot-quot-quot-quot-etc-and-keep-spec-td3535536.html
flatten <- function(lst, recursive = T,  use.names = TRUE) {
  if(isTRUE(recursive)) {
    lst <- c(list(function() NULL), lst)
    lst <- unlist(lst, recursive = recursive, use.names = use.names)
    lst[[1]] <- NULL
    return(lst)
  }
  else return(unlist(lst, recursive = recursive, use.names = use.names))
}
