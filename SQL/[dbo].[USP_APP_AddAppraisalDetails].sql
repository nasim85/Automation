
GO
/****** Object:  StoredProcedure [dbo].[USP_APP_AddAppraisalDetails]    Script Date: 03/23/2012 19:48:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- =============================================                                          
---- Author:  Pankaj Yadav  --Alter by Nasim                                        
---- Create date: 30 DEC 2011   -- On 27 feb 2012                                      
---- Description: Insert Appraisal  Details                                        
---- =============================================                                          
--ALTER PROCEDURE [dbo].[USP_APP_AddAppraisalDetails]  --'100','0','101173'                                        
--AS                                  
BEGIN                   
----------------------------------------------------Add Appraisal Details-------------------------------------------------------------                
  DECLARE @EmployeeID varchar(50)      
  ,@DOJ dateTime      
  ,@AppraisalDate dateTime       
  ,@LastAppraisalDate dateTime       
  ,@RoleId int,@AppriasalTypeID int       
  ,@NewAppraisalStatusID int      
  ,@AppraisalId varchar(50)      
                              
  DECLARE  @tempEmpList table (EmployeeID varchar(50),AppraisalDate datetime,EntryDate datetime,DOJ datetime)                                      
     
 INSERT INTO @tempEmpList (EmployeeID ,AppraisalDate,EntryDate,DOJ)                
   SELECT DISTINCT EM.employeeID,'9/30/2012' as AppraisalDate,ACE.EntryDate,EM.DOJ       
   from EmployeeMaster EM INNER JOIN AppraisalCycleEmployee ACE ON (EM.EmployeeID =ACE.EmployeeID)              
   Where EM.ACTIVE=1 AND EM.EmployeementStatusId in (1)  AND ACE.Active=1 --and isnull(EM.empType,0)=0
   --AND ( DATEDIFF(MONTH,EM.DOJ,GETDATE()) >= 6 ) --DOJ         
   --AND (DATEDIFF(DW,dbo.GetAppraisalDate(EM.DOJ,EM.EmployeeID),GETDATE()) BETWEEN  -30  AND 0 )  -- (14 Days)
   and EM.employeeID in (101166,104401,104402,312363)--101166,101122,100870,100350,101092)
      ORDER BY  ACE.EntryDate DESC            
                 
            
 WHILE (SELECT Count(EmployeeID) From @tempEmpList) > 0                                      
  BEGIN              
  SELECT top 1 @EmployeeID=EmployeeId,@AppraisalDate=AppraisalDate,@DOJ=DOJ FROM @tempEmpList             
IF NOT EXISTS(SELECT APPraisalID FROM Appraisal WHERE EmployeeId=@EmployeeID AND AppraisalDate=@AppraisalDate AND Active=1)            
BEGIN            
   SET @AppriasalTypeID=(SELECT TOP 1 AppraisalTypeID FROM  AppraisalCycleEmployee WHERE EmployeeID=@EmployeeID AND Active=1)           
           
     IF EXISTS(SELECT EmployeeRoleID from EmployeeRoles WHERE Active=1 AND EmployeeId=@EMPLOYEEID)        
     BEGIN        
  SET @RoleId =(SELECT TOP 1 RoleId FROM EmployeeRoles WHERE EmployeeID=@EMPLOYEEID  AND ACTIVE=1)          
     END        
     ELSE        
     BEGIN        
  SET @RoleId =(SELECT TOP 1 RoleId FROM login WHERE EmployeeID=@EMPLOYEEID AND ACTIVE=1 )          
     END             
            

  SELECT @LastAppraisalDate =max(AppraisalDate) from Appraisal where EmployeeID=@EmployeeID and Active=1            

if(@LastAppraisalDate is null)
	Begin            
	  SELECT @LastAppraisalDate= (case 
										when year(@DOJ) = 2012 then @DOJ
										else cast((cast(month(@DOJ) as varchar)+'/'+cast(day(@DOJ) as varchar)+'/2011') as datetime)
									End
									)
	End								
								
								
  SELECT  @NewAppraisalStatusID =1      
    --SELECT  @NewAppraisalStatusID =(CASE                  
    --      WHEN  @RoleId in (3) THEN 5 --pending for Manager                
    --      WHEN  @RoleId in (12)  THEN 6 ----pending for COE                
    --      WHEN  @RoleId in (10) THEN 7 ----pending for HR                
    --      ELSE 1 ----pending for Employee          
    --     END                
    --    )                
           
  INSERT INTO [dbo].[Appraisal]                
      ([EmployeeID],[AppraisalDate],[AppraisalStatusID],[Active],[AppriasalTypeID],DurationMonths,DurationDays,[ProcessedOn],[CreatedDate],[CreatedBy])                
   VALUES                
      (@EmployeeID,@AppraisalDate,@NewAppraisalStatusID,1,@AppriasalTypeID,DATEDIFF(MONTH,@LastAppraisalDate,@AppraisalDate),DATEDIFF(DAY,@LastAppraisalDate,@AppraisalDate),getDate(),getDate(),0)               
 SET @AppraisalId = SCOPE_IDENTITY()           
 --------------------------------------------------------INSERT NOTIFICATION -----------------------------------------------------------------------    
   INSERT INTO [employeenotification]([employeeid],[status],[notification],[createdby],[createddate],[alertcategory],[alertdata])                   
   VALUES( @EmployeeID, 1,0,-1,getdate(),8,@AppraisalId )    
-----------------------------------------------------------------------------------------------------------------------------------------------------            
              
 INSERT INTO [dbo].[AppraisalRouteStatus]              
           ([AppraisalID]              
           ,[RouteName]              
           ,[AppraisalStatusID]              
           ,[Active]              
           ,[EnteredBy]              
           ,[EntryDate])              
     VALUES              
           (@AppraisalId,'Appraisal Process Started by ARMS'  ,1,@NewAppraisalStatusID,0,GetDate())             
 END             
               
  DELETE  FROM @tempEmpList WHERE EmployeeID=@EmployeeID                
 END                
--------------------------------------------------------------------------------------------------------------------------------------------------                
                
----------------------------------------------------Update Appraisal status AutoSendDay Wise-------------------------------------------------------------                
--  DECLARE @oldAppraisalStatusID int      
--  ,@oldAppraisalStatus VARCHAR(200)       
     
--  DECLARE  @tempAppList table (AppraisalID varchar(50))                                      
      
--  INSERT INTO @tempAppList       
--  SELECT AppraisalID from Appraisal       
--  WHERE DATEDIFF(dd,ProcessedOn,GETDATE()) > (SELECT AutoSendDays FROM AppraisalStatus       
--           WHERE  AppraisalStatusId=Appraisal.AppraisalStatusID AND Active=1)  AND AppraisalStatusId not in (8) and isnull(OnHold,0) <>1 AND ACTIVE=1                
--  --INSERT INTO @tempAppList       
--  --SELECT AppraisalID from Appraisal       
--  --WHERE DATEDIFF(dd,ProcessedOn,GETDATE()) >= (SELECT TOP 1 AutoSendDays FROM AppraisalStatus       
--  --          WHERE  AppraisalStatusId=Appraisal.AppraisalStatusID AND Active=1)  AND AppraisalStatusId in (3,4,5,6) AND ACTIVE=1                
                  
                              
--  WHILE (SELECT Count(AppraisalID) From @tempAppList) > 0                                      
--   BEGIN        
--   SET @EmployeeID=''                          
--   SELECT top 1 @AppraisalID=AppraisalID FROM @tempAppList                 
--   SELECT @oldAppraisalStatusID=AppraisalStatusID,@EmployeeID=EmployeeID FROM Appraisal WHERE AppraisalID=@AppraisalID                
--   SELECT  @NewAppraisalStatusID =(CASE @oldAppraisalStatusID                 
--          WHEN  3   THEN 4                
--          WHEN  4   THEN 5                
--          WHEN  5   THEN 6                
--          WHEN  6   THEN 7                
--         END                
--         )                
               
--   UPDATE Appraisal SET AppraisalStatusID=@NewAppraisalStatusID ,ProcessedOn=getDate(),LastUpdated=GetDate(),UpdatedBy=0 WHERE AppraisalID=@AppraisalID                
----------------------------------------------------------INSERT NOTIFICATION -----------------------------------------------------------------------    
--   INSERT INTO [employeenotification]([employeeid],[status],[notification],[createdby],[createddate],[alertcategory],[alertdata])                   
--   VALUES( @EmployeeID, @NewAppraisalStatusID,0,-1,getdate(),8,@AppraisalID)    
-------------------------------------------------------------------------------------------------------------------------------------------------------            
--  SET @oldAppraisalStatus = (SELECT ISNULL(StatusName,'') FROM AppraisalStatus  WHERE AppraisalStatusId= @oldAppraisalStatusID )              
               
--   INSERT INTO [dbo].[AppraisalRouteStatus]              
--      ([AppraisalID]              
--      ,[RouteName]              
--      ,[AppraisalStatusID]              
--      ,[Active]              
--      ,[EnteredBy]              
--      ,[EntryDate])              
--   VALUES              
--      --(@AppraisalID,'Appraisal is '+@oldAppraisalStatus ,1,@NewAppraisalStatusID,101166,GetDate())              
--         (@AppraisalID,'Auto Post from '+@oldAppraisalStatus ,@NewAppraisalStatusID,1,0,GetDate())       
                      
--   DELETE  FROM @tempAppList WHERE AppraisalID=@AppraisalID        
                 
--  END           
------------------------------------------------------------------------------------------------------------------------------------------                
END                
        
--select * from Appraisal ORDER BY AppraisalID DESC        
--UPDATE Appraisal SET AppraisalDate='2011-08-24' WHERE AppraisalID=98        
---DELETE FROM Appraisal WHERE  AppraisalId >98        
--EmployeeId in (100078        
--,100224        
--,100721        
--,300126        
--,300128        
--,300150)        
        
--select dbo.[GetLastAppraisalDate]('08/24/2011', '300150')        
--select dbo.[GetAppraisalDate]('09/24/2011', '300150')        
        
--select DATEDIFF(MONTH,CONVERT(DATETIME, dbo.[GetLastAppraisalDate]('08/24/2011', '300150')),CONVERT(DATETIME,dbo.[GetAppraisalDate]('08/24/2011', '300150')))
