To specify a comparison:
- 2 tables
- 2 primary keys
- 2 sets of column pairs that will be compared

User gives two `varchar` parameters $A$ and $B$ that specify two datasets that will compared.

If $A$ has form `db.schema.table.primaryKey` then
- data set is `SELECT * FROM db.schema.table`
- primary key is `db.schema.table.primaryKey`
- comparison columns are all columns in table

If $A$ is a query form `db.schema.table` then
- data set is `SELECT * FROM db.schema.table`
- primary key is `db.schema.table.primaryKey`
- comparison columns are all columns in table


A: (`'db.schema.table.primaryKey'`





