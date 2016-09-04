# AutoTest

Automatic or ad-hoc profiles and comparisons of SQL views and tables.  Results are saved in `AutoTest` database and visualized with several linked SSRS reports.  Reports provide a single navigateable source of truth for all team members to quickly understand current data profiles as well as where and when those profiles changed.

## Profile or Compare Data

### Profile

- total row count, distinct column count, and column value histogram
- results saved in for future reference
- SSRS **Data Profile Report** presents visual summary with ability to drill down to column value histograms
- single `proc` call to bulk profile by database, schema, or table/view on a schedule or ad-hoc basis

## Compare

### ETL Regression Testing
- profile new, deleted, changed, and unchanged records

### Ad-Hoc Data Diffs
- profile records unique 
- ETL Regression Testing
    + Diffs Pre-Etl snap shot to Post-Etl snap shot
    + SSRS **Regression Test Reports** support testers by summarizing which columns in which tables/views changed and by how much
    + Logging provides single source of truth
- Data Profiles
    + Table/view row counts, column distinct counts, and column histograms 
    + SSRS **Data Profile Reports** inform report specs and mart design by visualizing data profiles

## Automated and Ad-Hoc

