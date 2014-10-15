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

# make flat list without type coercion
flatten <- function(lst) {
  lst[['__dummy']] <- function() NULL
  lst <- unlist(lst)
  lst$`__dummy` <- NULL
  lst
}
