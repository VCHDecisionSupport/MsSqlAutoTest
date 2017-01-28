TableCompare
======
#Source Control
Pull request approved by someone who didn't develop it.



#TODO
##1. MetaCompare (func/proc)
- As a tester I want to stand-alone function/procedure to compare the structure and other meta features of two tables
    + Will be called by `TestLog.dbo.uspInsTableCompare` to validate and/or determine then return (primary/natural) key column to join the two tables and the column name pairings
    + Will report structural differences between tables to tester

**Input Parameters:** (required for compatibility to existing `TestLog.dbo.uspInsTableCompare`)
    
    @pATableReference varchar(128*4)
    ,@pBTableReference varchar(128*4)

TableReference format: `database.schema.table` or `database.schema.table.keyColumn`

**Outputs:** 
    
    @A_qualified_key varchar(128*4)
    @B_qualified_key varchar(128*4)
    column name pairings *format/type to be determined*
qualified_key format: `database.schema.table.keyColumn`

#Purpose 
To standardize and consolidate the data validation efforts of actute and community.

- Automate the generation, execution, and logging tedious testing queries
    + testing efforts focus on intrepreting and analysing results
- Standardize testing strategies between acute and community
    + develop TSQL based tools to accomplish the union of requirements rather than the intersectino

#Use Cases
Overview of current testing methods
##Validate Type 1 Biz Rule
Compare column values before and after a biz rule is executed and be able to see high level comparison results as well drill down to a sample of records.
###Current Solution
1. Export sample of records into Excel
2. Execute Bizrule
3. Export same records into Excel again
4. Compare two samples to validate behavior of a biz rule

##Validate new data source for existing strucutres
Compare an upstream table to a downstream table.  Counts (natural) key (mis)matches, dim value (mis)matches/nulls/duplicates.

#Backlog
- Use ETLBizRuleAuditFact to validate changes; count proportion of changes accounted for in ETLBizRuleAuditFact
- Save test parameters for future rerunning
- Auto guess PK if not specified
TODO
- Log params to a new table in TestLog database to facilitate a rerunning a past test
    + Create PROC (input KeyComparisonID) to rerun a test
- Infer/store data lineage from MD_Object

