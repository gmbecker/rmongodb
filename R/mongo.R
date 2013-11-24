#' Create an object of class "mongo"
#' 
#' Connect to a MongoDB server or replset and return an object of class "mongo"
#' used for further communication over the connection.
#' 
#' All parameters are stored as attributes of the returned mongo object. Note
#' that these attributes only reflect the initial parameters. Only the external
#' data pointed to by the "mongo" attribute actually changes if, for example,
#' mongo.timeout is called after the initial call to \code{mongo.create}.
#' 
#' 
#' @param host (string vector) A list of hosts/ports to which to connect.  If a
#' port is not given, 27017 is used. Seperate ports from the IP address by
#' colon, like "120.0.0.1:12345".
#' @param name (string) The name of the replset to which to connect. If name ==
#' "" (the default), the hosts are tried one by one until a connection is made.
#' Otherwise, name must be the name of the replset and the given hosts are
#' assumed to be seeds of the replset.  Each of these is connected to and
#' queried in turn until one reports that it is a master.  This master is then
#' queried for a list of hosts and these are in turn connected to and verified
#' as belonging to the given replset name.  When one of these reports that it
#' is a master, that connection is used to form the actual connection as
#' returned.
#' @param username (string) The username to be used for authentication
#' purposes.  The default username of "" indicates that no user authentication
#' is to be performed by the initial connect.
#' @param password (string) The password corresponding to the given username.
#' @param db (string) The name of the database upon which to authenticate the
#' given username and password.  If authentication fails, the connection is
#' disconnected, but mongo.get.err() will indicate not indicate an error.
#' @param timeout (as.integer) The number of milliseconds to wait before timing
#' out of a network operation.  The default (0L) indicates no timeout.
#' @return If successful, a mongo object for use in subsequent database
#' operations; otherwise, mongo.get.err() may be called on the returned mongo
#' object to see why it failed.
#' @seealso \link{mongo},\cr \code{\link{mongo.is.connected}},\cr
#' \code{\link{mongo.disconnect}},\cr \code{\link{mongo.reconnect}},\cr
#' \code{\link{mongo.get.err}},\cr \code{\link{mongo.get.primary}},\cr
#' \code{\link{mongo.get.hosts}},\cr \code{\link{mongo.get.socket}},\cr
#' \code{\link{mongo.set.timeout}},\cr \code{\link{mongo.get.timeout}}.
#' @examples
#' 
#' mongo <- mongo.create()
#' \dontrun{
#'     mongo <- mongo.create("192.168.0.3")}
#' 
#' @export mongo.create
mongo.create <- function(host="127.0.0.1", name="", username="", password="", db="admin", timeout=0L) {
  mongo <- .Call(".mongo.create")
  attr(mongo, "host") <- host
  attr(mongo, "name") <- name
  attr(mongo, "username") <- username
  attr(mongo, "password") <- password
  attr(mongo, "db") <- db
  attr(mongo, "timeout") <- timeout
  .Call(".mongo.connect", mongo)
}






#' Retrieve an connection error code from a mongo object
#' 
#' Retrieve an connection error code from a mongo object indicating the failure
#' code if mongo.create() failed.
#' 
#' 
#' @param mongo (\link{mongo}) a mongo connection object.
#' @return (integer) error code as follows:
#' 
#' mongo.create() errors:
#' 
#' Other errors:
#' @returnItem 0 No Error
#' @returnItem 1 No socket - Could not create socket.
#' @returnItem 2 Fail - An error occurred attempting to connect to socket
#' @returnItem 3 Address fail - An error occured calling getaddrinfo().
#' @returnItem 4 Not Master - Warning: connected to a non-master node
#' (read-only).
#' @returnItem 5 Bad set name - given name doesn't match the replica set.
#' @returnItem 6 No Primary - Cannot find primary in replica set - connection
#' closed.
#' @returnItem 7 I/O error - An error occured reading or writing on the socket.
#' @returnItem 8 Read size error - The response is not the expected length.
#' @returnItem 9 Command failed - The command returned with 'ok' value of 0.
#' @returnItem 10 BSON invalid - Not valid for the specified operation.
#' @returnItem 11 BSON not finished - should not occur with R driver.
#' @seealso \code{\link{mongo.create}},\cr \link{mongo}
#' @examples
#' 
#' mongo <- mongo.create()
#' if (!mongo.is.connected(mongo)) {
#'     print("Unable to connect.  Error code:")
#'     print(mongo.get.err(mongo))
#' }
#' 
#' @export mongo.get.err
mongo.get.err <- function(mongo)
    .Call(".mongo.get.err", mongo)



