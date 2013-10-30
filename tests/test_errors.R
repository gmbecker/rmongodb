library(rmongodb)
library(RUnit)

err <- mongo.get.last.err(mongo, db)
print(mongo.get.server.err(mongo))
iter = mongo.bson.find(err, "code")
print(mongo.bson.iterator.value(iter))
print(mongo.get.server.err.string(mongo))
iter = mongo.bson.find(err, "err")
print(mongo.bson.iterator.value(iter))

mongo.reset.err(mongo, db)