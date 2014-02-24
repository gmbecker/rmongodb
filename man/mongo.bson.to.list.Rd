\name{mongo.bson.to.list}
\alias{mongo.bson.to.list}
\title{Convert a mongo.bson object to an R list object.}
\usage{
mongo.bson.to.list(b, simplify = FALSE)
}
\arguments{
  \item{b}{(\link{mongo.bson}) The mongo.bson object to
  convert.}

  \item{simplify}{logical (default: FALSE); should the
  result be simplified to a vector, matrix or higher
  dimensional array if possible?}
}
\value{
an R object of the type list
}
\description{
Convert a \link{mongo.bson} object to an R list object.
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Fred")
mongo.bson.buffer.append(buf, "city", "Dayton")
b <- mongo.bson.from.buffer(buf)

l <- mongo.bson.to.list(b)
print(l)
}
\seealso{
\code{\link{mongo.bson.from.list}},
\code{\link{mongo.bson.to.Robject}},\cr \link{mongo.bson}.
}

