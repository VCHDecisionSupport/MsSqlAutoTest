# notation

Let $\mathbb{T}$ be the table space.
Let $\mathbb{C}$ be the column space.
**Let $\mathbb{S}$ be the data point space.**
Let $\mathbb{I}$ be the column name/index space.
Let $\mathbb{N}$ be the natural numbers.

Let $A$ and $B$ be tables with $n$ columns $A_i:i=(1,2,\ldots,n)$ and key columns $A_\text{k}$ where $k\in\mathbb{I}$.

## operations
If $A$, $B$, and $X$ are tables, $i\in\mathbb{I}$ is a column index, $n\in\mathbb{N}$ is a non-negative integer then, $x$ is a singleton data value, $r$ is a data record/row

- $|A|\to\mathbb{N}$: denotes the row/record count of $A$
	+ $|A,A_i=x|$: denotes a conditional row count; row/record count of $A$  where column $A_i$ has value $x\in\mathbb{S}$
- $A^\prime$: denotes data table of $A$'s distinct records/rows
- $A_i^\prime$: denotes data column of $A_i$'s distinct values
- $|A^\prime|=n$ where $n\in\mathbb{N}$: denotes distinct count
- $[A,B]=X$ where $X\in\mathbb{T}$: denotes record match data table 
- $(A,B)=X$ where $X\in\mathbb{T}$: denotes key match data table:  where $X\subseteq A$ and $X\in\mathbb{T}$
- $A\backslash B = \\{r\in A | r\notin B\\}$: denotes record difference

# data table profile
If $A$ is a data table with key $A_\text{k}$ then a profile of $A$ consists of:

- $|A|$ row count
- for each column/attribute $i$ of $A$
    a. $|A,A_i=x|$ for $x=$`NULL`, `0`, `''`
    b. $|A_i^\prime|$
    * for each distinct value $x\in A_i^\prime$
        a. $|A,A_i=x|$

# derived data tables implied by regression
The regression of a table over an ETL execution from snapshot $A$ (previous/old/pre-ETL version of table's data) to $B$ (new/post-ETL version of table's data) implies 5 derived data tables:

1. $[A,B]$: unchanged records; records not changed by ETL execution; 
    - __record intersection__
2. $(A,B)\backslash[A,B]$: pre-ETL version of changed records; 
    - __key intersection, record difference in $A$__
3. $(B,A)\backslash[A,B]$: post-ETL version of changed records;
    - __key intersection, record difference in $B$__
4. $A\backslash(A,B)$: net lost records; records deleted/orphaned by ETL execution; $A$ key values don't exist in $B$;
    - __key difference in $A$__
5. $B\backslash(B,A)$: net new records; records created by ETL execution; $B$ key values don't exist in $A$;
    - __key difference in $B$__

# column histogram drill down
If $A$ and $B$ are tables with a non-key column $i$ then the regression value histogram specifies the following calculations for each value $v$

__Key MisMatch:__ If $X=A\backslash(A,B)$ then $|X,X_i=v|$ is the _key difference count_ of $v$ in $A$.
__Key Match Value MisMatch:__ If $X=(A,B)\backslash[A,B]$, $Y=(B,A)\backslash[A,B]$, and $Z=\\{z\in X:X_i=v \wedge Y_i\neq v\\}$ then $|Z|$ is the _key intersection, value difference count_ of $v$ in $A$.
__Key Match Value Match:__ If $X=(A,B)\backslash[A,B]$, $Y=(B,A)\backslash[A,B]$, and $Z=\\{z\in X:X_i=v \wedge Y_i=v\\}$ then $|Z|$ is the _key+value intersection count_ of $v$ in $A$ and $B$ (it is logical to visualize $|Z|$ near $|[A,B]|$ since $|Z|+|[A,B]|$ is the total number of records in $A$ and $B$ with value $v$).

These imply 6 summarizing values for each value in each column.

# profile of derived data tables
The an automated regression test from $A$ to be $B$ consists of computing, storing, and presenting profiles on the 5 derived data tables described above.

# implimentation

All packages call the `DQMF.dbo.SetAuditPkgExecution` procedure at the beginning and end of their execution typically as a _Execute SQL Task_ named "Get BatchID" and "Set DQMF Batch End/Failure" respectively.  When called at the beginning of a package `DQMF.dbo.SetAuditPkgExecution` inserts a new row into `DQMF.dbo.AuditPkgExecution` and sets a SSIS variable, typically named "BatchID", to the value of inserted identity column `DQMF.dbo.AuditPkgExecution.PkgExecKey`.  When called at the end of a package `DQMF.dbo.SetAuditPkgExecution` updates columns `DQMF.dbo.AuditPkgExecution.ExecStopDT` and `DQMF.dbo.AuditPkgExecution.IsPackageSuccessful`.  

