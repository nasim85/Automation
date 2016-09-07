
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_GetPolicyList]    Script Date: 08/08/2012 21:51:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_Policy_GetPolicyList]
@1 varchar(50)--roleid
AS

DECLARE @WHERE VARCHAR(MAX)
DECLARE @QUERY VARCHAR(MAX)
SET @WHERE=' WHERE Active=1'
--if(@1<>'0')
--BEGIN
--@WHERE=@WHERE+' AND 
--END
SET @QUERY='SELECT
PolicyID,
PolicyName
FROM 
PolicyMaster ' + @WHERE

PRINT @QUERY
EXEC (@QUERY)
GO
/****** Object:  StoredProcedure [dbo].[USP_eExit_unAssignPanel]    Script Date: 08/08/2012 21:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                          
-- Author:  Pankaj Yadav                         
-- Create date: 13 June 2012                  
-- Description: Remove Panel from Clearance Panel Matrix     
-- =============================================                          
ALTER PROCEDURE [dbo].[USP_eExit_unAssignPanel] --'8','A','101035'                    
--declare                  
 @1 varchar(max),--ClearancePanelMatrixId                      
 @2 VARCHAR(50)--USERID                      
AS                          
BEGIN                          
                
--set @1='575675,766778,786786'                  
--set @2='A'                   
--set @3='101035'                  
                    
DECLARE @qry VARCHAR(MAX)          
SET @qry='UPDATE    eExit_ClearancePanelMatrix                  
   SET Active = 0, UpdatedOn = '''+ convert(varchar(50),GETDATE())+''', UpdatedBy = '+@2+'                      
   WHERE     (ClearancePanelMatrixId in('+@1+'))                     
'                    
--select @qry                    
exec(@qry)           
return 2                     
END
GO
/****** Object:  UserDefinedFunction [dbo].[USP_EDB_GetDatesFromTwoDates]    Script Date: 08/08/2012 21:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[USP_EDB_GetDatesFromTwoDates] --'10/01/2011'
(@DATEFROM DATETIME,@DATETO DATETIME )
    RETURNS  @HOLDER_DATE table(DATE DATETIME)
AS
BEGIN
INSERT INTO
    @HOLDER_DATE(DATE)
VALUES(@DATEFROM)
WHILE @DATEFROM < @DATETO
BEGIN
    SELECT @DATEFROM = DATEADD(D, 1, @DATEFROM)
    INSERT INTO @HOLDER_DATE (DATE)
    VALUES (@DATEFROM)
END

return
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSplit]    Script Date: 08/08/2012 21:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[fnSplit](
    @sInputList VARCHAR(8000) -- List of delimited items
  , @sDelimiter VARCHAR(8000) = ',' -- delimiter that separates items
) 

RETURNS @List TABLE (item VARCHAR(8000))

BEGIN

DECLARE @sItem VARCHAR(8000)
WHILE CHARINDEX(@sDelimiter,@sInputList,0) <> 0
 BEGIN
 SELECT
  @sItem=RTRIM(LTRIM(SUBSTRING(@sInputList,1,CHARINDEX(@sDelimiter,@sInputList,0)-1))),
  @sInputList=RTRIM(LTRIM(SUBSTRING(@sInputList,CHARINDEX(@sDelimiter,@sInputList,0)+LEN(@sDelimiter),LEN(@sInputList))))
 
 IF LEN(@sItem) > 0
  INSERT INTO @List SELECT @sItem
 END

IF LEN(@sInputList) > 0
 INSERT INTO @List SELECT @sInputList -- Put the last item in
RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetDates]    Script Date: 08/08/2012 21:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[GetDates] --'10/01/2011'
(@DATEFROM DATETIME,@DATETO DATETIME )
    RETURNS  @HOLDER_DATE table(DATE DATETIME)
AS
BEGIN
INSERT INTO
    @HOLDER_DATE(DATE)
VALUES(@DATEFROM)
WHILE @DATEFROM < @DATETO
BEGIN
    SELECT @DATEFROM = DATEADD(D, 1, @DATEFROM)
    INSERT INTO @HOLDER_DATE (DATE)
    VALUES (@DATEFROM)
END

return
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetPolicyCaption]    Script Date: 08/08/2012 21:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[GetPolicyCaption](@policyid int)    
returns  varchar(max)    
as    
begin    
    
declare @m varchar(max)    
set @m=''    
select @m=@m+PolicyPage.Caption+'<br/>' from PolicyPage where PolicyPage.PolicyID=@policyid
and PolicyPage.Active=1     
--set @m=SUBSTRING(@m,0,len(@m))    
return @m    
--PRINT @M    
end
GO
/****** Object:  StoredProcedure [dbo].[eExit_BindQuestion]    Script Date: 08/08/2012 21:51:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[eExit_BindQuestion]
          as
          begin                        
          select QuesID, QuestionName from [eExit_FeedbackQuestion]  
          Where active=1 
          end
GO
/****** Object:  StoredProcedure [dbo].[USP_EDB_InsertTabMatrix]    Script Date: 08/08/2012 21:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_EDB_InsertTabMatrix]      
 @1 varchar(100)='',---RoleId      
 @2 varchar(20)='',---PageId      
 @3 varchar(20)='',---Readonly      
 @4 varchar(20)='',---Createdby      
 @5 varchar(5) ---ReportType
AS      
BEGIN      
Declare @result varchar(50)      
      
IF NOT EXISTS(SELECT ROLEID,PAGEID FROM RoleMatrix_Tabs WHERE ROLEID=@1 AND PAGEID=@2 AND ACTIVE=1)      
   BEGIN      
   INSERT INTO RoleMatrix_Tabs      
     (ROLEID,PAGEID,READONLY,ACTIVE,CREATEDDATE,CREATEDBY,ReportType)      
    VALUES  (@1,@2,@3,1,GETDATE(),@4,@5)     
    
  DECLARE @PARENTID VARCHAR(50)    
  SET @PARENTID=(SELECT PARENTNODE FROM ModuleMatrix_Tabs WHERE PAGEID=@2)    
  IF(@PARENTID <>0)    
   BEGIN    
    IF NOT EXISTS(SELECT * FROM RoleMatrix_Tabs WHERE ROLEID=@1 AND PAGEID=@PARENTID AND ReportType=@5 AND ACTIVE=1)    
    BEGIN    
     INSERT INTO RoleMatrix_Tabs      
     (ROLEID  ,PAGEID  ,READONLY  ,ACTIVE  ,CREATEDDATE  ,CREATEDBY,ReportType)      
      VALUES  (@1,@PARENTID,1,1,GETDATE(),@4,@5)      
    END    
   END    
   SET @RESULT=1      
   END      
ELSE      
   BEGIN      
  SET @RESULT=-1      
  END      
RETURN @RESULT      
END
GO
/****** Object:  StoredProcedure [dbo].[USP_EDB_GetEmployeementStatusList]    Script Date: 08/08/2012 21:51:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  <Nitish>    
-- Create date: <02-NOV-2010>    
-- Description: <For emp status List>    
-- =============================================    
--@1=BandId    
ALTER PROCEDURE [dbo].[USP_EDB_GetEmployeementStatusList]     
     
AS    
    
 BEGIN    
      
 SELECT EmployementStatusID, EmployementStatus ,EmployementStatusID 'ID',EmployementStatus 'Name' FROM EmployementStatus WHERE ACTIVE=1    AND EmployementStatusID <> 8
 ORDER BY  EmployementStatusID asc    
           
 END
GO
/****** Object:  StoredProcedure [dbo].[USP_EDB_GetEmployeementStatusDetail]    Script Date: 08/08/2012 21:51:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Indu Prakash Chaube,,USP_EDB_GetDesignationDetail>
-- Create date: <13-OCT-2010>
-- Description:	<For managing data on grid view for the form Designation Master>
-- =============================================
--@1=BandId
ALTER PROCEDURE [dbo].[USP_EDB_GetEmployeementStatusDetail] 
	
AS

	BEGIN
		
	SELECT EmployementStatusID, EmployementStatusCode, EmployementStatus FROM EmployementStatus WHERE ACTIVE=1
	ORDER BY  EmployementStatusID asc
							
	END

--EXEC [USP_EDB_GetAddressDetail] '0'
GO
/****** Object:  StoredProcedure [dbo].[USP_EDB_insertEmployeeAbsenceReason]    Script Date: 08/08/2012 21:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================              
-- Author:  Pankaj              
-- Create date: 09 DEC 2011              
-- Description: Insert Employee Absence Reasons By HR      
-- =============================================              
ALTER PROCEDURE [dbo].[USP_EDB_insertEmployeeAbsenceReason]              
 @1 varchar(50),-- EmployeeID              
 @2 varchar(50),--DateFrom            
 @3 varchar(50),--DateTO            
 @4 varchar(500),--Remark            
 @5 varchar(20),--Entered BY      
 @6 varchar(20)--ReasonId    
         
AS              
BEGIN   

Declare @result int

if not exists (SELECT ReasonID FROM EmployeeAbsenceReasons 
				WHERE (EmployeeID = @1) AND status=1 and active=1 and
					(
					(DateFrom between cast(@2 as datetime) and cast(@3 as datetime)) 
					OR (DateTo between cast(@2 as datetime) and cast(@3 as datetime))
					)
	)
Begin

		INSERT INTO [dbo].[EmployeeAbsenceReasons]      
				   ([EmployeeID],[DateFrom],[DateTo],[Remark],[EnteredBy],[CreatedDate],Status,Active)      
			 VALUES      
				   (@1,@2,@3,@4,@5,GetDate(),1,1)       
		set @result=1 
End

else
Begin
set @result=-1	
End

RETURN @result 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_EDB_EditTabMatrix]    Script Date: 08/08/2012 21:51:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  <Nitish>  
-- Create date: <10/22/2010>  
-- Description: <Insert Tab id and page id in Tab matrix>  
-- =============================================  
ALTER PROCEDURE [dbo].[USP_EDB_EditTabMatrix]  
 @1 varchar(100)='',---Id  
 @2 varchar(5)='',---Updateddby  
 @3 varchar(5)=''--Readonly  
AS  
BEGIN  
Declare @result varchar(50)  
  
 UPDATE RoleMatrix_Tabs  
   SET   
      ReadOnly = @3  
      ,LastUpdated = getdate()  
      ,UpdatedBy =@2  
 WHERE Id=@1  
  set @result=1  
return @result  
END
GO
/****** Object:  StoredProcedure [dbo].[USP_EDB_GetTabMatrix]    Script Date: 08/08/2012 21:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================      
-- Author:  <Pankaj>      
-- Create date: <07/25/2011>      
-- Description: <Select all active tab form tab matrix>      
-- =============================================      
ALTER PROCEDURE [dbo].[USP_EDB_GetTabMatrix]      
 @1 varchar(20)      
AS      
BEGIN      
 -- SET NOCOUNT ON added to prevent extra result sets from      
 SET NOCOUNT ON;      
 select RMT.Id,RMT.ReportType,RM.Rolename,RMT.ReadOnly,RMT.active,MMT.Pagename,d.ModuleName from dbo.RoleMatrix_Tabs RMT      
 inner join RoleMaster RM on RMT.Roleid=RM.Roleid      
 inner join ModuleMatrix_Tabs MMT on RMT.Pageid=MMT.pageid      
 inner join ModuleMaster d on d.ModuleID=MMT.ModuleID      
 where RMT.active=1      
END
GO
/****** Object:  StoredProcedure [dbo].[USP_EDB_GetTabListForRole]    Script Date: 08/08/2012 21:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================        
-- Author:  <Pankaj>        
-- Create date: <29/10/2010>        
-- Description: <Fetching all existing pages with related module>        
-- =============================================        
      
ALTER PROCEDURE [dbo].[USP_EDB_GetTabListForRole]-- '1'       
@1 varchar(50),--moduleID        
@2 varchar(50)=null --Parent node  
AS        
BEGIN        
 SET NOCOUNT ON;        
        
 select pageID, pageName         
 from ModuleMatrix_Tabs        
 WHERE Active='True' and moduleID=@1        
 and parentnode=isnull(@2,parentnode)  
 ORDER BY [pageName]        
        
END
GO
/****** Object:  StoredProcedure [dbo].[USP_eExitInsertResignation]    Script Date: 08/08/2012 21:51:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                          
-- Author:  Nasim      
-- Create date: 16 Jan 2012    
-- Description: Insert Employee Resignation    
-- =============================================                          
ALTER PROCEDURE [dbo].[USP_eExitInsertResignation]      
--declare      
@1 varchar(20), --EmployeeID     
@2 text,  --Resignation Details    
@3 varchar(20), --Last Day Worked
@4 varchar(20), --Last Day Worked by Policy
@5 varchar(20), --ReasonID of leaving
@6 varchar(500), --Reason details
@7 varchar(20) --UserID

  

    
AS                      
BEGIN      
SET NOCOUNT ON;        
    
Declare @result int,    
@resignationID int    
      
--set @1='101122'      
--set @2='101166'      
    
if not exists(SELECT     ResignationID FROM EmployeeResignation     
    WHERE (EmployeeID = @1) AND (Active = 1) and  ResignationStatusID in(1,2,4))    
 Begin    
    
    
	INSERT INTO EmployeeResignation
                      (EmployeeID, ResignationDate, ResignationDetails, Active, ResignationStatusID, EntryDate, EnteredBy, LastUpdatedOn, Updatedby, LastDayWorked, 
                      LastDayWorkedByPolicy, ReasonID, ReasonDetails)
	VALUES     (@1, GETDATE(),@2, 1, 1, GETDATE(),@7, GETDATE(),@7,@3,@4,@5,@6)
    
  set @resignationID=@@identity    
    
  INSERT INTO EmployeeNotification    
        (Employeeid, Status, Notification, Createdby, CreatedDate, AlertCategory,AlertData)    
  VALUES     (@1,1,0,@7, GETDATE(),6,@resignationID)    
    
  --select * from EmployeeNotification    
    
    
  set @result=1    
    
 End      
else    
 Begin    
  set @result=-1    
 End      
    
return @result    
    
        
END
GO
/****** Object:  StoredProcedure [dbo].[USP_eExitGetReasonList]    Script Date: 08/08/2012 21:51:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                        
-- Author:  Nasim    
-- Create date: 25 Jan 2012  
-- Description: Get resignation Details  
-- =============================================                        
ALTER PROCEDURE [dbo].[USP_eExitGetReasonList]    
  
AS                    
BEGIN    
SET NOCOUNT ON;    

SELECT     ReasonID, Reason
FROM         resignationReasonMaster
Where active=1
  
END
GO
/****** Object:  StoredProcedure [dbo].[USP_eExit_GetClearancePanelList]    Script Date: 08/08/2012 21:51:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                                  
-- Author:  Pankaj Yadav                                              
-- Create date: 13 Jun 2012                                            
-- Description: Get Clearance Panel List    
-- =============================================                                               
ALTER PROCEDURE [dbo].[USP_eExit_GetClearancePanelList]  --4
@1 Varchar(20)--Role ID      
AS        
SET NOCOUNT ON ;   

SELECT ClearancePanelId 'ID' ,ClearancePanelName 'NAME' FROM eExit_ClearancePanelMaster    
WHERE ACTIVE =1 
AND    ClearancePanelId NOT IN (SELECT  DISTINCT ClearancePanelId FROM eExit_ClearancePanelMatrix WHERE RoleId=@1 AND Active =1)
ORDER BY ClearancePanelName
GO
/****** Object:  StoredProcedure [dbo].[USP_eExit_GetClearancePanel]    Script Date: 08/08/2012 21:51:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                              
-- Author:  Satya                                          
-- Create date: 6 Jun 2012                                        
-- Description: Display Role by Process  
-- =============================================                                           
ALTER PROCEDURE [dbo].[USP_eExit_GetClearancePanel]    
@1 VARCHAR(50)--RoleID    
AS    
SELECT ClearancePanelId AS Process FROM eExit_ClearancePanelMatrix WHERE RoleId=@1 AND Active=1
GO
/****** Object:  StoredProcedure [dbo].[USP_eExit_GetClearanceAssignPanelList]    Script Date: 08/08/2012 21:51:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                              
-- Author:  Pankaj Yadav                                          
-- Create date: 13 Jun 2012                                        
-- Description: Get Assign Clearance Panel List
-- =============================================                                           
ALTER PROCEDURE [dbo].[USP_eExit_GetClearanceAssignPanelList]  
@1 varchar(20)  
AS    
SET NOCOUNT ON ;
SELECT CPMM.ClearancePanelMatrixId 'ID' ,CPM.ClearancePanelName 'NAME' FROM eExit_ClearancePanelMatrix CPMM
INNER JOIN eExit_ClearancePanelMaster CPM 
ON (CPM.ClearancePanelId=CPMM.ClearancePanelId)
WHERE CPM.ACTIVE =1 AND CPMM.Active=1 AND CPMM.RoleId=@1
Order By ClearancePanelName
GO
/****** Object:  StoredProcedure [dbo].[USP_eExit_AssignPanel]    Script Date: 08/08/2012 21:51:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                            
-- Author:  Pankaj Yadav                            
-- Create date: 13 June 2012                            
-- Description: Assign Panel To Role                           
-- =============================================                            
ALTER PROCEDURE [dbo].[USP_eExit_AssignPanel]  --'110,111','101122','19'                          
(                            
  @1 VARCHAR(MAX),--PanelIds                            
  @2 VARCHAR(20),--UPDATEDBY                            
  @3 varchar(20)--Role ID  
)                            
AS                    
BEGIN                            
            
  DECLARE @ClearancePanelId varchar(50)                 
  DECLARE  @tempPanelList table                        
 (ClearancePanelId varchar(50))                        
   INSERT INTO @tempPanelList select  * from dbo.split(@1,',')                    
          
WHILE (SELECT Count(ClearancePanelId) From @tempPanelList) > 0                        
 BEGIN                        
  SELECT Top 1 @ClearancePanelId = ClearancePanelId  From @tempPanelList                        
  IF((SELECT COUNT(ClearancePanelMatrixId) FROM eExit_ClearancePanelMatrix WHERE ClearancePanelId=@ClearancePanelId AND RoleId=@3 ) > 0)                             
   BEGIN                        
    --Already Assigned                    
    UPDATE eExit_ClearancePanelMatrix                            
     SET [ClearancePanelId] = @ClearancePanelId                
  , RoleId =@3                
  ,UpdatedOn =GETDATE(),                
  ACTIVE=1                            
  ,[UpdatedBy] =@2   
  WHERE ClearancePanelId =@ClearancePanelId    AND RoleId=@3                      
   END                        
  ELSE                        
    BEGIN                        
     INSERT INTO eExit_ClearancePanelMatrix(ClearancePanelId,RoleId,Active,EntryDate ,EnteredBy)                        
     VALUES(@ClearancePanelId,@3, 1, GetDate(), @2)                        
   END                        
    DELETE @tempPanelList Where ClearancePanelId = @ClearancePanelId                        
 END            
          
                        
RETURN 1                      
End
GO
/****** Object:  StoredProcedure [dbo].[Usp_eExitBindQuestion]    Script Date: 08/08/2012 21:51:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Usp_eExitBindQuestion]    
          as    
          /*    
           Craeted By : Vikas    
           Created At : 11 June 2012    
           Desc : To Bind Question of Employee Feddback Form details of eExit Module    
          */         
          begin                            
          select QuesID, QuestionName from [eExit_FeedbackQuestion]      
          Where active=1     
          end
