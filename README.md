# Simple Profiles

## Deployment

#### 1. **Sql Backend**

PowerShell script: `deploy_script.ps1` prompts for server then drops and creates all Sql AutoTest objects.

#### 2. **Update DQMF proc**

ajds 

#### 3. **C\# App (Package-Table Mapper)**

just do it.

## User Interface
TODO see issues.

## High level logical flow

- C\# app is a ran to populate/update `Map.PackageTable` [see SqlServerUtilities](https://github.com/grahamcrowell/SqlServerUtilities)

### At package runtime:

Package runs as usual at end of package `DQMF.dbo.SetAuditPkgExecution` is called with `@pIsProcessStart = 0` and `AutoTest.dbo.uspAutoTestPackage` is called:

1. `AutoTest.dbo.uspProfilePackageTables` is called

For each table in `Map.PackageTable` for this package `AutoTest.dbo.uspProfileTable` is called thereby populating: `AutoTest.dbo.TableProfile`, `AutoTest.dbo.ColumnProfile`, and `AutoTest.dbo.ColumnHistogram` are populated.

2. `AutoTest.dbo.uspUpdateAlerts` is called and `AutoTest.dbo.Alert` table is popualted.

3. `AutoTest.dbo.uspSendAlertEmails` is called

If rows exist in `AutoTest.dbo.Alert` for this package execution single summary email is sent with 

### Procedure list

#### `AutoTest.dbo.uspProfileTable`

For a given table: Profiles a single table and populates profile tables: `AutoTest.dbo.TableProfile`, `AutoTest.dbo.ColumnProfile`, and `AutoTest.dbo.ColumnHistogram`

#### `AutoTest.dbo.uspProfilePackageTables`

For a given package: Calls `AutoTest.dbo.uspProfileTable` for each table in `Map.PackageTable`

#### `AutoTest.dbo.uspUpdateAlerts`

Merge statement is executed to update/insert `AutoTest.dbo.Alert` from profile tables.

#### `AutoTest.dbo.uspSendAlertEmails`

For a given package execution: `AutoTest.dbo.Alert` is queried and if alerts are found an alert email is sent using `msdb.dbo.sp_send_dbmail`

### Table list

#### Profile tables
logging tables that profile results.

+ `AutoTest.dbo.TableProfile` one row per package execution per table per profile execution
+ `AutoTest.dbo.ColumnProfile` one row per column of a table profiled
+ `AutoTest.dbo.ColumnHistogram` one row per column value of a table profiled

#### Control tables

+ `AutoTest.dbo.Alert` controls content of alert emails.  one row per alerted violation.  a violation can be in terms of a profiled table, column or a column value.
+ `Map.PackageTable` one row per table in a package data flow task.  indirectly controls which tables are profiled at runtime (see `AutoTest.dbo.vwPackageProfileTable`).
+ `AutoTest.dbo.vwPackageProfileTable` controls which tables are profiled at package runtime.  queries `Map.PackageTable`.  one row per table per table to be profiled.

### Changes to existing package runtime

- The existing `DQMF.dbo.SetAuditPkgExecution` proc is extended to call new proc `AutoTest.dbo.uspProfilePackage` when `@pIsProcessStart = 0`

- `AutoTest.dbo.uspProfileTable` populates 3 profile tables
    + `AutoTest.dbo.TableProfile`
        * `TableProfileDate`
        * `DatabaseName`
        * `SchemaName`
        * `TableName`
        * `RecordCount`
        * `PkgExecKey`
    + `AutoTest.dbo.ColumnProfile`
        * `ColumnProfileDate`
        * `DatabaseName`
        * `TableName`
        * `ColumnName`
        * `DistinctCount`
        * `PkgExecKey`
    + `AutoTest.dbo.ColumnHistogram`
        * `ColumnHistogramDate`
        * `DatabaseName`
        * `TableName`
        * `ColumnName`
        * `ColumnValue`
        * `ValueCount`
        * `PkgExecKey`

