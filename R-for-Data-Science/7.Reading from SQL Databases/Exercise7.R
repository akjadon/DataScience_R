# Exercise 7.1
library(RODBC)
connStr <- paste(
  "Server=msedxeus.database.windows.net",
  "Database=DAT209x01",
  "uid=Rlogin",
  "pwd=P@ssw0rd",
  "Driver={SQL Server}",
  sep=";"
)
conn<-odbcDriverConnect(connStr)

sqlColumns(conn,"bi.salesFact")[c("COLUMN_NAME","TYPE_NAME")]
sqlColumns(conn,"bi.sentiment")[c("COLUMN_NAME","TYPE_NAME")]
sqlQuery(conn,"SELECT COUNT(*) FROM bi.sentiment")

close(conn)
# Exercise 7.2
library(RODBC)
connStr <- paste(
  "Server=msedxeus.database.windows.net",
  "Database=DAT209x01",
  "uid=Rlogin",
  "pwd=P@ssw0rd",
  "Driver={SQL Server}",
  sep=";"
)
conn<-odbcDriverConnect(connStr)
my.data.frame<- sqlQuery(conn,
                         "SELECT AVG(Score),Date
                         FROM bi.sentiment
                         WHERE State='WA'
                         GROUP BY Date")
names(my.data.frame)<-c("Average Score","Date")
my.data.frame

close(conn)

