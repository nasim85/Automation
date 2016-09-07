--RESTORE DATABASE [Tran] WITH RECOVERY
--EXECUTE master.dbo.xp_create_subdir 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\01062016'
:setvar BackupPath "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\01062016\"
:setvar DataPath "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Data\"
:setvar LogPath "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Log\"

--BACKUP DATABASE TranCCWI TO DISK = '$(BackupPath)TranCCWI1.bak'   WITH FORMAT;
--GO
--BACKUP DATABASE TranMAMI TO DISK = '$(BackupPath)TranMAMI.bak'   WITH FORMAT;
--GO
--BACKUP DATABASE TranMPME TO DISK = '$(BackupPath)TranMPME.bak'   WITH FORMAT;
--GO
--BACKUP DATABASE TranSCFL TO DISK = '$(BackupPath)TranSCFL.bak'   WITH FORMAT;
--GO
--BACKUP DATABASE TranSJPK TO DISK = '$(BackupPath)TranSJPK.bak'   WITH FORMAT;
--GO
--BACKUP DATABASE TranWYMI TO DISK = '$(BackupPath)TranWYMI.bak'   WITH FORMAT;
--GO



--BACKUP DATABASE DNN30 TO DISK = '$(BackupPath)DNN30.bak' WITH FORMAT;
--GO
--BACKUP DATABASE DNNStage TO DISK = '$(BackupPath)DNNStage.bak' WITH FORMAT;
--GO
--BACKUP DATABASE ClaimStatus TO DISK = '$(BackupPath)ClaimStatus.bak' WITH FORMAT;
--GO
--BACKUP DATABASE CrossSiteYBFU TO DISK = '$(BackupPath)CrossSiteYBFU.bak' WITH FORMAT;
--GO
--BACKUP DATABASE Reference TO DISK = '$(BackupPath)Reference.bak' WITH FORMAT;
--GO
--BACKUP DATABASE Global_AhtoDialer TO DISK = '$(BackupPath)Global_AhtoDialer.bak'   WITH FORMAT;
--GO
--BACKUP DATABASE DataArchive TO DISK = '$(BackupPath)DataArchive.bak' WITH FORMAT;
--GO
--BACKUP DATABASE ELIGIBILITY TO DISK = '$(BackupPath)ELIGIBILITY.bak' WITH FORMAT;
--GO
--BACKUP DATABASE Accretive TO DISK = '$(BackupPath)Accretive.bak'   WITH FORMAT;
--GO
--BACKUP DATABASE AccretiveLogs TO DISK = '$(BackupPath)AccretiveLogs.bak'  WITH FORMAT;
--GO
--BACKUP DATABASE CrossSiteSupport TO DISK = '$(BackupPath)CrossSiteSupport.bak'   WITH FORMAT;
--GO
--BACKUP DATABASE Global_FCC_PreRegistration TO DISK = '$(BackupPath)Global_FCC_PreRegistration.bak'   WITH FORMAT;
--GO
--BACKUP DATABASE TranGLOBAL TO DISK = '$(BackupPath)TranGLOBAL.bak'   WITH FORMAT;
--GO
--BACKUP DATABASE FileExchange TO DISK = '$(BackupPath)FileExchange.bak'  WITH FORMAT;
--GO



--------------------Restore Database---------------------------------------
--RESTORE DATABASE DNN30 FROM DISK = '$(BackupPath)DNN30.bak'  WITH Replace
--GO
--RESTORE DATABASE DNNStage FROM DISK = '$(BackupPath)DNNStage.bak'  WITH Replace
--GO
--RESTORE DATABASE ClaimStatus FROM DISK = '$(BackupPath)ClaimStatus.bak'  WITH Replace
--GO
--RESTORE DATABASE CrossSiteYBFU FROM DISK = '$(BackupPath)CrossSiteYBFU.bak'  WITH Replace
--GO
--RESTORE DATABASE Reference FROM DISK = '$(BackupPath)Reference.bak'  WITH Replace
--GO
--RESTORE DATABASE Global_AhtoDialer FROM DISK = '$(BackupPath)Global_AhtoDialer.bak'  WITH Replace
--GO
--RESTORE DATABASE DataArchive FROM DISK = '$(BackupPath)DataArchive.bak'  WITH Replace
--GO
--RESTORE DATABASE ELIGIBILITY FROM DISK = '$(BackupPath)ELIGIBILITY.bak'  WITH Replace
--GO
--RESTORE DATABASE Accretive FROM DISK = '$(BackupPath)Accretive.bak'  WITH Replace
--GO
--RESTORE DATABASE AccretiveLogs FROM DISK = '$(BackupPath)AccretiveLogs.bak'  WITH Replace
--GO
--RESTORE DATABASE CrossSiteSupport FROM DISK = '$(BackupPath)CrossSiteSupport.bak'  WITH Replace
--GO
--RESTORE DATABASE Global_FCC_PreRegistration FROM DISK = '$(BackupPath)Global_FCC_PreRegistration.bak'  WITH Replace
--GO
--RESTORE DATABASE TranGLOBAL FROM DISK = '$(BackupPath)TranGLOBAL.bak'  WITH Replace
--GO
--RESTORE DATABASE FileExchange FROM DISK = '$(BackupPath)FileExchange.bak'  WITH Replace
--GO


---------------#Tran#-------------
RESTORE DATABASE TranCCWI FROM DISK = '$(BackupPath)TranSCFL.bak'  WITH Replace, MOVE 'TranSCFL' TO '$(DataPath)TranCCWI.mdf', MOVE 'TranSCFL_Log' TO '$(LogPath)TranCCWI.ldf' 
GO
RESTORE DATABASE TranMAMI FROM DISK = '$(BackupPath)TranSCFL.bak'  WITH Replace, MOVE 'TranSCFL' TO '$(DataPath)TranMAMI.mdf', MOVE 'TranSCFL_Log' TO '$(LogPath)TranMAMI.ldf' 
GO
RESTORE DATABASE TranMPME FROM DISK = '$(BackupPath)TranSCFL.bak'  WITH Replace, MOVE 'TranSCFL' TO '$(DataPath)TranMPME.mdf', MOVE 'TranSCFL_Log' TO '$(LogPath)TranMPME.ldf' 
GO
RESTORE DATABASE TranSCFL FROM DISK = '$(BackupPath)TranSCFL.bak'  WITH Replace, MOVE 'TranSCFL' TO '$(DataPath)TranSCFL.mdf', MOVE 'TranSCFL_Log' TO '$(LogPath)TranSCFL.ldf' 
GO
RESTORE DATABASE TranSJPK FROM DISK = '$(BackupPath)TranSCFL.bak'  WITH Replace, MOVE 'TranSCFL' TO '$(DataPath)TranSJPK.mdf', MOVE 'TranSCFL_Log' TO '$(LogPath)TranSJPK.ldf' 
GO
RESTORE DATABASE TranWYMI FROM DISK = '$(BackupPath)TranSCFL.bak'  WITH Replace, MOVE 'TranSCFL' TO '$(DataPath)TranWYMI.mdf', MOVE 'TranSCFL_Log' TO '$(LogPath)TranWYMI.ldf' 
GO











