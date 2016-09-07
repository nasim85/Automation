SELECT top 50
 mailitem_id, profile_id, recipients, copy_recipients, subject, body, send_request_date, send_request_user,                       sent_account_id, sent_status, sent_date, last_mod_date, last_mod_user
FROM         msdb.dbo.sysmail_mailitems  
WHERE --sent_status <>1 and 

--(subject LIKE '%PHC- Downward trend identified for%')
--(subject LIKE '%Helpdesk : Reminder%')
--and sent_date >='2012-12-07' --and
--(subject LIKE '%Shift Change Notification%')   
--(subject LIKE '%ARMS- Leave Notification%')   
-- (subject LIKE '%ARMS-Update (Offer Drop)%')   
--(subject LIKE '%Appraisal%') 
--(subject LIKE '%ARMS- Attrition Update%') 
  (subject LIKE '%ARMS - Process Movement%') 
 
 --(subject LIKE '%Attendance Not Marked%')  
--(subject LIKE '%ARMS-Monthly attendance report for%') 
--and (subject LIKE '%ARMS- E. Id. of New Joiners%') 
-- and send_request_date >'12/19/2012'
 --and sent_status=2 --and mailitem_id >65034
 --recipients like'%SMittal@accretivehealth.com%'
--and MONTH(send_request_date)=9 and day(send_request_date)=20
--and send_request_User='IndiaSoft'
--and mailitem_id >78972 
ORDER BY mailitem_id desc




SELECT 
 sent_status ,COUNT(mailitem_id) as [Count]
FROM         msdb.dbo.sysmail_mailitems  
WHERE  (subject LIKE '%ARMS-Monthly attendance report for%') and sent_date >='2013-02-19'
--and mailitem_id >78972 
Group by   sent_status





SELECT 
  recipients, sent_status ,COUNT(mailitem_id) as [Count]
FROM         msdb.dbo.sysmail_mailitems  
WHERE  (subject LIKE '%Test mail%') and sent_date >='2012-12-06'
and mailitem_id >78972 
Group by   recipients, sent_status
order by recipients


--exec ResendEmailItem 120791

SELECT distinct
'exec ResendEmailItem '+cast(mailitem_id as varchar)+'; '
FROM         msdb.dbo.sysmail_mailitems  
WHERE sent_status=2 and send_request_date>='2012-12-06' and subject LIKE '%Test mail%'


--67598


SELECT top 50  mailitem_id, profile_id, recipients, copy_recipients, subject, body, send_request_date, send_request_user,                       sent_account_id, sent_status, sent_date, last_mod_date, last_mod_user
FROM         msdb.dbo.sysmail_mailitems  
--where profile_id=4-- sent_status=2 --and send_request_date>='10/31/2012' and subject <>'Database Mail Test'
--where mailitem_id =76406
ORDER BY mailitem_id DESC



select * from msdb.dbo.sysmail_log l where mailitem_id in(120791) order by l.log_id desc
select * from msdb.dbo.sysmail_profile
select * from msdb.dbo.sysmail_profileaccount where profile_id=2
select * from msdb.dbo.sysmail_account

---------------Grant permession on procesdure---------------
--Use msdb
--go
--Grant EXEC on sp_send_dbmail to [INDIA\300417]
--GO
--sp_configure 'show advanced options', 1;
--GO
--RECONFIGURE;
--GO
--sp_configure 'Database Mail XPs', 1;
--GO
--RECONFIGURE
--GO



--------------------Get modified objects---------------------------
SELECT *--'SP_HELPTEXT '+ name +char(13)+'GO'+char(13)
FROM sys.objects
WHERE type not in('f','PK') AND --name like '%US_%' and 
DATEDIFF(D,modify_date, GETDATE()) < 30
order by type, modify_date desc 

SELECT 'SP_HELPTEXT '+ name +char(13)+'GO'+char(13)
FROM sys.objects
WHERE type not in('f','PK') AND --name not like '%APP%' and 
DATEDIFF(D,modify_date, GETDATE()) < 30
order by type, modify_date desc 

