\name{mongo.table}
\alias{mongo.table}
\title{Count Tables}
\usage{
  mongo.table(mongo, ns, keys, limit = 0L, skip = 0L)
}
\arguments{
  \item{mongo}{(\link{mongo}) A mongo connection object.}

  \item{ns}{(string) The namespace of the collection in
  which to find the keys.}

  \item{keys}{(string) The name of the key field for which
  to get distinct values.}

  \item{limit}{(as.integer) The maximum number of records
  to be returned. A limit of 0L will return all matching
  records not skipped.}

  \item{skip}{(as.integer) The number of matching records
  to skip before returning subsequent matching records.}
}
\description{
  This function creates tables of counts at each
  combination of keys
}
\seealso{
  \code{\link{table}}
}

