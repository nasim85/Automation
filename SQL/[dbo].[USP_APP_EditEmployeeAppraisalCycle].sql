
GO
/****** Object:  StoredProcedure [dbo].[USP_APP_EditEmployeeAppraisalCycle]    Script Date: 03/23/2012 20:05:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                        
-- Author:  Pankaj Yadav                       
-- Create date: 23 DEC 2011                        
-- Description: Update Employee Appraisal Cycle                        
-- =============================================                        
--ALTER PROCEDURE [dbo].[USP_APP_EditEmployeeAppraisalCycle]  --'100','0','101173'                      
Declare
 @1 VARCHAR(MAX),--Employee Ids                        
 @2 VARCHAR(20),--Updated By                                
 @3 varchar(20)--Appraisal Type            
BEGIN                        

set @2='100350'
set @3='2'

        
  DECLARE @EmployeeID varchar(50)             
  DECLARE  @tempEmpList table  (EmployeeID varchar(50))                    
  
  INSERT INTO @tempEmpList 
  select employeeID from employeeMaster where employeeID in(101166,104401,104402,312363)
  
          
            
WHILE (SELECT Count(EmployeeID) From @tempEmpList) > 0                    
 BEGIN                    
  SELECT Top 1 @EmployeeID = EmployeeID  From @tempEmpList
  
  update AppraisalCycleEmployee set Active=0 where EmployeeID=@EmployeeID
                      
	  IF((SELECT COUNT(APPCycleID) FROM AppraisalCycleEmployee WHERE EmployeeID=@EmployeeID  AND AppraisalTypeID=@3 and Active=1) > 0)                   BEGIN                    
			  UPDATE AppraisalCycleEmployee                        
			   SET                         
			   [EmployeeID] = @EmployeeID            
			  , AppraisalTypeID =@3                      
			  ,LastUpdatedOn =GETDATE(),            
			   ACTIVE=1                        
			  ,LastUpdatedBy =@2 WHERE EmployeeID =@EmployeeID   AND AppraisalTypeID=@3                   
	   END                    
	ELSE                    
		BEGIN                    
	   INSERT INTO AppraisalCycleEmployee(EmployeeID,AppraisalTypeID,Active,EntryDate ,EnteredBy)                    
	   VALUES(@EmployeeID,@3, 2, GetDate(), @2)                    
	   END                    
	   DELETE @tempEmpList Where EmployeeID = @EmployeeID                    
 END        
--RETURN 1                  
End