-------------------------------------------



------Delete duplicate records-----
SELECT * FROM dbo.ATTENDANCE WHERE AUTOID NOT IN (SELECT MIN(AUTOID) _
	FROM dbo.ATTENDANCE GROUP BY EMPLOYEE_ID,ATTENDANCE_DATE)


---------------------------------------------------

--/****** Script for Mail count by Profile  ******/
--SELECT [profile_id]
--      ,[name]
--      ,MailCount=(select COUNT(mailitem_id) FROM msdb.dbo.sysmail_mailitems 
--      where profile_id=PF.profile_id and convert(varchar,sent_date,101)='10/01/2012')
--  FROM [msdb].[dbo].[sysmail_profile] PF


--SELECT SUBSTRING(fail.subject,1,25) AS 'Subject', 
--       fail.mailitem_id, fail.send_request_date,
--       LOG.description
--FROM msdb.dbo.sysmail_event_log LOG
--join msdb.dbo.sysmail_faileditems fail
--ON fail.mailitem_id = LOG.mailitem_id
--WHERE event_type = 'error'
--and fail.send_request_date>='8/28/2012'
-- order by mailitem_id desc;


--SELECT distinct fail.mailitem_id
--FROM msdb.dbo.sysmail_event_log LOG
--join msdb.dbo.sysmail_faileditems fail
--ON fail.mailitem_id = LOG.mailitem_id
--WHERE event_type = 'error'
--and fail.send_request_date>='8/28/2012'
-- order by mailitem_id desc;

go





--EXEC sp_attach_db @dbname = N'DEV-AFC', @filename1 = N'D:\Databases\DEV\Data\DEV-AFC.mdf', @filename2 = N'D:\Databases\DEV\Log\DEV-AFC_log.ldf'
--EXEC sp_attach_db @dbname = N'Achcalender_new', @filename1 = N'D:\Databases\DEV\Data\Achcalender_new.mdf', @filename2 = N'D:\Databases\DEV\Log\Achcalender_1_new.ldf'

--EXEC sp_attach_db @dbname = N'ARMS_Candidate', @filename1 = N'D:\Databases\DEV\Data\ARMS_Candidate_new.mdf', @filename2 = N'D:\Databases\DEV\Log\ARMS_Candidate_1_new.ldf'
--EXEC sp_attach_db @dbname = N'aTalk', @filename1 = N'D:\Databases\DEV\Data\aTalk_new.mdf', @filename2 = N'D:\Databases\DEV\Log\aTalk_1_new.ldf'
--EXEC sp_attach_db @dbname = N'DEV-IDMGT', @filename1 = N'D:\Databases\DEV\Data\DEV-IDMGT.mdf', @filename2 = N'D:\Databases\DEV\Log\DEV-IDMGT_1.ldf'
--EXEC sp_attach_db @dbname = N'DEV-MT_Dashboard', @filename1 = N'D:\Databases\DEV\Data\DEV-MT_Dashboard_new.mdf', @filename2 = N'D:\Databases\DEV\Log\DEV-MT_Dashboard_new_1.ldf'
--EXEC sp_attach_db @dbname = N'DEV-PHC', @filename1 = N'D:\Databases\DEV\Data\DEV-PHC_new.mdf', @filename2 = N'D:\Databases\DEV\Log\DEV-PHC_new_1.ldf'
--EXEC sp_attach_db @dbname = N'DEV-TL', @filename1 = N'D:\Databases\DEV\Data\DEV-TL_new.mdf', @filename2 = N'D:\Databases\DEV\Log\DEV-TL_new_1.ldf'
--EXEC sp_attach_db @dbname = N'DEV-FrontPage', @filename1 = N'D:\Databases\DEV\Data\DEV-FrontPage_new.mdf', @filename2 = N'D:\Databases\DEV\Log\FrontPage_1.ldf'
--EXEC sp_attach_db @dbname = N'IDCard', @filename1 = N'D:\Databases\DEV\Data\IDCard_new.mdf', @filename2 = N'D:\Databases\DEV\Log\IDCard_1_new.ldf'


