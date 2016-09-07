
declare @empID int,
@AppraisalDate varchar(20)
,@LastAppraisalDate datetime
,@AppraisalId int
,@DOJ varchar(20)

set @AppraisalDate='9/30/2012'

--delete from Appraisal where AppraisalDate='9/30/2012'
DECLARE InsertCursor CURSOR FOR 
   SELECT DISTINCT EM.employeeID,EM.DOJ       
   from EmployeeMaster EM INNER JOIN AppraisalCycleEmployee ACE ON (EM.EmployeeID =ACE.EmployeeID)              
   Where EM.ACTIVE=1 AND EM.EmployeementStatusId in (1)  AND ACE.Active=1 and ACE.AppraisalTypeID=2 
   --and isnull(EM.empType,0)=0 and EM.employeeID in (100955)
    OPEN InsertCursor
    FETCH NEXT FROM InsertCursor INTO @empID,@DOJ
    WHILE @@FETCH_STATUS = 0
    BEGIN
   
IF NOT EXISTS(SELECT APPraisalID FROM Appraisal WHERE EmployeeId=@empID AND AppraisalDate=@AppraisalDate AND Active=1)            
BEGIN            
  set @LastAppraisalDate=null
 
   SELECT @LastAppraisalDate =isnull(max(convert(datetime,AppraisalDate)),@DOJ) 
  from Appraisal where EmployeeID=@empID and Active=1


INSERT INTO [dbo].[Appraisal]                
      ([EmployeeID],[AppraisalDate],[AppraisalStatusID],[Active],[AppriasalTypeID],DurationMonths,DurationDays,[ProcessedOn],[CreatedDate],[CreatedBy])                
   VALUES                
      (@empID,@AppraisalDate,1,1,2,DATEDIFF(MONTH,@LastAppraisalDate,@AppraisalDate),DATEDIFF(DAY,@LastAppraisalDate,@AppraisalDate),getDate(),getDate(),0)               
 
 SET @AppraisalId = @@IDENTITY           
 --------------------------------------------------------INSERT NOTIFICATION -----------------------------------------------------------------------     
   INSERT INTO [employeenotification]([employeeid],[status],[notification],[createdby],[createddate],[alertcategory],[alertdata])                   
   VALUES( @empID, 1,0,-1,getdate(),8,@AppraisalId )    
-----------------------------------------------------------------------------------------------------------------------------------------------------            
              
 INSERT INTO [dbo].[AppraisalRouteStatus]              
           ([AppraisalID]              
           ,[RouteName]              
           ,[AppraisalStatusID]              
           ,[Active]              
           ,[EnteredBy]              
           ,[EntryDate])              
     VALUES              
           (@AppraisalId,'Appraisal Process Started by ARMS'  ,1,1,0,GetDate())             
 END             
    
      FETCH NEXT FROM InsertCursor INTO @empID,@DOJ
        END

    CLOSE InsertCursor
    DEALLOCATE InsertCursor
    