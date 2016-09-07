-- =============================================                                                    
-- Author:  Pankaj                                            
-- Create date: 11 aug 2011                                            
-- Description: Update Request Budget                                      
-- =============================================                                                    
Alter PROCEDURE [dbo].[USP_EP_EditRequestBudget] --105,5,'9.0','False',101173                                       
 @1 int, -- RequestID                                              
 @2 int,-- StatusID                              
 @3 varchar(50),-- Budget                                        
 @4 varchar(10),-- CorpAff                              
 @5 int --CreatedBy                                    
AS                                              
Begin                                     
   declare @comment varchar(max)                    
  ,@budgetmsg varchar(1000)                    
  ,@corpmsg varchar(1000)                        
  ,@prevBudget decimal(18,2)                   
  ,@CurrentStatusId int                  
----------------------Three Approval Change---------------------------                  
SELECT @CurrentStatusId=isnull(StatusId,0) FROM EP_Request WHERE  requestID=@1                  
IF(@4 ='True' AND @2=5)                        
 BEGIN       
  IF(@CurrentStatusId in (17)) --Pending For Super User               
    BEGIN                  
       SET @2 =10 --Contract/Aggrement Pending                   
    END                
  ELSE IF(@CurrentStatusId in (4,6)) --Validated By Finance  & Rejected               
    BEGIN                  
       SET @2 =14 --Approval 1                
    END                  
  ELSE IF(@CurrentStatusId =14 AND @5 NOT in (SELECT DISTINCT EnteredBy FROM   EP_RequestHistory WHERE RequestId=@1 and StatusId in (14,15)))                  
    BEGIN                  
       SET @2 =15 --Approval 2                
    END                 
  ELSE IF(@CurrentStatusId =14 )                 
  BEGIN                
       SET @2 =-1 --Already Exists                
  END                  
  ELSE IF(@4 ='True' AND @2=5   AND @5 NOT in (SELECT DISTINCT EnteredBy FROM   EP_RequestHistory WHERE RequestId=@1 and StatusId in (14,15)))                    
  BEGIN                      
      --SET @2 =10 --Contract/Aggrement Pending                        
  IF(CONVERT(float,@3) >25000)      
    BEGIN      
     SET @2 =17 --Pending For Super User      
    END      
    ELSE      
    BEGIN      
     SET @2 =10 --Contract/Aggrement Pending                     
    END      
  END                
  ELSE IF(@4 ='True' AND @2=5)                    
  BEGIN                      
     SET @2 =-1 --Already Approved                  
  END                
END                   
ELSE IF(@2=5)                        
 BEGIN          
 IF(@CurrentStatusId in (17)) --Pending For Super User               
    BEGIN                  
       SET @2 =8 --PO Pending                 
    END                 
  ELSE IF(@CurrentStatusId in (4,6)) --Validated By Finance                 
    BEGIN                  
       SET @2 =14 --Approval 1                
    END                  
  ELSE IF(@CurrentStatusId =14 AND @5 NOT in (SELECT DISTINCT EnteredBy FROM   EP_RequestHistory WHERE RequestId=@1 and StatusId in (14,15)))                  
    BEGIN                  
       SET @2 =15 --Approval 2                
    END                 
  ELSE IF(@CurrentStatusId =14 )                 
  BEGIN                
       SET @2 =-1 --Already Approved                
  END                  
  ELSE IF(@2=5  AND @5 NOT in (SELECT DISTINCT EnteredBy FROM   EP_RequestHistory WHERE RequestId=@1 and StatusId in (14,15)))                    
  BEGIN        
   IF(CONVERT(float,@3) >25000)      
    BEGIN      
     SET @2 =17 --Pending For Super User      
    END      
    ELSE      
    BEGIN      
     SET @2 =8 --PO Pending                          
    END      
  END                
  ELSE IF(@2=5)                
  BEGIN                      
      SET @2 =-1  --Already Approved                    
  END                
END       
      
      
      
                     
IF(@2 <> '-1')                  
BEGIN                  
   SELECT @prevBudget=isnull(approxBudget,0) FROM EP_Request WHERE  requestID=@1                       
   IF  (@prevBudget <> cast(@3 as decimal(18,2)))                    
    BEGIN                              
    SET @budgetmsg ='Budget of Rs. '+@3 + ' has been updated.'                              
    END                              
  IF ((SELECT COUNT(requestID) FROM EP_Request WHERE  requestID=@1 AND statusID<>@2 )>0)                              
   BEGIN                              
  set @comment=(SELECT 'Request Status has been changed to " '+ status +' ".' FROM EP_StatusMaster where statusID=@2)                                    
   END                              
 UPDATE  EP_Request SET  ApproxBudget=@3,CorporateAffairs=@4, StatusID=@2,UpdatedBy=@5,LastUpdatedOn=GetDate() WHERE  requestID=@1                                      
 exec USP_EP_RequestAlertInsert    @1,@2, @5           
 --EXEC [USP_EP_AlertAProcNewRequests] @1          
          
--IF( @2 in (6,7,13)) -- For  Remainder Inactive          
--BEGIN          
--  UPDATE EP_RequestAlert SET Active=0 WHERE RequestId=@1          
--END           
--          
--          
--IF( @2 in (6)) -- For  Second Approval Rejected          
--BEGIN          
--  UPDATE EP_RequestHistory SET StatusID=0 WHERE RequestId=@1 and StatusID in (14,15)          
--END           
--               
--  IF(@comment IS NOT NULL)                              
--  BEGIN                              
-- exec USP_EP_insertRequestHistory @1 ,@5 ,@comment ,@2                              
--  END                              
--                            
-- IF(@budgetmsg IS NOT NULL)                              
-- BEGIN                           
-- exec USP_EP_insertRequestHistory @1 ,@5 ,@budgetmsg  ,@2                             
-- END          
          
                              
 RETURN 1                      
END                  
ELSE                  
BEGIN                  
 RETURN -1                                 
END                           
END         
  
  
--select * from EP_Request WHERE RequestId=91    
--  
--select * from EP_RequestAlert WHERE RequestId=91  --435  
--  
--select * from EP_RequestHistory WHERE RequestId=91 AND EnteredBy=100400