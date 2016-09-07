CREATE PROCEDURE [dbo].[USP_EDB_editJobDetails] 
@1 varchar(3)='',--DesignationID                                                        
@2 varchar(3)='',--TeamID                                                         
@3 varchar(20)='',--DOJAsTrainee                                                        
@4 varchar(20)='',--DOJ                                                        
@5 varchar(3)='',--LocationID                                                        
@6 varchar(3)='',--ShiftID                                                        
@7 varchar(100)='',--EmailID                                                        
@8 varchar(3)='',--EmployeementStatusID                                                        
@9 varchar(50)='',--Voice                                                        
@10 varchar(500)='',--ConfirmationTerms                                                        
@11 varchar(20)='',--ConfirmationDue                                                        
@12 varchar(20)='',--RetirementDate                                                        
@13 varchar(20)='',--ResignationDate                                                        
@14 varchar(20)='',--AttritionDate                                                        
@15 varchar(20)='',--LastDayWorked                                                        
@16 varchar(50)='',--AttritionStatus                                                        
@17 varchar(200)='',--AttritionReason                                                        
@18 varchar(2000)='',--AttritionReasonInDetail                                                        
@19 varchar(10)='',--NoticePeriodServedInDays                                                        
@20 varchar(10)='',--AttritionMonth                                                        
@21 varchar(3)='',--Voluntary                                                        
--@22 varchar(10)='',--CompanyID                                                        
@22 varchar(10)='',--UpdatedBy                                                        
@23 varchar(10)='',--Employeeid                                                      
@24 varchar(50), --Transfer Date                                                    
@25 varchar(50),  --transfer Unit                                                    
@26 bit,  --EmployeeType                                             
@27 varchar(10),  --TransferEmpId                                            
@28 varchar(20),  --TransferProcessId                                             
@29 varchar(20),  --TransferShiftId                                             
@30 varchar(20), --Joining Date                                            
@31 varchar(max),  --JobDiscription                                             
@32 varchar(max)  --JobSpecification Date                                              
AS                                                        
BEGIN                                                        
 Declare @result varchar(10)                                                        
 if (@3='')                                                        
 begin                                                        
   SET @3=NULL                                                        
 end                                                        
 if (@11='')                                                        
 begin                                                        
   SET @11=NULL                                                        
 end                                                        
 if (@12='')                                                        
 begin                        
   SET @12=NULL                                                        
 end                                                        
 if (@13='')                                                        
 begin                                                        
   SET @13=NULL                                                        
 end                                                       
 if (@14='')                                                        
 begin                                                        
   SET @14=NULL               
 end                                                        
 if (@15='')                   
 begin                                                        
   SET @15=NULL                    
 end                                                        
       
    
--============Updating JobSpecification============================      
      
exec [USP_EDB_UpdateJobDescription] @23,@22,@31,@32    
      
      
--============END JobSpecification============================      
                                                 
                                  
                                        
IF NOT EXISTS(SELECT EMPLOYEEID FROM EmployeeMaster WHERE EmployeeId=@27  AND @8='3'   )  --for Transfer update                                    
BEGIN                                        
                                                      
 declare @processHeadID varchar(50)                                              
 ,@oldProcessHead varchar(50)                                              
 ,@OldProcessID varchar(50)                                              
 ,@NewProcessID varchar(50)                                              
 ,@subProcessID varchar(50)                            
 , @teamID varchar(50)                                                   
                                              
SET @OldProcessID=( select processID from VW_EmployeeDetails where employeeID=@23)                                              
SET @NewProcessID=(SELECT ProcessID FROM VW_ProcessDetails WHERE (TeamID = @2))                                              
                                                     
SET @oldProcessHead =(select top 1 employeeID  from processHead                                               
     WHERE processID in (select processID from subProcessMaster                                               
           WHERE subProcessID in ((select subprocessID from teamMaster                                               
           WHERE teamID in((select  teamID from employeeMaster where employeeID=@23))                                              
                  ))                                              
)                                                
                              
AND active=1 order by createdDate desc)                                                  
 SET @processHeadID  =(select top 1 employeeID  from processHead                                               
  WHERE processID in (select processID from subProcessMaster                                               
  WHERE subProcessID in ((select subprocessID from teamMaster                                               
  WHERE teamID in((@2)))))  and active=1 order by createdDate desc)                                                     
                                               
