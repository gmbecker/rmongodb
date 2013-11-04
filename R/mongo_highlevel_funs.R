
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
#' @return NULL if the command failed.  \code{\link{mongo.get.err}()} may be
#' MONGO_COMMAND_FAILED.
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
#' @param mongo (\link{mongo}) A mongo connection object.
#' @param ns (string) The namespace of the collection in which to find the
#' keys.
#' @param rm_mr (boolean) If TRUE the temporary collection created by mongodb mapreduce will be droped.
#' 
#' @return (dataframe) The result set of keys and the number of occurence in the collection. Or NULL if the mongo.command failed.
#' 
#' @examples
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     keys <- mongo.get.keys(mongo, "test.people")
#'     print(keys)
#' }
#' 
#' @export mongo.get.keys
mongo.get.keys <- function(mongo, ns, rm_mr=TRUE){
  
  pos <- regexpr('\\.', ns)
  if (pos == 0) {
    print("mongo.distinct: No '.' in namespace")
    return(NULL)
  }
  db <- substr(ns, 1, pos-1)
  collection <- substr(ns, pos+1, nchar(ns))
 
  mr <- list("mapreduce" = collection,
             "map" = "function() { for (var key in this) { emit(key, null); } }",
             "reduce" = "function(key, stuff) { return stuff.length; }", 
             "out"= paste(collection, "_keys", sep=""))
  mr_bson <- mongo.bson.from.list(mr)
  cmd <- mongo.command(mongo, db, mr_bson)
  
  if (!is.null(cmd)){
    res <- mongo.find.all(mongo, paste(ns, "_keys", sep=""))
  } else
    return(NULL)
  
  if (rm_mr==TRUE){
    err <- mongo.drop(mongo, paste(ns, "_keys", sep=""))
  }
  
  return(res)
}




#' Apply Function Over Keys
#' 
#' This function applies an R command over keys in a collection and returns the result.
#' 
#' @param mongo (\link{mongo}) A mongo connection object.
#' @param ns (string) The namespace of the collection in which to find the
#' keys.
#' @param margin (vector) A vector giving the subscripts which the function 
#' will be applied over. E.g., for a matrix 1 indicates rows, 2 indicates columns, 
#' c(1, 2) indicates rows and columns. 
#' @param keys (string) The name of the key field for which to get distinct
#' values.
#' @param fun (function) The function to be applied
#' @param ...	optional arguments to fun
#' 
#' @seealso \code{\link{apply}}
#' @export mongo.apply
mongo.apply <- function(mongo, ns, margin, keys=mongo.get.keys[-1,1], fun){

  #mongo.get.keys[-1,1]
  #
  #buf <- mongo.bson.buffer.create()
  #for( k in keys){
  #  mongo.bson.buffer.append(buf, k, 1)
  #}
  #fields <- mongo.bson.from.buffer(buf)
  #
  #res <- mongo.find.all(mongo, ns, fields=fields)
  
  warning(" comming soon ")
  
  return(NULL)
  
}





#' Mongo Key Summaries
#' 
#' This function produces result summaries of the selected keys.
#'
#' @param mongo (\link{mongo}) A mongo connection object.
#' @param ns (string) The namespace of the collection in which to find the
#' keys.
#' @param query (\link{mongo.bson}) The criteria with which to match the
#' records to be found.  The default of mongo.bson.empty() will cause the the
#' very first record in the collection to be returned.
#' 
#' Alternately, \code{query} may be a list which will be converted to a
#' mongo.bson object by \code{\link{mongo.bson.from.list}()}.
#' @param fields (\link{mongo.bson}) The desired fields which are to be
#' returned from the matching record.  The default of mongo.bson.empty() will
#' cause all fields of the matching record to be returned; however, specific
#' fields may be specified to cut down on network traffic and memory overhead.
#' 
#' Alternately, \code{fields} may be a list which will be converted to a
#' mongo.bson object by \code{\link{mongo.bson.from.list}()}.
#' @param limit (as.integer) The maximum number of records to be returned. A
#' limit of 0L will return all matching records not skipped.
#' @param skip (as.integer) The number of matching records to skip before
#' returning subsequent matching records.
#' @param options (integer vector) Flags governing the requested operation as
#' follows: \itemize{ \item\link{mongo.find.cursor.tailable}
#' \item\link{mongo.find.slave.ok} \item\link{mongo.find.oplog.replay}
#' \item\link{mongo.find.no.cursor.timeout} \item\link{mongo.find.await.data}
#' \item\link{mongo.find.exhaust} \item\link{mongo.find.partial.results} }
#' @param ...  optional arguments to \link{summary}
#' 
#' @return (\link{mongo.cursor}) An object of class "mongo.cursor" which is
#' used to step through the matching records.
#'  
#' @seealso \code{\link{summary}}
#' @export mongo.summary
mongo.summary <- function(mongo, ns, 
                          query=mongo.bson.empty(),
                          fields=mongo.bson.empty(),
                          limit=0L, skip=0L, options=0L, 
                          ...){
  
  out <- mongo.find.all(mongo, ns, query=query, fields=fields, limit=limit, skip=skip, options=options)
  
  res <- summary(out, ...)
  
  return(res)
}




#' Compute Summary Statistics of Mongo Subsets
#' 
#' Splits the mongo data into subsets, computes summary statistics for eachm and returns the result in a convenient form.
#' 
#' @param mongo (\link{mongo}) A mongo connection object.
#' @param ns (string) The namespace of the collection in which to find the
#' keys.
#' @param keys (string) The name of the key field for which to get distinct
#' values.
#' @param by (string) The name of the key field for which to aggregate values.
#' 
#' @seealso \code{\link{aggregate}}
#' @export mongo.aggregate.stats
mongo.aggregate.stats <- function(mongo, ns, keys, by){
  
  # ToDo
  warning(" comming soon ")
  
  return(NULL)
  
}




#' Count Tables
#' 
#' This function creates tables of counts at each combination of keys
#' 
#' @param mongo (\link{mongo}) A mongo connection object.
#' @param ns (string) The namespace of the collection in which to find the
#' keys.
#' @param keys (string) The name of the key field for which to get distinct
#' values.
#' @param limit (as.integer) The maximum number of records to be returned. A
#' limit of 0L will return all matching records not skipped.
#' @param skip (as.integer) The number of matching records to skip before
#' returning subsequent matching records.
#' 
#' @seealso \code{\link{table}}
#' @export mongo.table
mongo.table <- function(mongo, ns, keys, limit=0L, skip=0L){
  
  #mongo.distinct
  
  # ToDo
  warning(" comming soon ")
  
  return(NULL)
  
}



