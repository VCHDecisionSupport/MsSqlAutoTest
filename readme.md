# Cube Unit Test
PowerShell module for parameterized unit testing of SSAS tabular and multidimension cubes.

## 1. Install `CubeUnitTest` Module

## 2. Unit test walk through
__Example:__ Unit test of ED Visit Cube

### a.) Choose measure and 2 dimensions

__Example:__ Unit test of ED Visit Cube (server database name: `EDMartCube`, cube/perspective: `Emergency`) on SSAS server: `STDSDB004` against SQL server: `STDBDECSUP02`

- __Measure:__ `Count - Cases` by
- __Parameters:__ 
    - `Chief Complaint System`, 
    - `Start Date Fiscal Year`

### b.) Write Sql Test Script

- script returns 3 columns (column names must be exact match to cube names)
    + Measure (ie. `AS [Count - Cases]`)
    + Dim1 (ie. `AS [Start Date Fiscal Year]`)
    + Dim2 (ie. `AS [Chief Complaint System]`)
- Use fully qualified tables names (ie. `DatabaseName.SchemaName.TableName`)
- No `GO` statements
- script filename must follow strict naming convention
    + __Sql Server Name--Ssas Database Name--Measure Name--Dim1 Name--Dim2 Name.sql__
    + eg. __STDSDB004--EDMartCube--Count - Cases--Start Date Fiscal Year--Chief Complaint System.sql__

# Components

## Sql source of truth

Sql script is executed on server specified by PowerShell `-TestSqlServerName` parameter.

## PowerShell run time

## Mdx cube query diffd against Sql fact table query