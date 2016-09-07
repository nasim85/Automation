use  Eligibility

SELECT object_name(a.[object_id]),* FROM sys.sql_modules a
join sys.objects b on a.[object_id]=b.[object_id]
WHERE --routine_type='views' and
DEFINITION LIKE '%AHS-%' --and object_name(a.[object_id])='vwEligibilityTrace'



/*

-- to get the current name of the SQL Server
exec sp_helpserver                                           
--The output of the rpc.rpc out,use remote collation field in the result is the ORIGINAL-servername.  This is usually instance 0 as well.
 

-- to drop the old SQL Servername
exec sp_dropserver 'ORIGINAL-servername'                            
--The CURRENT-servername is your computer name.

-- to add the new name as the local server
exec sp_addserver 'CURRENT-servername', local                      

-- configures the server for Data Access
exec sp_serveroption 'CURRENT-servername', 'Data Access', 'True'   

*/