GO
/****** Object:  StoredProcedure [dbo].[USP_eExit_GetQuestionComment]    Script Date: 08/08/2012 21:51:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                                            
-- Author:  Satya                                                        
-- Create date: 8 Jun 2012                                                      
-- Description:Get Question Comments                                                                       
-- =============================================                                                         
ALTER PROCEDURE [dbo].[USP_eExit_GetQuestionComment] --100021                     
@1 VARCHAR(50)--userid                      
AS                          
IF EXISTS(SELECT ClearanceMatrixId FROM eExit_ClearanceEmployeeMatrix WHERE EmployeeId=@1 AND Active=1)                      
BEGIN                      
                  
SELECT p.QuestionId,                      
p.Answer,                      
CASE              
WHEN p.Answerbit=1              
THEN 'Yes'              
ELSE              
'No'              
END as AnswerCheck,            
t.QuestionName,                  
t.ClearancePanelId as Process                       
FROM eExit_ClearanceEmployeeMatrix p                       
INNER JOIN eExit_ClearanceQuestion t on p.QuestionId=t.QuestionId                      
WHERE p.Active=1 AND p.EmployeeId=@1 AND t.ClearancePanelId=1 order by t.QuestionNo                    
                  
                  
SELECT p.QuestionId,                      
p.Answer,                      
CASE              
WHEN p.Answerbit=1              
THEN 'Yes'              
ELSE              
'No'              
END as AnswerCheck,            
t.QuestionName,                  
t.ClearancePanelId as Process                        
FROM eExit_ClearanceEmployeeMatrix p                       
INNER JOIN eExit_ClearanceQuestion t ON p.QuestionId=t.QuestionId                      
WHERE p.Active=1 AND p.EmployeeId=@1 and t.ClearancePanelId=2 ORDER BY t.QuestionNo                    
                  
                  
SELECT           
p.QuestionId,                      
p.Answer,                      
CASE              
WHEN p.Answerbit=1              
THEN 'Yes'              
ELSE              
'No'              
END as AnswerCheck,                 
t.QuestionName,                  
t.ClearancePanelId as Process                       
FROM eExit_ClearanceEmployeeMatrix p                       
INNER JOIN eExit_ClearanceQuestion t on p.QuestionId=t.QuestionId                      
WHERE p.Active=1 AND p.EmployeeId=@1 AND t.ClearancePanelId=3  ORDER BY t.QuestionNo                   
                   
SELECT p.QuestionId,                      
p.Answer,                      
CASE              
WHEN p.Answerbit=1              
THEN 'Yes'              
ELSE              
'No'              
END as AnswerCheck,           
t.QuestionName,                  
t.ClearancePanelId as Process                       
FROM eExit_ClearanceEmployeeMatrix p                       
INNER JOIN eExit_ClearanceQuestion t ON p.QuestionId=t.QuestionId                      
WHERE p.Active=1 AND p.EmployeeId=@1 AND t.ClearancePanelId=4 ORDER BY t.QuestionNo  


SELECT p.QuestionId,                      
p.Answer,                      
CASE              
WHEN p.Answerbit=1              
THEN 'Yes'              
ELSE              
'No'              
END as AnswerCheck,           
t.QuestionName,                  
t.ClearancePanelId as Process                       
FROM eExit_ClearanceEmployeeMatrix p                       
INNER JOIN eExit_ClearanceQuestion t ON p.QuestionId=t.QuestionId                      
WHERE p.Active=1 AND p.EmployeeId=@1 AND t.ClearancePanelId=5 ORDER BY t.QuestionNo                    
                  
END
GO
/****** Object:  StoredProcedure [dbo].[USP_eExit_GetQuestion]    Script Date: 08/08/2012 21:51:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                                    
-- Author:  Satya                                                
-- Create date: 7 Jun 2012                                              
-- Description: Get Question List        
-- =============================================                                                 
ALTER PROCEDURE [dbo].[USP_eExit_GetQuestion] --100901           
@1 VARCHAR(50)--,--EMPID      
AS           
      
IF NOT EXISTS(SELECT ClearanceMatrixId FROM eExit_ClearanceEmployeeMatrix WHERE EmployeeId=@1 AND Active=1)         
 BEGIN      
      
  SELECT         
  QuestionId,        
  QuestionName,      
  CONVERT(bit,'false') AS Answerbit,      
  '' as Answer         
  FROM eExit_ClearanceQuestion         
  WHERE Active=1 AND ClearancePanelId=1       
          
  SELECT         
  QuestionId,        
  QuestionName,      
  CONVERT(bit,'false') AS Answerbit,      
  '' as Answer        
  FROM eExit_ClearanceQuestion         
  WHERE Active=1 AND ClearancePanelId=2          
         
  SELECT         
  QuestionId,        
  QuestionName,      
  CONVERT(bit,'false') AS Answerbit,      
  '' as Answer        
  FROM eExit_ClearanceQuestion         
  WHERE Active=1 AND ClearancePanelId=3         
         
  SELECT         
  QuestionId,        
  QuestionName,      
  CONVERT(bit,'false') AS Answerbit,      
  '' as Answer         
  FROM eExit_ClearanceQuestion        
  WHERE Active=1 AND ClearancePanelId=4  
  
  SELECT         
  QuestionId,        
  QuestionName,      
  CONVERT(bit,'false') AS Answerbit,      
  '' as Answer         
  FROM eExit_ClearanceQuestion        
  WHERE Active=1 AND ClearancePanelId=5  
  
      
 END      
       
 ELSE      
        
  BEGIN       
        
  IF EXISTS(SELECT p.QuestionId FROM eExit_ClearanceEmployeeMatrix p INNER JOIN eExit_ClearanceQuestion t ON p.QuestionId=t.QuestionId WHERE p.Active=1 AND p.EmployeeId=@1 AND t.ClearancePanelId=1)      
  BEGIN      
    SELECT       
    p.QuestionId,              
    p.Answer,              
    p.Answerbit,      
    t.QuestionName,          
    t.ClearancePanelId AS Process               
    FROM eExit_ClearanceEmployeeMatrix p               
    INNER JOIN eExit_ClearanceQuestion t on p.QuestionId=t.QuestionId              
    WHERE p.Active=1 AND p.EmployeeId=@1 AND t.ClearancePanelId=1 order by t.QuestionNo                
    END      
    ELSE      
    BEGIN      
    SELECT         
    QuestionId,        
    QuestionName,      
    CONVERT(bit,'false') AS Answerbit,      
    '' as Answer         
    FROM eExit_ClearanceQuestion         
    WHERE Active=1 AND ClearancePanelId=1       
    END      
          
    IF EXISTS(SELECT p.QuestionId FROM eExit_ClearanceEmployeeMatrix p INNER JOIN eExit_ClearanceQuestion t ON p.QuestionId=t.QuestionId WHERE p.Active=1 AND p.EmployeeId=@1 AND t.ClearancePanelId=2)      
  BEGIN      
    SELECT      
    p.QuestionId,      
    p.Answer,              
    p.Answerbit,           
    t.QuestionName,          
    t.ClearancePanelId AS Process               
    FROM eExit_ClearanceEmployeeMatrix p               
    INNER JOIN eExit_ClearanceQuestion t ON p.QuestionId=t.QuestionId              
    WHERE p.Active=1 AND p.EmployeeId=@1 and t.ClearancePanelId=2 ORDER BY t.QuestionNo            
    END      
    ELSE      
    BEGIN      
    SELECT         
    QuestionId,        
    QuestionName,      
    CONVERT(bit,'false') AS Answerbit,      
    '' as Answer        
    FROM eExit_ClearanceQuestion         
    WHERE Active=1 AND ClearancePanelId=2       
    END      
        
  IF EXISTS(SELECT p.QuestionId FROM eExit_ClearanceEmployeeMatrix p INNER JOIN eExit_ClearanceQuestion t ON p.QuestionId=t.QuestionId WHERE p.Active=1 AND p.EmployeeId=@1 AND t.ClearancePanelId=3)      
  BEGIN      
    SELECT       
    p.QuestionId,      
    p.Answer,      
    t.QuestionName,              
    p.Answerbit,          
    t.ClearancePanelId as Process               
    FROM eExit_ClearanceEmployeeMatrix p               
    INNER JOIN eExit_ClearanceQuestion t on p.QuestionId=t.QuestionId              
    WHERE p.Active=1 AND p.EmployeeId=@1 AND t.ClearancePanelId=3 ORDER BY t.QuestionNo   
     END      
     ELSE      
     BEGIN      
    SELECT         
    QuestionId,        
    QuestionName,      
    CONVERT(bit,'false') AS Answerbit,      
    '' as Answer        
    FROM eExit_ClearanceQuestion         
    WHERE Active=1 AND ClearancePanelId=3        
     END      
     IF EXISTS(SELECT p.QuestionId FROM eExit_ClearanceEmployeeMatrix p INNER JOIN eExit_ClearanceQuestion t ON p.QuestionId=t.QuestionId WHERE p.Active=1 AND p.EmployeeId=@1 AND t.ClearancePanelId=4)      
  BEGIN      
    SELECT       
    p.QuestionId,      
    p.Answer,              
    p.Answerbit,             
    t.QuestionName,          
    t.ClearancePanelId as Process               
    FROM eExit_ClearanceEmployeeMatrix p               
    INNER JOIN eExit_ClearanceQuestion t ON p.QuestionId=t.QuestionId              
    WHERE p.Active=1 AND p.EmployeeId=@1 AND t.ClearancePanelId=4 ORDER BY t.QuestionNo       
  END      
  ELSE      
  BEGIN      
    SELECT         
    QuestionId,        
    QuestionName,      
    CONVERT(bit,'false') AS Answerbit,      
    '' as Answer         
    FROM eExit_ClearanceQuestion        
    WHERE Active=1 AND ClearancePanelId=4      
  END                 
  
  IF EXISTS(SELECT p.QuestionId FROM eExit_ClearanceEmployeeMatrix p INNER JOIN eExit_ClearanceQuestion t ON p.QuestionId=t.QuestionId WHERE p.Active=1 AND p.EmployeeId=@1 AND t.ClearancePanelId=5)      
  BEGIN      
    SELECT       
    p.QuestionId,      
    p.Answer,              
    p.Answerbit,             
    t.QuestionName,          
    t.ClearancePanelId as Process               
    FROM eExit_ClearanceEmployeeMatrix p               
    INNER JOIN eExit_ClearanceQuestion t ON p.QuestionId=t.QuestionId              
    WHERE p.Active=1 AND p.EmployeeId=@1 AND t.ClearancePanelId=5 ORDER BY t.QuestionNo       
  END      
  ELSE      
  BEGIN      
    SELECT         
    QuestionId,        
    QuestionName,      
    CONVERT(bit,'false') AS Answerbit,      
    '' as Answer         
    FROM eExit_ClearanceQuestion        
    WHERE Active=1 AND ClearancePanelId=5      
  END                 
 END
GO
/****** Object:  StoredProcedure [dbo].[USP_ProductMasterList]    Script Date: 08/08/2012 21:51:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_ProductMasterList]      
@1 VARCHAR(50)--LanID        
AS        
SELECT        
dbo.ProductMaster.ProductID,        
dbo.ProductMaster.ProductName, 
dbo.ProductMaster.Description,        
dbo.ProductMaster.Image,        
dbo.ProductMaster.URL,        
ProductUserMatrix.LanID        
FROM dbo.ProductUserMatrix         
INNER JOIN dbo.ProductMaster ON dbo.ProductUserMatrix.ProductID=dbo.ProductMaster.ProductID        
WHERE dbo.ProductUserMatrix.LanID=@1 AND ProductMaster.Active=1 AND   ProductUserMatrix.Active=1  
UNION      
SELECT        
dbo.ProductMaster.ProductID,        
dbo.ProductMaster.ProductName,
dbo.ProductMaster.Description,        
dbo.ProductMaster.Image,        
dbo.ProductMaster.URL,        
 @1 as LanID    
FROM dbo.ProductMaster       
WHERE  ProductMaster.ProductName='ARMS' AND ProductMaster.Active=1
GO
/****** Object:  StoredProcedure [dbo].[USP_Product_AssignProductList]    Script Date: 08/08/2012 21:51:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================      
-- Author:  Satya      
-- Create date: 22 May 2012
-- Description: Assign Application ProductList    
-- =============================================      
ALTER PROCEDURE [dbo].[USP_Product_AssignProductList]  
@1 VARCHAR(50)--LANID  
AS  
 SELECT   
 ProductMaster.ProductID,  
ProductMaster.ProductName  
FROM   
ProductMaster  
 WHERE ProductMaster.ACTIVE=1 AND ProductMaster.ProductID   
 IN (SELECT ProductID FROM ProductUserMatrix WHERE LanID=@1 AND ProductUserMatrix.Active=1)
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_UpdateRoleMatrix]    Script Date: 08/08/2012 21:51:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  <Manish>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
ALTER PROCEDURE [dbo].[USP_Policy_UpdateRoleMatrix]  
@1 varchar(20),--[RoleID]  
@2 varchar(max),--[PolicyID]  
@3 varchar(20),--[CreatedBy]  
@4 varchar(20)--status  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
If (@4='Insert')  
 BEGIN  
   
  INSERT INTO [Policy_RoleMatrix] ([RoleID],[PolicyID],[Active],[CreatedOn],[CreatedBy])  
   select @1,String,1,getdate(),@3 from  dbo.split(@2,',')  
        return 1;
      END  
Else If (@4='Delete')  
 BEGIN  
 
 Update [Policy_RoleMatrix] 
 set Active=0 
 ,UpdatedOn=getdate()
 ,UpdatedBy=@3
 where [Active]=1 and [RoleID]=@1 and [PolicyID] in  (select String from  dbo.split(@2,','))  
 return 2;       
      END  
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_UpdatePolicyPage]    Script Date: 08/08/2012 21:51:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                                      
-- Author:Karan                                                                    
-- Created date: 27 June 2012    
-- Description: Update Policy Page Details                                                             
-- =============================================                             
------------------------------------------------------------------                            
ALTER PROCEDURE [dbo].[USP_Policy_UpdatePolicyPage] --1,'pd1','descr',300695,173,283                      
@1 INT,--PageNo                            
@2 TEXT,--Description                    
@3 VARCHAR(50),--Caption                           
@4 VARCHAR(50),--Updated By                            
@5 VARCHAR(50),--PolicyPageID                    
@6 INT,-- PolicyID    
@7 INT--Time Required                         
As                          
                        
                      
DECLARE @RESULT VARCHAR(50)                            
BEGIN              
                
IF EXISTS(SELECT PolicyPageID FROM PolicyPage WHERE PageNo=@1 AND PolicyID=@6 AND PolicyPageID<>@5 AND Active=1)                      
 BEGIN     
  SET @RESULT=-1     
 END    
 Else    
    BEGIN     
                               
     INSERT INTO PolicyMasterHistory(PolicyID,UpdatedOn,UpdatedBy)                            
     VALUES(@6,GETDATE(),@4)       
                              
   UPDATE PolicyPage                             
   SET  PageNo=@1,TimeRequired=@7,Description=@2,Caption=@3,UpdatedOn=GETDATE(),UpdatedBy=@4                             
   WHERE PolicyPageID=@5                            
    SET @RESULT=2                        
                        
                             
 END      
 RETURN @RESULT                
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_UpdatePolicy]    Script Date: 08/08/2012 21:51:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                          
-- Author:Satya                                                        
-- Created date: 16 May 2012        
-- Description: Update Policy Details                                                 
-- =============================================                 
------------------------------------------------------------------                
ALTER PROCEDURE [dbo].[USP_Policy_UpdatePolicy]                
@1 VARCHAR(200),--PolicyName                
--@2 INT,--TimeRequired               
@2 VARCHAR(50),--Updated By                
@3 VARCHAR(50)--Policy ID                
As                
                
DECLARE @PN VARCHAR(200)                
DECLARE @PTREQ INT            
DECLARE @RESULT VARCHAR(50)                
BEGIN                
                
                 
 DECLARE POLICY_CURSOR CURSOR                
 FOR SELECT PolicyName FROM PolicyMaster WHERE PolicyID=@3                
                
 OPEN POLICY_CURSOR                
 FETCH NEXT FROM POLICY_CURSOR INTO @PN,@PTREQ                
                
 WHILE (@@FETCH_STATUS = 0)                
  BEGIN                   
   INSERT INTO PolicyMasterHistory(PolicyID,PolicyName,UpdatedOn,UpdatedBy)                
   VALUES(@3,@PN,GETDATE(),@2)                
                  
   FETCH NEXT FROM POLICY_CURSOR INTO @PN,@PTREQ                  
                
  END                 
 CLOSE POLICY_CURSOR                 
 DEALLOCATE POLICY_CURSOR                
                
 UPDATE PolicyMaster                 
 SET  PolicyName=@1,UpdatedOn=GETDATE(),UpdatedBy=@2                 
 WHERE PolicyID=@3                
                
 SET @RESULT=@3                
 RETURN @RESULT                
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_UpdatePageNo]    Script Date: 08/08/2012 21:51:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                        
-- Author:Karan                                                      
-- Create date: 29 June 2012                                                  
-- Description:  Update Page No                                              
-- =============================================               
------------------------------------------------------------------              
ALTER PROCEDURE [dbo].[USP_Policy_UpdatePageNo]              
@1 VARCHAR(50),--PolicyPageID              
@2 INT,--PageNo      
@3 INT--CreatedBy            
AS    
BEGIN      
DECLARE @RESULT VARCHAR(50)  
  UPDATE PolicyPage     
  SET PageNo=@2,UpdatedOn=GETDATE(),UpdatedBy=@3    
  WHERE PolicyPageID=@1    
  SET @RESULT=1   
  RETURN @RESULT    
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_UnAlignedPolicy]    Script Date: 08/08/2012 21:51:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  <Manish>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
ALTER PROCEDURE [dbo].[USP_Policy_UnAlignedPolicy]  
@1 varchar(20) --roleID  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
 SELECT [PolicyID]  as 'Code'  
      ,[PolicyName] as 'Description'  
  FROM [PolicyMaster]  
  Where [Active]=1 and [PolicyID] not in (SELECT [PolicyID] FROM [Policy_RoleMatrix] Where RoleId=@1 and active=1)  
    
    
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_PolicyAcceptanceReport]    Script Date: 08/08/2012 21:51:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                                
-- Author:  Satya                                                               
-- Create date: 17 May 2012                                                          
-- Description:  Get Policy AcceptanceReport                                                       
-- =============================================                    
ALTER PROCEDURE [dbo].[USP_Policy_PolicyAcceptanceReport]  --57,5,5,'300625',101035                  
@1 VARCHAR(50),--CompanyID                  
@2 VARCHAR(50),--ProcessID                  
@3 VARCHAR(50),--SubProcessID                 
@4 VARCHAR(50),-- EmployeeID                
@5 VARCHAR(50)--UserID                   
AS                    
DECLARE @query VARCHAR(MAX) ,@ColumnList1 VARCHAR(max),@ColumnList2 VARCHAR(max)               
DECLARE @where VARCHAR (MAX)              
SET @where='  WHERE '              
            
IF(@1='0')            
BEGIN            
SET @where=''   
IF(@4<>'')              
BEGIN              
SET @where= @where+' WHERE  PolicyAcceptanceReport.[Employee ID]='+@4              
END           
END             
               
IF(@1<>'0')              
BEGIN              
SET @where=@where+'  PolicyAcceptanceReport.CompanyID='+@1     
  
IF(@4<>'')              
BEGIN              
SET @where= @where+' AND  PolicyAcceptanceReport.[Employee ID]='+@4              
END     
           
END            
                       
IF(@2<>'0')              
BEGIN              
SET @where= @where+' AND PolicyAcceptanceReport.ProcessID='+@2              
END              
              
IF(@3<>'0')              
BEGIN              
SET @where= @where+' AND PolicyAcceptanceReport.SubProcessID='+@3              
END              
  
                                           
                                        
 SET @ColumnList1=''                            
  SELECT                                         
   @ColumnList1 = @ColumnList1+'ISNULL(['+ PolicyName + '],''NA'') AS ['+ PolicyName + '],'    
FROM(SELECT PolicyName FROM PolicyMaster where  PolicyMaster.Active=1)p1             
                                                                                   
 SET @ColumnList2=''                            
  SELECT                                         
   @ColumnList2 = @ColumnList2 +'['+ PolicyName + '],'            
   FROM    (SELECT *  FROM PolicyMaster where  PolicyMaster.Active=1)p                
                 
  SET @ColumnList2 = SUBSTRING(@ColumnList2,1,DATALENGTH(@ColumnList2)-1)              
  SET @ColumnList1 = SUBSTRING(@ColumnList1,1,DATALENGTH(@ColumnList1)-1)        
        
SET @query=N'SELECT [Employee ID],[Employee Name],'+@ColumnList1+'         
FROM (SELECT [Employee ID] ,[Employee Name] ,PolicyName,DateStatus     
                  
  FROM             
PolicyAcceptanceReport'+@where+') AS P            
PIVOT              
(              
max(DateStatus) FOR PolicyName IN('+@ColumnList2+')) AS PV order by [Employee Name]'            
                    
PRINT @query                        
exec (@query)
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_InsertPolicyPage]    Script Date: 08/08/2012 21:51:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                      
-- Author: Karan                                                     
-- Create date: 26 June 2012       
-- Description: Insert PolicyPage Details                                             
-- =============================================       
      
ALTER PROCEDURE [dbo].[USP_Policy_InsertPolicyPage]             
@1 INT,--PolicyID             
@2 INT,--PageNo  
@3 INT,--TimeRequired                
@4 TEXT,--Description                
@5 VARCHAR(50),--Caption            
@6 INT--CreatedBy               
AS                
DECLARE @result VARCHAR(20)       
DECLARE @M INT         
BEGIN                
 IF EXISTS(SELECT PolicyPageID FROM PolicyPage WHERE PageNo=@2 AND PolicyID=@1 AND Active=1)                
 BEGIN                
 SET @result=-1                
 END                 
 ELSE                
 BEGIN               
 INSERT INTO PolicyPage(PolicyID,PageNo,TimeRequired,Description,Caption,Active,CreatedOn,CreatedBy)                
  VALUES(@1,@2,@3,@4,@5,'TRUE',GETDATE(),@6)                
 SET @result=1                
 END                
 RETURN @result                
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_InsertPolicy]    Script Date: 08/08/2012 21:51:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                        
-- Author: Satya                                                       
-- Created date: 16 May 2012                                                       
-- Description: Insert Policy Details                                               
-- =============================================                                                        
ALTER PROCEDURE [dbo].[USP_Policy_InsertPolicy]              
@1 VARCHAR(200),--PolicyName              
--@2 NVARCHAR(MAX),--TimeRequired              
@2 VARCHAR(50)--CreatedBy              
AS              
DECLARE @result VARCHAR(20)          
DECLARE @M INT              
BEGIN              
 IF EXISTS(SELECT PolicyID FROM PolicyMaster WHERE PolicyName=@1 AND Active=1)              
 BEGIN              
 SET @result=-1              
 END               
 ELSE              
 BEGIN              
  INSERT INTO PolicyMaster(PolicyName,Active,CreatedOn,CreatedBy)              
  VALUES(@1,'TRUE',GETDATE(),@2)            
  SET @M=@@IDENTITY            
 SET @result=@M              
 END              
 RETURN @result              
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_GetUserPolicies]    Script Date: 08/08/2012 21:51:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                      
-- Author:  Karan                                                     
-- Create date: 09 July 2012                                                
-- Description:   Get User Role Policies                                             
-- =============================================    

ALTER PROCEDURE [dbo].[USP_Policy_GetUserPolicies]
@1 VARCHAR(50),--RoleID
@2 VARCHAR(50)--EmpID
AS
BEGIN
DECLARE @RESULT VARCHAR(50) 

set @RESULT=(select Count(Policy_RoleMatrix.PolicyID) from Policy_RoleMatrix
inner join PolicyAcceptance on PolicyAcceptance.PolicyID=Policy_RoleMatrix.PolicyID
and PolicyAcceptance.Active=0
and PolicyAcceptance.EmployeeID=@2
where RoleID=@1)

return @result
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_GetRole]    Script Date: 08/08/2012 21:51:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Manish>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[USP_Policy_GetRole]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
Select RoleId as 'ID',
RoleName as 'Description'
from RoleMaster where Active=1
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_GetRemainPolicies]    Script Date: 08/08/2012 21:51:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                          
-- Author:  Karan                                                         
-- Create date: 09 July 2012                                                    
-- Description:   Get Remain Policies                                                 
-- =============================================        
    
ALTER PROCEDURE [dbo].[USP_Policy_GetRemainPolicies] --2,101122    
@1 VARCHAR(50),--RoleID    
@2 VARCHAR(50)--EmpID    
AS    
BEGIN    
DECLARE @RESULT VARCHAR(10)    



    
(select @RESULT= COUNT(policyID) from PolicyMaster where Active=1
and PolicyID not in(select PolicyID from PolicyAcceptance where EmployeeID=@2 and  Active=1)
)

--select 
--	@RESULT=  (Count(Rm.PolicyID)-(  
--						 select COUNT(*)   
--						 from PolicyAcceptance    
--						 where EmployeeID=@2 and  Active=1))    
--from Policy_RoleMatrix RM  inner join PolicyMaster p  on p.PolicyID=RM.PolicyID  
--where RoleID=@1  and p.Active=1  and RM.PolicyID  in (select PolicyID from PolicyMaster where Active=1) 
    
RETURN @RESULT    
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_GetPolicyPageTimeRequired]    Script Date: 08/08/2012 21:51:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                                          
-- Author: Karan                                                                        
-- Created date: 18 July 2012                                                                           
-- Description: GetPolicyPageTimeRequired                                                               
-- =============================================                                 
------------------------------------------------------------------        
ALTER PROCEDURE [dbo].[USP_Policy_GetPolicyPageTimeRequired]-- 4,300695,1         
@1 VARCHAR(50),--RoleID                  
@2 VARCHAR(50),--EmployeeID    
@3 INT-- PolicyPageNo    
AS                  
      
      
select  PolicyMaster.PolicyID,PolicyPage.TimeRequired As PolicyPageTimeReq from PolicyMaster inner join PolicyPage on PolicyMaster.PolicyID=PolicyPage.PolicyID       
where PolicyMaster.PolicyID in      
(      
SELECT TOP 1                   
PolicyID                          
FROM                   
PolicyMaster                   
WHERE                 
              
PolicyID in (select PolicyID from Policy_RoleMatrix where Active=1 and RoleID=@1)               
and               
PolicyMaster.PolicyID NOT IN(SELECT PolicyAcceptance.PolicyID FROM PolicyAcceptance where PolicyAcceptance.EmployeeID=@2 AND   Active=1 ) AND PolicyMaster.Active=1  and PolicyPage.Active=1 and PolicyPage.PageNo=@3    
)
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_GetPolicyPageNo]    Script Date: 08/08/2012 21:51:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                
-- Author: Karan                                               
-- Create date: 21-June-2012                                          
-- Description: Get Policy PageNo                                       
-- =============================================                                                
ALTER PROCEDURE [dbo].[USP_Policy_GetPolicyPageNo]   
@1 VARCHAR(50)--PolicyName  
AS    
DECLARE @result VARCHAR(200)  
  
IF EXISTS(SELECT PolicyID FROM PolicyMaster WHERE PolicyName=@1 AND Active =1)  
BEGIN  
SELECT PolicyPageID,PageNo,Description FROM PolicyPage  
WHERE PolicyID IN (SELECT PolicyID FROM PolicyMaster WHERE PolicyName=@1 AND Active =1)  
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_GetPolicyPageDetails]    Script Date: 08/08/2012 21:51:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                                
-- Author: Karan                                                               
-- Create date: 26 June 2012                                                          
-- Description: GetPolicyPageDetails                                                       
-- =============================================                       
ALTER PROCEDURE [dbo].[USP_Policy_GetPolicyPageDetails]            
@1 INT--PolicyID                  
AS          
BEGIN                  
SELECT                    
PolicyPageID,       
PolicyID,                   
PageNo,  
TimeRequired,                    
Caption                    
FROM                     
PolicyPage WHERE PolicyID=@1 AND Active=1                  
order by PageNo ASC        
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_EmployeePolicyAcceptanced]    Script Date: 08/08/2012 21:51:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                    
-- Author:  Satya                                                   
-- Create date: 17 May 2012                                              
-- Description:   Insert Policy Acceptance                                           
-- =============================================  
ALTER PROCEDURE [dbo].[USP_Policy_EmployeePolicyAcceptanced]      
@1 VARCHAR(50),--PolicyId      
@2 varchar(50),--Userid  
@3 VARCHAR(50)--Accept      
AS      
BEGIN      
DECLARE @RESULT VARCHAR(50)      
  IF NOT EXISTS(SELECT * FROM PolicyAcceptance WHERE EmployeeID=@2 AND PolicyID=@1 and Active=1)      
  BEGIN   
       
   if(@3<>'0')  
   begin  
   INSERT INTO PolicyAcceptance(PolicyID,EmployeeID,Active,AcceptedOn)       
   VALUES(@1,@2,'TRUE',GETDATE())      
   SET @RESULT=1      
   end  
     
   else  
   begin  
   INSERT INTO PolicyAcceptance(PolicyID,EmployeeID,Active,AcceptedOn)       
   VALUES(@1,@2,'FALSE',GETDATE())      
   SET @RESULT=1     
   end  
     
  END      
      
  ELSE      
  BEGIN      
   SET @RESULT=-1      
  END      
RETURN @RESULT      
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_EmployeePolicyAcceptance1]    Script Date: 08/08/2012 21:51:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_Policy_EmployeePolicyAcceptance1] --2,300625
@1 VARCHAR(50),--RoleID            
@2 VARCHAR(50)--lANID   
AS
select  PolicyMaster.PolicyID,PolicyMaster.PolicyName,PolicyMaster.TimeRequired, PolicyPage.Description from PolicyMaster inner join PolicyPage 
on PolicyMaster.PolicyID=PolicyPage.PolicyID
where PolicyMaster.Active=1 and PolicyPage.Active=1 and PolicyMaster.PolicyID NOT IN(SELECT PolicyAcceptance.PolicyID FROM PolicyAcceptance where PolicyAcceptance.EmployeeID=@2 AND   Active=1 )
AND PolicyMaster.PolicyID IN(select PolicyID from Policy_RoleMatrix where Active=1 and RoleID=@1)
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_EmployeePolicyAcceptance]    Script Date: 08/08/2012 21:51:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                                            
-- Author:Satya                                                                          
-- Created date: 16 May 2012                                                                             
-- Description: EmployeePolicyAcceptance                                                                  
-- =============================================                                   
------------------------------------------------------------------          
ALTER PROCEDURE [dbo].[USP_Policy_EmployeePolicyAcceptance]   
@1 VARCHAR(50),--RoleID                    
@2 VARCHAR(50)--lANID            
AS                    
  
--Declare  
--@1 VARCHAR(50),--RoleID                    
--@2 VARCHAR(50)--lANID          
  
--set @1='4'    
--set @2='300695'  
        
        
 select  PolicyMaster.PolicyID  
   ,PolicyMaster.PolicyName  
   ,PolicyPage.PageNo  
   ,PolicyPage.TimeRequired   
   , PolicyPage.Description   
 from   
 PolicyMaster inner join PolicyPage on PolicyMaster.PolicyID=PolicyPage.PolicyID      
 where PolicyMaster.PolicyID in        
  (        
   SELECT TOP 1 PolicyID FROM PolicyMaster   
   WHERE PolicyID in (select PolicyID from Policy_RoleMatrix where Active=1 and RoleID=@1)                 
     and                 
     PolicyMaster.PolicyID NOT IN(SELECT PolicyAcceptance.PolicyID FROM PolicyAcceptance   
             where PolicyAcceptance.EmployeeID=@2 AND   Active=1 )   
     AND   
     PolicyMaster.Active=1  and PolicyPage.Active=1        
  )
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_EditPolicyPageDetails]    Script Date: 08/08/2012 21:51:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                  
-- Author: Karan                                                 
-- Created date: 27 June 2012                                             
-- Description: Edit Policy Page Details                                         
-- =============================================                                                             
ALTER PROCEDURE [dbo].[USP_Policy_EditPolicyPageDetails]               
@1 varchar(50)--PolicyPageID               
AS                
SELECT              
PageNo,  
TimeRequired,   
Caption,    
Description        
FROM dbo.PolicyPage        
WHERE PolicyPageID=@1
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_EditPolicyDetails]    Script Date: 08/08/2012 21:51:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                
-- Author:Satya                                              
-- Created date: 25 June 2012    
-- Description:  Edit Policy Details                                       
-- =============================================                                                           
ALTER PROCEDURE [dbo].[USP_Policy_EditPolicyDetails]             
@1 varchar(50)--Policy ID             
AS              
SELECT            
PolicyName      
--TimeRequired      
FROM dbo.PolicyMaster      
WHERE PolicyID=@1
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_DeletePolicyPage]    Script Date: 08/08/2012 21:51:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                            
-- Author:Karan                                           
-- Create date:26 June 2012                                      
-- Description:  Inactive Policy Page Details                                   
-- =============================================                                       
ALTER PROCEDURE [dbo].[USP_Policy_DeletePolicyPage]             
 @1 VARCHAR(50), --PolicyPageID            
 @2 VARCHAR(50) --userID            
AS            
BEGIN            
DECLARE @result VARCHAR(50)          
IF EXISTS(SELECT PolicyPageID  FROM dbo.PolicyPage  WHERE PolicyPageID=@1 AND Active=1)          
  BEGIN            
  UPDATE PolicyPage SET Active=0 ,UpdatedOn=getdate(), UpdatedBy=@2            
  WHERE  PolicyPageID=@1      
    
  SET @result=1            
  END            
ELSE            
  BEGIN            
  SET @result=-1           
  END            
            
RETURN @result            
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_DeletePolicyMaster]    Script Date: 08/08/2012 21:51:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                          
-- Author:  Satya                                         
-- Create date: 16 May 2012                                    
-- Description:  Inactive Policy Details                                 
-- =============================================                                     
ALTER PROCEDURE [dbo].[USP_Policy_DeletePolicyMaster]           
 @1 VARCHAR(50), --PolicyID          
 @2 VARCHAR(50) --userID          
AS          
BEGIN          
DECLARE @result VARCHAR(50)        
IF EXISTS(SELECT PolicyID  FROM dbo.PolicyMaster  WHERE PolicyID=@1 AND Active=1)        
  BEGIN          
  UPDATE PolicyMaster SET Active=0 ,UpdatedOn=getdate(), UpdatedBy=@2          
  WHERE  PolicyID=@1    
  
  SET @result=1          
  END          
ELSE          
  BEGIN          
  SET @result=-1         
  END          
          
RETURN @result          
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_AlignedPolicy]    Script Date: 08/08/2012 21:51:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Manish>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[USP_Policy_AlignedPolicy]
@1 varchar(20) --roleID
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 SELECT [PolicyID]  as 'Code'
      ,[PolicyName] as 'Description'
  FROM [PolicyMaster]
  Where [Active]=1 and [PolicyID] in (SELECT [PolicyID] FROM [Policy_RoleMatrix] Where RoleId=@1 and active=1)
  
  
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetPolicyPageDesc]    Script Date: 08/08/2012 21:51:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: KARAN
-- Create date: 21-JUNE-2012
-- Description:	GET POLICY PAGE DESCRIPTION
-- =============================================
ALTER PROCEDURE [dbo].[USP_GetPolicyPageDesc]
@1 VARCHAR(50)-- PolicyPageID		
AS
BEGIN
select PolicyPage.Description
 from PolicyPage
 where PolicyPageID=@1
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Product_GetProductList]    Script Date: 08/08/2012 21:51:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================      
-- Author:  Satya      
-- Create date: 22 May 2012
-- Description: Get Application ProductList    
-- =============================================      
ALTER PROCEDURE [dbo].[USP_Product_GetProductList]  
@1 VARCHAR(50)--EmployeeID  
As  
  
DECLARE @where VARCHAR(MAX)  
  
if(@1='0')  
BEGIN  
 SELECT   
  ProductMaster.ProductID,  
  ProductMaster.ProductName  
  FROM ProductMaster   
  WHERE ProductMaster.Active=1  
END  
  
ELSE  
BEGIN  
SELECT   
ProductMaster.ProductID,  
ProductMaster.ProductName  
 FROM   
 ProductMaster  
 WHERE ProductMaster.ACTIVE=1   
 AND ProductMaster.ProductID  NOT IN (SELECT ProductID FROM ProductUserMatrix WHERE LanID=@1 and ProductUserMatrix.Active=1)  
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Policy_GetPolicyDetails]    Script Date: 08/08/2012 21:51:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                              
-- Author: Satya                                                           
-- Created date: 28 June 2012                                                        
-- Description: Get Policy Details                                                     
-- =============================================                     
ALTER PROCEDURE [dbo].[USP_Policy_GetPolicyDetails]                  
AS                  
SELECT                  
PolicyID,                  
PolicyName,                  
--TimeRequired,          
dbo.GetPolicyCaption(PolicyID) AS Caption          
FROM                   
PolicyMaster WHERE Active=1                
order by PolicyName asc
GO
/****** Object:  StoredProcedure [dbo].[USP_EDB_insertTeam]    Script Date: 08/08/2012 21:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[USP_EDB_insertTeam]
	@1 varchar(50),-- Team Code
	@2 varchar(100),--Team name
	@3 varchar(50),	--SubProcess ID
	@4 varchar(50)	--Created By	

AS
BEGIN
Declare @result varchar(50)


if not exists(select * from teamMaster where (teamName=@2 or teamCode=@1) and subprocessID=@3 and active=1)
		Begin
					insert into teamMaster (teamCode, teamName, subprocessID, active, createdDate, createdBy)
											values(@1, @2, @3,1, getdate(), @4)
				set @result=1

		End
else
		Begin
					set @result=-1

		End


return @result
END
GO
/****** Object:  StoredProcedure [dbo].[USP_EDB_editTeam]    Script Date: 08/08/2012 21:51:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[USP_EDB_editTeam]
	@1 varchar(50),-- team Code
	@2 varchar(100),--team name
	@3 varchar(50),	--subProcessID
	@4 varchar(50),	--editeted By	
	@5 varchar(50)	--Team ID	

AS
BEGIN
Declare @result varchar(50)

					update teamMaster 
						set teamCode=@1, 
							teamName=@2, 
							subprocessID=@3, 
							lastUpdated=getdate(), 
							updatedBy=@4
					where teamID=@5
				
set @result=2


return @result
END
GO
/****** Object:  UserDefinedFunction [dbo].[CheckLastDayWorked]    Script Date: 08/08/2012 21:51:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[CheckLastDayWorked] --'101313'          
       (          
       @EmployeeID VARCHAR(20)          
        )         
        RETURNS int        
    AS          
     /*           
  Craeted By : Vikas          
  Created At : 27 June 2012          
  Desc : To check last 2 working day for feedback form show         
 */          
   begin        
         declare @FirstDay varchar(20)        
   declare @Result int = 0        
   declare @LastDay Varchar(20)        
           
   Set @LastDay = (Select Ea.LastDayWorked from EmployeeMaster Ea where Ea.EmployeeID=@EmployeeID   
                     and Ea.LastDayWorked >= (GETDATE())-30 )--and EmployeementStatusID not in (2,5))           
   set @FirstDay = DATEDIFF(dd,GETDATE(),@LastDay)        
           
    if (@FirstDay <= 2)        
     begin            
    Set @Result = 1           
     end        
   -- Print @Result            
     Return @Result            
              
  end
GO
/****** Object:  UserDefinedFunction [dbo].[PanelName]    Script Date: 08/08/2012 21:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[PanelName](@empid varchar(50))  
returns varchar(max)  
AS  
BEGIN  
declare @panelName varchar(max)  
set @panelName=''  
SELECT   @panelName=@panelName+(case when cq.ClearancePanelId=1 then 'Department' when cq.ClearancePanelId=2 then 'IT' when cq.ClearancePanelId=3 then 'Admin' when cq.ClearancePanelId=4 then 'Finance' else 'HR' end )   +','    
FROM           
dbo.EmployeeMaster AS EM LEFT OUTER JOIN eExit_ClearanceEmployeeMatrix cem  
ON EM.EmployeeID=cem.EmployeeId       
Inner join eExit_ClearanceQuestion cq on cq.QuestionId=cem.QuestionId  
inner join eExit_ClearancePanelMaster cpm on cpm.ClearancePanelId=cq.ClearancePanelId  
where EM.EmployeeID=@empid  AND cem.Active=1
group by ClearancePanelName,cq.ClearancePanelId  
 set @panelName= substring(@panelName,0,len(@panelName))  
 IF(@panelName='')  
 BEGIN  
SET  @panelName='N/A'  
 END  
 RETURN @panelName  
 --print @panelName  
END
GO
/****** Object:  StoredProcedure [dbo].[MatchEmployeeId]    Script Date: 08/08/2012 21:51:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MatchEmployeeId]
       as  
      select EmployeeID from EmployeeMaster where EmployeeID in (select EmployeeID  from EmployeeAttendanceProcessMatrix )
GO
/****** Object:  StoredProcedure [dbo].[USP_AlertEmployeeLeaveStatementMonthly]    Script Date: 08/08/2012 21:51:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_AlertEmployeeLeaveStatementMonthly]--'07/05/2012','07/11/2012','300370'
 @1 varchar(50),--Start Date                                                        
 @2 varchar(50),--End Date
 @5 varchar(50)--Employee ID                                                           
-- @6 varchar(50)--UserID                            
          
AS              

--DECLARE                                                           
-- @1 varchar(50),--Start Date                                                        
-- @2 varchar(50),--End Date                                                           
-- @3 varchar(50),--Company ID                                                           
-- @4 varchar(50),--Process ID                                                           
-- @5 varchar(50),--Employee ID                                                           
-- @6 varchar(50),--UserID                                 
                                             
--SET @1='4/21/2012'                                                            
--SET @2='5/2/2012'                                                     
--SET @3='0'                                     
--SET @4='0'                                     
--SET @5=''                                                     



                                                       
DECLARE @StartDate varchar(50),@EndDate varchar(50)                                                            
 SET @StartDate=Convert(varchar(20),@1,101)                                                           
 SET @EndDate=Convert(varchar(20),@2,101)    
                           
--SET @1=CONVERT(VARCHAR,CAST(@1 AS DATETIME),103)
--SET @2=CONVERT(VARCHAR,CAST(@2 AS DATETIME),103)

DECLARE                                               
 @query VARCHAR(MAX)                                              
 ,@ColumnList VARCHAR(max)                                              
 ,@where varchar(1000)                            
 ,@reporting varchar(max)                            
 ,@roleID int              
 ,@reportingType varchar(50)                             

 set @roleID=ISNULL(@roleID,2)                                              


declare @table table (Date datetime)                                                            
insert into @table select * from USP_EDB_GetDatesFromTwoDates(@StartDate,@EndDate)
                            

SELECT @ColumnList = COALESCE(@ColumnList+''']'+',' ,'') + '['''+convert(varchar(12),Date,106) from @table order by Date
set @ColumnList=@ColumnList+''']'                            

if OBJECT_ID('tempdb..#TableData') is not null                            
Begin                            
drop table #TableData                            
End

--create table #tblEmployee (employeeID int)                            

set @where=''                                              


if(@5<>'')                                              
 Begin                                              
  set @where=@where +' and EM.EmployeeID='+@5                                    
 End                                 

--select * from #tblEmployee    

------------------------------------------------------------------------------
DECLARE @ColList varchar(Max)  
DECLARE @ColName varchar(100)  
DECLARE @ColList2 varchar(Max)  
SET @ColList = ''  
SET @ColList2 = ''  
SET @ColName = ''  
  
DECLARE AllColList CURSOR FOR  
select CONVERT(VARCHAR, DATE, 106) from USP_EDB_GetDatesFromTwoDates(@StartDate,@EndDate)  
 OPEN AllColList  
 FETCH NEXT FROM AllColList INTO @ColName  
 WHILE @@FETCH_STATUS = 0                        
    BEGIN                        
 SET @ColList = @ColList + '<td class="style2" style="font-size: 9pt">' + @ColName + '</td>'  
 SET @ColList2 = @ColList2 + '<td class="style2" style="font-size: 9pt">'''+ '+' + '['''+ @ColName + ''']' +'+' + '''</td>'  
    FETCH NEXT FROM AllColList INTO @ColName                       
    END                        
CLOSE AllColList                        
DEALLOCATE AllColList     
  
DECLARE @TableHeardes varchar(Max)  
SET @TableHeardes = ''  
SET @TableHeardes = '<td class="style2" width="20px" style="background-color: #528DD1">                       
           DATE                    
           </td>                                  
         <td class="style2" width="20px" style="background-color: #528DD1">                       
           STATUS                      
           </td>'                          
                        
           
          
--Body  
DECLARE @empName varchar(300)      
  ,@empID varchar(50)     
  ,@mailto varchar(100)
  
    SELECT @empName=isnull(FirstName,'')+isnull(MiddleName,'')+' '+isnull(LastName,'')+' ('+@5+')',     
      @mailto=EmailID    
    FROM EmployeeMaster    
    WHERE (EmployeeID = @5)
    
DECLARE @Cmonth VARCHAR(50)  
DECLARE @EmailBody varchar(Max)
--SET @Cmonth=DATENAME(MM,GETDATE())  
SET @EmailBody =  '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">              
<html>              
 <head>              
<style type="text/css">              
    body              
    {              
        font-size:13px;              
        font-family:Arial;              
    }              
    </style>              
  <title></title>              
   </head>              
 <body class="style2" style="font-size: 9pt">

 Dear '+@empName+',<br/> <br/>Your attendance report from "'+@1+ '" to "'+@2+'"<br/><br/><table cellpadding="5" cellspacing="0" border="1" width="50%" style="font-size: 9pt"><tr>' + @TableHeardes +'</td></tr>'
  
--DECLARE @ColumnCount AS Int  
--DECLARE @TableData AS Table (ID VArchar(20))  
--select @ColumnCount = COUNT(DATE)from USP_EDB_GetDatesFromTwoDates(Cast('01/01/2012' As Date),Cast('01/31/2012' As Date))  
--SET @ColumnCount = @ColumnCount + 6  
  
  
set @query ='                                                  
select ''<tr><td class="style2" style="font-size: 9pt">'' + DATEAPPLIED + ''</td><td>'' + LEAVETYPE +''</td></tr>''   
  FROM
(                         
SELECT     dbo.GetEmpID(EM.EmployeeID) AS [Employee ID]                                                
, ISNULL(EM.FirstName + ''  '', '''') + ISNULL(EM.MiddleName + '' '', '''')+ ISNULL(EM.LastName + '' '', '''') AS Name                                                
, EmployementStatus.EmployementStatus AS Status                                                
, DM.Designation, PM.ProcessName AS Process                                                
, DepM.DepartmentName AS Department                                            
,''LeaveType''=dbo.fn_Get_EmpAttendanceStatus(EM.EmployeeID,GD.DATE)
                                                                      
,''''+convert(varchar(12),GD.DATE,106) + '''' as DATEAPPLIED            
                                                
FROM         dbo.USP_EDB_GetDatesFromTwoDates('''+ @StartDate +''', '''+ @EndDate +''') AS GD CROSS JOIN                                                
                      EmployeeMaster AS EM INNER JOIN                                                
                      TeamMaster ON EM.TeamID = TeamMaster.TeamID INNER JOIN                                                
                      SubProcessMaster ON TeamMaster.SubProcessID = SubProcessMaster.SubProcessID INNER JOIN                                         
                      ProcessMaster AS PM ON SubProcessMaster.ProcessID = PM.ProcessID INNER JOIN                                                
                      DesignationMaster AS DM ON EM.DesignationID = DM.DesignationID INNER JOIN                                                
               EmployementStatus ON EM.EmployeementStatusID = EmployementStatus.EmployementStatusID INNER JOIN                                                
                      DepartmentMaster AS DepM ON PM.DepartmentID = DepM.DepartmentID 
        --LEFT OUTER JOIN                                                
        --EmployeeAttendance AS EA ON CAST(EM.EmployeeID AS varchar) = EA.EmployeeID AND GD.DATE = EA.IODate AND EA.IOStatus = ''Entry''                                                 
--LEFT OUTER JOIN   LeaveDetails AS LD ON EM.EmployeeID = LD.EmployeeID AND GD.DATE = LD.DateApplied AND LD.LeaveStatusID IN (16, 12)                                                
LEFT OUTER JOIN   HolidayMaster AS HM ON EM.companyID=HM.companyID and  GD.Date=HM.HOLIDAYDATE                                                
WHERE (EM.Active = 1)             
and  EM.employeeID  in ('+@5+')                      
    '+ @where +'                              
)            
AS SourceTablE'
   
  --PRINT @ColList2--1
  --1
  --PRINT @EmailBody
  print (@query) 
Create Table #TableData (RowData VARCHAR(MAX)) 
  
INSERT INTO #TableData  
Exec (@query) 
--print (@query) 
  
--Select * from #TableData --2
  
DECLARE @RowData VArchar(MAX)  
DECLARE @EmailMessage VArchar(MAX)
  
        
DECLARE @mailSubject varchar(100)    
  
  
SET @EmailMessage = ''  
SET @RowData = ''  
  
DECLARE TableDate CURSOR FOR  
select RowData from #TableData 
 
 OPEN TableDate  
 
 FETCH NEXT FROM TableDate INTO @RowData  
 WHILE @@FETCH_STATUS = 0                        
    BEGIN                        
   
 SET @EmailMessage = @EmailMessage + @RowData  

    FETCH NEXT FROM TableDate INTO @RowData 
    
    
                          
    END                        
CLOSE TableDate  
DEALLOCATE TableDate  
  
  
SET @EmailBody = @EmailBody + @EmailMessage + '</table><br/><br/><table class="style2" style="font-size: 9pt"><tr ><td class="style2">Regards,<br/>Human Resources Development<br/>Accretive Health</td></tr></table></body></html>' 

 ----Added for mail-------------

  set @mailSubject='ARMS-Monthly attendance report for-'+@empName+' from "'+@1+'" to "'+@2+'"'
  
  if(@mailto is not null and  @mailto !='')
		Begin
		EXEC msdb.dbo.sp_send_dbmail  @profile_name = 'ARMS',        
		--@recipients =@mailto,  
		 @recipients ='raggarwal@accretivehealth.com',--'amjoshi@accretivehealth.com',          
		 @subject =  @mailSubject,        
		 @body = @EmailBody,        
		 @body_format = 'HTML',        
		 @importance =  'HIGH' ;        
		   
		End
  -------------------------------------------- 
  
--PRINT @EmailBody
GO
/****** Object:  StoredProcedure [dbo].[USP_EDB_GetPunchCardReport]    Script Date: 08/08/2012 21:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================      
-- Author:  Nasim    
-- Create date: 2 Nov 2011    
-- Description: Get punch card details    
-- =============================================      
      
      
ALTER PROCEDURE [dbo].[USP_EDB_GetPunchCardReport]  --'01/17/2012'    
--declare    
@1 varchar(50)--date      
    
as    
Begin    
    
declare @date datetime    
    
set @date=cast(@1 as datetime)    
    
    
SELECT  EM.EmployeeID,     
  employeeName=isnull(EM.FirstName,'')+' '+isnull(EM.MiddleName,'')+' '+isnull(EM.LastName,'') ,    
  'IODate'=@1,    
  'IOTime'=(SELECT max(IOTime) FROM EmployeeAttendance EA WHERE (IOStatus = N'Entry') and (IODate=@date) and EA.employeeID=cast(EM.employeeID as varchar)),    
  'Card Punch'=case (SELECT count(AttendanceID) FROM EmployeeAttendance EA WHERE (IOStatus = N'Entry') and (IODate=@date) and EA.employeeID=cast(EM.employeeID as varchar))    
     when 0 then 'No' else 'Yes' end    
FROM  EmployeeMaster EM    
where  (EM.EmployeementStatusID in (1,12)) AND (EM.Active = 1)    
    
    
--    
--SELECT     EM.EmployeeID, EM.FirstName, EM.MiddleName, EM.LastName, EA.IODate, EA.IOTime, EA.IOStatus,    
--   'Card Punched'=case EA.IOStatus    
--FROM         EmployeeMaster AS EM LEFT OUTER JOIN    
--                      EmployeeAttendance AS EA ON CAST(EM.EmployeeID AS varchar) = EA.EmployeeID    
--WHERE     (EM.EmployeementStatusID = 1) AND (EM.Active = 1) AND (EA.IODate = @date)    
--    
--    
--    
--    
--    
--SELECT     EA.AttendanceID, EA.EmployeeID, EA.HolderNo, EA.HolderName,     
--                      EA.IODate, EA.IOTime, EA.IOStatus    
--FROM         EmployeeAttendance INNER JOIN    
--                      EmployeeMaster ON EA.EmployeeID = cast(EM.EmployeeID as varchar)    
--WHERE     (EA.IOStatus = N'Entry') and (EA.IODate=@date)    
--ORDER BY EA.employeeID DESC    
    
End
GO
/****** Object:  StoredProcedure [dbo].[USP_EexitCheckLastDayWorked]    Script Date: 08/08/2012 21:51:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_EexitCheckLastDayWorked] -- '300455'  
       (  
        @1 varchar(50) --Empid   
        )  
    AS  
    /*   
		Craeted By : Vikas  
		Created At : 27 June 2012  
		Desc : To check Employee ID in eExit_FeedbackEmployeeMatrix tbl 
	*/  
		Begin
		 declare @FirstDay varchar(20)
		 declare @Result int = 0
		 declare @LastDay Varchar(20)
		 
		 Set @LastDay = (Select Ea.LastDayWorked from EmployeeMaster Ea where EmployeeID=@1)		 
		 set @FirstDay = DATEDIFF(dd,GETDATE(),@LastDay)
		 
			--print @FirstDay
 
		  if (@FirstDay <= 2)
			  begin		  
				Set @Result = 1	  
			  end
		  Print @Result			 
	    Return @Result
  End
