# Automated Dim Demotion

## Purpose:
Allow views, cub to reduce join complexity and improve query performance. cross-fact joins.  


# Definitions:
Assume each fact table column can be categorized as:

1. Candidate Key: Any column whose distinct count equals the table's row count
2. Natural Key: One or more columns who together
3. Surrogate Key
4. Foreign Key referencing a Dim
4. Foreign Key referencing a Fact
3. Fact column

Using these definitions we categorize fact tables.