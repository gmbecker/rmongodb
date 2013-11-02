library(rmongodb)
library(RUnit)

# empty test db
mongo <- mongo.create()
db <- "rmongodb"
ns <- paste(db, "test_find", sep=".")
mongo.drop(mongo, ns)

# inster data
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Dave")
mongo.bson.buffer.append(buf, "city", "Munich")
mongo.bson.buffer.append(buf, "age", 27L)
x <- mongo.bson.from.buffer(buf)
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Fred")
mongo.bson.buffer.append(buf, "city", "Chicago")
mongo.bson.buffer.append(buf, "age", 31L)
y <- mongo.bson.from.buffer(buf)
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Silvia")
mongo.bson.buffer.append(buf, "city", "London")
mongo.bson.buffer.append(buf, "age", 24L)
z <- mongo.bson.from.buffer(buf)
mongo.insert.batch(mongo, ns, list(x, y, z))


# create bad query
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.start.object(buf, "age")
mongo.bson.buffer.append(buf, "$bad", 1L)
mongo.bson.buffer.finish.object(buf)
query  <- mongo.bson.from.buffer(buf)
result <- mongo.find.one(mongo, ns, query)

checkEquals(result, NULL)

if (is.null(result)) {
  err <- mongo.get.server.err(mongo)
  print(err)
  print(mongo.get.server.err.string(mongo))
} 

checkEqualsNumeric(err, 10068)


# good query with find.one
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Dave")
query  <- mongo.bson.from.buffer(buf)
result <- mongo.find.one(mongo, ns, query)

checkEquals( mongo.bson.value(result, "name"), "Dave")


# good query with find and bson find
iter <- mongo.bson.find(result, "city")
if (!is.null(iter)) {
  city <- mongo.bson.iterator.value(iter)
  buf <- mongo.bson.buffer.create()
  mongo.bson.buffer.append(buf, "city", city)
  query <- mongo.bson.from.buffer(buf)
  #print(paste("find city: ", city, sep=""))
  res <- mongo.find.one(mongo, ns, query)
  
  checkEquals( mongo.bson.value(res, "city"), "Munich")
  
}



# good query with find and sort
cursor <- mongo.find(mongo, ns, sort=mongo.bson.from.list(list(city=1L)), limit=100L)
res <- NULL
while (mongo.cursor.next(cursor))
  res <- rbind(res, mongo.bson.to.list(mongo.cursor.value(cursor)))
mongo.cursor.destroy(cursor)

checkEquals( dim(res), c(3,4))
checkIdentical( sort(unlist(res[, "city"])) , unlist(res[, "city"]))



# good query with find.all
res <- mongo.find.all(mongo, ns)

checkEquals( dim(res), c(3,4))
checkTrue( is.list(res))