GO
/****** Object:  StoredProcedure [dbo].[USP_eExitUpdateResignationStatus]    Script Date: 08/08/2012 21:51:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                        
-- Author:  Nasim                    
-- Create date: 17 Jan 2012                  
-- Description: Update resignation status                  
-- =============================================                                        
ALTER PROCEDURE [dbo].[USP_eExitUpdateResignationStatus]                  
--declare                    
@1 varchar(20), --resignationID                
@2 varchar(20), --Last day worked              
@3 varchar(500), --Remarks              
@4 varchar(20), --status                  
@5 varchar(20), --userID                  
@6 varchar(50), --Attrition Reason    
@7 varchar(20), --Rating    
@8 varchar(20), --Next Employer    
@9 varchar(20), --Hike    
@10 varchar(20) --Replacement action    
    
AS                                    
BEGIN                    
SET NOCOUNT ON;                      
Declare @result int                 
,@employeeID int                
,@resignationDate datetime      
,@lastdayworked datetime                
                  
--set @1='4'                    
--set @2='2/12/2012'                    
--set @3='Remarks'                    
--set @4='2'                    
--set @5='101062'     
                   
              
SET @result=1                  
                  
UPDATE    EmployeeResignation                  
SET              ResignationStatusID = @4, LastUpdatedOn = GETDATE(), Updatedby = @5,LastDayWorked=@2                  
WHERE     (ResignationID = @1)                 
            
            
INSERT INTO EmployeeResignationComments            
    (ResignationID, LastDayWorked, Remark, Active, EnteredBy, EntryDate,AttritionReason,Rating,NextEmployer,NextEmployerHike,ReplacementAction)            
VALUES     (@1,@2,@3,1,@5,GETDATE(),@6,@7,@8,@9,@10)             
            
                
select @employeeID=employeeID,@resignationDate=resignationDate,@lastdayworked=LastDayWorked from employeeResignation where resignationID=@1                
                
if(@4='2')                
Begin                
  UPDATE    EmployeeMaster                
  SET              EmployeementStatusID =5, ResignationDate =@resignationDate,LastDayWorked=@lastdayworked, LastUpdated =getdate(), UpdatedBy =@5                
  WHERE employeeID=@employeeID and EmployeementStatusID in (1) and active=1                
                
End                
                
                
INSERT INTO EmployeeNotification                
      (Employeeid, Status, Notification, Createdby, CreatedDate, AlertCategory,AlertData)                
VALUES     (@employeeID,@4,0,@5, GETDATE(),7,@1)                 
              
                  
Return @result                  
                  
                      
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ExitFeedbackEmpidDetail]    Script Date: 08/08/2012 21:51:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_ExitFeedbackEmpidDetail]  --'101177'   
   
 @1 varchar(50) --Empid   
AS  
/*   
Craeted By : Vikas  
Created At : 18 June 2012  
Desc : To check Employee ID in eExit_FeedbackEmployeeMatrix tbl */  
BEGIN    
 SET NOCOUNT ON;    
     
 Declare @result int    
     
 set @result=0    
     
 if exists(select * from eExit_FeedbackEmployeeMatrix where EmployeeID=@1 and ISComplete=1)    
 Begin    
  set @result=1   

 End      
      
    -- print @result   
 Return @result    
    
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ExitFeedbackcheckHRPMAns]    Script Date: 08/08/2012 21:51:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_ExitFeedbackcheckHRPMAns]  -- '101196'   
   
 @1 varchar(50)--EmployeeID   
  
AS  
/*   
Craeted By : Vikas  
Created At : 22 June 2012  
modified By : vikas, 25 Jun 2012, add more condition
Desc : To check Answer of HR and PM is Filled Or Not */  
BEGIN    
 SET NOCOUNT ON;    
     
 Declare @result int    
     
 set @result=0    
     
 if exists(Select * from eExit_FeedbackEmployeeMatrix where  Answer is not null and QuestID = 23 and EmployeeID=@1) -- For HR   
 Begin    
  set @result=1   

 End  
 else 
 if exists (Select * from eExit_FeedbackEmployeeMatrix where  Answer is not null and QuestID = 22 and EmployeeID=@1)   -- PM 
 Begin    
  set @result=2   

 End  
 else 
 if not exists (Select * from eExit_FeedbackEmployeeMatrix where  QuestID in (23,22) and EmployeeID=@1)   --- not entry by pm and hr
 Begin    
  set @result=3   

 End 
else 
 if exists (Select * from eExit_FeedbackEmployeeMatrix where  QuestID in (23,22) and Answer is not null and EmployeeID=@1)   --- check entry of both
 Begin    
set @result=4  

End 
 
  print @result     
     
 Return @result    
  
END
GO
/****** Object:  StoredProcedure [dbo].[USP_EexitViewFeedbackDetails]    Script Date: 08/08/2012 21:51:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_EexitViewFeedbackDetails]  --'101177'  
(  
 @1 varchar(50) --Empid   
)  
AS   
          /*    
           Craeted By : Vikas    
           Created At : 18 June 2012    
           Desc : To View Feedback Question and Answer  
          */       
BEGIN    
 SET NOCOUNT ON;    
   
--declare @1 varchar(10) = '101177' -- EmpID  
  
select eq.QuesID, eq.QuestionName,  
       isnull(ea.Answer,'N/A') as [Answer]   
 from eExit_FeedbackQuestion eq  
     inner join eExit_FeedbackEmployeeMatrix ea on ea.QuestID=eq.QuesID  
 Where ea.active=1 and EmployeeID=@1  and ISComplete=1  order by eq.QuesID 
  
END
GO
/****** Object:  StoredProcedure [dbo].[Usp_eExitViewFeedbackdetail]    Script Date: 08/08/2012 21:51:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Usp_eExitViewFeedbackdetail]  
(  
@1 varchar(10) -- EmpID  
)  
as  
/*    
           Craeted By : Vikas    
           Created At : 18 June 2012    
           Desc : To   
          */      
begin  
  
Select ef.QuestionName, e.Answer from eExit_FeedbackQuestion ef  
 inner join eExit_FeedbackEmployeeMatrix e on e.QuestID = ef.QuesID  
 where ef.active=1 and e.EmployeeID=@1  
   
 end
GO
/****** Object:  StoredProcedure [dbo].[USP_eExitRevokeResignation]    Script Date: 08/08/2012 21:51:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_eExitRevokeResignation] --'6','101166'                 
--declare                  
@1 varchar(20), --resignation ID                
@2 varchar(20) --userID                 
                
AS                                  
BEGIN                  
SET NOCOUNT ON;                    
                
Declare @result int  ,@EmployeeId Varchar(50)            
              
UPDATE    EmployeeResignation              
        
        
SET              ResignationStatusID =6, LastUpdatedOn =getdate(), Updatedby =@2, ResignationRevokeDate=GETDATE()              
Where resignationID=@1              
              
             
SET @EmployeeId =(SELECT EmployeeID FROM EmployeeResignation Where resignationID=@1 )            
INSERT INTO EmployeeNotification(Employeeid, Status, Notification, Createdby, CreatedDate,AlertCategory,AlertData)            
VALUES (@EmployeeId,6,0,@2, GETDATE(),7,@1)         
        
UPDATE EmployeeMaster SET EmployeementStatusID =1,LastUpdated=GetDate(),UpdatedBy=@2 WHERE  EmployeeID=@EmployeeId        
        
   
 if Exists (Select Employeeid from eExit_FeedbackEmployeeMatrix where EmployeeID=@EmployeeId)       
  begin      
  Update eExit_FeedbackEmployeeMatrix Set ISComplete=0, LastUpdatedBy=@2, LastUpdatedOn=GETDATE() where EmployeeID=@EmployeeId      
  end      
         
if Exists (Select Employeeid from eExit_ClearanceEmployeeMatrix where EmployeeID=@EmployeeId)       
  begin      
  Update eExit_ClearanceEmployeeMatrix Set Active=0, UpdatedBy=@2, UpdatedOn=GETDATE() where EmployeeID=@EmployeeId      
  end           
            
set   @result=1             
              
return @result        
END
GO
/****** Object:  StoredProcedure [dbo].[USP_eExitGetResignationStatus]    Script Date: 08/08/2012 21:51:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                        
-- Author:  Nasim    
-- Create date: 16 Jan 2012  
-- Description: Get resignation Status  
-- =============================================                        
ALTER PROCEDURE [dbo].[USP_eExitGetResignationStatus]    
@1 varchar(50),	--User ID
@2 varchar(50)=''--All status
AS                    
BEGIN    
SET NOCOUNT ON;      

if(@2='ALL')
	Begin
			SELECT     resignationStatusID, resignationStatus  
			FROM         ResignationStatusMaster  
			WHERE     (active = 1) 
	END
Else
	Begin
			Declare @roleID int
			select @roleID=isnull(roleID,2) from login where employeeID=@1

			if(@1=0)
			Begin
			set @roleID=4
			End  


			if(@roleID=4)
			Begin  
				SELECT     resignationStatusID, resignationStatus  
				FROM         ResignationStatusMaster  
				WHERE     (active = 1)  and resignationStatusID in (2,3)
			END
			else
			Begin
				SELECT     resignationStatusID, resignationStatus  
				FROM         ResignationStatusMaster  
				WHERE     (active = 1)   and resignationStatusID in (4,5)
			END
	END
      
END
GO
/****** Object:  StoredProcedure [dbo].[USP_eExitClearanceEmployeeList]    Script Date: 08/08/2012 21:51:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_eExitClearanceEmployeeList]  --'55','0','0','','06/19/2012', '07/19/2012','300312','0','0'                                                         
                          
@1 VARCHAR(50),--COMPANY ID                                            
@2 VARCHAR(50),--PROCESS ID                                            
@3 VARCHAR(50),--SUBPROCESS ID                                           
@4 VARCHAR(50),--EMPLOYEE ID                                            
@5 VARCHAR(50),--FROM DATE                                    
@6 VARCHAR(50),--TO DATE                                    
@7 VARCHAR(50),-- Login id                     
@8 varchar(1),--DR                     
@9 Varchar(1) --- Myself                                    
                       
 As                                
                                    
DECLARE @QUERY VARCHAR(MAX)                                            
DECLARE @WHERE VARCHAR(MAX)                           
DECLARE @ROLEID VARCHAR(50)                     
Declare @ReportingType Varchar(10)                         
                                           
SET @QUERY=' SELECT   EM.EmployeeID,                       
                      EM.FirstName + '' '' + ISNULL(EM.MiddleName ,'''')  + '' '' + ISNULL(EM.LastName ,'''') AS Name,                      
                      DM.Designation,Es.EmployementStatus as [Status],  
                       PM.ProcessName  AS Process,                                            
                      dbo.CompanyMaster.CompanyName AS Company ,                                         
                      dbo.PanelName(EM.EmployeeID) as [Clearance Status],                                          
                      Convert(varchar,EM.LastDayWorked,106)as [Last Working Date],                                
                       case                                
                       when (select count(FDEmpMatrixID)  from eExit_FeedbackEmployeeMatrix where EmployeeID=EM.EmployeeID and active=1 and ISComplete=1)>0                                
                       then Convert(bit,''true'')                                
                       else                                
                       Convert(bit,''false'')                                
                       end as ClearanceFormStatus ,                      
                            
                        CASE                      
              when     
              ( (Select [dbo].[CheckLastDayWorked](EM.EmployeeID) )= 1       
                AND    
          (case                 
             WHEN EM.EmployeeID ='+@7+' then 1                
              WHEN (Select count(FDEmpMatrixID)  from eExit_FeedbackEmployeeMatrix where EmployeeID=EM.EmployeeID and active=1 and ISComplete=1)>0                                               
           then 1               
           ELSE                
            0     
            end ) =1 )    
          THEN    
          Convert(bit,''true'')     
          ELSE    
          Convert(bit,''false'')     
        END    
         as feedBackStatus     
            
        ,            
                     
         CASE  WHEN (case                 
       WHEN EM.EmployeeID ='+@7+' then 1                
       WHEN (Select count(FDEmpMatrixID)  from eExit_FeedbackEmployeeMatrix where EmployeeID=EM.EmployeeID and active=1 and ISComplete=1)>0                                               
        then 1                
           ELSE                
             0 END) = 1            
             THEN  Convert(bit,''false'')            
             ELSE            
               Convert(bit,''true'')            
             END             
             AS feedBacklblStatus            
                                                
                                                                
FROM         dbo.EmployeeMaster AS EM   
       Inner Join EmployementStatus Es on Es.EmployementStatusID = Em.EmployeementStatusID      
            INNER JOIN    dbo.DesignationMaster AS DM ON EM.DesignationID = DM.DesignationID INNER JOIN                                            
                      dbo.TeamMaster ON EM.TeamID = dbo.TeamMaster.TeamID INNER JOIN                         
                      dbo.SubProcessMaster ON dbo.TeamMaster.SubProcessID = dbo.SubProcessMaster.SubProcessID INNER JOIN                                            
                      dbo.ProcessMaster AS PM ON dbo.SubProcessMaster.ProcessID = PM.ProcessID INNER JOIN                                            
     dbo.CompanyMaster ON EM.CompanyID = dbo.CompanyMaster.CompanyID                                   
   --INNER JOIN EmployeeResignation on EM.EmployeeID=EmployeeResignation.EmployeeID                                              
                      '                                            
                                            
SET @WHERE=' WHERE  (EM.Active = 1 and EmployeementStatusID in (5,2))'                                            
                                            
IF(@1<>'0')                                            
BEGIN                                            
SET @WHERE=@WHERE+ ' AND dbo.CompanyMaster.CompanyID='+@1                                            
END                                            
                                            
IF(@2<>'0')                                            
BEGIN                                            
SET @WHERE=@WHERE+ ' AND PM.ProcessID='+@2                                       
END                                            
                                            
IF(@3<>'0')                                   
BEGIN                                            
SET @WHERE=@WHERE+ ' AND dbo.SubProcessMaster.SubProcessID='+@3                                            
END                             
                                            
IF(@4<>'')                                            
BEGIN                                            
SET @WHERE=@WHERE+ ' AND EM.EmployeeID='+@4                                           
END                    
                   
IF(@5<>'')                                                
       BEGIN                                                
         SET @where=@where + ' And EM.LastDayWorked between convert(datetime,''' +@5 +''') and dateadd(hh,24,'''+@6+''')'                                              
       END                   
                    
if(@8='1')                                                          
 Begin                                                          
  SET @ReportingType='Direct'                          
 End                                         
                          
SET @ROLEID=(SELECT Login.RoleID FROM Login WHERE Login.EmployeeID=@7)                          
IF(@ROLEID  IN(12,3,4,5,6,7,11))                       
BEGIN                        
  If (@8 = '1')                     
  begin                     
 SET @WHERE=@WHERE+ ' AND EM.EmployeeID IN(select EM.EmployeeID from EmployeeReportingLead ERl                          
 INNER JOIN EmployeeMaster EM on EM.EmployeeID=ERl.EmployeeID                       
 WHERE EM.ACTIVE=1 AND ERl.ReportingType in(''Direct'')                       
 AND  ERl.Active=1 AND ERl.HeadID ='+@7+')   '    --AND (EM.LastDayWorked BETWEEN '''+@5+''' AND '''+@6+''')                     
 End                     
 else                    
  if(@8 = '1' and @9 = '1')                    
  begin                    
    SET @WHERE=@WHERE+ 'AND EM.EmployeeID Union EM.EmployeeID IN(select EM.EmployeeID from EmployeeReportingLead ERl                          
 INNER JOIN EmployeeMaster EM on EM.EmployeeID=ERl.EmployeeID                       
 WHERE EM.ACTIVE=1 AND ERl.ReportingType in(''Direct'')                       
 AND  ERl.Active=1 AND ERl.HeadID ='+@7+')  AND (EM.LastDayWorked BETWEEN '''+@5+''' AND '''+@6+''') '                    
  end                    
  else                    
 if(@9 = '1')                    
  begin                    
    SET @WHERE=@WHERE+ ' AND EM.EmployeeID IN('+@7+')'                     
  end                    
END                      
                      
IF(@ROLEID  IN(2))                          
BEGIN                          
 SET @WHERE=@WHERE+ ' AND EM.EmployeeID IN('+@7+')'                          
END                 
                          
IF(@ROLEID  IN(10))                          
BEGIN                          
SET @WHERE=@WHERE+ ' AND EM.EmployeeID IN(select EM.EmployeeID from EmployeeReportingLead ERl                          
INNER JOIN EmployeeMaster EM on EM.EmployeeID=ERl.EmployeeID                        
WHERE EM.ACTIVE=1 AND ERl.ReportingType in(''Direct'',''In-Direct'')                      
AND  ERl.Active=1 AND ERl.HeadID ='+@7+')    AND (EM.LastDayWorked BETWEEN '''+@5+''' AND '''+@6+''') '                          
END                          
                          
                                                    
PRINT (@QUERY+@WHERE)                                            
EXEC (@QUERY+@WHERE)
GO
/****** Object:  StoredProcedure [dbo].[USP_EDB_InsertWeekoff]    Script Date: 08/08/2012 21:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================        
-- Author:  Nasim        
-- Create date: 23 Apr 2012        
-- Description: Insert employee weekoff        
-- =============================================        
ALTER PROCEDURE [dbo].[USP_EDB_InsertWeekoff]                       
@1   NVARCHAR(MAX),            
@2 varchar(50)        
 AS                              
                            
BEGIN              
        
--DECLARE                       
--@1   NVARCHAR(MAX),            
--@2 varchar(50)        
--SET @2='101173'      
        
 --SET @1=                    
 --'        
 --<NewDataSet>        
 -- <Table1>        
 --   <EmployeeID>101173</EmployeeID>        
 --   <Date>4/1/2012</Date>        
 --   <WeekOff>1</WeekOff>        
 -- </Table1>        
 -- <Table1>        
 --   <EmployeeID>101173</EmployeeID>        
 --   <Date>4/2/2012</Date>        
 --   <WeekOff>0</WeekOff>        
 -- </Table1>        
 -- <Table1>        
 --   <EmployeeID>101173</EmployeeID>        
 --   <Date>4/3/2012</Date>        
 --   <WeekOff>1</WeekOff>        
 -- </Table1>        
 -- <Table1>        
 --   <EmployeeID>101173</EmployeeID>        
 --   <Date>4/4/2012</Date>        
 --   <WeekOff>1</WeekOff>        
 -- </Table1>        
 -- <Table1>        
 --   <EmployeeID>101173</EmployeeID>        
 --   <Date>4/5/2012</Date>        
 --   <WeekOff>1</WeekOff>        
 -- </Table1>        
 -- <Table1>        
 --   <EmployeeID>101173</EmployeeID>        
 --   <Date>4/6/2012</Date>        
 --   <WeekOff>1</WeekOff>        
 -- </Table1>        
 -- <Table1>        
 --   <EmployeeID>101173</EmployeeID>        
 --   <Date>4/29/2012</Date>        
 --   <WeekOff>0</WeekOff>        
 -- </Table1>        
 -- </NewDataSet>        
 --'                       
                     
 CREATE TABLE #Gettable                              
 (                              
  [EmployeeID] [nvarchar](100) NULL,                              
  [Date] [nvarchar](50) NULL,                              
  [WeekOff] [nvarchar](10) NULL        
                               
 )                              
       
 DECLARE @h INT                               
 EXEC sp_xml_preparedocument @h OUTPUT, @1                               
                              
 INSERT INTO #Gettable([EmployeeID],[Date],[WeekOff])                              
 (SELECT  [EmployeeID],[Date],[WeekOff]                             
 FROM OPENXML(@h, '/NewDataSet/Table1',2)                               
 WITH (                              
   [EmployeeID] [nvarchar](100) ,                              
  [Date] [nvarchar](50) ,                              
  [WeekOff] [nvarchar](10)                                 
  )                              
)                               
EXEC sp_xml_removedocument @h          
                             
--SET ARITHABORT OFF                              
--SET ANSI_WARNINGS OFF          
--Declare cue cursor        
--for select [EmployeeID],[Date],[WeekOff] from #Gettable        
--INSERT INTO LeaveSummary        
--                      (AppliedFor, AppliedBy, AppliedOn, StartDate, EndDate, LeaveTypeID, Reason, Status)        
--VALUES     (,,,,,,,)        
       
  DECLARE @EmployeeID int,      
   @date datetime,      
   @LeaveSummaryID varchar(20),      
   @LeaveID VARCHAR(20),      
   @WeekOff  bit  ,      
   @OldLeaveTypeId int  
         
   -----------------------------------------------------------------------------------------------------------------------------------------        
       DECLARE CursorWeekOff Cursor for        
       SELECT GT.EmployeeID,GT.Date,GT.WeekOff FROM #Gettable GT      
       WHERE  DATE NOT in (SELECT HolidayDate FROM HolidayMaster WHERE Active=1 AND CompanyId in (SELECT CompanyID FROM EmployeeMaster WHERE EmployeeID =GT.EmployeeID ))      
       OPEN CursorWeekOff        
       FETCH NEXT FROM CursorWeekOff INTO @EmployeeID, @date ,@WeekOff        
       WHILE @@FETCH_STATUS =0        
       BEGIN        
   SET @OldLeaveTypeId =0      
   SELECT   @OldLeaveTypeId=LeaveTypeId  FROM LeaveDetails LD inner JOIN LeaveSummary LS on (LD.LeaveSummaryID=LS.LeaveSummaryID)       
     WHERE        LD.EmployeeID=@EmployeeID AND Ld.DateApplied =@date AND  LD.LeaveStatusID IN (1,12,16)       
       --------------------------------------------------------------------------------------------------------------------------------------        
  IF(@WeekOff =1)      
  BEGIN      
    IF  NOT EXISTS( SELECT LEAVEID FROM DBO.LEAVEDETAILS WHERE EMPLOYEEID=@EmployeeID AND DATEAPPLIED =@date AND LeaveStatusID IN (1,12,16) )        
    BEGIN        
      INSERT INTO [LEAVESUMMARY]                                    
      ([AppliedFor],[AppliedBy],[AppliedOn],[StartDate],[EndDate],[LeaveTypeID],[Reason],[Status] )                                    
      VALUES (@EmployeeID,@2,GETDATE(),@date,@date,22,'Week Off',1)                                    
                    
      SET @LeaveSummaryID=@@IDENTITY          
                    
      IF(@LeaveSummaryID <> '')        
      BEGIN        
     INSERT INTO [LEAVEDETAILS]                                    
       ([EMPLOYEEID],[LEAVEDURATION],[DATEAPPLIED],[LEAVESTATUSID],[LEAVESUMMARYID])                                    
      VALUES ( @EmployeeID,1,@date,12,@LeaveSummaryID )        
     --SET @LEAVEID = SCOPE_IDENTITY()            
      END                
    END        
        END      
        ELSE      
        BEGIN      
    UPDATE  [LEAVEDETAILS]        
            SET  [LEAVESTATUSID]=13  ,LastUpdated=GetDate(),UpdatedBy=@2                               
      WHERE EmployeeID=@EmployeeID AND DateApplied =@date AND LeaveStatusID IN (1,12,16) AND @OldLeaveTypeId= 22      
             
        END      
       -----------------------------------------------------------------------------------------------------------------------------------------                    
               
       FETCH NEXT FROM CursorWeekOff  INTO @EmployeeID, @date ,@WeekOff          
       END        
       CLOSE CursorWeekOff        
       DEALLOCATE CursorWeekOff        
            
                  
  ---select * from  #Gettable                          
  DROP TABLE #Gettable        
  RETURN 1          
                              
END                          
                  
  --select * from [LEAVESUMMARY] WHERE LeaveSummaryID in (134,135,140)      
  -- select * from LeaveStatusMaster       
  --select * from LEaveDetails WHERE EmployeeID= 101173      
  --Select * from LeaveType      
  --DELETE FROM LeaveDetails WHERE LEaveId in (147,148,149,150,151,152)      
 --Update LEaveDetails SET leaveStatusID=13  WHERE LEaveID=153
GO
/****** Object:  StoredProcedure [dbo].[USP_eExit_insertEmployeeFeedBack]    Script Date: 08/08/2012 21:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_eExit_insertEmployeeFeedBack]          
 @1 VARCHAR(Max),--  answerString          
 @2 Varchar(20),-- EmpiD      
 @3 bit -- IsCompleted       
AS   
/*   
Craeted By : Vikas  
Created At : 12 June 2012  
Modified By : Vikas (14 Jun 2012) Add Update Details  
Desc : To Insert Employee Feddback Form details of eExit Module  
  [USP_eExit_insertEmployeeFeedBack] '1;Medical Benefits|2;jhkhjyujg|3;jhhg|4;Yes|5;Yes','101177',False  
Select * from eExit_FeedbackEmployeeMatrix  
   
Truncate Table  eExit_FeedbackEmployeeMatrix  
*/         
BEGIN   
                 
 DECLARE @Result VARCHAR(50),               
 @emid int,              
 @qid varchar(50),    
 @answer varchar(200)     
  
    DECLARE @table TABLE(empid varchar(20),quesid int,ans VARCHAR(Max))         
     
    INSERT INTO @table(empid,quesid,ans)          
    SELECT @2 ,SUBSTRING(String, 1, CHARINDEX(';', String) - 1),    
    SUBSTRING(String, CHARINDEX(';', String) + 1,LEN(String)-1)                   
    FROM dbo.split(@1,'|')   
     
   if not exists (select EmployeeID from eExit_FeedbackEmployeeMatrix where EmployeeID=@2 AND active=1 and QuestID in (Select quesid from @table) )  
        begin  
          
   Insert into eExit_FeedbackEmployeeMatrix (QuestID,EmployeeID,Answer,active,ISComplete, EnteredBy,EntryDate)  
            select  quesid, empid, ans,1,@3,@2,GETDATE() from  @table  
             
           SET @Result=1      
    End   
     else  
     begin   
               
   ------------FETCH DATA FROM @TABLE AND INSERT INTO eExit_FeedbackEmployeeMatrix TABLE-------------   
     
                
   DECLARE CUST CURSOR              
   FOR SELECT empid,quesid,ans FROM @table               
                 
   OPEN CUST              
   FETCH NEXT FROM CUST into @emid,@qid,@answer              
                 
    WHILE (@@FETCH_STATUS = 0)              
    BEGIN                 
                  
     IF NOT EXISTS(SELECT FDEmpMatrixID FROM eExit_FeedbackEmployeeMatrix               
       WHERE EmployeeID=@emid AND QuestID=@qid  AND Answer=@answer AND Active=1 )              
                   
     BEGIN              
                   
    UPDATE eExit_FeedbackEmployeeMatrix SET Active=0 ,LastUpdatedBy=@2, LastUpdatedOn=GETDATE() , ISComplete=0            
    WHERE  EmployeeID=@emid AND QuestID=@qid            
                    
    INSERT INTO eExit_FeedbackEmployeeMatrix              
     (QuestID,EmployeeID,Answer,Active,iscomplete,EnteredBy,EntryDate)               
    VALUES(@qid,@emid,@answer,1,@3,@2,GETDATE())               
     END              
                 
    FETCH NEXT FROM CUST into @emid,@qid,@answer              
                 
   END              
   CLOSE CUST              
   DEALLOCATE CUST    
     
   UPDATE eExit_FeedbackEmployeeMatrix SET ISComplete=@3  
    WHERE  EmployeeID=@emid AND active=1   
    
    

     
               
   ----------------------------------------------                
 SET @Result=2               
 END              
return @Result         
          
