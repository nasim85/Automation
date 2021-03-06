
GO
/****** Object:  StoredProcedure [dbo].[USP_EDB_editJobDetails]    Script Date: 03/16/2012 21:19:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_EDB_editJobDetails]          
          
          
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
@26 bit  --EmployeeType
        
AS          
BEGIN          
Declare @result varchar(10)          
if (@3='')          
begin          
 set @3=NULL          
end          
if (@11='')          
begin          
 set @11=NULL          
end          
if (@12='')          
begin          
 set @12=NULL          
end          
if (@13='')          
begin          
 set @13=NULL          
end          
if (@14='')          
begin          
 set @14=NULL          
end          
if (@15='')          
begin          
 set @15=NULL          
end          
        
        
        
declare @processHeadID varchar(50),@oldProcessHead varchar(50),@processID varchar(50),@subProcessID varchar(50), @teamID varchar(50)        
        
set @oldProcessHead =(select top 1 employeeID  from processHead where processID in (select processID from subProcessMaster where subProcessID in ((select subprocessID from teamMaster where teamID in((select  teamID from employeeMaster where employeeID=@23
  
    
      
)))))  and active=1 order by createdDate desc)        
set @processHeadID  =(select top 1 employeeID  from processHead where processID in (select processID from subProcessMaster where subProcessID in ((select subprocessID from teamMaster where teamID in((@2)))))  and active=1 order by createdDate desc)       
 
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
        
IF NOT EXISTS(SELECT * FROM EMPLOYEEMASTER WHERE EmployeeID=@23 AND EmployeementStatusID =@8)    
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
     ,[LastUpdated]= getdate()          
     ,[UpdatedBy]=@22        
  ,[transferDate]=@24      
  ,transferUnit=@25 
  ,emptype=@26       
   WHERE [EmployeeID]=@23 and active=1          
        
        
        
    
    
    
    
    
        
        
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
        
        
        
        
  set @result=2          
 end          
return @result          
END
