--select * from AlertCategoryMaster
--select * from employeeMaster where employeeID=isnull(@empID,employeeID)
--select * from employeeNotification where alertCategory in (6,7)


sp_helptext [USP_EP_AlertAProcRequestsReminder]
sp_helptext [USP_EP_AlertAProcNewRequests]
sp_helptext USP_EP_GetRequestList
sp_helptext USP_EP_InsertRequestAttachment
sp_helptext USP_EP_InsertRequest
sp_helptext USP_EP_EditRequest
sp_helptext USP_EP_EditRequestBudget
sp_helptext USP_EP_RequestAlertInsert
sp_helptext USP_EP_GetRequestDetailsByRequestId
sp_helptext USP_EmployeeAttendanceReport
sp_helptext 

SELECT *  FROM EP_Request where requestID in(195)
SELECT *  FROM EP_RequestComment where requestID in(143,144)
SELECT *  FROM EP_RequestAttachment where requestID=195
SELECT *  FROM EP_RequestAlert where active=1 and requestID=100
SELECT *  FROM EP_StatusMaster
SELECT *  FROM EP_RequestHistory where requestID in(144) order by EntryDate
SELECT *  FROM EP_Admin where employeeID=100350


--update EP_Request set StatusID=8 where StatusID =12 and active=1
--update EP_Admin set active=0 where employeeID=100350
--Update EP_RequestAttachment set active=0 where requestID=195

GO



--delete from EP_RequestAttachment where enteredBy=100350
--delete from EP_RequestHistory where enteredBy=100350
--delete from EP_RequestComment where EnteredBy=100350



SELECT     TOP (20) mailitem_id, profile_id, recipients, copy_recipients, subject, body, send_request_date, send_request_user, 
                      sent_account_id, sent_status, sent_date, last_mod_date, last_mod_user
FROM         msdb.dbo.sysmail_mailitems  WHERE     (subject LIKE '%aProc%') ORDER BY mailitem_id DESC


--UPDATE    EP_StatusMaster SET  RemainderDuration = 1
--UPDATE EP_RequestAlert set LastRemainder='2/6/2012 4:00 pm' where active=1

