\name{mongo.get.keys}
\alias{mongo.get.keys}
\title{Get a vector of all keys in a collection}
\usage{
  mongo.get.keys(mongo, ns, rm_mr = TRUE)
}
\arguments{
  \item{mongo}{(\link{mongo}) A mongo connection object.}

  \item{ns}{(string) The namespace of the collection in
  which to find the keys.}

  \item{rm_mr}{(boolean) If TRUE the temporary collection
  created by mongodb mapreduce will be droped.}
}
\value{
  (dataframe) The result set of keys and the number of
  occurence in the collection. Or NULL if the mongo.command
  failed.
}
\description{
  Get a vector of all keys in a collection.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    keys <- mongo.get.keys(mongo, "test.people")
    print(keys)
}
}

