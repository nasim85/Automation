                            
           
                            
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
--Alter PROCEDURE [dbo].[USP_EDB_insertLeaveDetailsWithApproved]                             
--(                             
-- @1 varchar(20),--                             
-- @2 varchar(20),--                            
-- @3 varchar(20), --                            
-- @4 varchar(20),--                             
-- @5 varchar(20),--                            
-- @6 varchar(20), --                            
-- @7 varchar(8000), --                            
--@8 varchar(200)                            
--)                            
--AS                              
BEGIN                         


declare
 @1 varchar(20),
 @2 varchar(20),
 @3 varchar(20),
 @4 varchar(20),
 @5 varchar(20),
 @6 varchar(20),
 @7 varchar(8000), 
 @8 varchar(200)                            

     
set   @1='101062'                            
set   @2='1/20/2012'                            
set   @3='1/25/2011'                            
set   @4='17'                          
set   @5='1'                           
set   @6='101062'                          
set   @7='1/20/2012,1/21/2012,1/22/2012,1/23/2012,1/24/2012,1/25/2012'                            
set  @8 ='dfdsfd'                            
                            
                            
declare @LeaveSummaryID varchar(20),@LEAVEID VARCHAR(20),@year int   ,@INTERRORCODE INT                          
                          
select @year=datepart(year,@2)                         
 ------------------------BEGIN TRANSACTION---------------------                  
-- BEGIN TRAN                        
  -- --------------------INSERITNG LEAVE SUMMARY -----------------------------                           
--IF  NOT EXISTS( SELECT LEAVEID FROM DBO.LEAVEDETAILS                      
--     WHERE EMPLOYEEID=@1 AND (DATEAPPLIED between cast(@2 as datetime) and cast(@3+' 11:59:59 PM' as datetime))                
--       and leaveStatusID in(1,12,16)                    
--      --(select  Convert(smalldatetime,string) from dbo.split(@7,','))                            
--      )                            
--
-- BEGIN                       
                  


--------Checking leave balance and apllied leaves-------------
declare @tblDuration table (dateApplied datetime, duration decimal(10,2))
declare @tblLWP table (dateApplied datetime, duration decimal(10,2))
declare @balance decimal(18,2),@leaveDuration decimal(10,2)

select @balance= [dbo].[GetEmpLeaveBalance](@1,@4,@year)

insert into @tblDuration(dateApplied,duration)
select Convert(smalldatetime,string) , @5 from dbo.split(@7,',')

select @leaveDuration=sum(duration) from @tblDuration

if(@balance >=@leaveDuration)
	Begin


	End
else
	Begin
				

	END
              
                         
-- INSERT INTO [LEAVESUMMARY]                            
--            ([AppliedFor]                          
--           ,[AppliedBy]                          
--           ,[AppliedOn]                          
--           ,[StartDate]                          
--           ,[EndDate]                          
--           ,[LeaveTypeID]                          
--           ,[Reason]                          
--           ,[Status]                                
--     )                            
--   VALUES                            

  select @1,@6,GETDATE(),@2,@3,@4,@8,'1'

set @LeaveSummaryID=@@IDENTITY                    
 ------------------------------IF ERROR OCCURS--------------------                  
--  SELECT @INTERRORCODE = @@ERROR                  
--  IF (@INTERRORCODE <> 0) GOTO PROBLEM                  
   -----IF NO PROBLEM IN ABOVE QUERY--------INSERTING LEAVE DETAIL-------------------------------                            
                              
--  INSERT INTO [LEAVEDETAILS]                            
--      (                          
--    [EMPLOYEEID]                           
--      ,[LEAVEDURATION]                            
--      ,[DATEAPPLIED]                            
--      ,[LEAVESTATUSID]                            
--      ,[LEAVESUMMARYID]               
--      )                            
      SELECT @1,@5,STRING,12,@LeaveSummaryID FROM DBO.SPLIT(@7,',')                     
         SET @LEAVEID = SCOPE_IDENTITY()            
      
      
------------------------INSERT LEAVE Transaction --------------------------        
             
--     DECLARE @GETEMPID CURSOR            
--     SET @GETEMPID = CURSOR FOR            
--  SELECT   leaveID from leavedetails  where leaveSummaryID=@LEAVESUMMARYID            
--     OPEN @GETEMPID            
--     FETCH NEXT            
--     FROM @GETEMPID INTO @leaveID            
--     WHILE @@FETCH_STATUS = 0            
--       BEGIN          
--       exec USP_EDB_insertLeaveTransaction  @LEAVEID,12,'0',@6,'1' --add For Leave Transaction            
--     FETCH NEXT            
--     FROM @GETEMPID INTO @leaveID            
--     END            
--     CLOSE @GETEMPID            
--     DEALLOCATE @GETEMPID         
            
           
                          
-- -----------------------------------------------------------------------------------------------                           
--     SELECT @INTERRORCODE = @@ERROR                  
--  IF (@INTERRORCODE <> 0) GOTO PROBLEM                    
--      
--	exec [dbo].[USP_EDB_UpdateEmpLeaveBalance] @1,@4      
--                          
--   SELECT @INTERRORCODE = @@ERROR                  
--  IF (@INTERRORCODE <> 0) GOTO PROBLEM                       
--   -------------------------------------------------------------------------                          
--   COMMIT TRAN                     
--                    
-- -----------------------------NO PROBLEM CASE--------------------------                  
--   RETURN 2                  
-- ----------------------------PROBLEM MESSAGE-------------                      
--  PROBLEM:                   
--      IF (@INTERRORCODE <> 0)                   
--     BEGIN                  
--      RETURN -1                  
--      ROLLBACK TRAN                  
--     END                  
-- END                  
--  ELSE                   
--   BEGIN                  
--   RETURN 0                  
--   END                  
END 