#' Disconnect from a MongoDB server
#' 
#' Disconnect from a MongoDB server.  No further communication is possible on
#' the connection. However, \code{\link{mongo.reconnect}()} may be called on
#' the mongo object to restablish the connection.
#' 
#' 
#' @param mongo (\link{mongo}) a mongo connection object.
#' @return The mongo object is returned.
#' @seealso \link{mongo},\cr \code{\link{mongo.create}},\cr
#' \code{\link{mongo.reconnect}},\cr \code{\link{mongo.is.connected}}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     n_people <- mongo.count(mongo, "test.people")
#'     mongo.disconnect(mongo)
#' }
#' 
#' @export mongo.disconnect
mongo.disconnect <- function(mongo)
    .Call(".mongo.disconnect", mongo)



#' Reconnect to a MongoDB server
#' 
#' Reconnect to a MongoDB server. Calls mongo.disconnect and then attempts to
#' re-establish the connection.
#' 
#' 
#' @param mongo (\link{mongo}) a mongo connection object.
#' @seealso \code{\link{mongo.create}},\cr \code{\link{mongo.disconnect}},\cr
#' \link{mongo}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo))
#'     mongo.reconnect(mongo)
#' 
#' @export mongo.reconnect
mongo.reconnect <- function(mongo)
    .Call(".mongo.reconnect", mongo)



#' Destroy a MongoDB connection
#' 
#' Destroy a \link{mongo} connection.  The connection is disconnected first if
#' it is still connected. No further communication is possible on the
#' connection.  Releases resources attached to the connection on both client
#' and server.
#' 
#' Although the 'destroy' functions in this package are called automatically by
#' garbage collection, this one in particular should be called as soon as
#' feasible when finished with the connection so that server resources are
#' freed.
#' 
#' 
#' @param mongo (\link{mongo}) a mongo connection object.
#' @return NULL
#' @seealso \link{mongo},\cr \code{\link{mongo.disconnect}},\cr
#' \code{\link{mongo.is.connected}}\cr \code{\link{mongo.reconnect}}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     n_people <- mongo.count(mongo, "test.people")
#'     mongo.destroy(mongo)
#'     print(n_people)
#' }
#' 
#' @export mongo.destroy
mongo.destroy <- function(mongo)
    .Call(".mongo.destroy", mongo)



#' Determine if a mongo object is connected to a MongoDB server
#' 
#' Returns TRUE if the parameter mongo object is connected to a MongoDB server;
#' otherwise, FALSE.
#' 
#' 
#' @param mongo (\link{mongo}) a mongo connection object.
#' @return Logical TRUE if the mongo connection object is currently connected
#' to a server; otherwise, FALSE.
#' @seealso \code{\link{mongo.create}},\cr \link{mongo}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     print(mongo.count(mongo, "test.people"))
#' }
#' 
#' @export mongo.is.connected
mongo.is.connected <- function(mongo)
    .Call(".mongo.is.connected", mongo)



#' Get the socket assigned to a mongo object by mongo.create().
#' 
#' Get the the low-level socket number assigned to the given mongo object by
#' mongo.create().
#' 
#' 
#' @param mongo (\link{mongo}) a mongo connection object.
#' @return Integer socket number
#' @seealso \code{\link{mongo.create}},\cr \link{mongo}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo))
#'     print(mongo.get.socket(mongo))
#' 
#' @export mongo.get.socket
mongo.get.socket <- function(mongo)
    .Call(".mongo.get.socket", mongo)



