# AutoTest

Automated regression testing for the tables/views affected by an ETL execution.

Automate detection of expected and unexpected changes to content of tables and views by 

- implemented with `AutoTest` database, procedures, functions, temporary snap shot tables, and logging tables [see AutoTest schema](www.nhl.com)
- automatically executed during normal ETL package/job execution [see attachment points section](#attachment-point)
- results summarized by SSRS reports [see Results section](#Results)
- minimal change to existing warehouse structures [see Requirements section](#Requirements)
- configuration mostly automated by seperate SSIS job that parses packages deployed to `msdb` [see Mapping Packages to Tables/Views](#mapping-packages-to-tablesviews)



## Implemenation

Prior to ETL execution snap shots of views/tables are copied to `AutoTest.SnapShot` schema



## Requirements

### Comparison Key
All fact tables have comparison/business key column meta data available from:

    1. `DQMF.dbo.MD_ObjectAttribute.IsBusinessKey` - or
    2. `DQMF.dbo.MD_Object.PKField` - or
    3. physical primary key column
Key column must include source system columns whose values that only change when business attribute(s) change

### Attachment Point
#### Package Level: `SetAuditPackageExecution`
Current implementation of `AutoTest` uses SSIS Packages as attachment points.

- All packages (including child packages) call `SetAuditPackageExecution`
    + this implies requirement that all packages exist in `DQMF.dbo.ETL_Package` (in all instances)

Other potiential attachment point options:

- As automatic DQMF stage?
    + pre/post processing?
- As job step
    + 1 step added at start and end
    + can be done automattically/in-bulk with [`sp_add_job`](https://msdn.microsoft.com/en-us/library/ms182079.aspx) and [`sp_add_jobstep`](https://msdn.microsoft.com/en-ca/library/ms187358.aspx)


### Mapping Packages to Tables/Views

see new table `DQMF.dbo.ETL_PackageObject`
For each package/job a list of tables/views to be tested is required.  This mapping from attachment point to data object is specified by `DQMF.dbo.ETL_PackageObject`.  This table is also populated by a `C#` executable that walks the `msdb` folders and loads each package into memory using [the SSIS object model](https://msdn.microsoft.com/en-us/library/ms136025.aspx) to extract the destination tables of the data flow tasks contained in each package.  A copy of this executable is required on each server; when could then be called on a regular basis using a SSIS package with a ??? task.

# Procedures

## `dbo.uspInitPkgRegressionTest`
__Parameters:__

    @pPkgExecKey int

Called once per package execution from `DQMF.dbo.SetAuditPackageExecution` [see Regression Testing Package At Package Runtime section](#regression-testing-package-at-package-runtime)

## `dbo.uspPkgRegressionTest`

## `dbo.uspCreateSnapShot`
__Parameters:__

    @pQuery varchar(max),
    @pKeyColumns varchar(max) = NULL,
    @pHashKeyColumns varchar(max) = NULL,
    @pDestDatabaseName varchar(100) = 'AutoTest',
    @pDestSchemaName varchar(100) = 'SnapShot',
    @pDestTableName varchar(100)

- utility proc that creates a snap shot of the query
- executes `SELECT` <given query> `INTO` <given destination table>
- merges `@pHashKeyColumns` into single `HASHBYTES` column
- drop destination table if it already exists
- creates indexes on `@pKeyColumns and @pHashKeyColumns`

- `@pQuery` simple query; alias allowed; `WITH`, `GO`, `;`, etc not allowed
- `@pKeyColumns,@pHashKeyColumns` comma delimited list of column names
- `@pDestDatabaseName.@pDestSchemaName.@pDestTableName` is snap shot table



## `dbo.uspCreateProfile`
__Parameters:__

    @pTestConfigID int,
    @pTargetDatabaseName nvarchar(200) = 'AutoTest',
    @pTargetSchemaName nvarchar(200) = 'SnapShot',
    @pTargetTableName nvarchar(200),
    @pTableProfileTypeID int,
    @pColumnProfileTypeID int,
    @pColumnHistogramTypeID int

1. get row count and `INSERT INTO dbo.TableProfile`
2. get distinct count of each column, `UNPIVOT`, then `INSERT INTO dbo.ColumnProfile`
3. cursor on `dbo.ColumnProfile`
    - call `dbo.uspInsColumnHistogram` to `INSERT INTO dbo.ColumnHistogram`

## `dbo.uspDataCompare`

1. create snap shot of tables' intersection: _RecordMatch_
    - call `dbo.uspCreateProfile` with name of _RecordMatch_ snap shot as parameter
2. create snap shot of tables' set difference: on `__pkhash__`: _PreEtl_
    - call `dbo.uspCreateProfile` with name of _PreEtl_ snap shot as parameter


# Regression Testing Package At Package Runtime
`DQMF.dbo.SetAuditPackageExecution` is called at start/end of package

## If `@IsProcessStart=1` 
call [`AutoTest.dbo.uspInitPkgRegressionTest`](#dbouspinitpkgregression) with parameter `@PkgExecKey` 

1. populate `AutoTest.dbo.TestConfig` from `DQMF.dbo.ETL_PackageObject` mapping table for this `PkgID`
2. cursor on `AutoTest.dbo.TestConfig` for this `PkgExecKey`
    - call `uspCreateSnapShot` to create _PreEtl_ snap shot of table with added column: `__pkhash__` in `AutoTest.SnapShot` schema 

## If `@IsProcessStart=0` 
call `uspPkgRegressionTest` with parameter `@PkgExecKey` 

1. cursor on `AutoTest.dbo.TestConfig` for this `PkgExecKey`
    - call `uspCreateSnapShot` to _PostEtl_ create snap shot of table with added column: `__pkhash__` in `AutoTest.SnapShot` schema
    - call `uspDataCompare`

# AutoTest Schema Diagram

![AutoTest_Schema](/Documentation/AutoTest_Schema.jpg?raw=true "AutoTest_Schema")

# References

[Case Study Regression Testing](https://www.researchgate.net/publication/230639909_A_CASE_STUDY_ON_REGRESSION_TEST_AUTOMATION_FOR_DATA_WAREHOUSE_QUALITY_ASSURANCE)

[Regression Test Relational Database](http://www.agiledata.org/essays/databaseTesting.html)

[Wikipedia: Regression Testing](https://en.wikipedia.org/wiki/Regression_testing)