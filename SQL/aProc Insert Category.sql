/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [categoryID]
      ,[processID]
      ,[category]
      ,[active]
      ,[EntryDate]
      ,[EnteredBy]
      ,[LastUpdatedOn]
      ,[UpdatedBy]
  FROM [ARMS].[dbo].[EP_Category]
  
  
  
  select * from processmaster where processName like '%Human%' and active=1
  
  
  
INSERT INTO EP_Category
                      (processID, category, active, EntryDate, EnteredBy)
                      
select processID,'Recruitment',1,getdate(),101166
from processmaster where processName like '%Human%' and active=1
and processID not in (select processID from EP_Category where category='Recruitment' and active=1 and EP_Category.processID=processmaster.ProcessID )
