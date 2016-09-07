set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



  
  
-- =============================================  
-- Author:  Nasim  
-- Create date: 29 april 2011  
-- Description: Getting Chat ID  
-- =============================================  
ALTER PROCEDURE [dbo].[SL_GetChatID] -- '1234'
 @1 varchar(50) --Access Key  
   
   
   
   
AS  
BEGIN  
  
declare @chatID varchar(50),@chatName varchar(100) ,@userCount varchar(50) 
  
  
SELECT   @chatID=ChatID, @chatName=ChatName+' ('+left(startTime,20)+' TO '+ left(EndTime,20) +')' ,@userCount=usercount 
FROM         SL_Chat  
where ChatKey=@1 and StartTime <=getdate() and endTime >=getdate()  


set @chatName=@chatName+' : '+(select top 1 owner from SL_chatOwner where chatID=@chatID)

  
if(@chatID is null )  
Begin  
 set @chatID='0'  
End  
  
if (@chatName is null)  
Begin  
 set @chatName=''  
End  
  
select @chatID,@chatName ,@userCount 
     
  
END  
  
  


