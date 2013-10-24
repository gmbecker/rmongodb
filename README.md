rmongodb
===================

This is an R extension supporting access to MongoDB using the mongodb-c-driver.

Thanks to Gerald Lindsly and MongoDB, Inc. (formerly 10gen) for all the initial work. 
In October 2013, **MongoSoup** (www.mongosoup.de) has overtacken the development and maintenance of the R package. 

Please feel free to send us issues, feedback or push 
requests: markus@mongosoup.de

Usage
==================
Once you have installed the package, it may be loaded from within R like any other:

    library("rmongodb")
    
    mongo <- mongo.create()
    
    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "age", 18L)
    query <- mongo.bson.from.buffer(buf)

    # Find the first 100 records
    #    in collection people of database test where age == 18
    cursor <- mongo.find(mongo, "test.people", query, limit=100L)
    # Step though the matching records and display them
    while (mongo.cursor.next(cursor))
        print(mongo.cursor.value(cursor))
    mongo.cursor.destroy(cursor)

To run the unit tests:
    R --no-save < tests/test.R


Development
==================

To install the development version of rmongodb, it's easiest to use the devtools package:

    # install.packages("devtools")
    library(devtools)
    install_github("rmongodb", "mongosoup")








