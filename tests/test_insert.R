library(rmongodb)
library(RUnit)

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "John")
mongo.bson.buffer.append(buf, "age", 22L)
x <- mongo.bson.from.buffer(buf)
mongo.insert(mongo, ns, x);

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "John")
mongo.bson.buffer.append(buf, "age", 27L)
x <- mongo.bson.from.buffer(buf)
mongo.insert(mongo, ns, x);



print("insert")
#print(mongo.insert(mongo, ns, b))  #

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Dwight")
mongo.bson.buffer.append(buf, "city", "NY")
b <- mongo.bson.from.buffer(buf)
mongo.insert(mongo, ns, b)

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Dave")
mongo.bson.buffer.append(buf, "city", "Cincinnati")
x <- mongo.bson.from.buffer(buf)

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Fred")
mongo.bson.buffer.append(buf, "city", "Dayton")
mongo.bson.buffer.append(buf, "age", 21L)
print(mongo.bson.buffer.size(buf))

y <- mongo.bson.from.buffer(buf)
print(mongo.bson.size(y))

l <- mongo.bson.to.list(y)
print(l$name)
print(l$city)
l$city <- "Detroit"
print(l)

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Silvia")
mongo.bson.buffer.append(buf, "city", "Cincinnati")
z <- mongo.bson.from.buffer(buf)
mongo.insert.batch(mongo, ns, list(x, y, z))

print("index create x2")
print(mongo.index.create(mongo, ns, "city"))

print(mongo.index.create(mongo, ns, c("name", "city")))
