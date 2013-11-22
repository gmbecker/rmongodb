\name{mongo.apply}
\alias{mongo.apply}
\title{Apply Function Over Keys}
\usage{
  mongo.apply(mongo, ns, margin,
    keys = mongo.get.keys[-1, 1], fun)
}
\arguments{
  \item{mongo}{(\link{mongo}) A mongo connection object.}

  \item{ns}{(string) The namespace of the collection in
  which to find the keys.}

  \item{margin}{(vector) A vector giving the subscripts
  which the function will be applied over. E.g., for a
  matrix 1 indicates rows, 2 indicates columns, c(1, 2)
  indicates rows and columns.}

  \item{keys}{(string) The name of the key field for which
  to get distinct values.}

  \item{fun}{(function) The function to be applied}

  \item{...}{optional arguments to fun}
}
\description{
  This function applies an R command over keys in a
  collection and returns the result.
}
\seealso{
  \code{\link{apply}}
}