Since `DQMF.dbo.SetAuditPkgExecution` is a self-contained entry point to the start and end of every package's runtime it was chosen to **for development**???

## Utility Procs

### `TestLog.dbo.CreateSnapShot`

### `TestLog.dbo.CreateTableProfile`
1. `INSERT` `TableProfile` (all columns)
    1. `EXEC` `TestLog.dbo.CreateColumnProfile`
    2. `CURSOR` over `DQMF.dbo.MD_ObjectAttribute` for this `ObjectID`
        1. `INSERT` `ColumnProfile` (all columns)
        2. `EXEC` `TestLog.dbo.CreateColumnHistogram` for this `ColumnID`
            * `CURSOR` over `ColumnProfile` for this `ObjectID WHERE DistinctCount < ???` 
                1. `INSERT` `ColumnProfile` (all columns)

## foo

### Package begins execution: calls `DQMF.dbo.SetAuditPkgExecution`
1. `PkgExecKey` set to a variable
2. `QUERY` `DataRequestConfig` to identify tables that need to be snapshot for this package
    1. `INSERT` one `TestConfig` row per table
        - `TestConfigID`
        - `DataRequestConfigID`
        - `PkgID`
        - `ObjectID`
        - `PkgExecKey`
        - `TestTypeDesc` (Profile or Regression)
3. `CURSOR` over `TestConfig` for this `PkgExecKey`
    - `SET @pDatabaseName, @pSchemaName, @pTableName, @pSnapShotName`
    1. `EXEC` `TestLog.dbo.CreateSnapShot`
    2. `UPDATE` `TestConfig.PreEtlSnapShotDate`
    3. `EXEC` `TestLog.CreateTableProfile`
        
4. Package continues normal execution

### Package ends: calls `DQMF.dbo.SetAuditPkgExecution`
1. `CURSOR` over `TestConfig` for this `PkgExecKey`
    - `SET @pDatabaseName, @pSchemaName, @pTableName, @pPreSnapShotName, @pPostSnapShotName`
    1. `EXEC` `TestLog.dbo.CreateSnapShot`
    2. `UPDATE` `TestConfig.PostEtlSnapShotDate`
    3. `EXEC` `TestLog.CreateTableProfile`
        1. `INSERT` `TableProfile` (all columns)
        3. `EXEC` `TestLog.dbo.CreateColumnProfile`
            + `CURSOR` over `DQMF.dbo.MD_ObjectAttribute` for this `ObjectID`
                1. `INSERT` `ColumnProfile` (all columns)
                2. `EXEC` `TestLog.dbo.CreateColumnHistogram` for this `ColumnID`
                    + `CURSOR` over `ColumnProfile` for this `ObjectID WHERE DistinctCount < ???` 
                        1. `INSERT` `ColumnProfile` (all columns)
    4. `EXEC` `TestLog.CreateRegressionViews`
    


# the algorithm

`QUERY` $|A|$ and $|B|$, WLOG let $|A|\leq|B|$

If $|A|=0$ or $|B|=0$ then `EXIT`

`QUERY` $[A,B]\_\text{k}$

If $|[A,B]\_\text{k}|=|A|$ then `EXIT` or `Profile` $B-[A,B]$ __record set difference__.  This indicates that $A$ is a proper _record_ subset of $B$: every record in $A$ exists and matches with a record in $B$.  

non empty data sets:
- $[A,B]$
- $B-[A,B]$


Potiential explanations:

- $B$ is more complete or up to date that $A$
- $B$ has duplicates. 

Next Steps:

- Check if $B$ has duplicates
- Profile $B-[A,B]$

`QUERY`  $(A,B)_\text{k}$

If $|(A,B)\_\text{k}|=|A|$ then `EXIT` or `Compare` $[A,B]-(A,B)$ to $[A,B]-(B,A)$ __key intersection__ and/or `Profile` $B-[A,B]$ __record set difference__.  This indicates that $A$ is a proper _key_ subset of $B$: every key in $A$ exists in $B$ but 1 or more columns do not match.

data sets:

- $[A,B]$
- $A-[B,A]$
- $B-[A,B]-(B,A)$
- $A-[B,A]-(A,B)=\emptyset$

next steps:

- Column Comparisons $(A,B)$ and $(B,A)$

If $|(A,B)_\text{k}|\neq|A|$

data sets

$A-(A,B)$ rows in $A$ that don't join to $B$
$B-(B,A)$ rows in $B$ that don't join to $A$



