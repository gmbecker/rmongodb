library(rmongodb)
library(RUnit)

mongo <- mongo.create()
if (!mongo.is.connected(mongo))
  stop("No connnection")

print(mongo.get.primary(mongo))
print(sprintf("IsMaster (%s)", if (mongo.is.master(mongo)) "Yes" else "No"))
mongo.set.timeout(mongo, 2000)
print(mongo.get.timeout(mongo))

print(mongo.simple.command(mongo, "admin", "buildInfo", 1))

print(mongo.get.databases(mongo))
#print(mongo.simple.command(mongo, "admin", "top", 1L))

db <- "test"
ns <- paste(db, "test", sep=".")
print("drop collection x2")
print(mongo.drop(mongo, ns))
print(mongo.drop(mongo, "foo.bar"))
print("drop database")
print(mongo.drop.database(mongo, db))

print("test add dup key")
ns <- paste(db, "people", sep=".")
mongo.index.create(mongo, ns, "name", mongo.index.unique)


# test various other database ops

print("add user")
print(mongo.add.user(mongo, "Gerald", "PaSsWoRd"))

mongo.simple.command(mongo, db, "badcommand", 0L)
print(mongo.get.err(mongo))




buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "")
mongo.bson.buffer.append(buf, "age", 1L)
b <- mongo.bson.from.buffer(buf)
print("index create")
print(mongo.index.create(mongo, ns, b))

print("rename")
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "renameCollection", ns)
mongo.bson.buffer.append(buf, "to", "foo.humans")
command <- mongo.bson.from.buffer(buf)
print(mongo.command(mongo, "admin", command))
ns <- "foo.humans"

print("count x2")
print(mongo.count(mongo, ns))
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "count", "humans")
mongo.bson.buffer.append(buf, "query", mongo.bson.empty())
command <- mongo.bson.from.buffer(buf)
print(mongo.command(mongo, "foo", command))

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Ford")
mongo.bson.buffer.append(buf, "engine", "Vv8")
z <- mongo.bson.from.buffer(buf)
mongo.insert(mongo, "foo.cars", z)

print(mongo.get.database.collections(mongo, "foo"))

buf <- mongo.bson.buffer.create()
l <- list(fruit = "apple", hasSeeds = TRUE)
mongo.bson.buffer.append.list(buf, "item", l)
b <- mongo.bson.from.buffer(buf)
print(b)


buf <- mongo.bson.buffer.create()
undef <- mongo.undefined.create()
mongo.bson.buffer.append(buf, "Undef", undef)
l <- list(u1 = undef, One = 1)
mongo.bson.buffer.append.list(buf, "listWundef", l)
b <- mongo.bson.from.buffer(buf)
print(b)
print(mongo.bson.to.list(b))

