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
#' 
#' @return vector of distinct values or NULL if the command failed.
#' 
#' (vector) The result set of distinct keys.
#' @seealso \code{\link{mongo.command}},\cr
#' \code{\link{mongo.simple.command}},\cr \code{\link{mongo.find}},\cr
#' \link{mongo}.
#' 
#' @examples
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     keys <- mongo.distinct(mongo, "test.people", "name")
#'     print(keys)
#' }
#' 
#' @aliases mongo.get.values
#' @export mongo.get.values
#' @export mongo.distinct
mongo.distinct <- function(mongo, ns, key, query=mongo.bson.empty()) {
  
  ns_parsed <- mongo.parse.ns(ns)
  db <- ns_parsed$db
  collection <- ns_parsed$collection
  if( is.null(db) || is.null(collection) ){
    stop("Wrong namespace (ns).")
  }
  
  b <- mongo.command(mongo, db, list(distinct=collection, key=key, query=query))
  
  if (!is.null(b)){
    b <- mongo.bson.value(b, "values")
    if(length(b)==0)
      warning("No values - probably wrong key!")
    return(b)
  } else{
    warning( mongo.get.server.err.string(mongo) )
    return(NULL)
  }
}

mongo.get.values <- mongo.distinct





#' Aggregation pipeline
#' 
#' Aggregation pipeline
#' 
#' See
#' \url{http://docs.mongodb.org/manual/core/aggregation-pipeline/}.
#' 
#' 
#' @param mongo (\link{mongo}) A mongo connection object.
#' @param ns (string) The namespace of the collection in which to find distinct
#' keys.
#' @param aggr_cmd_list \link{mongo.bson} An list representing aggregation query pipeline.
#' 
#' @return NULL if the command failed.  \code{\link{mongo.get.err}()} may be
#' MONGO_COMMAND_FAILED.
#' 
#' \link{mongo.bson} The result of aggregation.
#' @seealso \code{\link{mongo.command}},\cr
#' \code{\link{mongo.simple.command}},\cr \code{\link{mongo.find}},\cr
#' \link{mongo}.
#' 
#' @examples
#' # Imagine we have collection with people ids and their ages. Aggregation below finds ids 
#' # between 1 and 1000, group by age, counts them and push ids into buckets, one per age.
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'   upper <- 1000
#'   lower <- 1
#'   pipe_1 <- mongo.bson.from.list(list("$match" = list('id'=c(list('$lte' = upper), list('$gte' = lower)))))
#'   pipe_2 <- mongo.bson.from.list(list("$project" = list('id' = 1, 'age'=1)))
#'   pipe_3 <- mongo.bson.from.list(list("$group" = c(list('_id' = '$age'), list(cnt=list('$sum'=1)), list(ids=list('$push'='$id')))))
#'   cmd_list <- list(pipe_1, pipe_2, pipe_3)
#'   aggr <- mongo.aggregation(mongo, ns = 'db.collection', aggr_cmd_list = cmd_list)
#'   # check results:
#'   str(mongo.bson.to.list(aggr))
#' }
#' mongo.destroy(mongo = mongo)
#'
#' @export mongo.aggregation
mongo.aggregation <- function(mongo, ns, aggr_cmd_list)
{
  ns_parsed <- mongo.parse.ns(ns)
  db <- ns_parsed$db
  collection <- ns_parsed$collection
  if( is.null(db) || is.null(collection) ){
    stop("Wrong namespace (ns).")
  }
  
  buf <- mongo.bson.buffer.create()
  mongo.bson.buffer.append(buf, "aggregate", collection)
  mongo.bson.buffer.start.array(buf, "pipeline")
  for (i in (1:length(aggr_cmd_list)))
  {
    mongo.bson.buffer.append(buf, as.character(i-1), aggr_cmd_list[[i]]);
  }
  mongo.bson.buffer.finish.object(buf)
  query <- mongo.bson.from.buffer(buf)
  
  res <- mongo.command(mongo, db, query)
  
  return(res)
}