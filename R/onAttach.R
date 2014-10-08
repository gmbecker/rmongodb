.onAttach <- function(libname, pkgname) {
  # Runs when attached to search() path such as by library() or require()
  if (interactive()) {
    packageStartupMessage('WARNING! In this version of rmongodb package behavior of 
    functions mongo.bson.to.list, mongo.bson.from.list was slightly changed. Please see NEWS file.')
    packageStartupMessage('WARNING! In the next release functionality of mongo.cursor.to.list will 
    be replaced by new mongo.cursor.to.rlist. Please see ?mongo.cursor.to.rlist');
  }
}
