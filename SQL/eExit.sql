select * from alertCategoryMaster
SELECT *FROM  EmployementStatus
SELECT * FROM LeaveStatusMaster
SELECT * FROM ResignationStatusMaster

select * from   EmployeeMaster  where EmployeementStatusID=2 and AttritionDate='8/6/2012'
select * from EmployeeResignation where EmployeeID in(select EmployeeID from   EmployeeMaster  where EmployeementStatusID=2 and AttritionDate='8/6/2012')
SELECT *FROM   VW_EmployeeDetailsAll where  EmployeeID in(300555,300563,300605,300630)
select * from employeeAttendance where employeeID=101166 and IOStatus='Entry' order by IOdate desc
select * from employeeAttendanceMissing  where employeeID=101166
SELECT * FROM EmployeeAbsenceReasons  where employeeID=101166
select * from leaveDetails  where employeeID=101166 --and leaveStatusID not in(13,14,15)  --not a calceled leaves
select * from leaveSummary where AppliedFor=101166 
select * from employeeNotification where alertCategory=1 and Status=4 and  EmployeeID in(300555,300563,300605,300630) order by ID desc
SELECT * FROM EmployeeResignation
select * from EmployeeJobDetailsHistory where EmployeeID in(300555,300563,300605,300630)

sp_helptext USP_InsertAbscondingNotification
sp_helptext USP_AlertEmployeeAbsconding
sp_helptext USP_EDB_GetEmployeeAbsenceReasons
sp_helptext USP_EDB_editJobDetails
sp_helptext USP_eExitGetResignation
sp_helptext USP_eExitUpdateResignationStatus
sp_helptext USP_eExitGetResignationDetails

--update EmployeeNotification set Notification=0 where ID in(56303)

--Delete from employeeNotification  where employeeID=in(300631,300632,300633,300634,300635)
--Delete from EmployeeAbsenceReasons  where employeeID=101166
--Update leaveDetails set LeaveStatusID=13 where employeeID=101166 and DateApplied >='2/1/2012'
--Delete from leaveSummary where AppliedFor=101166 

--update employeeNotification set createdDate='1/30/2012 4:00:00 PM' where employeeID=101166 and alertCategory=4
--update employeeMaster set employeeMentStatusID=1 where employeeID=101166




--INSERT INTO EmployeeAttendance
--                      (EmployeeID, HolderNo, HolderName, IODate, IOTime, IOStatus, CompanyID)
--SELECT     EmployeeID,'',name,'2/6/2012','14:30:00','Entry',2
--FROM         VW_EmployeeDetails


--------------------------------------------------
----------- Delete Employee ----------------------
--------------------------------------------------
--select * from employeemaster where EmployeeID=300643

--delete from employeemaster where EmployeeID=300643
--delete from login where EmployeeID=300643
--delete from EmployeeNotification where employeeID=300643




SELECT TOP (50) mailitem_id, profile_id, recipients, copy_recipients, subject, body, send_request_date, send_request_user, 
                      sent_account_id, sent_status, sent_date, last_mod_date, last_mod_user
FROM msdb.dbo.sysmail_mailitems  WHERE (subject LIKE '%ARMS - Process Movement : Kiran   Kumari%')  ORDER BY mailitem_id DESC