#' Get the host & port of the server to which a mongo object is connected.
#' 
#' Get the host & port of the server to which a mongo object is connected.
#' 
#' 
#' @param mongo (\link{mongo}) a mongo connection object.
#' @return String host & port in the format "\%s:\%d".
#' @seealso \code{\link{mongo.create}},\cr \link{mongo}.
#' @examples
#' 
#' \dontrun{
#' mongo <- mongo.create(c("127.0.0.1", "192.168.0.3"))
#' if (mongo.is.connected(mongo)) {
#'     print(mongo.get.primary(mongo))
#' }
#' }
#' 
#' @export mongo.get.primary
mongo.get.primary <- function(mongo)
    .Call(".mongo.get.primary", mongo)



#' Get a lists of hosts & ports as reported by a replica set master upon
#' connection creation.
#' 
#' Get a lists of hosts & ports as reported by a replica set master upon
#' connection creation.
#' 
#' 
#' @param mongo (\link{mongo}) a mongo connection object.
#' @return NULL if a replica set was not connected to; otherwise, a list of
#' host & port strings in the format "%s:%d".
#' @seealso \code{\link{mongo.create}},\cr \link{mongo}
#' @examples
#' 
#' \dontrun{
#' mongo <- mongo.create(c("127.0.0.1", "192.168.0.3"), name="Inventory")
#' if (mongo.is.connected(mongo))
#'     print(mongo.get.hosts(mongo))
#' }
#' 
#' @export mongo.get.hosts
mongo.get.hosts <- function(mongo)
    .Call(".mongo.get.hosts", mongo)



#' Set the timeout value on a mongo connection
#' 
#' Set the timeout value for network operations on a mongo connection.
#' Subsequent network operations will timeout if they take longer than the
#' given number of milliseconds.
#' 
#' 
#' @param mongo (\link{mongo}) a mongo connection object.
#' @param timeout (as.integer) number of milliseconds to which to set the
#' timeout value.
#' @seealso \code{\link{mongo.get.timeout}},\cr \code{\link{mongo.create}},\cr
#' \link{mongo}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     mongo.set.timeout(mongo, 2000L)
#'     timeout <- mongo.get.timeout(mongo)
#'     if (timeout != 2000L)
#'         error("expected timeout of 2000");
#' }
#' 
#' @export mongo.set.timeout
mongo.set.timeout <- function(mongo, timeout)
    .Call(".mongo.set.timeout", mongo, timeout)



#' Get the timeout value of a mongo connection
#' 
#' Get the timeout value for network operations on a mongo connection.
#' 
#' 
#' @param mongo (\link{mongo}) a mongo connection object.
#' @return (integer) timeout value in milliseconds.
#' @seealso \code{\link{mongo.set.timeout}},\cr \code{\link{mongo.create}},\cr
#' \link{mongo}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     mongo.set.timeout(mongo, 2000L)
#'     timeout <- mongo.get.timeout(mongo)
#'     if (timeout != 2000L)
#'         error("expected timeout of 2000");
#' }
#' 
#' @export mongo.get.timeout
mongo.get.timeout <- function(mongo)
    .Call(".mongo.get.timeout", mongo)



#' Determine if a mongo connection object is connected to a master
#' 
#' Determine if a mongo connection object is connected to a master.  Normally,
#' this is only used with replsets to see if we are currently connected to the
#' master of the replset. However, when connected to a singleton, this function
#' reports TRUE also.
#' 
#' 
#' @param mongo (\link{mongo}) a mongo connection object.
#' @return (logical) TRUE if the server reports that it is a master; otherwise,
#' FALSE.
#' @seealso \code{\link{mongo.create}},\cr \link{mongo}.
#' @examples
#' 
#' \dontrun{
#' mongo <- mongo.create(c("127.0.0.1", "192.168.0.3"), name="Accounts")
#' if (mongo.is.connected(mongo)) {
#'     print("isMaster")
#'     print(if (mongo.is.master(mongo)) "Yes" else "No")
#' }
#' }
#' 
#' @export mongo.is.master
mongo.is.master <- function(mongo)
    .Call(".mongo.is.master", mongo)



