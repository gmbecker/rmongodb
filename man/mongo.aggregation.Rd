\name{mongo.aggregation}
\alias{mongo.aggregation}
\title{Aggregation pipeline}
\usage{
mongo.aggregation(mongo, ns, aggr_cmd_list)
}
\arguments{
  \item{mongo}{(\link{mongo}) A mongo connection object.}

  \item{ns}{(string) The namespace of the collection in
  which to find distinct keys.}

  \item{aggr_cmd_list}{\link{mongo.bson} An list
  representing aggregation query pipeline.}
}
\value{
NULL if the command failed.  \code{\link{mongo.get.err}()}
may be MONGO_COMMAND_FAILED.

\link{mongo.bson} The result of aggregation.
}
\description{
Aggregation pipeline
}
\details{
See
\url{http://docs.mongodb.org/manual/core/aggregation-pipeline/}.
}
\examples{
# Imagine we have collection with people ids and their ages. Aggregation below finds ids
# between 1 and 1000, group by age, counts them and push ids into buckets, one per age.
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
  upper <- 1000
  lower <- 1
  pipe_1 <- mongo.bson.from.list(list("$match" = list('id'=c(list('$lte' = upper), list('$gte' = lower)))))
  pipe_2 <- mongo.bson.from.list(list("$project" = list('id' = 1, 'age'=1)))
  pipe_3 <- mongo.bson.from.list(list("$group" = c(list('_id' = '$age'), list(cnt=list('$sum'=1)), list(ids=list('$push'='$id')))))
  cmd_list <- list(pipe_1, pipe_2, pipe_3)
  aggr <- mongo.aggregation(mongo, ns = 'db.collection', aggr_cmd_list = cmd_list)
  # check results:
  str(mongo.bson.to.list(aggr))
}
mongo.destroy(mongo = mongo)
}
\seealso{
\code{\link{mongo.command}},\cr
\code{\link{mongo.simple.command}},\cr
\code{\link{mongo.find}},\cr \link{mongo}.
}

