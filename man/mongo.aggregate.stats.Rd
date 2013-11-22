\name{mongo.aggregate.stats}
\alias{mongo.aggregate.stats}
\title{Compute Summary Statistics of Mongo Subsets}
\usage{
  mongo.aggregate.stats(mongo, ns, keys, by)
}
\arguments{
  \item{mongo}{(\link{mongo}) A mongo connection object.}

  \item{ns}{(string) The namespace of the collection in
  which to find the keys.}

  \item{keys}{(string) The name of the key field for which
  to get distinct values.}

  \item{by}{(string) The name of the key field for which to
  aggregate values.}
}
\description{
  Splits the mongo data into subsets, computes summary
  statistics for eachm and returns the result in a
  convenient form.
}
\seealso{
  \code{\link{aggregate}}
}