End
GO
/****** Object:  StoredProcedure [dbo].[USP_eExit_InsertAnswer]    Script Date: 08/08/2012 21:51:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================         
-- Author:  Satya                            
-- Create date: 10 June 2012                          
-- Description: Insert/Update Clearance Form Question      
-- Modified By : Vikas (30 July 2012)    
-- Desc : Add Notification and Attrition Status                        
-- =============================================                            
ALTER PROCEDURE [dbo].[USP_eExit_InsertAnswer] --'27;True;nnnnnnnnnnnnnnnn','101177','101319'                      
                    
@1 VARCHAR(MAX),--AnswerString                      
@2 VARCHAR(50),--Enter By                     
@3 VARCHAR(50)--USERID                     
AS                      
--SET @1='1;TRUE;ABC'                    
--SET @2=101036                    
                    
BEGIN                      
DECLARE @Result VARCHAR(50),                     
 @emid int,                    
 @qid varchar(50),                    
 @abit bit,                    
 @answer varchar(200)                    
                     
 DECLARE @table TABLE(empid INT,quesid VARCHAR(50),ansbit BIT,ans VARCHAR(200))                      
                      
  INSERT INTO @table(empid,quesid,ansbit,ans)                      
   SELECT @3, SUBSTRING(String, 1, CHARINDEX(';', String) - 1) ,                      
      SUBSTRING(String, CHARINDEX(';', String) + 1,CHARINDEX(';',String,(CHARINDEX(';', String)+1))-(CHARINDEX(';', String)+1)) ,                          
            SUBSTRING(String,CHARINDEX(';',String,(CHARINDEX(';', String)+1))+1,LEN(String)-1)                      
   FROM dbo.split(@1,',')                      
                      
  IF NOT EXISTS(SELECT DISTINCT Employeeid from eExit_ClearanceEmployeeMatrix WHERE Employeeid=@3)                    
 BEGIN                     
                     
 INSERT INTO  eExit_ClearanceEmployeeMatrix                    
   (QuestionId,EmployeeId,Answerbit,Answer,Active,EnteredBy,EntryDate)                     
            SELECT quesid,@3,ansbit,ans,'true',@2,GETDATE() FROM @table                      
                    
 SET @Result=1                      
                     
 END                    
                    
ELSE                    
 BEGIN                           
                       
   ------------FETCH DATA FROM @TABLE AND INSERT INTO eExit_ClearanceEmployeeMatrix TABLE-------------                    
   DECLARE CUST CURSOR                    
   FOR SELECT empid,quesid,ansbit,ans FROM @table                     
                       
   OPEN CUST                    
   FETCH NEXT FROM CUST into @emid,@qid,@abit,@answer                    
                       
   WHILE (@@FETCH_STATUS = 0)                    
   BEGIN                       
                       
   IF NOT EXISTS(SELECT ClearanceMatrixId FROM eExit_ClearanceEmployeeMatrix                     
   WHERE EmployeeId=@emid AND QuestionId=@qid AND Answerbit=@abit AND Answer=@answer AND Active=1)                    
                       
   BEGIN                    
                       
    UPDATE eExit_ClearanceEmployeeMatrix SET Active=0                     
    WHERE  EmployeeId=@emid AND QuestionId=@qid  AND  Answerbit IN(0,1)                   
                       
    INSERT INTO eExit_ClearanceEmployeeMatrix                    
    (QuestionId,EmployeeId,Answerbit,Answer,Active,UpdatedBy,UpdatedOn)                     
    VALUES(@qid,@emid,@abit,@answer,'true',@2,GETDATE())                     
   END                    
                       
   FETCH NEXT FROM CUST into @emid,@qid,@abit,@answer                    
                       
   END                    
   CLOSE CUST                    
   DEALLOCATE CUST                    
   ------------------------------------------------        
   ---User is HR then change status to attrited and insert Attrition notification      
   ------------------------------------------------        
  --- print '123'      
     ---------------Inserting Employee status change notification mail entry-----------------   
    if(@2 = (Select EmployeeID from Login where EmployeeID=@2 and RoleID=4))        
      begin      
      update EmployeeMaster set EmployeementStatusID = 2, AttritionDate=GETDATE(),LastUpdated=GETDATE(),UpdatedBy=@2    
                , AttritionReason=(Select top 1 ReasonDetails from EmployeeResignation where EmployeeID=@3 order by ResignationID desc)     
                 , AttritionReasonInDetail=(Select top 1 ReasonDetails from EmployeeResignation where EmployeeID=@3 order by ResignationID desc)     
                 , AttritionStatus='Attrited' , AttritionMonth = MONTH(GETDATE())    
                 where EmployeeID=@3      
            
       exec USP_EDB_InsertEmpNotification @3,2,@2       
            
      End    
        
 SET @Result=2                     
 END                    
return @Result                      
--PRINT @Result                    
END
GO
/****** Object:  StoredProcedure [dbo].[USP_eExit_GetEmployeeEDB]    Script Date: 08/08/2012 21:51:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  [USP_eExit_GetEmployeeEDB] '0','05/29/2012','06/29/2012','','5','Software Development',''         
 -- =============================================                        
-- Author:  <Manish>                        
-- Create date: <>      
-- Modified By : Vikas (29 Jun 2012) commented line no 1 an 2                      
-- Description: <getting  Details of employee>                        
-- =============================================                        
ALTER PROCEDURE [dbo].[USP_eExit_GetEmployeeEDB] -- '101012'                    
 @1 varchar(50), --Company Id                               
 @2 varchar(50), --To Date                                
 @3 varchar(50), --From Date            
 @4 varchar (20), -- Employee Id        
  @5 varchar(20), --'ControlKey      
  @6 varchar(50), --ProcessID      
 @7 varchar(50) --Employmentstatus      
AS         
      
--declare       
-- @1 varchar(50)=0, --Company Id                               
-- @2 varchar(50)='05/29/2012', --To Date                                
-- @3 varchar(50)='06/29/2012', --From Date            
-- @4 varchar (20)='', -- Employee Id        
--  @5 varchar(20)='5', --'ControlKey      
--  @6 varchar(50)='', --ProcessID      
-- @7 varchar(50) = ''--Employmentstatus      
                     
BEGIN                        
            
   DECLARE @SDATE DATETIME ,@EDATE DATETIME                      
                     
 SET @SDATE=@2  SET @EDATE=@3       
                      
 IF(@1='0')        
  BEGIN        
  SET @1=NULL        
  END       
 IF(@7='0')        
  BEGIN        
  SET @7=NULL        
  END        
 IF(@6='0')        
  BEGIN        
  SET @6=NULL        
  END                           
  IF(@4='')        
  BEGIN        
  SET @4=NULL        
  END      
 SET NOCOUNT ON;       
            
            
            
      IF(@5='0')--PERSONAL      
      BEGIN      
      ----------------------Personal Details-----------------------------------------------------------------------------          
    SELECT                     
    DBO.GETEMPID([EMPLOYEEID]) AS 'EmployeeID',[FIRSTNAME] +' '+ ISNULL([MIDDLENAME],'')+' '+ISNULL([LASTNAME],'') AS 'Employee Name'  ,                    
    [FatherName] AS [Father Name]      
    ,(CASE Gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' ELSE '' END) AS Gender      
    ,[BloodGroup] AS [Blood Group]       
    ,CONVERT(varchar,[DOB],101) as DOB       
    ,(CASE [MaritalStatus] WHEN '::::Select::::' THEN '' ELSE  [MaritalStatus] END) AS [Marital Status]       
    ,[NumberOfChildren] AS [Number Of Children]  ,[PersonalEmailID] AS [Personal Email ID]            
   ,(CASE Handicapped WHEN '1' THEN 'Yes' ELSE 'No' END) AS Handicapped                       
    FROM [DBO].[EMPLOYEEMASTER] EMP LEFT JOIN DBO.TEAMMASTER TM                       
    ON TM.TEAMID=EMP.TEAMID LEFT JOIN DBO.SUBPROCESSMASTER SPM                      
    ON SPM.SUBPROCESSID=TM.SUBPROCESSID LEFT JOIN DBO.PROCESSMASTER PM                      
    ON PM.PROCESSID=SPM.PROCESSID LEFT JOIN DBO.DEPARTMENTMASTER DM                      
    ON DM.DEPARTMENTID=PM.PROCESSID                      
     WHERE  EMP.ACTIVE=1 AND EMP.COMPANYID=ISNULL(@1,EMP.COMPANYID)       
     and employeementStatusid=isnull(@7,employeementStatusid)        
     and   PM.PROCESSID=isnull(@6,PM.PROCESSID)      
     and Emp.employeeID=isnull(@4,Emp.employeeID)                    
    AND DOJ BETWEEN @SDATE AND @EDATE                     
     ORDER BY EMP.COMPANYID,EMP.[EMPLOYEEID]                   
        
      END      
      ELSE IF(@5='1')--Contact      
      BEGIN      
                  
   -----------------------Contact Details-------------------------------------------------------------------------                  
                     
    SELECT   E.EmployeeId 'EmployeeID',A.[Name] AS [Address Type],                  
    E.Address1 + E.Address2 + E.Address3  + E.Address4  + E.Address5 AS Address ,C.City ,S.State  ,CO.Country ,E.Pincode ,E.PhoneNo 'Phone No.' ,Isnull(E.MobileNo,'N/A') as 'Mobile No.',                            
    (CASE E.ContactDefault WHEN '1' THEN 'Yes' ELSE 'No' END) AS [Default Contact]    FROM EmployeeAddress E               
    INNER JOIN AddressType A ON A.AdrTypeID=E.AdrTypeID                              
    left JOIN CityMaster C ON C.CityID=E.CityID                              
    left JOIN StateMaster S ON S.StateId=C.StateID                              
    left JOIN CountryMaster CO ON CO.CountryID=S.CountryID                    
    INNER JOIN  [EMPLOYEEMASTER] EMP ON (E.EmployeeId=EMP.EmployeeId)                    
    LEFT JOIN DBO.TEAMMASTER TM                       
     ON TM.TEAMID=EMP.TEAMID LEFT JOIN DBO.SUBPROCESSMASTER SPM                      
     ON SPM.SUBPROCESSID=TM.SUBPROCESSID LEFT JOIN DBO.PROCESSMASTER PM                      
     ON PM.PROCESSID=SPM.PROCESSID LEFT JOIN DBO.DEPARTMENTMASTER DM                      
     ON DM.DEPARTMENTID=PM.PROCESSID                      
     WHERE  EMP.ACTIVE=1 AND E.ACTIVE=1       
      and employeementStatusid=isnull(@7,employeementStatusid)        
     and   PM.PROCESSID=isnull(@6,PM.PROCESSID)        
      AND EMP.COMPANYID=ISNULL(@1,EMP.COMPANYID)        
       and Emp.employeeID=isnull(@4,Emp.employeeID)                           
     AND DOJ BETWEEN @SDATE AND @EDATE                     
     ORDER BY EMP.COMPANYID,EMP.[EMPLOYEEID]                       
             
      END      
      ELSE IF(@5='2')--Job      
      BEGIN      
      ---------------------Job Details-------------------------------------------------------------------------------------------          
                  
            
    SELECT EMP.EmployeeID, Designation=(select designation from designationMaster where designationID= EMP.DesignationID) ,CONVERT(varchar,EMP.DOJ,101) as DOJ,convert(varchar,EMP.DOJAsTrainee,101) as [DOJ As Trainee],            
    'Location'=(select locationName from locationMaster where locationID=EMP.LocationID),            
    'Shift Name'=(select ShiftName from ShiftMaster where ShiftID=EMP.ShiftID),            
    EMP.EmailID 'Email ID',EMP.Voice as Voice,EMP.ConfirmationTerms 'Confirmation Terms',                        
      CONVERT(varchar,EMP.TransferDate,101) 'Transfer Date',              
      EMP.TransferUnit 'Transfer Unit' ,                      
      TM.TeamName 'Team Name',SPM.SubProcessName 'Sub Process Name',PM.ProcessName 'Process Name'            
      From [EmployeeMaster] EMP                        
    LEFT JOIN DBO.TEAMMASTER TM                       
      ON TM.TEAMID=EMP.TEAMID LEFT JOIN DBO.SUBPROCESSMASTER SPM                      
      ON SPM.SUBPROCESSID=TM.SUBPROCESSID LEFT JOIN DBO.PROCESSMASTER PM                      
      ON PM.PROCESSID=SPM.PROCESSID LEFT JOIN DBO.DEPARTMENTMASTER DM                      
      ON DM.DEPARTMENTID=PM.PROCESSID                      
      WHERE  EMP.ACTIVE=1 AND EMP.COMPANYID=ISNULL(@1,EMP.COMPANYID)                      
      AND DOJ BETWEEN @SDATE AND @EDATE        
       and Emp.employeeID=isnull(@4,Emp.employeeID)               
       and employeementStatusid=isnull(@7,employeementStatusid)        
     and   PM.PROCESSID=isnull(@6,PM.PROCESSID)                    
      ORDER BY EMP.EmployeeID                   
         
      END      
      ELSE IF(@5='3')--Emergency      
      BEGIN      
   ------------------Emergency Details ----------------------------------------------------------------------------------          
                  
     SELECT [EEC].[EmployeeID],[ConcerenedPersonName]'Concerned Person Name'      
     ,[ConcerenedPersonNumber] 'Concerned Person Number'       
     ,[Relationship],[Address]                    
     FROM [EmployeeEmergencyContacts] EEC                  
     LEFT JOIN  [EMPLOYEEMASTER] EMP ON (EEC.EmployeeID=EMP.EmployeeID)                    
    LEFT JOIN DBO.TEAMMASTER TM                       
     ON TM.TEAMID=EMP.TEAMID LEFT JOIN DBO.SUBPROCESSMASTER SPM                      
     ON SPM.SUBPROCESSID=TM.SUBPROCESSID LEFT JOIN DBO.PROCESSMASTER PM                      
     ON PM.PROCESSID=SPM.PROCESSID LEFT JOIN DBO.DEPARTMENTMASTER DM                      
     ON DM.DEPARTMENTID=PM.PROCESSID                      
     WHERE  EMP.ACTIVE=1 AND EMP.COMPANYID=ISNULL(@1,EMP.COMPANYID)                      
     AND DOJ BETWEEN @SDATE AND @EDATE       
      and Emp.employeeID=isnull(@4,Emp.employeeID)              
      and employeementStatusid=isnull(@7,employeementStatusid)        
     and   PM.PROCESSID=isnull(@6,PM.PROCESSID)                      
     ORDER BY EMP.EmployeeID                     
                   
      END      
      ELSE IF(@5='4')--Salary      
      BEGIN      
                     
   --------------- Salary Details--------------------------------------------------------------------------------------          
                       
    SELECT     ESM.EmployeeID, CAST(ESM.AnnualCTC as decimal(8,2)) 'Annual CTC',                      
    CAST(ESM.Bonus as decimal(8,2)) 'Bonus',                       
    ESM.BonusTenureInMonths 'Bonus Tenure',                       
    CAST(ESM.DIP as decimal(8,2)) 'DIP', ESM.DIPTenureInMonths 'DIP Tenure'                      
    FROM         EmployeeSalaryMaster  ESM                    
    INNER JOIN  [EMPLOYEEMASTER] EMP ON (EMP.EmployeeID=ESM.EmployeeID)                    
     LEFT  JOIN DBO.TEAMMASTER TM                       
     ON TM.TEAMID=EMP.TEAMID LEFT JOIN DBO.SUBPROCESSMASTER SPM                      
     ON SPM.SUBPROCESSID=TM.SUBPROCESSID LEFT JOIN DBO.PROCESSMASTER PM                      
     ON PM.PROCESSID=SPM.PROCESSID LEFT JOIN DBO.DEPARTMENTMASTER DM                      
     ON DM.DEPARTMENTID=PM.PROCESSID                      
     WHERE  EMP.ACTIVE=1 AND EMP.COMPANYID=ISNULL(@1,EMP.COMPANYID)                      
     AND DOJ BETWEEN @SDATE AND @EDATE      
      and Emp.employeeID=isnull(@4,Emp.employeeID)                
      and employeementStatusid=isnull(@7,employeementStatusid)        
     and   PM.PROCESSID=isnull(@6,PM.PROCESSID)                     
     ORDER BY EMP.COMPANYID ,EMP.[EMPLOYEEID]              
      END      
      ELSE IF(@5='5')--Report      
      BEGIN      
                  
   -----------------------Report Details ----------------------------------------------------------------------------          
                   
    SELECT ERL.EmployeeID        
    ,EMP.FirstName+' '+isnull(EMP.MiddleName,'')+' '+isnull(EMP.LastName,'') as [Head Name]      
     ,ERL.ReportingType 'Reporting Type'                 
     FROM EmployeeReportingLead ERL                 
     INNER JOIN  [EMPLOYEEMASTER] EMP ON (ERL.HeadID=EMP.EmployeeID)     
    --  INNER JOIN  [EMPLOYEEMASTER] EMP ON (ERL.EmployeeID=EMP.EmployeeID) -- -1                    
    LEFT JOIN DBO.TEAMMASTER TM                       
     ON TM.TEAMID=EMP.TEAMID LEFT JOIN DBO.SUBPROCESSMASTER SPM                      
     ON SPM.SUBPROCESSID=TM.SUBPROCESSID LEFT JOIN DBO.PROCESSMASTER PM                      
     ON PM.PROCESSID=SPM.PROCESSID LEFT JOIN DBO.DEPARTMENTMASTER DM                      
     ON DM.DEPARTMENTID=PM.PROCESSID                      
     WHERE  EMP.ACTIVE=1 AND EMP.COMPANYID=ISNULL(@1,EMP.COMPANYID)                      
     AND DOJ BETWEEN @SDATE AND @EDATE   And ERL.Active=1    
      -- and EMP.employeeID=isnull(@4,EMP.employeeID) =---- 2    
      and ERL.employeeID=isnull(@4,ERL.employeeID)     
     and employeementStatusid=isnull(@7,employeementStatusid)        
     and   PM.PROCESSID=isnull(@6,PM.PROCESSID)                     
     ORDER BY EMP.EmployeeID        
      END      
      ELSE IF(@5='6')--Financial      
      BEGIN      
                   
    ----------------- Financial Details -----------------------------------------------------------------------------          
                    
      SELECT   EMP.EmployeeID,   EMP.PANNumber 'PAN Number'      
      , EMP.PFNumber 'PF Number'      
      , EMP.ESINumber 'ESI Number'                  
       FROM   [EMPLOYEEMASTER] EMP                 
     LEFT JOIN DBO.TEAMMASTER TM                       
      ON TM.TEAMID=EMP.TEAMID LEFT JOIN DBO.SUBPROCESSMASTER SPM                      
      ON SPM.SUBPROCESSID=TM.SUBPROCESSID LEFT JOIN DBO.PROCESSMASTER PM                      
      ON PM.PROCESSID=SPM.PROCESSID LEFT JOIN DBO.DEPARTMENTMASTER DM                      
      ON DM.DEPARTMENTID=PM.PROCESSID                      
      WHERE  EMP.ACTIVE=1 AND EMP.COMPANYID=ISNULL(@1,EMP.COMPANYID)           
       and Emp.employeeID=isnull(@4,Emp.employeeID)                         
      AND DOJ BETWEEN @SDATE AND @EDATE and employeementStatusid=isnull(@7,employeementStatusid)        
     and   PM.PROCESSID=isnull(@6,PM.PROCESSID)                       
      ORDER BY EMP.EmployeeID                 
               
      END      
      ELSE IF(@5='7')--Work Exp       
      BEGIN      
        
                    
   ------------- Work Exp Details -----------------------------------------------------------------------------------          
                     
      SELECT EMP.EmployeeID,                    
      ISnull([CompanyName],'N/A') as 'Company Name'                    
      ,Isnull(Convert(varchar,[From],101),'N/A') as 'From'                    
      ,Isnull(Convert(varchar,[Till],101),'N/A') as 'Till'                    
    ,Isnull([Designation],'N/A') as 'Designation'                    
    ,convert(decimal(18,2),[LastSalaryDrawn]) AS [Last Salary Drawn]                    
    ,convert(decimal(18,2),[SalaryInHand]) AS [Salary In Hand]                    
    ,convert(decimal(18,2),[AnnualCTC]) AS [Annual CTC]                    
    ,ISNULL([ReasonForLeaving],'N/A') as [Reason For Leaving]                    
    --,[CreatedDate]                    
     -- ,[CreatedBy]                    
    FROM [EmployeeExperience]  EE                   
    INNER JOIN  [EMPLOYEEMASTER] EMP ON (EE.EmployeeID=EMP.EmployeeID)                    
    LEFT JOIN DBO.TEAMMASTER TM                       
    ON TM.TEAMID=EMP.TEAMID LEFT JOIN DBO.SUBPROCESSMASTER SPM                      
    ON SPM.SUBPROCESSID=TM.SUBPROCESSID LEFT JOIN DBO.PROCESSMASTER PM                      
    ON PM.PROCESSID=SPM.PROCESSID LEFT JOIN DBO.DEPARTMENTMASTER DM                      
    ON DM.DEPARTMENTID=PM.PROCESSID                      
    WHERE  EMP.ACTIVE=1 AND EMP.COMPANYID=ISNULL(@1,EMP.COMPANYID)     and Emp.employeeID=isnull(@4,Emp.employeeID)                          
    AND DOJ BETWEEN @SDATE AND @EDATE   and employeementStatusid=isnull(@7,employeementStatusid)        
     and   PM.PROCESSID=isnull(@6,PM.PROCESSID)                     
    ORDER BY EMP.EmployeeID                    
                   
      END      
      ELSE IF(@5='8')--Education      
      BEGIN      
            
   ------------------------ Education Details -------------------------------------------------------------------------          
                   
      SELECT     EED.EmployeeID,EED.Course   'Course Name'      
      ,   EED.Specialization 'Specilization'      
      ,   EED.PassYear      
      ,   EED.PassPercent  'Percentage'      
      ,   EED.Institute                  
      FROM  EmployeeEducationDetails   EED                
      LEFT JOIN  [EMPLOYEEMASTER] EMP ON (EED.EmployeeID=EMP.EmployeeID)                    
    LEFT JOIN DBO.TEAMMASTER TM                       
     ON TM.TEAMID=EMP.TEAMID LEFT JOIN DBO.SUBPROCESSMASTER SPM                      
     ON SPM.SUBPROCESSID=TM.SUBPROCESSID LEFT JOIN DBO.PROCESSMASTER PM                      
     ON PM.PROCESSID=SPM.PROCESSID LEFT JOIN DBO.DEPARTMENTMASTER DM                      
     ON DM.DEPARTMENTID=PM.PROCESSID                      
     WHERE  EMP.ACTIVE=1 AND EMP.COMPANYID=ISNULL(@1,EMP.COMPANYID)  and Emp.employeeID=isnull(@4,Emp.employeeID)                             
     AND DOJ BETWEEN @SDATE AND @EDATE   and employeementStatusid=isnull(@7,employeementStatusid)        
     and   PM.PROCESSID=isnull(@6,PM.PROCESSID)                     
     ORDER BY EMP.EmployeeID            
                  
      END      
      ELSE IF(@5='9')--Documents      
      BEGIN      
                  
    --------------------Documents Details-----------------------------------------------------      
                    
                    
       SELECT    ED.EmployeeID      
       , (CASE ISNULL(ED.HippaDocPath,'') WHEN '' THEN 'No' ELSE 'Yes' END ) AS [Hippa Document]      
     , (CASE ISNULL(ED.NDADocPath,'') WHEN '' Then 'No' ELSE 'Yes' END) AS [NDA Document]      
     , (CASE ISNULL(ED.ResumePath,'') WHEN '' THEN 'No' ELSE 'Yes' END ) AS Resume               
       FROM EmployeeDocuments ED                
       LEFT JOIN  [EMPLOYEEMASTER] EMP ON (ED.EmployeeID=EMP.EmployeeID)                    
       LEFT JOIN DBO.TEAMMASTER TM                       
       ON TM.TEAMID=EMP.TEAMID LEFT JOIN DBO.SUBPROCESSMASTER SPM                      
       ON SPM.SUBPROCESSID=TM.SUBPROCESSID LEFT JOIN DBO.PROCESSMASTER PM                      
       ON PM.PROCESSID=SPM.PROCESSID LEFT JOIN DBO.DEPARTMENTMASTER DM                      
       ON DM.DEPARTMENTID=PM.PROCESSID                      
       WHERE  EMP.ACTIVE=1  AND EMP.COMPANYID=ISNULL(@1,EMP.COMPANYID) and Emp.employeeID=isnull(@4,Emp.employeeID)                              
       AND DOJ BETWEEN @SDATE AND @EDATE    and employeementStatusid=isnull(@7,employeementStatusid)        
     and   PM.PROCESSID=isnull(@6,PM.PROCESSID)                    
       ORDER BY EMP.EmployeeID                
            
      END      
      ELSE IF(@5='10')--Reference      
      BEGIN      
    -----------------  Emp Ref Details------------------------------------------------------------------------------          
                    
                    
      SELECT     ER.EmployeeID,   ER.RefName  'Ref Name',   ER.RefDesign 'Ref Designation',   ER.RefCompany 'Ref Company',   ER.RefAddress 'Ref Address',   ER.RefContactNo 'Ref Contact',   ER.RefRelation 'Relation',   ER.RefRemarks 'Remarks'             
  
     
      FROM         EmployeeReferences  ER                  
      LEFT JOIN  [EMPLOYEEMASTER] EMP ON (ER.EmployeeID=EMP.EmployeeID)                    
      LEFT JOIN DBO.TEAMMASTER TM                       
      ON TM.TEAMID=EMP.TEAMID LEFT JOIN DBO.SUBPROCESSMASTER SPM                      
      ON SPM.SUBPROCESSID=TM.SUBPROCESSID LEFT JOIN DBO.PROCESSMASTER PM                      
      ON PM.PROCESSID=SPM.PROCESSID LEFT JOIN DBO.DEPARTMENTMASTER DM                      
      ON DM.DEPARTMENTID=PM.PROCESSID                      
      WHERE  EMP.ACTIVE=1 AND EMP.COMPANYID=ISNULL(@1,EMP.COMPANYID) and Emp.employeeID=isnull(@4,Emp.employeeID)                              
      AND DOJ BETWEEN @SDATE AND @EDATE     and employeementStatusid=isnull(@7,employeementStatusid)        
     and   PM.PROCESSID=isnull(@6,PM.PROCESSID)                   
      ORDER BY EMP.EmployeeID                 
                
      END      
      ELSE IF(@5='11')--Nominee      
      BEGIN      
    --------------------------- Nominees Details ---------------------------------------------------------------------          
                    
      SELECT     EN.EmployeeID, EN.NomineeName 'Nominee Name', EN.Relationship, CONVERT(varchar,EN.DOB,101) 'DOB',                   
       EN.Address, EN.Phone, EN.Email 'Email ID', EN.NomineeFor 'Nominee For',EN.Gender                  
      FROM         EmployeeNominee EN                
                    
     LEFT JOIN  [EMPLOYEEMASTER] EMP ON (EN.EmployeeID=EMP.EmployeeID)                    
     LEFT JOIN DBO.TEAMMASTER TM                       
      ON TM.TEAMID=EMP.TEAMID LEFT JOIN DBO.SUBPROCESSMASTER SPM                      
      ON SPM.SUBPROCESSID=TM.SUBPROCESSID LEFT JOIN DBO.PROCESSMASTER PM                      
      ON PM.PROCESSID=SPM.PROCESSID LEFT JOIN DBO.DEPARTMENTMASTER DM                      
      ON DM.DEPARTMENTID=PM.PROCESSID                      
      WHERE  EMP.ACTIVE=1 AND EMP.COMPANYID=ISNULL(@1,EMP.COMPANYID)  and Emp.employeeID=isnull(@4,Emp.employeeID)                             
      AND DOJ BETWEEN @SDATE AND @EDATE    and employeementStatusid=isnull(@7,employeementStatusid)        
     and   PM.PROCESSID=isnull(@6,PM.PROCESSID)                    
      ORDER BY EMP.EmployeeID                    
                
      END      
      ELSE IF(@5='12')--Dependent      
      BEGIN      
                  
   --------------------- Dependents Details -------------------------------------------------------------------------          
           
     SELECT     ED.EmployeeID,ED.DependentName 'Dependent Name', ED.Relationship, convert(varchar,ED.DOB,101) 'DOB',                  
      ED.Gender,(CASE ED.physicallyChalanged WHEN '1' THEN 'Yes' ELSE 'No' End )  AS [Physically Chalanged]                
      FROM         EmployeeDependents   ED                
      LEFT JOIN  [EMPLOYEEMASTER] EMP ON (ED.EmployeeID=EMP.EmployeeID)                    
      LEFT JOIN DBO.TEAMMASTER TM                       
     ON TM.TEAMID=EMP.TEAMID LEFT JOIN DBO.SUBPROCESSMASTER SPM                      
     ON SPM.SUBPROCESSID=TM.SUBPROCESSID LEFT JOIN DBO.PROCESSMASTER PM                      
     ON PM.PROCESSID=SPM.PROCESSID LEFT JOIN DBO.DEPARTMENTMASTER DM                      
     ON DM.DEPARTMENTID=PM.PROCESSID                      
     WHERE  EMP.ACTIVE=1 AND EMP.COMPANYID=ISNULL(@1,EMP.COMPANYID)  and Emp.employeeID=isnull(@4,Emp.employeeID)                             
     AND DOJ BETWEEN @SDATE AND @EDATE   and employeementStatusid=isnull(@7,employeementStatusid)        
     and   PM.PROCESSID=isnull(@6,PM.PROCESSID)                     
     ORDER BY EMP.EmployeeID             
      END      
END
GO
/****** Object:  StoredProcedure [dbo].[USP_EDB_getUserTabItem]    Script Date: 08/08/2012 21:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_EDB_getUserTabItem]  -- '101173'  
 @1 VARCHAR(20)      
AS      
BEGIN      
 SET NOCOUNT ON;      
if @1<>'0'      
BEGIN      
 DECLARE @toplevel TABLE      
 ( PageID int,      
  controlKey varchar(100),       
  PageName varchar(100),      
  Readonly int,
  PageDescription   varchar(500)    
 )      
 DECLARE @RoleID int      
 SELECT @RoleID=RoleID FROM dbo.Login WHERE EmployeeID=@1      
    
 INSERT INTO @toplevel SELECT SR.PageID ,      
        mm.ControlKey ,      
        mm.PageName ,      
        SR.ReadOnly ,mm.PageDescription     
      FROM dbo.ModuleMatrix_Tabs mm INNER JOIN dbo.SpecialRights_Tabs SR      
        ON SR.PageID=mm.PageID      
      WHERE SR.EmployeeID=@1 AND SR.Active='True'       
        AND mm.Active='True'     
      
 INSERT INTO @toplevel SELECT mm.PageID ,      
        mm.ControlKey,      
        mm.PageName ,      
        rm.ReadOnly ,mm.PageDescription     
      FROM dbo.ModuleMatrix_Tabs mm INNER JOIN dbo.RoleMatrix_Tabs rm      
        ON rm.PageID=mm.PageID      
      WHERE rm.RoleID=@RoleID AND rm.Active='True'      
        AND mm.Active='True' AND ParentNode=0      
        AND mm.PageID NOT IN       
        (SELECT PageID FROM @toplevel)      
      
     SELECT * FROM @toplevel ORDER BY controlKey      
 END      
Else      
 BEGIN      
  SELECT PageID ,  ControlKey,  PageName ,PageDescription,  '0'AS readonly  FROM dbo.ModuleMatrix_Tabs  WHERE Active='True' AND ParentNode=0      
  ORDER BY controlKey      
 END      
    
END
GO
/****** Object:  StoredProcedure [dbo].[USP_EDB_GetPunchCardDeatails]    Script Date: 08/08/2012 21:51:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                          
-- Author:  Pankaj                                        
-- Create date: 09 Nov 2011                                        
-- Description: Get punch card details                                        
-- =============================================                                          
                                                   
ALTER PROCEDURE [dbo].[USP_EDB_GetPunchCardDeatails]--'1/12/2011','','0','55','101167',''  
--declare                                        
@1 varchar(50),-- From date                                          
@2 varchar(50),--EmployeeId                                          
@3 varchar(50),--ProcessId                                          
@4 varchar(50),-- CompanyId                      
@5 varchar(50)='0',--userID  
@6 varchar(50)='0'--Employmentstatusid               
                                        
as                                        
Begin                                        
              
--              
--set @1='2/1/2012'              
--set @2='101166'              
--set @3='0'              
--set @4='55'            
--set @5='101166'              
--set @6='0'


if(@6='0')
Begin
	set @6='1,5'
End

              
              
declare @date datetime,              
@select varchar(2000),              
@where varchar(1000),              
@role varchar(10)              
                                        
set @date=cast(@1 as datetime)              
set @role=(select roleID from login where employeeID=@5)              
                                    
--IF( @2<>'')              
--BEGIN                                 
                                
                                  
set @select='SELECT  EM.EmployeeID,                                        
 employeeName=isnull(EM.FirstName,'''')+'' ''+isnull(EM.MiddleName,'''')+'' ''+isnull(EM.LastName,'''') ,                                        
 ''IODate''='''+@1+''',                                        
 ''IOTime''=isnull((SELECT Min(IOTime) FROM EmployeeAttendance EA WHERE (IOStatus = ''Entry'') and (IODate='''+cast(@date as varchar)+''') and EA.employeeID=cast(EM.employeeID as varchar)),(SELECT max(IOTime) FROM EmployeeAttendanceMissing EA          
          
 WHERE (IOStatus = ''Entry'') and (IODate='''+cast(@date as varchar)+''') and EA.employeeID=cast(EM.employeeID as varchar))),              
 ''OTime''=isnull((SELECT max(IOTime) FROM EmployeeAttendance EA WHERE (IOStatus = ''Exit'') and (IODate='''+cast(@date as varchar)+''') and EA.employeeID=cast(EM.employeeID as varchar)),(SELECT max(IOTime) FROM EmployeeAttendanceMissing EA           
WHERE (IOStatus = ''Exit'') and (IODate='''+cast(@date as varchar)+''') and EA.employeeID=cast(EM.employeeID as varchar))),              
 ''Card Punch''=case               
     when (SELECT count(AttendanceID) FROM EmployeeAttendance EA WHERE  (IODate='''+cast(@date as varchar)+''') and IOStatus=''Entry'' and EA.employeeID=cast(EM.employeeID as varchar)) >0 then ''Yes''              
     when (SELECT count(AttendanceID) FROM EmployeeAttendanceMissing EA WHERE  (IODate='''+cast(@date as varchar)+''') and EA.employeeID=cast(EM.employeeID as varchar))>0 then ''Yes (Marked By HR)''               
     else ''No'' end,                  
''Remark''=(SELECT TOP 1 Remark FROM EmployeeAttendanceMissing EA WHERE (IOStatus = ''Entry'') and (IODate='''+cast(@date as varchar)+''') and EA.employeeID=cast(EM.employeeID as varchar))                                                                   
  
    
      
        
         
 FROM  EmployeeMaster EM '              
                                    
 --set @where=' where  (EM.EmployeementStatusID in (1,5)) AND (EM.Active = 1)'              
set @where=' where  (EM.EmployeementStatusID in ('+@6+')) AND (EM.Active = 1)'              
              
              
if( @2<>'')              
Begin              
 set @where=@where + '  AND EM.employeeID='''+@2+''''              
End              
              
if( @3<>'0')              
Begin              
 set @where=@where + '  AND EM.teamID in(SELECT     TM.TeamID              
       FROM         TeamMaster AS TM INNER JOIN              
              SubProcessMaster ON TM.SubProcessID = SubProcessMaster.SubProcessID INNER JOIN              
              ProcessMaster AS PM ON SubProcessMaster.ProcessID = PM.ProcessID              
       WHERE     (PM.ProcessID ='+ @3 +' ))'              
End              
              
if( @4<>'0')              
Begin              
 set @where=@where + '  AND EM.companyID='''+@4+''''              
End              
              
              
if(@role not in ('4'))              
Begin              
 set @where=@where + ' AND (               
      EM.EmployeeID in (SELECT  EmployeeID FROM EmployeeReportingLead WHERE  (Active = 1) AND (HeadID = '+@5+'))               
       or EM.EmployeeID='+ @5 +'              
      )'               
End              
              
              
              
print(@select + @where)              
exec(@select + @where)              
                              
End
GO
/****** Object:  StoredProcedure [dbo].[usp_AlertEmployeeLeaveStatement]    Script Date: 08/08/2012 21:51:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[usp_AlertEmployeeLeaveStatement]
	@1 varchar(50),--Start Date                                                          
	@2 varchar(50)--End Date   

AS
BEGIN

	SET NOCOUNT ON;

	        
        BEGIN TRY
        
			DECLARE @CID  VARCHAR(10) 
			DECLARE @4 VARCHAR(10)
			
			DECLARE C30 CURSOR 
			FOR SELECT EmployeeId FROM EmployeeMaster WHERE Active=1 and employeementStatusID in (1,5)
			OPEN C30
			FETCH NEXT FROM C30 INTO @CID
			WHILE(@@FETCH_STATUS=0)
			BEGIN
			SET @4=CAST(@CID AS VARCHAR(10))                                                               
				EXEC USP_AlertEmployeeLeaveStatementMonthly @1, @2,@4
			FETCH NEXT FROM C30 INTO @CID
			END
			CLOSE C30
			DEALLOCATE C30
 
				
        END TRY
        BEGIN CATCH
        			
			SELECT 'ERROR MESSAGE '+ ERROR_MESSAGE()
                 
        END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[USP_AlertPendingLeavesReminder]    Script Date: 08/08/2012 21:51:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--======================================================================= =                         
 --Author:  PANKAJ YADAV                          
 --Create date: 5 JUNE 2012                        
 --Description: ARMS Pending Leave  reminder mailer                        
 --========================================================================                          
ALTER PROCEDURE [dbo].[USP_AlertPendingLeavesReminder]                          
AS                          
BEGIN        
    
                      
 SET NOCOUNT ON     
                          
 Declare @EmailSubject varchar(500)                           
 Declare @htmlTop VARCHAR(MAX)                             
 Declare @htmlBottom VARCHAR(MAX)                          
 DECLARE @htmlTable  VARCHAR(MAX)                             
 Declare @htmlDisclaimer VARCHAR(MAX)                           
 Declare @htmlTemp VARCHAR(MAX)                          
 Declare @ControlTemp VARCHAR(MAX)    
 Declare @ControlTemp1 VARCHAR(MAX)                        
  ,@leaveID int                        
  ,@leaveSummaryID int                        
  ,@userName varchar(500)                        
  ,@empID varchar(50)                        
  ,@userID varchar(50)                        
  ,@leaveType varchar(50)                         
  ,@leaveDate varchar(50)                        
  ,@leaveComment varchar(200)                        
  ,@leaveDuration varchar(50)                        
  ,@leaveStatus varchar(50)                        
  ,@headingTemp varchar(200)                        
  ,@leaveTransID int                        
  ,@mailTo varchar(MAX)           
  ,@mailToUnique varchar(MAX)                        
  ,@mailCc varchar(8000)                        
  ,@isGrouped varchar(10)                        
  ,@Supervisor varchar(1000)                      
  ,@EnteredBy varchar(50)                    
  ,@ReminderDate datetime                   
  ,@AutoCancellationDate datetime                
         
                
IF EXISTS(SELECT LeaveID,EmployeeID FROM LeaveDetails WHERE LeaveStatusID=1)                        
BEGIN                        
  set @htmlTemp='';                        
  Set @htmlTop = '<html >                          
         <head runat="server">                          
          <style type="text/css">                        
 body                        
   {                        
   font-size:11px;                          
   }                          
      .style1                          
      {                          
    width: 100%;                          
    --background-color:#b0b0b0;                          
    font-family:Arial;                          
    --font-size:11px;                          
      }                          
      .style2                          
      {                          
    background-color: #e0e0e0;                          
    font-weight:bold;                          
      }                          
      .style3                          
      {                          
    text-align: center;                          
      }                          
      .style4                          
      {                          
    --font-family: Arial, Helvetica, sans-serif;                          
    --font-size: small;                          
    font-weight: bold;                          
    color: #3333FF;                          
      }                          
      .style5                          
      {                          
    background-color:White;                          
      }                           
     .tdRed                          
      {                          
    background-color:#ee9999;                          
      }                         
    .style6                          
      {                          
    text-align: right;                          
      }                          
     </style>                          
    </head>                          
  <body>                                                
  <table cellpadding="5" cellspacing="1" class="style1" >                          
            '                          
 set @htmlBottom='</table>'                          
 Set @htmlDisclaimer = '<table><tr><td class="securityFooter"><br><br><hr>                        
    This is an autogenerated mail from ARMS. For any questions or clarifications please call HR Helpdesk                        
    <br/><br/>                        
   Regards,                        
   <br/>                        
   Human Resources Development<br/>                        
   Accretive Health.                        
   <br/><br/>                        
   </td></tr></table></body></html>    
       
   '     
       
       
   Declare  @tblReportingLead table (HeadID Varchar(50))    
    Declare  @tblLeaveSummary table (LeaveSummaryID Varchar(50))    
   DECLARE @HeadID Varchar(50)    
       
   INSERT INTO @tblReportingLead    
   SELECT DISTINCT HEadID FROM EmployeeReportingLead WHERE Active=1 AND ReportingType='Direct' AND EmployeeID in (    
      SELECT    distinct LD.EmployeeID     
      FROM         LeaveSummary AS LS INNER JOIN                    
        LeaveDetails AS LD ON LD.LEAVESUMMARYID = LS.LEAVESUMMARYID            
        INNER JOIN   EmployeeMAster EM          
         ON (LD.EmployeeID= EM.EmployeeID)           
      WHERE     LD.LeaveStatusID=1  AND EM.EmployeementStatusId in (1,5) AND EM.Active=1  AND CONVERT(VARCHAR,ISNULL(LD.LastReminderDate,LS.AppliedOn),101) < Convert(Varchar,GETDATE(),101)      
       
        
    )     
        
        
     --------------------------------------------------------------------------------------------------------------     
               
   DECLARE ReportingHeadCursor CURSOR FOR                       
  SELECT HeadID FROM  @tblReportingLead    
   OPEN ReportingHeadCursor                     
   FETCH NEXT FROM ReportingHeadCursor INTO @HeadID                    
   WHILE @@FETCH_STATUS = 0                      
    BEGIN                     
                    
     SET @controlTemp=''     
     SET @controlTemp1=''               
     SET @leaveType=''                
     SET @leaveComment=''                
     SET @userID=''                
     SET @AutoCancellationDate=''                
     SET @userName=''    
     SET @htmlTable=''    
     SET @htmlTemp=''    
                     
               
     SET @controlTemp='    
      <table cellpadding="5" cellspacing="0" border="1" width="100%">                
        <tr>                
       <td class="style2">                         
          Employee ID                        
          </td>                             
        <td class="style2">                         
          Name                        
          </td>                             
         <td class="style2">                         
          Applied Date(s)                        
          </td>                          
         <td class="style2">                         
          Type of Leave                        
          </td>                
          <td class="style2">                         
          Status                        
          </td>                           
         <td class="style2">                         
          Duration (hours)                        
          </td>                          
         <td class="style2">                         
          Comments                        
          </td>                  
        <td class="style2">                         
          Auto Cancellation Date                        
          </td>                           
        </tr>     
                 
       '       
           
  Set @EmailSubject ='ARMS-Leave Notification - Pending for approval'                   
                    
                    
         
       
 ----------------------------------------Cursor Leave Details------------------------------------------                
                  
        DECLARE CursorLeaveDetail CURSOR FOR      
           SELECT    distinct LD.LeaveID, LD.EmployeeID,LD.LEAVESUMMARYID                 
      FROM         LeaveSummary AS LS INNER JOIN                    
        LeaveDetails AS LD ON LD.LEAVESUMMARYID = LS.LEAVESUMMARYID            
        INNER JOIN   EmployeeMAster EM          
         ON (LD.EmployeeID= EM.EmployeeID)           
      WHERE       LD.LeaveStatusID=1 AND EM.EmployeementStatusId in (1,5) AND EM.Active=1  AND CONVERT(VARCHAR,ISNULL(LD.LastReminderDate,LS.AppliedOn),101) < Convert(Varchar,GETDATE(),101)                   
         AND EM.EmployeeID in (SELECT EmployeeID FROM EmployeeReportingLead WHERE Active=1 AND ReportingType='Direct' AND HeadID=@HeadID )    
      ORDER BY LEaveSummaryID     
         
          OPEN CursorLeaveDetail                     
                             
           FETCH NEXT FROM CursorLeaveDetail INTO @leaveID ,@UserId,@leaveSummaryID                   
           WHILE @@FETCH_STATUS = 0                      
            BEGIN                      
                   
                SET @LeaveDuration=''                
    SET @leaveDate=''                
    SET @leaveStatus=''     
    Set @userName=''    
    Set @leaveType=''    
    Set @leaveComment=''    
    SET @AutoCancellationDate=''    
    SET @leaveDate=''    
    SET @leaveStatus=''    
        
        
    SET @userName=(SELECT  isnull(FirstName,' ')+' '+ isnull(MiddleName,' ')+' '+isnull(LastName,' ') FROM EmployeeMaster where employeeID=@userID)                               
     SELECT                     
       @leaveType=LT.LeaveType                    
      , @leaveComment=LS.Reason                    
      ,@userID=LS.AppliedBy                   
      ,@AutoCancellationDate=DATEADD(day,5,LS.StartDate)                 
      FROM  LeaveSummary AS LS INNER JOIN                    
      LeaveType AS LT ON LS.LeaveTypeID = LT.LeaveTypeID                    
      WHERE LS.LeaveSummaryID=@leaveSummaryID     
                              
            SELECT @LeaveDuration=case LeaveDuration                     
                   when 1 then 9                     
                   when .5 then 4.5                     
                   when .25 then 2                     
                   else 0                     
                   end,                     
               @leaveDate=convert(varchar,DateApplied,103)                
              ,@leaveStatus=(SELECT LeaveStatus FROM LeaveStatusMaster where LeavestatusID=LeaveDetails.LeavestatusID)                     
            FROM  LeaveDetails                     
            WHERE LeaveID=@leaveID                    
              
      SET @controlTemp1=@controlTemp1+' <tr>                      
       <td>                     
     '+ ISNULL(@userID,'') +'                    
     </td>                      
      <td>                     
     '+ ISNULL(@userName,'') +'                    
     </td>                      
       <td>                     
     '+ ISNULL(@leaveDate,'') +'                    
     </td>                      
       <td>                     
     '+ISNULL(@leaveType,'')+'                    
     </td>                 
      <td>                     
     '+ISNULL(@leaveStatus,'')+'                    
     </td>                   
      <td>                     
     '+ISNULL(@LeaveDuration,'')+'                    
     </td>                   
       <td>                     
     '+ISNULL(@leaveComment,'')+'                    
     </td>                      
       <td>                     
     '+CONVERT(VARCHAR,@AutoCancellationDate,103)+'                    
     </td>                      
      </tr>'     
              
              
     IF NOT EXISTS (SELECT LeaveSummaryID From @tblLeaveSummary WHERE LeaveSummaryID=@leaveSummaryID)    
     BEGIN    
      INSERT INTO @tblLeaveSummary (LeaveSummaryID) VALUES (@leaveSummaryID)    
     END    
                  
            FETCH NEXT FROM CursorLeaveDetail INTO @leaveID ,@UserId,@leaveSummaryID                       
            END                      
          CLOSE CursorLeaveDetail                      
          DEALLOCATE CursorLeaveDetail                    
          
     ----------------------------------------End Cursor Leave Details------------------------------------------      
        -- PRINT @htmlTable        
   SET @controlTemp1=@controlTemp1+' </table>'                     
   SET @htmlTemp='<tr>                      
     <td >                     
     Following Leaves are waiting for your approval in ARMS: <a href=''http://10.240.152.55/Arms/default.aspx''>Click Here to view online</a>                   
     </td>                      
     </tr><tr><td>'+ @controlTemp+@controlTemp1+'</td></tr>'                    
        
       PRINT @htmlTop    
       PRINT @htmlTemp    
       PRINT @htmlBottom    
       PRINT @htmlDisclaimer    
         
      Set @htmlTable  =@htmlTop+@htmlTemp+ @htmlBottom +@htmlDisclaimer     
      -- PRINT @htmlTable     
                           
      SET @mailto=null             
      SET @mailCC=null                          
                  
      SELECT  @mailto=  ISNULL(EmailID,'') from employeeMaster  WHERE EmployeeID=@HeadID                
      SET  @mailCC = ''    
        
     --print @htmlTable                
  --print  @htmlTable                  
  --print  @ReminderDate                  
                        
       SET @ReminderDate=(SELECT ISNULL(LD.LastReminderDate,LS.AppliedOn) FROM LeaveDetails LD INNER JOIN LeaveSummary LS ON LD.LeaveSummaryID=LS.LeaveSummaryID  WHERE  LD.LeaveID=@leaveID )                                 
        
      --PRINT @mailto+'-'+@HeadID     
      Print @htmlTable       
     
  EXEC msdb.dbo.sp_send_dbmail  @profile_name = 'ARMS',                      
  @recipients =@mailto,--'nasimuddin@accretivehealth.com',                      
  @copy_recipients=@mailCC,                    
  @subject =  @EmailSubject,                      
  @body = @htmlTable,                      
  @body_format = 'HTML',                      
  @importance =  'HIGH' ;                 
           
           
      -- UPDATE LeaveDetails SET LastReminderDate =GETDATE() WHERE LeaveSummaryID=@leaveSummaryID                
  FETCH NEXT FROM ReportingHeadCursor INTO @HeadID                    
 END                      
                   
   CLOSE ReportingHeadCursor                      
   DEALLOCATE ReportingHeadCursor      
       
   -----------------------update last Reminder date-------------------------------------------------------------    
     
   IF EXISTS (SELECT LeaveSummaryID FROM @tblLeaveSummary)    
   BEGIN    
  UPDATE LeaveDetails SET LastReminderDate =GETDATE()     
  WHERE LeaveSummaryID in ( SELECT DISTINCT LeaveSummaryID FROM @tblLeaveSummary )      
   END    
      
      
   --------------------------------------------------------------------------------------------------------------    
                       
End                  
END
GO
/****** Object:  StoredProcedure [dbo].[USP_AlertPendingLeaves]    Script Date: 08/08/2012 21:51:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================          
-- Author:  PANKAJ YADAV          
-- Create date: 5 JUNE 2012        
-- Description: ARMS Pending Leave alert reminder mailer        
-- =============================================          
ALTER PROCEDURE [dbo].[USP_AlertPendingLeaves]          
AS          
BEGIN          
 SET NOCOUNT ON          
 Declare @CurrentTimeStamp varchar(100)           
 Declare @EmailSubject varchar(255)           
 Declare @htmlTop NVARCHAR(2000)             
 Declare @htmlBottom NVARCHAR(1000)          
 DECLARE @htmlTable  NVARCHAR(MAX)             
-- Declare @htmlControls  NVARCHAR(MAX)             
-- Declare @htmlControlTop NVARCHAR(MAX)            
 Declare @htmlDisclaimer NVARCHAR(1000)           
 Declare @htmlTemp NVARCHAR(MAX)          
 Declare @ControlTemp NVARCHAR(MAX)        
  ,@strEmail nvarchar(1000)          
  ,@leaveID int        
  ,@leaveStatusID int        
  ,@leaveSummaryID int        
  ,@empName varchar(300)        
  ,@userName varchar(300)        
  ,@empID varchar(50)        
  ,@userID varchar(50)        
  ,@leaveType varchar(50)         
  ,@leaveDate varchar(50)        
  ,@leaveComment varchar(200)        
  ,@leaveDuration varchar(50)        
  ,@leaveStatus varchar(50)        
  ,@isAssignedLeave varchar(10)        
  ,@headingTemp varchar(200)        
  ,@leaveCount int        
  ,@leaveTransID int        
  ,@mailTo varchar(8000)        
  ,@mailCc varchar(8000)        
  ,@isGrouped varchar(10)        
  ,@Supervisor varchar(1000)      
  ,@EnteredBy varchar(50)       
          
 --Select @sDate = CONVERT(VARCHAR(20),DATEADD(dd,-1,getdate()),101)     
 CREATE TABLE #LeaveDetails    
 (      
   LeaveID varchar(50),    
   EmployeeID Varchar(20)              
 )     
    
INSERT #LeaveDetails SELECT LeaveID,EmployeeID FROM LeaveDetails WHERE LeaveStatusID=1      
  
IF EXISTS(SELECT LeaveID FROM #LeaveDetails )        
BEGIN        
  set @htmlTemp='';        
  Set @htmlTop = '<html >          
         <head runat="server">          
          <style type="text/css">        
    body        
  {        
  font-size:11px;          
  }          
      .style1          
      {          
    width: 100%;          
    --background-color:#b0b0b0;          
    font-family:Arial;          
    --font-size:11px;          
      }          
      .style2          
      {          
    background-color: #e0e0e0;          
    font-weight:bold;          
      }          
      .style3          
      {          
    text-align: center;          
      }          
      .style4          
      {          
    --font-family: Arial, Helvetica, sans-serif;          
    --font-size: small;          
    font-weight: bold;          
    color: #3333FF;          
      }          
      .style5          
      {          
    background-color:White;          
      }           
     .tdRed          
      {          
    background-color:#ee9999;          
      }         
    .style6          
      {          
    text-align: right;          
      }          
     </style>          
    </head>          
    <body>          
                       
          <table cellpadding="5" cellspacing="1" class="style1" >          
            '          
       set @htmlBottom='</table>'          
       Set @htmlDisclaimer = '<table><tr><td class="securityFooter"><br><br><hr>        
    This is an autogenerated mail from ARMS. For any questions or clarifications please call HR Helpdesk        
    <br/><br/>        
   Regards,        
   <br/>        
   Human Resources Development<br/>        
   Accretive Health.        
   <br/><br/>        
   </td></tr></table></body></html>'            
        
    DECLARE CursorLeaveStatus CURSOR FOR           
       SELECT LeaveID,EmployeeID FROM #LeaveDetails     
        
      OPEN CursorLeaveStatus         
        
       FETCH NEXT FROM CursorLeaveStatus INTO @leaveID,@userID        
        
       WHILE @@FETCH_STATUS = 0          
        BEGIN          
          
        SET @userName=(SELECT  isnull(FirstName,' ')+ ' '+isnull(MiddleName,' ')+' '+isnull(LastName,' ') FROM EmployeeMaster where employeeID=@userID)        
        SELECT @LeaveDuration=case LeaveDuration         
               when 1 then 9         
               when .5 then 4.5         
               when .25 then 2         
               else 0         
               end,         
          @leaveDate=convert(varchar,DateApplied,103),        
          @leaveSummaryID=leaveSummaryID,        
          --@leaveStatus=(SELECT LeaveStatus FROM LeaveStatusMaster where LeavestatusID=LeaveDetails.LeavestatusID),        
          @leaveStatusID=LeavestatusID        
        FROM  LeaveDetails         
        WHERE LeaveID=@leaveID        
        SELECT @leaveType=LT.LeaveType        
    , @leaveComment=LS.Reason        
         --,@userID=LS.AppliedBy        
        FROM  LeaveSummary AS LS INNER JOIN        
           LeaveType AS LT ON LS.LeaveTypeID = LT.LeaveTypeID        
        WHERE LS.LeaveSummaryID=@leaveSummaryID        
      
       SET @leaveStatus=(SELECT LeaveStatus FROM LeaveStatusMaster WHERE (LeaveStatusID IN (SELECT LeaveStatusID FROM LeaveTransaction WHERE (LeaveTransID = @leaveTransID))))     
       SET @enteredBy=(SELECT  isnull(FirstName,' ')+' '+ isnull(MiddleName,' ')+' '+isnull(LastName,' ') FROM EmployeeMaster where employeeID in (SELECT EnteredBy FROM LeaveTransaction WHERE (LeaveTransID = @leaveTransID)))       
        
      if(@LeavestatusID=15)Begin set @headingTemp='('+@leaveStatus+ ') ' end        
       else begin  set @headingTemp='('+@leaveStatus+ ') by ('+@enteredBy +')' end    --your Supervisor' end        
        
       Set @EmailSubject ='ARMS-Leave Notification - Pending for approval'        
       SET @controlTemp='<table cellpadding="5" cellspacing="0" border="1" width="100%"><tr>          
         <td class="style2">         
           Employee ID        
           </td>             
         <td class="style2">         
           Name        
           </td>             
          <td class="style2">         
           Applied Date(s)        
           </td>          
          <td class="style2">         
           Type of Leave        
           </td>          
          <td class="style2">         
           Duration (hours)        
           </td>          
          <td class="style2">         
           Comments        
           </td>          
         </tr>        
         <tr>          
         <td>         
           '+ @userID +'        
           </td>          
         <td>         
           '+ @userName +'        
           </td>          
          <td>         
           '+ @leaveDate +'        
           </td>          
          <td>         
           '+@leaveType+'        
           </td>          
          <td>         
           '+@LeaveDuration+'        
           </td>          
          <td>         
           '+@leaveComment+'        
           </td>          
         </tr>'        
        
            set @controlTemp=@controlTemp+' </table>'         
            set @htmlTemp='<tr>          
               <td >         
                Following Leaves are waiting for your approval in ARMS: <a href=''http://10.240.152.55/Arms/default.aspx''>Click Here to view online</a>       
                </td>          
              </tr><tr><td>'+ @controlTemp+' </td></tr>'        
             Set @htmlTable  =@htmlTop+@htmlTemp+ @htmlBottom +@htmlDisclaimer          
        -- print @htmlTable          
         
   SET @mailCC=null    
   SELECT @mailCC= emailID from employeeMaster where employeeID =@userID  AND EmployeementStatusId in (1,5)  AND Active=1      
        
        SELECT  @mailto= isnull(@mailto+';','')+ EmailID from employeeMaster where EmployeementStatusId in (1,5)  AND Active=1 AND employeeID in(SELECT HeadID FROM EmployeeReportingLead WHERE (EmployeeID = @userID) AND (ReportingType = 'Direct') and Active=1)  
    
     DECLARE @MailCCUnique1 varchar(max)    
     SET  @MailCCUnique1=null    
     SELECT @MailCCUnique1=isnull(@MailCCUnique1+';','')+ string  from dbo.split(@mailCC,';') where (string is not null) and (string<>'') group by string                
      
    
          --EXEC msdb.dbo.sp_send_dbmail  @profile_name = 'ARMS',          
          --@recipients =@mailto,--'nasimuddin@accretivehealth.com',          
          --@copy_recipients=@MailCCUnique1,        
          --@subject =  @EmailSubject,          
          --@body = @htmlTable,          
          --@body_format = 'HTML',          
          --@importance =  'HIGH' ;           
          
           --Print @leaveID    
     
     
   DELETE FROM #LeaveDetails WHERE LeaveID=@leaveID    
    
        FETCH NEXT FROM CursorLeaveStatus INTO @leaveID ,@userID         
        END          
              
      CLOSE CursorLeaveStatus          
      DEALLOCATE CursorLeaveStatus         
        
End          
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Product_InsertProductList]    Script Date: 08/08/2012 21:51:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================            
-- Author:  Satya            
-- Create date: 22 May 2012      
-- Description: Insert ProductList          
-- =============================================            
ALTER PROCEDURE [dbo].[USP_Product_InsertProductList]          
@1 VARCHAR(MAX),--PRODUCTID          
@2 VARCHAR(50),--Lanid          
@3 VARCHAR(50)--Userid        
AS          
    
BEGIN          
    
DECLARE @RESULT VARCHAR(50)     
    
if(@2<>'')          
BEGIN       
       
 INSERT INTO ProductUserMatrix          
 (ProductID, LanID, active, CreatedOn, CreatedBy)          
 SELECT STRING,@2,1,GETDATE(),@3 FROM dbo.Split(@1,',')           
 WHERE STRING NOT IN( SELECT ProductUserMatrix.ProductID FROM ProductUserMatrix WHERE Active=1 and LanID=@2)          
     
     
 ------Product pages check and assign pages to User---------------    
 IF EXISTS(Select PageID from ProductPageMatrix  where ProductID =@1)    
 BEGIN    
  INSERT INTO SpecialRights(EmployeeID,PageID,ReadOnly,Active,CreatedDate,CreatedBy)    
     SELECT @2,PageID,0,1,GETDATE(),@3    
     FROM         ProductPageMatrix    
     WHERE     (ProductID in (SELECT STRING FROM dbo.Split(@1,','))) and active=1     
     and pageid not in(select pageid from SpecialRights where EmployeeID=@2 and Active=1)    
         
         
 End    
     
    
 SET @RESULT=1          
END          
ELSE          
BEGIN          
 SET @RESULT=-1          
END          
 RETURN @RESULT         
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Product_DeleteProductList]    Script Date: 08/08/2012 21:51:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================          
-- Author:  Satya          
-- Create date: 22 May 2012    
-- Description: Delete ProductList        
-- =============================================          
ALTER PROCEDURE [dbo].[USP_Product_DeleteProductList]  --'4,26','100000',101062          
@1 VARCHAR(MAX),--ProductId        
@2 VARCHAR(50),--EMPID        
@3 VARCHAR(50)--Userid      
AS        
BEGIN      
--Declare
--@1 VARCHAR(MAX)='4,26',--ProductId        
--@2 VARCHAR(50)=100000,--EMPID        
--@3 VARCHAR(50)=101062 --Userid      
  
DECLARE @query VARCHAR(MAX)        

--SET @query='UPDATE ProductUserMatrix SET active = 0,UpdatedOn='''+ convert(varchar,GETDATE(),101)+''',UpdatedBy= '+@3+'        
--WHERE (ProductID in('+@1+')) AND (LanID = '''+@2+''')'      

--SELECT STRING FROM dbo.Split(@1,',')

UPDATE ProductUserMatrix SET active = 0,UpdatedOn=GETDATE(),UpdatedBy= @3        
WHERE (cast(ProductID as varchar) in(SELECT STRING FROM dbo.Split(@1,','))) AND (LanID = @2)
  
UPDATE SpecialRights SET Active=0, LastUpdtaed=GETDATE(), UpdatedBy= @3  
WHERE PageID in (SELECT PageID from ProductPageMatrix WHERE cast(ProductID as varchar) in (SELECT STRING FROM dbo.Split(@1,',')) AND Active=1)
   
        
--EXEC(@query)        
RETURN 2        
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetUserName]    Script Date: 08/08/2012 21:51:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_GetUserName]     
@1 VARCHAR(50)--lANID    
As    
--DECLARE @EMPID VARCHAR(50)    
--SELECT @EMPID=EmployeeID FROM dbo.Login WHERE LanID=@1    
--SELECT FirstName+' '+ISNULL(MiddleName,'')+' '+ISNULL(LastName,'') as Name from EmployeeMaster where EmployeeID=@EMPID  
  
SELECT FirstName+' '+ISNULL(MiddleName,'')+' '+ISNULL(LastName,'') as Name,Login.RoleID,EmployeeMaster.EmployeeID FROM EmployeeMaster  
INNER JOIN Login ON EmployeeMaster.EmployeeID=Login.EmployeeID WHERE  LanID=@1
GO
/****** Object:  StoredProcedure [dbo].[USP_eExitGetResignation]    Script Date: 08/08/2012 21:51:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                  
-- Author:  Nasim              
-- Create date: 16 Jan 2012            
-- Description: Get resignation Details            
-- =============================================                                  
ALTER PROCEDURE [dbo].[USP_eExitGetResignation]              
--declare              
@1 varchar(20), --From            
@2 varchar(20), --To             
@3 varchar(20), --CompanyID            
@4 varchar(20), --Process id            
@5 varchar(20), --EmployeeID            
@6 varchar(20), --Status            
@7 varchar(20) --User ID            
            
AS                              
BEGIN              
SET NOCOUNT ON;              
            
            
--declare              
--@1 varchar(20), --From            
--@2 varchar(20), --To             
--@3 varchar(20), --CompanyID            
--@4 varchar(20), --Process id            
--@5 varchar(20), --EmployeeID            
--@6 varchar(20), --Status            
--@7 varchar(20) --User ID              
            
            
--set @1='1/1/2012'              
--set @2='1/17/2012'              
--set @3='0'              
--set @4='0'              
--set @5=''              
--set @6='0'              
--set @7='0'              
            
            
Declare @fromDate datetime            
,@toDate datetime            
,@roleID int            
,@access varchar(10)            
            
set @fromDate=cast(@1 as datetime)            
set @toDate=cast(@2 as datetime)            
if(@7='0')    
 Begin              
  select @roleID=4           
 End    
else    
 Begin    
  select @roleID=roleId from login where employeeID=@7 and active=1            
 End    
            
set @access='False'    
            
if(@roleID=4)            
 Begin            
 set @access='True'            
 End            
            
            
declare @sql varchar(max)            
,@where varchar(max)            
,@orderBy varchar(100)            
            
set @sql='SELECT                 
vEM.EmployeeID            
, vEM.Name            
, vEM.DOJ            
, convert(varchar,ER.ResignationDate,101) as ResignationDate            
, ER.ResignationDetails            
, vEMU.Name AS EnteredBy            
, ER.ResignationID  
, convert(varchar,ER.ResignationRevokeDate,101) as ResignationRevokeDate        
,RSM.resignationStatus            
,vEM.Process            
,vEM.Company            
,[Access]= cast((          
   case when '+ cast(@roleID as varchar)+'=4 and ER.ResignationStatusID in (4,3) then 1             
    when '+ cast(@roleID as varchar)+'<> 4 and ER.ResignationStatusID in (1) then 1          
    Else 0          
   End           
   )          
  as bit)        
, convert(varchar,ER.LastDayWorked ,101) as LastDayWorked            
,convert(varchar,ER.LastDayWorkedByPolicy ,101) as LastDayWorkedByPolicy        
,ER.ReasonDetails        
,[Reason]=(select reason from resignationReasonMaster where reasonID= ER.ReasonID)        
        
   FROM         VW_EmployeeDetails AS vEM INNER JOIN            
          EmployeeResignation AS ER ON vEM.EmployeeID = ER.EmployeeID INNER JOIN            
          VW_EmployeeDetails AS vEMU ON ER.EnteredBy = vEMU.EmployeeID INNER JOIN            
          ResignationStatusMaster RSM ON ER.ResignationStatusID = RSM.resignationStatusID            
   WHERE     (ER.Active = 1)'            
            
set @where=' and (ER.ResignationDate between '''+ @1 +''' and '''+@2 +' 11:59:59 PM'') '            
            
if(@3<>'0')            
Begin            
 set @where=@where+' and vEM.companyID='+@3            
End            
            
if(@4<>'0')            
Begin            
 set @where=@where+' and vEM.processID='+@4            
End            
            
if(@5<>'')            
Begin            
 set @where=@where+' and vEM.employeeID='+@5            
End            
            
if(@6<>'0')            
Begin            
 set @where=@where+' and RSM.resignationStatusID='+@6            End            
            
if(@roleID<>'4')            
Begin            
 set @where=@where+' and vEM.employeeID in (select employeeID from employeeReportingLead where headID='+@7+' and active=1 union select '+ @7+')'            
End            
            
            
set @orderBy=' order by ER.resignationID desc'            
        
--print(@sql + @where)            
exec(@sql + @where +@orderBy)            
            
            
                
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetDRName]    Script Date: 08/08/2012 21:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Manish Sharma>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER function [dbo].[GetDRName]
(	
--DECLARE
	@EMPID varchar(20)
)
RETURNS varchar(max)
AS

BEGIN
--SET @DOJ=CONVERT(DATETIME,'11/10/2008')
--SET @CON='RECENT'

DECLARE @NAME VARCHAR(MAX)
SET @NAME=''

SELECT @NAME=@NAME+[FIRSTNAME]+' '+ISNULL([MIDDLENAME],'')+' '+ISNULL([LASTNAME],'')+','           
  FROM [EMPLOYEEMASTER] E WHERE E.[EMPLOYEEID] in (SELECT HEADID           
              FROM DBO.EMPLOYEEREPORTINGLEAD          
              WHERE EMPLOYEEID=@empID AND ACTIVE=1 and ReportingType='Direct')
and employeementstatusID in(1,5)              

SET @NAME=SUBSTRING(@NAME,0,LEN(@NAME))

RETURN @NAME
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Get_EmpAttendanceStatus]    Script Date: 08/08/2012 21:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[fn_Get_EmpAttendanceStatus](@EmpID VARCHAR(10),@Date DATETIME)
RETURNS VARCHAR(2000)
AS 
BEGIN
	DECLARE @StartDate DATETIME
	DECLARE @EndDate DATETIME
	SET @StartDate=@Date
	SELECT @EndDate= DATEADD(D,1,@Date)
	DECLARE @AttendanceStatus VARCHAR(2000)
	DECLARE @Time_IN DATETIME
	DECLARE @Time_OUT DATETIME
	DECLARE @Working_HRS VARCHAR(10)
	DECLARE @Shift_S_TIME VARCHAR(10)
	DECLARE @Shift_TIME VARCHAR(10)
	DECLARE @TimeInMinute INT
    DECLARE @Exit_Date DATETIME
    DECLARE @Entry_Date DATETIME
    
   
   --if active then check all login
   --else chek last day worked and tranfer date is less then @Date the show employeement status
    IF EXISTS(
    SELECT EmployeeID FROM EmployeeMaster EM 
    WHERE EM.ACTIVE=1  AND EM.employeementStatusID in(1,5)
    AND  EM.employeeID=@EmpID
    )
    BEGIN
    
		 IF EXISTS( SELECT EmployeeID FROM [Login] WHERE EmployeeID=@EmpID AND RoleID NOT IN(2,3) )
			BEGIN
			   SELECT @AttendanceStatus= CASE  WHEN EM.DOJ>@Date 
			   THEN 'N/A'
			   --WHEN EM.EmployeementStatusID IN (3) AND EM.TransferDate < @Date 
			   --THEN  EmployementStatus 
			   -- For Present Attendance Logic, Check only Entry Date of The Employe
			   WHEN (SELECT TOP 1 IODate FROM  EmployeeAttendance WHERE IOStatus = 'Entry' AND IODate=@Date 
			   AND EmployeeID=EM.EmployeeID) IS  NOT NULL
			   THEN 'P'
			   --WHEN EM.EmployeementStatusID NOT IN (1,5,3) AND EM.LastDayWorked < @Date 
			   --THEN  EmployementStatus 
			   WHEN LD.DateApplied IS NOT NULL AND CAST(LD.LeaveDuration AS INT)=1                            
			   THEN (SELECT  LeaveType.LeaveType FROM LeaveSummary INNER JOIN  LeaveType ON LeaveSummary.LeaveTypeID = LeaveType.LeaveTypeID 
			   WHERE  (LeaveSummary.LeaveSummaryID = LD.LeaveSummaryID))
			   WHEN HM.HOLIDAYDATE IS NOT NULL 
			   THEN 'Holiday('+HM.HOLIDAYNAME+')'  
			   ELSE 'Leave Without Pay'                                              
			   END 
			   FROM  EmployeeMaster AS EM 
                       INNER JOIN                             
                      EmployementStatus ON EM.EmployeementStatusID = EmployementStatus.EmployementStatusID      
				      LEFT OUTER JOIN   
					  LeaveDetails AS LD ON EM.EmployeeID = LD.EmployeeID AND LD.DateApplied= @Date AND LD.LeaveStatusID IN (16, 12)                               
				      LEFT OUTER JOIN   HolidayMaster AS HM ON EM.companyID=HM.companyID AND HM.HOLIDAYDATE=@Date                     
					  WHERE (EM.Active = 1)           
					  AND  EM.employeeID=@EmpID 
					  
				  
	END		   	
	ELSE	   	
		BEGIN  
				IF EXISTS(
							SELECT  ShiftID FROM ShiftChangeRequest 
							WHERE EmployeeID =@EmpID AND active=1 AND AdminStatus=1
							AND (HRStatus=1 OR HRStatus=2) AND @Date BETWEEN FromDate AND TillDate
						 )
							BEGIN
									SELECT @Shift_TIME=SH.StartTime 
									FROM ShiftMaster SH
									INNER JOIN ShiftChangeRequest SCH ON SH.ShiftID = SCH.ShiftID 
									WHERE SCH.EmployeeID=@EmpID AND SCH.active=1 AND SCH.AdminStatus=1
									AND (SCH.HRStatus=1 OR SCH.HRStatus=2) 
									AND @DATE BETWEEN SCH.FromDate AND SCH.TillDate			
							END
				ELSE 
							BEGIN
									SELECT @Shift_TIME=SH.StartTime FROM ShiftMaster SH
									INNER JOIN EmployeeMaster EM
									ON SH.ShiftID = EM.ShiftID WHERE EM.EmployeeID=@EmpID
							END
					--  CALCULATING WORKING HRS
				     /*To Check Employee's Shift's Time */
					SELECT @Shift_S_TIME=@Shift_TIME
					SET @Shift_TIME =DATEADD(HH,-1,CAST(@Shift_S_TIME AS TIME))
		
					/*To Calculate Employee's Entry Date */
					SELECT @Entry_Date=Cast(@Date+CAST(@Shift_TIME AS TIME)AS DATETIME)
					IF EXISTS(SELECT TimeInMinute FROM EmployeeAttendanceTime 
					WHERE EmployeeID=@EmpId AND [Date]=@Date AND [Type]=3 AND ACTIVE=1)
						BEGIN
							  SELECT @TimeInMinute=TimeInMinute 
							  FROM EmployeeAttendanceTime 
							  WHERE EmployeeID=@EmpId AND [Date]=@Date AND [Type]=3 AND ACTIVE=1
							  SELECT @Entry_Date=DATEADD(MINUTE,-@TimeInMinute, @Entry_Date)
						END
					/*To Calculate Employee's Exit Date */
					SELECT @Exit_Date= DATEADD(HH,10,@Date+CAST(@Shift_S_TIME AS TIME))
					IF EXISTS(SELECT TimeInMinute FROM EmployeeAttendanceTime WHERE EmployeeID=@EmpId AND [Date]=@Date AND [Type]=2 AND ACTIVE=1)
						BEGIN
							 SELECT @TimeInMinute=TimeInMinute 
							 FROM EmployeeAttendanceTime 
							 WHERE EmployeeID=@EmpId AND [Date]=@Date AND [Type]=2 AND ACTIVE=1
							 SELECT @Exit_Date=DATEADD(MINUTE,@TimeInMinute, @Exit_Date)
		   
						END
		
					/*To Retrieve Employee's Punch In Time */
				SELECT @Time_IN= CAST(MIN(IODate+CAST(IOTime AS TIME))AS DATETIME)
				FROM EmployeeAttendance
				WHERE EmployeeID=@EmpId 
				AND CAST(IODate+CAST(IOTime AS TIME)AS DATETIME) BETWEEN @Entry_Date AND @Exit_Date
				AND IOStatus='Entry'
	
				/*To Retrieve Employee's Punch Out Time */
				SELECT @Time_OUT= CAST(MAX(IODate+CAST(IOTime AS TIME))AS DATETIME)
				FROM EmployeeAttendance
				WHERE employeeid=@EmpId
				AND CAST(IODate+CAST(IOTime AS TIME)AS DATETIME) BETWEEN @Entry_Date AND @Exit_Date
				AND IOStatus='Exit'
		
				/* Logic for LWP And fogetting Punch-Out */
				IF(@Time_IN IS NULL OR @Time_IN='')
				BEGIN
					SET @Working_HRS=0
				END
				/*fogetting Punch-Out*/
				ELSE IF((@Time_IN IS NOT NULL OR @Time_IN <>'')AND(@Time_OUT IS NULL OR @Time_OUT=''))
				BEGIN
					SET @Working_HRS=-1
				END
		  ELSE
			    BEGIN
					/* Calculating Working Hrs in HH:MM:SS */
					SET @Working_HRS=DATEDIFF(MINUTE,@Time_IN,@Time_OUT)
				END
		/* Including Employee Attendance Time for calculating stretched time */
		
		IF EXISTS(SELECT TimeInMinute FROM EmployeeAttendanceTime WHERE EmployeeID=@EmpId AND [Date]=@Date AND [Type]=1 AND ACTIVE=1)
		BEGIN
				SELECT @TimeInMinute=TimeInMinute 
				FROM EmployeeAttendanceTime 
				WHERE EmployeeID=@EmpId AND [Date]=@Date AND [Type]=1 AND ACTIVE=1
				-- Adding Time In to Minute
				SET @Working_HRS= @TimeInMinute+CAST(@Working_HRS AS INT)		
		END 	
		
		
			   SELECT @AttendanceStatus= CASE WHEN EM.DOJ>@Date 
					THEN 'N/A' 
					--WHEN EM.EmployeementStatusID IN (3) AND EM.TransferDate < @Date 
					--THEN  EmployementStatus 
					
					--CONDITION 1: When Employee Has Worked 9 Working Hrs then P with working hours             
					WHEN (@Working_HRS>=540)                        
					THEN 'P(' +CAST(@Working_HRS/60 AS VARCHAR(10))+ ' Hrs '+ CAST(@Working_HRS% 60 AS VARCHAR(10))+ ' Minutes)' 
		 				
					--CONDITION 2: less than 9 Working Hrs then Short Attendance with working hours            
					WHEN (@Working_HRS<540 AND @Working_HRS>0 AND LD.DateApplied IS NULL)                  
					THEN 'Attendance Short(' +CAST(@Working_HRS/60 AS VARCHAR(10))+ ' Hrs '+ CAST(@Working_HRS% 60 AS VARCHAR(10))+ ' Minutes)' 
					
					-- For Attrited/Transferred/Offer drop/Absconding Attendnace
					--WHEN EM.EmployeementStatusID NOT IN (1,5,3) AND EM.LastDayWorked < @Date 
					--THEN  EmployementStatus 
					
					--CONDITION 3: For Missing Attendance                                                 
					WHEN (SELECT TOP 1 IODate FROM EmployeeAttendanceMissing 
					WHERE IOStatus = 'Entry' AND IODate=@Date 
					AND EmployeeID=CONVERT(VARCHAR,EM.EmployeeID))IS  NOT NULL                             
					THEN 'M ('+(SELECT TOP 1 Remark FROM EmployeeAttendanceMissing
					 WHERE IOStatus = 'Entry' AND IODate=@Date 
					AND EmployeeID=CONVERT(VARCHAR,EM.EmployeeID)) +')'  
			                                             
					--CONDITION 4: When Employee is on Leave for whole day then Show Leave Name 
					WHEN LD.DateApplied IS NOT NULL AND CAST(LD.LeaveDuration AS INT)=1                            
					THEN (SELECT  LeaveType.LeaveType FROM LeaveSummary 
					INNER JOIN  LeaveType ON LeaveSummary.LeaveTypeID = LeaveType.LeaveTypeID 
					WHERE  (LeaveSummary.LeaveSummaryID = LD.LeaveSummaryID))
					
					--CONDITION 5:half day Leave and has completed  9 working hrs 
					WHEN LD.DateApplied IS NOT NULL AND CAST(LD.LeaveDuration AS INT)<1  
					AND (270+@Working_HRS>=540 AND @Working_HRS>0)
					THEN 'P(' +CAST(@Working_HRS/60 AS VARCHAR(10))+ ' Hrs '+ 
					CAST(@Working_HRS% 60 AS VARCHAR(10))+ ' Minutes)With Half Day Leave'
					
					--CONDITION 6: When Employee is on half day Leave and has less than 9 working hours 
					WHEN LD.DateApplied IS NOT NULL AND CAST(LD.LeaveDuration AS INT)<1  
					AND (270+(@Working_HRS)<540 AND (@Working_HRS)>0)
					THEN 'Attendance Short(' +CAST(@Working_HRS/60 AS VARCHAR(10))+ ' Hrs '+ 
					CAST(@Working_HRS % 60 AS VARCHAR(10))+ ' Minutes)With Half Day Leave'	
					WHEN HM.HOLIDAYDATE IS NOT NULL 
					THEN 'Holiday('+HM.HOLIDAYNAME+')' 
					--CONDITION 7:Another Scenerio for LWP: when no Punch-in.
					WHEN (@Working_HRS=0) 
					THEN 'Leave Without Pay'  
					--CONDITION 8: When Employee has forgot to punch out.
					WHEN (@Working_HRS=-1) 
					THEN 'Leave Without Pay(No Punch-Out)'                                           
					ELSE 'Leave Without Pay'                                              
			    END 
				FROM  EmployeeMaster AS EM 
                       LEFT OUTER JOIN                             
                      EmployementStatus ON EM.EmployeementStatusID = EmployementStatus.EmployementStatusID      
				      LEFT OUTER JOIN   
					  LeaveDetails AS LD ON EM.EmployeeID = LD.EmployeeID AND LD.DateApplied= @Date AND LD.LeaveStatusID IN (16, 12)                               
				      LEFT OUTER JOIN   HolidayMaster AS HM ON EM.companyID=HM.companyID AND HM.HOLIDAYDATE=@Date                     
					  WHERE (EM.Active = 1)           
					  AND  EM.employeeID=@EmpID 
					  
	  END  
	  END
	  ELSE
	  BEGIN
			SELECT @AttendanceStatus =CASE 
			WHEN EM.EmployeementStatusID IN (3) AND EM.TransferDate < @Date 
			THEN ES.EmployementStatus
			WHEN EM.EmployeementStatusID NOT IN (1,5,3) AND EM.LastDayWorked < @Date 
			THEN ES.EmployementStatus END
			FROM EmployeeMaster AS EM 
            LEFT OUTER JOIN                             
            EmployementStatus ES ON EM.EmployeementStatusID = ES.EmployementStatusID       
			 WHERE EM.employeeID=@EmpID		
	  END
	RETURN @AttendanceStatus
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetCOELeadsName]    Script Date: 08/08/2012 21:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Manish Sharma>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER function [dbo].[GetCOELeadsName]
(	
--DECLARE
	@PROCESSID varchar(20)
)
RETURNS varchar(max)
AS

