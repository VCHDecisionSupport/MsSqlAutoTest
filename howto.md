# Ad-Hoc Data Comparisons with AutoTest

__Compare two objects that already exist (table or view)__

## How To:

1. `EXEC`ute stored proc: `AutoTest.dbo.uspAdHocDataCompare`
2. goto [Comparison Results Report (SSRS)](www.google.com) to see results.


## `AutoTest.dbo.uspAdHocDataCompare` usage:
	
	EXEC AutoTest.dbo.uspAdHocDataCompare  
		@pPreEtlDatabaseName
		,@pPreEtlSchemaName
		,@pPreEtlTableName
		,@pPostEtlDatabaseName
		,@pPostEtlSchemaName
		,@pPostEtlTableName
		,@pObjectPkColumns

## Example
Let `CCRSMart.dbo.MedicationFact` be a table and `CCRSMart.dbo.vwMedicationFact` be a view with key column (not nessisarly primary key or indexed) `MedicationKey`.

