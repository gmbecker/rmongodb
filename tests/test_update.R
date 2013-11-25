library(rmongodb)
library(RUnit)

# 1 tests
# 22.11.2013

mongo <- mongo.create()

# empty test db
db <- "rmongodb"
ns <- paste(db, "test_update", sep=".")
mongo.drop(mongo, ns)

if( mongo.is.connected(mongo) ){
  
  # inster data
  buf <- mongo.bson.buffer.create()
  mongo.bson.buffer.append(buf, "name", "Dave")
  mongo.bson.buffer.append(buf, "age", 27L)
  x <- mongo.bson.from.buffer(buf)
  buf <- mongo.bson.buffer.create()
  mongo.bson.buffer.append(buf, "name", "Fred")
  mongo.bson.buffer.append(buf, "age", 31L)
  y <- mongo.bson.from.buffer(buf)
  buf <- mongo.bson.buffer.create()
  mongo.bson.buffer.append(buf, "name", "Silvia")
  mongo.bson.buffer.append(buf, "age", 24L)
  z <- mongo.bson.from.buffer(buf)
  mongo.insert.batch(mongo, ns, list(x, y, z))
  
  
  # update one document
  buf <- mongo.bson.buffer.create()
  mongo.bson.buffer.append(buf, "name", "Silvia")
  query <- mongo.bson.from.buffer(buf)
  
  buf <- mongo.bson.buffer.create()
  mongo.bson.buffer.start.object(buf, "$inc")
  mongo.bson.buffer.append(buf, "age", 1L)
  mongo.bson.buffer.finish.object(buf)
  op  <- mongo.bson.from.buffer(buf)
  
  mongo.update(mongo, ns, query, op)
   
  checkEquals(
      mongo.bson.value( mongo.find.one(mongo, ns, query), "age"),
      mongo.bson.value( z, "age") +1 )
  
}

# cleanup and close
mongo.drop.database(mongo, db)
mongo.disconnect(mongo)
mongo.destroy(mongo)