--set @processHeadID =(select top 1 employeeID  from processHead where processID=@7 and active=1 order by createdDate desc)                                                      
                                                        
  if exists(Select EmployeeId from EmployeeMaster where EmployeeId=@23 and active=1)                                                        
 begin                                                  
                                                       
       INSERT INTO EmployeeJobDetailsHistory                                                        
       (EmployeeID,DesignationID,TeamID,DOJAsTrainee,DOJ,LocationID,                                                        
       ShiftID,EmailID,EmployeementStatusID,Voice,ConfirmationTerms,                
       ConfirmationDue,RetirementDate,ResignationDate,AttritionDate,                                               
       LastDayWorked,AttritionStatus,AttritionReason,                                                        
       AttritionReasonInDetail,NoticePeriodServedInDays,AttritionMonth,                                                        
       Voluntary,LastUpdated,UpdatedBy)                                                   
       Select EmployeeID,DesignationID,TeamID,DOJAsTrainee,DOJ,LocationID,                                                        
       ShiftID,EmailID,EmployeementStatusID,Voice,ConfirmationTerms,                                                        
       ConfirmationDue,RetirementDate,ResignationDate,AttritionDate,                                                        
       LastDayWorked,AttritionStatus,AttritionReason,                                                        
       AttritionReasonInDetail,NoticePeriodServedInDays,AttritionMonth,                           
       Voluntary,getdate(),@22 from EmployeeMaster                                                        
       where EmployeeID=@23 and active=1                                   
                                                      
IF NOT EXISTS(SELECT EMPLOYEEID FROM EMPLOYEEMASTER WHERE EmployeeID=@23 AND EmployeementStatusID =@8)                      
BEGIN                                                  
  if(@8<>'1')                                                
  Begin                                                
  ---------------Inserting Employee status change notification mail entry-----------------                                                  
  exec USP_EDB_InsertEmpNotification @23,@8,@22                                                   
  End                                                
END                                                  
                                                      
  UPDATE [EmployeeMaster]                                                        
     SET [DesignationID]=@1                                                        
     ,[TeamID]=@2                               
     ,[DOJAsTrainee]=@3                                                        
     ,[DOJ]=@4                                                        
     ,[LocationID]=@5                                                        
     ,[ShiftID]=@6                         
     ,[EmailID]=@7                                                        
     ,[EmployeementStatusID]=@8                                                        
     ,[Voice]=@9                                                         
     ,[ConfirmationTerms]=@10                                                        
     ,[ConfirmationDue]=@11                                                        
     ,[RetirementDate]=@12                                                        
     ,[ResignationDate]=@13                                                        
     ,[AttritionDate]=@14                                                        
     ,[LastDayWorked]=@15                                   
     ,[AttritionStatus]=@16                                                        
     ,[AttritionReason]=@17                                                        
     ,[AttritionReasonInDetail]=@18                                                        
     ,[NoticePeriodServedInDays]=@19                                                        
     ,[AttritionMonth]=@20                                                        
     ,[Voluntary]=@21                                                        
     --,[CompanyID]=@22                                                        
     ,[LastUpdated]= getdate()                                                             ,[UpdatedBy]=@22                                                      
  ,[transferDate]=@24                                   
  ,transferUnit=@25                                               
  ,emptype=@26                                           
  ,TransferEmployeeId=@27                                                     
   WHERE [EmployeeID]=@23 and active=1                                                        
                                                      
                                      
                                                 
if(@NewProcessID <> @OldProcessID)                                              
Begin                                              
 INSERT INTO EmployeeNotification                                              
                      (Employeeid, Status, Notification, Createdby, CreatedDate, AlertCategory, AlertData)                                              
 VALUES     (@23,@NewProcessID,0,@22,GETDATE(),9,@OldProcessID)                                              
End                                                  
                                                      
                                                      
if exists(select reportingLeadID from EmployeeReportingLead where employeeID=@23 and HeadID =@oldProcessHead)                                                      
 Begin                                            
  update EmployeeReportingLead                                                      
    set     HeadID=@processHeadID, LastUpdated=getdate(), UpdatedBy=@22                                                      
  where employeeID=@23 and HeadID =@oldProcessHead                                                      
 End                                                      
