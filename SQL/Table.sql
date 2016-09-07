

CREATE TABLE eExit_FeedbackQuestion
(
	[QuesID] [int] IDENTITY(1,1) Primary Key NOT NULL,
	[QuesNo] [Int] Not Null,
	[QuestionName] varchar(max) NULL,
	[active] [bit] NULL,
	HasChild Bit Null,
	[EnteredBy] [int] NULL,
	[EntryDate] [datetime] NULL,
	[LastUpdatedBy] [int] NULL,
	[LastUpdatedOn] [datetime] NULL
)

go

CREATE TABLE eExit_FeedbackEmployeeMatrix
(
	[FDEmpMatrixID] [int] IDENTITY(1,1) Primary Key NOT NULL,
	[QuestID][Int] foreign key references  eExit_FeedbackQuestion(QuesID),
	[EmployeeID] Varchar (100) foreign key references EmployeeMaster(EmployeeID),
	[Answer] varchar(max) NULL,
	[active] [bit] NULL,
	[ISComplete] [bit] Null,
	[EnteredBy] [int] NULL,
	[EntryDate] [datetime] NULL,
	[LastUpdatedBy] [int] NULL,
	[LastUpdatedOn] [datetime] NULL
)


                      INSERT INTO [eExit_FeedbackQuestion]([QuesNo],[QuestionName],[active],[EnteredBy],[EntryDate]) 
                           VALUES (1,'Why are you leaving the company?',1,101177,GETDATE()),
                                  (2,'Please explain your reason(s) for leaving in more detail.',1,101177,GETDATE()),
                                  (3,'What suggestions for improvement do you have for us?',1,101177,GETDATE()),
                                  (4,'If we implemented those suggestions, would you return to work here?',1,101177,GETDATE()),
                                  (5,'Would you recommented this company to your friends as a good place to work?',1,101177,GETDATE()),
                                  (6,'I believe that I was treated like a valuable member  of the company',1,101177,GETDATE()),
                                  (7,'My immediate supervisor let me know when I was doing a good job',1,101177,GETDATE()),
                                  (8,'I felt free to suggest to my supervisor changes that would improve my department',1,101177,GETDATE()),
                                  (9,'My job duties and responsibilities were clearly defined',1,101177,GETDATE()),
                                  (10,'I received the proper training in order to perform my job effectively',1,101177,GETDATE()),
                                  (11,'Employee problems and complaints were resolved fairly and promptly in my department.',1,101177,GETDATE())
                                  go
                                  
                       INSERT INTO [eExit_FeedbackQuestion]([QuesNo],[QuestionName]) 
                           VALUES            
                                  (12,'If I had questions and concerns, I felt comfortable speaking with:')
                                  Go
                                  
                        INSERT INTO [eExit_FeedbackQuestion]([QuesNo],[QuestionName],[active],[EnteredBy],[EntryDate],[HasChild]) 
                           VALUES           
                                  (12,'My immediate supervisor',1,101177,GETDATE(),1),
                                  (12,'Upper Management',1,101177,GETDATE(),1),
                                  (12,'Human resources',1,101177,GETDATE(),1)
                                  go
                                  
                         INSERT INTO [eExit_FeedbackQuestion]([QuesNo],[QuestionName],[active],[EnteredBy],[EntryDate]) 
                           VALUES          
                                  (13,'I was kept well informed about the company, its policies and procedures, and other important information',1,101177,GETDATE()),
                                  (14,'I felt that the company provided me with job security',1,101177,GETDATE()),
                                  (15,'If going to another job, what advantage does your new job have over your Accretive Health position?(Tick all that apply)',1,101177,GETDATE()),
                                  (16,'What did you like best about your job at Accretive Health?(Tick all that apply)',1,101177,GETDATE()),
                                  (17,'What did you like that least about your job at Accretive Health?(Tick all that apply)',1,101177,GETDATE()),
                                  (18,'Please list any additional benefits that you would have wanted the company to offer:',1,101177,GETDATE()),
                                  (19,'Reporting Managers comments:',1,101177,GETDATE()),
                                  (20,'HR comments:',1,101177,GETDATE())
                                  
go

CREATE TABLE [dbo].[eExit_ClearanceEmployeeMatrix]
(
	[ClearanceMatrixId] [int] IDENTITY(1,1) NOT NULL,
	[QuestionId] [int] NULL,
	[EmployeeId] [int] NULL,
	[Answer] [varchar](200) NULL,
	[Answerbit] [bit] NULL,
	[Active] [bit] NULL,
	[EnteredBy] [int] NULL,
	[EntryDate] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL
) ON [PRIMARY]

