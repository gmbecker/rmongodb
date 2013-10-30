library(rmongodb)
library(RUnit)

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.start.object(buf, "age")
mongo.bson.buffer.append(buf, "$bad", 1L)
mongo.bson.buffer.finish.object(buf)
query  <- mongo.bson.from.buffer(buf)
print("bad find.one")
result <- mongo.find.one(mongo, ns, query)
if (is.null(result)) {
  print(mongo.get.server.err(mongo))
  print(mongo.get.server.err.string(mongo))
} else
  print(result)

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Dave")
query  <- mongo.bson.from.buffer(buf)
print("find.one")
result <- mongo.find.one(mongo, ns, query)

print("bson.find")
iter <- mongo.bson.find(result, "city")
if (!is.null(iter)) {
  city <- mongo.bson.iterator.value(iter)
  buf <- mongo.bson.buffer.create()
  mongo.bson.buffer.append(buf, "city", city)
  query <- mongo.bson.from.buffer(buf)
  print(paste("find city: ", city, sep=""))
  print(mongo.find.one(mongo, ns, query))
}

cursor <- mongo.find(mongo, ns, sort=mongo.bson.from.list(list(city=1L)), limit=100L)
print(mongo.cursor.value(cursor))
while (mongo.cursor.next(cursor))
  print(mongo.cursor.value(cursor))
mongo.cursor.destroy(cursor)