BEGIN
DECLARE @NAME VARCHAR(MAX)
SET @NAME=''
SELECT @NAME=@NAME+[FIRSTNAME]+' '+ISNULL([MIDDLENAME],'')+' '+ISNULL([LASTNAME],'')+','           
  FROM [EMPLOYEEMASTER] E WHERE E.[EMPLOYEEID] in (Select  EmployeeID          
              from dbo.ProcessHead          
              where ProcessID=@PROCESSID AND ACTIVE=1)
SET @NAME=SUBSTRING(@NAME,0,LEN(@NAME))
RETURN @NAME
END
GO
/****** Object:  StoredProcedure [dbo].[usp_AlertDRLeaveStatement_Excel]    Script Date: 08/08/2012 21:51:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery2.sql|7|0|C:\Documents and Settings\300051\Local Settings\Temp\~vs64.sql
                                         
ALTER PROCEDURE [dbo].[usp_AlertDRLeaveStatement_Excel]--'07/05/2012','08/05/2012','300059'
 @1 varchar(50)=NULL,--Start Date                                                          
 @2 varchar(50)=NULL,--End Date                                                                                                                      
 @6 varchar(50)--UserID                              
             
AS                
                                                    
--DECLARE                                                             
-- @1 varchar(50),--Start Date                                                          
-- @2 varchar(50),--End Date                                                             
-- @3 varchar(50),--Company ID                                                             
-- @4 varchar(50),--Process ID                                                             
-- @5 varchar(50),--Employee ID                                                             
-- @6 varchar(50),--UserID                            
         
                                               
--SET @1='4/21/2012'                                                              
--SET @2='5/2/2012'                                                       
--SET @3='0'                                       
--SET @4='0'                                       
--SET @5=''                                       
--SET @6='101062'                       

                 
                                                    
DECLARE @8 varchar(1)  
SET @8='1'  
  
  DECLARE @7 varchar(1)  
SET @7='1' 
--DECLARE @3 VARCHAR(50)  
--SELECT @3=companyid from EmployeeMaster where  EmployeeId=@6  

IF @1 IS NULL
BEGIN	 
	SET @1=CAST(CAST(DATEPART(MM,GETDATE())-1AS VARCHAR(2))+'-20-'+CAST(DATEPART(YY,GETDATE())AS VARCHAR(4))AS DATETIME)
	
END

IF @2 IS NULL
BEGIN
	SET @2=CAST(CAST(DATEPART(MM,GETDATE())AS VARCHAR(2))+'-19-'+CAST(DATEPART(YY,GETDATE())AS VARCHAR(4))AS DATETIME)

END


DECLARE @9 varchar(1)  
SET @9='0'                                                           
DECLARE @StartDate varchar(50),@EndDate varchar(50)                                                              
 SET @StartDate=Convert(varchar(20),@1,101)                                                             
 SET @EndDate=Convert(varchar(20),@2,101)                                
                               
 
  
                                                              
DECLARE                                                 
 @query VARCHAR(MAX)                                                
 ,@ColumnList VARCHAR(max)                                                
 ,@where varchar(1000)                              
 ,@reporting varchar(max)                              
 ,@roleID int                
 ,@reportingType varchar(50)                               
               
                                              
                                              
 IF(@6='0')                              
  BEGIN                              
   SET @roleID=4                              
  END                               
 ELSE                              
  Begin                              
   select @roleID=roleid from Login where EmployeeID=@6                              
  End                               
                              
 set @roleID=ISNULL(@roleID,2)                                                
                              
                              
declare @table table (Date datetime)                                                              
insert into @table select * from USP_EDB_GetDatesFromTwoDates( @StartDate,@EndDate)  

                                                              
SELECT @ColumnList = COALESCE(@ColumnList+']'+',' ,'') + '['+convert(varchar(12),Date,106) from @table order by Date                   
set @ColumnList=@ColumnList+']' 

                              
                              
if OBJECT_ID('tempdb..##tblEmployeedr') is not null                              
Begin                              
drop table ##tblEmployeedr                              
End            
                              
create table ##tblEmployeedr (employeeID int)                              
                              
set @where=''                                                
                              
 --if(@3<>'0')                                                
 --Begin                                                
 -- set @where=@where+' and EM.CompanyID='+@3                                                
 --End                                        
                                                                   
                       
 if(@7<>'0')                                                
 Begin                                                
  SET @where=@where +' and EM.EmployeementStatusID='+@7                                      
 End                     
                 
  if(@8='1')                                                
 Begin                                                
  SET @reportingType='Direct'                
 End           
         
         
         
  if(@9='1' and @8='0')        
  Begin        
            
   insert into ##tblEmployeedr(employeeID)          
   select @6           
  End        
      
Else                          
Begin        
      
 if(@9='1' and @8='1')        
   Begin        
             
    insert into ##tblEmployeedr(employeeID)          
    select @6           
   End                              
                              
 if(@roleID=4)                              
   Begin                      
        if(@8=1)        
        Begin        
       insert into ##tblEmployeedr(employeeID)                              
       Select employeeID from VW_EmployeeDetails where EmployeementStatusID in(1,5)         
       and EmployeeID in(select employeeID from EmployeeReportingLead         
             where HeadID=@6 and Active=1 and ReportingType=ISNULL(@reportingType,ReportingType)         
            )                      
      union                    
       Select employeeID from EmployeeMaster                     
       where (LastDayWorked >= @EndDate or (LastDayWorked between @StartDate and @EndDate))        
       and EmployeeID in(select employeeID from EmployeeReportingLead         
             where HeadID=@6 and Active=1 and ReportingType=ISNULL(@reportingType,ReportingType)         
            )                          
        End               
        else        
        Begin        
       insert into ##tblEmployeedr(employeeID)                              
       Select employeeID from VW_EmployeeDetails where EmployeementStatusID in(1,5)                    
      union                    
       Select employeeID from EmployeeMaster                     
       where (LastDayWorked >= @EndDate or (LastDayWorked between @StartDate and @EndDate))                       
     End        
                                        
   End                               
 else                    
  Begin           
          
  insert into ##tblEmployeedr(employeeID)          
           
    Select employeeID from VW_EmployeeDetails                     
    where ProcessID in (select ProcessID from EmployeeAttendanceProcessMatrix where EmployeeID=@6)                      
        OR EmployeeID in(select employeeID from EmployeeReportingLead         
             where HeadID=@6 and Active=1 and ReportingType=ISNULL(@reportingType,ReportingType)         
            )          
     Union                
                                   
    SELECT     EM.EmployeeID                              
    FROM         EmployeeMaster AS EM INNER JOIN                              
      TeamMaster AS TM ON EM.TeamID = TM.TeamID INNER JOIN                              
      SubProcessMaster AS SPM ON TM.SubProcessID = SPM.SubProcessID                              
    WHERE     (EM.Active = 1)                             
       and (                    
        ((EM.LastDayWorked >= @EndDate or (EM.LastDayWorked between @StartDate and @EndDate)))                    
        OR                              
        ((EM.TransferDate >= @EndDate or (EM.TransferDate between @StartDate and @EndDate)))                    
       )                    
       and SPM.ProcessID in(select ProcessID from EmployeeAttendanceProcessMatrix where EmployeeID=@6)                       
                          
   Union                    
                          
    SELECT     EM.EmployeeID                              
    FROM         EmployeeMaster AS EM INNER JOIN                              
      TeamMaster AS TM ON EM.TeamID = TM.TeamID INNER JOIN                              
      SubProcessMaster AS SPM ON TM.SubProcessID = SPM.SubProcessID                              
    WHERE     (EM.Active = 1)                             
       and (                    
        ((EM.LastDayWorked >= @EndDate or (EM.LastDayWorked between @StartDate and @EndDate)))                    
        OR                              
        ((EM.TransferDate >= @EndDate or (EM.TransferDate between @StartDate and @EndDate)))                    
       )                    
       and EmployeeID in(select employeeID from EmployeeReportingLead         
           where HeadID=@6 and Active=1  and ReportingType=ISNULL(@reportingType,ReportingType))                                
            
   End         
              
END                 
                     
      
--select * from ##tblEmployeedr      
                               
                              
set @query='                                                  
select [Employee ID], Name,Status,Designation,Department,Process,'+@ColumnList+' from                                                               
(                         
SELECT     dbo.GetEmpID(EM.EmployeeID) AS [Employee ID]                                                
, ISNULL(EM.FirstName + ''  '', '''') + ISNULL(EM.MiddleName + '' '', '''')+ ISNULL(EM.LastName + '' '', '''') AS Name                                                
, EmployementStatus.EmployementStatus AS Status                                                
, DM.Designation, PM.ProcessName AS Process                                                
, DepM.DepartmentName AS Department                                            
--,''LeaveType''=dbo.fn_Get_EmpAttendanceStatus(EM.EmployeeID,GD.DATE)
,ISNULL(EC.AttendanceStatus,dbo.fn_Get_EmpAttendanceStatus(EM.EmployeeID,GD.DATE)) as LeaveType             
,''''+convert(varchar(12),GD.DATE,106) + '''' as DATEAPPLIED                                                
                                                
FROM         dbo.USP_EDB_GetDatesFromTwoDates('''+ @StartDate +''', '''+ @EndDate +''') AS GD CROSS JOIN                                                
                      EmployeeMaster AS EM INNER JOIN                                                
                      TeamMaster ON EM.TeamID = TeamMaster.TeamID INNER JOIN                                                
                      SubProcessMaster ON TeamMaster.SubProcessID = SubProcessMaster.SubProcessID INNER JOIN                                         
                      ProcessMaster AS PM ON SubProcessMaster.ProcessID = PM.ProcessID INNER JOIN                                                
                      DesignationMaster AS DM ON EM.DesignationID = DM.DesignationID INNER JOIN                                                
               EmployementStatus ON EM.EmployeementStatusID = EmployementStatus.EmployementStatusID INNER JOIN                                                
                      DepartmentMaster AS DepM ON PM.DepartmentID = DepM.DepartmentID LEFT JOIN
                       EmployeeAttendanceStatus EC ON EM.EmployeeID=EC.EmployeeID 
                     -- LEFT OUTER JOIN                                               
       -- EmployeeAttendance AS EA ON CAST(EM.EmployeeID AS varchar) = EA.EmployeeID AND GD.DATE = EA.IODate AND EA.IOStatus = ''Entry''                                                 
--LEFT OUTER JOIN   LeaveDetails AS LD ON EM.EmployeeID = LD.EmployeeID AND GD.DATE = LD.DateApplied AND LD.LeaveStatusID IN (16, 12)                                                
LEFT OUTER JOIN   HolidayMaster AS HM ON EM.companyID=HM.companyID and  GD.Date=HM.HOLIDAYDATE                                                
WHERE (EM.Active = 1) AND EC.AttendanceDate= GD.DATE            
and  EM.employeeID  in (select employeeID from ##tblEmployeedr)                     
    '+ @where +'                              
)            
AS SourceTable PIVOT ( MAX(LeaveType) FOR DATEAPPLIED IN ( '+ @ColumnList + ' ) ) p                                                 
                                               
'                                                           
                                                             

exec(@query)   

 DECLARE @EXCELVAR varchar(Max)
 SET @EXCELVAR=@query
 
  
-----------------------------------------------------------  
DECLARE @ColList varchar(Max)  
DECLARE @ColName varchar(100)  
DECLARE @ColList2 varchar(Max)  
SET @ColList = ''  
SET @ColList2 = ''  
SET @ColName = ''  
  
DECLARE AllColList CURSOR FOR  
select CONVERT(VARCHAR, DATE, 106) from USP_EDB_GetDatesFromTwoDates(@StartDate,@EndDate)  
 OPEN AllColList  
 FETCH NEXT FROM AllColList INTO @ColName  
 WHILE @@FETCH_STATUS = 0                        
    BEGIN                        
 SET @ColList = @ColList + '<td class="style2" style="font-size: 9pt">' + @ColName + '</td>'  
 SET @ColList2 = @ColList2 + '<td class="style2" style="font-size: 9pt">'''+ '+' + '['''+ @ColName + ''']' +'+' + '''</td>'  
    FETCH NEXT FROM AllColList INTO @ColName                       
    END                        
CLOSE AllColList                        
DEALLOCATE AllColList     
  
  
               
          
  
DECLARE @RowData varchar(MAX)  
DECLARE @EmailMessage varchar(MAX) 

DECLARE @empName varchar(300)      
  ,@empID varchar(50)     
  ,@mailto varchar(100)     
  --,@mailCC varchar(500)    
   ,@mailSubject varchar(100)
  ,@File varchar(20)
  ,@Separator NCHAR(1) = CHAR(9)
                                               
                                               
--SET @1=CONVERT(VARCHAR,CAST(@1 AS DATETIME),103)
--SET @2=CONVERT(VARCHAR,CAST(@2 AS DATETIME),103)
      
SET @File = 'Attendance' + RIGHT('0' + RTRIM(MONTH(GETDATE())), 2) + 
                               CONVERT(CHAR(2),GETDATE(),103) + 
                               SUBSTRING(CONVERT(VARCHAR(4),DATEPART(YY, GETDATE())),3,2) + '.xls' 
  

 ----Added for mail-------------
  SELECT @empName=isnull(FirstName,'')+' '+isnull(MiddleName,'')+' '+isnull(LastName,'')+' ('+@6+')',     
      @mailto=EmailID    
    FROM EmployeeMaster    
    WHERE (EmployeeID = @6)
  set @mailSubject='ARMS-Monthly attendance report of reporting employees from date "'+@1+'" to "'+@2+'"'
  
  DECLARE @htmlbody VARCHAR(MAX)
--SET @htmlbody='<html> <head runat="server"> </head> <body>Dear Mr.'+@empName+ '<br/><br/>Monthly Attendance Report For All Employees '+@1+' TO '+@2+'</body></html>'

SET @htmlbody='

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">              
<html>              
 <head>              
<style type="text/css">              
    body              
    {              
        font-size:13px;              
        font-family:Arial;              
    }              
    </style>              
  <title></title>              
   </head>              
 <body class="style2" style="font-size: 9pt"> 

<table  class="style2" style="font-size: 9pt"><tr><td  class="style2" style="font-size: 9pt">

<table  class="style2" style="font-size: 9pt"><tr><td  class="style2" style="font-size: 9pt">
Dear '+@empName+ '<br/><br/>Monthly attendance report of employees reporting directly to you from  "'+@1+'" to "'+@2+'"<br/><br/>Regards,<br/>Human Resources Development<br/>Accretive Health</td></tr></table></body></html>'
  if(@mailto is not null and  @mailto !='')
		Begin
		 
	   EXEC msdb.dbo.sp_send_dbmail 
       @profile_name='ARMS',
       --@recipients='raggarwal@accretivehealth.com', 
       @recipients=@mailto, 
       @subject=@mailSubject, 
       @query=@EXCELVAR, 
       @query_result_width =65535, 
       @body=@htmlbody,   
       @execute_query_database='QAT-AHPLHRMS', 
       @query_result_separator=@Separator, 
       --@query_result_header=0, 
       @query_result_no_padding=1, 
       @attach_query_result_as_file=1, 
       @query_attachment_filename=@File, 
       @body_format='HTML',
       @importance='High'       
  
		END
  -------------------------------------------- 
  -------------------------------------------- 

--SET @EmailBody = @EmailBody + @EmailMessage + '</tr></table>' 


 -- SELECT  @EmailBody
GO
/****** Object:  StoredProcedure [dbo].[USP_Update_AttendanceStatus]    Script Date: 08/08/2012 21:51:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_Update_AttendanceStatus](    
@1 VARCHAR(50),--Employee ID    
@2 DATETIME,--Start date    
@3 DATETIME--End date    
)    
AS    
BEGIN   
		IF EXISTS(
					SELECT AttendanceStatusID FROM EmployeeAttendanceStatus 
					WHERE EmployeeID=@1 AND AttendanceDate BETWEEN @2 AND @3
				) 
				BEGIN
						UPDATE EmployeeAttendanceStatus     
						SET AttendanceStatus= dbo.fn_Get_EmpAttendanceStatus(@1,GD.[Date])    
						FROM EmployeeAttendanceStatus EA    
						INNER JOIN     
						DBO.USP_EDB_GetDatesFromTwoDates(CONVERT(VARCHAR,@2,101),CONVERT(VARCHAR,@3,101))GD    
						ON CONVERT(VARCHAR,EA.AttendanceDate,101)=CONVERT(VARCHAR,GD.[DATE],101)    
						WHERE EA.EmployeeID=@1  
				END
				ELSE
				BEGIN
				        INSERT INTO EmployeeAttendanceStatus(EmployeeID,AttendanceDate,AttendanceStatus)     
						SELECT EM.EmployeeID,GD.[Date],dbo.fn_Get_EmpAttendanceStatus(@1,GD.[Date])    
						FROM EmployeeMaster EM
						CROSS JOIN     
						DBO.USP_EDB_GetDatesFromTwoDates(CONVERT(VARCHAR,@2,101),CONVERT(VARCHAR,@3,101))GD     
						WHERE EM.EmployeeID=@1  
				END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetEmployeeDetailsEmpIDWise]    Script Date: 08/08/2012 21:51:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_GetEmployeeDetailsEmpIDWise] -- '101092'          
(            
@1 varchar(50)--- Employee Id        
)        
As        
/*        
Created By : Vikas (5 June 2012)   
Modified by : Vikas (30 July 2012)   
Desc : Add Status       
[USP_GetEmployeeDetailsEmpIDWise]'101177'        
*/        
Begin           
select  dbo.GetEmpID(@1) as [EmployeeID],        
       (Em.FirstName +' '+ isnull(Em.MiddleName,'') +' '+ isnull(Em.LastName,'')) as [Name],   
        Es.EmployementStatus as [Status], Em.EmployeementStatusID as [StatusID],             
       Convert(varchar,Em.DOJ,106) as [DOJ],   
       Convert(varchar,Em.ResignationDate,106) as [Resignation Date],         
       Em.NoticePeriodServedInDays as [Noticeserved],  
       Convert(varchar,Em.LastDayWorked,106) as [LastDayWorked],        
       dm.Designation, Lm.LocationName as [Location],        
       Dm1.DepartmentName,   
      -- (Select FirstName  from EmployeeMaster where EmployeeID=Erl.EmployeeID),    
       dbo.GetDRName(@1) As [SuperVisor]     
 from EmployeeMaster Em     
    Inner Join EmployementStatus Es on Es.EmployementStatusID = Em.EmployeementStatusID      
    Inner join DesignationMaster dm on dm.DesignationID = Em.DesignationID        
    Inner Join LocationMaster Lm on Lm.LocationID = Em.LocationID        
    INNER JOIN TeamMaster Tm on Tm.TeamID = Em.TeamID              
    Inner Join SubProcessMaster Spm ON Tm.SubProcessID = Spm.SubProcessID                
    Inner join ProcessMaster Pm ON Spm.ProcessID = Pm.ProcessID         
    Inner join DepartmentMaster Dm1 on Dm1.DepartmentID = Pm.DepartmentID      
    --Inner join EmployeeReportingLead Erl on Erl.EmployeeID = Em.EmployeeID      
 where Em.EmployeeID=@1        
         