#' Autherticate a user and password
#' 
#' Autherticate a user and password against a given database on a MongoDB
#' server.
#' 
#' See \url{http://www.mongodb.org/display/DOCS/Security+and+Authentication}.
#' 
#' Note that \code{\link{mongo.create}()} can authenticate a username and
#' password before returning a connected mongo object.
#' 
#' 
#' @param mongo (\link{mongo}) a mongo connection object.
#' @param username (string) username to authenticate.
#' @param password (string) password corresponding to username.
#' @param db (string) The database on the server against which to validate the
#' username and password.
#' @seealso \code{\link{mongo.add.user}},\cr
#' \code{\link{mongo.create}}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo))
#'     mongo.authenticate(mongo, "Joe", "ZxYaBc217")
#' 
#' @export mongo.authenticate
mongo.authenticate <- function(mongo, username, password, db="admin")
    .Call(".mongo.authenticate", mongo, username, password, db)



#' Add a user and password
#' 
#' Add a user and password to the given database on a MongoDB server for
#' authentication purposes.
#' 
#' See \url{http://www.mongodb.org/display/DOCS/Security+and+Authentication}.
#' 
#' 
#' @param mongo (\link{mongo}) a mongo connection object.
#' @param username (string) username to add.
#' @param password (string) password corresponding to username.
#' @param db (string) The database on the server to which to add the username
#' and password.
#' @seealso \code{\link{mongo.authenticate}},\cr \link{mongo},\cr
#' \code{\link{mongo.create}}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo))
#'     mongo.add.user(mongo, "Jeff", "H87b5dog")
#' 
#' @export mongo.add.user
mongo.add.user <- function(mongo, username, password, db="admin")
    .Call(".mongo.add.user", mongo, username, password, db)



#' Retrieve an server error code from a mongo connection object
#' 
#' Retrieve an server error record from a the MongoDB server.  This describes
#' the last error that occurs while accessing the give database. While this
#' function retrieves an error record in the form of a mongo.bson record, it
#' also sets the values returned by \code{\link{mongo.get.server.err}()} and
#' \code{\link{mongo.get.server.err.string}()}. You may find it more convenient
#' using those after calling \code{mongo.get.last.err()} rather than unpacking
#' the returned mongo.bson object.
#' 
#' 
#' @param mongo (\link{mongo}) a mongo connection object.
#' @param db (string) The name of the database for which to get the error
#' status.
#' @return NULL if no error was reported; otherwise,
#' 
#' (\link{mongo.bson}) This BSON object has the form { err : "\emph{error
#' message string}", code : \emph{error code integer} }
#' @seealso \code{\link{mongo.get.server.err}},\cr
#' \code{\link{mongo.get.server.err.string}},\cr
#' \code{\link{mongo.get.prev.err}}\cr \link{mongo}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#' 
#'     # try adding a duplicate record when index doesn't allow this
#' 
#'     db <- "test"
#'     ns <- "test.people"
#'     mongo.index.create(mongo, ns, "name", mongo.index.unique)
#' 
#'     buf <- mongo.bson.buffer.create()
#'     mongo.bson.buffer.append(buf, "name", "John")
#'     mongo.bson.buffer.append(buf, "age", 22L)
#'     b <- mongo.bson.from.buffer(buf)
#'     mongo.insert(mongo, ns, b);
#' 
#'     buf <- mongo.bson.buffer.create()
#'     mongo.bson.buffer.append(buf, "name", "John")
#'     mongo.bson.buffer.append(buf, "age", 27L)
#'     b <- mongo.bson.from.buffer(buf)
#'     mongo.insert(mongo, ns, b);
#' 
#'     err <- mongo.get.last.err(mongo, db)
#'     print(mongo.get.server.err(mongo))
#'     print(mongo.get.server.err.string(mongo))
#' }
#' 
#' @export mongo.get.last.err
mongo.get.last.err <- function(mongo, db)
    .Call(".mongo.get.last.err", mongo, db)



