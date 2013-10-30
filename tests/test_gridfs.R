library(rmongodb)
library(RUnit)


gfs <- mongo.gridfs.create(mongo, "grid")
if (!mongo.gridfs.store.file(gfs, "test.R", "test.R"))
  stop("unable to store test.R")



gridfile <- mongo.gridfs.find(gfs, "test.R")
print(mongo.gridfile.get.descriptor(gridfile))
print(mongo.gridfile.get.filename(gridfile))
print(mongo.gridfile.get.length(gridfile))
print(mongo.gridfile.get.chunk.size(gridfile))
print(mongo.gridfile.get.chunk.count(gridfile))
print(mongo.gridfile.get.content.type(gridfile))
print(mongo.gridfile.get.upload.date(gridfile))
print(mongo.gridfile.get.md5(gridfile))
print(mongo.gridfile.get.metadata(gridfile))

b <- mongo.gridfile.get.chunk(gridfile, 0)
print(b)
iter <- mongo.bson.find(b, "data")
print(rawToChar(mongo.bson.iterator.value(iter)))

test.out <- file("test.out")
mongo.gridfile.pipe(gridfile, test.out)

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
if (!is.null(mongo.gridfs.find(gfs, "test.R")))
  stop("mongo.gridfs.remove.file didn't work.")

mongo.gridfile.destroy(gridfile)

mongo.disconnect(mongo)
mongo.destroy(mongo)
