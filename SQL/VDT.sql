Use A2AdbVariance
go

select top 100* from Analysis order by Id desc
/*Record time and AnalysisID from this query*/
Declare @time datetime='2014-12-01 20:00:00.813'
/* Anallysisid:244, 245 */
select * from Run where StartTime>=@time order by 1 desc
select top 100 * from Results
where RunId in (select id from Run where StartTime>=@time) order by 1 desc


--Check progeress----------
--GetAnalysisProgress 549
select * from ProgressReportAH where AnalysisId in (774) and CompleteDateTime is null
select * from ProgressReport where AnalysisId in (777)  and CompleteDateTime is null

---Run the Tool
--sp_helptext LoopThroughDatabasesAH 0	--will analyze  AH environment
--sp_helptext LoopThroughDatabases 0	--will analyze  IMH environment

sp_helptext Usp_populatedbobjects
sp_helptext usp_TableChecksum
sp_helptext usp_GetTableKeyConstraintsIndexInfo

select * from  Key_ConstraintInfo where TABLE_NAME='Departments'
NotificationProfileEventLogging

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 10 *  FROM [A2AdbVariance].[dbo].[Results_030120150730]  where DatabaseName='TranBACC' and ObjectName='Departments'
SELECT TOP 10 *  FROM [A2AdbVariance].[dbo].[Results_062620140426]  where DatabaseName='TranBACC' and ObjectName='Departments'
SELECT TOP 10 *  FROM [A2AdbVariance].[dbo].[Results]  where DatabaseName='TranBACC' and ObjectName='dbo.NotificationProfileEventLogging'





--- Compare specific objects-----------
/*
exec ObjectsCompare 'dbo.usp_wklYBFUActiveMassUpdateYBFUTask', 'Tran'
exec TablesCompare 'dbo.__RefactorLog', 'Tran'
exec TablesCompare 'Payer.DefectAccountCorrespondence', 'Tran'
*/
-----Get statistics---

-----GetAnalysisStats 542----
SELECT * FROM  ObjectCountReport where AnalysisId=548	
Select * from LastVersionObjects() where  ObjectName='dbo.vwCoverageTertiaryActive'
Select distinct * from LastVersionTables()  where ObjectName='dbo.vwCoverageTertiaryActive'
Select distinct ObjectDefination from LastVersionTables()  where ObjectName='dbo.vwCoverageTertiaryActive'
Select distinct ObjectName,ObjectDefination from LastVersionTables()  where ObjectName='dbo.Departments'
Select distinct  ObjectName,TblSortbyColumnName,ObjectDefination from LastVersionTables() where ObjectName='dbo.AH_Check_Payer'

exec GetVariances '837_Charges', 'TranUCKY'

SELECT i.name 'Index Name',o.create_date
FROM sys.indexes i INNER JOIN sys.objects o ON i.name = o.name
WHERE o.is_ms_shipped = 0 AND o.type IN ('UQ')    
--    AND o.type IN ('PK', 'FK', 'UQ')


---Reports-----
--This report shows database scan Start and Complete time as well as count objects scanned vs. total count of objects in database
exec PostScanReport  1
sp_helptext Usp_getlatestgolddbobjectslist

EXECUTE Usp_getlatestgolddbobjectslist
EXECUTE Usp_getlatestgolddbobjectslist_nospace

--The following reports will will rank objects or tables based on variance
EXEC VarianceSummary_Objects
EXEC VarianceSummary_Tables 



---Get variance
exec ObjectsCompare 'A2PostBatchServices', 'TranWBMI'
exec TablesCompare 'dbo.__RefactorLog', 'Tran'
exec GetVariances 'dbo.Departments', 'TranWBMI'

---Get Latest defination of objects and table
select top 10 * from Results where ObjectName='dbo.Departments'




select left(databasename,len(databasename)-4) as 'DbType', count(1)as 'Total Count' from 
(
select * from ProgressReportAH
where AnalysisId in (776)
and completedatetime is not null
union
select * from ProgressReport
where AnalysisId in (777)
and completedatetime is not null
)as t
where completeDateTime is not null
group by left(databasename,len(databasename)-4)


-----Get Env Details Servers DB -------------------
SELECT * FROM Environments
SELECT * FROM CareServers
SELECT * FROM ActiveLocations where DBName IN('TranUCKY')
SELECT * FROM DBServers where ServerId=17
SELECT * FROM ServerDatabases
SELECT * FROM ServerDatabases where DatabaseName in ('TranBHTN')
and DatabaseName LIKE 'Tran%'
select * from ExcludedDatabase

SELECT top 20 * from MasterObjectList where ObjectName='job_InsertNewPaymentCodesToFinTran'
select * from Results
select top 10 * from Analysis
select * from Environments
select * from DBServers
select * from ServerDatabases
select * from DatabaseClass


----Deal loack detection--
EXEC SP_LOCK 
EXEC SP_WHO2
SELECT * FROM sys.dm_tran_locks 


SELECT  L.request_session_id AS SPID, 
    DB_NAME(L.resource_database_id) AS DatabaseName,
    O.Name AS LockedObjectName, 
    P.object_id AS LockedObjectId, 
    L.resource_type AS LockedResource, 
    L.request_mode AS LockType,
    ST.text AS SqlStatementText,        
    ES.login_name AS LoginName,
    ES.host_name AS HostName,
    TST.is_user_transaction as IsUserTransaction,
    AT.name as TransactionName,
    CN.auth_scheme as AuthenticationMethod
FROM    sys.dm_tran_locks L
    JOIN sys.partitions P ON P.hobt_id = L.resource_associated_entity_id
    JOIN sys.objects O ON O.object_id = P.object_id
    JOIN sys.dm_exec_sessions ES ON ES.session_id = L.request_session_id
    JOIN sys.dm_tran_session_transactions TST ON ES.session_id = TST.session_id
    JOIN sys.dm_tran_active_transactions AT ON TST.transaction_id = AT.transaction_id
    JOIN sys.dm_exec_connections CN ON CN.session_id = ES.session_id
    CROSS APPLY sys.dm_exec_sql_text(CN.most_recent_sql_handle) AS ST
WHERE   resource_database_id = db_id()
ORDER BY L.request_session_id



SELECT object_name(a.[object_id]),* FROM sys.sql_modules a
join sys.objects b on a.[object_id]=b.[object_id]
WHERE --routine_type='views' and
DEFINITION LIKE '%AHS-%' and object_name(a.[object_id])='vwEligibilityTrace'


SELECT qt.[text]          AS [SP Name],
       qs.last_execution_time,
       qs.execution_count AS [Execution Count]
FROM   sys.dm_exec_query_stats AS qs
       CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
WHERE  qt.dbid = DB_ID()
       AND objectid = OBJECT_ID('Load_hl7_tran') 