#' Retrieve an server error code from a mongo connection object
#' 
#' Retrieve the previous server error record from a the MongoDB server.  While
#' this function retrieves an error record in the form of a mongo.bson record,
#' it also sets the values returned by \code{\link{mongo.get.server.err}()} and
#' \code{\link{mongo.get.server.err.string}()}. You may find it more convenient
#' using those after calling \code{mongo.get.prev.err()} rather than unpacking
#' the returned mongo.bson object.
#' 
#' 
#' @param mongo (\link{mongo}) a mongo connection object.
#' @param db (string) The name of the database for which to get the error
#' status.
#' @return NULL if no error was reported; otherwise,
#' 
#' (\link{mongo.bson}) This BSON object has the form { err : "\emph{error
#' message string}", code : \emph{error code integer} }
#' @seealso \code{\link{mongo.get.server.err}},\cr
#' \code{\link{mongo.get.server.err.string}},\cr
#' \code{\link{mongo.get.last.err}}\cr \link{mongo}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#' 
#'     # try adding a duplicate record when index doesn't allow this
#' 
#'     db <- "test"
#'     ns <- "test.people"
#'     mongo.index.create(mongo, ns, "name", mongo.index.unique)
#' 
#'     buf <- mongo.bson.buffer.create()
#'     mongo.bson.buffer.append(buf, "name", "John")
#'     mongo.bson.buffer.append(buf, "age", 22L)
#'     b <- mongo.bson.from.buffer(buf)
#'     mongo.insert(mongo, ns, b);
#' 
#'     buf <- mongo.bson.buffer.create()
#'     mongo.bson.buffer.append(buf, "name", "John")
#'     mongo.bson.buffer.append(buf, "age", 27L)
#'     b <- mongo.bson.from.buffer(buf)
#'     mongo.insert(mongo, ns, b);
#' 
#'     # try insert again
#'     mongo.insert(mongo, ns, b);
#' 
#'     err <- mongo.get.prev.err(mongo, db)
#'     print(mongo.get.server.err(mongo))
#'     print(mongo.get.server.err.string(mongo))
#' }
#' 
#' @export mongo.get.prev.err
mongo.get.prev.err <- function(mongo, db)
    .Call(".mongo.get.prev.err", mongo, db)



#' Retrieve an server error code from a mongo connection object
#' 
#' Send a "reset error" command to the server, it also resets the values
#' returned by\cr \code{\link{mongo.get.server.err}()} and
#' \code{\link{mongo.get.server.err.string}()}.
#' 
#' 
#' @param mongo (\link{mongo}) a mongo connection object.
#' @param db (string) The name of the database on which to reset the error
#' status.
#' @return NULL
#' @seealso \code{\link{mongo.get.server.err}},\cr
#' \code{\link{mongo.get.server.err.string}},\cr
#' \code{\link{mongo.get.last.err}},\cr \code{\link{mongo.get.prev.err}},\cr
#' \link{mongo}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#' 
#'     # try adding a duplicate record when index doesn't allow this
#' 
#'     db <- "test"
#'     ns <- "test.people"
#'     mongo.index.create(mongo, ns, "name", mongo.index.unique)
#' 
#'     buf <- mongo.bson.buffer.create()
#'     mongo.bson.buffer.append(buf, "name", "John")
#'     mongo.bson.buffer.append(buf, "age", 22L)
#'     b <- mongo.bson.from.buffer(buf)
#'     mongo.insert(mongo, ns, b);
#' 
#'     buf <- mongo.bson.buffer.create()
#'     mongo.bson.buffer.append(buf, "name", "John")
#'     mongo.bson.buffer.append(buf, "age", 27L)
#'     b <- mongo.bson.from.buffer(buf)
#'     mongo.insert(mongo, ns, b);
#' 
#'     err <- mongo.get.last.err(mongo, db)
#'     print(mongo.get.server.err(mongo))
#'     print(mongo.get.server.err.string(mongo))
#'     mongo.reset.err(mongo, db)
#' }
#' 
#' @export mongo.reset.err
mongo.reset.err <- function(mongo, db)
    .Call(".mongo.reset.err", mongo, db)



