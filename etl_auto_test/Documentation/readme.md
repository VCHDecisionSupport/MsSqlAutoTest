# testing utility
- standardize and streamline testing
- standardize logging of test results
- record level comparison between servers

## Shared TODO:
- user interface to define/input Dataset
- database structure to save Dataset definitions

## Profile TODO:
- algorithm to profile a dataset

## Comparison TODO:
- user interface to preview a comparison
- algorithm compare 2 Datasets
- database structure to save output of a comparison
- algorithm to identitify signifigant differences between datasets
- user interface to summarize sigigant differences

# Data Comparison Use Case

Determine degree of similarity between 2 tables
- count of rows in each table
	+ 
- count of record matches
- count of key matches
-  


# Main Sql Procedures

## `uspProfile`
Tester granted permission to each server.  Main user interface for one table profiles.  Arguments control worker procs will be called.
InsDataSet, InsUserDescription
- `@pServer`
Default is current. The server with the DataSet to be profiled.
- `@pTable`
The table to be profiled.  Tester's specify with this or `@pQuery`
- `@pQuery`
The a query that wrapped in create view.  The content returned by this query is DataSet to be profiled.  Tester's specify with this or `@pTable`
- `@pProfileAllColumns`
Default. Flag indicating if all columns will be profiled.  This is ignored when `@pProfileColumns` is specified.
- `@pProfileColumns`
Csv list.  Call uspColumnProfile
- `@pHistogramColumns`
Csv list.  Call uspValueHistogram

### `uspTableProfile`
Inserts into DataSet, TableProfile

### `uspColumnProfile`
Inserts into DataSetColumn, ColumnProfile

### `uspValueHistogram`
Inserts into DatasetValue, ValueHistogram


## `uspCompare`
Tester granted permission to each server.

- ServerA
- TableA
- KeyColumnsA
- ServerB
- TableB
- KeyColumnsB

Inserts into DataSetComparison, 


### `uspTableCompare`


### `uspColumnCompare`

### `uspValueCompare`

# Utilities Procedures

## uspInsDataSet
Tester granted permission to each server.  Allows tester to define and save a query as a DataSet.  

## uspMetaCompare
Tester granted permission to each server.  Compare structure of two DataSets.

## uspCopyTable
Copy source table structure and data to temporary table.  Throw exception if row count too 

## uspInsDataSet
Tester granted permission to each server.


# Summary views





# User Interface 


## Proc prompted summaries

Server, Table, 
## SSRS Profile Regression
Question: Where are servers different?

Answer: Compare most recent profile execution for each server.

Prod, profile age, row count

Beta, profile age, row count

Test, profile age, row count

Column, Prod row count, Beta row count, Test row count, Prod null count, Beta null count, Test null count (order by sum or % differences)
Column, Value, Prod row count, Beta row count, Test row count, Prod null count, Beta null count, Test null count (order by sum or % differences)



Most recent profile execution for each server; last 5 executions for same server;
Date, Server, Table, row count, row count difference to (%), null count, null count difference (%)
Column, Date, Server, Table, row count, row count difference (%), null count, null count difference (%)
- where do 

Server, Date, Table, Row count, row count difference (%), null count, null count difference (%)
Profile, comparison regression test.