go


CREATE TABLE [dbo].[eExit_ClearancePanelMatrix](
	[ClearancePanelMatrixId] [int] IDENTITY(1,1) NOT NULL,
	[ClearancePanelId] [int] NULL,
	[RoleId] [int] NULL,
	[Active] [bit] NULL,
	[EnteredBy] [int] NULL,
	[EntryDate] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_eExit_ClearancePanel_Matrix] PRIMARY KEY CLUSTERED 
(
	[ClearancePanelMatrixId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

go

CREATE TABLE [dbo].[eExit_ClearanceQuestion](
	[QuestionId] [int] IDENTITY(1,1) NOT NULL,
	[QuestionNo] [int] NULL,
	[ClearancePanelId] [int] NULL,
	[QuestionName] [varchar](200) NULL,
	[Active] [bit] NULL,
	[EnteredBy] [int] NULL,
	[EntryDate] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_eExit_Clearance_Question] PRIMARY KEY CLUSTERED 
(
	[QuestionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[eExit_ClearanceQuestion] ON
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (1, 1, 1, N'Documents/Notes, if any', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (2, 2, 1, N'Informed HR-IT-Admin via email ', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (3, 3, 1, N'Resignation letter acceptance', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (4, 4, 1, N'Process hand over ', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (5, 5, 1, N'Notice period served (in days) ', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (6, 6, 1, N'Official file handed over to HR', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (7, 7, 2, N'Received Laptop', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (8, 8, 2, N'Data card received ', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (9, 9, 2, N'Email ID deleted ', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (10, 10, 2, N'Domain ID deleted ', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (11, 11, 2, N'CD/Floppy', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (12, 12, 2, N'Process related ID', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (13, 13, 2, N'Headset received ', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (14, 14, 2, N'Access to sites ', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (15, 15, 3, N'Access card collected', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (16, 16, 3, N'ID card collected', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (17, 17, 3, N'Mobile                       ', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (18, 18, 3, N'Drawer keys             ', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (19, 19, 3, N'Tuck Shop                 ', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (20, 20, 3, N'Transport roster updated', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (21, 21, 3, N'Stationary', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (22, 22, 3, N'Access card deactivated ', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (23, 23, 4, N'Imprest ', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (24, 24, 4, N'Loan ', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (25, 25, 4, N'Advance', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (26, 26, 4, N'Any other dues', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearanceQuestion] ([QuestionId], [QuestionNo], [ClearancePanelId], [QuestionName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (27, 27, 5, N'Remark', 1, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[eExit_ClearanceQuestion] OFF

GO

CREATE TABLE [dbo].[eExit_ClearancePanelMaster](
	[ClearancePanelId] [int] IDENTITY(1,1) NOT NULL,
	[ClearancePanelName] [varchar](200) NULL,
	[Active] [bit] NULL,
	[EnteredBy] [int] NULL,
	[EntryDate] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_eExit_ClearancePanelMaster] PRIMARY KEY CLUSTERED 
(
	[ClearancePanelId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[eExit_ClearancePanelMaster] ON
INSERT [dbo].[eExit_ClearancePanelMaster] ([ClearancePanelId], [ClearancePanelName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (1, N'Process/Department Clearance', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearancePanelMaster] ([ClearancePanelId], [ClearancePanelName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (2, N'Information Technology', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearancePanelMaster] ([ClearancePanelId], [ClearancePanelName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (3, N'Administration Department', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearancePanelMaster] ([ClearancePanelId], [ClearancePanelName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (4, N'Finance', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[eExit_ClearancePanelMaster] ([ClearancePanelId], [ClearancePanelName], [Active], [EnteredBy], [EntryDate], [UpdatedBy], [UpdatedOn]) VALUES (5, N'HR', 1, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[eExit_ClearancePanelMaster] OFF


-- dbo.eExit_ClearanceQuestion With Data
-- dbo.eExit_ClearancePanelMaster With Data
--Select * from eExit_ClearancePanelMatrix






--/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
--BEGIN TRANSACTION
--SET QUOTED_IDENTIFIER ON
--SET ARITHABORT ON
--SET NUMERIC_ROUNDABORT OFF
--SET CONCAT_NULL_YIELDS_NULL ON
--SET ANSI_NULLS ON
--SET ANSI_PADDING ON
--SET ANSI_WARNINGS ON
--COMMIT
--BEGIN TRANSACTION
--GO
--CREATE TABLE dbo.Tmp_EmployeeResignation
--	(
--	ResignationID int NOT NULL IDENTITY (1, 1),
--	EmployeeID int NULL,
--	ResignationDate datetime NULL,
--	ResignationRevokeDate datetime NULL,
--	ResignationDetails text NULL,
--	ResignationStatusID int NULL,
--	LastDayWorkedByPolicy datetime NULL,
--	LastDayWorked datetime NULL,
--	ReasonID int NULL,
--	ReasonDetails varchar(500) NULL,
--	Active bit NULL,
--	EntryDate datetime NULL,
--	EnteredBy int NULL,
--	LastUpdatedOn datetime NULL,
--	Updatedby int NULL
--	)  ON [PRIMARY]
--	 TEXTIMAGE_ON [PRIMARY]
--GO
--ALTER TABLE dbo.Tmp_EmployeeResignation SET (LOCK_ESCALATION = TABLE)
--GO
--SET IDENTITY_INSERT dbo.Tmp_EmployeeResignation ON
--GO
--IF EXISTS(SELECT * FROM dbo.EmployeeResignation)
--	 EXEC('INSERT INTO dbo.Tmp_EmployeeResignation (ResignationID, EmployeeID, ResignationDate, ResignationDetails, ResignationStatusID, LastDayWorkedByPolicy, LastDayWorked, ReasonID, ReasonDetails, Active, EntryDate, EnteredBy, LastUpdatedOn, Updatedby)
--		SELECT ResignationID, EmployeeID, ResignationDate, ResignationDetails, ResignationStatusID, LastDayWorkedByPolicy, LastDayWorked, ReasonID, ReasonDetails, Active, EntryDate, EnteredBy, LastUpdatedOn, Updatedby FROM dbo.EmployeeResignation WITH (HOLDLOCK TABLOCKX)')
--GO
--SET IDENTITY_INSERT dbo.Tmp_EmployeeResignation OFF
--GO
--ALTER TABLE dbo.EmployeeResignation
--	DROP CONSTRAINT FK_EmployeeResignation_EmployeeResignation
--GO
--DROP TABLE dbo.EmployeeResignation
--GO
--EXECUTE sp_rename N'dbo.Tmp_EmployeeResignation', N'EmployeeResignation', 'OBJECT' 
--GO
--ALTER TABLE dbo.EmployeeResignation ADD CONSTRAINT
--	PK_EmployeeResignation PRIMARY KEY CLUSTERED 
--	(
--	ResignationID
--	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

--GO
--ALTER TABLE dbo.EmployeeResignation ADD CONSTRAINT
--	FK_EmployeeResignation_EmployeeResignation FOREIGN KEY
--	(
--	ResignationID
--	) REFERENCES dbo.EmployeeResignation
--	(
--	ResignationID
--	) ON UPDATE  NO ACTION 
--	 ON DELETE  NO ACTION 
	
--GO
--COMMIT








--GO

--/****** Object:  Table [dbo].[EmployeeAttendanceStatus]    Script Date: 08/08/2012 22:01:18 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--SET ANSI_PADDING ON
--GO

--CREATE TABLE [dbo].[EmployeeAttendanceStatus](
--	[AttendanceStatusID] [int] IDENTITY(1,1) NOT NULL,
--	[EmployeeID] [varchar](50) NOT NULL,
--	[AttendanceDate] [datetime] NULL,
--	[AttendanceStatus] [varchar](200) NULL,
-- CONSTRAINT [PK_EmployeeAttendanceStatus] PRIMARY KEY CLUSTERED 
--(
--	[AttendanceStatusID] ASC
--)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--) ON [PRIMARY]

--GO

--SET ANSI_PADDING OFF
--GO




/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.EmployeeResignationComments
	DROP COLUMN DOJ
GO
ALTER TABLE dbo.EmployeeResignationComments SET (LOCK_ESCALATION = TABLE)
GO
COMMIT






GO

/****** Object:  Table [dbo].[ProductPageMatrix]    Script Date: 07/31/2012 18:00:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ProductPageMatrix](
	[ProductPageID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NULL,
	[PageID] [int] NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_ProductPageMatrix] PRIMARY KEY CLUSTERED 
(
	[ProductPageID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO



--INSERT INTO ProductPageMatrix
--                      (ProductID, PageID, Active)
--select 27,PageID,1  from SpecialRights where  EmployeeID= 101090  and Active=1


--INSERT INTO ProductPageMatrix
--                      (ProductID, PageID, Active)
--select 26,PageID,1 from ModuleMatrix where PageID in (95,93,94)

