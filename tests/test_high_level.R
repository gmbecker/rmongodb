library(rmongodb)
library(RUnit)

# 03.03.2014

# set up mongoDB connection and db / collection parameters
mongo <- mongo.create()
db <- "rmongodb"
ns <- paste(db, "test_high_level", sep=".")

if( mongo.is.connected(mongo) ){
  
  # clean up old existing collection
  mongo.drop(mongo, ns)
  # and insert some data
  mongo.insert(mongo, ns, '{"name":"Peter", "city":"Rom"}')
  mongo.insert(mongo, ns, '{"name":"Markus", "city":"Munich", "age":51}')
  mongo.insert(mongo, ns, '{"name":"Tom", "city":"London", "age":1}')
  mongo.insert(mongo, ns, '{"name":"Jon", "age":23}')
  
  
  #mongo.distinct
  res <- mongo.distinct(mongo, ns, "name")
  checkEquals(as.vector(res), c("Peter", "Markus", "Tom", "Jon"))
  
  res <- mongo.distinct(mongo, ns, "name2")
  checkEquals(length(res), 0)
    
  res <- mongo.distinct(mongo, ns, "age")
  checkEquals(as.vector(res), c(51,1,23))
  
  checkException( mongo.distinct(mongo, "ns", "age"), "Wrong namespace (ns)." )
  
  
  # mongo.parse.ns
  res <- rmongodb:::mongo.parse.ns("db.coll")
  checkEquals(res$db, "db")
  checkEquals(res$collection, "coll")
  checkTrue(is.list(res))
  
  res <- rmongodb:::mongo.parse.ns("db_coll")
  checkTrue(is.null(res))
  
  
  # cleanup db and close connection
  mongo.drop.database(mongo, db)
  mongo.destroy(mongo)
}

