
GO
/****** Object:  StoredProcedure [dbo].[USP_AlertEmployeeResignation]    Script Date: 03/13/2012 16:07:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================            
-- Author:  Nasim          
-- Create date: 18 jan 2012      
-- Description: Sending alert employe resignation.  
-- =============================================            
ALTER PROCEDURE [dbo].[USP_AlertEmployeeResignation]    
AS            
BEGIN            
 SET NOCOUNT ON            
 DECLARE @htmlBody  NVARCHAR(MAX)        
  ,@empName varchar(300)          
  ,@empID varchar(50)         
  ,@mailto varchar(8000)         
  ,@mailCC varchar(8000)        
  ,@mailSubject varchar(100)        
  ,@AlertData varchar(50)     
 ,@CreatedDate Datetime    
,@statusID int    
,@alertID int       
,@alertCategoryID int       
Set @htmlBody = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">        

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
 <body>        
         ##TITTLE##
    <table cellpadding="0" cellspacing="0" class="style1">        
  <tr>        
   <td class="style2">        
       <br><br><br><br>
			##MAILDATA##
       <br><br><br><br><br><br> 
			##RGARDS##
		<br><br><br> 
        </td>        
    </tr>        
            
</table>        
                        
         
 </body>        
</html>        
                         
                                
            '            
               
          
          
          
          
          
---------------------------------------------------------------------------------------------------------------------------          
-------------------Sending Alert Employee Resignation ------------------------------------          
---------------------------------------------------------------------------------------------------------------------------          
            
 DECLARE AlertCursor CURSOR FOR             
 SELECT     ID, Employeeid, AlertData, Status ,AlertCategory 
 FROM         EmployeeNotification  
 WHERE     Notification=0 AND AlertCategory in (6,7)    
        
   OPEN AlertCursor           
 FETCH NEXT FROM AlertCursor into @alertID,@empID,@AlertData ,@statusID,@alertCategoryID  
 WHILE @@FETCH_STATUS = 0            
 BEGIN   

declare @tblMailTo table (emailID varchar(100))
declare @tblMailCc table (emailID varchar(100))
Declare @resignationDate varchar(50)  
    --,@resignationDetails varchar(max)  
	,@mailBody varchar(max)
	,@resignationStaus varchar(100)
	,@Data varchar(1000)
  
   select @resignationDate=convert(varchar,ER.resignationDate,101)
		--,@resignationDetails=ER.resignationDetails 
	FROM         EmployeeResignation AS ER 
	WHERE     (ER.ResignationID = @AlertData) AND (ER.Active = 1)

   select @resignationStaus=RSM.resignationStatus 
	FROM ResignationStatusMaster AS RSM 
	WHERE    (RSM.ResignationStatusID = @statusID) AND (RSM.Active = 1)




   SELECT @empName =  Name FROM  VW_EmployeeDetails	WHERE     (EmployeeID = @empID)

delete from @tblMailCc

 
if(@alertCategoryID=6)
	Begin

			set @Data=null
			
			set @Data='You are informed that '+@empName + '('+@empID+') has been resigned from his services on '+ @resignationDate +'.
						</br> For more details please check on ARMS.'
			
			set @mailBody=replace(@htmlBody,'##MAILDATA##',@Data)       
			set @mailBody=replace(@mailBody,'##TITTLE##','Hi Team')
			set @mailBody=replace(@mailBody,'##RGARDS##','Regards, <br>Human Resources Development<br>Accretive Health.<br> ')

			set @mailSubject='ARMS-eExit Voluntary : '+@empName        

			delete from @tblMailTo
			insert into @tblMailTo(emailID)
			select EmailID  
				from employeeMaster             
				where   (EmployeementStatusId in(1,5) AND Active=1) AND         
				( employeeID in(SELECT HeadID FROM EmployeeReportingLead WHERE (EmployeeID = @empID) AND ACTIVE=1 )
			            
				) 



			
			
	End
Else
	Begin
	

			set @Data=null
			
			set @Data='You are informed your resigned has been '+ @resignationStaus +'.
						</br> For more details please check on ARMS.'
			
			set @mailBody=replace(@htmlBody,'##MAILDATA##',@Data)       
			set @mailBody=replace(@mailBody,'##TITTLE##','Hi '+@empName)
			set @mailBody=replace(@mailBody,'##RGARDS##','Regards, <br>Human Resources Development<br>Accretive Health.<br> ')

			set @mailSubject='ARMS-eExit Voluntary : '+@empName        

			delete from @tblMailTo
			insert into @tblMailTo(emailID)
			select EmailID  
				from employeeMaster             
				where   (EmployeementStatusId in(1,5) AND Active=1) AND  EmployeeID=@empID
				

			insert into @tblMailCc(emailID)
			select EmailID  
				from employeeMaster             
				where   (EmployeementStatusId in(1,5) AND Active=1) AND         
				( employeeID in(SELECT HeadID FROM EmployeeReportingLead WHERE (EmployeeID = @empID) AND ACTIVE=1 )
			            
				) 


	
	End
 
      
			

			insert into @tblMailCc(emailID)
			SELECT     MailID
			FROM         AlertNotificationIDs
			WHERE     (AlertType = 'Resignation') AND (isCC = 1)

   
           
    set @mailto=null    
    select @mailto= isnull(@mailto+';','')+ EmailID  
    from @tblMailTo  
	group by  EmailID          

    set @mailCC=null    
    select @mailCC= isnull(@mailCC+';','')+ EmailID  
    from @tblMailCc  
	group by  EmailID             

--Print ('----------------------------------------------------------------------------------------')
--print (@mailto)
--print (@mailCC)
--print (@mailSubject)
--print (@mailBody)
--Print ('----------------------------------------------------------------------------------------')
  
              
   EXEC msdb.dbo.sp_send_dbmail  @profile_name = 'ARMS',  
    @recipients =@mailto,  
    --@recipients ='nasimuddin@accretivehealth.com',        
    @copy_recipients=@mailCC,          
    --@copy_recipients='nasimuddin@accretivehealth.com',        
    @subject =  @mailSubject,            
    @body = @mailBody,            
    @body_format = 'HTML',            
    @importance =  'HIGH' ;    
       
           
   update EmployeeNotification set Notification=1 where ID=@alertID  

  FETCH NEXT FROM AlertCursor INTO @alertID,@empID,@AlertData  ,@statusID ,@alertCategoryID  
   END            
             
   CLOSE AlertCursor            
   DEALLOCATE AlertCursor            
          
END            
            
            
            
            
            
            
            
            
          
          
          
          
          
          
          
          
         
          
          
          
          
        
        
        
        
    
    
  
  

