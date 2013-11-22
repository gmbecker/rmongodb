library(rmongodb)
library(RUnit)

# 10 tests
# 22.11.2013

mongo <- mongo.create()

# empty test db
db <- "rmongodb"
ns <- paste(db, "test_gridfs", sep=".")
mongo.drop(mongo, ns)

if( mongo.is.connected(mongo) ){
  
  gfs <- mongo.gridfs.create(mongo, db)
  checkEquals(class(gfs), "mongo.gridfs")
  
  out <- mongo.gridfs.store.file(gfs, "test_bson.R", "test.R")
  checkTrue(out)

  gridfile <- mongo.gridfs.find(gfs, "test.R")
  checkEquals( class(gridfile), "mongo.gridfile")
  
  out <- mongo.gridfile.get.descriptor(gridfile)
  print(out)
  checkEquals( class(out), "mongo.bson")
  out <- mongo.gridfile.get.filename(gridfile)
  print(out)
  checkEquals( out, "test.R")
  print(mongo.gridfile.get.length(gridfile))
  print(mongo.gridfile.get.chunk.size(gridfile))
  print(mongo.gridfile.get.chunk.count(gridfile))
  print(mongo.gridfile.get.content.type(gridfile))
  print(mongo.gridfile.get.upload.date(gridfile))
  print(mongo.gridfile.get.md5(gridfile))
  print(mongo.gridfile.get.metadata(gridfile))
  
  b <- mongo.gridfile.get.chunk(gridfile, 0)
  print(b)
  checkEquals( class(b), "mongo.bson")
  
  iter <- mongo.bson.find(b, "data")
  out_file <- rawToChar(mongo.bson.iterator.value(iter))
  checkTrue( is.character(out_file))
  checkEquals( substr(out_file, 1, 17), "library(rmongodb)")
  
  test.out <- file("test.out")
  mongo.gridfile.pipe(gridfile, test.out)
  checkTrue( file.exists("test.out") )
  file.remove("test.out")
  
  gfw <- mongo.gridfile.writer.create(gfs, "test.dat")
  # store 4 bytes
  mongo.gridfile.writer.write(gfw, charToRaw("test"))
  # store string & LF plus 0-byte terminator
  buf <- writeBin("Test\n", as.raw(1))
  mongo.gridfile.writer.write(gfw, buf)
  # store PI as a float
  buf <- writeBin(3.1415926, as.raw(1), size=4, endian="little")
  mongo.gridfile.writer.write(gfw, buf)
  mongo.gridfile.writer.finish(gfw)
  
  
  mongo.gridfs.remove.file(gfs, "test.R")
  out <- mongo.gridfs.find(gfs, "test.R")
  checkTrue(is.null(out))
  
  mongo.gridfile.destroy(gridfile)

}

mongo.disconnect(mongo)
mongo.destroy(mongo)
