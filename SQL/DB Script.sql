USE [ARMS]


if not exists (select * from ARMS.dbo.AppraisalPerformanceNoteType where PerformanceNoteType='Corrective Action Plan' and active=1)
Begin
INSERT INTO [ARMS].[dbo].[AppraisalPerformanceNoteType]
           ([PerformanceNoteType]
           ,[active])
     VALUES
           ('Corrective Action Plan',1)
           
End
           
GO





-- =============================================                              
-- Author:  Nasim          
-- Create date: 27 DEC 2011           
-- Description: Employee Appraisal Cycle                              
-- =============================================                              
ALTER PROCEDURE [dbo].[USP_APP_GetRatingCalculated]          
@1 varchar(20), --AppraisalID         
@2 varchar(20) --User ID          
AS                          
BEGIN          
SET NOCOUNT ON;            

--Declare
--@1 varchar(20)=11, --AppraisalID         
--@2 varchar(20)=0 --User ID   
          
          
declare     
@TotalWeightage decimal(10,2)    
    
    
set @TotalWeightage =(SELECT sum(cast(APM.ParameterWeightage as decimal(10,2)))    
FROM     AppraisalParameter AS AP INNER JOIN    
                      AppraisalParameterMaster AS APM ON AP.ParameterID = APM.ParameterID    
where  AP.AppraisalID=@1  and APM.ParameterTypeID=2)    



    
select r.AppraisalID    
  ,[EnteredBy]=(select isnull(FirstName+' ','')+isnull(MiddleName+' ','')+isnull(LastName+' ','') from EmployeeMaster where EmployeeID=r.EnteredBy)    
  ,[Rating]=

	CAST(SUM(r.Score)/(COUNT(r.Score)) as decimal(10,0))
  --sum (r.Score)
  --(case     
  -- when (sum(r.Score)/@TotalWeightage*100)  <=70 then 'C'    
  -- when (sum(r.Score)/@TotalWeightage*100)  <=80 then 'B-'    
  -- when (sum(r.Score)/@TotalWeightage*100)  <=90 then 'B+'    
  -- when (sum(r.Score)/@TotalWeightage*100)  <=100 then 'A'    
  -- else ''    
  --End)   
   
 from    
 (    
   SELECT     APM.ParameterName, APR.Rating, APR.Remark,     
      APR.EnteredBy    
      ,APM.ParameterWeightage,     
       --((CAST(APM.ParameterWeightage AS DECIMAL(10,2)))/4* CAST(APR.Rating AS DECIMAL(10,2))) as [Score],     
       CAST(APR.Rating AS DECIMAL(10,2))as [Score],  
       AP.AppraisalID,APR.EntryDate    
   FROM         AppraisalParameterRating AS APR INNER JOIN    
          AppraisalParameter AS AP ON APR.APPID = AP.APPID INNER JOIN    
          AppraisalParameterMaster AS APM ON AP.ParameterID = APM.ParameterID    
   WHERE     (AP.AppraisalID = @1) and APM.ParameterTypeID=2 --and APR.EnteredBy=@2     
       
       
       
 ) r    
    
group by r.AppraisalID,r.EnteredBy     
order by max (r.EntryDate) desc           
END    
    
     