#' Retrieve an server error code from a mongo connection object
#' 
#' Retrieve an server error code from a mongo connection object.
#' 
#' \code{\link{mongo.find}()}, \code{\link{mongo.find.one}()},
#' \code{\link{mongo.index.create}()} set or clear this error code depending on
#' whether they are successful or not.
#' 
#' \code{\link{mongo.get.last.err}()} and \code{\link{mongo.get.prev.err}()}
#' both set or clear this error code according to what the server reports.
#' 
#' 
#' @param mongo (\link{mongo}) a mongo connection object.
#' @return (integer) Server error code
#' @seealso \code{\link{mongo.get.server.err.string}},\cr
#' \code{\link{mongo.get.last.err}},\cr \code{\link{mongo.get.prev.err}},\cr
#' \code{\link{mongo.find}},\cr \code{\link{mongo.find.one}},\cr
#' \code{\link{mongo.index.create}},\cr \link{mongo}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     # construct a query containing invalid operator
#'     buf <- mongo.bson.buffer.create()
#'     mongo.bson.buffer.start.object(buf, "age")
#'     mongo.bson.buffer.append(buf, "$bad", 1L)
#'     mongo.bson.buffer.finish.object(buf)
#'     query <- mongo.bson.from.buffer(buf)
#' 
#'     result <- mongo.find.one(mongo, "test.people", query)
#'     if (is.null(result)) {
#'         print(mongo.get.server.err.string(mongo))
#'         print(mongo.get.server.err(mongo))
#'     }
#' }
#' 
#' @export mongo.get.server.err
mongo.get.server.err <- function(mongo)
    .Call(".mongo.get.server.err", mongo)



#' Retrieve an server error code from a mongo connection object
#' 
#' Retrieve an server error string from a mongo connection object.
#' 
#' \code{\link{mongo.find}()}, \code{\link{mongo.find.one}()},
#' \code{\link{mongo.index.create}()} set or clear this error string depending
#' on whether they are successful or not.
#' 
#' \code{\link{mongo.get.last.err}()} and \code{\link{mongo.get.prev.err}()}
#' both set or clear this error string according to what the server reports.
#' 
#' 
#' @param mongo (\link{mongo}) a mongo connection object.
#' @return (string) Server error string
#' @seealso \code{\link{mongo.get.server.err}},\cr
#' \code{\link{mongo.get.last.err}},\cr \code{\link{mongo.get.prev.err}},\cr
#' \code{\link{mongo.find}},\cr \code{\link{mongo.find.one}},\cr
#' \code{\link{mongo.index.create}},\cr \link{mongo}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     # construct a query containing invalid operator
#'     buf <- mongo.bson.buffer.create()
#'     mongo.bson.buffer.start.object(buf, "age")
#'     mongo.bson.buffer.append(buf, "$bad", 1L)
#'     mongo.bson.buffer.finish.object(buf)
#'     query <- mongo.bson.from.buffer(buf)
#' 
#'     result <- mongo.find.one(mongo, "test.people", query)
#'     if (is.null(result)) {
#'         print(mongo.get.server.err(mongo))
#'         print(mongo.get.server.err.string(mongo))
#'     }
#' }
#' 
#' @export mongo.get.server.err.string
mongo.get.server.err.string <- function(mongo)
    .Call(".mongo.get.server.err.string", mongo)



