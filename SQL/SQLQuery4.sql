                  
                  
                  
                  
                  
                  
                  
                  
-- =============================================                  
-- Author:  Nasim          
-- Create date: 10 FEB 2012          
-- Description: Get job details          
-- =============================================                  
Alter PROCEDURE [dbo].[USP_getJobs]            
@1 varchar(50), --From Date          
@2 varchar(50), --ToDate          
@3 varchar(50), --job ID          
@4 varchar(50), --Account ID          
@5 varchar(50), --CompanyID          
@6 varchar(50), --ProcessID          
@7 varchar(50), --SubProcessID          
@8 varchar(50), --Request Type          
@9 varchar(50), --Request Status          
@10 varchar(50),--Emplopyee ID  
@11 varchar(50) --User ID    
          
AS                  
BEGIN   

--Declare
--@1 varchar(50), --From Date          
--@2 varchar(50), --ToDate          
--@3 varchar(50), --job ID          
--@4 varchar(50), --Account ID          
--@5 varchar(50), --CompanyID          
--@6 varchar(50), --ProcessID          
--@7 varchar(50), --SubProcessID          
--@8 varchar(50), --Request Type          
--@9 varchar(50), --Request Status          
--@10 varchar(50),--Emplopyee ID  
--@11 varchar(50) --User ID


--set		@1 ='1/1/2012'
--set 	@2 ='3/1/2012'
--set 	@3 =''
--set 	@4 ='0'
--set 	@5 ='0'
--set 	@6 ='0'
--set 	@7 ='0'
--set 	@8 ='0'
--set 	@9 ='0'
--set     @10='' 
--set 	@11=101062
	
	
	
declare @select varchar(8000)
,@where varchar(4000) 
,@groupBy varchar(4000)
,@roleID int

SELECT    @roleID= RoleID
FROM         EmployeeRole
WHERE     (EmployeeID = @11) AND (Active = 1)

set @roleID=isnull(@roleID,0)

set @select='SELECT     Job.JobNo, JTM.JobType, PM.Priority, JSM.jobStatus, JSM.Color, CONVERT(varchar, Job.EntryDate, 101) AS EntryDate, Job.EnteredBy, Job.JobID, 
                      COUNT(EA.EmployeeAccountID) AS TotalAccount, COUNT(CASE WHEN AccountStatusID NOT IN (1) THEN 1 ELSE NULL END) AS AccountLeft, 
                      vEM.Name AS RequestedBy, Job.PriorityID, Job.JobTypeID, Job.JobStatusID, EA.AccountID, Job.SubProcessID, vEM.CompanyID, vEM.company, 
                      vEM.ProcessID, vEM.SubProcessID AS Expr1, vEM.SubProcessName, vEM.Process, AccountMaster.AccountName,
                      cast( (case when '+cast(@roleID as varchar) +'=1 then 1 else 0 end) as bit) as SendVisisble
			FROM         Job INNER JOIN
                      JobTypeMaster AS JTM ON Job.JobTypeID = JTM.JobTypeID INNER JOIN
                      JobStatusMaster AS JSM ON Job.JobStatusID = JSM.JobStatusID INNER JOIN
                      PriorityMaster AS PM ON Job.PriorityID = PM.PriorityID INNER JOIN
                      VW_EmployeeDetails AS vEM ON Job.EnteredBy = vEM.EmployeeID INNER JOIN
                      EmployeeAccount AS EA ON Job.JobID = EA.JobID INNER JOIN
                      AccountMaster ON EA.AccountID = AccountMaster.AccountID
		'

set @where=' WHERE     (Job.Active = 1) AND (EA.Active = 1) and (Job.EntryDate between '''+ @1 +''' and '''+ @2 +' 11:59:59 PM'' )'


set @groupBy=' GROUP BY Job.JobNo, JTM.JobType, PM.Priority, JSM.jobStatus, JSM.Color, Job.EntryDate, Job.EnteredBy, Job.JobID, vEM.Name, Job.PriorityID, 
                      Job.JobTypeID, Job.JobStatusID, EA.AccountID, Job.SubProcessID, vEM.CompanyID, vEM.company, vEM.ProcessID, vEM.SubProcessID, 
                      vEM.SubProcessName, vEM.Process, AccountMaster.AccountName
                      
                ORDER BY job.JobID desc      
             ' 
             
if(@roleID=0)
Begin             
set @where=@where+' AND Job.EnteredBy='+ @11 +' ' 
End
  
  
if(@4<>0)
Begin
set @where=@where+' AND EA.accountID='+ @4 +' '
End  
  
if(@5<>0)
Begin
set @where=@where+' AND vEM.companyID='+ @5 +' '
End

if(@6<>0)
Begin
set @where=@where+' AND vEM.processID='+ @6 +' '
End

if(@7<>0)
Begin
set @where=@where+' AND vEM.subProcessID='+ @7 +' '
End

if(@8<>0)
Begin
set @where=@where+' AND Job.JobTypeID='+ @8 +' '
End

if(@9<>0)
Begin
set @where=@where+' AND Job.jobStatusID='+ @9 +' '
End

if(@10<>0)
Begin
set @where=@where+' AND EA.EmployeeID='+ @10 +' '
End





exec(@select + @where + @groupBy)
--print(@select )

               
                  
END                  