else                                                      
 Begin                                                      
  INSERT INTO EmployeeReportingLead                                   
                      (EmployeeID, HeadID, ReportingType, Active, CreatedDate, CreatedBy, LastUpdated, UpdatedBy)                                                      
  Values(@23,@processHeadID,'In-Direct',1 ,getdate(), @22,getdate(), @22)                  
 End                                                      
  SET @result=2                                                        
 end                                             
                                             
 ----------------------------------------------------------Transfer Update-------------------------------------------------------------                                            
  IF(@8 ='3')                                        
   BEGIN                                        
   DECLARE @FirstName varchar(100),@MiddleName varchar(100),@LastName varchar(100),@SSN varchar(50),@DesignationId varchar(50),@DOJ varchar(50) ,@Tital varchar(50),@empType varchar(10),
   @Gender varchar(10),@LocationID varchar(10),@pwd varchar(100)
   ,@FromTeamId int,@ToTeamId int                                     
   SELECT @FirstName=FirstName,                                            
   @MiddleName=MiddleName,                                            
   @LastName=LastName,                                            
     @SSN=SSNNumber,                                            
     @DesignationId=DesignationId,                                            
     @DOJ=DOJ,                                            
     @Tital=Tiltle,                                            
     @empType=empType,                                            
     @Gender=Gender,                                            
     @pwd=@pwd,                          
     @FromTeamId=TeamID                                            
                                                 
    FROM EmployeeMaster WHERE EmployeeID=@23                                            
      
  SET @LocationID = (SELECT Top 1 LocationID from LocationMaster WHERE CompanyID= @25 AND Active=1)                      
                      
                      
   /*IF ((SELECT  TransferEmployeeId FROM EmployeeMaster WHERE EmployeeID=@23) IS NOT NULL)                                
     BEGIN                                
                                     
   UPDATE EmployeeMaster SET Active=0,[LastUpdated]= getdate() ,[UpdatedBy]=@22   WHERE EmployeeID=(SELECT  TransferEmployeeId FROM EmployeeMaster WHERE EmployeeID=@23)                                
   UPDATE Login SET Active=0,[LastUpdated]= getdate() ,[UpdatedBy]=@22  WHERE EmployeeID=(SELECT  TransferEmployeeId FROM EmployeeMaster WHERE EmployeeID=@23)                                
                                      
     END               
                   
     */                        
                      
                            
                                
   EXEC USP_EDB_insertEmpDetail @27,@FirstName,@MiddleName,@LastName,@SSN,@DesignationId,@28,@30,@29,@25,@22,@Tital,@empType,@Gender,@LocationID,'','1'                                            
   EXEC [USP_EDB_UpdateTransferEmployeeDetails] @23,@27,@22                                          
                               
    SET @ToTeamId =(SELECT TeamId from EmployeeMaster WHERE EmployeeID= @27)                          
    INSERT INTO [dbo].[EmployeeTransfer]                            
     ([EmployeeID],[TransferType],[FromTeamID],[ToTeamID],[TransferDate],[ReasonForTransfer],[Comments],[Active],[CreatedDate],[CreatedBy])                            
   VALUES                            
     (@23,'',@FromTeamId,@ToTeamId,@24,'','',1,GETDATE(),@22)     
         
         
    
               
  END                                       
  ELSE IF ((SELECT  TransferEmployeeId FROM EmployeeMaster WHERE EmployeeID=@23) IS NOT NULL)                                
  BEGIN                                
  /* UPDATE EmployeeMaster SET Active=0,[LastUpdated]= getdate() ,[UpdatedBy]=@22   WHERE EmployeeID=(SELECT  TransferEmployeeId FROM EmployeeMaster WHERE EmployeeID=@23)                 
  UPDATE Login SET Active=0,[LastUpdated]= getdate() ,[UpdatedBy]=@22  WHERE EmployeeID=(SELECT  TransferEmployeeId FROM EmployeeMaster WHERE EmployeeID=@23)                                
   */              
                     
     IF(@8 ='1')                   
     BEGIN                  
    UPDATE EmployeeMaster SET TransferDate=NULL,TransferEmployeeId=NULL,TransferUnit=NULL,[LastUpdated]= getdate() ,[UpdatedBy]=@22  WHERE  EmployeeID=@23                                
   END                  
  END                                 
 -----------------------------------------------------------------------------------------------------------------------                                            
 END                                   
 ELSE                                    
 BEGIN                                    
 SET @result=-1                                    
 END                                    
return @result                                                        
END 