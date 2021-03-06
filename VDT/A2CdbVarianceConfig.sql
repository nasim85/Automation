USE [A2CdbVariance]

---------Configuration Cleanup Truncate tables-----------
--TRUNCATE TABLE Analysis
--TRUNCATE TABLE ServerDatabasesCare05
--TRUNCATE TABLE dbServersCare05
--TRUNCATE TABLE Environments
--TRUNCATE TABLE DBServers
--TRUNCATE TABLE ServerDatabases
--TRUNCATE TABLE DatabaseClass


--insert configuration---
INSERT INTO Environments([EnvironmentName]) VALUES('AHtoContract')

INSERT INTO DatabaseClass(DBClass, TotalCount)VALUES ('TRAN',68)

GO
SET IDENTITY_INSERT DBServers ON

INSERT INTO DBServers(ServerId, ServerName, EnvironmentId)VALUES(1,'SDS-DBSERVER19',1)
INSERT INTO DBServers(ServerId, ServerName, EnvironmentId)VALUES(2,'SDS-DBSERVER20',1)
INSERT INTO DBServers(ServerId, ServerName, EnvironmentId)VALUES(3,'SDV-DBSERVER21',1)
INSERT INTO DBServers(ServerId, ServerName, EnvironmentId)VALUES(4,'SDV-DBSERVER22',1)
INSERT INTO DBServers(ServerId, ServerName, EnvironmentId)VALUES(5,'SDS-DBSERVER18',1)
INSERT INTO DBServers(ServerId, ServerName, EnvironmentId)VALUES(6,'SDS-DBSERVER15',1)
SET IDENTITY_INSERT DBServers OFF



INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A116',1,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A118',1,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A120',2,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A122',2,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A125',2,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A126',2,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A127',2,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A128',1,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A130',1,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A132',1,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A134',2,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A138',1,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A139',1,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A140',2,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A142',2,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A143',2,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A144',1,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A146',2,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A148',2,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A152',2,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A154',1,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A364',2,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A370',2,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-A400',2,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-BGMI',3,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-BHTN',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-BMAL',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-BOGI',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-BOLE',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-BOMC',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-BOSU',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-BRMI',3,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-BTAL',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-DHPN',5,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-DHPS',3,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-DHTN',3,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-ESAL',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-GRMC',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-HCAZ-RI',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-HCFL',6,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-LLNJ',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-LMNJ',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-MCWI',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-MHME',6,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-MMMA',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-MTTN',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-OCWI',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-PHAL',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-PHDC',5,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-SCAL',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-SCCA_Epic',6,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-SFNJ',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-SHOR',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-SHWI',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-SJAZ-RI',5,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-SJMA',3,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-SJMC',6,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-SJOK',5,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-SJPK',5,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-SJPR',3,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-SJRD',3,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-SLFL',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-SMAZ-RI',5,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-SMMC',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-SPCA',6,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-STAH-RI',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-STTN',4,1,1)
INSERT INTO ServerDatabases(DatabaseName, ServerId, DatabaseClass, IsGold)VALUES ('ACCRETIVE-SVFL',5,1,1)




/****** Script for SelectTopNRows command from SSMS  ******/
SELECT * FROM Environments
SELECT * FROM DBServers
SELECT * FROM ServerDatabases
SELECT * FROM DatabaseClass