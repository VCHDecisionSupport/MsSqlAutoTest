# AutoTest

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
    a. call `dbo.uspInsColumnHistogram` to `INSERT INTO dbo.ColumnHistogram`

## `dbo.uspDataCompare`

1. create snap shot of tables' intersection: _RecordMatch_
    - call `dbo.uspCreateProfile` with name of _RecordMatch_ snap shot as parameter
2. create snap shot of tables' set difference: on `__pkhash__`: _PreEtl_
    - call `dbo.uspCreateProfile` with name of _PreEtl_ snap shot as parameter


# Regression Testing Package At Package Runtime
`DQMF.dbo.SetAuditPackageExecution` is called at start/end of package

## If `@IsProcessStart=1` 
call `AutoTest.dbo.uspInitPkgRegressionTest` with parameter `@PkgExecKey` 

1. populate `AutoTest.dbo.TestConfig` from `AutoTest.dbo.TestConfig`
2. cursor on `AutoTest.dbo.TestConfig` for this `PkgExecKey`
    - call `uspCreateSnapShot` to _PreEtl_ create snap shot of table with new column: `__pkhash__` in `AutoTest.SnapShot` schema 

## If `@IsProcessStart=0` 
call `uspPkgRegressionTest` with parameter `@PkgExecKey` 

1. populate `AutoTest.dbo.TestConfig` from `AutoTest.dbo.TestConfig`
2. cursor on `AutoTest.dbo.TestConfig` for this `PkgExecKey`
    - call `uspCreateSnapShot` to _PostEtl_ create snap shot of table with new column: `__pkhash__` in `AutoTest.SnapShot` schema
    - call `uspDataCompare`

<!-- 


        call `uspGetKey` to get key columns: look in:
            a. `DQMF.dbo.MD_ObjectAttribute.IsBusinessKey` sdfs
            a. `DQMF.dbo.MD_ObjectAttribute.IsBusinessKey` as
            b. 1;lkj
        2. dsaf
    B. sdfs 



 -->