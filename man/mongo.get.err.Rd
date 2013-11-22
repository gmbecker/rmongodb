\name{mongo.get.err}
\alias{mongo.get.err}
\title{Retrieve an connection error code from a mongo object}
\usage{
  mongo.get.err(mongo)
}
\arguments{
  \item{mongo}{(\link{mongo}) a mongo connection object.}
}
\value{
  (integer) error code as follows:

  mongo.create() errors:

  Other errors:
}
\description{
  Retrieve an connection error code from a mongo object
  indicating the failure code if mongo.create() failed.
}
\examples{
mongo <- mongo.create()
if (!mongo.is.connected(mongo)) {
    print("Unable to connect.  Error code:")
    print(mongo.get.err(mongo))
}
}
\seealso{
  \code{\link{mongo.create}},\cr \link{mongo}
}

