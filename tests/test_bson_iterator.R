library(rmongodb)
library(RUnit)

iter <- mongo.bson.iterator.create(b)
while (mongo.bson.iterator.next(iter)) {
  print(mongo.bson.iterator.key(iter))
  print(mongo.bson.iterator.value(iter))
}
print(attr(ts, "increment"))

iter <- mongo.bson.find(b, "code")
print(mongo.bson.iterator.value(iter))

sub2 <- mongo.bson.value(b, "data.sub2")
print(sub2)