End
GO
/****** Object:  StoredProcedure [dbo].[USP_Insert_CalculatedAttendance]    Script Date: 08/08/2012 21:51:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_Insert_CalculatedAttendance]
  @Start_Date DATETIME=NULL,  
  @End_Date DATETIME  =NULL
AS   
BEGIN  
  --DECLARE @Start_Date DATETIME  
  --DECLARE @End_Date DATETIME 
  
					IF (@Start_Date IS NULL AND @End_Date IS NULL)
					BEGIN
						SELECT @Start_Date=CONVERT(VARCHAR,GETDATE(),101)
						SELECT @End_Date=CONVERT(VARCHAR,GETDATE(),101)  		
					END

					INSERT INTO EmployeeAttendanceStatus(EmployeeID,AttendanceDate)  
					SELECT EM.EmployeeID,GD.Date 
					FROM dbo.USP_EDB_GetDatesFromTwoDates(@Start_Date,@End_Date) AS GD  
					CROSS JOIN EmployeeMaster AS EM WHERE EM.ACTIVE=1  AND EM.employeementStatusID in(1,5)
					AND EM.EmployeeID NOT IN
					(
					 SELECT EmployeeID FROM EmployeeAttendanceStatus 
					 WHERE AttendanceDate BETWEEN @Start_Date AND @End_Date
					)
					
					UPDATE EmployeeAttendanceStatus 
					SET AttendanceStatus =dbo.fn_Get_EmpAttendanceStatus(ES.EmployeeID,@Start_Date)
					FROM EmployeeAttendanceStatus AS ES  
					INNER JOIN dbo.USP_EDB_GetDatesFromTwoDates(@Start_Date,@End_Date) AS GD  
					ON ES.AttendanceDate=GD.DATE
					
					
   
 END
GO
/****** Object:  StoredProcedure [dbo].[USP_EDB_getAllEmployeeList]    Script Date: 08/08/2012 21:51:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                                        
-- Author:  Pankaj                                                                        
-- Create date: 12 JAN 2012                                                                       
-- Description: Get Employee List                                                  
-- =============================================                                                                        
ALTER PROCEDURE [dbo].[USP_EDB_getAllEmployeeList]  --'0','55','1','0','0'                                                          
@1 varchar(20),--Process Id                                                                 
@2 varchar(20), --Company ID                                                
@3 varchar(500), --Search Text                            
@4 varchar(50), --Designation ID                    
@5 varchar(50), --Emp Status ID         
@6 varchar(20)='0', --User ID        
@7 varchar(20)='0'--Sub Process Id        
                                      
AS                                                                        
BEGIN                                                                        
 SET NOCOUNT ON;                                                                        
 DECLARE @select VARCHAR(MAX),                        
 @company varchar(500)             
         
         
 DECLARE @ROLEID int                                              
 SELECT @ROLEID=[RoleID]                                              
     FROM [dbo].[Login]                                              
 WHERE [EmployeeID]=@6              
          
if OBJECT_ID('tempdb..#tblEmployee') is not null            
Begin            
 DROP TABLE #tblEmployee            
End            
            
CREATE TABLE #tblEmployee (employeeID int)            
            
insert into #tblEmployee(employeeID)            
select employeeID from EmployeeReportingLead where HeadID=@6 and Active=1            
union             
select @6            
Union            
Select employeeID from VW_EmployeeDetails where ProcessID in (select ProcessID from EmployeeAttendanceProcessMatrix where EmployeeID=@6)                       
                        
                  
SET @select='SELECT EM.EmployeeID AS EMPLOYEEID,DBO.[GetEmpID](EMPLOYEEID)  AS EID,EM.FirstName+'' ''+isnull(EM.MiddleName,'''')+'' ''+isnull(EM.LastName,'''')  AS FIRSTNAME                                                                
   FROM EmployeeMaster EM INNER JOIN  TeamMaster TM ON (EM.TeamID =TM.TeamID) INNER JOIN SubProcessMaster SPM ON (TM.SubProcessID =SPM.SubProcessID)   WHERE  EM.ACTIVE in (1) '                                             
                      
IF( @1<>'0' )                                           
 BEGIN                                        
  SET @select=@select+' AND  SPM.ProcessID='''+@1+''''                                           
 END                    
                      
IF( @2<>'0' )                                           
 BEGIN                                        
 SET @select =@select + '  AND EM.CompanyId = '''+@2+''''                                           
 END                
     
     
 IF( @7<>'0' )                                           
 BEGIN                                        
 SET @select =@select + '  AND SPM.SubProcessID = '''+@7+''''                                           
 END               
                    
IF( @4<>'0' )                                           
 BEGIN                                        
 SET @select =@select + '  AND EM.DesignationID = '''+@4+''''                                           
 END                      
                    
IF( @5<>'0' )                                           
 BEGIN                                        
  SET @select =@select + '  AND EM.EmployeementStatusID = '''+@5+''''                                           
 END           
 --ELSE          
 --BEGIN          
 -- SET @select =@select + '  AND EM.EmployeementStatusID  in (1,5)  '                                           
 --END          
                          
            IF(@3<> '')                            
BEGIN                             
 SET @select =@select + ' AND ( EMPLOYEEID like '''+@3+'%'' OR   FIRSTNAME +'' ''+ISNULL(MiddleName,'''')+'' ''+ISNULL(LastName,'''') LIKE   '''+@3+'%'')'   
END         
        
if(@ROLEID NOT IN (1,4))             
begin              
 SET @select=@select + 'AND   (EM.EMPLOYEEID in (select EmployeeID from #tblEmployee))  '            
END        
      
      
                          
              
--SET @select =@select +' ORDER BY EM.FirstName '                                            
PRINT(@SELECT)                                        
exec(@select )                              
              
END
GO
/****** Object:  StoredProcedure [dbo].[usp_AlertHRLeaveStatement_Excel]    Script Date: 08/08/2012 21:51:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery2.sql|7|0|C:\Documents and Settings\300051\Local Settings\Temp\~vs64.sql
                                         
ALTER PROCEDURE [dbo].[usp_AlertHRLeaveStatement_Excel]--'05/26/2012','05/30/2012','55','300051'  
 @1 varchar(50)=NULL,--Start Date                                                          
 @2 varchar(50)=NULL,--End Date                                                             
 @3 varchar(50),--Company ID                                                             
 @6 varchar(50)--UserID                              
AS                
                                                    
--DECLARE                                                             
-- @1 varchar(50),--Start Date                                                          
-- @2 varchar(50),--End Date                                                             
-- @3 varchar(50),--Company ID                                                             
-- @6 varchar(50)--UserID                            
          
                                               
--SET @1='7/1/2012'                                                              
--SET @2='7/19/2012'                                                       
--SET @3='55'                                       
--SET @6='101062'                       
                  
                                                    
                                                          
DECLARE @StartDate varchar(50),@EndDate varchar(50)                                                              
 SET @StartDate=Convert(varchar(20),@1,101)                                                             
 SET @EndDate=Convert(varchar(20),@2,101)                                
                               
 DECLARE @COMPANYNAME VARCHAR(50)
 
 SELECT @COMPANYNAME=companyname FROM companymaster WHERE companyid=@3
  
                                                              
DECLARE                                                 
 @query VARCHAR(MAX)                                                
 ,@ColumnList VARCHAR(max)                                                
 ,@where varchar(1000)                              
 ,@reporting varchar(max)                              
 ,@roleID int                
 ,@reportingType varchar(50)                               
                                          
                              
                              
declare @table table (Date datetime)                                                              
insert into @table select * from USP_EDB_GetDatesFromTwoDates( @StartDate,@EndDate)  

                                                              
SELECT @ColumnList = COALESCE(@ColumnList+']'+',' ,'') + '['+convert(varchar(12),Date,106) from @table order by Date                   
set @ColumnList=@ColumnList+']' 

                              
                              
if OBJECT_ID('tempdb..##tblEmployeehr') is not null                              
Begin                              
drop table ##tblEmployeehr                              
End            
                              
create table ##tblEmployeehr (employeeID int)                              
                              
set @where=''                                                
                              
 if(@3<>'0')                                                
 Begin                                                
  set @where=@where+' and EM.CompanyID='+@3                                                
 End                                        
                                                                   
                       
       
			   insert into ##tblEmployeehr(employeeID)                              
			   Select employeeID from VW_EmployeeDetails where EmployeementStatusID in(1,5)                    
			  union                    
			   Select employeeID from EmployeeMaster                     
			   where (LastDayWorked >= @EndDate or (LastDayWorked between @StartDate and @EndDate))                       

--select * from ##tblEmployeehr      
                               
                              
set @query='                                                  
select [Employee ID], Name,Status,Designation,Department,Process,'+@ColumnList+' from                                                               
(                         
SELECT     dbo.GetEmpID(EM.EmployeeID) AS [Employee ID]                                                
, ISNULL(EM.FirstName + ''  '', '''') + ISNULL(EM.MiddleName + '' '', '''')+ ISNULL(EM.LastName + '' '', '''') AS Name                                                
, EmployementStatus.EmployementStatus AS Status                                                
, DM.Designation, PM.ProcessName AS Process                                                
, DepM.DepartmentName AS Department                                            
--,''LeaveType''=dbo.fn_Get_EmpAttendanceStatus(EM.EmployeeID,GD.DATE)
,ISNULL(EC.AttendanceStatus,dbo.fn_Get_EmpAttendanceStatus(EM.EmployeeID,GD.DATE)) as LeaveType             
,''''+convert(varchar(12),GD.DATE,106) + '''' as DATEAPPLIED                                                
                                                
FROM         dbo.USP_EDB_GetDatesFromTwoDates('''+ @StartDate +''', '''+ @EndDate +''') AS GD CROSS JOIN                                                
                      EmployeeMaster AS EM INNER JOIN                                                
                      TeamMaster ON EM.TeamID = TeamMaster.TeamID INNER JOIN                                                
                      SubProcessMaster ON TeamMaster.SubProcessID = SubProcessMaster.SubProcessID INNER JOIN                                         
                      ProcessMaster AS PM ON SubProcessMaster.ProcessID = PM.ProcessID INNER JOIN                                                
                      DesignationMaster AS DM ON EM.DesignationID = DM.DesignationID INNER JOIN                                                
               EmployementStatus ON EM.EmployeementStatusID = EmployementStatus.EmployementStatusID INNER JOIN                                                
                      DepartmentMaster AS DepM ON PM.DepartmentID = DepM.DepartmentID LEFT JOIN
                       EmployeeAttendanceStatus EC ON EM.EmployeeID=EC.EmployeeID 
                     -- LEFT OUTER JOIN                                               
       -- EmployeeAttendance AS EA ON CAST(EM.EmployeeID AS varchar) = EA.EmployeeID AND GD.DATE = EA.IODate AND EA.IOStatus = ''Entry''                                                 
--LEFT OUTER JOIN   LeaveDetails AS LD ON EM.EmployeeID = LD.EmployeeID AND GD.DATE = LD.DateApplied AND LD.LeaveStatusID IN (16, 12)                                                
--LEFT OUTER JOIN   HolidayMaster AS HM ON EM.companyID=HM.companyID and  GD.Date=HM.HOLIDAYDATE                                                
WHERE (EM.Active = 1) AND EC.AttendanceDate= GD.DATE               
and  EM.employeeID  in (select employeeID from ##tblEmployeehr)                     
    '+ @where +'                              
)            
AS SourceTable PIVOT ( MAX(LeaveType) FOR DATEAPPLIED IN ( '+ @ColumnList + ' ) ) p                                                 
                                               
'                                                           
                                                             
--print(@query)
exec(@query)   
  
 DECLARE @EXCELVAR varchar(Max)
 SET @EXCELVAR=@query
 
  
-----------------------------------------------------------  
DECLARE @ColList varchar(Max)  
DECLARE @ColName varchar(100)  
DECLARE @ColList2 varchar(Max)  
SET @ColList = ''  
SET @ColList2 = ''  
SET @ColName = ''  
  
DECLARE AllColList CURSOR FOR  
select CONVERT(VARCHAR, DATE, 106) from USP_EDB_GetDatesFromTwoDates(@StartDate,@EndDate)  
 OPEN AllColList  
 FETCH NEXT FROM AllColList INTO @ColName  
 WHILE @@FETCH_STATUS = 0                        
    BEGIN                        
 SET @ColList = @ColList + '<td class="style2">' + @ColName + '</td>'  
 SET @ColList2 = @ColList2 + '<td class="style2">'''+ '+' + '['''+ @ColName + ''']' +'+' + '''</td>'  
    FETCH NEXT FROM AllColList INTO @ColName                       
    END                        
CLOSE AllColList                        
DEALLOCATE AllColList     
  
  
               
          
  
DECLARE @RowData varchar(MAX)  
DECLARE @EmailMessage varchar(MAX) 

DECLARE @empName varchar(300)      
  ,@empID varchar(50)     
  ,@mailto varchar(100)     
  --,@mailCC varchar(500)    
   ,@mailSubject varchar(100)
  ,@File varchar(20)
  ,@Separator NCHAR(1) = CHAR(9)
  ,@to VARCHAR(30)
                                               
SET @1=CONVERT(VARCHAR,CAST(@1 AS DATETIME),103)
SET @2=CONVERT(VARCHAR,CAST(@2 AS DATETIME),103)                                                
                        
SELECT @to=MailId FROM AlertNotificationIDs WHERE AlertType='AttendanceReportHR'
      
SET @File = 'Attendance' + RIGHT('0' + RTRIM(MONTH(GETDATE())), 2) + 
                               CONVERT(CHAR(2),GETDATE(),103) + 
                               SUBSTRING(CONVERT(VARCHAR(4),DATEPART(YY, GETDATE())),3,2) + '.xls' 
  

 ----Added for mail-------------
    
  set @mailSubject='ARMS-Monthly attendance report of '+@COMPANYNAME+'  employees from "'+@1+'" to '+@2+'"'
  SELECT @mailto=MailId FROM AlertNotificationIDs WHERE AlertType='AttendanceReportHR' and isCC='False'
  
  DECLARE @htmlbody VARCHAR(MAX)
--SET @htmlbody='<html> <head runat="server"> </head> <body>Dear Mr.'+@empName+ '<br/><br/>Monthly Attendance Report For All Employees '+@1+' TO '+@2+'</body></html>'

SET @htmlbody='


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">              
<html>              
 <head>              
<style type="text/css">              
    body              
    {              
        font-size:13px;              
        font-family:Arial;              
    }              
    </style>              
  <title></title>              
   </head>              
 <body class="style2" style="font-size: 9pt"> 

<table  class="style2" style="font-size: 9pt"><tr><td  class="style2" style="font-size: 9pt">

<table  class="style2" style="font-size: 9pt"><tr><td  class="style2" style="font-size: 9pt">
Hi Team <br/><br/>Monthly attendance report of '+@COMPANYNAME+' employees from "'+@1+'" to "'+@2+'"<br/><br/>Regards,<br/>HR Division<br/>Accretive Health </td></tr></table></body></html>'

  if(@mailto is not null and  @mailto !='')
		Begin
		

		 
		EXEC msdb.dbo.sp_send_dbmail 
       @profile_name='ARMS',
       @recipients=@mailto,  
      -- @recipients='raggarwal@accretivehealth.com', 
       @subject=@mailSubject, 
       @query=@EXCELVAR, 
       @query_result_width =65535, 
       @body=@htmlbody,   
       @execute_query_database='QAT-AHPLHRMS', 
       @query_result_separator=@Separator, 
       --@query_result_header=0, 
       @query_result_no_padding=1, 
       @attach_query_result_as_file=1, 
       @query_attachment_filename=@File, 
       @body_format='HTML',
       @importance='High'       
	    --set @mailto='' 
		End
  -------------------------------------------- 

--SET @EmailBody = @EmailBody + @EmailMessage + '</tr></table>' 


 -- SELECT  @EmailBody
GO
/****** Object:  StoredProcedure [dbo].[USP_EDB_UpdateTakenLeaveDetails]    Script Date: 08/08/2012 21:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================                            
-- Author:  Pankaj Yadav                     
-- Create date: 04 Sept 2011                
-- Description: updating employee leave balance                 
-- ===================================================================                 
ALTER PROCEDURE   [dbo].[USP_EDB_UpdateTakenLeaveDetails]              
AS              
SET NOCOUNT ON;              
BEGIN              
  DECLARE @leavesummaryID varchar(20),@EmployeeId varchar(50),@LeaveId varchar(20),@LeaveType varchar(20)             
  DECLARE LeaveUpdateTaken CURSOR FOR                    
           
          SELECT   LD.LeaveSummaryId,LD.EmployeeId,LD.LeaveId from leavedetails   
           LD inner join LeaveSummary LS ON (LD.LeaveSummaryId=LS.LeaveSummaryID)    
           WHERE Ld.LeaveStatusId =12 AND  LS.StartDate < getDate()                
            
     OPEN LeaveUpdateTaken                    
     FETCH NEXT                    
     FROM LeaveUpdateTaken INTO @leavesummaryID,@EmployeeId ,@LeaveId                   
     WHILE @@FETCH_STATUS = 0                    
       BEGIN                  
      SELECT  @LeaveType = LeaveTypeID FROM LeaveSummary WHERE LeaveSummaryId=@leavesummaryID              
      UPDATE LeaveDetails Set LeaveStatusId=16,LastUpdated=GETDATE(),UpdatedBy=0 WHERE LeaveId=@LeaveId              
            EXEC [dbo].[USP_EDB_UpdateEmpLeaveBalance] @EmployeeId,@LeaveType               
     FETCH NEXT                    
     FROM LeaveUpdateTaken INTO @leavesummaryID,@EmployeeId,@LeaveId                    
     END                    
     CLOSE LeaveUpdateTaken                    
     DEALLOCATE LeaveUpdateTaken            
     ----------------------------------------------Update Pending Leaves Status to Cancel ---------------------------           
             
      DECLARE LeaveUpdateCancel  CURSOR FOR                    
          SELECT DISTINCT  LD.LeaveSummaryId from leavedetails LD inner join LeaveSummary LS ON (LD.LeaveSummaryId=LS.LeaveSummaryID)    
          INNER JOIN EmployeeMAster EM  
          ON (LD.EmployeeID= EM.EmployeeID)   
          WHERE LD.LeaveStatusId =1 AND  DATEADD(DAY,5,LS.StartDate) < GETDate()   AND EM.EmployeementStatusId in (1,5)        
            
                
     OPEN LeaveUpdateCancel                       
     FETCH NEXT                    
     FROM LeaveUpdateCancel    INTO @leavesummaryID                   
     WHILE @@FETCH_STATUS = 0                    
       BEGIN         
  SELECT  @LeaveType = LeaveTypeID FROM LeaveSummary WHERE LeaveSummaryId=@leavesummaryID              
      
  DECLARE @isGrouped int     
  SET @isGrouped=0    
  IF((SELECT Count(LeaveId) FROM  leavedetails WHERE LeaveSummaryId=@leavesummaryID )  >1)    
  BEGIN    
  SET @isGrouped=1    
  END    
      
     DECLARE LeaveDetails  CURSOR FOR                    
     SELECT   EmployeeId,LeaveId from leavedetails WHERE LeaveSummaryId=@leavesummaryID AND LeaveStatusId=1      
     OPEN LeaveDetails                       
     FETCH NEXT                    
     FROM LeaveDetails    INTO @EmployeeId ,@LeaveId                   
     WHILE @@FETCH_STATUS = 0                    
       BEGIN         
       
         UPDATE LeaveDetails Set LeaveStatusId=13,LastUpdated=GETDATE(),UpdatedBy=0 WHERE LeaveId=@LeaveId              
      EXEC [dbo].[USP_EDB_UpdateEmpLeaveBalance] @EmployeeId,@LeaveType          
      EXEC USP_EDB_insertLeaveTransaction  @LeaveId,13,'0',0,0,@isGrouped --add For Leave Transaction    
     FETCH NEXT                    
     FROM LeaveDetails    INTO @EmployeeId,@LeaveId                    
     END                    
     CLOSE LeaveDetails                       
     DEALLOCATE LeaveDetails       
             
                       
     FETCH NEXT                    
     FROM LeaveUpdateCancel    INTO @leavesummaryID                   
     END                    
     CLOSE LeaveUpdateCancel                       
     DEALLOCATE LeaveUpdateCancel              
END
GO
/****** Object:  StoredProcedure [dbo].[USP_EDB_UpdateAutomaticWeekOff ]    Script Date: 08/08/2012 21:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                  
-- Author:  Pankaj Yadav                                  
-- Create date: 19 April 2012                                  
-- Description: Update Sat/Sunday Week Off Details                                  
-- =============================================                          
ALTER PROCEDURE [dbo].[USP_EDB_UpdateAutomaticWeekOff ] --4,2012,'101173'               
--DECLARE                             
 @1 int=0,--Month                          
 @2 int=0,--Year                             
 @3 varchar(20)='0'--Entered BY                            
AS        
      
BEGIN      
 DECLARE @EmployeeID int,    
 @Month int,    
 @year int,    
 @StartDate varchar(50),    
 @EndDate varchar(50),    
 @date datetime,    
 @LeaveSummaryID varchar(20),    
 @LeaveID VARCHAR(20),    
 @EnteredBy varchar(50)      
      
      
   IF( @1 = 0 OR @2 = 0 )  
   BEGIN  
  SET @Month=DATEPART(month,getDate())        
  SET @year=DATEPART(Year,getDate())       
  END  
  ELSE  
  BEGIN  
   SET @Month=@1        
   SET @year=@2    
  END  
       
  SET @EnteredBy=@3    
  SET @StartDate=cast(@month as varchar)+'/01/' + CAST(@YEAR AS CHAR(4))                                  
  --SET @StartDate = DATEADD(d, -(DATEPART(dd, @StartDate) - 1), @StartDate)                                   
  SET @EndDate=DATEADD(DD,-1,DATEADD(MM,1,@StartDate))        
      
    --print @StartDate  
    --print @EndDate  
      
      
 DECLARE CursorWeekOff Cursor for      
    SELECT EmployeeId FROM VW_EmployeeDetails      
    --WHERE  ProcessID NOT IN (select DISTINCT ProcessID from ProcessMaster WHERE ProcessCode ='MT' AND Active=1)      
 OPEN CursorWeekOff      
 FETCH NEXT FROM CursorWeekOff INTO @EmployeeID       
 WHILE @@FETCH_STATUS =0      
 BEGIN      
      
   -----------------------------------------------------------------------------------------------------------------------------------------      
       DECLARE CursorDate Cursor for      
       SELECT DATE from USP_EDB_GetDatesFromTwoDates(@StartDate,@EndDate)       
       WHERE DATENAME(DW,DATE) IN ('Saturday','Sunday')      
       AND DATE NOT in (SELECT HolidayDate FROM HolidayMaster WHERE Active=1)    
       OPEN CursorDate      
       FETCH NEXT FROM CursorDate INTO @date       
       WHILE @@FETCH_STATUS =0      
       BEGIN      
                      
       -----------------------------------------------------------------------------------------------------------------------      
        IF  NOT EXISTS( SELECT LEAVEID FROM DBO.LEAVEDETAILS WHERE EMPLOYEEID=@EmployeeID AND DATEAPPLIED =@date AND LeaveStatusID IN (1,12,16) )      
        BEGIN      
          INSERT INTO [LEAVESUMMARY]                                  
             ([AppliedFor],[AppliedBy],[AppliedOn],[StartDate],[EndDate],[LeaveTypeID],[Reason],[Status] )                                  
             VALUES (@EmployeeID,@EnteredBy,GETDATE(),@date,@date,22,'Week Off',1)                                  
                
          SET @LeaveSummaryID=@@IDENTITY        
                
          IF(@LeaveSummaryID <> '')      
          BEGIN      
            INSERT INTO [LEAVEDETAILS]                                  
              ([EMPLOYEEID],[LEAVEDURATION],[DATEAPPLIED],[LEAVESTATUSID],[LEAVESUMMARYID])                                  
             VALUES ( @EmployeeID,1,@date,12,@LeaveSummaryID )      
            --SET @LEAVEID = SCOPE_IDENTITY()          
          END              
        END      
       -----------------------------------------------------------------------------------------------------------------------                  
             
       FETCH NEXT FROM CursorDate  INTO @date       
       END      
       CLOSE CursorDate      
       DEALLOCATE CursorDate      
          
          
      
  -------------------------------------------------------------------------------------------------------------------------------------------      
      
 FETCH NEXT FROM CursorWeekOff  INTO @EmployeeID       
 END      
 CLOSE CursorWeekOff      
 DEALLOCATE CursorWeekOff      
          
       
 END
GO
/****** Object:  StoredProcedure [dbo].[USP_eExitGetEmployeeDetails]    Script Date: 08/08/2012 21:51:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================          
-- Author:		Nasim        
-- Create date: 19 jan 2012    
-- Description: Getting Employee details for resignation
-- =============================================          
  
ALTER PROCEDURE [dbo].[USP_eExitGetEmployeeDetails]  
@1 varchar(50)	--Employee ID
AS          
BEGIN            
SELECT     vEM.EmployeeID, CAST(NPM.noticePeriod AS varchar) + ' Days' AS NoticePeriod, vEM.Name, vEM.DOJ, vEM.Designation, vEM.Process, 
                      vEM.company, vEM.EmployementStatus, vEM.EmployeeIDFull
FROM         DesignationMaster AS DM INNER JOIN
                      VW_EmployeeDetails AS vEM ON DM.DesignationID = vEM.DesignationID INNER JOIN
                      NoticePeriodMatrix AS NPT ON DM.BandID = NPT.BandID INNER JOIN
                      NoticePeriodMaster AS NPM ON NPM.noticePeriodID = NPT.NoticePeriodID
WHERE     (vEM.EmployeeID = @1) AND (NPT.active = 1)

       
END
GO
/****** Object:  StoredProcedure [dbo].[USP_EmployeeAttendanceReport]    Script Date: 08/08/2012 21:51:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_EmployeeAttendanceReport] --'05/28/2012','06/28/2012','0','0','','300059','1','0','0'                
 @1 varchar(50),--Start Date                                                                              
 @2 varchar(50),--End Date                                                                                 
 @3 varchar(50),--Company ID                                                                                 
 @4 varchar(50),--Process ID                                                                                 
 @5 varchar(50),--Employee ID                                                                                 
 @6 varchar(50),--UserID                                                  
 @7 varchar(50),--Employement Status                                          
 @8 varchar(1),--DR                             
 @9 varchar(1)--My self                                     
AS                                    
                                                                      
--DECLARE                                                                                 
-- @1 varchar(50),--Start Date                                                                              
-- @2 varchar(50),--End Date                                                                                 
-- @3 varchar(50),--Company ID                                                                                 
-- @4 varchar(50),--Process ID                                                                                 
-- @5 varchar(50),--Employee ID                                                                                 
-- @6 varchar(50),--UserID                                                
-- @7 varchar(50),--Employement Status                                      
-- @8 varchar(1), --My DR                                   
-- @9 varchar(1)  -- Myself                                 
                                                                   
--SET @1='5/28/2012'                                                                                  
--SET @2='6/28/2012'                                                                           
--SET @3='55'                                                           
--SET @4='0'                                                           
--SET @5=''                                                           
--SET @6='101062'                                           
--SET @7='0'                                                                                  
--SET @8='0'                                        
--SET @9='0'                                        
                                                                        
                                                                                  
 DECLARE @StartDate VARCHAR(15),@EndDate VARCHAR(15)                                                                                  
 SET @StartDate=CONVERT(VARCHAR,CAST(@1 AS DATETIME),101)                                                                                 
 SET @EndDate=CONVERT(VARCHAR,CAST(@2 AS DATETIME),101)                                                    
                                                   
                                                                                  
DECLARE                                                                     
 @query VARCHAR(MAX)                                                                    
 ,@ColumnList VARCHAR(max)                                                                       
 ,@where varchar(1000)                                                  
 ,@reporting varchar(max)                                                  
 ,@roleID int                                    
 ,@reportingType varchar(50)                                                   
                                   
                                                                  
                                                    
 IF(@6='0')                
  BEGIN                                                  
   SET @roleID=4                                  
  END                                                   
 ELSE                              
  Begin                                                  
   select @roleID=roleid from Login where EmployeeID=@6                                              
  End                                                   
                    
 set @roleID=ISNULL(@roleID,2)                                                                    
                              
                                                  
declare @table table (Date datetime)                                                     
insert into @table select * from USP_EDB_GetDatesFromTwoDates(@StartDate,@EndDate)                                                                                  
                                     
                                                                                  
SELECT @ColumnList = COALESCE(@ColumnList+''']'+',' ,'') + '['''+convert(varchar(12),Date,106) from @table order by Date                                       
set @ColumnList=@ColumnList+''']'  
                                                        
                                                  
IF OBJECT_ID('tempdb..#tblEmployee') is not null                                                  
BEGIN                
 DROP TABLE #tblEmployee                                                  
END                
create table #tblEmployee (employeeID int)                                                                                              
set @where=''                                                                                                                
 if(@3<>'0')                                                                    
 Begin                                                                    
  set @where=@where+' and EM.CompanyID='+@3                                                                    
 End                                                            
                                                          
 if(@4<>'0')                                                          
 Begin                                                     
  set @where= @where + ' and PM.ProcessID='+@4                                                                    
 End                                                   
                                                           
                                                               
if(@5<>'')                                                                    
 Begin                                                                    
  set @where=@where +' and EM.EmployeeID='+@5                                                          
 End                                                       
                                           
 if(@7<>'0')                                                                    
 Begin                                                                    
  SET @where=@where +' and EM.EmployeementStatusID='+@7                                                
 End                                         
                                     
  if(@8='1')                                                                    
 Begin                                                                    
  SET @reportingType='Direct'                                    
 End                               
                             
                             
                             
  if(@9='1' and @8='0')                            
  Begin                            
                                
   insert into #tblEmployee(employeeID)                              
   select @6                               
  End                            
                          
Else      
Begin                            
                          
 if(@9='1' and @8='1')                            
   Begin                            
                                 
    insert into #tblEmployee(employeeID)                              
    select @6                               
   End                                                  
                                                  
 if(@roleID=4)                                           
   Begin                                          
        if(@8=1)                            
        Begin                            
       insert into #tblEmployee(employeeID)                                                  
       Select employeeID from VW_EmployeeDetails where EmployeementStatusID in(1,5)                             
       and EmployeeID in(select employeeID from EmployeeReportingLead                             
             where HeadID=@6 and Active=1 and ReportingType=ISNULL(@reportingType,ReportingType)                             
            )                                          
      union                                        
       Select employeeID from EmployeeMaster                                         
       where (LastDayWorked >= @EndDate or (LastDayWorked between @StartDate and @EndDate))                            
       and EmployeeID in(select employeeID from EmployeeReportingLead                             
             where HeadID=@6 and Active=1 and ReportingType=ISNULL(@reportingType,ReportingType)                             
            )                                              
        End                                   
        else                            
        Begin                            
       insert into #tblEmployee(employeeID)                                                  
       Select employeeID from VW_EmployeeDetails where EmployeementStatusID in(1,5)                                        
   union                                        
       Select employeeID from EmployeeMaster  EM                                        
       where --(LastDayWorked >= @EndDate or (LastDayWorked between @StartDate and @EndDate))                                           
        (                                
        ((EM.LastDayWorked >= @EndDate or (EM.LastDayWorked between @StartDate and @EndDate)))                                
        OR                                          
        ((EM.TransferDate >= @EndDate or (EM.TransferDate between @StartDate and @EndDate)))                                
       )                  
     End                            
                    
   End                                                   
 else                                        
  Begin                               
                              
  insert into #tblEmployee(employeeID)                              
                               
    Select employeeID from VW_EmployeeDetails                                         
    where ProcessID in (select ProcessID from EmployeeAttendanceProcessMatrix where EmployeeID=@6)                                          
        OR EmployeeID in(select employeeID from EmployeeReportingLead                             
             where HeadID=@6 and Active=1 and ReportingType=ISNULL(@reportingType,ReportingType)                             
            )                              
     Union                                    
                                                       
    SELECT     EM.EmployeeID                                                  
    FROM         EmployeeMaster AS EM INNER JOIN                                                  
      TeamMaster AS TM ON EM.TeamID = TM.TeamID INNER JOIN                                                  
      SubProcessMaster AS SPM ON TM.SubProcessID = SPM.SubProcessID                                                  
    WHERE     (EM.Active = 1)                                                 
   and (                                        
        ((EM.LastDayWorked >= @EndDate or (EM.LastDayWorked between @StartDate and @EndDate)))                                        
        OR                                                  
        ((EM.TransferDate >= @EndDate or (EM.TransferDate between @StartDate and @EndDate)))                                        
       )                                        
       and SPM.ProcessID in(select ProcessID from EmployeeAttendanceProcessMatrix where EmployeeID=@6)                                           
                                              
   Union                        
                                              
    SELECT     EM.EmployeeID                                                  
    FROM         EmployeeMaster AS EM INNER JOIN                                                  
      TeamMaster AS TM ON EM.TeamID = TM.TeamID INNER JOIN                                                  
      SubProcessMaster AS SPM ON TM.SubProcessID = SPM.SubProcessID                                                  
    WHERE     (EM.Active = 1)                                                 
       and (                                        
        ((EM.LastDayWorked >= @EndDate or (EM.LastDayWorked between @StartDate and @EndDate)))                                        
        OR                                                  
        ((EM.TransferDate >= @EndDate or (EM.TransferDate between @StartDate and @EndDate)))                                        
       )                                        
       and EmployeeID in(select employeeID from EmployeeReportingLead                             
           where HeadID=@6 and Active=1  and ReportingType=ISNULL(@reportingType,ReportingType))                                                    
                                
   End                             
                                  
END                                     
                                         
                          
--select * from #tblEmployee                          
                                   
                                                  
set @query='                                                                      
select [Employee ID],Name,Status,Designation,Department,Process,'+@ColumnList+' from                                                                                   
(                                             
SELECT     dbo.GetEmpID(EM.EmployeeID) AS [Employee ID]                                                       
, ISNULL(EM.FirstName + ''  '', '''') + ISNULL(EM.MiddleName + '' '', '''')+ ISNULL(EM.LastName + '' '', '''') AS Name                                                                    
, EmployementStatus.EmployementStatus AS Status                                                                    
, DM.Designation, PM.ProcessName AS Process                                                                    
, DepM.DepartmentName AS Department                                                                
--,''LeaveType''=dbo.fn_Get_EmpAttendanceStatus(EM.EmployeeID,GD.DATE)        
,ISNULL(EC.AttendanceStatus,dbo.fn_Get_EmpAttendanceStatus(EM.EmployeeID,GD.DATE)) as LeaveType                   
                  
,''''''''+convert(varchar(12),GD.DATE,106) + '''''''' as DATEAPPLIED                                                               
                                                                    
FROM         dbo.USP_EDB_GetDatesFromTwoDates('''+ @StartDate +''', '''+ @EndDate +''') AS GD CROSS JOIN                                                                    
                      EmployeeMaster AS EM INNER JOIN                                                                    
                      TeamMaster ON EM.TeamID = TeamMaster.TeamID INNER JOIN                                                                    
                      SubProcessMaster ON TeamMaster.SubProcessID = SubProcessMaster.SubProcessID INNER JOIN                                                             
                      ProcessMaster AS PM ON SubProcessMaster.ProcessID = PM.ProcessID INNER JOIN                                                                    
                      DesignationMaster AS DM ON EM.DesignationID = DM.DesignationID INNER JOIN                                                                    
       EmployementStatus ON EM.EmployeementStatusID = EmployementStatus.EmployementStatusID INNER JOIN                                                     
                      DepartmentMaster AS DepM ON PM.DepartmentID = DepM.DepartmentID LEFT OUTER JOIN      
                      EmployeeAttendanceStatus EC ON EM.EmployeeID=EC.EmployeeID AND EC.AttendanceDate= GD.DATE     
                            
                                 
WHERE (EM.Active = 1)      
and  EM.employeeID  in (select employeeID from #tblEmployee)                              
                 
    '+ @where +'                                                  
)                                
AS SourceTable PIVOT ( MAX(LeaveType) FOR DATEAPPLIED IN ( '+ @ColumnList + ' ) ) p                                                                     
                                                              
'                                                                               
                                                                                 
print (@query )                                                            
exec(@query)        
        
        
        
--IF OBJECT_ID('tempdb..#tblEmployee') is not null                                                  
--BEGIN                
-- DROP TABLE #tblEmployee                                                  
--END                
--IF OBJECT_ID('EmployeeAttendance_new') is not null                                                  
--BEGIN                
-- DROP TABLE EmployeeAttendance_new                                                  
--END
GO
/****** Object:  StoredProcedure [dbo].[USP_EmployeeAttendanceLeaveReport]    Script Date: 08/08/2012 21:51:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_EmployeeAttendanceLeaveReport]--'06/01/2012','07/24/2012','0','0','300311','300479','0','0','0'                                                                    
 @1 varchar(50),--Start Date                                                                          
 @2 varchar(50),--End Date                                                                             
 @3 varchar(50),--Company ID                                                                             
 @4 varchar(50),--Process ID                                                                             
 @5 varchar(50),--Employee ID                                                                             
 @6 varchar(50),--UserID                                              
 @7 varchar(50),--Employement Status                                      
 @8 varchar(1),--DR                         
 @9 varchar(1)--My self                                 
AS                                
                                                                    
--DECLARE                                                                             
-- @1 varchar(50),--Start Date   
-- @2 varchar(50),--End Date  
-- @3 varchar(50),--Company ID  
-- @4 varchar(50),--Process ID   
-- @5 varchar(50),--Employee ID                                                                             
-- @6 varchar(50),--UserID                                            
-- @7 varchar(50),--Employement Status                                  
-- @8 varchar(1), --My DR                               
-- @9 varchar(1)  -- Myself                             
                                                               
--SET @1='5/28/2012'                                                                              
--SET @2='6/28/2012'                                                                       
--SET @3='57'                                                       
--SET @4='0'                                                       
--SET @5=''                                                       
--SET @6='312345'                                       
--SET @7=' '                                                                              
--SET @8='0'                                    
--SET @9='1'                                    
                                                                    
                                                                              
DECLARE @StartDate varchar(50),@EndDate varchar(50)                                                                              
 SET @StartDate=Convert(varchar,cast(@1 as datetime),101)                                                                             
 SET @EndDate=Convert(varchar,cast(@2 as datetime),101)                                                
  
  
DECLARE                                                                 
 @query VARCHAR(MAX)                                                                
 ,@ColumnList VARCHAR(max)                                                                
 ,@where varchar(1000)                                              
 ,@reporting varchar(max)                                              
 ,@roleID int                                
 ,@reportingType varchar(50)  
 ,@ColumnList1 VARCHAR(max)                                               
         
 IF(@6='0')                                              
  BEGIN                                              
   SET @roleID=4                                              
  END                           
 ELSE                                              
  Begin                   
   select @roleID=roleid from Login where EmployeeID=@6                                              
  End                               
                                              
 set @roleID=ISNULL(@roleID,2)                                            
       
DECLARE @table table (LeaveType VARCHAR(MAX))      
insert into @table select LeaveType from LeaveType WHERE Active=1        
      
--select * from @table      
      
SELECT @ColumnList = COALESCE(@ColumnList+']'+',' ,'') + '['+LeaveType from @table                     
set @ColumnList=@ColumnList+']'    
  
DECLARE @table1 table (LeaveType VARCHAR(MAX))      
insert into @table1 select ISNULL(LeaveType,0) from LeaveType WHERE Active=1        
      
--select * from @table      
      
SELECT @ColumnList1 = COALESCE(@ColumnList1+']'+',' ,'') + 'ISNULL(['+LeaveType+'],0) AS ['+LeaveType from @table  
  
set @ColumnList1=@ColumnList1+']'  
                                            
                                              
if OBJECT_ID('tempdb..#tblEmployee') is not null                                              
Begin                                              
drop table #tblEmployee                                              
End                            
                                              
create table #tblEmployee (employeeID int)                                              
                                              
set @where=''                                                                
                                              
 if(@3<>'0')                                                                
 Begin                                                                
  set @where=@where+' and EM.CompanyID='+@3                                                                
 End                                                        
                                                      
 if(@4<>'0')                                                      
 Begin                                                 
  set @where= @where + ' and PM.ProcessID='+@4                                                                
 End                                               
                                                       
                                                           
if(@5<>'')                                                                
 Begin                                                                
  set @where=@where +' and EM.EmployeeID='+@5                                                      
 End                                                   
                                       
 if(@7<>'0' and  @7<>'')                                                                
 Begin                                                                
  SET @where=@where +' and EM.EmployeementStatusID='+@7                                                      
 End                                     
                                 
  if(@8='1')                                                                
 Begin                                                                
  SET @reportingType='Direct'                                
 End                           
                         
                         
                         
  if(@9='1' and @8='0')                        
  Begin                        
                            
   insert into #tblEmployee(employeeID)                          
   select @6                           
  End                        
                      
Else                                          
Begin                        
                      
 if(@9='1' and @8='1')                        
   Begin                        
                             
    insert into #tblEmployee(employeeID)                          
    select @6                           
   End                                              
                                              
 if(@roleID=4)                                              
   Begin                                      
        if(@8=1)                        
        Begin                        
       insert into #tblEmployee(employeeID)                                              
       Select employeeID from VW_EmployeeDetails where EmployeementStatusID in(1,5)       
       and EmployeeID in(select employeeID from EmployeeReportingLead                         
             where HeadID=@6 and Active=1 and ReportingType=ISNULL(@reportingType,ReportingType)                        
            )                                      
      union                        
       Select employeeID from EmployeeMaster                                     
       where (LastDayWorked >= @EndDate or (LastDayWorked between @StartDate and @EndDate))                        
       and EmployeeID in(select employeeID from EmployeeReportingLead                         
             where HeadID=@6 and Active=1 and ReportingType=ISNULL(@reportingType,ReportingType)                         
            )                             
        End                               
        else                        
        Begin                        
       insert into #tblEmployee(employeeID)                                              
       Select employeeID from VW_EmployeeDetails where EmployeementStatusID in(1,5)                                    
   union                                    
       Select employeeID from EmployeeMaster                                     
       where (LastDayWorked >= @EndDate or (LastDayWorked between @StartDate and @EndDate))                                       
     End                        
                
   End                                               
 else                                    
  Begin                           
                          
  insert into #tblEmployee(employeeID)                          
                           
    Select employeeID from VW_EmployeeDetails                                     
    where ProcessID in (select ProcessID from EmployeeAttendanceProcessMatrix where EmployeeID=@6)                                      
        OR EmployeeID in(select employeeID from EmployeeReportingLead                         
             where HeadID=@6 and Active=1 and ReportingType=ISNULL(@reportingType,ReportingType)                         
            )                          
     Union                                
                                                   
    SELECT     EM.EmployeeID                                              
    FROM         EmployeeMaster AS EM INNER JOIN                                              
      TeamMaster AS TM ON EM.TeamID = TM.TeamID INNER JOIN                                              
      SubProcessMaster AS SPM ON TM.SubProcessID = SPM.SubProcessID                                              
    WHERE     (EM.Active = 1)                                             
       and (                                    
        ((EM.LastDayWorked >= @EndDate or (EM.LastDayWorked between @StartDate and @EndDate)))                                    
        OR                                              
        ((EM.TransferDate >= @EndDate or (EM.TransferDate between @StartDate and @EndDate)))                                    
       )                                    
       and SPM.ProcessID in(select ProcessID from EmployeeAttendanceProcessMatrix where EmployeeID=@6)                                       
                                          
   Union                                    
                                          
    SELECT     EM.EmployeeID                                              
    FROM         EmployeeMaster AS EM INNER JOIN                                              
      TeamMaster AS TM ON EM.TeamID = TM.TeamID INNER JOIN                                              
      SubProcessMaster AS SPM ON TM.SubProcessID = SPM.SubProcessID                                              
    WHERE     (EM.Active = 1)                                             
       and (                                    
        ((EM.LastDayWorked >= @EndDate or (EM.LastDayWorked between @StartDate and @EndDate)))                                    
        OR                       
        ((EM.TransferDate >= @EndDate or (EM.TransferDate between @StartDate and @EndDate)))                                    
       )                               
       and EmployeeID in(select employeeID from EmployeeReportingLead                         
           where HeadID=@6 and Active=1  and ReportingType=ISNULL(@reportingType,ReportingType))                                                
                            
   End                         
          
END             
                                     
                      
--select * from #tblEmployee               
--print @where                   
                                               
if((@5 is not null or @5<>'') and @9='0' and @8='0')      
begin      
set @query='                                                                  
SELECT  EmployeeId,Name,'+@ColumnList1+'FROM(            
SELECT  EM.EmployeeId AS EmployeeId,EM.FirstName+'' ''+EM.LastName AS Name,  B.LeaveType,L.LeaveDuration       
  FROM EmployeeMaster EM     
  INNER JOIN TeamMaster ON EM.TeamID = TeamMaster.TeamID    
  INNER JOIN  SubProcessMaster ON TeamMaster.SubProcessID = SubProcessMaster.SubProcessID                            
  INNER JOIN ProcessMaster AS PM ON SubProcessMaster.ProcessID = PM.ProcessID         
  LEFT JOIN LeaveDetails L ON (EM.EmployeeId=L.EmployeeId AND L.LeaveStatusId IN (12,16) and CONVERT(VARCHAR,DateApplied,101) BETWEEN '''+@StartDate+''' AND '''+@EndDate+''')      
  LEFT JOIN  LeaveSummary C ON (C.LeaveSummaryID=L.LeaveSummaryID)      
  LEFT JOIN LeaveType B ON (B.LeaveTypeID=C.LeaveTypeID)      
                   
WHERE EM.Active=1             
--AND  EM.employeeID  in (select employeeID from #tblEmployee)  
 '+ @where +'                                                  
)                            
      
A PIVOT (SUM(LeaveDuration)FOR LeaveType IN ('+@ColumnList+') ) AS S '         
end      
else      
begin                                              
set @query='                                                                  
SELECT  EmployeeId,Name,'+@ColumnList1+'FROM(            
SELECT  EM.EmployeeId AS EmployeeId,EM.FirstName+'' ''+EM.LastName AS Name,  B.LeaveType,L.LeaveDuration      
  FROM EmployeeMaster EM     
  INNER JOIN TeamMaster ON EM.TeamID = TeamMaster.TeamID            
  INNER JOIN  SubProcessMaster ON TeamMaster.SubProcessID = SubProcessMaster.SubProcessID   
  INNER JOIN  ProcessMaster AS PM ON SubProcessMaster.ProcessID = PM.ProcessID         
  LEFT JOIN LeaveDetails L ON (EM.EmployeeId=L.EmployeeId AND L.LeaveStatusId IN (12,16) and CONVERT(VARCHAR,DateApplied,101) BETWEEN '''+@StartDate+''' AND '''+@EndDate+''')      
  LEFT JOIN  LeaveSummary C ON (C.LeaveSummaryID=L.LeaveSummaryID)      
  LEFT JOIN LeaveType B ON (B.LeaveTypeID=C.LeaveTypeID)      
                   
WHERE EM.Active=1             
AND  EM.employeeID  in (select employeeID from #tblEmployee)              
  
          
 '+ @where +'                                                  
)                            
  
A PIVOT (SUM(LeaveDuration)FOR LeaveType IN ('+@ColumnList+') ) AS S '         
end                                                                 
print (@query )                                                        
exec(@query)
GO
/****** Object:  StoredProcedure [dbo].[USP_EmployeeWeekOffReport]    Script Date: 08/08/2012 21:51:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                                                  
-- Author:  Pankaj Yadav                                                                                  
-- Create date: 21 March 2012                                                                                  
-- Description: Get Employee Week Off Details                                                                                  
-- =============================================                                                                                        
ALTER PROCEDURE [dbo].[USP_EmployeeWeekOffReport] --6,2012                                                                                          
--DECLARE                                                                                                       
 @1 varchar(50),--Month                                                                      
 @2 varchar(50),--Year                                                                      
 @3 varchar(50),--Company ID                                                                       
 @4 varchar(50),--Process ID                                                                        
 @5 varchar(50),--Sub Process Id                                                                        
 @6 varchar(50),--Emp Status                                                                      
 @7 varchar(50),--Designation                                                                       
 @8 varchar(50),--Employee Id                                                                      
 @9 varchar(50),--User ID                                     
 @10 varchar(20)='False'--MyDR                                    
                        
      AS                                                                                                
                                                                            
 --SET    @1='6'                                                                            
 --SET    @2='2012'                                                                              
 --SET    @3=0                                                                            
 --SET    @4=0                                                                      
 --SET    @5=0                                                                            
 --SET    @6=0                                                                      
 --SET    @7=0                                                                      
 --SET    @8='101173'                                                                             
 --SET    @9='0'                                                                             
                                                                                              
 DECLARE @query VARCHAR(MAX) ,@ColumnList VARCHAR(max),@ColumnList1 varchar(MAX) ,@where varchar(MAX),@OrderBy varchar(500),@Date datetime,@roleID int ,                                                                                  
     @StartDate varchar(50),@EndDate varchar(50), @month int,  @YEAR int,@WeekCount int ,@CurrentWeekNo int                                                                                                  
  SET @month =@1                                                                                  
  SET @YEAR =@2                                                                                  
     SET @StartDate=cast(@month as varchar)+'/01/' + CAST(@YEAR AS CHAR(4))                                                                                  
     --SET @StartDate = DATEADD(d, -(DATEPART(dd, @StartDate) - 1), @StartDate)                                                                                   
     SET @EndDate=CONVERT(VARCHAR,DATEADD(DD,-1,DATEADD(MM,1,@StartDate)),101)                                                                     
    --SET @StartDate='04/01/2012'                         
    --SET @EndDate='04/03/2012'                   
                       
       PRINT @StartDate                
       PRINT @EndDate                
                                            
   IF(@9='0')                                                                          
   BEGIN SET @roleID=4 END                                                                                          
  ELSE                                                                                          
  BEGIN SET @roleID=(select roleID from login where employeeID=@9) END                                                                           
                             
    DECLARE @table table (EmployeeId int ,Name varchar(500),DOJ VARCHAR(50),DATE datetime,WO int,CompanyId int,ProcessID int,SubProcessID int,EmployeementStatusID int,DesignationID int);                                                                     
     
    IF OBJECT_ID('tempdb..#tblWODetails','u') IS NOT NULL                                                                                  
    BEGIN                                              
   DROP TABLE #tblWODetails                                 
    END                                                                           
                                 
   CREATE  table  #tblWODetails  (EmployeeId int ,Name varchar(500),DOJ VARCHAR(50),DATE VARCHAR(50),WO int,CompanyId int,ProcessID int,SubProcessID int,EmployeementStatusID int,DesignationID int);                                               
    WITH EmployeeWOCTE                                                                            
    AS                                                         
    (                                                 
    SELECT convert(datetime,convert(varchar,@startdate,101)) [Date],EmployeeID,Name,VW_EmployeeDetails.DOJ,                                                                            
     CASE WHEN (SELECT count(LeaveDetails.LeaveID) FROM dbo.LeaveDetails INNER  JOIN dbo.LeaveSummary                                                                            
     ON dbo.LeaveDetails.LeaveSummaryID=dbo.LeaveSummary.LeaveSummaryID                                                                                  
     WHERE  convert(DATETIME,DateApplied)=convert(DATETIME,@startdate) AND                                                                             
    dbo.LeaveDetails.LeaveStatusID in (1,12,16) AND LeaveTypeID=22 AND Status=1                                                                            
    AND dbo.LeaveDetails.EmployeeID=VW_EmployeeDetails.EmployeeID) =0  THEN 0 ELSE 1 END                                                                            
    AS WO ,CompanyID,ProcessID                                                                      
    ,SubProcessID                                                                      
    ,EmployeementStatusID                                                                      
    ,DesignationID                                                                          
   FROM dbo.VW_EmployeeDetails                                                                             
   WHERE CONVERT(datetime,DOJ) <= CONVERT(datetime, @EndDate)                                
                                  
                                                               
     UNION ALL                                                                          
                                                                                    
   SELECT dateadd(d,1,CTE.date) [Date],AED.EmployeeID,AED.Name,AED.DOJ,                                                                            
     CASE WHEN (SELECT LeaveDetails.LeaveID FROM dbo.LeaveDetails inner join dbo.LeaveSummary                                                                            
     ON dbo.LeaveDetails.LeaveSummaryID=dbo.LeaveSummary.LeaveSummaryID                                                                            
     WHERE convert(varchar,DateApplied,101)=convert(varchar,DateAdd(day,1,CTE.date),101) AND                                                                  
     dbo.LeaveDetails.LeaveStatusID in (1,12,16) AND LeaveTypeID=22 AND Status=1                                                                            
     AND dbo.LeaveDetails.EmployeeID=AED.EmployeeID) IS NULL THEN 0 ELSE 1 END                                                                            
     AS WO ,                                                                      
     AED.CompanyID                                                                      
       ,AED.ProcessID                                                                      
       ,AED.SubProcessID                                                                      
         ,AED.EmployeementStatusID                                                                      
     ,AED.DesignationID                                                                      
    FROM dbo.VW_EmployeeDetails  AED INNER  JOIN                                  
      EmployeeWOCTE CTE On CTE.EmployeeID=AED.EmployeeID                                                                              
    WHERE CTE.[Date]<@enddate                                   
    AND  CONVERT(datetime,AED.DOJ) <= CONVERT(datetime, @EndDate)                                                                     
  )                                                                         
                                                                  
                                                                                
   INSERT  INTO @table SELECT EmployeeID,Name,DOJ,[Date],WO,CompanyID,ProcessID,SubProcessID,EmployeementStatusID,DesignationID from EmployeeWOCTE                                                                          
   SELECT                                                          
   @ColumnList = COALESCE(@ColumnList + ',[' +   CONVERT(VARCHAR,DATEPART(day,DATE)) + ' ' + CONVERT(varchar(2),datename(dw,DATE),106)  + ']',                                                                          
        '[' +   CONVERT(VARCHAR,DATEPART(day,DATE)) + ' ' + CONVERT(varchar(2),datename(dw,DATE),106)  + ']')                                                                          
   FROM (SELECT DISTINCT DATE FROM @table)p                                        
                                                                         
 -- select * from #tblWODetails                                                                           
   INSERT INTO #tblWODetails                                                                          
   select EmployeeId,Name,DOJ,CONVERT(VARCHAR,DATEPART(day,DATE)) + ' ' + CONVERT(varchar(2),datename(dw,DATE),106) ,WO,CompanyId,ProcessID,SubProcessID,EmployeementStatusID,DesignationID from @table                                                        
     
    
       
       
          
            
             
                                           
--select * from #tblWODetails                                                                         
  --select @ColumnList                                                                          
  SET @query = N'SELECT EmployeeID,Name,DOJ, '+                                                                          
  @ColumnList +'                                                                          
  FROM   #tblWODetails  WO                                                                            
  PIVOT                                                                          
  (                                                                  
  MAX(WO)                                                                          
  FOR Date IN                                                                          
  ( '+                                                                     
  @ColumnList +' )                                                                          
  ) AS pvt                                                         
  '                            
 SET @where =' WHERE  EmployeementStatusID in (1,5)  '                                                                      
 SET @OrderBy =' ORDER BY EmployeeId '                                  
 IF(@3 <> '0')                                                                            
 BEGIN                                                                            
  SET @where =@where+' AND  CompanyID='+@3                                                                
 END                                                                            
          
         
          
                                                                               
   IF(@4 <> '0')                      
   BEGIN         
                                                    
  SET @where =@where+' AND  ProcessID='+@4                                                                            
   END                    
                                         
   IF(@5 <> '0')                                                        
   BEGIN                                                                            
  SET @where =@where+' AND  SubProcessID='+@5                                     
   END                                                                            
                                                                               
   IF(@7 <> '0')                              
   BEGIN                                                                            
  SET @where =@where+' AND DesignationID='+@7                                                                            
   END                                                                            
                                                 
   IF(@6 <> '0')                                                                            
   BEGIN                                                                            
  SET @where =@where+' AND  EmployeementStatusID='+@6                                        
   END                                                                            
                                                                               
   IF(@8 <> '')                                                                            
   BEGIN                                                                        
  SET @where =@where+' AND  EmployeeID='+@8                                                                            
   END                                            
                                           
   IF(@10='True')                                                                                
   BEGIN                                                                                
   SET @where= @where +' AND EmployeeID in (Select DISTINCT EmployeeID FROM dbo.EmployeeReportingLead WHERE HeadID='+@9+' AND ACTIVE=1 AND ReportingType=''Direct''  union select '+ @9+')'                              
   End                                      
   ELSE                                    
 BEGIN                                    
   IF(@roleID<> 4)                                                                                
     BEGIN                                                                                
     SET @where= @where +' AND EmployeeID in (Select DISTINCT EmployeeID FROM dbo.EmployeeReportingLead WHERE HeadID='+@9+' AND ACTIVE=1   union select '+ @9+')'                                                                                
     END                                      
 END                                     
                                             
 --print (@query+@where+@OrderBy)      
 EXECUTE(@query+@where+@OrderBy)
GO
/****** Object:  StoredProcedure [dbo].[usp_EmployeeAttendanceTime]    Script Date: 08/08/2012 21:51:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  RAHUL AGGARWAL  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
ALTER PROCEDURE [dbo].[usp_EmployeeAttendanceTime] --'300409,atma','3','7/16/2012','180','qsqwded','insert','300417','1'  
   
  
 @1 VARCHAR(50)=NULL,--@EmployeeID  
 @2 TINYINT=NULL,--@AttendanceType  
 @3 DATETIME=NULL,--@UpdatedDate  
 @4 INT=NULL,--@TimeInMinutes   
 @5 VARCHAR(100)=NULL,--@Remark  
 @6 VARCHAR(20)=NULL,--@ActionType  
 @7 VARCHAR(50)=NULL,--@UserId  
 @8 VARCHAR(10) =0--@EmployeeTimeId  
  
AS  
BEGIN  
  
 SET NOCOUNT ON;  
           
        BEGIN TRY  
          
        DECLARE @RESULT VARCHAR(50)   
          
        SET @1= LEFT(@1,6)  
          
        SET @8=CONVERT(INT,@8)  
          
          
          
        SELECT @8=EmployeeTimeID FROM EmployeeAttendanceTime WHERE EmployeeID=@1  
          
        IF(@6='Insert')  
  BEGIN   
    
  Declare @Countvalue int  
    
  Select @Countvalue=count (*) from EmployeeAttendanceTime where [Date]=@3 and [Type]=@2 and EmployeeID=@1 and Active=1  
    
  IF(@Countvalue=0)  
  BEGIN  
  INSERT INTO EmployeeAttendanceTime  (EmployeeID  
              ,[Date]  
              ,TimeInMinute  
           ,Remarks  
           ,[Type]  
           ,Active  
           ,EntryDate  
           ,EnteredBy)  
         VALUES (@1  
           ,@3  
           ,@4  
           ,@5  
           ,@2  
           ,1  
           ,CONVERT(VARCHAR,GETDATE(),101)  
           ,@7)  
             
            SET @RESULT=1    
  END  
  ELSE  
  BEGIN  
    SET @RESULT=-1    
  END  
   
    
    
   
  
      
  END  
    
  
  IF(@6='Update')  
  BEGIN  
        
     
   UPDATE EmployeeAttendanceTime SET UpdatedOn=CONVERT(VARCHAR,GETDATE(),101),  
     UpdatedBy=@7,Remarks=@5,TimeInMinute=@4,  
     [Type]=CONVERT(TINYINT,@2),  
     [Date]=@3  
     WHERE  EmployeeTimeID=@8  
      SET @RESULT=2  
  END  
    
  IF(@6='Delete')  
  BEGIN  
     
   UPDATE EmployeeAttendanceTime SET Active=0  
     WHERE  EmployeeTimeID=@8     
   --DELETE FROM EmployeeAttendanceTime WHERE EmployeeTimeID=@8  
     
  END   
    
  IF(@6='Search')  
  BEGIN  
        
   SELECT EmployeeTimeID,EmployeeID,[Date],TimeInMinute,Remarks,[Type]=  
     CASE Type  
  
     WHEN '1' THEN 'Short'  
              WHEN '2' THEN 'Stratch'  
              WHEN '3' THEN 'Punch-In Earlier'
              End  
  
    FROM EmployeeAttendanceTime  
     WHERE EmployeeID=@1 AND Active=1  
       
     SET @RESULT=0  
     
  END    
  ---CODE ADDED BY ATMA FOR SHIFT-WISE ATTENDANCE STATUS UPDATE
  IF(@6<>'Search')
   BEGIN
		EXEC USP_Update_AttendanceStatus @1,@3,@3
   END
  -------------------------------------------------------------  
        END TRY  
        BEGIN CATCH  
     
    SELECT 'ERROR MESSAGE: '+ ERROR_MESSAGE()  
                   
        END CATCH  
        RETURN @RESULT    
END
GO
/****** Object:  StoredProcedure [dbo].[USP_eExitGetResignationDetails]    Script Date: 08/08/2012 21:51:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                              
-- Author:  Nasim          
-- Create date: 16 Jan 2012        
-- Description: Get resignation Details        
-- =============================================                              
ALTER PROCEDURE [dbo].[USP_eExitGetResignationDetails]-- '101062'         
--declare          
@1 varchar(20) --EmployeeID         
        
AS                          
BEGIN          
SET NOCOUNT ON;            
        
Declare @result int      
,@access varchar(10)      
          
--set @1='101122'          
--set @2='101166'       
      
--select * from ResignationStatusMaster      
      
if exists(select resignationID from EmployeeResignation WHERE Active = 1 and EmployeeID=@1 and ResignationStatusID in (1,2,4))      
Begin      
 set @access='false'      
End      
else      
Begin      
 set @access='true'      
End      
         
SELECT     vEM.EmployeeID, vEM.Name, CONVERT(varchar, vEM.DOJ, 101) AS DOJ, CONVERT(varchar, ER.ResignationDate, 101) AS ResignationDate, ISNULL(CONVERT(varchar, ER.ResignationRevokeDate, 101),'') AS ResignationRevokeDate,      
                      ER.ResignationDetails, vEMU.Name AS EnteredBy, ER.ResignationID, ResignationStatusMaster.resignationStatus AS status, @access AS Access,     
                      CONVERT(varchar, ER.LastDayWorked, 101) AS LastDayWorked, (CASE WHEN ER.ResignationStatusID IN (1, 2, 4) THEN CAST(1 AS bit)     
                      ELSE CAST(0 AS bit) END) AS AccessRevoke, dbo.App_GetResignationComment(ER.ResignationID) AS Comment, RRM.Reason, ER.ReasonDetails,     
                      CONVERT(varchar, ER.LastDayWorkedByPolicy, 101) as LastDayWorkedByPolicy    
FROM         VW_EmployeeDetails AS vEM INNER JOIN    
                      EmployeeResignation AS ER ON vEM.EmployeeID = ER.EmployeeID INNER JOIN    
                      VW_EmployeeDetails AS vEMU ON ER.EnteredBy = vEMU.EmployeeID INNER JOIN    
                      ResignationStatusMaster ON ER.ResignationStatusID = ResignationStatusMaster.resignationStatusID INNER JOIN    
                      resignationReasonMaster AS RRM ON ER.ReasonID = RRM.ReasonID    
WHERE     (ER.Active = 1)  and ER.EmployeeID=@1      
        
            
END
GO
/****** Object:  StoredProcedure [dbo].[USP_EDB_insertLeaveDetailsWithApproved]    Script Date: 08/08/2012 21:51:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                              
-- Author:  Nasim                                              
-- Create date: <JAN 2011>                                              
-- Description: <Inserting Employee Leave Details (Leavedetails,LeaveSummary)>                                              
-- =============================================                                           
                                          
--@1=EmployeeID                                          
--@2=sdate                                          
--@3=edate                                          
--@4=leavetypeID                                          
--@5=leaveduration                                          
--@6=[APPLIEDBY]                                          
--@7=[DATEAPPLIED]                                          
--@8=Reason                                          
ALTER PROCEDURE [dbo].[USP_EDB_insertLeaveDetailsWithApproved]                                             
(                                             
 @1 varchar(20),--                                             
 @2 varchar(20),--                                            
 @3 varchar(20), --                                            
 @4 varchar(20),--                                             
 @5 varchar(20),--                                            
 @6 varchar(20), --                                            
 @7 varchar(8000), --                                            
 @8 varchar(200)                                            
)                                            
AS                                              
BEGIN                                              
--set   @1='101062'                                            
--set   @2='1/20/2011'                                            
--set   @3='1/20/2011'                                            
--set   @4='18'                                          
--set   @5='1'                                           
--set   @6='101062'                                          
--set   @7='1/20/2011'                                            
--set  @8 ='dfdsfd'                                            
                                            
                                            
declare @LeaveSummaryID varchar(20),@LEAVEID VARCHAR(20),@year int   ,@INTERRORCODE INT                                          
                                          
select @year=datepart(year,@2)                                         
 ------------------------BEGIN TRANSACTION---------------------                                  
 BEGIN TRAN                                        
  -- --------------------INSERITNG LEAVE SUMMARY -----------------------------                                           
IF  NOT EXISTS( SELECT LEAVEID FROM DBO.LEAVEDETAILS                                      
     WHERE EMPLOYEEID=@1 AND (DATEAPPLIED between cast(@2 as datetime) and cast(@3+' 11:59 PM' as datetime))                                
       and leaveStatusID in(1,12,16)                                    
                               
      --(select  Convert(smalldatetime,string) from dbo.split(@7,','))                                            
      )                                            
 BEGIN                                       
             
   DECLARE @StartDate1 datetime,@StartDate2 Datetime,@EndDate1 datetime,@EndDate2 datetime, @LeaveBalance float                
   ,@LeaveDuration1 float,@LeaveDuration2 float ,@isLWP bit              
   SET @isLWP =0             
   IF OBJECT_ID('tempdb..#TempLeaveDetails','u') IS NOT NULL                          
   BEGIN  DROP TABLE #TempLeaveDetails END                          
   CREATE TABLE #TempLeaveDetails                          
   ( StartDate datetime,EndDate datetime,LeaveTypeId int,LeaveDuration varchar(50))                    
                  
   SET @LeaveBalance=CAST(dbo.GetEmpLeaveBalance(@1,@4,@YEAR) as float)                
                  
     IF( CAST(@5 as float) <= @LeaveBalance)                
      BEGIN                
       SET @StartDate1=cast(@2 as datetime)                
       SET @EndDate1=cast(@3+' 11:59 PM' as datetime)                
       SET @LeaveDuration1=@5                
      END                
      ELSE                
     BEGIN                
       
       
     IF(@LeaveBalance >= 1)            
    BEGIN  
     SET @StartDate1=cast(@2 as datetime)            
     SET @EndDate1=DATEADD(day,@LeaveBalance-1,CAST(@2+' 11:59 PM' as datetime))            
     SET @LeaveDuration1=@LeaveBalance-1       
      IF(@LeaveBalance < 2)           
      BEGIN  
      SET @EndDate1=CAST(@2+' 11:59 PM' as datetime)            
      SET @LeaveDuration1=1      
      END  
    END   
                 
   SET @StartDate2=ISNULL(DATEADD(day,1,@EndDate1),cast(@2 as datetime))                
   SET @EndDate2=cast(@3+' 11:59 PM' as datetime)                
   SET @LeaveDuration2=(@5-ISNULL(@LeaveDuration1,0))                
     END                
                   
    IF(@StartDate1 IS NOT NULL AND @EndDate1 IS NOT NULL )                
    BEGIN                
   Insert into #TempLeaveDetails(StartDate,EndDate,LeaveTypeId,LeaveDuration) SELECT @StartDate1,@EndDate1,@4,(CASE WHEN  @LeaveDuration1  >=1 THEN 1 ELSE @LeaveDuration1 END )                 
    END                
    IF(@StartDate2 IS NOT NULL AND @EndDate2 IS NOT NULL)                
    BEGIN                
   Insert into #TempLeaveDetails(StartDate,EndDate,LeaveTypeId,LeaveDuration) SELECT @StartDate2,@EndDate2,32,(CASE WHEN  @LeaveDuration2  >=1 THEN 1 ELSE @LeaveDuration2 END )                 
   SET @isLWP =1            
    END             
              
          
                  
 ---------------------------------------------------------------------------------------                   
  DECLARE @StartDate datetime,@EndDate Datetime,@LeaveTypeId int,@LeaveDuration varchar(50)                
                  
  DECLARE @LeaveInsert CURSOR                            
     SET @LeaveInsert = CURSOR FOR                            
    SELECT StartDate,EndDate,LeaveTypeId,LeaveDuration FROM #TempLeaveDetails                        
     OPEN @LeaveInsert                            
     FETCH NEXT                            
     FROM @LeaveInsert INTO @StartDate,@EndDate ,@LeaveTypeId  ,@LeaveDuration                         
     WHILE @@FETCH_STATUS = 0                            
       BEGIN                   
                       
                      
      INSERT INTO [LEAVESUMMARY]                                                
   ([APPLIEDFOR],[APPLIEDBY],[APPLIEDON],[STARTDATE],[ENDDATE],[LEAVETYPEID],[REASON],[STATUS])                                                
    VALUES(@1,@6,GETDATE(),@StartDate,@EndDate,@LeaveTypeId,@8,'1')                                              
set @LeaveSummaryID=@@IDENTITY                                    
 ------------------------------IF ERROR OCCURS--------------------                                  
  SELECT @INTERRORCODE = @@ERROR                                  
  IF (@INTERRORCODE <> 0) GOTO PROBLEM                                  
   -----IF NO PROBLEM IN ABOVE QUERY--------INSERTING LEAVE DETAIL-------------------------------                                            
                                              
                           
                      
                      
      INSERT INTO [LEAVEDETAILS]                                                
   (                                              
  [EMPLOYEEID]                                               
    ,[LEAVEDURATION]                                                
    ,[DATEAPPLIED]                                                
    ,[LEAVESTATUSID]                                                
    ,[LEAVESUMMARYID]                                              
   )                             
   SELECT @1,@LeaveDuration,DATE,12,@LeaveSummaryID FROM DBO.USP_EDB_GetDatesFromTwoDates(Convert(varchar(20),@StartDate,101),CONVERT(VARCHAR(20),@EndDate,101))                             
   SET @LEAVEID=@@IDENTITY                   
                      
------------------------INSERT LEAVE Transaction --------------------------                        
               
     DECLARE @GETEMPID CURSOR                            
     SET @GETEMPID = CURSOR FOR                            
  SELECT   leaveID from leavedetails  where leaveSummaryID=@LEAVESUMMARYID                            
     OPEN @GETEMPID                            
   FETCH NEXT                            
     FROM @GETEMPID INTO @leaveID                            
     WHILE @@FETCH_STATUS = 0                            
       BEGIN                          
       exec USP_EDB_insertLeaveTransaction  @LEAVEID,12,'0',@6,'1','0',@isLWP --add For Leave Transaction                            
     FETCH NEXT                            
     FROM @GETEMPID INTO @leaveID                            
     END                            
     CLOSE @GETEMPID                            
     DEALLOCATE @GETEMPID                         
                            
                           
                        
                      
                      
       FETCH NEXT                            
     FROM @LeaveInsert INTO @StartDate,@EndDate ,@LeaveTypeId  ,@LeaveDuration                              
     END               
     CLOSE @LeaveInsert                            
     DEALLOCATE @LeaveInsert                     
                                          
 -----------------------------------------------------------------------------------------------                                           
     SELECT @INTERRORCODE = @@ERROR                                  
  IF (@INTERRORCODE <> 0) GOTO PROBLEM                                    
                      
exec [dbo].[USP_EDB_UpdateEmpLeaveBalance] @1,@LeaveTypeId                      
                      
      exec [dbo].[USP_AlertMailLeaveStatus]                                       
      -----------------CODE ADDED BY ATMA-FOR SHIFT-WISE ATTENDANCE STATUS--------------------
      EXEC USP_Update_AttendanceStatus @1,@StartDate,@EndDate
      --------------------------------------------------------------------
      
   SELECT @INTERRORCODE = @@ERROR                                  
  IF (@INTERRORCODE <> 0) GOTO PROBLEM                                       
   -------------------------------------------------------------------------                                          
   COMMIT TRAN                                     
                                    
 -----------------------------NO PROBLEM CASE--------------------------            
            
                                 
   RETURN 2                                  
 ----------------------------PROBLEM MESSAGE-------------                                      
  PROBLEM:                                   
      IF (@INTERRORCODE <> 0)                                   
     BEGIN                                  
      RETURN -1                                  
      ROLLBACK TRAN                                  
     END                                  
 END                                  
  ELSE                                   
   BEGIN                                  
   RETURN 0                                  
   END                                  
END
GO
/****** Object:  StoredProcedure [dbo].[USP_EDB_ChangeLeaveStatusBySummary]    Script Date: 08/08/2012 21:51:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                        
-- Author:  < Pankaj Yadav>                                        
-- Create date: <>                                        
-- Description: <>                                        
-- =============================================                                        
ALTER PROCEDURE [dbo].[USP_EDB_ChangeLeaveStatusBySummary]   
--declare                                        
@1 varchar(20),  -- Leave Summary ID                                      
@2 varchar(20),  --Updated BY                                  
@3 varchar(20),  --LeaveStatusID                                  
@4 varchar(20),  --EmployeeID                                  
@5 varchar(20),  --LeaveTypeID                                  
@6 varchar(50)=null --Prev status  ID          
                                    
AS                                        
BEGIN                                        
--  
--set @1=41  
--set @1=101062  
--set @1=12  
--set @1=101167  
--set @1=19  
--set @1=1  
  
  
  
  
  
  
  
 SET NOCOUNT ON;                                     
declare @prevStatus varchar(50),@LeaveId varchar(50)               
-- 2 variables declared by atma
DECLARE @Date DATETIME,@EmpID VARCHAR(50)          
-------------
 DECLARE  @tempLeaveId table (LeaveId varchar(50))                  
  
    INSERT INTO @tempLeaveId   
 SELECT  LeaveId FROM leaveDetails WHERE   LeaveSummaryId= @1          
          
WHILE (SELECT Count(*) From @tempLeaveId) > 0                  
 BEGIN                  
   SELECT Top 1 @LeaveId = LeaveId  From @tempLeaveId     
       
 IF((SELECT LEAVESTATUSID FROM LeaveDetails WHERE LeaveId=@LeaveId ) NOT IN (13,15))    
  BEGIN    
                  
  UPDATE [dbo].[LeaveDetails]                                    
    SET [LeaveStatusID] =@3                                    
    ,[LastUpdated] = getdate()                                    
    ,[UpdatedBy] = @2       
    ,[LeaveProcessedBy]=@2      
  ,LeaveProcessedOn=getdate()                                   
  WHERE LeaveID=@LeaveId    
                                
    exec [dbo].[USP_EDB_UpdateEmpLeaveBalance] @4,@5                          
    exec USP_EDB_insertLeaveTransaction  @LeaveId,@3,0,@2,0,1 --add For Leave Transaction                
    ---------------- CODE ADDED BY ATMA FOR SHIFT-WISE ATTENDANCE STATUS ---------------
    SELECT @Date=DateApplied,@EmpID=EmployeeID FROM [LeaveDetails]
    WHERE LeaveID=@LeaveId  
    EXEC USP_Update_AttendanceStatus @EmpID, @Date,@Date 
    -----------------------------------------------------------
  END    
    
    DELETE @tempLeaveId Where LeaveId = @LeaveId                  
 END             
          
--select 2               
RETURN '2'                
End        
      
      
      
--select * from [LeaveDetails]    
--    
--select * from LeaveStatusMaster
GO
/****** Object:  StoredProcedure [dbo].[USP_EDB_ChangeLeaveStatus]    Script Date: 08/08/2012 21:51:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                              
-- Author:  Nasim                              
-- Create date: <>                              
-- Description: <>                              
-- =============================================                              
--@1=Leave ID                          
--@2=Updated BY                          
--@3=LeaveStatusID                          
--@4=EmployeeID                          
--@5=LeaveTypeID                          
--@6=Duration                          
ALTER PROCEDURE [dbo].[USP_EDB_ChangeLeaveStatus]                              
@1 varchar(20),                          
@2 varchar(20),                          
@3 varchar(20),                          
@4 varchar(20),                          
@5 varchar(20),                          
@6 varchar(20),  
@7 varchar(50)=null--Prev status  
                          
AS                              
BEGIN                              
 SET NOCOUNT ON;                           
                      
declare @prevStatus varchar(50)    
DECLARE @Date DATETIME
DECLARE @EmpID VARCHAR(10)                  
---------------------Updating Details in LeaveDetails---------------------------------                  
            
  
  
  
if exists(select leaveID from leaveDetails where leaveID=@1 and leavestatusID=@7)  
 Begin  
UPDATE [dbo].[LeaveDetails]                          
   SET [LeaveStatusID] =@3                          
      ,[LastUpdated] = getdate()                          
      ,[UpdatedBy] = @2   
   ,[LeaveProcessedBy]=@2  
   ,LeaveProcessedOn=getdate()                          
 WHERE LeaveID=@1                       
  
exec [dbo].[USP_EDB_UpdateEmpLeaveBalance] @4,@5                
exec USP_EDB_insertLeaveTransaction  @1,@3,'0',@2 --add For Leave Transaction   
-- CODE ADDED BY ATMA FOR SHIFT CHANGE.
SELECT @Date=DateApplied,@EmpID=EmployeeID FROM [LeaveDetails]  
    WHERE LeaveID=@1 
    EXEC USP_Update_AttendanceStatus @EmpID, @Date,@Date  
   
return '2'      
 End  
else  
Begin  
return '3'      
End  
       
                             
        
                         
end
GO
/****** Object:  StoredProcedure [dbo].[usp_AlertHRLeaveStatement_ExcelMail]    Script Date: 08/08/2012 21:51:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery2.sql|7|0|C:\Documents and Settings\300051\Local Settings\Temp\~vs64.sql
                                         
ALTER PROCEDURE [dbo].[usp_AlertHRLeaveStatement_ExcelMail]-- '07/05/2012','08/05/2012','300051'  
 @1 varchar(50),--Start Date                                                          
 @2 varchar(50),--End Date                                                                                                                                                                                 
 @6 varchar(50)--UserID                              
               
AS                
  
                                                     
DECLARE @CID  INT 
DECLARE @3 VARCHAR(2)


DECLARE C1 CURSOR 
FOR SELECT DISTINCT COMPANYID FROM companymaster where Active=1
OPEN C1

FETCH NEXT FROM C1 INTO @CID
WHILE(@@FETCH_STATUS=0)
BEGIN
SET @3=CAST(@CID AS VARCHAR(2))                     

                                                                                                                                                          
Exec usp_AlertHRLeaveStatement_Excel @1, @2,@3,@6 
FETCH NEXT FROM C1 INTO @CID
END
CLOSE C1
DEALLOCATE C1
GO
/****** Object:  StoredProcedure [dbo].[usp_AlertDRLeaveStatement_ExcelMail]    Script Date: 08/08/2012 21:51:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[usp_AlertDRLeaveStatement_ExcelMail]-- '07/05/2012','07/10/2012'
	-- Add the parameters for the stored procedure here
	@1 varchar(50),--Start Date                                                          
	@2 varchar(50)--End Date                                                                                   

AS
BEGIN

	SET NOCOUNT ON;

	        
        BEGIN TRY
			DECLARE @CID  VARCHAR(10) 
			DECLARE @4 VARCHAR(10)
			
			DECLARE C10 CURSOR 
			FOR SELECT DISTINCT HeadId FROM EmployeeReportingLead WHERE Active=1 AND ReportingType='Direct'
			OPEN C10
			FETCH NEXT FROM C10 INTO @CID
			WHILE(@@FETCH_STATUS=0)
			BEGIN
			SET @4=CAST(@CID AS VARCHAR(10))                                                               
				EXEC usp_AlertDRLeaveStatement_Excel @1, @2,@4 
			FETCH NEXT FROM C10 INTO @CID
			END
			CLOSE C10
			DEALLOCATE C10
			
        END TRY
        BEGIN CATCH
			
			SELECT 'ERROR MESSAGE '+ ERROR_MESSAGE()
                 
        END CATCH
END
GO
