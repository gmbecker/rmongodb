
#' Get a vector of distinct values for keys in a collection
#' 
#' Get a vector of distinct values for keys in a collection.
#' 
#' See
#' \url{http://www.mongodb.org/display/DOCS/Aggregation#Aggregation-Distinct}.
#' 
#' 
#' @param mongo (\link{mongo}) A mongo connection object.
#' @param ns (string) The namespace of the collection in which to find distinct
#' keys.
#' @param key (string) The name of the key field for which to get distinct
#' values.
#' @param query \link{mongo.bson} An optional query to restrict the returned
#' values.
#' @return NULL if the command failed.  \code{\link{mongo.get.err}()} may be
#' MONGO_COMMAND_FAILED.
#' 
#' (vector) The result set of distinct keys.
#' @seealso \code{\link{mongo.command}},\cr
#' \code{\link{mongo.simple.command}},\cr \code{\link{mongo.find}},\cr
#' \link{mongo}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     keys <- mongo.distinct(mongo, "test.people", "name")
#'     print(keys)
#' }
#' 
#' @export mongo.distinct
mongo.distinct <- function(mongo, ns, key, query=mongo.bson.empty()) {
  pos <- regexpr('\\.', ns)
  if (pos == 0) {
    print("mongo.distinct: No '.' in namespace")
    return(NULL)
  }
  db <- substr(ns, 1, pos-1)
  collection <- substr(ns, pos+1, nchar(ns))
  b <- mongo.command(mongo, db, list(distinct=collection, key=key, query=query))
  if (!is.null(b))
    b <- mongo.bson.value(b, "values")
  b
}




#' Get a vector of all keys in a collection
#' 
#' Get a vector of all keys in a collection.
#' 
#' @export mongo.get.keys
mongo.get.keys <- function(mongo, ns, limit=0L, skip=0L){
  
  # ToDo
  # http://stackoverflow.com/questions/2298870/mongodb-get-names-of-all-keys-in-collection
  
}




#' Apply Function Over Keys
#' 
#' This function applies an R command over keys in a collection and returns the result.
#' 
#' @seealso \code{\link{apply}}
#' @export mongo.apply
mongo.apply <- function(mongo, ns, keys, fun){
  
  # ToDo
  
}





#' Mongo Key Summaries
#' 
#' This function produces result summaries of the selected keys.
#' 
#' @seealso \code{\link{summary}}
#' @export mongo.summary
mongo.summary <- function(mongo, ns, keys, fun, limit=0L, skip=0L){
  
  # ToDo
  
}




#' Compute Summary Statistics of Mongo Subsets
#' 
#' Splits the mongo data into subsets, computes summary statistics for eachm and returns the result in a convenient form.
#' 
#' @seealso \code{\link{aggregate}}
#' @export mongo.aggregate.stats
mongo.aggregate.stats <- function(mongo, ns, keys, by){
  
  # ToDo
  
}




#' Count Tables
#' 
#' This function creates tables of counts at each combination of keys
#' 
#' @seealso \code{\link{table}}
#' @export mongo.table
mongo.table <- function(mongo, ns, keys, limit=0L, skip=0L){
  
  #mongo.distinct
  
  # ToDo
  
}
