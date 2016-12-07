1. with MD_Object CROSS JOIN all testable dsdw tables (schema not dim or staging tables) (248 entries in PROD) with all staging tables (object type = table, schema = table) ON their respective columns (510 entries in PROD)
    - 9 dsdw testable tables don't have Staging tables (look to be temporary unused tables - they are ignored) so 239 entries
3. for each testable take stage table with most columns in common
4. for each staging table search for a lookup bizrule 
    - assign Pkg associated with bizrule to table (231/239 testable tables have bizrules)
    - 126 active packages in ETL_Package 92 join to schedule, bizrule tables, all of these 92 packages have a lookup bizrule 
5. for 




