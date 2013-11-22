\name{mongo.summary}
\alias{mongo.summary}
\title{Mongo Key Summaries}
\usage{
  mongo.summary(mongo, ns, query = mongo.bson.empty(),
    fields = mongo.bson.empty(), limit = 0L, skip = 0L,
    options = 0L, ...)
}
\arguments{
  \item{mongo}{(\link{mongo}) A mongo connection object.}

  \item{ns}{(string) The namespace of the collection in
  which to find the keys.}

  \item{query}{(\link{mongo.bson}) The criteria with which
  to match the records to be found.  The default of
  mongo.bson.empty() will cause the the very first record
  in the collection to be returned.

  Alternately, \code{query} may be a list which will be
  converted to a mongo.bson object by
  \code{\link{mongo.bson.from.list}()}.}

  \item{fields}{(\link{mongo.bson}) The desired fields
  which are to be returned from the matching record.  The
  default of mongo.bson.empty() will cause all fields of
  the matching record to be returned; however, specific
  fields may be specified to cut down on network traffic
  and memory overhead.

  Alternately, \code{fields} may be a list which will be
  converted to a mongo.bson object by
  \code{\link{mongo.bson.from.list}()}.}

  \item{limit}{(as.integer) The maximum number of records
  to be returned. A limit of 0L will return all matching
  records not skipped.}

  \item{skip}{(as.integer) The number of matching records
  to skip before returning subsequent matching records.}

  \item{options}{(integer vector) Flags governing the
  requested operation as follows: \itemize{
  \item\link{mongo.find.cursor.tailable}
  \item\link{mongo.find.slave.ok}
  \item\link{mongo.find.oplog.replay}
  \item\link{mongo.find.no.cursor.timeout}
  \item\link{mongo.find.await.data}
  \item\link{mongo.find.exhaust}
  \item\link{mongo.find.partial.results} }}

  \item{...}{optional arguments to \link{summary}}
}
\value{
  (\link{mongo.cursor}) An object of class "mongo.cursor"
  which is used to step through the matching records.
}
\description{
  This function produces result summaries of the selected
  keys.
}
\seealso{
  \code{\link{summary}}
}

