# VCH-DS-DEV
Documentation for DS and eCN cubes, DQMF, SSRS, and SSIS

    We the willing; lead by the unknowing; 
    are doing the impossible for the ungrateful;
    we have done so much;
    for so long;
    we are now qualified to anything;
    with nothing.

## DQMF

## Cubes

### Tabular Cube Dev Walk Through

- Create DR in Access 
- In __Vault__, find "Cube/Tabular" folder then "get latest version" then "explore working copy" (this is the where the new tabular report will be saved) 
- Open Visual Studio and create __new tabular project__ called "BirthCube" (uncheck "create directory for solution") 
    - File -> New -> Business Intelligence -> Analysis Services -> Analysis Services Tablelar Project 
- In Visual Studio, __rename "Model.bim"__ file to "BirthModel.bim" from Solution Explorer 
    - CTRL + ALT + L to open Solution Explorer 
- In Visual Studio, __add role__ "read" with Read permission and add VCH and VRHB domain user groups to this role 
    - Model -> Roles (to add a new role to cube) 
     - -> Members -> Add... -> Object Types... -> check Groups 
     - -> in Enter the object names to select type "VCH\domain users" and "VRHB\domain users" -> OK 
- In Visual Studio, change project __Processing Option__ to Full 
    - CTRL + ALT + L to open Solution Explorer 
- In Visual Studio, __change Deployment Server__ to STDSDB004\tabular (dba's will change this as needed when DR is released) 
    - CTRL + ALT + L to open Solution Explorer 
- Open SSMS and __develop an import query__ for the main fact table your cube will report on 
    - Calculated age group column using ufnDateDiff 
        "- MotherAgeID" 
    - Add FiscalID column(s) 
        - Join to fact DateID columns to Dim.Date and alias FiscalPeriodEndDateID as "BirthFiscalID" in output 
    - Join to FiscalID columns ufnFiscalCutoff to get cutoff date cuts 
        - StartDateID, and EndDateID 
    - Other foreign key ID columns from spec 
        - Avoid varchar columns 
    - Null values will be shown as blank in Pivot Table slicers, Filters etc 
- __Save script__ as "Birth.sql" in local tabular project directory with the other SSAS files (keep this up to date with any changes to actual query used in Tabular model)
    + Best Practice: dev import query in SSMS not Visual Studio
- In Visual Studio, create new __data source connection__ to STDBDECSUP02 called "connection" 
    - Model -> "Import From Data Source..." 
    - See Import data from database section 
- Add __main fact query__ to model with Friendly Query Name "Birth" 
    - Model -> Existing Connections... -> Open -> Write a query that will specify the data to import 
    - See  add table 
- Add __dim date__ to model with Friendly Name Query Name "Fiscal Date" or "Calendar Date" 
    - Model -> Existing Connections... -> Open -> Select from a list of tables and views to choose what data to import 
        - check vwFiscalDate 
        - Change Friendly Name to "Fiscal Date" 
        - Add filter on CompleteFiscalYears column 
            - -> Preview and Filter -> CompleteFiscalYears -> Number Filters -> Less than or equal to -> 3 
        - -> Preview and Filter -> uncheck all columns not used in report 
    - Write a query that will specify the data to import 
    - Use Dim.vwFiscalDate or Dim.vwCalendarDate with WHERE clause on CompleteFiscalYears column 
        - eg WHERE CompleteFiscalYears <= 3 
- Add __other dim tables__ to model  
    - Model -> Existing Connections... -> Open -> Select from a list of tables and views to choose what data to import 
    - For dim table: 
        - check table (leave Friendly name as is) 
        - -> Preview and Filter -> uncheck all columns not used in report (do not filter rows; this is done automatically at runtime see auto exist in tabular) 
- Create __relationships__ 
    + TODO
- Add __calculated columns__ for each dim column spec'd for a field/slicer/filter 
    + TODO
- Add __Hierarchies__ 
    + TODO
- Create __measures__ 
    + Format measure output
    + TODO
- Implement __measure slicer__ 
    + TODO
- Add __Perspective__
    + TODO

### How to...
    
- Change the __Model View__ in Visual Studio
    + Model -> Model View
- __Change query__ (or some other property) of existing table in model?
    + In Data View (aka Grid) click table's tab -> F4 -> Source Data -> click ...
    + In Diagram View click a table -> F4 -> Source Data -> click ...
- __Deploy__ Model to server
    + F5
- Browse __pivot table__ of current working (aka workspace) model
    + Model -> Analyse in Excel
- Add model processing to __SSIS job__
    + TODO
- Find cube on server in __SSMS__
    + TODO
- Change __SQL data source__ server
    + TODO
- Use __service account__
    + TODO



## SSRS

## SSIS
