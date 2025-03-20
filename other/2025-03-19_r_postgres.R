library(DBI)
library(RPostgres)
library(rstudioapi)
con <- dbConnect(Postgres(), 
                 host='localhost', 
                 port=askForSecret("port(e.g. 5432)"), 
                 dbname=askForSecret("database name"), 
                 user='postgres', 
                 password = rstudioapi::askForSecret("password"))
db_tables <- dbListTables(con)
sprintf("The database has %d tables.", length(db_tables)) # "The database has 15 tables."
sprintf("The first table is `%s`.", db_tables[1]) # "The first table is `age`."
dbReadTable(con, "age")

query_1 <- dbSendQuery(con, "SELECT * FROM supervisor") # write a query
dbFetch(query_1) # `dbFetch` to show results
dbClearResult(query_1) # clear before running more queries

dbDisconnect(con) # disconnect and exit