#' Issue a command to a database on MongoDB server
#' 
#' Issue a command to a MongoDB server and return the response from the server.
#' 
#' This function supports any of the MongoDB database commands by allowing you
#' to specify the command object completely yourself.
#' 
#' See \url{http://www.mongodb.org/display/DOCS/List+of+Database+Commands}.
#' 
#' 
#' @param mongo (\link{mongo}) A mongo connection object.
#' @param db (string) The name of the database upon which to perform the
#' command.
#' @param command (\link{mongo.bson}) An object describing the command.
#' 
#' Alternately, \code{command} may be a list which will be converted to a
#' mongo.bson object by \code{\link{mongo.bson.from.list}()}.
#' @return NULL if the command failed.  \code{\link{mongo.get.err}()} may be
#' MONGO_COMMAND_FAILED.
#' 
#' (\link{mongo.bson}) The server's response if successful.
#' @seealso \code{\link{mongo.get.err}},\cr
#' \code{\link{mongo.simple.command}},\cr \code{\link{mongo.rename}},\cr
#' \code{\link{mongo.count}},\cr \code{\link{mongo.drop.database}},\cr
#' \code{\link{mongo.drop}},\cr \link{mongo},\cr \link{mongo.bson}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#' 
#'     # alternate method of renaming a collection
#'     buf <- mongo.bson.buffer.create()
#'     mongo.bson.buffer.append(buf, "renameCollection", "test.people")
#'     mongo.bson.buffer.append(buf, "to", "test.humans")
#'     command <- mongo.bson.from.buffer(buf)
#'     mongo.command(mongo, "admin", command)
#' 
#'     # use list notation to rename the collection back
#'     mongo.command(mongo, "admin", 
#'         list(renameCollection="test.humans", to="test.people"))
#' 
#'     # Alternate method of counting people
#'     buf <- mongo.bson.buffer.create()
#'     mongo.bson.buffer.append(buf, "count", "people")
#'     mongo.bson.buffer.append(buf, "query", mongo.bson.empty())
#'     command <- mongo.bson.from.buffer(buf)
#'     result = mongo.command(mongo, "test", command)
#'     if (!is.null(result)) {
#'         iter = mongo.bson.find(result, "n")
#'         print(mongo.bson.iterator.value(iter))
#'     }
#' 
#' }
#' 
#' @export mongo.command
mongo.command <- function(mongo, db, command) {
   if (typeof(command) == "list")
        command <- mongo.bson.from.list(command)
    .Call(".mongo.command", mongo, db, command)
}



#' Issue a simple.command to a database on MongoDB server
#' 
#' Issue a simple command to a MongoDB server and return the response from the
#' server.
#' 
#' This function supports many of the MongoDB database commands by allowing you
#' to specify a simple command object which is entirely specified by the
#' command name and an integer or string argument.
#' 
#' See \url{http://www.mongodb.org/display/DOCS/List+of+Database+Commands}.
#' 
#' 
#' @param mongo (\link{mongo}) A mongo connection object.
#' @param db (string) The name of the database upon which to perform the
#' command.
#' @param cmdstr (string) The name of the command.
#' @param arg An argument to the command, may be a string or numeric
#' (as.integer).
#' @return NULL if the command failed.  Use \code{\link{mongo.get.last.err}()}
#' to determine the cause.
#' 
#' (\link{mongo.bson}) The server's response if successful.
#' @seealso \code{\link{mongo.command}},\cr \code{\link{mongo.rename}},\cr
#' \code{\link{mongo.count}},\cr \code{\link{mongo.drop.database}},\cr
#' \code{\link{mongo.drop}},\cr \link{mongo},\cr \link{mongo.bson}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     print(mongo.simple.command(mongo, "admin", "buildInfo", 1))
#' 
#'     mongo.destroy(mongo)
#' }
#' 
#' @export mongo.simple.command
mongo.simple.command <- function(mongo, db, cmdstr, arg)
    .Call(".mongo.simple.command", mongo, db, cmdstr, arg)



#' Drop a database from a MongoDB server
#' 
#' Drop a database from MongoDB server.  Removes the entire database and all
#' collections in it.
#' 
#' Obviously, care should be taken when using this command.
#' 
#' 
#' @param mongo (\link{mongo}) A mongo connection object.
#' @param db (string) The name of the database to drop.
#' @return (Logical) TRUE if successful; otherwise, FALSE
#' @seealso \code{\link{mongo.drop}},\cr \code{\link{mongo.command}},\cr
#' \code{\link{mongo.rename}},\cr \code{\link{mongo.count}},\cr \link{mongo}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     print(mongo.drop.database(mongo, "test"))
#' 
#'     mongo.destroy(mongo)
#' }
#' 
#' @export mongo.drop.database
mongo.drop.database <- function(mongo, db)
    .Call(".mongo.drop.database", mongo, db)



