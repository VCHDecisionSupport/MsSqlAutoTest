# Simple Profiles

## User Interface
TODO see issues.

## High level logical flow

1. Package runs as usual at end of package `DQMF.dbo.SetAuditPkgExecution` is called with `@pIsProcessStart = 0`
2. 

- The profiles of each fact table is stored in 3 tables:
    + `???.dbo.TableProfile`
    + `???.dbo.ColumnProfile`
    + `???.dbo.ColumnHistogram`
- The relationship between packages and the fact tables they populate is stored in `Map.PackageTable`
- `Map.PackageTable` is populated C# app: [see SqlServerUtilities](https://github.com/grahamcrowell/SqlServerUtilities)
- The existing `DQMF.dbo.SetAuditPkgExecution` proc is extended to call new proc `???.dbo.uspProfilePackage` when `@pIsProcessStart = 0`
- `???.dbo.uspProfilePackage` calls `???.dbo.uspProfileTable` for each table in `Map.PackageTable` where `PackageName = @pPkgName`
- `???.dbo.uspProfileTable` populates 3 profile tables
    + `???.dbo.TableProfile`
        * `TableProfileDate`
        * `DatabaseName`
        * `SchemaName`
        * `TableName`
        * `RecordCount`
        * `PkgExecKey`
    + `???.dbo.ColumnProfile`
        * `ColumnProfileDate`
        * `DatabaseName`
        * `TableName`
        * `ColumnName`
        * `DistinctCount`
        * `PkgExecKey`
    + `???.dbo.ColumnHistogram`
        * `ColumnHistogramDate`
        * `DatabaseName`
        * `TableName`
        * `ColumnName`
        * `ColumnValue`
        * `ValueCount`
        * `PkgExecKey`

