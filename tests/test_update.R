library(rmongodb)
library(RUnit)

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "_id", oid)
query <- mongo.bson.from.buffer(buf)

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.start.object(buf, "$inc")
mongo.bson.buffer.append(buf, "age", 1L)
mongo.bson.buffer.finish.object(buf)
op  <- mongo.bson.from.buffer(buf)

mongo.update(mongo, ns, query, op)