#' Drop a collection from a MongoDB server
#' 
#' Drop a collection from a database on MongoDB server.  This removes the
#' entire collection.
#' 
#' Obviously, care should be taken when using this command.
#' 
#' 
#' @param mongo (\link{mongo}) A mongo connection object.
#' @param ns (string) The namespace of the collection to drop.
#' @return (Logical) TRUE if successful; otherwise, FALSE
#' @seealso \code{\link{mongo.drop.database}},\cr
#' \code{\link{mongo.command}},\cr \code{\link{mongo.rename}},\cr
#' \code{\link{mongo.count}},\cr \link{mongo}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     print(mongo.drop(mongo, "test.people"))
#' 
#'     mongo.destroy(mongo)
#' }
#' 
#' @export mongo.drop
mongo.drop <- function(mongo, ns)
    .Call(".mongo.drop", mongo, ns)



#' Rename a collection on a MongoDB server
#' 
#' Rename a collection on a MongoDB server.
#' 
#' Note that this may also be used to move a collection from one database to
#' another.
#' 
#' 
#' @param mongo (\link{mongo}) A mongo connection object.
#' @param from.ns (string) The namespace of the collection to rename.
#' @param to.ns (string) The new namespace of the collection.
#' @return TRUE if successful; otherwise, FALSE.
#' @seealso \code{\link{mongo.drop.database}},\cr \code{\link{mongo.drop}},\cr
#' \code{\link{mongo.command}},\cr \code{\link{mongo.count}},\cr \link{mongo}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     print(mongo.rename(mongo, "test.people", "test.humans"))
#' 
#'     mongo.destroy(mongo)
#' }
#' 
#' @export mongo.rename
mongo.rename <- function(mongo, from.ns, to.ns)
    .Call(".mongo.rename", mongo, from.ns, to.ns)



#' Get a list of databases from a MongoDB server
#' 
#' Get a list of databases from a MongoDB server.
#' 
#' 
#' @param mongo (\link{mongo}) A mongo connection object.
#' @return (string vector) List of databases.  Note this will not include the
#' system databases "admin" and "local".
#' @seealso \code{\link{mongo.get.database.collections}},\cr
#' \code{\link{mongo.drop.database}},\cr \code{\link{mongo.command}},\cr
#' \code{\link{mongo.rename}},\cr \link{mongo}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     print(mongo.get.databases(mongo))
#' 
#'     mongo.destroy(mongo)
#' }
#' 
#' @export mongo.get.databases
mongo.get.databases <- function(mongo)
    .Call(".mongo.get.databases", mongo)



#' Get a list of collections in a database
#' 
#' Get a list of collections in a database on a MongoDB server.
#' 
#' 
#' @param mongo (\link{mongo}) A mongo connection object.
#' @param db (string) Name of the database for which to get the list of
#' collections.
#' @return (string vector) List of collection namespaces in the given database.
#' 
#' Note this will not include the system collection \code{db}.system.indexes
#' nor the indexes attached to the database. Use \code{mongo.find(mongo,
#' "db.system.indexes", limit=0L)} for information on any indexes.
#' @seealso \code{\link{mongo.get.databases}},\cr
#' \code{\link{mongo.drop.database}},\cr \code{\link{mongo.drop}},\cr
#' \code{\link{mongo.command}},\cr \code{\link{mongo.rename}},\cr \link{mongo}.
#' @examples
#' 
#' mongo <- mongo.create()
#' if (mongo.is.connected(mongo)) {
#'     print(mongo.get.database.collections(mongo, "test"))
#' 
#'     mongo.destroy(mongo)
#' }
#' 
#' @export mongo.get.database.collections
mongo.get.database.collections <- function(mongo, db)
    .Call(".mongo.get.database.collections", mongo, db)