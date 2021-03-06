USE [master]
GO

/****** Object:  Database [A2CdbVariance]    Script Date: 06/02/2016 19:55:36 ******/
CREATE DATABASE [A2CdbVariance]
GO


USE [A2CdbVariance]
GO

/****** Object:  Schema [Analysis]    Script Date: 06/07/2016 17:38:26 ******/
CREATE SCHEMA [Analysis] AUTHORIZATION [dbo]
GO




USE [A2CdbVariance]
GO
/****** Object:  Table [dbo].[VarianceReductionData_20130806]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VarianceReductionData_20130806](
	[rank] [bigint] NULL,
	[ObjectName] [varchar](100) NOT NULL,
	[ObjectType] [varchar](5) NOT NULL,
	[SelectFrom] [varchar](100) NULL,
	[DatabaseList] [nvarchar](max) NULL,
	[CountOfObjects] [int] NULL,
	[ServerName] [nvarchar](128) NULL,
	[CountOfDatabases] [int] NULL,
	[AssignedTo] [varchar](200) NULL,
	[RiskLevel] [varchar](200) NULL,
	[ModelSite] [varchar](200) NULL,
	[Comment] [varchar](max) NULL,
	[ReviewerName] [varchar](200) NULL,
	[ReviewerComments] [varchar](max) NULL,
	[Changeset] [varchar](200) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[VarianceReductionData]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VarianceReductionData](
	[rank] [bigint] NULL,
	[ObjectName] [varchar](100) NOT NULL,
	[ObjectType] [varchar](5) NOT NULL,
	[SelectFrom] [varchar](100) NULL,
	[DatabaseList] [nvarchar](max) NULL,
	[CountOfObjects] [int] NULL,
	[ServerName] [nvarchar](128) NULL,
	[CountOfDatabases] [int] NULL,
	[AssignedTo] [varchar](200) NULL,
	[RiskLevel] [varchar](200) NULL,
	[ModelSite] [varchar](200) NULL,
	[Comment] [varchar](max) NULL,
	[ReviewerName] [varchar](200) NULL,
	[ReviewerComments] [varchar](max) NULL,
	[Changeset] [varchar](200) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[VarianceAnalysisRecordKey]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VarianceAnalysisRecordKey](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[row] [float] NULL,
	[Object Name] [nvarchar](255) NULL,
	[Version] [smallint] NULL,
	[PickFrom] [nvarchar](255) NULL,
	[ObjType] [nvarchar](255) NULL,
	[FileName] [nvarchar](255) NULL,
	[Header] [ntext] NULL,
	[Database List] [ntext] NULL,
	[Include In Deployment] [nvarchar](255) NULL,
	[Story#] [nvarchar](255) NULL,
	[Field11] [nvarchar](255) NULL,
	[DHTN] [nvarchar](255) NULL,
	[DHPS] [nvarchar](255) NULL,
	[HFMI] [nvarchar](255) NULL,
	[Processed] [nvarchar](255) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorklostTrace]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorklostTrace](
	[RowNumber] [int] IDENTITY(0,1) NOT NULL,
	[EventClass] [int] NULL,
	[TextData] [ntext] NULL,
	[DatabaseID] [int] NULL,
	[DatabaseName] [nvarchar](128) NULL,
	[ObjectID] [int] NULL,
	[ObjectName] [nvarchar](128) NULL,
	[ServerName] [nvarchar](128) NULL,
	[BinaryData] [image] NULL,
	[SPID] [int] NULL,
	[StartTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[RowNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[usp_RequestDbObjectInsertTest]    Script Date: 06/02/2016 18:52:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Umesh Kumar
-- Create date: 4/12/2012
-- Description:	Inserting database objects like (SP,View,Function etc.) and there analysis results into request table.
-- =============================================
CREATE procedure [dbo].[usp_RequestDbObjectInsertTest]
     
     @RunId as int,
     @ServerName as varchar(100),
     @DbName varchar(50)
 As
 --execute [usp_RequestDbObjectInsert]100,'AHS-Care01','TranBOLE'
 Begin
	 Declare @str varchar(1000) 
	 set @str = ''
	 set @str = ''
		set @str = @str +'  select ' + convert(varchar(10),@RunId) + ' as RunId,''' + @ServerName + ''' as ServerName,''' + @DbName + ''' as DbName, o.name, o.Type,
		dbo.MakeMD5Hash(definition) as ''hashbytes'',
		dbo.MakeMD5Hash(dbo.RemoveComments(definition)) ''hashbytesNoComments'',
		dbo.MakeMD5Hash(dbo.RemoveWhiteSpace(dbo.RemoveComments(definition))) ''hashbytesRemoveAll'',
		Definition
		from ['+@ServerName+'].[' +  @DbName + '].dbo.sysobjects o
		inner join ['+@ServerName+'].[' + @DbName + '].sys.sql_modules c on c.object_id = o.id where o.type in (''P'',''V'',''FN'',''IF'',''TF'',''U'',''TR'')
		and o.name not in (select ObjectName from Results where RunId='+ convert(nvarchar(11),@RunId ) +' and DatabaseName ='''+@DbName+''') 
		and o.name not in (Select [Name] from ExcludedDbObject ) and o.name=''EDI_835_5010_AdjudicationSummaryUpdate'''
	 print @str
	 Exec (@str)
		    
End
GO
/****** Object:  StoredProcedure [dbo].[usp_TableChecksum_old]    Script Date: 06/02/2016 18:52:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 4/15/2012
-- Description:	Returns checksum over column defenitions for a table
-- execute [usp_TableChecksum] 48,'AHS-STAGE02','StageBACC'
-- =============================================
CREATE PROCEDURE [dbo].[usp_TableChecksum_old] 
	@RunId as int=100,
    @ServerName as varchar(100),
    @DbName sysname
AS
BEGIN
	SET NOCOUNT ON;
Declare @sql nvarchar(4000)

set @sql=N'select ' +convert(nvarchar(11),@RunId ) + ',''' + convert(nvarchar(128),@ServerName) + ''',''' +
convert(nvarchar(128),@DbName) + ''',o.name,''U'', 
checksum_agg(
BINARY_CHECKSUM(
ISNULL(convert(nvarchar(3),c.bitpos),'''')
+ ISNULL(convert(nvarchar(11),c.cdefault),'''')
--+ ISNULL(convert(nvarchar(5),c.colid),'''')
+ ISNULL(c.collation,'''')
+ ISNULL(convert(nvarchar(11),c.collationid),'''')
+ ISNULL(convert(nvarchar(5),c.colorder),'''')
+ ISNULL(convert(nvarchar(5),c.colstat),'''')
+ ISNULL(convert(nvarchar(11),c.domain),'''')
+ ISNULL(convert(nvarchar(11),c.iscomputed),'''')
+ ISNULL(convert(nvarchar(11),c.isnullable),'''')
+ ISNULL(convert(nvarchar(11),c.isoutparam),'''')
+ ISNULL(convert(nvarchar(11),c.language),'''')
+ ISNULL(convert(nvarchar(5),c.length),'''')
+ c.name
+ ISNULL(convert(nvarchar(5),c.number),'''')
+ ISNULL(convert(nvarchar(5),c.offset),'''')
+ ISNULL(convert(nvarchar(5),c.prec),'''')
+ ISNULL(convert(nvarchar(255),c.printfmt),'''')
+ ISNULL(convert(nvarchar(3),c.reserved),'''')
+ ISNULL(convert(nvarchar(11),c.scale),'''')
--+ ISNULL(convert(nvarchar(3),c.status),'''')
--+ ISNULL(convert(nvarchar(5),c.tdscollation),'''')
+ ISNULL(convert(nvarchar(3),c.type),'''')
--+ ISNULL(convert(nvarchar(3),c.typestat),'''')
+ ISNULL(convert(nvarchar(5),c.usertype),'''')
+ ISNULL(convert(nvarchar(5),c.xoffset),'''')
+ ISNULL(convert(nvarchar(3),c.xprec),'''')
+ ISNULL(convert(nvarchar(3),c.xscale),'''')
+ ISNULL(convert(nvarchar(3),c.xtype),'''')
+ ISNULL(convert(nvarchar(5),c.xusertype),''''))) as ''Table'',
checksum_agg(
BINARY_CHECKSUM(
ISNULL(convert(nvarchar(3),c.bitpos),'''')
+ ISNULL(convert(nvarchar(11),c.cdefault),'''')
+ ISNULL(c.collation,'''')
+ ISNULL(convert(nvarchar(11),c.collationid),'''')
+ ISNULL(convert(nvarchar(5),c.colstat),'''')
+ ISNULL(convert(nvarchar(11),c.domain),'''')
+ ISNULL(convert(nvarchar(11),c.iscomputed),'''')
+ ISNULL(convert(nvarchar(11),c.isnullable),'''')
+ ISNULL(convert(nvarchar(11),c.isoutparam),'''')
+ ISNULL(convert(nvarchar(11),c.language),'''')
+ ISNULL(convert(nvarchar(5),c.length),'''')
+ c.name
+ ISNULL(convert(nvarchar(5),c.number),'''')
+ ISNULL(convert(nvarchar(5),c.prec),'''')
+ ISNULL(convert(nvarchar(255),c.printfmt),'''')
+ ISNULL(convert(nvarchar(3),c.reserved),'''')
+ ISNULL(convert(nvarchar(11),c.scale),'''')
+ ISNULL(convert(nvarchar(3),c.type),'''')
+ ISNULL(convert(nvarchar(5),c.usertype),'''')
+ ISNULL(convert(nvarchar(5),c.xoffset),'''')
+ ISNULL(convert(nvarchar(3),c.xprec),'''')
+ ISNULL(convert(nvarchar(3),c.xscale),'''')
+ ISNULL(convert(nvarchar(3),c.xtype),'''')
+ ISNULL(convert(nvarchar(5),c.xusertype),''''))) as ''TableUnordered''
 from ['+@ServerName+'].[' +  @DbName + '].dbo. syscolumns c
	inner join ['+@ServerName+'].[' +  @DbName + '].dbo.sysobjects o on c.id=o.id
	where o.type=''U'' and o.name not in (select ObjectName from Results where ObjectType =''U'' 
	and RunId='+ convert(nvarchar(11),@RunId ) +' and  DatabaseName ='''+@DbName+''')
group by o.name'

exec sp_executesql @sql
--Print @sql

END
GO
/****** Object:  StoredProcedure [dbo].[usp_TableChecksum_NEW]    Script Date: 06/02/2016 18:52:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Viktor Misyutin  
-- Create date: 4/15/2012  
-- Description: Returns checksum over column defenitions for a table  
-- execute [usp_TableChecksum] 100,'AHV-A2AQA1TRN01','TranSJMA'  
-- =============================================  
Create PROCEDURE [dbo].[usp_TableChecksum_NEW]   
 @RunId as int=100,  
    @ServerName as varchar(128),  
    @DbName sysname,  
    @LinkedServerPrefix nchar(3)=N'VDT'  
AS  
BEGIN  
 SET NOCOUNT ON;  
 Declare @sql nvarchar(4000)  
 Declare @sqlTemp as nvarchar(4000)  
 -- Create Temp Table for holding table columns detail.  
   
 CREATE TABLE #CTE (TABLE_SCHEMA VARCHAR(100), TABLE_NAME VARCHAR(250),TABLE_ID int,column_definitions VARCHAR(Max))   
  
 select @sqlTemp=N'  
 INSERT INTO #CTE  
 SELECT e1.TABLE_SCHEMA, e1.TABLE_NAME,(select object_id from ['+@ServerName+'].[' +  @DbName + '].sys.objects where name =e1.TABLE_NAME) as TableID, LEFT(column_definitions, LEN(column_definitions) - 1) AS column_definitions  
 FROM ['+@ServerName+'].[' +  @DbName + '].INFORMATION_SCHEMA.COLUMNS AS e1  
 INNER JOIN ['+@ServerName+'].[' +  @DbName + '].INFORMATION_SCHEMA.TABLES tbl ON tbl.TABLE_SCHEMA = e1.TABLE_SCHEMA AND tbl.TABLE_NAME = e1.TABLE_NAME  
 CROSS APPLY ( SELECT ''{RETURN}    '' + QUOTENAME(COLUMN_NAME, ''['') + '' '' + QUOTENAME(DATA_TYPE, ''['') + CASE DATA_TYPE  
 WHEN ''char'' THEN (CASE ISNULL(CHARACTER_MAXIMUM_LENGTH, 0) WHEN 0 THEN '''' WHEN -1 THEN ''(MAX)'' ELSE ''('' + convert(varchar(10), CHARACTER_MAXIMUM_LENGTH) + '')'' END)  
 WHEN ''nchar'' THEN (CASE ISNULL(CHARACTER_MAXIMUM_LENGTH, 0) WHEN 0 THEN '''' WHEN -1 THEN ''(MAX)'' ELSE ''('' + convert(varchar(10), CHARACTER_MAXIMUM_LENGTH) + '')'' END)  
 WHEN ''varchar'' THEN (CASE ISNULL(CHARACTER_MAXIMUM_LENGTH, 0) WHEN 0 THEN '''' WHEN -1 THEN ''(MAX)'' ELSE ''('' + convert(varchar(10), CHARACTER_MAXIMUM_LENGTH) + '')'' END)  
 WHEN ''nvarchar'' THEN (CASE ISNULL(CHARACTER_MAXIMUM_LENGTH, 0) WHEN 0 THEN '''' WHEN -1 THEN ''(MAX)'' ELSE ''('' + convert(varchar(10), CHARACTER_MAXIMUM_LENGTH) + '')'' END)  
 WHEN ''numeric'' THEN (CASE ISNULL(NUMERIC_PRECISION, 0) WHEN 0 THEN '''' ELSE ''('' + convert(varchar(10), NUMERIC_PRECISION) + '', '' + convert(varchar(10), NUMERIC_SCALE) + '')'' END)  
 WHEN ''decimal'' THEN (CASE ISNULL(NUMERIC_PRECISION, 0) WHEN 0 THEN '''' ELSE ''('' + convert(varchar(10), NUMERIC_PRECISION) + '', '' + convert(varchar(10), NUMERIC_SCALE) + '')'' END)  
 WHEN ''varbinary'' THEN (CASE CHARACTER_MAXIMUM_LENGTH WHEN -1 THEN ''(max)'' ELSE ''('' + convert(varchar(10), CHARACTER_MAXIMUM_LENGTH) + '')'' END)  
 ELSE '''' END +   
 CASE WHEN DATA_TYPE LIKE ''%char'' THEN '' COLLATE '' + COLLATION_NAME  
 ELSE ''''  
 END + ISNULL((SELECT '' IDENTITY ('' + CAST(sic.[seed_value] AS varchar(10)) + '','' + CAST(sic.[increment_value] AS varchar(10)) + '')''  
 FROM sys.identity_columns sic  
 WHERE sic.[object_id] = OBJECT_ID(intern.TABLE_SCHEMA + ''.'' + intern.TABLE_NAME) AND sic.[name] = intern.COLUMN_NAME  
 ), '''') + CASE IS_NULLABLE WHEN ''NO'' THEN '' NOT'' ELSE '''' END + '' NULL'' + '',''  
 FROM ['+@ServerName+'].[' +  @DbName + '].INFORMATION_SCHEMA.COLUMNS AS intern  
 WHERE  e1.TABLE_NAME = intern.TABLE_NAME AND e1.TABLE_SCHEMA = intern.TABLE_SCHEMA  
 ORDER BY intern.ORDINAL_POSITION FOR XML PATH('''') ) pre_trimmed (column_definitions)  
 WHERE e1.TABLE_NAME NOT IN (''dtproperties'', ''sysconstraints'', ''syssegments'') AND tbl.TABLE_TYPE = ''BASE TABLE''  
 GROUP BY e1.TABLE_SCHEMA, e1.TABLE_NAME, pre_trimmed.column_definitions '  
  
 exec sp_executesql @sqlTemp  
  
 print @sqlTemp  
 --select * from #CTE   
 --insert into @CTE EXECUTE usp_TableColumnDefination '''+@ServerName+''',''' +  @DbName + '''  
  
 set @sql=N'  
 select ' +convert(nvarchar(11),@RunId ) + ',''' + convert(nvarchar(128),REPLACE(@ServerName,@LinkedServerPrefix,'')) + ''',''' + convert(nvarchar(128),@DbName) + ''',o.name,''U'',   
 checksum_agg(BINARY_CHECKSUM(  
 dbo.ColumnsOrdered(c.bitpos,c.collation,c.collationid,c.domain,c.iscomputed,c.isnullable,c.isoutparam,c.language,c.length, c.name,  
 c.number,c.offset,c.prec,c.printfmt,c.reserved,c.scale,c.type,c.usertype,c.xoffset,c.xprec,c.xscale,c.xtype,c.xusertype))) as ''TO'',  
 checksum_agg(BINARY_CHECKSUM(dbo.ColumnsUnordered(c.bitpos,c.collation,c.collationid,c.domain,c.iscomputed,c.isnullable,c.isoutparam,c.language,c.length, c.name,  
 c.number,c.prec,c.printfmt,c.reserved,c.scale,c.type,c.usertype,c.xoffset,c.xprec,c.xscale,c.xtype,c.xusertype))) as ''TableUnordered'',  
 (select DISTINCT  ''CREATE TABLE '' + QUOTENAME(TABLE_SCHEMA, ''['') + ''.'' + QUOTENAME(TABLE_NAME, ''['') +   
 '' ('' + REPLACE(column_definitions, ''{RETURN}'', CHAR(13)) + ''  
 ) ON '' + QUOTENAME(ds.name) + '';'' + CHAR(13)   
 FROM ['+@ServerName+'].[' +  @DbName + '].sys.indexes ix   
 inner JOIN ['+@ServerName+'].[' +  @DbName + '].sys.data_spaces ds ON ds.data_space_id = ix.data_space_id  
 inner  JOIN #CTE t ON t.Table_ID = ix.object_id  
 WHERE ix.object_id > 100 AND ix.type <=1 and ix.object_id= O.id) as ''TD''   
 from ['+@ServerName+'].[' +  @DbName + '].dbo. syscolumns c  
 inner join ['+@ServerName+'].[' +  @DbName + '].dbo.sysobjects o on c.id=o.id  
 where o.type=''U'' and o.name not in (select ObjectName from Results where ObjectType =''U''   
 and RunId='+ convert(nvarchar(11),@RunId ) +' and  DatabaseName ='''+@DbName+''')  
 group by o.name,O.id'  
  
 --exec sp_executesql @sql  
 Print @sql  
  
 --drop table  #CTE  
  
END
GO
/****** Object:  StoredProcedure [dbo].[usp_helper_DynamicPivot]    Script Date: 06/02/2016 18:52:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

http://www.sommarskog.se/pivot_sp.sp

exec usp_helper_DynamicPivot 
	@query='select row_number() over (order by chargeitemcode) as rownum, chargeitemcode, CPTCode  from CDM WHERE CPTCode = ''90774''',
	@on_rows='CPTCode',
	@on_cols='rownum',
	@agg_func= N'count',
	@agg_col='chargeitemcode'
*/	
	
CREATE PROCEDURE [dbo].[usp_helper_DynamicPivot]
  @query    AS NVARCHAR(MAX),
  @on_rows  AS NVARCHAR(MAX),
  @on_cols  AS NVARCHAR(MAX),
  @agg_func AS NVARCHAR(MAX) = N'MAX',
  @agg_col  AS NVARCHAR(MAX)
AS

DECLARE 
  @sql     AS NVARCHAR(MAX),
  @cols    AS NVARCHAR(MAX),
  @newline AS NVARCHAR(2);

SET @newline = NCHAR(13) + NCHAR(10);

-- If input is a valid table or view,
-- construct a SELECT statement against it.
IF COALESCE(OBJECT_ID(@query, N'U'),
            OBJECT_ID(@query, N'V')) IS NOT NULL
  SET @query = N'SELECT * FROM ' + @query;

-- Make the query a derived table.
SET @query = N'( ' + @query + @newline + N'      ) AS Query';



-- Handle * input in @agg_col.
IF @agg_col = N'*'
  SET @agg_col = N'1';


-- Construct column list.
SET @sql =
  N'SET @result = '                                    + @newline +
  N'  STUFF('                                          + @newline +
  N'    (SELECT N'','' + '
           + N'QUOTENAME(pivot_col) AS [text()]'       + @newline +
  N'     FROM (SELECT DISTINCT('
           + @on_cols + N') AS pivot_col'              + @newline +
  N'           FROM' + @query + N') AS DistinctCols'   + @newline +
  N'     ORDER BY pivot_col'                           + @newline +
  N'     FOR XML PATH('''')),'                         + @newline +
  N'    1, 1, N'''');'
print @sql
EXEC sp_executesql
  @stmt   = @sql,
  @params = N'@result AS NVARCHAR(MAX) OUTPUT',
  @result = @cols OUTPUT;


-- Create the PIVOT query.
SET @sql = 
  N'SELECT *'                                          + @newline +
  N'FROM'                                              + @newline +
  N'  ( SELECT '                                       + @newline +
  N'      ' + @on_rows + N','                          + @newline +
  N'      ' + @on_cols + N' AS pivot_col,'             + @newline +
  N'      ' + @agg_col + N' AS agg_col'                + @newline +
  N'    FROM '                                         + @newline +
  N'      ' + @query                                   + @newline +
  N'  ) AS PivotInput'                                 + @newline +
  N'  PIVOT'                                           + @newline +
  N'    ( ' + @agg_func + N'(agg_col)'                 + @newline +
  N'      FOR pivot_col'                               + @newline +
  N'        IN(' + @cols + N')'                        + @newline +
  N'    ) AS PivotOutput;'
print @sql;
EXEC sp_executesql @sql;
GO
/****** Object:  Table [dbo].[RecordList586]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RecordList586](
	[Name] [nvarchar](255) NULL,
	[Type] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RecordList342]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RecordList342](
	[Object Name] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgressReportAH]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgressReportAH](
	[AnalysisId] [int] NULL,
	[SERVERNAME] [nvarchar](128) NULL,
	[DatabaseName] [nvarchar](128) NULL,
	[StartDateTime] [datetime] NULL,
	[CompleteDateTime] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgressReport]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgressReport](
	[AnalysisId] [int] NULL,
	[SERVERNAME] [nvarchar](128) NULL,
	[DatabaseName] [nvarchar](128) NULL,
	[StartDateTime] [datetime] NULL,
	[CompleteDateTime] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SQLPromptInvalidObjects1]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQLPromptInvalidObjects1](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Database] [nvarchar](255) NULL,
	[Type] [nvarchar](255) NULL,
	[Object name] [nvarchar](255) NULL,
	[Reason invalid] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SQLPromptInvalidObjects]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQLPromptInvalidObjects](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Database] [nvarchar](255) NULL,
	[Type] [nvarchar](255) NULL,
	[Object name] [nvarchar](255) NULL,
	[Reason invalid] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 06/02/2016 18:52:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Split]
(
	@RowData nvarchar(max),
	@SplitOn nvarchar(5)
)  
RETURNS @RtnValue table 
(
	Id int identity(1,1),
	Data nvarchar(max)
) 
AS  
BEGIN 
	Declare @Cnt int
	Set @Cnt = 1

	While (Charindex(@SplitOn,@RowData)>0)
	Begin
		Insert Into @RtnValue (data)
		Select 
			Data = ltrim(rtrim(Substring(@RowData,1,Charindex(@SplitOn,@RowData)-1)))
		Set @RowData = Substring(@RowData,Charindex(@SplitOn,@RowData)+1,len(@RowData))
		Set @Cnt = @Cnt + 1
	End
	
	Insert Into @RtnValue (data)
	Select Data = @RowData

	Return
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetObjectScript]    Script Date: 06/02/2016 18:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetObjectScript]
	@DBName AS VARCHAR(20),
	@ObjectName AS NVARCHAR(255)
AS
  BEGIN
	DECLARE @SQL AS NVARCHAR(300)
	DECLARE @statement AS VARCHAR(8000)
	
	SET @SQL='sp_helptext ' + @ObjectName 
	 
	EXEC ('USE '+@DBName)
	EXEC dbo.Sp_executesql @statement = @SQL
        
    SELECT @statement
    
END
GO
/****** Object:  UserDefinedFunction [dbo].[RemoveComments_Old]    Script Date: 06/02/2016 18:52:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Umesh Kumar>
-- Create date: <04/18/2012,>
-- Description:	<RemoveComments>
-- =============================================
CREATE FUNCTION [dbo].[RemoveComments_Old]
(
	@input varchar(max)
)
RETURNS varchar(max)
AS
BEGIN
declare @definition varchar(max),
        @objectname varchar(255),
        @vbCrLf     CHAR(2)
SET @vbCrLf = CHAR(13) + CHAR(10)  
      
--SET @objectname = 'load_CHRGS01D_Invoices_Main'
select @definition = @input + ' GO ' + @vbcrlf 
--select @definition = definition + 'GO' + @vbcrlf from [AHS-Care03].TranDHPS.sys.sql_modules where [object_id] = object_id(@objectname)

--'objective: strip out comments.
--first loop is going to look for pairs of '/*' and '*/',  and STUFF them with empty space.
--second loop is going to look for sets of '--' and vbCrLf and STUFF them with empty space.
  
 --===== Replace all '/*' and '*/' pairs with nothing
 ---- Old Code for multi line comment removed.

  WHILE CHARINDEX('/*',@definition) > 0
	SELECT @definition = STUFF(@definition,
                            CHARINDEX('/*',@definition),
                            CHARINDEX('*/',@definition) - CHARINDEX('/*',@definition) + 2, --2 is the length of the search term 
                            '')

---- New Code for multi line comment removed.
 --SELECT @definition = dbo.RemoveMultiLineComments(@definition)

---===== Replace all single line comments
-- New Code for Single line comment removed.
  WHILE CHARINDEX('--',@definition) > 0 
    AND CHARINDEX(@vbCrLf,@definition,CHARINDEX('--',@definition)) > CHARINDEX('--',@definition)
 SELECT @definition = STUFF(@definition,
                            CHARINDEX('--',@definition),
                            CHARINDEX(@vbCrLf,@definition,CHARINDEX('--',@definition)) - CHARINDEX('--',@definition) + 2,
                            '')
 
--declare @Id as int 
--set @Id=1
--Declare @MaxId as int

--Declare @tbl_sp_Text as table ( id int identity(1,1),sp_text varchar(Max))

--insert into @tbl_sp_Text
--select Data from dbo.Split(@definition,Char(10)) 

--select @MaxId = Max(id) from @tbl_sp_Text
----select * from #tbl_sp_no_comments

--set @definition=''
--WHILE @Id <= @maxID
--Begin
--	declare @stringTxt as varchar(max) 
--	set @stringTxt=''
--	select @stringTxt = sp_text from @tbl_sp_Text where id =@Id
--	if(substring(Ltrim(Rtrim(replace(@stringTxt,char(9),''))),1,2)<>'--')
--		begin
--			--print @stringTxt
--			set @definition=@definition+@stringTxt + Char(13)
--		end
	
--	set @Id =@Id+1
--End
  
--print @definition --you can now search this without false positives from comments.

return  @definition	
END
GO
/****** Object:  Table [dbo].[MEMO03D]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MEMO03D](
	[FacilityCode] [nvarchar](4000) NULL,
	[AccountNumber] [nvarchar](4000) NULL,
	[MedicalRecordNumber] [nvarchar](4000) NULL,
	[PostDate] [nvarchar](4000) NULL,
	[PostTime] [nvarchar](4000) NULL,
	[UserID] [nvarchar](4000) NULL,
	[MemoDestination] [nvarchar](4000) NULL,
	[MemoType] [nvarchar](4000) NULL,
	[MemoCode] [nvarchar](4000) NULL,
	[MemoMessage] [nvarchar](4000) NULL,
	[SequenceNumber] [nvarchar](4000) NULL,
	[EarliestServiceFromDate] [nvarchar](4000) NULL,
	[InvoiceNumber] [nvarchar](4000) NULL,
	[FileLogId] [bigint] NULL,
	[FileDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t1]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t1](
	[r] [int] NULL,
	[OName] [sysname] NOT NULL,
	[otype] [char](2) NULL,
	[SelectFrom] [varchar](20) NULL,
	[dlist] [varchar](2000) NULL,
	[tcount] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RunId] [int] NOT NULL,
	[ServerName] [varchar](100) NOT NULL,
	[DatabaseName] [varchar](100) NOT NULL,
	[ObjectName] [varchar](100) NOT NULL,
	[ObjectType] [varchar](5) NOT NULL,
	[TxtObj] [varbinary](50) NULL,
	[TxtObjNoComments] [varbinary](50) NULL,
	[TxtObjNoWhiteSpace] [varbinary](50) NULL,
	[Tbl] [int] NULL,
	[TblSortbyColumnName] [int] NULL,
	[ObjectDefination] [varchar](max) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[RemoveWhiteSpace]    Script Date: 06/02/2016 18:52:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[RemoveWhiteSpace]
(
	@input nvarchar(max)
)
RETURNS nvarchar(max)
AS
BEGIN
DECLARE @charid tinyint
set @charid=0
/*remove all non-printable characters 0x00 to 0x20 */	

-- Remove semocolon from script.
--SELECT ASCII(';')
set @input=REPLACE(@input,char(59),'')
while @charid<= 32
begin
	set @input=REPLACE(@input,char(@charid),'')
	set @charid=@charid+1
end 

return Upper(@input)	

END
GO
/****** Object:  Table [dbo].[UDFTestTable]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UDFTestTable](
	[Col1] [int] NULL,
	[Col2] [nvarchar](10) NULL
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[usp_CreateSynonyms]    Script Date: 06/02/2016 18:52:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_CreateSynonyms] @BaseServerName      NVARCHAR(100),    
                                           @BaseDatabaseName    NVARCHAR(100),    
                                           @SynonymDatabaseName NVARCHAR(100) = NULL,    
                                           @Exec                INT = 1    
AS    
  BEGIN    
      -- 1/12/2010 db - Added transactions and forced rollback on encountering an error     
         
      SET NOCOUNT ON    
      SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

      DECLARE @TargetSchema NVARCHAR(50)    
      DECLARE @TABLE_CATALOG NVARCHAR(50)    
      DECLARE @TABLE_SCHEMA NVARCHAR(50)    
      DECLARE @TABLE_NAME NVARCHAR(50)    
      DECLARE @TABLE_TYPE NVARCHAR(50)    
      DECLARE @SQLstring NVARCHAR(MAX)    
      DECLARE @Output NVARCHAR(MAX)    
      DECLARE @PrintOutput NVARCHAR(max)    
      DECLARE @Header NVARCHAR(MAX)    
      DECLARE @Trailer NVARCHAR(MAX)    
      DECLARE @FinalOutput TABLE    
        (    
           Id        INT IDENTITY(1, 1),    
           strOutput NVARCHAR(MAX)    
        )    
     
     IF Object_Id('TempDB..#InfoSchemaOutputIn') IS NOT NULL    
		DROP TABLE #InfoSchemaOutputIn 
		 
     CREATE TABLE #InfoSchemaOutputIn     
        (    
           TABLE_CATALOG NVARCHAR(128), 
           TABLE_SCHEMA NVARCHAR(128), 
           TABLE_NAME NVARCHAR(128), 
           TABLE_TYPE  VARCHAR(10)               
        )             
      -- =====================================================================      
      IF ISNULL(@SynonymDatabaseName, '') = ''    
        SET @SynonymDatabaseName = @BaseDatabaseName    
    
      SET @TargetSchema = 'dbo'    
      SET @Output = ''    
      --SET @FinalOutput = ''      
      -- =====================================================================      
      -- =============== Cursor Source Query =================================      
        
      SET @SQLstring = 'INSERT INTO #InfoSchemaOutputIn    
	   SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE      
	   FROM [' + @BaseServerName + '].[' + @BaseDatabaseName + '].'    
			  + 'Information_Schema.Tables      
	   WHERE TABLE_NAME NOT IN (''dtproperties'',''sysdiagrams'')      
		AND TABLE_NAME NOT LIKE ''%_defrag''      
		AND TABLE_NAME NOT LIKE ''%_fragidx''      
	   ORDER BY TABLE_TYPE, TABLE_NAME'    
    
      EXEC sp_executeSQL    
        @SQLstring    
    
      -- =====================================================================      
      --SET XACT_ABORT ON   -- Automatically rollback transaction on error      
      --SET LOCK_TIMEOUT 0   -- Don''t wait, return error immediately      
      --SET DEADLOCK_PRIORITY LOW -- Specifies this session will be the deadlock victim      
      -- =============== Setup the environment ===============================      
      INSERT INTO @FinalOutput    
                  (strOutput)    
      SELECT '      
	  SET ANSI_NULLS ON      
	  SET QUOTED_IDENTIFIER ON      
	  SET XACT_ABORT ON      
	  SET LOCK_TIMEOUT 0       
	  SET DEADLOCK_PRIORITY LOW      
	  '    
    
      SET @Header = '      
	  BEGIN TRY      
	  BEGIN TRAN      
	        
	  '    
      SET @Trailer = '      
	  IF @@TRANCOUNT > 0      
	  COMMIT TRANSACTION; END TRY BEGIN CATCH      
	   IF @@TRANCOUNT > 0      
	   ROLLBACK TRANSACTION;      
	        
	  '    
    
      -- ================== Run ==============================================      
      DECLARE cur CURSOR FOR    
        SELECT TABLE_CATALOG,    
               TABLE_SCHEMA,    
               TABLE_NAME,    
               TABLE_TYPE    
        FROM   #InfoSchemaOutputIn    
        ORDER  BY TABLE_TYPE,    
                  TABLE_NAME    
    
      OPEN cur    
    
      FETCH NEXT FROM cur INTO @TABLE_CATALOG, @TABLE_SCHEMA, @TABLE_NAME, @TABLE_TYPE    
    
      WHILE @@FETCH_STATUS = 0    
        BEGIN    
            IF @Exec = 2    
              BEGIN    
                  SET @Output = @Output + 'IF NOT EXISTS (SELECT * FROM sys.synonyms WHERE name = N'''    
                  SET @Output = @Output + @SynonymDatabaseName + '_' + @TABLE_NAME + ''')' + CHAR(13)    
                  SET @Output = @Output + 'CREATE SYNONYM '    
                  SET @Output = @Output + @TargetSchema + '.'    
                  SET @Output = @Output + '[' + @SynonymDatabaseName + '_' + @TABLE_NAME + ']'    
                  SET @Output = @Output + ' FOR '    
                  SET @Output = @Output + '[' + @BaseServerName + '].'    
                  SET @Output = @Output + '[' + @BaseDatabaseName + '].'    
                  SET @Output = @Output + '[' + @TargetSchema + '].'    
                  SET @Output = @Output + '[' + @TABLE_NAME + ']'    
                  SET @Output = @Output + CHAR(13)    
              END    
            ELSE    
              BEGIN    
                  SET @Output = @Output + 'IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'''    
                  SET @Output = @Output + @SynonymDatabaseName + '_' + @TABLE_NAME + ''')' + CHAR(13)    
                  SET @Output = @Output + 'DROP SYNONYM '    
                  SET @Output = @Output + @TargetSchema + '.'    
                  SET @Output = @Output + '[' + @SynonymDatabaseName + '_' + @TABLE_NAME + ']'    
                  SET @Output = @Output + CHAR(13)    
                  SET @Output = @Output + 'CREATE SYNONYM '    
                  SET @Output = @Output + @TargetSchema + '.'    
                  SET @Output = @Output + '[' + @SynonymDatabaseName + '_' + @TABLE_NAME + ']'    
                  SET @Output = @Output + ' FOR '    
                  SET @Output = @Output + '[' + @BaseServerName + '].'    
                  SET @Output = @Output + '[' + @BaseDatabaseName + '].'    
                  SET @Output = @Output + '[' + @TargetSchema + '].'    
                  SET @Output = @Output + '[' + @TABLE_NAME + ']'    
                  SET @Output = @Output + CHAR(13)    
              END    
    
            SET @PrintOutput = @Output    
            -- Change a single quotes (') to ''      
            SET @PrintOutput = REPLACE(@PrintOutput, CHAR(39),CHAR(39) + CHAR(39))    
            -- Replace the beginning of the line with PRINT '      
            SET @PrintOutput = REPLACE(@PrintOutput, 'IF ', 'PRINT ''IF ')    
            SET @PrintOutput = REPLACE(@PrintOutput, 'DROP ', 'PRINT ''DROP ')    
            SET @PrintOutput = REPLACE(@PrintOutput, 'CREATE ', 'PRINT ''CREATE ')    
            -- Add a single quote to the end of the line      
            SET @PrintOutput = REPLACE(@PrintOutput, CHAR(13), CHAR(39) + CHAR(13))    
    
            -- TODO: Identify any orphaned synonyms and delete those too      
            INSERT INTO @FinalOutput    
                        (strOutput)    
            SELECT @Header + @Output + @Trailer + @PrintOutput + '     
            END CATCH;'    
    
            SET @Output = ''    
            SET @PrintOutput = ''    
    
            FETCH NEXT FROM cur INTO @TABLE_CATALOG, @TABLE_SCHEMA, @TABLE_NAME, @TABLE_TYPE    
        END    
    
      CLOSE cur    
    
      DEALLOCATE cur    
    
      DECLARE @strSQL AS NVARCHAR(max)    
    
      SET @strSQL = ''    
    
      SELECT @strSQL = @strSQL + strOutput    
      FROM   @FinalOutput    
      ORDER  BY Id    
    
      IF @Exec IN ( 1, 2 )    
        EXEC sp_executesql    
          @strSQL    
      ELSE    
        SELECT strOutput    
        FROM   @FinalOutput    
        ORDER  BY Id    
  -- ======== Housekeeping ==============       
      
    DROP TABLE #InfoSchemaOutputIn          
    
SET NOCOUNT OFF
END
GO
/****** Object:  Table [dbo].[trtest]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trtest](
	[Name] [nvarchar](100) NULL,
	[Age] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TranObjectsCountOctober]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TranObjectsCountOctober](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DBName] [nvarchar](255) NULL,
	[Type] [nvarchar](255) NULL,
	[Count] [float] NULL,
	[July] [int] NULL,
	[September] [int] NULL,
	[October] [int] NULL,
	[Active] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tmpRetroAll]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmpRetroAll](
	[FacilityCode] [nvarchar](1000) NULL,
	[PatientAccountNbr] [nvarchar](1000) NULL,
	[AdmitDate] [nvarchar](1000) NULL,
	[PatientType] [nvarchar](1000) NULL,
	[StandardPatientType] [nvarchar](1000) NULL,
	[AdmissionType] [nvarchar](1000) NULL,
	[PatientFirstName] [nvarchar](1000) NULL,
	[PatientLastName] [nvarchar](1000) NULL,
	[PatientPhone] [nvarchar](1000) NULL,
	[PatientDOB] [nvarchar](1000) NULL,
	[PatientGender] [nvarchar](1000) NULL,
	[PatientSSN] [nvarchar](1000) NULL,
	[PatientAddress1] [nvarchar](1000) NULL,
	[PatientAddress2] [nvarchar](1000) NULL,
	[PatientCity] [nvarchar](1000) NULL,
	[PatientState] [nvarchar](1000) NULL,
	[PatientZip] [nvarchar](1000) NULL,
	[GuarantorFirstName] [nvarchar](1000) NULL,
	[GuarantorLastName] [nvarchar](1000) NULL,
	[GuarantorPhone] [nvarchar](1000) NULL,
	[GuarantorSSN] [nvarchar](1000) NULL,
	[GuarantorAddress1] [nvarchar](1000) NULL,
	[GuarantorAddress2] [nvarchar](1000) NULL,
	[GuarantorCity] [nvarchar](1000) NULL,
	[GuarantorState] [nvarchar](1000) NULL,
	[GuarantorZip] [nvarchar](1000) NULL,
	[PrimaryPayerCode] [nvarchar](1000) NULL,
	[PrimaryPayerName] [nvarchar](1000) NULL,
	[PrimaryPayerPlanCode] [nvarchar](1000) NULL,
	[PrimaryPayerGroupNumber] [nvarchar](1000) NULL,
	[PrimaryPayerGroupName] [nvarchar](1000) NULL,
	[PrimaryPayerPolicyNumber] [nvarchar](1000) NULL,
	[SecondaryPayerCode] [nvarchar](1000) NULL,
	[SecondaryPayerName] [nvarchar](1000) NULL,
	[SecondaryPayerPlanCode] [nvarchar](1000) NULL,
	[SecondaryPayerGroupNumber] [nvarchar](1000) NULL,
	[SecondaryPayerGroupName] [nvarchar](1000) NULL,
	[SecondaryPayerPolicyNumber] [nvarchar](1000) NULL,
	[TertiaryPayerCode] [nvarchar](1000) NULL,
	[TertiaryPayerName] [nvarchar](1000) NULL,
	[TertiaryPayerPlanCode] [nvarchar](1000) NULL,
	[TertiaryPayerGroupNumber] [nvarchar](1000) NULL,
	[TertiaryPayerGroupName] [nvarchar](1000) NULL,
	[TertiaryPayerPolicyNumber] [nvarchar](1000) NULL,
	[PrimaryDiagnosis] [nvarchar](1000) NULL,
	[PrimaryProcedure] [nvarchar](1000) NULL,
	[OtherDiagnosis1] [nvarchar](1000) NULL,
	[OtherDiagnosis2] [nvarchar](1000) NULL,
	[OtherDiagnosis3] [nvarchar](1000) NULL,
	[OtherDiagnosis4] [nvarchar](1000) NULL,
	[OtherProcedure1] [nvarchar](1000) NULL,
	[OtherProcedure2] [nvarchar](1000) NULL,
	[OtherProcedure3] [nvarchar](1000) NULL,
	[OtherProcedure4] [nvarchar](1000) NULL,
	[DRG] [nvarchar](1000) NULL,
	[ReferringPhysicianName] [nvarchar](1000) NULL,
	[ReferringPhysicianPhone] [nvarchar](1000) NULL,
	[AdmittingPhysicianName] [nvarchar](1000) NULL,
	[AdmittingPhysicianPhone] [nvarchar](1000) NULL,
	[EncounterOpenBalance] [nvarchar](1000) NULL,
	[EncounterTotalCharges] [nvarchar](1000) NULL,
	[TotalOpenBalance] [nvarchar](1000) NULL,
	[MedicalRecordsNmbr] [nvarchar](1000) NULL,
	[AccountStatus] [nvarchar](1000) NULL,
	[CurrentFinancialClass] [nvarchar](1000) NULL,
	[RegistrationID] [nvarchar](1000) NULL,
	[HospServCode] [nvarchar](1000) NULL,
	[GuarantorDOB] [nvarchar](1000) NULL,
	[PavillionCode] [nvarchar](1000) NULL,
	[ServiceAreaLocation] [nvarchar](1000) NULL,
	[AdmitStatus] [nvarchar](1000) NULL,
	[EncounterInsuranceBalance] [nvarchar](1000) NULL,
	[EncounterPatientBalance] [nvarchar](1000) NULL,
	[VisitCreationDate] [nvarchar](1000) NULL,
	[DischargeDate] [nvarchar](1000) NULL,
	[BillDate] [nvarchar](1000) NULL,
	[MailDate] [nvarchar](1000) NULL,
	[PatientStatementDate] [nvarchar](1000) NULL,
	[PatientStatementNumberCycle] [nvarchar](1000) NULL,
	[CollectionsBadDebtStatus] [nvarchar](1000) NULL,
	[CollectionsAssignmentDate] [nvarchar](1000) NULL,
	[OriginalFinancialClass] [nvarchar](1000) NULL,
	[CurrentPayorPlanCode] [nvarchar](1000) NULL,
	[InsuranceVerificationHoldFlag] [nvarchar](1000) NULL,
	[MedicalRecordsCodingHoldFlag] [nvarchar](1000) NULL,
	[ManualBillHoldFlag] [nvarchar](1000) NULL,
	[OtherBillHoldFlag1] [nvarchar](1000) NULL,
	[OtherBillHoldFlag2] [nvarchar](1000) NULL,
	[OtherBillHoldFlag3] [nvarchar](1000) NULL,
	[OtherBillHoldFlag4] [nvarchar](1000) NULL,
	[ReturnedMailFlag] [nvarchar](1000) NULL,
	[PrimaryPayorEmployer] [nvarchar](1000) NULL,
	[PrimaryPayorSubscriberFirstName] [nvarchar](1000) NULL,
	[PrimaryPayorSubscriberLastName] [nvarchar](1000) NULL,
	[PrimaryPayorRelationship] [nvarchar](1000) NULL,
	[SecondaryPayorEmployer] [nvarchar](1000) NULL,
	[SecondaryPayorSubscriberFirstName] [nvarchar](1000) NULL,
	[SecondaryPayorSubscriberLastName] [nvarchar](1000) NULL,
	[SecondaryPayorRelationship] [nvarchar](1000) NULL,
	[TertiaryPayorEmployer] [nvarchar](1000) NULL,
	[TertiaryPayorSubscriberFirstName] [nvarchar](1000) NULL,
	[TertiaryPayorSubscriberLastName] [nvarchar](1000) NULL,
	[TertiaryPayorRelationship] [nvarchar](1000) NULL,
	[MaritalStatus] [nvarchar](1000) NULL,
	[Religion] [nvarchar](1000) NULL,
	[GuarantorEmail] [nvarchar](1000) NULL,
	[PatientEmail] [nvarchar](1000) NULL,
	[GuarantorEmployer] [nvarchar](1000) NULL,
	[GuarantorEmployerphone] [nvarchar](1000) NULL,
	[PatientEmployer] [nvarchar](1000) NULL,
	[PatientEmployerphone] [nvarchar](1000) NULL,
	[EmergencyContactFirstName] [nvarchar](1000) NULL,
	[EmergencyContactLastName] [nvarchar](1000) NULL,
	[EmergencyContactRelationship] [nvarchar](1000) NULL,
	[EmergencyContactPhone] [nvarchar](1000) NULL,
	[GuarantorDriversLicense] [nvarchar](1000) NULL,
	[GuarantorDriversLicenseState] [nvarchar](1000) NULL,
	[PatientDriversLicense] [nvarchar](1000) NULL,
	[PatientDriversLicenseState] [nvarchar](1000) NULL,
	[PatientRace] [nvarchar](1000) NULL,
	[GuarantorRace] [nvarchar](1000) NULL,
	[ContestedAmount] [nvarchar](1000) NULL,
	[ClinicalComments] [nvarchar](1000) NULL,
	[ExpireDate] [nvarchar](1000) NULL,
	[GuarantorID] [nvarchar](1000) NULL,
	[GuarantorRelationship] [nvarchar](1000) NULL,
	[CollectionAgencyCode] [nvarchar](1000) NULL,
	[TotalEncounterPayments] [nvarchar](1000) NULL,
	[TotalEncounterAdjustments] [nvarchar](1000) NULL,
	[MostRecentNote] [nvarchar](1000) NULL,
	[UserDefinedField1] [nvarchar](1000) NULL,
	[UserDefinedField2] [nvarchar](1000) NULL,
	[UserDefinedField3] [nvarchar](1000) NULL,
	[UserDefinedField4] [nvarchar](1000) NULL,
	[UserDefinedField5] [nvarchar](1000) NULL,
	[UserDefinedField6] [nvarchar](1000) NULL,
	[UserDefinedField7] [nvarchar](1000) NULL,
	[UserDefinedField8] [nvarchar](1000) NULL,
	[UserDefinedField9] [nvarchar](1000) NULL,
	[UserDefinedField10] [nvarchar](1000) NULL,
	[MPPIndicator] [nvarchar](1000) NULL,
	[LastMPPPayementDate] [nvarchar](1000) NULL,
	[LastMPPPaymentAmount] [nvarchar](1000) NULL,
	[EncounterUnbilledAmount] [nvarchar](1000) NULL,
	[HIMSystemGroupNbr] [nvarchar](1000) NULL,
	[SecondaryAccountIdentifier] [nvarchar](1000) NULL,
	[FileLogId] [bigint] NULL,
	[FileDate] [datetime] NULL,
	[id] [bigint] NOT NULL,
	[dataStatus] [int] NULL,
	[dataStatusDescription] [nvarchar](max) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tmpResults]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmpResults](
	[ServerName] [varchar](100) NOT NULL,
	[DatabaseClass] [int] NOT NULL,
	[DatabaseName] [varchar](100) NOT NULL,
	[ObjectName] [varchar](100) NOT NULL,
	[ObjectType] [varchar](5) NOT NULL,
	[TxtObjNoWhiteSpace] [varbinary](50) NULL,
	[TotalObjects] [int] NULL,
	[TotalVariant] [int] NULL,
	[VariantRank] [int] NULL,
	[DBList] [varchar](max) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[testvik]    Script Date: 06/02/2016 18:52:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[testvik]
AS
BEGIN
--SELECT [FacilityCode]
--      ,[PatientAccountNbr]
--      ,[AdmitDate]
--      ,[PatientType]
--      ,[StandardPatientType]
--      ,[AdmissionType]
--      ,[PatientFirstName]
--      ,[PatientLastName]
--      ,[PatientPhone]
--      ,[PatientDOB]
--      ,[PatientGender]
--      ,[PatientSSN]
--      ,[PatientAddress1]
--      ,[PatientAddress2]
--      ,[PatientCity]
--      ,[PatientState]
--      ,[PatientZip]
--      ,[GuarantorFirstName]
--      ,[GuarantorLastName]
--      ,[GuarantorPhone]
--      ,[GuarantorSSN]
--      ,[GuarantorAddress1]
--      ,[GuarantorAddress2]
--      ,[GuarantorCity]
--      ,[GuarantorState]
--      ,[GuarantorZip]
--      ,[PrimaryPayerCode]
--      ,[PrimaryPayerName]
--      ,[PrimaryPayerPlanCode]
--      ,[PrimaryPayerGroupNumber]
--      ,[PrimaryPayerGroupName]
--      ,[PrimaryPayerPolicyNumber]
--      ,[SecondaryPayerCode]
--      ,[SecondaryPayerName]
--      ,[SecondaryPayerPlanCode]
--      ,[SecondaryPayerGroupNumber]
--      ,[SecondaryPayerGroupName]
--      ,[SecondaryPayerPolicyNumber]
--      ,[TertiaryPayerCode]
--      ,[TertiaryPayerName]
--      ,[TertiaryPayerPlanCode]
--      ,[TertiaryPayerGroupNumber]
--      ,[TertiaryPayerGroupName]
--      ,[TertiaryPayerPolicyNumber]
--      ,[PrimaryDiagnosis]
--      ,[PrimaryProcedure]
--      ,[OtherDiagnosis1]
--      ,[OtherDiagnosis2]
--      ,[OtherDiagnosis3]
--      ,[OtherDiagnosis4]
--      ,[OtherProcedure1]
--      ,[OtherProcedure2]
--      ,[OtherProcedure3]
--      ,[OtherProcedure4]
--      ,[DRG]
--      ,[ReferringPhysicianName]
--      ,[ReferringFacilityPhysicianID]
--      ,[AdmittingPhysicianName]
--      ,[AdmittingFacilityPhysicianID]
--      ,[AttendingPhysicianName]
--      ,[AttendingFacilityPhysicianID]
--      ,[Family_PCP_PhysicianName]
--      ,[Family_PCP_FacilityPhysicianID]
--      ,[EncounterOpenBalance]
--      ,[EncounterTotalCharges]
--      ,[TotalOpenBalance]
--      ,[MedicalRecordsNmbr]
--      ,[AccountStatus]
--      ,[CurrentFinancialClass]
--      ,[RegistrationID]
--      ,[HospServCode]
--      ,[GuarantorDOB]
--      ,[PavillionCode]
--      ,[ServiceAreaLocation]
--      ,[AdmitStatus]
--      ,[EncounterInsuranceBalance]
--      ,[EncounterPatientBalance]
--      ,[VisitCreationDate]
--      ,[DischargeDate]
--      ,[BillDate]
--      ,[MailDate]
--      ,[PatientStatementDate]
--      ,[PatientStatementNumberCycle]
--      ,[CollectionsBadDebtStatus]
--      ,[CollectionsAssignmentDate]
--      ,[OriginalFinancialClass]
--      ,[CurrentPayorPlanCode]
--      ,[InsuranceVerificationHoldFlag]
--      ,[MedicalRecordsCodingHoldFlag]
--      ,[ManualBillHoldFlag]
--      ,[OtherBillHoldFlag1]
--      ,[OtherBillHoldFlag2]
--      ,[OtherBillHoldFlag3]
--      ,[OtherBillHoldFlag4]
--      ,[ReturnedMailFlag]
--      ,[PrimaryPayorEmployer]
--      ,[PrimaryPayorSubscriberFirstName]
--      ,[PrimaryPayorSubscriberLastName]
--      ,[PrimaryPayorRelationship]
--      ,[SecondaryPayorEmployer]
--      ,[SecondaryPayorSubscriberFirstName]
--      ,[SecondaryPayorSubscriberLastName]
--      ,[SecondaryPayorRelationship]
--      ,[TertiaryPayorEmployer]
--      ,[TertiaryPayorSubscriberFirstName]
--      ,[TertiaryPayorSubscriberLastName]
--      ,[TertiaryPayorRelationship]
--      ,[MaritalStatus]
--      ,[Religion]
--      ,[GuarantorEmail]
--      ,[PatientEmail]
--      ,[GuarantorEmployer]
--      ,[GuarantorEmployerphone]
--      ,[PatientEmployer]
--      ,[PatientEmployerphone]
--      ,[EmergencyContactFirstName]
--      ,[EmergencyContactLastName]
--      ,[EmergencyContactRelationship]
--      ,[EmergencyContactphone]
--      ,[GuarantorDriversLicense]
--      ,[GuarantorDriversLicenseState]
--      ,[PatientDriversLicense]
--      ,[PatientDriversLicenseState]
--      ,[PatientRace]
--      ,[GuarantorRace]
--      ,[ContestedAmount]
--      ,[ClinicalComments]
--      ,[ExpireDate]
--      ,[GuarantorID]
--      ,[GuarantorRelationship]
--      ,[CollectionAgencyCode]
--      ,[TotalEncounterPayments]
--      ,[TotalEncounterAdjustments]
--      ,[MostRecentNote]
--      ,[FileLogId]
--      ,[ValidationErrors]
--      ,[FileDate]
--      ,[LoadDate]
--      ,[Id]
--      ,[Hash]
--      ,[LoadType]
--      ,[SendApplication]
--      ,[ReceiveApplication]
--      ,[MessageDateTime]
--      ,[MessageType]
--      ,[EventCode]
--      ,[MessageControlID]
--      ,[MessageVersionID]
--      ,[QuickRegStatus]
--  FROM [AHS-A2ASTG01].[HL7StageA116].[dbo].[VW_PROD_STAGE_HL7_BELIG06D]
--GO



SELECT 1
END
GO
/****** Object:  Table [dbo].[tempCategoryOriginal]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tempCategoryOriginal](
	[servername] [varchar](100) NOT NULL,
	[objectname] [varchar](100) NOT NULL,
	[databasename] [varchar](100) NOT NULL,
	[ObjectType] [varchar](5) NOT NULL,
	[TxtObj] [int] NULL,
	[ObjCount] [int] NULL,
	[v] [bigint] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tempCategory]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tempCategory](
	[servername] [varchar](100) NOT NULL,
	[objectname] [varchar](100) NOT NULL,
	[databasename] [varchar](100) NOT NULL,
	[ObjectType] [varchar](5) NOT NULL,
	[TxtObjNoWhiteSpace] [int] NULL,
	[ObjCount] [int] NULL,
	[v] [bigint] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Temp3]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Temp3](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RunId] [int] NOT NULL,
	[ServerName] [varchar](100) NOT NULL,
	[DatabaseName] [varchar](100) NOT NULL,
	[ObjectName] [varchar](100) NOT NULL,
	[ObjectType] [varchar](5) NOT NULL,
	[TxtObj] [varbinary](50) NULL,
	[TxtObjNoComments] [varbinary](50) NULL,
	[TxtObjNoWhiteSpace] [varbinary](50) NULL,
	[Tbl] [int] NULL,
	[TblSortbyColumnName] [int] NULL,
	[ObjectDefination] [varchar](max) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[temp2]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[temp2](
	[RunId] [int] NOT NULL,
	[Id] [int] NOT NULL,
	[ServerName] [varchar](100) NOT NULL,
	[DatabaseName] [varchar](100) NOT NULL,
	[ObjectName] [varchar](100) NOT NULL,
	[TxtObj] [varbinary](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Temp1]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Temp1](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RunId] [int] NOT NULL,
	[ServerName] [varchar](100) NOT NULL,
	[DatabaseName] [varchar](100) NOT NULL,
	[ObjectName] [varchar](100) NOT NULL,
	[ObjectType] [varchar](5) NOT NULL,
	[TxtObj] [varbinary](50) NULL,
	[TxtObjNoComments] [varbinary](50) NULL,
	[TxtObjNoWhiteSpace] [varbinary](50) NULL,
	[Tbl] [int] NULL,
	[TblSortbyColumnName] [int] NULL,
	[ObjectDefination] [varchar](max) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[temp_products]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[temp_products](
	[productID] [int] NULL,
	[Name] [nvarchar](50) NULL,
	[ProductModelName] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Temp_CategoryCObjects]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Temp_CategoryCObjects](
	[otype] [char](2) NULL,
	[oname] [nvarchar](128) NULL,
	[txtobj] [varbinary](16) NULL,
	[dname] [varchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Temp_CategoryBObjects]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Temp_CategoryBObjects](
	[otype] [char](2) NULL,
	[oname] [nvarchar](128) NULL,
	[txtobj] [varbinary](16) NULL,
	[dname] [varchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Temp_CategoryaObjects]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Temp_CategoryaObjects](
	[otype] [char](2) NULL,
	[oname] [nvarchar](128) NULL,
	[txtobj] [varbinary](16) NULL,
	[dname] [varchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl123]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl123](
	[RunId] [int] NOT NULL,
	[ServerName] [varchar](100) NOT NULL,
	[DatabaseName] [varchar](100) NOT NULL,
	[ObjectName] [varchar](100) NOT NULL,
	[ObjectType] [varchar](5) NOT NULL,
	[TxtObj] [varbinary](50) NULL,
	[TxtObjNoWhiteSpace] [varbinary](50) NULL,
	[Tbl] [int] NULL,
	[TblSortbyColumnName] [int] NULL,
	[ObjectDefination] [varchar](max) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ServerDatabases]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServerDatabases](
	[DatabaseId] [int] IDENTITY(1,1) NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[ServerId] [int] NOT NULL,
	[DatabaseClass] [int] NOT NULL,
	[IsGold] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ServerClass]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ServerClass](
	[ClassId] [int] IDENTITY(1,1) NOT NULL,
	[ServerClass] [varchar](10) NOT NULL,
	[TotalCount] [int] NULL,
 CONSTRAINT [PK_ServerClass] PRIMARY KEY CLUSTERED 
(
	[ClassId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ScriptAllObjectToFiles]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ScriptAllObjectToFiles](
	[rank] [bigint] NULL,
	[ObjectName] [varchar](100) NOT NULL,
	[SelectFrom] [varchar](100) NULL,
	[DatabaseList] [nvarchar](max) NULL,
	[TotalCount] [int] NULL,
	[DatabaseClass] [int] NOT NULL,
	[ServerName] [nvarchar](128) NOT NULL,
	[IsIMH] [varchar](3) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Run]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Run](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [nvarchar](100) NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
 CONSTRAINT [PK_Run] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ResultsCategory]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ResultsCategory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DBClassId] [int] NOT NULL,
	[objectName] [varchar](100) NOT NULL,
	[DatabaseID] [int] NULL,
	[CategoryID] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Results_062620140426]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Results_062620140426](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RunId] [int] NOT NULL,
	[ServerName] [varchar](100) NOT NULL,
	[DatabaseName] [varchar](100) NOT NULL,
	[ObjectName] [varchar](100) NOT NULL,
	[ObjectType] [varchar](5) NOT NULL,
	[TxtObj] [varbinary](50) NULL,
	[TxtObjNoComments] [varbinary](50) NULL,
	[TxtObjNoWhiteSpace] [varbinary](50) NULL,
	[Tbl] [int] NULL,
	[TblSortbyColumnName] [int] NULL,
	[ObjectDefination] [varchar](max) NULL,
 CONSTRAINT [PK_Results] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Results_030120150730]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Results_030120150730](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RunId] [int] NOT NULL,
	[ServerName] [varchar](100) NOT NULL,
	[DatabaseName] [varchar](100) NOT NULL,
	[ObjectName] [varchar](200) NOT NULL,
	[ObjectType] [varchar](5) NOT NULL,
	[TxtObj] [varbinary](50) NULL,
	[TxtObjNoComments] [varbinary](50) NULL,
	[TxtObjNoWhiteSpace] [varbinary](50) NULL,
	[Tbl] [varbinary](50) NULL,
	[TblSortbyColumnName] [varbinary](50) NULL,
	[ObjectDefination] [varchar](max) NULL,
 CONSTRAINT [PK_Results_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Results]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Results](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RunId] [int] NOT NULL,
	[ServerName] [varchar](100) NOT NULL,
	[DatabaseName] [varchar](100) NOT NULL,
	[ObjectName] [varchar](200) NOT NULL,
	[ObjectType] [varchar](5) NOT NULL,
	[TxtObj] [varbinary](50) NULL,
	[TxtObjNoComments] [varbinary](50) NULL,
	[TxtObjNoWhiteSpace] [varbinary](50) NULL,
	[Tbl] [varbinary](50) NULL,
	[TblSortbyColumnName] [varbinary](50) NULL,
	[ObjectDefination] [varchar](max) NULL,
 CONSTRAINT [PK_Results_2] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ObjectsOnFx]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ObjectsOnFx](
	[objectname] [nvarchar](128) NOT NULL,
	[objectType] [char](2) NOT NULL,
	[selectFrom] [varchar](12) NOT NULL,
	[DatabaseList] [varchar](12) NOT NULL,
	[TotalCount] [int] NOT NULL,
	[ServerName] [varchar](11) NOT NULL,
	[BaseObject] [varchar](1) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ObjectsListForDbSourceLite]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ObjectsListForDbSourceLite](
	[Rank] [int] NULL,
	[objectName] [varchar](250) NULL,
	[objectType] [varchar](10) NULL,
	[selectFrom] [varchar](100) NULL,
	[DatabaseList] [varchar](max) NULL,
	[TotalCount] [int] NULL,
	[serverName] [varchar](250) NULL,
	[BaseObject] [varchar](1) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[objectsDBTypeOne4]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[objectsDBTypeOne4](
	[objectname] [nvarchar](128) NULL,
	[def] [varbinary](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[objectsDBTypeOne3]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[objectsDBTypeOne3](
	[objectname] [nvarchar](128) NULL,
	[def] [varbinary](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[objectsDBTypeOne2]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[objectsDBTypeOne2](
	[objectname] [nvarchar](128) NULL,
	[def] [varbinary](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[objectsDBTypeOne]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[objectsDBTypeOne](
	[objectname] [nvarchar](128) NULL,
	[def] [varbinary](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ObjectNameCategory]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ObjectNameCategory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ObjectName] [nvarchar](128) NOT NULL,
	[CategoryID] [int] NOT NULL,
 CONSTRAINT [PK_ObjectNameCategory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ObjectDrop]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ObjectDrop](
	[ObjectName] [varchar](255) NOT NULL,
	[ObjectType] [varchar](5) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ObjectCounts]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ObjectCounts](
	[SERVERNAME] [varchar](100) NULL,
	[DatabaseName] [varchar](100) NULL,
	[ObjectType] [char](10) NULL,
	[ObjCount] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ObjectCountReport]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ObjectCountReport](
	[AnalysisId] [int] NOT NULL,
	[SERVERNAME] [nvarchar](128) NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[ObjectType] [nchar](2) NOT NULL,
	[ObjCount] [int] NULL,
	[ObjCountActual] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[AnalysisId] ASC,
	[SERVERNAME] ASC,
	[DatabaseName] ASC,
	[ObjectType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[MakeMD5Hash]    Script Date: 06/02/2016 18:52:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[MakeMD5Hash] 
(
	@input nvarchar(max)
)
RETURNS binary(16)
AS
BEGIN
Declare @result binary(16),  @length int
set @length=DATALENGTH(@input)
set @result=0
	if @length<8000
		begin
			set @result=hashbytes('MD5',@input)
		end
	else
		begin
			set @result=hashbytes('MD5',substring(@input,1,3989)+ CAST(checksum(@input) as NCHAR(11)))
			
		end
	
	Return @result
END
GO
/****** Object:  Table [dbo].[HL7_Errors]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HL7_Errors](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[MessageControlID] [nvarchar](1000) NULL,
	[EncounterID] [nvarchar](255) NULL,
	[LoadStatus] [int] NULL,
	[ErrorType] [nvarchar](100) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [idx_HL7_Errors_ID] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GOLDDbObjectsList]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GOLDDbObjectsList](
	[Rank] [int] NULL,
	[objectName] [varchar](250) NULL,
	[objectType] [varchar](10) NULL,
	[selectFrom] [varchar](100) NULL,
	[DatabaseList] [varchar](max) NULL,
	[TotalCount] [int] NULL,
	[serverName] [varchar](250) NULL,
	[BaseObject] [varchar](1) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ObjectCategorization]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ObjectCategorization](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[environmentId] [int] NOT NULL,
	[ServerName] [nvarchar](128) NOT NULL,
	[DBName] [nvarchar](128) NOT NULL,
	[ObjectName] [nvarchar](128) NOT NULL,
	[RunId] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[obj]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[obj](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](2000) NULL,
	[Used] [bit] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NonCompilabileObjects]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NonCompilabileObjects](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DbName] [varchar](100) NOT NULL,
	[ObjectName] [varchar](200) NOT NULL,
	[ObjectType] [varchar](2) NOT NULL,
	[Population] [char](1) NOT NULL,
	[Remarks] [varchar](300) NULL,
 CONSTRAINT [PK_NonCompilabeObjects] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[Mytbl1]    Script Date: 06/02/2016 18:52:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Mytbl1]
(
	@RowData nvarchar(max),
	@SplitOn nvarchar(5)
)  
RETURNS @RtnValue table 
(
	Id int identity(1,1),
	Data nvarchar(max)
) 
AS  
BEGIN 
	Declare @Cnt int
	Set @Cnt = 1

	While (Charindex(@SplitOn,@RowData)>0)
	Begin
		Insert Into @RtnValue (data)
		Select 
			Data = ltrim(rtrim(Substring(@RowData,1,Charindex(@SplitOn,@RowData)-1)))
		Set @RowData = Substring(@RowData,Charindex(@SplitOn,@RowData)+1,len(@RowData))
		Set @Cnt = @Cnt + 1
	End
	
	Insert Into @RtnValue (data)
	Select Data = @RowData

	Return
END
GO
/****** Object:  Table [dbo].[Log]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RunId] [int] NULL,
	[LogDetail] [varchar](2500) NULL,
	[LogDateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Log] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[GetObjectsCount]    Script Date: 06/02/2016 18:52:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 6/8/12
-- Description:	Gets count of objects in database
-- =============================================
CREATE PROCEDURE [dbo].[GetObjectsCount] 
	@AnalysisID INT,
	@ServerName NVARCHAR(128), 
	@DatabaseName NVARCHAR(128),
	@LinkedServerPrefix nchar(3)=N'VDT'
AS
BEGIN
	SET NOCOUNT ON;

DECLARE @sql NVARCHAR(1000)
SET @sql='select ' + convert(varchar(10), @AnalysisID) + ',''' + REPLACE(@ServerName,@LinkedServerPrefix,'') + ''' as ServerName, ''' + @DatabaseName + ''', o.Type, count(1) as objCount
from [' + @ServerName + '].[' + @DatabaseName + '].dbo.sysobjects o
where o.type in (''P'',''V'',''FN'',''IF'',''TF'',''U'',''TR'')
and o.name not in (Select [Name] from ExcludedDbObject )
group by o.type'
EXEC sp_ExecuteSql @sql 
END
GO
/****** Object:  Table [dbo].[Key_ConstraintInfo]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Key_ConstraintInfo](
	[DBNAME] [sysname] NOT NULL,
	[TABLE_NAME] [varchar](250) NULL,
	[TABLE_ID] [int] NULL,
	[Type_DESC] [varchar](50) NULL,
	[Definitions] [varchar](max) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IUAT_TRACE]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IUAT_TRACE](
	[RowNumber] [int] IDENTITY(0,1) NOT NULL,
	[EventClass] [int] NULL,
	[TextData] [ntext] NULL,
	[ApplicationName] [nvarchar](128) NULL,
	[NTUserName] [nvarchar](128) NULL,
	[LoginName] [nvarchar](128) NULL,
	[CPU] [int] NULL,
	[Reads] [bigint] NULL,
	[Writes] [bigint] NULL,
	[Duration] [bigint] NULL,
	[ClientProcessID] [int] NULL,
	[SPID] [int] NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[BinaryData] [image] NULL,
PRIMARY KEY CLUSTERED 
(
	[RowNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IntermediateResults]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IntermediateResults](
	[RunId] [int] NOT NULL,
	[ServerName] [varchar](100) NOT NULL,
	[DatabaseName] [varchar](100) NOT NULL,
	[ObjectName] [varchar](200) NOT NULL,
	[ObjectType] [varchar](5) NOT NULL,
	[TxtObj] [varbinary](50) NULL,
	[TxtObjNoWhiteSpace] [varbinary](50) NULL,
	[Tbl] [varbinary](50) NULL,
	[TblSortbyColumnName] [varbinary](50) NULL,
	[ObjectDefination] [varchar](max) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Analysis].[Analysis]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Analysis].[Analysis](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EnvironmentId] [int] NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
	[Status] [tinyint] NULL,
	[CreatedBy] [varchar](50) NOT NULL,
 CONSTRAINT [PK_AnalysisAnalysis] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ActiveLocations]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActiveLocations](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Environment] [nvarchar](255) NULL,
	[DBClass] [nvarchar](255) NULL,
	[DBName] [nvarchar](255) NULL,
	[FacilityCode] [nvarchar](255) NULL,
	[Server] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ActiveFacilities]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ActiveFacilities](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FacilityName] [char](4) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Analysis].[ActiveFacilities]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Analysis].[ActiveFacilities](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FacilityName] [char](4) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[837_Charges]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[837_Charges](
	[ID] [int] IDENTITY(10000,1) NOT NULL,
	[RegistrationID] [int] NULL,
	[EncounterID] [nvarchar](50) NULL,
	[DateOfService] [datetime] NULL,
	[RevenueCenterCode] [nvarchar](20) NULL,
	[ChargeItemCode] [nvarchar](20) NULL,
	[UB92RevCode] [nvarchar](20) NULL,
	[NumberOfUnits] [int] NULL,
	[TotalCharges] [money] NULL,
	[CPT4HCPCSCode] [nvarchar](20) NULL,
	[OrderingPhysician] [nvarchar](100) NULL,
	[ChargePostingDate] [smalldatetime] NULL,
	[FileDate] [datetime] NULL,
	[FileLogID] [int] NULL,
	[FileName] [nvarchar](100) NULL,
	[ClaimSequence] [int] NULL,
	[Exception] [nvarchar](4000) NULL,
	[Status] [nvarchar](10) NULL,
	[ClaimNumber] [nvarchar](50) NULL,
 CONSTRAINT [PK_837_Charges] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Split]    Script Date: 06/02/2016 18:52:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_Split](@sText  VARCHAR(8000),
                                 @sDelim VARCHAR(20) = ' ')
-- RETURNS @retArray TABLE (idx smallint Primary Key, value varchar(8000))
RETURNS @retArray TABLE (
  idx   SMALLINT,
  value VARCHAR(8000))
AS
  BEGIN
      -- From http://www.sqlmag.com/Articles/ArticleID/21071/21071.html
      ---- debug
      --declare @sText varchar(8000), @sDelim varchar(20)
      ---- declare @retArray TABLE (idx smallint Primary Key, value varchar(8000))
      --declare @retArray TABLE (idx smallint, value varchar(8000))
      --set @sDelim = '|'
      --set @sText = 'P,11|C,4'
      ---- debug
      DECLARE @idx          SMALLINT,
              @value        VARCHAR(8000),
              @bcontinue    BIT,
              @iStrike      SMALLINT,
              @iDelimlength TINYINT

      IF @sDelim = 'Space'
        BEGIN
            SET @sDelim = ' '
        END

      SET @idx = 0
      SET @sText = LTrim(RTrim(@sText))
      SET @iDelimlength = DATALENGTH(@sDelim)
      SET @bcontinue = 1

      IF NOT ( ( @iDelimlength = 0 )
                OR ( @sDelim = 'Empty' ) )
        BEGIN
            WHILE @bcontinue = 1
              BEGIN
                  --If you can find the delimiter in the text, retrieve the first element and
                  --insert it with its index into the return table.
                  IF CHARINDEX(@sDelim, @sText) > 0
                    BEGIN
                        SET @value = SUBSTRING(@sText, 1, CHARINDEX(@sDelim, @sText) - 1)

                        BEGIN
                            INSERT @retArray
                                   (idx,
                                    value)
                            VALUES (@idx,
                                    @value)
                        END

                        --Trim the element and its delimiter from the front of the string.
                        --Increment the index and loop.
                        SET @iStrike = DATALENGTH(@value) + @iDelimlength
                        SET @idx = @idx + 1
                        SET @sText = LTrim(RIGHT(@sText, DATALENGTH(@sText) - @iStrike))
                    END
                  ELSE
                    BEGIN
                        --If you can’t find the delimiter in the text, @sText is the last value in
                        --@retArray.
                        SET @value = @sText

                        BEGIN
                            INSERT @retArray
                                   (idx,
                                    value)
                            VALUES (@idx,
                                    @value)
                        END

                        --Exit the WHILE loop.
                        SET @bcontinue = 0
                    END
              END
        END
      ELSE
        BEGIN
            WHILE @bcontinue = 1
              BEGIN
                  --If the delimiter is an empty string, check for remaining text
                  --instead of a delimiter. Insert the first character into the
                  --retArray table. Trim the character from the front of the string.
                  --Increment the index and loop.
                  IF DATALENGTH(@sText) > 1
                    BEGIN
                        SET @value = SUBSTRING(@sText, 1, 1)

                        BEGIN
                            INSERT @retArray
                                   (idx,
                                    value)
                            VALUES (@idx,
                                    @value)
                        END

                        SET @idx = @idx + 1
                        SET @sText = SUBSTRING(@sText, 2, DATALENGTH(@sText) - 1)
                    END
                  ELSE
                    BEGIN
                        --One character remains.
                        --Insert the character, and exit the WHILE loop.
                        INSERT @retArray
                               (idx,
                                value)
                        VALUES (@idx,
                                @sText)

                        SET @bcontinue = 0
                    END
              END
        END

      --select * from @retArray
      RETURN
  END
GO
/****** Object:  UserDefinedFunction [dbo].[ColumnsUnordered]    Script Date: 06/02/2016 18:52:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[ColumnsUnordered] 
(
	@bitpos tinyint,
	--@cdefault int,
	@collation sysname,
	@collationid int,
	--@colstat smallint,
	@domain int,
	@iscomputed int,
	@isnullable int,
	@isoutparam int,
	@language int,
	@length smallint,
	@name sysname,
	@number smallint,
	@prec smallint,
	@printfmt varchar(255),
	@reserved tinyint,
	@scale int,
	@type tinyint,
	@usertype smallint,
	@xoffset smallint,
	@xprec tinyint,
	@xscale tinyint,
	@xtype tinyint,
	@xusertype smallint
	
)
RETURNS nvarchar(2000)
AS
BEGIN

RETURN 	ISNULL(convert(nvarchar(3),@bitpos),'''')
--+ ISNULL(convert(nvarchar(11),@cdefault),'''')
+ ISNULL(@collation,'''')
+ ISNULL(convert(nvarchar(11),@collationid),'''')
--+ ISNULL(convert(nvarchar(5),@colstat),'''')
+ ISNULL(convert(nvarchar(11),@domain),'''')
+ ISNULL(convert(nvarchar(11),@iscomputed),'''')
+ ISNULL(convert(nvarchar(11),@isnullable),'''')
+ ISNULL(convert(nvarchar(11),@isoutparam),'''')
+ ISNULL(convert(nvarchar(11),@language),'''')
+ ISNULL(convert(nvarchar(5),@length),'''')
+ upper(@name)
+ ISNULL(convert(nvarchar(5),@number),'''')
+ ISNULL(convert(nvarchar(5),@prec),'''')
+ ISNULL(convert(nvarchar(255),@printfmt),'''')
+ ISNULL(convert(nvarchar(3),@reserved),'''')
+ ISNULL(convert(nvarchar(11),@scale),'''')
+ ISNULL(convert(nvarchar(3),@type),'''')
+ ISNULL(convert(nvarchar(5),@usertype),'''')
+ ISNULL(convert(nvarchar(5),@xoffset),'''')
+ ISNULL(convert(nvarchar(3),@xprec),'''')
+ ISNULL(convert(nvarchar(3),@xscale),'''')
+ ISNULL(convert(nvarchar(3),@xtype),'''')
+ ISNULL(convert(nvarchar(5),@xusertype),'''')
END
GO
/****** Object:  UserDefinedFunction [dbo].[ColumnsOrdered]    Script Date: 06/02/2016 18:52:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ColumnsOrdered] 
(
	@bitpos tinyint,
	--@cdefault int,
	@collation sysname,
	@collationid int,
	--@colorder smallint,
	--@colstat smallint,
	@domain int,
	@iscomputed int,
	@isnullable int,
	@isoutparam int,
	@language int,
	@length smallint,
	@name sysname,
	@number smallint,
	--@offset smallint,
	@prec smallint,
	@printfmt varchar(255),
	@reserved tinyint,
	@scale int,
	@type tinyint,
	@usertype smallint,
	@xoffset smallint,
	@xprec tinyint,
	@xscale tinyint,
	@xtype tinyint,
	@xusertype smallint
	
)
RETURNS nvarchar(2000)
AS
BEGIN

RETURN 	ISNULL(convert(nvarchar(3),@bitpos),'''')
--+ ISNULL(convert(nvarchar(11),@cdefault),'''')
+ ISNULL(@collation,'''')
+ ISNULL(convert(nvarchar(11),@collationid),'''')
--+ ISNULL(convert(nvarchar(5),@colorder),'''')
--+ ISNULL(convert(nvarchar(5),@colstat),'''')
+ ISNULL(convert(nvarchar(11),@domain),'''')
+ ISNULL(convert(nvarchar(11),@iscomputed),'''')
+ ISNULL(convert(nvarchar(11),@isnullable),'''')
+ ISNULL(convert(nvarchar(11),@isoutparam),'''')
+ ISNULL(convert(nvarchar(11),@language),'''')
+ ISNULL(convert(nvarchar(5),@length),'''')
+ upper(@name)
+ ISNULL(convert(nvarchar(5),@number),'''')
--+ ISNULL(convert(nvarchar(5),@offset),'''')
+ ISNULL(convert(nvarchar(5),@prec),'''')
+ ISNULL(convert(nvarchar(255),@printfmt),'''')
+ ISNULL(convert(nvarchar(3),@reserved),'''')
+ ISNULL(convert(nvarchar(11),@scale),'''')
+ ISNULL(convert(nvarchar(3),@type),'''')
+ ISNULL(convert(nvarchar(5),@usertype),'''')
+ ISNULL(convert(nvarchar(5),@xoffset),'''')
+ ISNULL(convert(nvarchar(3),@xprec),'''')
+ ISNULL(convert(nvarchar(3),@xscale),'''')
+ ISNULL(convert(nvarchar(3),@xtype),'''')
+ ISNULL(convert(nvarchar(5),@xusertype),'''')
END
GO
/****** Object:  StoredProcedure [dbo].[CheckLinkedServer]    Script Date: 06/02/2016 18:51:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 6/512
-- Description:	Creates Linked server
-- =============================================
CREATE PROCEDURE [dbo].[CheckLinkedServer] 
 @LinkedServerName NVARCHAR(128)
AS
BEGIN
	SET NOCOUNT ON;
DECLARE @ServerName nvarchar(131)
SET @ServerName=REPLACE(@LinkedServerName,'VDT','')
IF  NOT EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = @LinkedServerName)
BEGIN
	EXEC master.dbo.sp_addlinkedserver @server = @LinkedServerName, @srvproduct=N'VDT', @provider=N'SQLNCLI', @datasrc=@ServerName
	EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=@LinkedServerName,@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'collation compatible', @optvalue=N'false'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'data access', @optvalue=N'true'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'dist', @optvalue=N'false'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'pub', @optvalue=N'false'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'rpc', @optvalue=N'false'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'rpc out', @optvalue=N'false'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'sub', @optvalue=N'false'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'connect timeout', @optvalue=N'0'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'collation name', @optvalue=null
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'lazy schema validation', @optvalue=N'false'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'query timeout', @optvalue=N'0'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'use remote collation', @optvalue=N'true'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'remote proc transaction promotion', @optvalue=N'true'
END
END
GO
/****** Object:  Table [dbo].[Category]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Category](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [varchar](50) NOT NULL,
	[Description] [varchar](500) NOT NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CareServers]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CareServers](
	[ServerName] [sysname] NOT NULL,
	[dbname] [sysname] NOT NULL,
	[Serverid] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_FormatHL7Date]    Script Date: 06/02/2016 18:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_FormatHL7Date](@date VARCHAR(50)) 
RETURNS DATETIME 
  BEGIN 
      DECLARE @Result VARCHAR(100) 

      IF Isdate(@date) = 1 
        BEGIN 
            RETURN CONVERT(DATETIME, @date) 
        END 

      IF LEFT(@date, 4) < 1900 
         AND Len(@date) > 0 
        SET @date = '' 

      SET @Result = LEFT(@date, 8) + CASE WHEN Len(@date) > 8 THEN ' ' +Substring(@date, 9, 2) ELSE '' END + CASE WHEN Len(@date) > 10 THEN ':' + 
                    Substring(@date, 11, 2) 
                    ELSE '' END + CASE WHEN Len(@date) > 12 THEN +':' +Substring(@date, 13, 2) ELSE '' END 

      RETURN CONVERT(DATETIME, @Result) 
  END
GO
/****** Object:  UserDefinedFunction [dbo].[IsFileExpected]    Script Date: 06/02/2016 18:52:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    FUNCTION [dbo].[IsFileExpected]
(
@currentDate datetime,
@fileLocationId int
)  
RETURNS char(1)  AS  
begin

declare @retVal char(1)
declare @startDate datetime
declare @frequency char(1)

select @startDate = fl.StartDate, @frequency = f.frequency from fileLocations fl, files f
where f.fileid = fl.fileId 
and fl.fileLocationId = @fileLocationId

if @frequency = 'F' 
begin
	-- if currentDate is a saturday or a sunday, then Not Expected'
	set @retVal = case when datepart("dw",@currentdate) in (7,1) then 'N' else 'M' end
end

else if @frequency = 'D'
begin
	set @retval = 'M'
end

else if @frequency = 'M'
begin
	set @retval= 'N'
end
		

return @retval
END
GO
/****** Object:  Table [dbo].[ExcludedDbObject]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ExcludedDbObject](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](200) NOT NULL,
 CONSTRAINT [PK_ExcludedDbObject] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ExcludedDatabase]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ExcludedDatabase](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](150) NOT NULL,
 CONSTRAINT [PK_ExcludedDatabase] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EvnironmentConfig]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EvnironmentConfig](
	[env] [char](5) NULL,
	[client] [char](4) NULL,
	[DBClass] [varchar](12) NULL,
	[DBName] [sysname] NOT NULL,
	[ServerName] [sysname] NOT NULL,
	[InsertedDate] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[errorLog]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[errorLog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ErrorDescription] [varchar](2048) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Environments]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Environments](
	[EnvironmentId] [int] IDENTITY(1,1) NOT NULL,
	[EnvironmentName] [varchar](200) NOT NULL,
 CONSTRAINT [PK_Environments] PRIMARY KEY CLUSTERED 
(
	[EnvironmentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Analysis].[Environments]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Analysis].[Environments](
	[EnvironmentId] [int] IDENTITY(1,1) NOT NULL,
	[EnvironmentName] [varchar](200) NOT NULL,
 CONSTRAINT [PK_AnalysisEnvironments] PRIMARY KEY CLUSTERED 
(
	[EnvironmentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EnvironmentLocations]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnvironmentLocations](
	[ID] [int] NOT NULL,
	[Code] [nvarchar](20) NULL,
	[Description] [nvarchar](100) NULL,
	[Parent] [int] NULL,
	[ConnectionString] [nvarchar](500) NULL,
	[ServerPath] [nvarchar](50) NULL,
	[Name] [nvarchar](100) NULL,
	[DatabaseName] [nvarchar](50) NULL,
	[active] [int] NOT NULL,
	[EnvironmentId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[Drop_CreateLinkedServer]    Script Date: 06/02/2016 18:51:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 6/512
-- Description:	Drops and creates Linked server
-- =============================================
CREATE PROCEDURE [dbo].[Drop_CreateLinkedServer] 
 @LinkedServerName NVARCHAR(128), @DropAndCreate bit=1 
AS
BEGIN
	SET NOCOUNT ON;
DECLARE @ServerName nvarchar(131)
SET @ServerName=REPLACE(@LinkedServerName,'VDT','')
IF  EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = @LinkedServerName)
	EXEC master.dbo.sp_dropserver @server=@LinkedServerName, @droplogins='droplogins'
IF @DropAndCreate=1
BEGIN
	EXEC master.dbo.sp_addlinkedserver @server = @LinkedServerName, @srvproduct=N'VDT', @provider=N'SQLNCLI', @datasrc=@ServerName
	EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=@LinkedServerName,@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'collation compatible', @optvalue=N'false'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'data access', @optvalue=N'true'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'dist', @optvalue=N'false'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'pub', @optvalue=N'false'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'rpc', @optvalue=N'false'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'rpc out', @optvalue=N'false'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'sub', @optvalue=N'false'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'connect timeout', @optvalue=N'0'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'collation name', @optvalue=null
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'lazy schema validation', @optvalue=N'false'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'query timeout', @optvalue=N'0'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'use remote collation', @optvalue=N'true'
	EXEC master.dbo.sp_serveroption @server=@LinkedServerName, @optname=N'remote proc transaction promotion', @optvalue=N'true'
END
END
GO
/****** Object:  Table [dbo].[DRGDetails]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DRGDetails](
	[RegistrationId] [bigint] NULL,
	[AccountNumber] [nvarchar](50) NULL,
	[DischargeStatus] [nvarchar](50) NULL,
	[TransferLossAmount] [decimal](18, 2) NULL,
	[FinalDRG] [nvarchar](50) NULL,
	[CopiedDate] [datetime] NULL,
	[FileDate] [datetime] NULL,
	[FileLogId] [bigint] NULL,
	[ID] [bigint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[DistinctList]    Script Date: 06/02/2016 18:52:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[DistinctList](@List VARCHAR(MAX),@Delim CHAR)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @ParsedList TABLE (Item VARCHAR(MAX))

    DECLARE @list1 VARCHAR(MAX), @Pos INT, @rList VARCHAR(MAX)

    SET @list = LTRIM(RTRIM(@list)) + @Delim
    SET @pos = CHARINDEX(@delim, @list, 1)

    WHILE @pos > 0
    BEGIN
        SET @list1 = LTRIM(RTRIM(LEFT(@list, @pos - 1)))
        IF @list1 <> ''
        INSERT INTO @ParsedList VALUES (CAST(@list1 AS VARCHAR(MAX)))
        SET @list = SUBSTRING(@list, @pos+1, LEN(@list))
        SET @pos = CHARINDEX(@delim, @list, 1)
    END

    SELECT @rlist = COALESCE(@rlist+',','') + Item
    FROM (SELECT DISTINCT Item FROM @ParsedList) t

    RETURN @rlist
END
GO
/****** Object:  Table [dbo].[DbSourceLiteObjectList]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DbSourceLiteObjectList](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ObjectName] [varchar](300) NULL,
	[ObjectDbName] [varchar](100) NULL,
	[ObjectServerName] [varchar](200) NULL,
	[ObjectType] [varchar](25) NULL,
	[ObjectScript] [varchar](max) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DBServers]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBServers](
	[ServerId] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [nvarchar](128) NOT NULL,
	[EnvironmentId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Analysis].[DBServers]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Analysis].[DBServers](
	[ServerId] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [nvarchar](128) NOT NULL,
	[EnvironmentId] [int] NOT NULL,
 CONSTRAINT [PK_AnalysisDBServers] PRIMARY KEY CLUSTERED 
(
	[ServerId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BuildExeRun]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BuildExeRun](
	[BuildExeRunID] [int] IDENTITY(1,1) NOT NULL,
	[UserNm] [varchar](200) NULL,
	[BuildDt] [datetime] NULL,
	[DBname] [varchar](50) NULL,
	[Servername] [varchar](50) NULL,
 CONSTRAINT [PK_TranBuild] PRIMARY KEY CLUSTERED 
(
	[BuildExeRunID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BadObjectsOctober]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BadObjectsOctober](
	[Database] [nvarchar](255) NULL,
	[Type] [nvarchar](255) NULL,
	[Object name] [nvarchar](255) NULL,
	[Reason invalid] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BadObjectsNovember]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BadObjectsNovember](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Database] [nvarchar](255) NULL,
	[Type] [nvarchar](255) NULL,
	[Object name] [nvarchar](255) NULL,
	[Reason invalid] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BadObjectScanSep2012]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BadObjectScanSep2012](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Database] [nvarchar](255) NULL,
	[Type] [nvarchar](255) NULL,
	[ObjectName] [nvarchar](255) NULL,
	[ReasonInvalid] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BadObjectScanJuly2012]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BadObjectScanJuly2012](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Database] [nvarchar](255) NULL,
	[Type] [nvarchar](255) NULL,
	[ObjectName] [nvarchar](255) NULL,
	[ReasonInvalid] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AP_DEMO]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AP_DEMO](
	[TRANSACTION_ID] [int] IDENTITY(1,1) NOT NULL,
	[Xml_Data] [xml] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TRANSACTION_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AnalysisStatus]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AnalysisStatus](
	[Id] [tinyint] IDENTITY(1,1) NOT NULL,
	[Status] [varchar](50) NOT NULL,
	[Description] [varchar](500) NOT NULL,
 CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Analysis].[AnalysisStatus]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Analysis].[AnalysisStatus](
	[Id] [tinyint] IDENTITY(1,1) NOT NULL,
	[Status] [varchar](50) NOT NULL,
	[Description] [varchar](500) NOT NULL,
 CONSTRAINT [PK_AnalysisStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Analysis].[AnalysisLog]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Analysis].[AnalysisLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AnalysisId] [int] NULL,
	[LogDetail] [varchar](2500) NULL,
	[LogDateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_AnalysisLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DatabaseClass]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DatabaseClass](
	[ClassId] [int] IDENTITY(1,1) NOT NULL,
	[DBClass] [varchar](10) NOT NULL,
	[TotalCount] [int] NULL,
 CONSTRAINT [PK_DatabaseClass] PRIMARY KEY CLUSTERED 
(
	[ClassId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[danVarianceReductionData_201307087_1640]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[danVarianceReductionData_201307087_1640](
	[rank] [bigint] NULL,
	[ObjectName] [varchar](100) NOT NULL,
	[ObjectType] [varchar](5) NOT NULL,
	[SelectFrom] [varchar](100) NULL,
	[DatabaseList] [nvarchar](max) NULL,
	[CountOfObjects] [int] NULL,
	[ServerName] [nvarchar](128) NULL,
	[CountOfDatabases] [int] NULL,
	[AssignedTo] [varchar](200) NULL,
	[RiskLevel] [varchar](200) NULL,
	[ModelSite] [varchar](200) NULL,
	[Comment] [varchar](max) NULL,
	[ReviewerName] [varchar](200) NULL,
	[ReviewerComments] [varchar](max) NULL,
	[Changeset] [varchar](200) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[danVarianceReductionData]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[danVarianceReductionData](
	[rank] [bigint] NULL,
	[ObjectName] [varchar](100) NOT NULL,
	[ObjectType] [varchar](5) NOT NULL,
	[SelectFrom] [varchar](100) NULL,
	[DatabaseList] [nvarchar](max) NULL,
	[CountOfObjects] [int] NULL,
	[ServerName] [nvarchar](128) NULL,
	[CountOfDatabases] [int] NULL,
	[AssignedTo] [varchar](200) NULL,
	[RiskLevel] [varchar](200) NULL,
	[ModelSite] [varchar](200) NULL,
	[Comment] [varchar](max) NULL,
	[ReviewerName] [varchar](200) NULL,
	[ReviewerComments] [varchar](max) NULL,
	[Changeset] [varchar](200) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[ConnectionTest_ReadTableDef]    Script Date: 06/02/2016 18:51:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 6/5/12
-- Description:	Reads Table definition from sys table to confirm connectivity
-- =============================================
CREATE PROCEDURE [dbo].[ConnectionTest_ReadTableDef] 
	-- Add the parameters for the stored procedure here
	@ServerName nvarchar(128), 
	@DatabaseName nvarchar(128),
	@Result varchar(500) OUTPUT
AS
BEGIN
DECLARE @str nvarchar(Max), @ParamDef nvarchar(100)
Set @ParamDef=N'@ResultOut varchar(500) OUTPUT';

Set @str ='select top 1 @ResultOut=o.[Name] + '' of type '' + o.[Type] + '''' from ['+@ServerName+'].[' +  @DatabaseName + '].dbo.sysobjects o
inner join ['+@ServerName+'].[' + @DatabaseName + '].sys.syscolumns c on c.id = o.id where o.type =''U'''
--print @str

Exec sp_ExecuteSql @str, @ParamDef, @ResultOut=@Result OUTPUT
--print @Result
END
GO
/****** Object:  StoredProcedure [dbo].[ConnectionTest_ReadObjectDef]    Script Date: 06/02/2016 18:51:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 6/5/12
-- Description:	Reads Object definition from sys table to confirm connectivity
-- =============================================
CREATE PROCEDURE [dbo].[ConnectionTest_ReadObjectDef] 
	-- Add the parameters for the stored procedure here
	@ServerName nvarchar(128), 
	@DatabaseName nvarchar(128),
	@Result varchar(500) OUTPUT
AS
BEGIN
DECLARE @str nvarchar(Max), @ParamDef nvarchar(100)
Set @ParamDef=N'@ResultOut varchar(500) OUTPUT';

Set @str ='select top 1 @ResultOut=[Name] + '' of type '' + [Type] + '''' from ['+@ServerName+'].[' +  @DatabaseName + '].dbo.sysobjects o
inner join ['+@ServerName+'].[' + @DatabaseName + '].sys.sql_modules c on c.object_id = o.id where o.type in (''P'',''V'',''FN'',''IF'',''TF'',''TR'')'
--print @str

Exec sp_ExecuteSql @str, @ParamDef, @ResultOut=@Result OUTPUT
--print @Result
END
GO
/****** Object:  UserDefinedFunction [dbo].[ConName]    Script Date: 06/02/2016 18:52:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================

--Select dbo.ConName('dbo.fn_InterfaceFileVariance','Stored Procedure','Invalid object name ''sTAGEihil.DBO.VWcISBELIG01D'.)
CREATE FUNCTION [dbo].[ConName]
(
	-- Add the parameters for the function here
	@ObjectName varchar(50),@Type varchar(50),@reasonInvalid varchar(100)
)
RETURNS VARCHAR(4000)
AS
BEGIN
	-- Declare the return variable here
	   DEclare @String As Varchar(4000)
	   
	   SELECT 	 @String  = ISNULL(@String,'') +',' + [Database]
	   FROM   BadObjectScanJuly2012
	   WHERE  objectname = @ObjectName
       and Type =@Type
       aND reasonInvalid = @reasonInvalid
        Return @String
END
GO
/****** Object:  Table [dbo].[Analysis]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Analysis](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EnvironmentId] [int] NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Analysis] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DBServersCare05]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBServersCare05](
	[ServerId] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [nvarchar](128) NOT NULL,
	[EnvironmentId] [int] NOT NULL,
 CONSTRAINT [PK_DBServers] PRIMARY KEY CLUSTERED 
(
	[ServerId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BuildExeRunlog]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BuildExeRunlog](
	[BuildExeRunlogID] [int] IDENTITY(1,1) NOT NULL,
	[BuildExeRunID] [int] NOT NULL,
	[ErrorlogTxt] [varchar](max) NULL,
	[FileNm] [varchar](500) NULL,
	[ObjectNm] [varchar](200) NULL,
 CONSTRAINT [PK_BuildExeRunlog] PRIMARY KEY CLUSTERED 
(
	[BuildExeRunlogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[fn_IsNonCompilableObject]    Script Date: 06/02/2016 18:52:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[fn_IsNonCompilableObject]
(	
	@ObjectName Varchar(200) 
)
RETURNS VARCHAR(10)
AS
BEGIN
	 DECLARE @Value VARCHAR(10)
	 
    select @Value = case when count(objectname)>0 then 'Y' else 'N' end 
		from NonCompilabileObjects
		where objectName =@ObjectName 
		
	RETURN @Value		
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_IsBadObjectScanJuly2012]    Script Date: 06/02/2016 18:52:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_IsBadObjectScanJuly2012]
(	
	@ObjectName Varchar(200) 
)
RETURNS VARCHAR(10)
AS
BEGIN
	 DECLARE @Value VARCHAR(10)
	 
    select @Value = case when count(objectname)>0 then 'Y' else 'N' end 
		from [BadObjectScanJuly2012]
		where replace([ObjectName],'dbo.','') =@ObjectName 
		
	RETURN @Value		
END
GO
/****** Object:  StoredProcedure [Analysis].[InsertLogDetails]    Script Date: 06/02/2016 18:51:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 5/15/2012
-- Description:	Inserts record into AnalysisLog
-- =============================================
CREATE PROCEDURE [Analysis].[InsertLogDetails]
	@AnalysisId int,
	@LogDetail varchar(2500)
AS
BEGIN
	SET NOCOUNT ON;
insert into  Analysis.AnalysisLog ( AnalysisId,LogDetail) values (@AnalysisId,@LogDetail)
END
GO
/****** Object:  StoredProcedure [dbo].[GetLastAnalysisInfo]    Script Date: 06/02/2016 18:52:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 6/14/12
-- Description:	Gets Information of last database analysis
-- =============================================
CREATE PROCEDURE [dbo].[GetLastAnalysisInfo] 
@db nvarchar(128)
AS
BEGIN
	SET NOCOUNT ON;
select top 1 * from dbo.ProgressReport
where Databasename=@db and CompleteDatetime is not null
union
select top 1 * from dbo.ProgressReportAH
where Databasename=@db and CompleteDatetime is not null
order by CompleteDatetime
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetDeletedHashObject]    Script Date: 06/02/2016 18:52:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[GetDeletedHashObject] 
(
	@objectname sysname
)
RETURNS varbinary(50)
AS
BEGIN
Declare @hash varbinary(50)
select @hash= TxtObjNoWhiteSpace 
from (	select top 2 TxtObjNoWhiteSpace from results where databasename=
			(select top 1 databasename from results where objectname=@objectname and objectdefination ='DELETED')  
		and objectname=@objectname 
order by runid desc) y
where TxtObjNoWhiteSpace is not null
return @hash
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetBadObjectsList]    Script Date: 06/02/2016 18:52:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 4/29/2012
-- Description:	Gets latest version of objects across all runs
-- =============================================
Create FUNCTION [dbo].[GetBadObjectsList]
(	
)
RETURNS TABLE 
AS
RETURN 
(
select distinct objectname 
from NonCompilabileObjects
where dbname='BaseTran'
union 
SELECT distinct replace([ObjectName],'dbo.','')
FROM [BadObjectScanJuly2012]
--where left([Object name],4)='dbo.'
)
GO
/****** Object:  UserDefinedFunction [dbo].[LastVersionTables]    Script Date: 06/02/2016 18:52:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 4/29/2012
-- Description:	Gets latest version of objects across all runs
-- =============================================
-- =============================================
-- Updated By: Umesh Kumar
-- Updated Date : 08/20/2012
-- Desc: Added column ObjectDefination in select statement.	
-- =============================================
CREATE FUNCTION [dbo].[LastVersionTables]
(	
)
RETURNS TABLE 
AS
RETURN 
(
with LastRun as (select ServerName, DatabaseName, ObjectName,  MAX(runid) MaxRunId
from Results with (NOLOCK) 
where objecttype='u' and RunId in ( select ID from Run with (NOLOCK) where EndTime is not null)
and DatabaseName not in (Select [name] from dbo.excludeddatabase)
group by ServerName, DatabaseName, ObjectName)

 select r.ServerName, r.DatabaseName, r.ObjectName, r.tbl, r.TblSortbyColumnName, r.runid,r.ObjectType, ObjectDefination
from Results r with (NOLOCK) 
inner join LastRun l on r.ServerName=l.ServerName and r.DatabaseName=l.DatabaseName and r.ObjectName=l.ObjectName and r.RunId=l.MaxRunId
inner join dbo.DBServers ds on ds.ServerName=l.ServerName
inner join dbo.ServerDatabases sd on sd.DatabaseName=l.DatabaseName
where objecttype='u' and ds.ServerId=sd.ServerId and ObjectDefination<> 'DELETED'

)
GO
/****** Object:  UserDefinedFunction [dbo].[LastVersionOfAnObject]    Script Date: 06/02/2016 18:52:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Viktor Misyutin  
-- Create date: 10/3/2012  
-- Description: Gets latest version of an object across all runs  
-- =============================================  
CREATE FUNCTION [dbo].[LastVersionOfAnObject]  
(   
 @objName nvarchar(128),  
 @dbname nvarchar(128)  
)  
RETURNS TABLE   
AS  
RETURN   
(  
with LastRun as (select ServerName, DatabaseName, ObjectName,  MAX(runid) MaxRunId  
from Results with (NOLOCK)   
where objecttype<>'U' and RunId in ( select ID from Run with (NOLOCK) where EndTime is not null)  
and DatabaseName not in (Select [name] from dbo.excludeddatabase)  
--and [ObjectName] like @objName +'%'  
and [ObjectName] = @objName 
and  databasename like @dbname + '%'  
group by ServerName, DatabaseName, ObjectName)  
  
 select r.ServerName, r.DatabaseName, r.ObjectName, r.TxtObj, r.TxtObjNoWhiteSpace, r.runid,r.ObjectType,ObjectDefination  
from Results r with (NOLOCK)   
inner join LastRun l on r.ServerName=l.ServerName and r.DatabaseName=l.DatabaseName and r.ObjectName=l.ObjectName and r.RunId=l.MaxRunId  
inner join dbo.DBServers ds with (NOLOCK) on ds.ServerName=l.ServerName  
inner join dbo.ServerDatabases sd with (NOLOCK)on sd.DatabaseName=l.DatabaseName  
where objecttype<>'U' and ds.ServerId=sd.ServerId  
)
GO
/****** Object:  UserDefinedFunction [dbo].[LastVersionObjects]    Script Date: 06/02/2016 18:52:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 4/29/2012
-- Description:	Gets latest version of objects across all runs
-- =============================================
CREATE FUNCTION [dbo].[LastVersionObjects]
(	
)
RETURNS TABLE 
AS
RETURN 
(
with LastRun as (select ServerName, DatabaseName, ObjectName,  MAX(runid) MaxRunId
from Results with (NOLOCK) 
where objecttype<>'U' and RunId in ( select ID from Run with (NOLOCK) where EndTime is not null)
and DatabaseName not in (Select [name] from dbo.excludeddatabase)
group by ServerName, DatabaseName, ObjectName)

 select r.ServerName, r.DatabaseName, r.ObjectName, r.TxtObj, r.TxtObjNoWhiteSpace, r.runid,r.ObjectType,ObjectDefination,sd.DatabaseClass 
from Results r with (NOLOCK) 
inner join LastRun l on r.ServerName=l.ServerName and r.DatabaseName=l.DatabaseName and r.ObjectName=l.ObjectName and r.RunId=l.MaxRunId
inner join dbo.DBServers ds with (NOLOCK) on ds.ServerName=l.ServerName
inner join dbo.ServerDatabases sd with (NOLOCK)on sd.DatabaseName=l.DatabaseName
where objecttype<>'U' and ds.ServerId=sd.ServerId and ObjectDefination<> 'DELETED'

)
GO
/****** Object:  UserDefinedFunction [dbo].[Mytbl]    Script Date: 06/02/2016 18:52:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Mytbl]
(	
)
RETURNS TABLE 
AS
RETURN 
(
	with LastRun as (select ServerName, DatabaseName, ObjectName,  MAX(runid) MaxRunId
	from Results with (NOLOCK) 
	where objecttype<>'U' and RunId in ( select ID from Run with (NOLOCK) where EndTime is not null)
	group by ServerName, DatabaseName, ObjectName)

	 select r.ServerName, r.DatabaseName, r.ObjectName, r.TxtObj, r.TxtObjNoWhiteSpace, r.runid,r.ObjectType,ObjectDefination
	from Results r with (NOLOCK) 
	inner join LastRun l on r.ServerName=l.ServerName and r.DatabaseName=l.DatabaseName and r.ObjectName=l.ObjectName and r.RunId=l.MaxRunId
	inner join dbo.DBServers ds with (NOLOCK) on ds.ServerName=l.ServerName
	inner join dbo.ServerDatabases sd with (NOLOCK)on sd.DatabaseName=l.DatabaseName
	where objecttype<>'U' and ds.ServerId=sd.ServerId

)
GO
/****** Object:  StoredProcedure [dbo].[TablesComparePivot]    Script Date: 06/02/2016 18:52:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TablesComparePivot]    
 (@objName sysname, @dbname sysname)    
as    
BEGIN    
--get the latest runid by object    
select DatabaseName, ObjectName, Max(RunID) as RunID    
 into #LatestObjects    
 from dbo.Results    
 where Objectname  = @objName    
  and DatabaseName like @dbname+'%'    
 group by DatabaseName, ObjectName    
    
--Return results with list of databases pivoted into single column    
select distinct    
 r.ObjectName    
 ,r.TblSortByColumnName    
 ,DatabaseList = REPLACE((select distinct databasename as [data()]  from results R2   
 where R.Objectname  = r2.ObjectName and R.TblSortByColumnName = r2.TblSortByColumnName 
 and databasename  like @dbname+'%'    
 FOR XML PATH ('')),' ',',')    
 from dbo.Results r    
 join #LatestObjects l on r.DatabaseName = l.DatabaseName and r.ObjectName = l.ObjectName and r.RunID =l.RunID    
 where r.Objectname  = @objName    
  and r.DatabaseName like @dbname+'%'    
    
--cleanup     
drop table #LatestObjects;    
END    
    
--objectscompare 'vwRETRO01D','Tran'
GO
/****** Object:  StoredProcedure [dbo].[usp_ApplyDeltas]    Script Date: 06/02/2016 18:52:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Usp_applydeltas 'VDHAHS-CARE05','TRANAJMA',37909  
CREATE PROC [dbo].[usp_ApplyDeltas] @Servername   NVARCHAR(200),  
                                   @DatabaseName NVARCHAR(200),  
                                   @RunId        AS INTEGER  
AS  
  BEGIN  
      BEGIN TRY ;  
          WITH CurrentRow  
               AS (SELECT [Id],  
                          [RunId],  
                          ds.serverid,  
                          ds.servername       AS ds_servername,  
                          sd.databaseId,  
                          sd.databasename     AS sd_databasename,  
                          sd.databaseclass,  
                          dc.classid,  
                          dc.dbclass,  
                          r.[ServerName],  
                          r.[DatabaseName],  
                          [ObjectName],  
                          [ObjectType],  
                          [TxtObj],  
                          [TxtObjNoWhiteSpace],  
                          [Tbl],  
                          [TblSortbyColumnName],  
                          [ObjectDefination],  
                          Row_number()  
                            OVER (  
                              PARTITION BY r.ServerName, r.DatabaseName, ObjectName  
                              ORDER BY [Tbl]) AS row_num  
                   FROM   [dbo].Results r WITH (nolock)  
                          JOIN dbo.ServerDatabases sd  
                            ON r.databasename = sd.databasename  
                          JOIN dbo.DBServers ds  
                            ON ds.serverid = sd.serverid  
                          JOIN dbo.DatabaseClass dc  
                            ON dc.classid = sd.databaseclass  
                   WHERE  Upper(r.ServerName) = @Servername  
                          AND r.DatabaseName = @DatabaseName  
                          AND ObjectType = 'U')  
          SELECT  
          --[current].[RunId],[current].Id, [current].ServerName, [current].DatabaseName, [current].ObjectName,  [current].[ObjectType],[current].Tbl    
          [current].[RunId],  
          [current].Id,  
          [current].ServerName,  
          [current].DatabaseName,  
          [current].ObjectName,  
          [current].ObjectType,  
          [current].TxtObj,  
          [current].TxtObjNoWhiteSpace,  
          [current].Tbl,  
          [current].TblSortbyColumnName,  
          [current].ObjectDefination  
          INTO   #ExistingTableData  
          FROM   CurrentRow AS [Current]  
                 LEFT OUTER JOIN CurrentRow AS previous  
                              ON ( Isnull([current].Tbl, 0) = Isnull(previous.Tbl, 0) )  
                                 AND [current].ObjectName = previous.ObjectName  
                                 AND [current].row_num = previous.row_num + 1  
          WHERE  ( Isnull([current].Tbl, 0) <> Isnull(previous.Tbl, 0) )  
                  OR [previous].Tbl IS NULL  
          ORDER  BY DatabaseName,  
                    ObjectName,  
                    RunId;  
           
          DELETE FROM #ExistingTableData  
          WHERE  ID NOT IN(SELECT id  
                           FROM   #ExistingTableData ED  
                           WHERE  ED.RunId = (SELECT Max(RunId)  
                                              FROM   #ExistingTableData e  
                                              WHERE  e.DatabaseName = ED.DatabaseName  
                                                     AND e.ServerName = ED.ServerName  
                                                     AND e.ObjectName = ED.ObjectName));;  
          INSERT INTO Results  
                      (RunId,  
                       ServerName,  
                       DatabaseName,  
                       ObjectName,  
                       ObjectType,  
                       TxtObj,  
                       TxtObjNoWhiteSpace,  
                       Tbl,  
                       TblSortbyColumnName,  
                       ObjectDefination)  
          SELECT RunId,  
                 ServerName,  
                 DatabaseName,  
                 ObjectName,  
                 ObjectType,  
                 TxtObj,  
                 TxtObjNoWhiteSpace,  
                 Tbl,  
                 TblSortbyColumnName,  
                 ObjectDefination  
          FROM   IntermediateResults e WITH (NOLOCK)  
          WHERE  e.objecttype = 'U'  
    and  Upper(e.ServerName) = @Servername  
                AND e.DatabaseName = @DatabaseName  
                 AND NOT EXISTS (SELECT *  
                                 FROM   #ExistingTableData R  
                                 WHERE  R.ServerName = e.ServerName  
                                        AND R.DatabaseName = e.DatabaseName  
                                        AND R.ObjectName = e.ObjectName  
                                        AND Isnull(R.Tbl, 0) = Isnull(e.Tbl, 0)  
                                        AND R.ObjectType = 'U');  
          WITH CurrentRow1  
               AS (SELECT [Id],  
                          [RunId],  
                          ds.serverid,  
                          ds.servername          AS ds_servername,  
                          sd.databaseId,  
                          sd.databasename        AS sd_databasename,  
                          sd.databaseclass,  
                          dc.classid,  
                          dc.dbclass,  
                          r.[ServerName],  
                          r.[DatabaseName],  
                          [ObjectName],  
                          [ObjectType],  
                          [TxtObj],  
                          [TxtObjNoWhiteSpace],  
                          [Tbl],  
                          [TblSortbyColumnName],  
                          [ObjectDefination],  
                          Row_number()  
                            OVER (  
                              PARTITION BY r.ServerName, r.DatabaseName, ObjectName  
                              ORDER BY [TxtObj]) AS row_num  
                   FROM   [dbo].[Results] r WITH (nolock)  
                          JOIN dbo.ServerDatabases sd  
                            ON r.databasename = sd.databasename  
                          JOIN dbo.DBServers ds  
                            ON ds.serverid = sd.serverid  
                          JOIN dbo.DatabaseClass dc  
                            ON dc.classid = sd.databaseclass  
                   WHERE  Upper(r.ServerName) = @Servername  
                          AND r.DatabaseName = @DatabaseName  
                          AND ObjectType <> 'U')  
          SELECT [current].[RunId],  
                 [current].Id,  
                 [current].ServerName,  
                 [current].DatabaseName,  
                 [current].ObjectName,  
                 [current].ObjectType,  
                 [current].TxtObj,  
                 [current].TxtObjNoWhiteSpace,  
                 [current].Tbl,  
                 [current].TblSortbyColumnName,  
                 [current].ObjectDefination  
          INTO   #ExistingProgData  
          FROM   CurrentRow1 AS [Current]  
                 LEFT OUTER JOIN CurrentRow1 AS previous  
                              ON ( Isnull([current].TxtObj, 0) = Isnull(previous.TxtObj, 0) )  
                                 AND [current].ObjectName = previous.ObjectName  
                                 AND [current].row_num = previous.row_num + 1  
          WHERE  ( Isnull([current].TxtObj, 0) <> Isnull(previous.TxtObj, 0)   
          --or Isnull([current].TxtObjNoWhiteSpace, 0) <> Isnull(previous.TxtObjNoWhiteSpace, 0)  
          )  
                  OR previous.TxtObj IS NULL  
                    
          ORDER  BY DatabaseName,  
                    ObjectName,  
                    RunId;  
         -- select '#ExistingProgData',* from #ExistingProgData where ObjectName ='vwPatientSatisfactionCallVolumeByWeek'  
          DELETE FROM #ExistingProgData  
          WHERE  ID NOT IN(SELECT id  
                           FROM   #ExistingProgData ED  
                           WHERE  ED.RunId = (SELECT Max(RunId)  
                                              FROM   #ExistingProgData e  
                                              WHERE  e.DatabaseName = ED.DatabaseName  
                                                     AND e.ServerName = ED.ServerName  
                                                     AND e.ObjectName = ED.ObjectName));  
          INSERT INTO Results  
                      (RunId,  
                       ServerName,  
                       DatabaseName,  
                       ObjectName,  
                       ObjectType,  
                       TxtObj,  
                       TxtObjNoWhiteSpace,  
                       Tbl,  
                       TblSortbyColumnName,  
                       ObjectDefination)  
          SELECT RunId,  
                 ServerName,  
                 DatabaseName,  
                 ObjectName,  
                 ObjectType,  
                 TxtObj,  
                 TxtObjNoWhiteSpace,  
                 Tbl,  
                 TblSortbyColumnName,  
                 ObjectDefination  
          FROM   IntermediateResults e WITH (NOLOCK)  
          WHERE  e.objecttype <> 'U'  
    AND Upper(e.ServerName) = @Servername  
                AND e.DatabaseName = @DatabaseName  
                 AND NOT EXISTS (SELECT *  
                                 FROM   #ExistingProgData R  
                                 WHERE  R.ServerName = e.ServerName  
                                        AND R.DatabaseName = e.DatabaseName  
                                        AND R.ObjectName = e.ObjectName  
                                        AND Isnull(R.TxtObj, 0) = Isnull(e.TxtObj, 0)  
                                       -- and Isnull(r.TxtObjNoWhiteSpace, 0) = Isnull(e.TxtObjNoWhiteSpace, 0)  
                                        AND R.ObjectType <> 'U');  
          ---------------------------------------- Insert DELETED Objects -----------------------------------------------------------------------------    
          WITH CurrentRow1  
               AS (SELECT [Id],  
                          @RunId                 RunId,  
                          ds.serverid,  
                          ds.servername          AS ds_servername,  
                          sd.databaseId,  
                          sd.databasename        AS sd_databasename,  
                          sd.databaseclass,  
                          dc.classid,  
                          dc.dbclass,  
                          r.[ServerName],  
                          r.[DatabaseName],  
                          [ObjectName],  
                          [ObjectType],  
                          [TxtObj],  
                          [TxtObjNoWhiteSpace],  
                          [Tbl],  
                          [TblSortbyColumnName],  
                          [ObjectDefination],  
                          Row_number()  
                            OVER (  
                              PARTITION BY r.ServerName, r.DatabaseName, ObjectName  
                              ORDER BY [TxtObj]) AS row_num  
                   FROM   [dbo].[Results] r WITH (nolock)  
                          JOIN dbo.ServerDatabases sd  
                            ON r.databasename = sd.databasename  
                          JOIN dbo.DBServers ds  
                            ON ds.serverid = sd.serverid  
                          JOIN dbo.DatabaseClass dc  
                            ON dc.classid = sd.databaseclass  
                   WHERE  Upper(r.ServerName) = @Servername  
                          AND r.DatabaseName = @DatabaseName  
                          AND ObjectType = 'U'  
                          AND Isnull(R.Tbl, 0) <> 0  
                          AND Isnull(r.ObjectDefination, '') <> 'DELETED')  
          SELECT e.objectname existingObjectName,  
                 [current].[RunId],  
                 [current].Id,  
                 [current].ServerName,  
     [current].DatabaseName,  
                 [current].ObjectName,  
                 [current].ObjectType,  
                 [current].TxtObj,  
                 [current].TxtObjNoWhiteSpace,  
                 [current].Tbl,  
                 [current].TblSortbyColumnName,  
                 'DELETED'    AS [ObjectDefination]  
          INTO   #DeletedTableData  
          FROM   CurrentRow1 AS [Current]  
                 LEFT OUTER JOIN IntermediateResults e WITH (NOLOCK)  
                              ON [Current].ServerName = e.ServerName  
                                 AND [Current].DatabaseName = e.DatabaseName  
                                 AND e.objecttype = 'U'  
                                 AND [Current].objectname = e.objectname;  
          -- select '#DeletedTableData',* from #DeletedTableData where ObjectName ='vwPatientSatisfactionCallVolumeByWeek'  
          DELETE FROM #DeletedTableData  
          WHERE  existingObjectName IS NOT NULL;  
          INSERT INTO Results  
                      (RunId,  
                       ServerName,  
                       DatabaseName,  
                       ObjectName,  
                       ObjectType,  
                       TxtObj,  
                       TxtObjNoWhiteSpace,  
                       Tbl,  
                       TblSortbyColumnName,  
                       ObjectDefination)  
          SELECT *  
          FROM  (SELECT @RunId RunId,  
                        ServerName,  
                        DatabaseName,  
                        ObjectName,  
                        ObjectType,  
                        NULL   TxtObj,  
                        NULL   TxtObjNoWhiteSpace,  
                        NULL   Tbl,  
                        NULL   TblSortbyColumnName,  
                        ObjectDefination  
                 FROM   #DeletedTableData e  
                 GROUP  BY ServerName,  
                           Databasename,  
                           ObjectName,  
                           ObjectType,  
                           ObjectDefination) AS A  
          WHERE  NOT EXISTS(SELECT *  
                            FROM   results r WITH (NOLOCK)  
                            WHERE  A.ServerName = r.ServerName  
                                   AND A.DatabaseName = r.DatabaseName  
                                   AND r.objecttype = 'U'  
                                   AND r.objectname = A.objectname  
                                   AND r.objectdefination = 'DELETED');  
          WITH CurrentRow1  
               AS (SELECT [Id],  
                          @RunId                 RunId,  
                          ds.serverid,  
                          ds.servername          AS ds_servername,  
                          sd.databaseId,  
                          sd.databasename        AS sd_databasename,  
                          sd.databaseclass,  
                          dc.classid,  
                          dc.dbclass,  
                          r.[ServerName],  
                          r.[DatabaseName],  
                          [ObjectName],  
                          [ObjectType],  
                          [TxtObj],  
                          [TxtObjNoWhiteSpace],  
                          [Tbl],  
                          [TblSortbyColumnName],  
                          [ObjectDefination],  
                          Row_number()  
                            OVER (  
                              PARTITION BY r.ServerName, r.DatabaseName, ObjectName  
                              ORDER BY [TxtObj]) AS row_num  
                   FROM   [dbo].[Results] r WITH (nolock)  
                          JOIN dbo.ServerDatabases sd  
                            ON r.databasename = sd.databasename  
                          JOIN dbo.DBServers ds  
                            ON ds.serverid = sd.serverid  
                          JOIN dbo.DatabaseClass dc  
                            ON dc.classid = sd.databaseclass  
                   WHERE  Upper(r.ServerName) = @Servername  
                          AND r.DatabaseName = @DatabaseName  
                          AND ObjectType <> 'U'  
                          AND Isnull(R.TxtObj, 0) <> 0  
                          AND Isnull(r.ObjectDefination, '') <> 'DELETED')  
          SELECT e.objectname existingObjectName,  
                 [current].[RunId],  
                 [current].Id,  
                 [current].ServerName,  
                 [current].DatabaseName,  
                 [current].ObjectName,  
                 [current].ObjectType,  
                 [current].TxtObj,  
                 [current].TxtObjNoWhiteSpace,  
                 [current].Tbl,  
                 [current].TblSortbyColumnName,  
                 'DELETED'    AS [ObjectDefination]  
          INTO   #DeletedProgData  
          FROM   CurrentRow1 AS [Current]  
                 LEFT OUTER JOIN IntermediateResults e WITH (NOLOCK)  
                              ON [Current].ServerName = e.ServerName  
                                 AND [Current].DatabaseName = e.DatabaseName  
                                 AND e.objecttype <> 'U'  
                                 AND [Current].objectname = e.objectname;  
          DELETE FROM #DeletedProgData  
          WHERE  existingObjectName IS NOT NULL;  
          INSERT INTO Results  
                      (RunId,  
                       ServerName,  
                       DatabaseName,  
                       ObjectName,  
                       ObjectType,  
                       TxtObj,  
                       TxtObjNoWhiteSpace,  
                       Tbl,  
                       TblSortbyColumnName,  
                       ObjectDefination)  
          SELECT *  
          FROM  (SELECT @RunId RunId,  
                        ServerName,  
                        DatabaseName,  
                        ObjectName,  
                        ObjectType,  
                        NULL   TxtObj,  
                        NULL   TxtObjNoWhiteSpace,  
                        NULL   Tbl,  
                        NULL   TblSortbyColumnName,  
                        ObjectDefination  
                 FROM   #DeletedProgData e  
                 GROUP  BY ServerName,  
                           Databasename,  
                           ObjectName,  
                           ObjectType,  
                           ObjectDefination) AS A  
          WHERE  NOT EXISTS(SELECT *  
                            FROM   results r WITH (NOLOCK)  
                            WHERE  A.ServerName = r.ServerName  
                                   AND A.DatabaseName = r.DatabaseName  
                                   AND r.objecttype <> 'U'  
                                   AND r.objectname = A.objectname  
                                   AND r.objectdefination = 'DELETED');  
      END TRY  
      BEGIN CATCH  
          DECLARE @ErrorMessage NVARCHAR(4000);  
          DECLARE @ErrorSeverity INT;  
          DECLARE @ErrorState INT;  
          SELECT @ErrorMessage = Error_message(),  
                 @ErrorSeverity = Error_severity(),  
                 @ErrorState = Error_state();  
          RAISERROR (@ErrorMessage,-- Message text.    
                     @ErrorSeverity,-- Severity.    
                     @ErrorState -- State.    
          );  
      END CATCH  
  END
GO
/****** Object:  UserDefinedFunction [dbo].[UDFReturnsTable]    Script Date: 06/02/2016 18:52:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[UDFReturnsTable] (@MinRange int = 1, @MaxRange int = 4)
-- Procedure B
RETURNS TABLE
AS
   RETURN(SELECT A.Col2 AS N'TextNumber' 
   FROM dbo.UDFTestTable AS A
   WHERE A.Col1 BETWEEN @MinRange AND @MaxRange)
GO
/****** Object:  UserDefinedFunction [dbo].[RemoveMultiLineComments]    Script Date: 06/02/2016 18:52:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Umesh Kumar>
-- Create date: <04/18/2012,>
-- Description:	<RemoveMultiLineComments>
-- =============================================
CREATE FUNCTION [dbo].[RemoveMultiLineComments] ( @input VARCHAR(MAX) )
RETURNS VARCHAR(MAX)
AS 
    BEGIN
        DECLARE @definition VARCHAR(MAX)


----Old Code for removing multi line comments.
----===== Replace all '/*' and '*/' pairs with nothing
--  WHILE CHARINDEX('/*',@definition) > 0
--	SELECT @definition = STUFF(@definition,
--                            CHARINDEX('/*',@definition),
--                            CHARINDEX('*/',@definition) - CHARINDEX('/*',@definition) + 2, --2 is the length of the search term 
--                            '')

        DECLARE @tbl_sp_text AS TABLE
            (
              id INT IDENTITY(1, 1) ,
              sp_text VARCHAR(MAX)
            )
        SELECT  @definition = @input

        INSERT  INTO @tbl_sp_text
                SELECT  Data
                FROM    dbo.Split(@definition, CHAR(13)) 

        DECLARE @sp_text VARCHAR(MAX) ,
            @sp_text_row VARCHAR(MAX) ,
            @sp_no_comment VARCHAR(MAX)
        DECLARE @c CHAR(1)
        DECLARE @i INT ,
            @rowcount INT
        SET @sp_text = ''
        SELECT  @sp_text = @sp_text + sp_text
        FROM    @tbl_sp_text

        SELECT  @i = 1
        SELECT  @rowcount = LEN(@sp_text)
        DECLARE @comment_count INT
        SELECT  @comment_count = 0
        SELECT  @sp_no_comment = ''
        WHILE @i <= @rowcount 
            BEGIN
                IF SUBSTRING(@sp_text, @i, 2) = '/*' 
                    SELECT  @comment_count = @comment_count + 1
                ELSE 
                    IF SUBSTRING(@sp_text, @i, 2) = '*/' 
                        SELECT  @comment_count = @comment_count - 1  
                    ELSE 
                        IF @comment_count = 0 
                            SELECT  @sp_no_comment = @sp_no_comment
                                    + SUBSTRING(@sp_text, @i, 1)
                IF SUBSTRING(@sp_text, @i, 2) = '*/' 
                    SELECT  @i = @i + 2
                ELSE 
                    SELECT  @i = @i + 1
            END

        SET @definition = @sp_no_comment 

        RETURN  @definition	
    END
GO
/****** Object:  Table [dbo].[MasterObjectList]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MasterObjectList](
	[ObjectId] [int] IDENTITY(1,1) NOT NULL,
	[AnalysisId] [int] NOT NULL,
	[DatabaseId] [int] NOT NULL,
	[FromRunId] [int] NOT NULL,
	[ObjectName] [varchar](100) NOT NULL,
	[ObjectType] [varchar](5) NOT NULL,
	[ObjectAsIS] [varbinary](50) NULL,
	[ObjectNoCommentsWhiteSpace] [varbinary](50) NULL,
	[TblAsIS] [int] NULL,
	[TblNoColumnOrder] [int] NULL,
	[ObjectDefinition] [varchar](max) NULL,
 CONSTRAINT [PK_MasterObjectList] PRIMARY KEY CLUSTERED 
(
	[ObjectId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[GetObjectVersions_delete]    Script Date: 06/02/2016 18:52:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create FUNCTION [dbo].[GetObjectVersions_delete] 
(	
	@startRunId int,
	@endRunId int 
)
RETURNS TABLE 
AS
RETURN 
(
	with R as ( 
		select objectname, TxtObjNoWhiteSpace, count(*) as 'ObjCount'
		from dbo.results with (nolock)
		where runid>=@startRunId and runid <=@endRunId and objecttype<>'U'
		group by objectname, TxtObjNoWhiteSpace
		),
	z as ( 
		select objectname, TblSortbyColumnName, count(*) as 'ObjCount'
		from dbo.results with (nolock)
		where runid>=@startRunId and runid <=@endRunId and objecttype='U'
		group by objectname, TblSortbyColumnName
		),
	RR as (
		select ObjCount,objectname,TxtObjNoWhiteSpace,
		row_number() over ( partition by r.objectName order by r.objectname, r.objcount desc) as v
		from R),
	zz as (
		select ObjCount,objectname,TblSortbyColumnName,
		row_number() over ( partition by z.objectName order by z.objectname, z.objcount desc) as v
		from z),
	R1 as ( 
		select objectname,databasename,ObjectType, TxtObjNoWhiteSpace
		from dbo.results with (nolock)
		where runid>=@startRunId and runid <=@endRunId and objecttype<>'U'
		),
	z1 as ( 
		select objectname,databasename,ObjectType, TblSortbyColumnName
		from dbo.results with (nolock)
		where runid>=@startRunId and runid <=@endRunId and objecttype='U'
		)

select RR.objectname, r1.databasename,ObjectType, RR.TxtObjNoWhiteSpace, ObjCount,v
from RR inner join R1 on RR.objectname=r1.objectname and RR.TxtObjNoWhiteSpace=r1.TxtObjNoWhiteSpace
union
select zz.objectname, z1.databasename,ObjectType, zz.TblSortbyColumnName, ObjCount,v
from zz inner join z1 on zz.objectname=z1.objectname and zz.TblSortbyColumnName=z1.TblSortbyColumnName
--order by objectname desc
)
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetBadObjectResion]    Script Date: 06/02/2016 18:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_GetBadObjectResion]
(	
	@ObjectName Varchar(200) 
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @InvalidReason as varchar(max)

	SELECT @InvalidReason = COALESCE(@InvalidReason+',','') + ReasonInvalid
	FROM (select distinct objectname,Remarks  as ReasonInvalid
	from NonCompilabileObjects
	where dbname='BaseTran' and objectname =@ObjectName
	union 
	SELECT distinct replace([ObjectName],'dbo.',''),ReasonInvalid
	FROM [BadObjectScanJuly2012]
	where replace([ObjectName],'dbo.','') =@ObjectName) as t

	--select @InvalidReason
		
	RETURN @InvalidReason		
END
GO
/****** Object:  StoredProcedure [dbo].[sp_Compare_Object]    Script Date: 06/02/2016 18:52:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Compare_Object] @Proc_Name AS NVARCHAR(255)
AS
  BEGIN
	SET NOCOUNT ON
	
      DECLARE @SrNo    AS INT,
              @ObjName AS VARCHAR(50)

      --IF OBJECT_ID('tempdb..#ObjectTemp') IS NOT NULL
      --  BEGIN
      --      DROP TABLE #ObjectTemp
      --  END

      IF OBJECT_ID('tempdb..#ObjectFinal') IS NOT NULL
        BEGIN
            DROP TABLE #ObjectFinal
        END

      --CREATE TABLE #ObjectTemp
      --  (
      --     ObjName VARCHAR(50)
      --  )

      --INSERT INTO #ObjectTemp
      --            (ObjName)
      --VALUES      (@Proc_Name)

      CREATE TABLE #ObjectFinal
        (
           ObjectName         NVARCHAR(50),
           DatabaseName       NVARCHAR(50),
           TxtObj             VARBINARY(100),
           TxtObjNoWhiteSpace VARBINARY(100),
           ObjectType         NVARCHAR(10),
           ObjectDefination   NVARCHAR(MAX)
        )

      --DECLARE Object_cursor CURSOR FOR
      --  SELECT 1,
      --         ObjName
      --  FROM   #ObjectTemp
      --OPEN Object_cursor

      --FETCH NEXT FROM Object_cursor INTO @SrNo, @ObjName

      --WHILE @@FETCH_STATUS = 0
      --  BEGIN
            INSERT INTO #ObjectFinal
            EXEC('Exec ObjectsCompare ''' + @Proc_Name +'''' + ',' + '''Tran''')

      --      FETCH NEXT FROM Object_cursor INTO @SrNo, @ObjName
      --  END

      --CLOSE Object_cursor;

      --DEALLOCATE Object_cursor;

      SELECT DISTINCT UPPER(R.ServerName)                                                                               AS ServerName,
                      'Version'
                      + CAST(DENSE_RANK() OVER(Partition BY O.ObjectName ORDER BY O.TxtObjNoWhiteSpace)AS VARCHAR(100)) AS VersionName,
                      O.ObjectName,
                      O.DatabaseName,
                      O.TxtObj,
                      O.TxtObjNoWhiteSpace,
                      O.ObjectType
      FROM   #ObjectFinal O
             LEFT JOIN Results R
                    ON O.ObjectName = R.ObjectName
                       AND R.DatabaseName = O.DatabaseName
                       AND O.ObjectType = R.ObjectType
             INNER JOIN DBServers D
                     ON D.ServerName = R.ServerName
      ORDER  BY O.TxtObjNoWhiteSpace,
                O.ObjectName

      --IF OBJECT_ID('tempdb..#ObjectTemp') IS NOT NULL
      --  BEGIN
      --      DROP TABLE #ObjectTemp
      --  END

      IF OBJECT_ID('tempdb..#ObjectFinal') IS NOT NULL
        BEGIN
            DROP TABLE #ObjectFinal
        END
        SET NOCOUNT OFF
  END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetTableKeyConstraintsIndexInfo]    Script Date: 06/02/2016 18:52:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  Umesh Kumar   
-- Create date: 4/15/2012    
-- Description: Returns checksum over column defenitions for a table    
-- execute [usp_GetTableKeyConstraintsIndexInfo] 100,'AHV-A2AQA1TRN01','TranDHTN'    
-- =============================================    
CREATE PROCEDURE [dbo].[usp_GetTableKeyConstraintsIndexInfo]     
    @RunId as int=100,    
    @ServerName as varchar(128),    
    @DbName sysname    
AS    
BEGIN    
 SET NOCOUNT ON;    
 Declare @sql nvarchar(4000)    
 Declare @sqlTemp as nvarchar(4000)    
 
-- Delete  all data from Key_ConstraintInfo table.    
delete from Key_ConstraintInfo
-- Insert Primary Key and unique key details.    
set @sql=N'    
INSERT INTO Key_ConstraintInfo
			SELECT DISTINCT ''' +  @DbName + ''',tbl.name,kc.parent_object_id,''PKUQ'',
			Stuff((SELECT '' ,CONSTRAINT '' + Quotename(cco.name) + CASE cco.type WHEN ''PK'' THEN '' PRIMARY KEY '' WHEN ''UQ'' THEN '' UNIQUE '' END
			+ i.type_desc COLLATE DATABASE_DEFAULT + '' ('' + KeyColumns + '')'' + '' WITH ( '' + CASE
			WHEN I.is_padded = 1 THEN '' PAD_INDEX = ON '' ELSE '' PAD_INDEX = OFF '' END + '','' + CASE WHEN ST.no_recompute = 0 THEN '' STATISTICS_NORECOMPUTE = OFF '' ELSE '' STATISTICS_NORECOMPUTE = ON ''
			END + '','' + CASE 	WHEN I.ignore_dup_key = 1 THEN '' IGNORE_DUP_KEY = ON '' ELSE '' IGNORE_DUP_KEY = OFF ''END + '','' + CASE 	WHEN I.allow_row_locks = 1 THEN '' ALLOW_ROW_LOCKS = ON '' 	ELSE '' ALLOW_ROW_LOCKS = OFF '' END + '','' + CASE
			WHEN I.allow_page_locks = 1 THEN '' ALLOW_PAGE_LOCKS = ON '' ELSE '' ALLOW_PAGE_LOCKS = OFF ''	END + '','' + ''FILLFACTOR = '' + CONVERT(CHAR(5), CASE
			WHEN I.fill_factor = 0 THEN 100 ELSE I.fill_factor 	END) + '' ) ON ['' + DS.name + '' ] ''
			FROM   ['+@ServerName+'].[' +  @DbName + '].sys.key_constraints cco
			INNER JOIN ['+@ServerName+'].[' +  @DbName + '].sys.indexes I ON I.object_id = cco.parent_object_id AND cco.unique_index_id = i.index_id
			JOIN ['+@ServerName+'].[' +  @DbName + '].sys.schemas AS sch 	ON cco.schema_id = sch.schema_id
			JOIN (SELECT *
				FROM   (SELECT IC2.object_id,IC2.index_id,
				Stuff((SELECT '' , '' + Quotename(C.name) + CASE WHEN Max(CONVERT(INT, IC1.is_descending_key)) = 1 THEN '' DESC '' ELSE '' ASC '' END
				FROM   ['+@ServerName+'].[' +  @DbName + '].sys.index_columns IC1
				JOIN ['+@ServerName+'].[' +  @DbName + '].sys.columns C 	ON C.object_id = IC1.object_id 	AND C.column_id = IC1.column_id AND IC1.is_included_column = 0
				WHERE  IC1.object_id = IC2.object_id AND IC1.index_id = IC2.index_id 
				GROUP  BY IC1.object_id, C.name,index_id ORDER  BY Max(IC1.key_ordinal)
				FOR XML PATH('''')), 1, 2, '''') KeyColumns
				FROM    ['+@ServerName+'].[' +  @DbName + '].sys.index_columns IC2
				GROUP  BY IC2.object_id, IC2.index_id) tmp3)tmp4 ON I.object_id = tmp4.object_id AND I.Index_id = tmp4.index_id
			JOIN ['+@ServerName+'].[' +  @DbName + '].sys.stats ST ON ST.object_id = I.object_id 	AND ST.stats_id = I.index_id
			LEFT OUTER JOIN ['+@ServerName+'].[' +  @DbName + '].sys.data_spaces DS
			ON I.data_space_id = DS.data_space_id
			WHERE  ( I.is_primary_key = 1	OR I.is_unique_constraint = 1 )
			--AND I.Object_id = Object_id(''Actions'') 
			AND I.Object_id = kc.parent_object_id
			GROUP  BY I.Object_id,cco.name,cco.type,	I.type_desc,tmp4.KeyColumns,I.is_padded,ST.no_recompute,I.ignore_dup_key,I.allow_row_locks,I.allow_page_locks,I.fill_factor,I.index_id,I.fill_factor,DS.name
			ORDER  BY I.index_id ASC
			FOR XML PATH ('''')), 1, 1, '''') AS ''IndScript''
			FROM   ['+@ServerName+'].[' +  @DbName + '].sys.key_constraints KC
			INNER JOIN ['+@ServerName+'].[' +  @DbName + '].sys.tables AS tbl ON KC.parent_object_id = tbl.object_id '    
    
 exec sp_executesql @sql  
 --  print @sql
--select len(@sqlTemp)
 --select * from #CTE     
 --insert into @CTE EXECUTE usp_TableColumnDefination '''+@ServerName+''',''' +  @DbName + '''    
 -- Get default constraint details    
 set @sql=N'
INSERT INTO Key_ConstraintInfo
SELECT ''' +  @DbName + ''',name, object_id,''DFC'', Replace(t.DefScript, ''{RETURN}'', Char(13)+'';'')
FROM   (SELECT DISTINCT obj2.name, obj2.object_id,Stuff((SELECT '' ALTER TABLE dbo.'' + Quotename(obj.name)
		+ '' ADD CONSTRAINT '' + Quotename(dc.name)+ '' DEFAULT('' + dc.definition + '') FOR '' + Quotename(c.name) + '' {RETURN}''
		FROM   ['+@ServerName+'].[' +  @DbName + '].sys.default_constraints dc
		INNER JOIN ['+@ServerName+'].[' +  @DbName + '].sys.columns c ON dc.parent_object_id = c.object_id  AND dc.parent_column_id = c.column_id
		INNER JOIN ['+@ServerName+'].[' +  @DbName + '].sys.objects AS obj ON dc.parent_object_id = obj.object_id 
		WHERE  dc.parent_object_id = obj2.object_id
		GROUP  BY obj.name,dc.name, dc.definition,c.name
		FOR XML PATH ('''')), 1, 1, '''') AS ''DefScript''
        FROM   ['+@ServerName+'].[' +  @DbName + '].sys.default_constraints AS DC
               INNER JOIN ['+@ServerName+'].[' +  @DbName + '].sys.objects AS obj2 ON DC.parent_object_id = obj2.object_id)AS t'    
  
 exec sp_executesql @sql    
 --Print @sql    
 -- Get table index information.
set @sql=N'
	INSERT INTO Key_ConstraintInfo
	select ''' +  @DbName + ''',T2.name,T2.object_id,''IDX'',replace(T2.IDXScript,''{RETURN}'',CHAR(13)+'';'') as ''Defination'' from (
	select tbl.object_id,tbl.name,
	stuff((	SELECT 
	 ''  CREATE '' + CASE WHEN I.is_unique = 1 THEN '' UNIQUE '' ELSE '''' END + I.type_desc COLLATE DATABASE_DEFAULT + '' INDEX '' + Quotename(I.name) 
	+ '' ON ['' + sch.name + ''].'' + Quotename(T.name) + '' ( '' + KeyColumns + '' )  ''
	+ Isnull('' INCLUDE ('' + IncludedColumns + '' ) '', '''') +
	'' WITH ( '' + 
		CASE WHEN I.is_padded = 1 THEN '' PAD_INDEX = ON ''ELSE '' PAD_INDEX = OFF '' END + '','' +
		CASE WHEN ST.no_recompute = 0 THEN '' STATISTICS_NORECOMPUTE = OFF '' ELSE '' STATISTICS_NORECOMPUTE = ON ''END + '',''+ ''SORT_IN_TEMPDB = OFF '' + '','' + 
		CASE WHEN I.ignore_dup_key = 1 THEN '' IGNORE_DUP_KEY = ON '' ELSE '' IGNORE_DUP_KEY = OFF '' END + '','' + '' ONLINE = OFF '' + '','' + 
		CASE WHEN I.allow_row_locks = 1 THEN '' ALLOW_ROW_LOCKS = ON '' ELSE '' ALLOW_ROW_LOCKS = OFF '' END + '','' + 
		CASE WHEN I.allow_page_locks = 1 THEN '' ALLOW_PAGE_LOCKS = ON '' ELSE '' ALLOW_PAGE_LOCKS = OFF '' END +  '','' +
		''FILLFACTOR = '' + CONVERT(CHAR(5), CASE WHEN I.fill_factor = 0 THEN 100 ELSE I.fill_factor END) + '' ) ON ['' + DS.name + ''] ''
		+ '' {RETURN} '' 
	FROM ['+@ServerName+'].[' +  @DbName + '].sys.indexes I 
	JOIN ['+@ServerName+'].[' +  @DbName + '].sys.tables T ON T.object_id = I.object_id 
	JOIN ['+@ServerName+'].[' +  @DbName + '].sys.sysindexes SI ON I.object_id = SI.id AND I.index_id = SI.indid
	join ['+@ServerName+'].[' +  @DbName + '].sys.schemas as sch on t.schema_id = sch.schema_id
	JOIN (SELECT * FROM   
			( SELECT IC2.object_id,IC2.index_id, Stuff((SELECT '' , ['' + C.name +'']''+ CASE WHEN Max(CONVERT(INT, IC1.is_descending_key)) = 1 THEN '' DESC '' ELSE '' ASC '' END
				FROM   ['+@ServerName+'].[' +  @DbName + '].sys.index_columns IC1 
				JOIN ['+@ServerName+'].[' +  @DbName + '].sys.columns C 	ON C.object_id = IC1.object_id 	AND C.column_id = IC1.column_id AND IC1.is_included_column = 0
			WHERE  IC1.object_id = IC2.object_id AND IC1.index_id = IC2.index_id GROUP  BY IC1.object_id,C.name,index_id ORDER  BY Max(IC1.key_ordinal)
			FOR XML PATH('''')), 1, 2, '''') KeyColumns
			FROM   ['+@ServerName+'].[' +  @DbName + '].sys.index_columns IC2 GROUP  BY IC2.object_id,IC2.index_id) tmp3)tmp4
		ON I.object_id = tmp4.object_id AND I.Index_id = tmp4.index_id 
	JOIN ['+@ServerName+'].[' +  @DbName + '].sys.stats ST ON ST.object_id = I.object_id AND ST.stats_id = I.index_id
	LEFT OUTER JOIN ['+@ServerName+'].[' +  @DbName + '].sys.data_spaces DS ON I.data_space_id = DS.data_space_id 
	LEFT JOIN (SELECT *
					FROM   (SELECT IC2.object_id,IC2.index_id,Stuff((SELECT '' , ['' + C.name+'']''
					FROM   ['+@ServerName+'].[' +  @DbName + '].sys.index_columns IC1
					JOIN ['+@ServerName+'].[' +  @DbName + '].sys.columns C ON C.object_id = IC1.object_id AND C.column_id = IC1.column_id AND IC1.is_included_column = 1
					WHERE  IC1.object_id = IC2.object_id AND IC1.index_id = IC2.index_id 
					GROUP  BY IC1.object_id,C.name,	index_id,IC1.index_column_id
					ORDER  BY IC1.index_column_id ASC
					FOR XML PATH('''')), 1, 2, '''') IncludedColumns
					FROM   ['+@ServerName+'].[' +  @DbName + '].sys.index_columns IC2
					GROUP  BY IC2.object_id,IC2.index_id) tmp1
					WHERE  IncludedColumns IS NOT NULL) tmp2
	ON tmp2.object_id = I.object_id AND tmp2.index_id = I.index_id
	WHERE  I.is_primary_key = 0 AND I.is_unique_constraint = 0
	and t.name = tbl.name
	--and  T.name in( ''A2Post835FileIndex'')
	group by T.name,I.is_unique,I.type_desc,sch.name,tmp4.KeyColumns,tmp2.IncludedColumns,i.is_padded,i.fill_factor,i.ignore_dup_key,st.no_recompute,
	i.allow_page_locks,i.allow_row_locks,i.name,ds.name
	FOR XML PATH ('''')), 1, 1, '''') AS ''IDXScript'' from ['+@ServerName+'].[' +  @DbName + '].sys.tables as tbl ) as T2 where IDXScript is not NULL order by name asc'    
  
 exec sp_executesql @sql    
 --Print @sql  
  -- Get table forigen key information.
set @sql=N'
	INSERT INTO Key_ConstraintInfo
SELECT DISTINCT ''' +  @DbName + ''' as ''DBNAME'',tbl.name, f.parent_object_id, ''FKY'',
      STUFF( (SELECT ''  ALTER TABLE ''+ Quotename(schPar.name)+''.''
               + Quotename(tblPar.name)
               + case when (f.is_disabled = 1) then  '' WITH NOCHECK ADD CONSTRAINT ''
				 else 
					 CASE when (is_not_trusted = 1) then '' WITH NOCHECK ADD CONSTRAINT '' else '' WITH CHECK ADD CONSTRAINT '' end  
				 end
               + Quotename(f.name) + '' FOREIGN KEY '' + ''(''
               + Quotename(FKC.name)
               + '')'' + Char(10) + ''REFERENCES  ''+ Quotename(schRef.name)+''.''
               + Quotename(tblRef.name)
               + ''('' + Quotename(RFC.name) + '') ''
               + case when (f.is_not_for_replication = 1) then '' NOT FOR REPLICATION'' else '''' END
			   + case when (f.update_referential_action = 1) then '' ON UPDATE CASCADE'' else '''' END
			   + case when (f.delete_referential_action = 1) then '' ON DELETE CASCADE'' else '''' END
               +'';''+ Char(10)
        FROM   ['+@ServerName+'].[' +  @DbName + '].sys.foreign_keys AS f
               INNER JOIN ['+@ServerName+'].[' +  @DbName + '].sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
               inner join ['+@ServerName+'].[' +  @DbName + '].sys.columns as FKC on FKC.object_id = fc.parent_object_id AND FKC.column_id =fc.parent_column_id
               inner join ['+@ServerName+'].[' +  @DbName + '].sys.columns as RFC on RFC.object_id = fc.referenced_object_id AND RFC.column_id =fc.referenced_column_id
               inner join ['+@ServerName+'].[' +  @DbName + '].sys.tables tblPar on tblPar.object_id = f.parent_object_id
               inner join ['+@ServerName+'].[' +  @DbName + '].sys.tables tblRef on tblRef.object_id = f.referenced_object_id
               inner join ['+@ServerName+'].[' +  @DbName + '].sys.schemas schPar on schPar.schema_id = tblPar.schema_id
               inner join ['+@ServerName+'].[' +  @DbName + '].sys.schemas schRef on schRef.schema_id = tblRef.schema_id
        WHERE  f.parent_object_id = tbl.object_id 
        group by f.parent_object_id,tblPar.name,f.name,FKC.name,tblRef.name,RFC.name,schPar.name,schRef.name,f.is_not_trusted,is_disabled,f.is_not_for_replication,f.update_referential_action,f.delete_referential_action
        FOR XML PATH('''')),1,1,'''') AS ''DEF''
FROM   ['+@ServerName+'].[' +  @DbName + '].sys.foreign_keys AS f
       inner join ['+@ServerName+'].[' +  @DbName + '].sys.tables tbl on tbl.object_id = f.parent_object_id
--WHERE  tbl.name = ''ISQ_AI_ActionItemLogDetail'' '    
  
 exec sp_executesql @sql    
 --Print @sql     
END
GO
/****** Object:  View [dbo].[vwVarianceReductionData_Assignment]    Script Date: 06/02/2016 18:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwVarianceReductionData_Assignment]
AS
SELECT 
	CASE 
		WHEN ObjectType = 'IF'	THEN 'Function' --In-lined table-function'
		WHEN ObjectType = 'U'	THEN 'Table'
		WHEN ObjectType = 'P'	THEN 'Stored procedure'
		WHEN ObjectType = 'V'	THEN 'View' 
		WHEN ObjectType = 'TR'	THEN 'Trigger'
		WHEN ObjectType = 'TF'	THEN 'Function' --Table function'
		WHEN ObjectType = 'FN'	THEN 'Function' --Scalar Function'
	END as ObjectType,
	ObjectName, 
	AssignedTo, 
	CASE 
		WHEN MAX([Rank]) = 1 AND SUM(CountOfObjects) = MAX(CountOfDatabases) THEN 'Std'
		WHEN MAX([Rank]) = 1 AND SUM(CountOfObjects) <> MAX(CountOfDatabases)THEN 'Std_NotAll'
		WHEN MAX([Rank]) > 1 AND SUM(CountOfObjects) = MAX(CountOfDatabases) THEN 'NotStd_All'
		WHEN MAX([Rank]) > 1 AND SUM(CountOfObjects) <> MAX(CountOfDatabases)THEN 'NotStd_NotAll'
	END as VarianceCat,
		CASE 
		WHEN MAX([Rank]) = 1 AND SUM(CountOfObjects) = MAX(CountOfDatabases) THEN 'Do Nothing'
		WHEN MAX([Rank]) = 1 AND SUM(CountOfObjects) <> MAX(CountOfDatabases)THEN 'Std_DeployToAll'
		WHEN MAX([Rank]) > 1 AND SUM(CountOfObjects) = MAX(CountOfDatabases) THEN 'Standardize'
		WHEN MAX([Rank]) > 1 AND SUM(CountOfObjects) <> MAX(CountOfDatabases)THEN 'Standardize_DeployToAll'
	END as VarianceCat2,
	CASE -- An item is considered Done when a non-null value exists in the Changeset column
		WHEN COUNT(Changeset) > 0 THEN 'True' 
		ELSE 'False'
	END as Done

FROM VarianceReductionData
WHERE SelectFrom Like 'Tran%' 
and countofobjects <> 93
GROUP BY ObjectType, ObjectName, AssignedTo, ChangeSet
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[50] 4[25] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2[66] 3) )"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 5
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "VarianceReductionData"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 222
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwVarianceReductionData_Assignment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwVarianceReductionData_Assignment'
GO
/****** Object:  View [dbo].[vwResults]    Script Date: 06/02/2016 18:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vwResults]
as

SELECT [Id]
      ,[RunId],
      ds.serverid, ds.servername as ds_servername,
      sd.databaseId, sd.databasename as sd_databasename, sd.databaseclass,dc.classid, dc.dbclass
      ,r.[ServerName]
      ,r.[DatabaseName]
      ,[ObjectName]
      ,[ObjectType]
      ,[TxtObj]
      ,[TxtObjNoComments]
      ,[TxtObjNoWhiteSpace]
      ,[Tbl]
      ,[TblSortbyColumnName]
      ,[ObjectDefination]
  FROM [dbo].[Results] r
  join dbo.ServerDatabases sd on r.databasename=sd.databasename
  join dbo.DBServers ds on ds.serverid=sd.serverid
  join dbo.DatabaseClass dc on dc.classid=sd.databaseclass
  --where objectname
GO
/****** Object:  UserDefinedFunction [dbo].[Variance_Tables]    Script Date: 06/02/2016 18:52:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 4/17/2013
-- Description:	Returns variance counts for Tables
-- =============================================
CREATE FUNCTION [dbo].[Variance_Tables] 
()
RETURNS TABLE AS
RETURN (
	 with CTE AS (
	 SELECT l.*, d.DatabaseClass
      FROM   dbo.Lastversiontables() l
             INNER JOIN serverdatabases d
                     ON l.DatabaseName = d.DatabaseName)
                     
--Return results with list of databases pivoted into single column  
      SELECT DISTINCT r.ObjectName, r.ObjectType,
                      SelectFrom=(SELECT DISTINCT TOP 1 databasename
                                  FROM   CTE R2
                                  WHERE  R.Objectname = r2.ObjectName
                                         AND R.tblsortbycolumnname = r2.tblsortbycolumnname
                                         AND r.DatabaseClass = r2.DatabaseClass
                                  ORDER  BY 1 DESC),
                      DatabaseList = Replace((SELECT DISTINCT databasename AS [data()]
                                              FROM   CTE R2
                                              WHERE  R.Objectname = r2.ObjectName
                                                     AND R.tblsortbycolumnname = r2.tblsortbycolumnname
                                                     AND r.DatabaseClass = r2.DatabaseClass
                                              ORDER  BY 1 DESC
                                              FOR XML PATH ('')), ' ', ','),
                      TotalCount=(SELECT Count(*)
                                  FROM   CTE Z
                                  WHERE  R.Objectname = z.ObjectName
                                         AND R.tblsortbycolumnname = z.tblsortbycolumnname
                                         AND r.DatabaseClass = z.DatabaseClass),
                      DatabaseClass
 
      FROM   CTE R)
GO
/****** Object:  StoredProcedure [dbo].[VarianceSummary_Tables]    Script Date: 06/02/2016 18:52:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[VarianceSummary_Tables]
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 4/17/2013
-- Description:	Returns variance counts for Tables
-- =============================================
as
  
   SELECT l.*, d.DatabaseClass
      INTO   #LatestTables
      FROM   dbo.Lastversiontables() l
             INNER JOIN serverdatabases d
                     ON l.DatabaseName = d.DatabaseName
--Return results with list of databases pivoted into single column  
      SELECT DISTINCT r.ObjectName, r.ObjectType,
                      SelectFrom=(SELECT DISTINCT TOP 1 databasename
                                  FROM   #LatestTables R2
                                  WHERE  R.Objectname = r2.ObjectName
                                         AND R.tblsortbycolumnname = r2.tblsortbycolumnname
                                         AND r.DatabaseClass = r2.DatabaseClass
                                  ORDER  BY 1 DESC),
                      DatabaseList = Replace((SELECT DISTINCT databasename AS [data()]
                                              FROM   #LatestTables R2
                                              WHERE  R.Objectname = r2.ObjectName
                                                     AND R.tblsortbycolumnname = r2.tblsortbycolumnname
                                                     AND r.DatabaseClass = r2.DatabaseClass
                                              ORDER  BY 1 DESC
                                              FOR XML PATH ('')), ' ', ','),
                      TotalCount=(SELECT Count(*)
                                  FROM   #LatestTables Z
                                  WHERE  R.Objectname = z.ObjectName
                                         AND R.tblsortbycolumnname = z.tblsortbycolumnname
                                         AND r.DatabaseClass = z.DatabaseClass),
                      DatabaseClass
      INTO   #11
      FROM   #LatestTables R
      
       SELECT Row_number()
              OVER (
                PARTITION BY a.ObjectName, databaseclass
                ORDER BY TotalCount DESC) AS rank,
            a.ObjectName,
            a.ObjectType,
            SelectFrom,
            DatabaseList,
            TotalCount as CountOfObjects,
            ServerName = (SELECT DISTINCT TOP 1 serv.ServerName
                          FROM   ServerDatabases AS sd
                                 INNER JOIN dbservers serv
                                         ON sd.ServerId = serv.ServerId
                          WHERE  DatabaseClass = a.DatabaseClass
                                 AND DatabaseName = a.SelectFrom),
            --CASE
            --  WHEN 
            (		SELECT Count(*) AS 'TranCount'
                    FROM   dbo.ServerDatabases
                    WHERE  substring(DatabaseName,0,len(DatabaseName)-3) = substring(selectFrom,0,len(selectFrom)-3)
                       GROUP  BY substring(DatabaseName,0,len(DatabaseName)-3)
            --        HAVING Count(*) = TotalCount) > 0 THEN 'Y'
            --  ELSE 'N'
            --END   
            )                        AS CountOfDatabases
     FROM   #11 AS a 
--cleanup   
drop table #LatestTables;  
DROP TABLE #11
GO
/****** Object:  StoredProcedure [dbo].[VarianceSummary_Objects]    Script Date: 06/02/2016 18:52:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[VarianceSummary_Objects]
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 4/17/2013
-- Description:	Returns variance counts for Objects
-- =============================================
as
  
 select *
	into #LatestObjects  
	FROM dbo.LastVersionObjects()
    --from [dbo].[LastVersionOfAnObject] ('exc_ChargeAuditRuleEditor_Validation','Tran')
  
  --SELECT * FROM #LatestObjects  
--Return results with list of databases pivoted into single column  
select DISTINCT 
	r.ObjectName  ,r.ObjectType
	,SelectFrom=(select distinct TOP 1 databasename 
	from #LatestObjects R2 
	where R.Objectname  = r2.ObjectName 
	AND R.txtobjnowhitespace = r2.txtobjnowhitespace 
	AND R.DatabaseClass = r2.DatabaseClass
	ORDER BY 1 desc )  
	,DatabaseList = REPLACE((select distinct  databasename as [data()]  
	from #LatestObjects R2 
	where R.Objectname  = r2.ObjectName 
	AND R.txtobjnowhitespace = r2.txtobjnowhitespace 
	AND R.DatabaseClass = r2.DatabaseClass
	ORDER BY 1 desc FOR XML PATH ('') ),' ',',')  ,
	TotalCount=(SELECT  COUNT(*) 
				FROM  #LatestObjects Z 
				WHERE R.Objectname  = z.ObjectName 
				AND R.txtobjnowhitespace = z.txtobjnowhitespace 
				AND R.DatabaseClass = z.DatabaseClass),
	DatabaseClass
	INTO #1
	from #LatestObjects R
	
--SELECT row_number() OVER 
--	(PARTITION BY ObjectName ORDER BY TotalCount desc) as rank,
--	 ObjectName,ObjectType, SelectFrom, DatabaseList,TotalCount FROM #1
--ORDER BY ObjectName


 SELECT Row_number()
              OVER (
                PARTITION BY a.ObjectName, databaseclass
                ORDER BY TotalCount DESC) AS rank,
            a.ObjectName,
            a.ObjectType,
            SelectFrom,
            DatabaseList,
            TotalCount as CountOfObjects,
            ServerName = (SELECT DISTINCT TOP 1 serv.ServerName
                          FROM   ServerDatabases AS sd
                                 INNER JOIN dbservers serv
                                         ON sd.ServerId = serv.ServerId
                          WHERE  DatabaseClass = a.DatabaseClass
                                 AND DatabaseName = a.SelectFrom),
               (		SELECT Count(*) AS 'TranCount'
                    FROM   dbo.ServerDatabases
                    WHERE  substring(DatabaseName,0,len(DatabaseName)-3) = substring(selectFrom,0,len(selectFrom)-3)
                       GROUP  BY substring(DatabaseName,0,len(DatabaseName)-3)
            --        HAVING Count(*) = TotalCount) > 0 THEN 'Y'
            --  ELSE 'N'
            --END   
            )                        AS CountOfDatabases
     FROM   #1 AS a 


--cleanup   
drop table #LatestObjects;  
DROP TABLE #1
GO
/****** Object:  StoredProcedure [dbo].[usp_TableChecksum]    Script Date: 06/02/2016 18:52:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================        
-- Author:  Umesh Kumar       
-- Create date: 4/15/2012        
-- Description: Returns checksum over column defenitions for a table        
-- execute [usp_TableChecksum] 100,'AHS-Care05','TranMAMI'        
-- =============================================        
CREATE PROCEDURE [dbo].[usp_TableChecksum]         
 @RunId as int=100,        
    @ServerName as varchar(128),        
    @DbName sysname,        
    @LinkedServerPrefix nchar(3)=N'VDT'        
AS        
BEGIN        
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
 Declare @sql nvarchar(4000)        
 Declare @sqlTemp as nvarchar(4000)    
     
  -- Populate database key constraints info    
 execute usp_GetTableKeyConstraintsIndexInfo @RunId,@ServerName,@DbName    
 --*****************************************          
 -- Create Temp Table for holding table columns detail.        
 CREATE TABLE #CTE (TABLE_SCHEMA VARCHAR(100), TABLE_NAME VARCHAR(250),TABLE_ID int,column_definitions VARCHAR(Max))        
 select @sqlTemp=N'        
 INSERT INTO #CTE        
 SELECT e1.TABLE_SCHEMA, e1.TABLE_NAME,(select object_id from ['+@ServerName+'].[' +  @DbName + '].sys.objects where name =e1.TABLE_NAME) as TableID, LEFT(column_definitions, LEN(column_definitions) - 1) AS column_definitions        
 FROM ['+@ServerName+'].[' +  @DbName + '].INFORMATION_SCHEMA.COLUMNS AS e1 (nolock)       
 INNER JOIN ['+@ServerName+'].[' +  @DbName + '].INFORMATION_SCHEMA.TABLES tbl (nolock) ON tbl.TABLE_SCHEMA = e1.TABLE_SCHEMA AND tbl.TABLE_NAME = e1.TABLE_NAME        
 CROSS APPLY ( SELECT ''{RETURN}    '' + QUOTENAME(COLUMN_NAME, ''['') + '' '' + QUOTENAME(DATA_TYPE, ''['') + CASE DATA_TYPE        
 WHEN ''char'' THEN (CASE ISNULL(CHARACTER_MAXIMUM_LENGTH, 0) WHEN 0 THEN '''' WHEN -1 THEN ''(MAX)'' ELSE ''('' + convert(varchar(10), CHARACTER_MAXIMUM_LENGTH) + '')'' END)        
 WHEN ''nchar'' THEN (CASE ISNULL(CHARACTER_MAXIMUM_LENGTH, 0) WHEN 0 THEN '''' WHEN -1 THEN ''(MAX)'' ELSE ''('' + convert(varchar(10), CHARACTER_MAXIMUM_LENGTH) + '')'' END)        
 WHEN ''varchar'' THEN (CASE ISNULL(CHARACTER_MAXIMUM_LENGTH, 0) WHEN 0 THEN '''' WHEN -1 THEN ''(MAX)'' ELSE ''('' + convert(varchar(10), CHARACTER_MAXIMUM_LENGTH) + '')'' END)        
 WHEN ''nvarchar'' THEN (CASE ISNULL(CHARACTER_MAXIMUM_LENGTH, 0) WHEN 0 THEN '''' WHEN -1 THEN ''(MAX)'' ELSE ''('' + convert(varchar(10), CHARACTER_MAXIMUM_LENGTH) + '')'' END)        
 WHEN ''numeric'' THEN (CASE ISNULL(NUMERIC_PRECISION, 0) WHEN 0 THEN '''' ELSE ''('' + convert(varchar(10), NUMERIC_PRECISION) + '', '' + convert(varchar(10), NUMERIC_SCALE) + '')'' END)        
 WHEN ''decimal'' THEN (CASE ISNULL(NUMERIC_PRECISION, 0) WHEN 0 THEN '''' ELSE ''('' + convert(varchar(10), NUMERIC_PRECISION) + '', '' + convert(varchar(10), NUMERIC_SCALE) + '')'' END)        
 WHEN ''varbinary'' THEN (CASE CHARACTER_MAXIMUM_LENGTH WHEN -1 THEN ''(max)'' ELSE ''('' + convert(varchar(10), CHARACTER_MAXIMUM_LENGTH) + '')'' END)        
 ELSE '''' END +         
 CASE WHEN DATA_TYPE LIKE ''%char'' THEN '' COLLATE '' + COLLATION_NAME        
 ELSE ''''        
 END + ISNULL((SELECT '' IDENTITY ('' + CAST(sic.[seed_value] AS varchar(500)) + '','' + CAST(sic.[increment_value] AS varchar(10)) + '')''        
 FROM ['+@ServerName+'].[' +  @DbName + '].sys.identity_columns sic (nolock)       
 WHERE sic.[object_id] = tbl.object_id  AND sic.[name] = intern.COLUMN_NAME        
 ), '''') + CASE IS_NULLABLE WHEN ''NO'' THEN '' NOT'' ELSE '''' END + '' NULL'' + '',''        
 FROM ['+@ServerName+'].[' +  @DbName + '].INFORMATION_SCHEMA.COLUMNS AS intern (nolock)    
 inner join ['+@ServerName+'].[' +  @DbName + '].sys.tables as tbl (nolock) on intern.Table_name = tbl.name       
 WHERE  e1.TABLE_NAME = intern.TABLE_NAME AND e1.TABLE_SCHEMA = intern.TABLE_SCHEMA        
 ORDER BY intern.ORDINAL_POSITION FOR XML PATH('''') ) pre_trimmed (column_definitions)        
 WHERE e1.TABLE_NAME NOT IN (''dtproperties'', ''sysconstraints'', ''syssegments'') AND tbl.TABLE_TYPE = ''BASE TABLE''        
 GROUP BY e1.TABLE_SCHEMA, e1.TABLE_NAME, pre_trimmed.column_definitions '        
        
 exec sp_executesql @sqlTemp        
 -- print @sqlTemp        
 --select * from #CTE         
 --insert into @CTE EXECUTE usp_TableColumnDefination '''+@ServerName+''',''' +  @DbName + '''      
 --Checksum_agg(Binary_checksum(UPPER(t1.TD)))AS ''TO'',Checksum_agg(Binary_checksum(UPPER(t1.TD)))AS ''TableUnordered''      
 set @sql=N'        
 select ' +convert(nvarchar(11),@RunId ) + 'as ''RunID'',''' + convert(nvarchar(128),REPLACE(@ServerName,@LinkedServerPrefix,'')) + '''as ''ServerName'',''' + convert(nvarchar(128),@DbName) + '''as ''DbName'',T1.name,''U''as ''Type'',         
 dbo.MakeMD5Hash(UPPER(t1.TD))AS ''TO'',dbo.MakeMD5Hash(UPPER(t1.TD))AS ''TableUnordered'',t1.TD    
 from ( SELECT scm.name+''.''+o.NAME as NAME,O.id,    
 (select DISTINCT  ''CREATE TABLE ''     
  + QUOTENAME(t.TABLE_SCHEMA, ''['') + ''.''     
  + QUOTENAME(t.TABLE_NAME, ''['') +  '' (''     
  + REPLACE(column_definitions, ''{RETURN}'', CHAR(13))     
  + isnull(PKUQ.Definitions,'''') +'' ) ON '' + QUOTENAME(ds.name) + '';''+ Char(13) + isnull(idx.Definitions,'''') + Char(13)+ isnull(fky.Definitions,'''')+ Char(13)+ isnull(DFC.Definitions,'''')        
 FROM ['+@ServerName+'].[' +  @DbName + '].sys.indexes ix         
 inner JOIN ['+@ServerName+'].[' +  @DbName + '].sys.data_spaces ds (nolock) ON ds.data_space_id = ix.data_space_id        
 inner  JOIN #CTE t (nolock) ON t.Table_ID = ix.object_id        
 left outer join Key_ConstraintInfo as PKUQ  on PKUQ.TABLE_NAME =  t.TABLE_NAME and PKUQ.TABLE_ID= t.TABLE_ID  and PKUQ.Type_desc = ''PKUQ''    
 left outer join Key_ConstraintInfo as IDX  on IDX.TABLE_NAME =  t.TABLE_NAME and IDX.TABLE_ID= t.TABLE_ID  and IDX.Type_desc = ''IDX''     
 left outer join Key_ConstraintInfo as FKY  on FKY.TABLE_NAME =  t.TABLE_NAME and FKY.TABLE_ID= t.TABLE_ID  and FKY.Type_desc = ''FKY''     
 left outer join Key_ConstraintInfo as DFC  on DFC.TABLE_NAME =  t.TABLE_NAME and DFC.TABLE_ID= t.TABLE_ID  and DFC.Type_desc = ''DFC''     
 WHERE ix.object_id > 100 AND ix.type <=1 and ix.object_id= O.id) as ''TD''         
 from ['+@ServerName+'].[' +  @DbName + '].dbo. syscolumns c (nolock)       
 inner join ['+@ServerName+'].[' +  @DbName + '].dbo.sysobjects o (nolock) on c.id=o.id 
 inner join ['+@ServerName+'].[' +  @DbName + '].sys.objects obj (nolock) on  obj.object_id = o.id   
 inner join ['+@ServerName+'].[' +  @DbName + '].sys.schemas scm (nolock)on obj.schema_id = scm.schema_id        
 where o.type=''U'' and o.name not in (select ObjectName from Results where ObjectType =''U''         
 and RunId='+ convert(nvarchar(11),@RunId ) +' and  DatabaseName ='''+@DbName+''')        
 group by o.name,O.id ,scm.name)as t1 GROUP  BY t1.name,t1.id ,t1.TD order by t1.name'     
        
 exec sp_executesql @sql        
-- Print @sql        
        
 drop table  #CTE        
        
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetLatestObjectsListForDbSourceLite]    Script Date: 06/02/2016 18:52:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--execute usp_GetLatestObjectsListForDbSourceLite
CREATE PROCEDURE [dbo].[usp_GetLatestObjectsListForDbSourceLite]
AS
  BEGIN
        SET NOCOUNT ON;

      SELECT l.*, d.DatabaseClass
      INTO   #LatestTables
      FROM   dbo.Lastversiontables() l
             INNER JOIN serverdatabases d
                     ON l.DatabaseName = d.DatabaseName
--Return results with list of databases pivoted into single column  
      SELECT DISTINCT r.ObjectName, r.ObjectType,
                      SelectFrom=(SELECT DISTINCT TOP 1 databasename
                                  FROM   #LatestTables R2
                                  WHERE  R.Objectname = r2.ObjectName
                                         AND R.tblsortbycolumnname = r2.tblsortbycolumnname
                                         AND r.DatabaseClass = r2.DatabaseClass
                                  ORDER  BY 1 DESC),
                      DatabaseList = Replace((SELECT DISTINCT databasename AS [data()]
                                              FROM   #LatestTables R2
                                              WHERE  R.Objectname = r2.ObjectName
                                                     AND R.tblsortbycolumnname = r2.tblsortbycolumnname
                                                     AND r.DatabaseClass = r2.DatabaseClass
                                              ORDER  BY 1 DESC
                                              FOR XML PATH ('')), ' ', ','),
                      TotalCount=(SELECT Count(*)
                                  FROM   #LatestTables Z
                                  WHERE  R.Objectname = z.ObjectName
                                         AND R.tblsortbycolumnname = z.tblsortbycolumnname
                                         AND r.DatabaseClass = z.DatabaseClass),
                      DatabaseClass
      INTO   #11
      FROM   #LatestTables R
	 -- where ObjectName ='837_Charges'
/*########################################################*/
--					Objects
/*########################################################*/
      SELECT *
      INTO   #LatestObjects
      FROM   dbo.Lastversionobjects()
     -- where objectname ='EDI_835AdjudicationInsert'
--Return results with list of databases pivoted into single column  
      SELECT DISTINCT r.ObjectName, r.ObjectType,
                      SelectFrom=(SELECT DISTINCT TOP 1 databasename
                                  FROM   #LatestObjects R2
                                  WHERE  R.Objectname = r2.ObjectName
                                         AND R.TxtObjNoWhiteSpace = r2.TxtObjNoWhiteSpace
                                         AND R.DatabaseClass=r2.DatabaseClass
                                  ORDER  BY 1 DESC),
                      DatabaseList = Replace((SELECT DISTINCT databasename AS [data()]
                                              FROM   #LatestObjects R2
                                              WHERE  R.Objectname = r2.ObjectName
                                                     AND R.TxtObjNoWhiteSpace = r2.TxtObjNoWhiteSpace
                                                     AND r.DatabaseClass=r2.DatabaseClass
                                              ORDER  BY 1 DESC
                                              FOR XML PATH ('')), ' ', ','),
                      TotalCount=(SELECT Count(*)
                                  FROM   #LatestObjects Z
                                  WHERE  R.Objectname = z.ObjectName
                                         AND R.TxtObjNoWhiteSpace = Z.TxtObjNoWhiteSpace
                                         AND R.DatabaseClass=Z.DatabaseClass),
                      r.DatabaseClass
      INTO   #1
      FROM   #LatestObjects R;
	
	-- Truncate version table for DbSource Lite.
	Truncate table ObjectsListForDbSourceLite;
	
	--Insert object's version information into database table for DbSource Lite 
	Insert into ObjectsListForDbSourceLite  
     SELECT Row_number()
              OVER (
                PARTITION BY a.ObjectName, databaseclass
                ORDER BY TotalCount DESC) AS rank,
            a.ObjectName,
            a.ObjectType,
            SelectFrom,
            DatabaseList,
            TotalCount,
            ServerName = (SELECT DISTINCT TOP 1 serv.ServerName
                          FROM   ServerDatabases AS sd
                                 INNER JOIN dbservers serv
                                         ON sd.ServerId = serv.ServerId
                          WHERE  DatabaseClass = a.DatabaseClass
                                 AND DatabaseName = a.SelectFrom),
            CASE
              WHEN (SELECT Count(*) AS 'TranCount'
                    FROM   dbo.ServerDatabases
                    WHERE  substring(DatabaseName,0,len(DatabaseName)-3) = substring(selectFrom,0,len(selectFrom)-3)
                       GROUP  BY substring(DatabaseName,0,len(DatabaseName)-3)
                    HAVING Count(*) = TotalCount) > 0 THEN 'Y'
              ELSE 'N'
            END                           AS BaseObject
     FROM   #11 AS a 
     
      
      UNION
     SELECT Row_number()
              OVER (
                PARTITION BY a.ObjectName, databaseclass
                ORDER BY TotalCount DESC) AS rank,
            a.ObjectName,
            a.ObjectType,
            SelectFrom,
            DatabaseList,
            TotalCount,
            ServerName = (SELECT DISTINCT TOP 1 serv.ServerName
                          FROM   ServerDatabases AS sd
                                 INNER JOIN dbservers serv
                                         ON sd.ServerId = serv.ServerId
                          WHERE  DatabaseClass = a.DatabaseClass
                                 AND DatabaseName = a.SelectFrom),
            CASE
              WHEN (SELECT Count(*) AS 'TranCount'
                    FROM   dbo.ServerDatabases
                   WHERE  substring(DatabaseName,0,len(DatabaseName)-3) = substring(selectFrom,0,len(selectFrom)-3)
                       GROUP  BY substring(DatabaseName,0,len(DatabaseName)-3)
                    HAVING Count(*) = TotalCount) > 0 THEN 'Y'
              ELSE 'N'
            END                           AS BaseObject
     FROM   #1 AS a
     ORDER  BY ObjectName  ;
      

      --cleanup   
      DROP TABLE #LatestTables;
      DROP TABLE #LatestObjects;
      DROP TABLE #1;
      DROP TABLE #11;
      
      select * from ObjectsListForDbSourceLite order by objectName asc;
  END
GO
/****** Object:  StoredProcedure [dbo].[Usp_getlatestgolddbobjectslist_NoSpace]    Script Date: 06/02/2016 18:52:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================        
-- Author:  <Umesh Kumar>        
-- Create date: <10/24/2013>        
-- Description: <This sproc is for geting version info of all GOLD db objects>        
-- =============================================        
--execute usp_GetLatestGOLDdbObjectsList      
CREATE PROCEDURE [dbo].[Usp_getlatestgolddbobjectslist_NoSpace]  
AS  
  BEGIN  
      SET NOCOUNT ON;  
      SELECT l.*,  
             d.DatabaseClass  
      INTO   #LatestTables  
      FROM   dbo.Lastversiontables() l  
             INNER JOIN serverdatabases d  
                     ON l.DatabaseName = d.DatabaseName  
      WHERE  d.isGold = 1  
      --Return results with list of databases pivoted into single column          
      SELECT DISTINCT r.ObjectName,  
                      r.ObjectType,  
                      SelectFrom=(SELECT DISTINCT TOP 1 databasename  
                                  FROM   #LatestTables R2  
                                  WHERE  R.Objectname = r2.ObjectName  
                                         AND R.tbl = r2.tbl  
                                         AND r.DatabaseClass = r2.DatabaseClass  
                                  ORDER  BY 1 DESC),  
                      DatabaseList = Replace((SELECT DISTINCT databasename AS [data()]  
                                              FROM   #LatestTables R2  
                                              WHERE  R.Objectname = r2.ObjectName  
                                                     AND R.tbl = r2.tbl  
                                                     AND r.DatabaseClass = r2.DatabaseClass  
                                              ORDER  BY 1 DESC  
                                              FOR XML PATH ('')), ' ', ','),  
                      TotalCount=(SELECT Count(*)  
                                  FROM   #LatestTables Z  
                                  WHERE  R.Objectname = z.ObjectName  
                                         AND R.tbl = z.tbl  
                                         AND r.DatabaseClass = z.DatabaseClass),  
                      DatabaseClass  
      INTO   #11  
      FROM   #LatestTables R  
      -- where ObjectName ='837_Charges'        
  /*########################################################*/  
      --     Objects        
      /*########################################################*/  
      SELECT l.*  
      INTO   #LatestObjects  
      FROM   dbo.Lastversionobjects() l  
             INNER JOIN serverdatabases d  
                     ON l.DatabaseName = d.DatabaseName  
      WHERE  d.isGold = 1  
      -- and  objectname ='load_AddWeightSyncExceptions_Diagnoses'        
      --Return results with list of databases pivoted into single column          
      SELECT DISTINCT r.ObjectName,  
                      r.ObjectType,  
                      SelectFrom=(SELECT DISTINCT TOP 1 databasename  
                                  FROM   #LatestObjects R2  
                                  WHERE  R.Objectname = r2.ObjectName  
                                         -- AND R.TxtObj = r2.TxtObj   
                                         -- AND R.TxtObjNoWhiteSpace = r2.TxtObjNoWhiteSpace   
                                         AND ( R.TxtObjNoWhiteSpace = r2.TxtObjNoWhiteSpace  
                                                OR R.TxtObj = r2.TxtObj )  
                                         AND R.DatabaseClass = r2.DatabaseClass  
                                  ORDER  BY 1 DESC),  
                      DatabaseList = Replace((SELECT DISTINCT databasename AS [data()]  
                                              FROM   #LatestObjects R2  
                                              WHERE  R.Objectname = r2.ObjectName  
                                                     --  AND R.TxtObj = r2.TxtObj    
                                                     AND ( R.TxtObjNoWhiteSpace = r2.TxtObjNoWhiteSpace  
                                                            OR R.TxtObj = r2.TxtObj )  
                                                     AND r.DatabaseClass = r2.DatabaseClass  
                                              ORDER  BY 1 DESC  
                                              FOR XML PATH ('')), ' ', ','),  
                      TotalCount=(SELECT Count(*)  
                                  FROM   #LatestObjects Z  
                                  WHERE  R.Objectname = z.ObjectName  
          --AND R.TxtObj = Z.TxtObj   
                                        -- AND R.TxtObjNoWhiteSpace = Z.TxtObjNoWhiteSpace  
                                          AND ( R.TxtObjNoWhiteSpace = z.TxtObjNoWhiteSpace OR R.TxtObj = Z.TxtObj )  
                                           
                                         AND R.DatabaseClass = Z.DatabaseClass),  
                      r.DatabaseClass  
      INTO   #1  
      FROM   #LatestObjects R;  
      -- Truncate version table for DbSource Lite.        
      TRUNCATE TABLE GOLDDbObjectsList;  
      --Insert object's version information into database table for DbSource Lite         
      INSERT INTO GOLDDbObjectsList  
      SELECT Row_number()  
               OVER (  
                 PARTITION BY a.ObjectName, databaseclass  
                 ORDER BY TotalCount DESC) AS rank,  
             a.ObjectName,  
             a.ObjectType,  
             SelectFrom,  
             DatabaseList,  
             TotalCount,  
             ServerName = (SELECT DISTINCT TOP 1 serv.ServerName  
                           FROM   ServerDatabases AS sd  
                                  INNER JOIN dbservers serv  
                                          ON sd.ServerId = serv.ServerId  
                           WHERE  DatabaseClass = a.DatabaseClass  
                                  AND DatabaseName = a.SelectFrom  
                                  AND sd.isGold = 1),  
             CASE  
               WHEN (SELECT Count(*) AS 'TranCount'  
                     FROM   dbo.ServerDatabases  
                     WHERE  Substring(DatabaseName, 0, Len(DatabaseName) - 3) = Substring(selectFrom, 0, Len(selectFrom) - 3)  
                            AND isGold = 1  
                     GROUP  BY Substring(DatabaseName, 0, Len(DatabaseName) - 3)  
                     HAVING Count(*) = TotalCount) > 0 THEN 'Y'  
               ELSE 'N'  
             END                           AS BaseObject  
      FROM   #11 AS a  
      UNION  
      SELECT Row_number()  
               OVER (  
                 PARTITION BY a.ObjectName, databaseclass  
                 ORDER BY TotalCount DESC) AS rank,  
             a.ObjectName,  
             a.ObjectType,  
             SelectFrom,  
             DatabaseList,  
             TotalCount,  
             ServerName = (SELECT DISTINCT TOP 1 serv.ServerName  
                           FROM   ServerDatabases AS sd  
                                  INNER JOIN dbservers serv  
                                          ON sd.ServerId = serv.ServerId  
                           WHERE  DatabaseClass = a.DatabaseClass  
                                  AND DatabaseName = a.SelectFrom  
                                  AND sd.isGold = 1),  
             CASE  
               WHEN (SELECT Count(*) AS 'TranCount'  
                     FROM   dbo.ServerDatabases  
                     WHERE  Substring(DatabaseName, 0, Len(DatabaseName) - 3) = Substring(selectFrom, 0, Len(selectFrom) - 3)  
                            AND isGold = 1  
                     GROUP  BY Substring(DatabaseName, 0, Len(DatabaseName) - 3)  
                     HAVING Count(*) = TotalCount) > 0 THEN 'Y'  
               ELSE 'N'  
             END                           AS BaseObject  
      FROM   #1 AS a  
      ORDER  BY ObjectName;  
      --cleanup           
      DROP TABLE #LatestTables;  
      DROP TABLE #LatestObjects;  
      DROP TABLE #1;  
      DROP TABLE #11;  
      SELECT *  
      FROM   GOLDDbObjectsList  
      ORDER  BY objectName ASC;  
  END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetLatestGOLDdbObjectsList]    Script Date: 06/02/2016 18:52:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  <Umesh Kumar>    
-- Create date: <10/24/2013>    
-- Description: <This sproc is for geting version info of all GOLD db objects>    
-- =============================================    
--execute usp_GetLatestGOLDdbObjectsList  
CREATE PROCEDURE [dbo].[usp_GetLatestGOLDdbObjectsList]  
AS  
  BEGIN  
      SET NOCOUNT ON;  
      SELECT l.*,  
             d.DatabaseClass  
      INTO   #LatestTables  
      FROM   dbo.Lastversiontables() l  
             INNER JOIN serverdatabases d  
                     ON l.DatabaseName = d.DatabaseName  
      WHERE  d.isGold = 1  
      --Return results with list of databases pivoted into single column      
      SELECT DISTINCT r.ObjectName,  
                      r.ObjectType,  
                      SelectFrom=(SELECT DISTINCT TOP 1 databasename  
                                  FROM   #LatestTables R2  
                                  WHERE  R.Objectname = r2.ObjectName  
                                         AND R.tblsortbycolumnname = r2.tblsortbycolumnname  
                                         AND r.DatabaseClass = r2.DatabaseClass  
                                  ORDER  BY 1 DESC),  
                      DatabaseList = Replace((SELECT DISTINCT databasename AS [data()]  
                                              FROM   #LatestTables R2  
                                              WHERE  R.Objectname = r2.ObjectName  
                                                     AND R.tblsortbycolumnname = r2.tblsortbycolumnname  
                                                     AND r.DatabaseClass = r2.DatabaseClass  
                                              ORDER  BY 1 DESC  
                                              FOR XML PATH ('')), ' ', ','),  
                      TotalCount=(SELECT Count(*)  
                                  FROM   #LatestTables Z  
                                  WHERE  R.Objectname = z.ObjectName  
                                         AND R.tblsortbycolumnname = z.tblsortbycolumnname  
                                         AND r.DatabaseClass = z.DatabaseClass),  
                      DatabaseClass  
      INTO   #11  
      FROM   #LatestTables R  
      -- where ObjectName ='837_Charges'    
  /*########################################################*/  
      --     Objects    
      /*########################################################*/  
      SELECT l.*  
      INTO   #LatestObjects  
      FROM   dbo.Lastversionobjects() l  
             INNER JOIN serverdatabases d  
                     ON l.DatabaseName = d.DatabaseName  
      WHERE  d.isGold = 1  
      -- where objectname ='EDI_835AdjudicationInsert'    
      --Return results with list of databases pivoted into single column      
      SELECT DISTINCT r.ObjectName,  
                      r.ObjectType,  
                      SelectFrom=(SELECT DISTINCT TOP 1 databasename  
                                  FROM   #LatestObjects R2  
                                  WHERE  R.Objectname = r2.ObjectName  
										 AND R.TxtObj = r2.TxtObj
                                        -- AND R.TxtObjNoWhiteSpace = r2.TxtObjNoWhiteSpace  
                                         AND R.DatabaseClass = r2.DatabaseClass  
                                  ORDER  BY 1 DESC),  
                      DatabaseList = Replace((SELECT DISTINCT databasename AS [data()]  
                                              FROM   #LatestObjects R2  
                                              WHERE  R.Objectname = r2.ObjectName 
													 AND R.TxtObj = r2.TxtObj
                                                     --AND R.TxtObjNoWhiteSpace = r2.TxtObjNoWhiteSpace  
                                                     AND r.DatabaseClass = r2.DatabaseClass  
                                              ORDER  BY 1 DESC  
                                              FOR XML PATH ('')), ' ', ','),  
                      TotalCount=(SELECT Count(*)  
                                  FROM   #LatestObjects Z  
   WHERE  R.Objectname = z.ObjectName  
                                         --AND R.TxtObjNoWhiteSpace = Z.TxtObjNoWhiteSpace  
                                          AND R.TxtObj = Z.TxtObj
                                         AND R.DatabaseClass = Z.DatabaseClass),  
                      r.DatabaseClass  
      INTO   #1  
      FROM   #LatestObjects R;  
      -- Truncate version table for DbSource Lite.    
      TRUNCATE TABLE GOLDDbObjectsList;  
      --Insert object's version information into database table for DbSource Lite     
      INSERT INTO GOLDDbObjectsList  
      SELECT Row_number()  
               OVER (  
                 PARTITION BY a.ObjectName, databaseclass  
                 ORDER BY TotalCount DESC) AS rank,  
             a.ObjectName,  
             a.ObjectType,  
             SelectFrom,  
             DatabaseList,  
             TotalCount,  
             ServerName = (SELECT DISTINCT TOP 1 serv.ServerName  
                           FROM   ServerDatabases AS sd  
                                  INNER JOIN dbservers serv  
                                          ON sd.ServerId = serv.ServerId  
                           WHERE  DatabaseClass = a.DatabaseClass  
                                  AND DatabaseName = a.SelectFrom  
                                  AND sd.isGold = 1),  
             CASE  
               WHEN (SELECT Count(*) AS 'TranCount'  
                     FROM   dbo.ServerDatabases  
                     WHERE  Substring(DatabaseName, 0, Len(DatabaseName) - 3) = Substring(selectFrom, 0, Len(selectFrom) - 3)  
                     and isGold = 1  
                     GROUP  BY Substring(DatabaseName, 0, Len(DatabaseName) - 3)  
                     HAVING Count(*) = TotalCount) > 0 THEN 'Y'  
               ELSE 'N'  
             END                           AS BaseObject  
      FROM   #11 AS a  
      UNION  
      SELECT Row_number()  
               OVER (  
                 PARTITION BY a.ObjectName, databaseclass  
                 ORDER BY TotalCount DESC) AS rank,  
             a.ObjectName,  
             a.ObjectType,  
             SelectFrom,  
             DatabaseList,  
             TotalCount,  
             ServerName = (SELECT DISTINCT TOP 1 serv.ServerName  
                           FROM   ServerDatabases AS sd  
                                  INNER JOIN dbservers serv  
                                          ON sd.ServerId = serv.ServerId  
                           WHERE  DatabaseClass = a.DatabaseClass  
                                  AND DatabaseName = a.SelectFrom  
                                  AND sd.isGold = 1),  
             CASE  
               WHEN (SELECT Count(*) AS 'TranCount'  
                     FROM   dbo.ServerDatabases  
                     WHERE  Substring(DatabaseName, 0, Len(DatabaseName) - 3) = Substring(selectFrom, 0, Len(selectFrom) - 3)  
                     and isGold = 1  
                     GROUP  BY Substring(DatabaseName, 0, Len(DatabaseName) - 3)  
                     HAVING Count(*) = TotalCount) > 0 THEN 'Y'  
               ELSE 'N'  
             END                           AS BaseObject  
      FROM   #1 AS a  
      ORDER  BY ObjectName;  
      --cleanup       
      DROP TABLE #LatestTables;  
      DROP TABLE #LatestObjects;  
      DROP TABLE #1;  
      DROP TABLE #11;  
      SELECT *  
      FROM   GOLDDbObjectsList  
      ORDER  BY objectName ASC;  
  END
GO
/****** Object:  Table [dbo].[ServerDatabasesCare05]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServerDatabasesCare05](
	[DatabaseId] [int] IDENTITY(1,1) NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[ServerId] [int] NOT NULL,
	[DatabaseClass] [int] NOT NULL,
 CONSTRAINT [PK_ServerDatabases] PRIMARY KEY CLUSTERED 
(
	[DatabaseId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[RemoveComments]    Script Date: 06/02/2016 18:52:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Umesh Kumar>
-- Create date: <04/18/2012,>
-- Description:	<RemoveComments>
-- =============================================
CREATE FUNCTION [dbo].[RemoveComments] (@input VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
  BEGIN
      DECLARE @definition VARCHAR(MAX),
              @vbCrLf     CHAR(2)
      SET @vbCrLf = Char(13) + Char(10)
      SELECT @definition = @input + ' GO ' + @vbcrlf
      --'objective: strip out comments.
      --first loop is going to look for pairs of '/*' and '*/',  and STUFF them with empty space.
      --second loop is going to look for sets of '--' and vbCrLf and STUFF them with empty space.
      --===== Replace all '/*' and '*/' pairs with nothing
      ---- Old Code for multi line comment removed.
      -- WHILE CHARINDEX('/*',@definition) > 0
      --SELECT @definition = STUFF(@definition,
      --                           CHARINDEX('/*',@definition),
      --                           CHARINDEX('*/',@definition) - CHARINDEX('/*',@definition) + 2, --2 is the length of the search term 
      --                           '')
      ---- New Code for multi line comment removed.
      SELECT @definition = dbo.Removemultilinecomments(@definition)
      DECLARE @Id AS INT
      SET @Id = 1
      DECLARE @MaxId AS INT
      DECLARE @tbl_sp_Text AS TABLE
        (
           id      INT IDENTITY(1, 1),
           sp_text VARCHAR(MAX)
        )
      INSERT INTO @tbl_sp_Text
      SELECT Data
      FROM   dbo.Split(@definition, Char(10))
      SELECT @MaxId = Max(id)
      FROM   @tbl_sp_Text
      SET @definition = ''
      WHILE @Id <= @maxID
        BEGIN
            DECLARE @stringTxt AS VARCHAR(MAX)
            SET @stringTxt = ''
            SELECT @stringTxt = sp_text
            FROM   @tbl_sp_Text
            WHERE  id = @Id
            IF ( Substring(Ltrim(Rtrim(Replace(@stringTxt, Char(9), ''))), 1, 2) <> '--' )
              BEGIN
                  SET @definition = @definition + @stringTxt + Char(13)
              END
            SET @Id = @Id + 1
        END
      RETURN @definition
  END
GO
/****** Object:  StoredProcedure [dbo].[PostScanReport]    Script Date: 06/02/2016 18:52:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[PostScanReport]
@DeltaOnly bit =0
as 
Declare @MostRecentTuesday datetime
SELECT @MostRecentTuesday=DATEADD(wk, DATEDIFF(wk,0,GETDATE()), 1);

with cte as (
select * from ProgressReport where AnalysisId in 
	(select id from Analysis
	where StartTime>@MostRecentTuesday
	) 
union
select * from ProgressReportAH where AnalysisId in 
	(select id from Analysis
	where StartTime>@MostRecentTuesday
	) 
),
Report as (	
	select c.DatabaseName, StartDateTime, CompleteDateTime, 
	CountExpected=(	SELECT SUM(objcount) FROM dbo.ObjectCountReport o 
					where c.AnalysisId=o.AnalysisId and o.DatabaseName=c.DatabaseName),
	CountActual  =(	SELECT SUM(objcountactual) FROM dbo.ObjectCountReport o 
					where c.AnalysisId=o.AnalysisId and o.DatabaseName=c.DatabaseName),
	Delta =(SELECT SUM(objcount)-SUM(objcountactual) FROM dbo.ObjectCountReport o 
					where c.AnalysisId=o.AnalysisId and o.DatabaseName=c.DatabaseName)
	from cte c inner join ServerDatabases d on c.DatabaseName=d.DatabaseName
)

	select * 
	into #tmp
	from Report
	
	if @DeltaOnly =0
	BEGIN
		Select * from #tmp order by 1
	END
	ElSE
	BEGIN
		Select * from #tmp where Delta > 0 order by 1
	END
GO
/****** Object:  StoredProcedure [dbo].[PopulateMasterDataForAnalysis]    Script Date: 06/02/2016 18:52:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 5/1/2012
-- Description:	Gets the latest set of objects from data gathered and populates Master ObjectList
-- =============================================
CREATE PROCEDURE [dbo].[PopulateMasterDataForAnalysis] 
@AnalysysId int =0
AS
BEGIN
	SET NOCOUNT ON;
--Identify latest objects 
    insert into dbo.MasterObjectList 
		(AnalysisId, DatabaseId, FromRunId, ObjectName, ObjectType,ObjectAsIS, ObjectNoCommentsWhiteSpace, ObjectDefinition)
	select @AnalysysId, ds.ServerId, t.runid, t.ObjectName, t.ObjectType, TxtObj, TxtObjNoWhiteSpace, ObjectDefination
	from dbo.LastVersionObjects() t 
		inner join ServerDatabases sd on t.DatabaseName=sd.DatabaseName
		inner join DBServers ds on ds.ServerName=t.ServerName 
	where sd.ServerId=ds.ServerId 
	
	insert into dbo.MasterObjectList 
		(AnalysisId,DatabaseId,FromRunId, ObjectName, ObjectType, TblAsIS, TblNoColumnOrder, ObjectDefinition)
		select @AnalysysId, ds.ServerId, t.runid, t.ObjectName, t.ObjectType, Tbl, TblSortbyColumnName, ObjectDefination
	from dbo.LastVersionTables() t 
		inner join ServerDatabases sd on t.DatabaseName=sd.DatabaseName
		inner join DBServers ds on ds.ServerName=t.ServerName 
	where sd.ServerId=ds.ServerId 
	
END
GO
/****** Object:  StoredProcedure [Analysis].[StartAnalysis]    Script Date: 06/02/2016 18:51:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 5/15/2012
-- Description:	Starts analysis Run for all Facility databases in specified environment
-- =============================================
CREATE PROCEDURE [Analysis].[StartAnalysis]
@EnvId int
AS
BEGIN
SET NOCOUNT ON;
 Declare @LogMessage varchar(2500),	@AnalysisId int

	INSERT INTO [Analysis].[Analysis] ([EnvironmentId])
    VALUES (@EnvId)
    set @AnalysisId= SCOPE_IDENTITY()
 
IF  EXISTS (SELECT * FROM [Analysis].[Analysis] a WHERE a.Id <> @AnalysisId and a.Status=1)
Begin
	exec [Analysis].[InsertLogDetails] @AnalysisId, 'Another Analysis is in progress. Exiting.';
	update [Analysis].[Analysis]  set [Status]=4,EndTime=CURRENT_TIMESTAMP  where [id]=@AnalysisId
End 
else
Begin 
	declare @Counter table (ServerId int, DBName nvarchar(128),uTable int, Sp int,UV int, FN int, InlineF int,TF int, TR int)
	
	select * from  @Counter
	update Analysis.Analysis Set EndTime=CURRENT_TIMESTAMP, [Status]=2 	where Id=@AnalysisId
End


END
GO
/****** Object:  StoredProcedure [dbo].[PerformCleanAnalysys]    Script Date: 06/02/2016 18:52:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 5/2/2012
-- Description:	Generates variance analysys for "Clean" version ov objects
-- =============================================
CREATE PROCEDURE [dbo].[PerformCleanAnalysys] 
	@AnalysisId int 
AS
BEGIN
	SET NOCOUNT ON;

  	;with P as (
		select DatabaseClass , ObjectName, TblNoColumnOrder,  count(*) as 'ObjCount'
		from dbo.MasterObjectList l inner join ServerDatabases sd on l.DatabaseId=sd.DatabaseId
		where   AnalysisId=2
		group by DatabaseClass, objectname, TblNoColumnOrder
		),
	PP as (select DatabaseClass, ObjectName, ObjCount, TblNoColumnOrder,
		row_number() over ( partition by P.objectName order by P.objectname, P.objcount desc) as VCount
		from P)

select objectid,DatabaseClass ,pp.ObjectName, ObjectType,ObjCount,VCount
from PP  inner join dbo.MasterObjectList l with (nolock) on l.ObjectName=pp.ObjectName and l.TblNoColumnOrder=pp.TblNoColumnOrder
where AnalysisId =@AnalysisId 
order by ObjectName, VCount 
--8483
END
GO
/****** Object:  StoredProcedure [dbo].[Type4Objects]    Script Date: 06/02/2016 18:52:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Type4Objects]
AS
BEGIN

SELECT l.ObjectName,l.TxtObj,count(1)   objcount
into #tmp
from LastVersionObjects()  l inner join [objectsDBTypeOne4] o
on l.TxtObjNoWhiteSpace=o.def
group by l.ObjectName,l.TxtObj
order by l.ObjectName,3 desc



select (select  top 1 databasename from LastVersionObjects() w
			where t.ObjectName=w.ObjectName and t.TxtObj=w.TxtObj) as Dname,
	T.objectname
	from #tmp t inner join  
		(select objectname,MAX(objcount) as omax 
		from #tmp t
		group by  ObjectName )  z
	ON T.ObjectName=Z.ObjectName AND T.objcount=Z.omax
	
	drop table #tmp
END
GO
/****** Object:  StoredProcedure [dbo].[Type2Objects]    Script Date: 06/02/2016 18:52:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Type2Objects]
AS
BEGIN
SELECT l.ObjectName,l.TxtObj,count(1)   objcount
into #tmp
from LastVersionObjects()  l inner join [objectsDBTypeOne2] o
on l.TxtObjNoWhiteSpace=o.def
group by l.ObjectName,l.TxtObj
order by l.ObjectName,3 desc



select (select  top 1 databasename from LastVersionObjects() w
			where t.ObjectName=w.ObjectName and t.TxtObj=w.TxtObj) as Dname,
	T.objectname
	from #tmp t inner join  
		(select objectname,MAX(objcount) as omax 
		from #tmp t
		group by  ObjectName )  z
	ON T.ObjectName=Z.ObjectName AND T.objcount=Z.omax
	
	drop table #tmp
END
GO
/****** Object:  StoredProcedure [dbo].[Type1Objects]    Script Date: 06/02/2016 18:52:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Type1Objects]
AS
BEGIN

select * into #LV from LastVersionObjects();

SELECT l.ObjectName,l.TxtObj,count(1)   objcount
into #tmp
from #lv  l inner join [objectsDBTypeOne] o on l.TxtObjNoWhiteSpace=o.def 
inner join ServerDatabases sd on l.DatabaseName=sd.DatabaseName
inner join dbservers ds  on l.servername=ds.ServerName 
where   sd.ServerId=ds.ServerId and sd.DatabaseClass=1
group by l.ObjectName,l.TxtObj
order by l.ObjectName,3 desc



select (select  top 1 databasename from #LV w
			where t.ObjectName=w.ObjectName and t.TxtObj=w.TxtObj) as Dname,
	T.objectname
	from #tmp t inner join  
		(select objectname,MAX(objcount) as omax 
		from #tmp t
		group by  ObjectName )  z
	ON T.ObjectName=Z.ObjectName AND T.objcount=Z.omax
	
	drop table #tmp
	drop table #LV 
END
GO
/****** Object:  Table [dbo].[ObjectCategory]    Script Date: 06/02/2016 18:50:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ObjectCategory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ObjectID] [int] NOT NULL,
	[CategoryID] [int] NOT NULL,
 CONSTRAINT [PK_ObjectCategory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[ObjectsComparePivot]    Script Date: 06/02/2016 18:52:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ObjectsComparePivot]
 (@objName sysname, @dbname sysname)  
as  
BEGIN  

--get the latest runid by object  
  select * 
	into #LatestObjects  
	from [dbo].[LastVersionOfAnObject] (@objName,@dbname)
  
--Return results with list of databases pivoted into single column  
select distinct  
	r.ObjectName  
	,r.TxtObjNoWhiteSpace  
	,DatabaseList = REPLACE((select distinct databasename as [data()]  
							from #LatestObjects R2 
							where R.Objectname  = r2.ObjectName and R.txtobjnowhitespace = r2.txtobjnowhitespace FOR XML PATH ('')),' ',',')
	--,r.ServerName  
	from #LatestObjects R
	 
--cleanup   
drop table #LatestObjects;  
END  
  
--objectscompare 'vwRETRO01D','Tran'
GO
/****** Object:  StoredProcedure [dbo].[GetTablesCategoryC]    Script Date: 06/02/2016 18:52:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 5/30/12
-- Description:	Gets tables for category "C" within DB Class
-- =============================================
Create PROCEDURE [dbo].[GetTablesCategoryC] 
 @dbclass int=1
AS
BEGIN
SET NOCOUNT ON;

select ServerName,DatabaseName, ObjectName, TblSortbyColumnName,ObjectDefination
into #LV
from dbo.LastVersionTables()

declare @tmp table  (objectname nvarchar(128), TblSortbyColumnName int,objectType varchar(5), objdef varchar(max));
;	with P as (
		select environmentid,databaseclass,objectname, l.TblSortbyColumnName , count(*) as 'ObjCount'
		from #LV l inner join ServerDatabases sd on l.DatabaseName=sd.DatabaseName
		inner join dbservers ds  on l.servername=ds.ServerName 
		where   sd.ServerId=ds.ServerId and DatabaseClass=@dbclass
		group by environmentid,databaseclass,objectname, TblSortbyColumnName
		) ,
	PP as (select environmentid, databaseclass,ObjCount,objectname,TblSortbyColumnName,
		row_number() over ( partition by P.objectName order by P.objectname, P.objcount desc) as VCount
		from P)


insert into @tmp(objectname, TblSortbyColumnName,objectType, objdef)
select distinct  PP.objectname,PP.TblSortbyColumnName,'U', p1.ObjectDefination
from PP inner join #LV P1 on PP.objectname=P1.objectname and PP.TblSortbyColumnName<>P1.TblSortbyColumnName
inner join dbo.ServerDatabases ds on ds.DatabaseClass=pp.DatabaseClass 
inner join dbo.DBServers sd on sd.EnvironmentId=pp.EnvironmentId 
where sd.ServerId=ds.ServerId 
and PP.environmentid=1
and pp.DatabaseClass =@dbclass
and objcount<(select COUNT(1) from ServerDatabases where ServerDatabases.DatabaseClass=@dbclass)

select distinct objectType,objectname , (select top 1 objdef from @tmp b where b.objectname=a.objectname and a.TblSortbyColumnName=b.TblSortbyColumnName) as def
from @tmp a order by objectname asc;


END
GO
/****** Object:  StoredProcedure [dbo].[GetTablesCategoryB]    Script Date: 06/02/2016 18:52:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 5/8/12
-- Description:	Gets tables for category "B" within DB Class
-- =============================================
CREATE PROCEDURE [dbo].[GetTablesCategoryB] 
 @dbclass int=1
AS
BEGIN
SET NOCOUNT ON;

select ServerName,DatabaseName, ObjectName, TblSortbyColumnName,ObjectDefination
into #LV
from dbo.LastVersionTables()

declare @tmp table  (objectname nvarchar(128), TblSortbyColumnName int,objectType varchar(5), objdef varchar(max));
;	with P as (
		select environmentid,databaseclass,objectname, l.TblSortbyColumnName , count(*) as 'ObjCount'
		from #LV l inner join ServerDatabases sd on l.DatabaseName=sd.DatabaseName
		inner join dbservers ds  on l.servername=ds.ServerName 
		where   sd.ServerId=ds.ServerId and DatabaseClass=@dbclass
		group by environmentid,databaseclass,objectname, TblSortbyColumnName
		) ,
	PP as (select environmentid, databaseclass,ObjCount,objectname,TblSortbyColumnName,
		row_number() over ( partition by P.objectName order by P.objectname, P.objcount desc) as VCount
		from P)


insert into @tmp(objectname, TblSortbyColumnName,objectType, objdef)
select distinct  PP.objectname,PP.TblSortbyColumnName,'U', p1.ObjectDefination
from PP inner join #LV P1 on PP.objectname=P1.objectname and PP.TblSortbyColumnName<>P1.TblSortbyColumnName
inner join dbo.ServerDatabases ds on ds.DatabaseClass=pp.DatabaseClass 
inner join dbo.DBServers sd on sd.EnvironmentId=pp.EnvironmentId 
where sd.ServerId=ds.ServerId 
and PP.environmentid=1
and pp.DatabaseClass =@dbclass
and objcount=(select COUNT(1) from ServerDatabases where ServerDatabases.DatabaseClass=@dbclass)

select distinct objectType,objectname , (select top 1 objdef from @tmp b where b.objectname=a.objectname and a.TblSortbyColumnName=b.TblSortbyColumnName) as def
from @tmp a order by objectname asc;


END
GO
/****** Object:  StoredProcedure [dbo].[GetTablesCategoryA]    Script Date: 06/02/2016 18:52:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 5/8/12
-- Description:	Gets tables that are identical "As Is" within DB Class
-- =============================================
CREATE PROCEDURE [dbo].[GetTablesCategoryA]
 @dbclass int=1
AS
BEGIN
SET NOCOUNT ON;

select ServerName,DatabaseName, ObjectName, TblSortbyColumnName,ObjectDefination
into #LV
from dbo.LastVersionTables()

declare @tmp table  (objectname nvarchar(128), TblSortbyColumnName int,objectType varchar(5), objdef varchar(max));
;	with P as (
		select environmentid,databaseclass,objectname, l.TblSortbyColumnName , count(*) as 'ObjCount'
		from #LV l inner join ServerDatabases sd on l.DatabaseName=sd.DatabaseName
		inner join dbservers ds  on l.servername=ds.ServerName 
		where   sd.ServerId=ds.ServerId and DatabaseClass=@dbclass
		group by environmentid,databaseclass,objectname, TblSortbyColumnName
		) ,
	PP as (select environmentid, databaseclass,ObjCount,objectname,TblSortbyColumnName,
		row_number() over ( partition by P.objectName order by P.objectname, P.objcount desc) as VCount
		from P)


insert into @tmp(objectname, TblSortbyColumnName,objectType, objdef)
select distinct  PP.objectname,PP.TblSortbyColumnName,'U', p1.ObjectDefination
from PP inner join #LV P1 on PP.objectname=P1.objectname and PP.TblSortbyColumnName=P1.TblSortbyColumnName
inner join dbo.ServerDatabases ds on ds.DatabaseClass=pp.DatabaseClass 
inner join dbo.DBServers sd on sd.EnvironmentId=pp.EnvironmentId 
where sd.ServerId=ds.ServerId 
and PP.environmentid=1
and pp.DatabaseClass =@dbclass
and objcount=(select COUNT(1) from ServerDatabases where ServerDatabases.DatabaseClass=@dbclass)

select distinct objectType,objectname , (select top 1 objdef from @tmp b where b.objectname=a.objectname and a.TblSortbyColumnName=b.TblSortbyColumnName) as def
from @tmp a order by objectname asc;


END
GO
/****** Object:  StoredProcedure [dbo].[GetAsIsTablesScripts]    Script Date: 06/02/2016 18:52:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 5/8/12
-- Description:	Generates Create table scripts for objecfts that are identical "As Is" within DB Class
-- =============================================
CREATE PROCEDURE [dbo].[GetAsIsTablesScripts]
 @dbclass int=1
AS
BEGIN
	SET NOCOUNT ON;
declare @tmp table  (objectname nvarchar(128), tbl int, objtype char(2),objdef varchar(max));
;	with P as (
		select environmentid,databaseclass,objectname, tbl, count(*) as 'ObjCount'
		from dbo.LastVersionTables() l inner join ServerDatabases sd on l.DatabaseName=sd.DatabaseName
		inner join dbservers ds  on l.servername=ds.ServerName 
		where   sd.ServerId=ds.ServerId and DatabaseClass=@dbclass
		group by environmentid,databaseclass,objectname, tbl
		) ,
	PP as (select environmentid, databaseclass,ObjCount,objectname,tbl,
		row_number() over ( partition by P.objectName order by P.objectname, P.objcount desc) as VCount
		from P)

insert into @tmp(objectname, tbl,objtype, objdef)
select distinct  PP.objectname,PP.tbl,objecttype,p1.ObjectDefination
from PP inner join dbo.LastVersionTables() P1 on PP.objectname=P1.objectname and PP.tbl=P1.tbl
inner join dbo.ServerDatabases ds on ds.DatabaseClass=pp.DatabaseClass 
inner join dbo.DBServers sd on sd.EnvironmentId=pp.EnvironmentId 
where sd.ServerId=ds.ServerId 
and PP.environmentid=1
and pp.DatabaseClass =@dbclass
and objcount=(select COUNT(1) from ServerDatabases where ServerDatabases.DatabaseClass=@dbclass)

select distinct top 10 (select top 1 'IF Not EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[' + b.objectname +  ']'') AND type in (N''' + objtype +''')) ' + objdef + Char(13)+ Char(10) +' GO ' + char(13)+ Char(10) from @tmp b where b.objectname=a.objectname and a.tbl=b.tbl)  as def
from @tmp a ;
END
GO
/****** Object:  StoredProcedure [dbo].[GetAsIsTables]    Script Date: 06/02/2016 18:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 5/8/12
-- Description:	Gets tables that are identical "As Is" within DB Class
-- =============================================
CREATE PROCEDURE [dbo].[GetAsIsTables]
 @dbclass int=1
AS
BEGIN
SET NOCOUNT ON;
select ServerName,DatabaseName, ObjectName, tbl,ObjectDefination
into #LV
from dbo.LastVersionTables()

declare @tmp table  (objectname nvarchar(128), tbl int,objectType varchar(5), objdef varchar(max));
;	with P as (
		select environmentid,databaseclass,objectname, tbl, count(*) as 'ObjCount'
		from #LV l inner join ServerDatabases sd on l.DatabaseName=sd.DatabaseName
		inner join dbservers ds  on l.servername=ds.ServerName 
		where   sd.ServerId=ds.ServerId and DatabaseClass=@dbclass
		group by environmentid,databaseclass,objectname, tbl
		) ,
	PP as (select environmentid, databaseclass,ObjCount,objectname,tbl,
		row_number() over ( partition by P.objectName order by P.objectname, P.objcount desc) as VCount
		from P)


insert into @tmp(objectname, tbl,objectType, objdef)
select distinct  PP.objectname,PP.tbl,'U', p1.ObjectDefination
from PP inner join #LV P1 on PP.objectname=P1.objectname and PP.tbl=P1.tbl
inner join dbo.ServerDatabases ds on ds.DatabaseClass=pp.DatabaseClass 
inner join dbo.DBServers sd on sd.EnvironmentId=pp.EnvironmentId 
where sd.ServerId=ds.ServerId 
and PP.environmentid=1
and pp.DatabaseClass =@dbclass
and objcount=(select COUNT(1) from ServerDatabases where ServerDatabases.DatabaseClass=@dbclass)

select distinct objectType,objectname , (select top 1 objdef from @tmp b where b.objectname=a.objectname and a.tbl=b.tbl) as def
from @tmp a order by objectname asc;


END
GO
/****** Object:  StoredProcedure [dbo].[GetAnalysisProgress]    Script Date: 06/02/2016 18:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 6/14/12
-- Description:	Gets Counts of objects analyzed
-- =============================================
CREATE PROCEDURE [dbo].[GetAnalysisProgress] 
	@r int =0
AS
BEGIN
	SET NOCOUNT ON;
if @r=0
Begin
	select @r=max(id) from [dbo].[Analysis]
 End
 Select 'Progress Information for Analysis: ' + convert(varchar(10),@r)
 
  SELECT TOP 1000 [AnalysisId]
      ,[SERVERNAME]
      ,[DatabaseName]
      ,[StartDateTime]
      ,[CompleteDateTime]
  FROM [A2CdbVariance].[dbo].[ProgressReport]
  where analysisid=@r
  order by [SERVERNAME],[DatabaseName]
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetObjectsCategoryC]    Script Date: 06/02/2016 18:52:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 5/30/2012
-- Description:	Gets Category "C" version of DB objects
-- =============================================
Create PROCEDURE [dbo].[GetObjectsCategoryC] 
 @dbclass int=1
AS
BEGIN
		SET NOCOUNT ON;
select ServerName,l.DatabaseName, ObjectName,TxtObj, TxtObjNoWhiteSpace, ObjectDefination,l.objectType
into #LV
from dbo.LastVersionObjects()l inner join ServerDatabases sd on l.DatabaseName=sd.DatabaseName
where sd.DatabaseClass=@dbclass;

declare @tmp table  (objectname nvarchar(128), TxtObjNoWhiteSpace varbinary(50),objectType varchar(5), objdef varchar(max));
with P as (
	select environmentid,databaseclass,objectname, TxtObjNoWhiteSpace, count(*) as 'ObjCount'
	from #LV l inner join ServerDatabases sd on l.DatabaseName=sd.DatabaseName
	inner join dbservers ds  on l.servername=ds.ServerName 
	where   sd.ServerId=ds.ServerId and sd.DatabaseClass=@dbclass
	group by environmentid,databaseclass,objectname, TxtObjNoWhiteSpace
	) ,
PP as (select environmentid, databaseclass,ObjCount,objectname,TxtObjNoWhiteSpace,
	row_number() over ( partition by P.objectName order by P.objectname, P.objcount desc) as VCount
	from P)

insert into @tmp(objectname, TxtObjNoWhiteSpace,objectType, objdef)
select distinct  PP.objectname,PP.TxtObjNoWhiteSpace,p1.objectType,p1.ObjectDefination
from PP inner join #LV P1 on PP.objectname=P1.objectname --and PP.TxtObjNoWhiteSpace<>P1.TxtObjNoWhiteSpace
inner join dbo.ServerDatabases ds on ds.DatabaseClass=pp.DatabaseClass 
inner join dbo.DBServers sd on sd.EnvironmentId=pp.EnvironmentId 
where sd.ServerId=ds.ServerId 
and PP.environmentid=1
and pp.DatabaseClass =@dbclass
and objcount<(select COUNT(1) from ServerDatabases where ServerDatabases.DatabaseClass=@dbclass)

--Gets name and Clean Hash  of an object where object with this name exists in all facilities 
select distinct objectname , 
(select top 1 TxtObjNoWhiteSpace 
	from @tmp b 
		where b.objectname=a.objectname and a.TxtObjNoWhiteSpace=b.TxtObjNoWhiteSpace) as def
into #objectsOfDBType
from @tmp a ;

--select * from #objectsOfDBType 


SELECT l.objectType,l.ObjectName,l.TxtObj,count(1)   objcount
into #tmp
from #LV  l inner join #objectsOfDBType o on l.TxtObjNoWhiteSpace=o.def 
inner join ServerDatabases sd on l.DatabaseName=sd.DatabaseName
inner join dbservers ds  on l.servername=ds.ServerName 
where   sd.ServerId=ds.ServerId and sd.DatabaseClass=@dbclass
group by l.objectType,l.ObjectName,l.TxtObj
order by l.ObjectName,3 desc


select t.objectType,T.objectname,t.TxtObj,(select  top 1 databasename from #LV w
			where t.ObjectName=w.ObjectName and t.TxtObj=w.TxtObj order by databasename desc) as Dname
	
	from #tmp t inner join  
		(select objectname,MAX(objcount) as omax 
		from #tmp t
		group by  ObjectName )  z
	ON T.ObjectName=Z.ObjectName AND T.objcount=Z.omax
	order by  t.objectType,ObjectName, Dname
	
	
	drop table #tmp
	drop table #LV 
	drop table #objectsOfDBType
END
GO
/****** Object:  StoredProcedure [dbo].[GetObjectsCategoryB]    Script Date: 06/02/2016 18:52:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 5/14/2012
-- Description:	Gets Category "B" version of DB objects
-- =============================================
CREATE PROCEDURE [dbo].[GetObjectsCategoryB] 
 @dbclass int=1
AS
BEGIN
		SET NOCOUNT ON;
select ServerName,l.DatabaseName, ObjectName,TxtObj, TxtObjNoWhiteSpace, ObjectDefination,l.objectType
into #LV
from dbo.LastVersionObjects()l inner join ServerDatabases sd on l.DatabaseName=sd.DatabaseName
where sd.DatabaseClass=@dbclass;

declare @tmp table  (objectname nvarchar(128), TxtObjNoWhiteSpace varbinary(50),objectType varchar(5), objdef varchar(max));
with P as (
	select environmentid,databaseclass,objectname, TxtObjNoWhiteSpace, count(*) as 'ObjCount'
	from #LV l inner join ServerDatabases sd on l.DatabaseName=sd.DatabaseName
	inner join dbservers ds  on l.servername=ds.ServerName 
	where   sd.ServerId=ds.ServerId and sd.DatabaseClass=@dbclass
	group by environmentid,databaseclass,objectname, TxtObjNoWhiteSpace
	) ,
PP as (select environmentid, databaseclass,ObjCount,objectname,TxtObjNoWhiteSpace,
	row_number() over ( partition by P.objectName order by P.objectname, P.objcount desc) as VCount
	from P)

insert into @tmp(objectname, TxtObjNoWhiteSpace,objectType, objdef)
select distinct  PP.objectname,PP.TxtObjNoWhiteSpace,p1.objectType,p1.ObjectDefination
from PP inner join #LV P1 on PP.objectname=P1.objectname and PP.TxtObjNoWhiteSpace<>P1.TxtObjNoWhiteSpace
inner join dbo.ServerDatabases ds on ds.DatabaseClass=pp.DatabaseClass 
inner join dbo.DBServers sd on sd.EnvironmentId=pp.EnvironmentId 
where sd.ServerId=ds.ServerId 
and PP.environmentid=1
and pp.DatabaseClass =@dbclass
and objcount>=(select COUNT(1) from ServerDatabases where ServerDatabases.DatabaseClass=@dbclass)

--Gets name and Clean Hash  of an object where object with this name exists in all facilities 
select distinct objectname , 
(select top 1 TxtObjNoWhiteSpace 
	from @tmp b 
		where b.objectname=a.objectname and a.TxtObjNoWhiteSpace=b.TxtObjNoWhiteSpace) as def
into #objectsOfDBType
from @tmp a ;

--select * from #objectsOfDBType 


SELECT l.objectType,l.ObjectName,l.TxtObj,count(1)   objcount
into #tmp
from #LV  l inner join #objectsOfDBType o on l.TxtObjNoWhiteSpace=o.def 
inner join ServerDatabases sd on l.DatabaseName=sd.DatabaseName
inner join dbservers ds  on l.servername=ds.ServerName 
where   sd.ServerId=ds.ServerId and sd.DatabaseClass=@dbclass
group by l.objectType,l.ObjectName,l.TxtObj
order by l.ObjectName,3 desc


select t.objectType,T.objectname,t.TxtObj,(select  top 1 databasename from #LV w
			where t.ObjectName=w.ObjectName and t.TxtObj=w.TxtObj order by databasename desc) as Dname
	
	from #tmp t inner join  
		(select objectname,MAX(objcount) as omax 
		from #tmp t
		group by  ObjectName )  z
	ON T.ObjectName=Z.ObjectName AND T.objcount=Z.omax
	order by  t.objectType,ObjectName, Dname
	
	
	drop table #tmp
	drop table #LV 
	drop table #objectsOfDBType
END
GO
/****** Object:  StoredProcedure [dbo].[GetObjectsCategoryA]    Script Date: 06/02/2016 18:52:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 5/14/2012
-- Description:	Gets "Clean" version of DB objects
-- =============================================
CREATE PROCEDURE [dbo].[GetObjectsCategoryA]
 @dbclass int=1
AS
BEGIN
		SET NOCOUNT ON;
select ServerName,l.DatabaseName, ObjectName,TxtObj, TxtObjNoWhiteSpace, ObjectDefination,l.objectType
into #LV
from dbo.LastVersionObjects()l inner join ServerDatabases sd on l.DatabaseName=sd.DatabaseName
where sd.DatabaseClass=@dbclass;

declare @tmp table  (objectname nvarchar(128), TxtObjNoWhiteSpace varbinary(50),objectType varchar(5), objdef varchar(max));
with P as (
	select environmentid,databaseclass,objectname, TxtObjNoWhiteSpace, count(*) as 'ObjCount'
	from #LV l inner join ServerDatabases sd on l.DatabaseName=sd.DatabaseName
	inner join dbservers ds  on l.servername=ds.ServerName 
	where   sd.ServerId=ds.ServerId and sd.DatabaseClass=@dbclass
	group by environmentid,databaseclass,objectname, TxtObjNoWhiteSpace
	) ,
PP as (select environmentid, databaseclass,ObjCount,objectname,TxtObjNoWhiteSpace,
	row_number() over ( partition by P.objectName order by P.objectname, P.objcount desc) as VCount
	from P)

insert into @tmp(objectname, TxtObjNoWhiteSpace,objectType, objdef)
select distinct  PP.objectname,PP.TxtObjNoWhiteSpace,p1.objectType,p1.ObjectDefination
from PP inner join #LV P1 on PP.objectname=P1.objectname and PP.TxtObjNoWhiteSpace=P1.TxtObjNoWhiteSpace
inner join dbo.ServerDatabases ds on ds.DatabaseClass=pp.DatabaseClass 
inner join dbo.DBServers sd on sd.EnvironmentId=pp.EnvironmentId 
where sd.ServerId=ds.ServerId 
and PP.environmentid=1
and pp.DatabaseClass =@dbclass
and objcount>=(select COUNT(1) from ServerDatabases where ServerDatabases.DatabaseClass=@dbclass)

--Gets name and Clean Hash  of an object where object with this name exists in all facilities 
select distinct objectname , 
(select top 1 TxtObjNoWhiteSpace 
	from @tmp b 
		where b.objectname=a.objectname and a.TxtObjNoWhiteSpace=b.TxtObjNoWhiteSpace) as def
into #objectsOfDBType
from @tmp a ;

--select * from #objectsOfDBType 


SELECT l.objectType,l.ObjectName,l.TxtObj,count(1)   objcount
into #tmp
from #LV  l inner join #objectsOfDBType o on l.TxtObjNoWhiteSpace=o.def 
inner join ServerDatabases sd on l.DatabaseName=sd.DatabaseName
inner join dbservers ds  on l.servername=ds.ServerName 
where   sd.ServerId=ds.ServerId and sd.DatabaseClass=@dbclass
group by l.objectType,l.ObjectName,l.TxtObj
order by l.ObjectName,3 desc


select t.objectType,T.objectname,t.TxtObj,(select  top 1 databasename from #LV w
			where t.ObjectName=w.ObjectName and t.TxtObj=w.TxtObj order by databasename desc) as Dname
	
	from #tmp t inner join  
		(select objectname,MAX(objcount) as omax 
		from #tmp t
		group by  ObjectName )  z
	ON T.ObjectName=Z.ObjectName AND T.objcount=Z.omax
	order by  t.objectType,ObjectName, Dname
	
	
	drop table #tmp
	drop table #LV 
	drop table #objectsOfDBType
END
GO
/****** Object:  StoredProcedure [dbo].[GetNewObjects]    Script Date: 06/02/2016 18:52:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 7/18/2012
-- Description:	Gets objects and databases that were updated since last scan
-- =============================================
CREATE PROCEDURE [dbo].[GetNewObjects] 

AS
BEGIN
	SET NOCOUNT ON;
DECLARE @AHs DATETIME,@AHe DATETIME, @IMHs DATETIME, @IMHe DATETIME

SELECT TOP 1 @IMHs=starttime, @IMHE=EndTime
  FROM [A2CdbVariance].[dbo].Analysis
  WHERE createdBy='ACCRETIVEHEALTH\vmisyutin'
  ORDER BY id DESC
  SELECT  TOP 1 @AHs=starttime,@AHe=EndTime
  FROM [A2CdbVariance].[dbo].Analysis
  WHERE createdBy<>'ACCRETIVEHEALTH\vmisyutin'
  ORDER BY id DESC
  
SELECT @AHe AS [AH Scan Completed], @IMHe AS [IMH Scan Completed]
  
SELECT   [ObjectName], COUNT(databasename) AS [Number AH Databases Affected]
  FROM [A2CdbVariance].[dbo].[Results]
  WHERE runid IN (
  SELECT id FROM run WHERE starttime >@AHs AND starttime < @AHe)
  GROUP BY objectname
  ORDER BY objectname
  
  SELECT   databasename,  COUNT(ObjectName) AS [Number AH Objects Deployed]
  FROM [A2CdbVariance].[dbo].[Results]
  WHERE runid IN (
  SELECT id FROM run WHERE starttime >@AHs AND starttime < @AHe)
  GROUP BY databasename
  ORDER BY 2
  
  SELECT   [ObjectName], COUNT(databasename) AS [Number IMH Databases Affected]
  FROM [A2CdbVariance].[dbo].[Results]
  WHERE runid IN (
  SELECT id FROM run WHERE starttime >@IMHs AND starttime < @IMHe)
  GROUP BY objectname
  ORDER BY objectname
  
  SELECT   databasename,  COUNT(ObjectName) AS [Number IMH Objects Deployed]
  FROM [A2CdbVariance].[dbo].[Results]
  WHERE runid IN (
  SELECT id FROM run WHERE starttime >@IMHs AND starttime < @IMHe)
  GROUP BY databasename
  ORDER BY 2
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetLatestTableVersionsOriginalClass]    Script Date: 06/02/2016 18:52:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 5/1/2012
-- Description:	Returns versioning distribution for table definition with Column Order 
-- =============================================
CREATE FUNCTION [dbo].[GetLatestTableVersionsOriginalClass] 
(	
)
RETURNS TABLE 
AS
RETURN 
(
	with P as (
		select environmentid,databaseclass,objectname, Tbl,  count(*) as 'ObjCount'
		from dbo.LastVersionTables() l 
		inner join ServerDatabases sd on l.DatabaseName=sd.DatabaseName
		inner join dbservers ds  on l.servername=ds.ServerName 
		where   sd.ServerId=ds.ServerId 
		group by environmentid,databaseclass,objectname, Tbl
		),
	PP as (select environmentid,databaseclass,ObjCount,objectname, Tbl,
		row_number() over ( partition by P.objectName order by P.objectname, P.objcount desc) as VCount
		from P)

select PP.EnvironmentId ,pp.DatabaseClass ,PP.objectname, P1.databasename,ObjectType, PP.Tbl, ObjCount,VCount,P1.ObjectDefination
from PP inner join dbo.LastVersionTables() P1 on PP.objectname=P1.objectname and PP.Tbl=P1.Tbl
)
GO
/****** Object:  UserDefinedFunction [dbo].[GetLatestTableVersionsCleanClass1]    Script Date: 06/02/2016 18:52:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 5/1/2012
-- Description:	Returns versioning distribution for table definition w/out Column Order 
-- =============================================
CREATE FUNCTION [dbo].[GetLatestTableVersionsCleanClass1] 
(	
)
RETURNS TABLE 
AS
RETURN 
(
	with LO as (
		select ServerName,	DatabaseName, ObjectName, Tbl, TblSortByColumnname, ObjectType,ObjectDefination 
		from dbo.LastVersionTables()), 
	P as (
		select environmentid,databaseclass,objectname, TblSortByColumnname, count(*) as 'ObjCount'
		from LO l inner join ServerDatabases sd on l.DatabaseName=sd.DatabaseName
		inner join dbservers ds  on l.servername=ds.ServerName 
		where   sd.ServerId=ds.ServerId 
		group by environmentid,databaseclass,objectname, TblSortByColumnname
		),
	PP as (select environmentid,databaseclass,ObjCount,objectname,TblSortByColumnname,
		row_number() over ( partition by P.objectName order by P.objectname, P.objcount desc) as VCount
		from P)

select PP.EnvironmentId ,PP.DatabaseClass ,PP.objectname, P1.databasename,ObjectType, PP.TblSortByColumnname, ObjCount,VCount,p1.ObjectDefination
from PP inner join LO P1 on PP.objectname=P1.objectname and PP.TblSortByColumnname=P1.TblSortByColumnname

)
GO
/****** Object:  UserDefinedFunction [dbo].[GetLatestTableVersionsCleanClass]    Script Date: 06/02/2016 18:52:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 5/1/2012
-- Description:	Returns versioning distribution for table definition w/out Column Order 
-- =============================================
CREATE FUNCTION [dbo].[GetLatestTableVersionsCleanClass] 
(	
)
RETURNS TABLE 
AS
RETURN 
(
	with P as (
		select environmentid,l.servername,databaseclass,objectname, TblSortbyColumnName, count(*) as 'ObjCount'
		from dbo.LastVersionTables() l inner join ServerDatabases sd on l.DatabaseName=sd.DatabaseName
		inner join dbservers ds  on l.servername=ds.ServerName 
		where   sd.ServerId=ds.ServerId
		group by environmentid,l.servername,databaseclass,objectname, TblSortbyColumnName
		),
	PP as (select environmentid,servername, databaseclass,ObjCount,objectname,TblSortbyColumnName,
		row_number() over ( partition by P.objectName order by P.objectname, P.objcount desc) as VCount
		from P)

select PP.EnvironmentId ,PP.DatabaseClass ,PP.objectname, P1.databasename,ObjectType, PP.TblSortbyColumnName, ObjCount,VCount
from PP inner join dbo.LastVersionTables() P1 on PP.objectname=P1.objectname and PP.TblSortbyColumnName=P1.TblSortbyColumnName
inner join dbo.ServerDatabases ds on ds.DatabaseClass=pp.DatabaseClass 
inner join dbo.DBServers sd on sd.EnvironmentId=pp.EnvironmentId and sd.ServerName=pp.ServerName
where sd.ServerId=ds.ServerId

)
GO
/****** Object:  UserDefinedFunction [dbo].[GetLatestOjectVersionsCleanClassSingle]    Script Date: 06/02/2016 18:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 10/3/2012
-- Description:	Returns versioning distribution for object definition w/out whitespace and comments 
-- =============================================
Create FUNCTION [dbo].[GetLatestOjectVersionsCleanClassSingle] 
(	
	@objName nvarchar(128),
	@dbname nvarchar(128)
)
RETURNS TABLE 
AS
RETURN 
(
	with LO as (
		select ServerName,	DatabaseName, ObjectName, txtObj, txtObjNoWhiteSpace, ObjectType 
		from dbo.LastVersionOfAnObject(@objName,@dbname)), 
	P as (
		select environmentid,databaseclass,objectname, TxtObjNoWhiteSpace, count(*) as 'ObjCount'
		from LO l inner join ServerDatabases sd on l.DatabaseName=sd.DatabaseName
		inner join dbservers ds  on l.servername=ds.ServerName 
		where   sd.ServerId=ds.ServerId 
		group by environmentid,databaseclass,objectname, TxtObjNoWhiteSpace
		),
	PP as (select environmentid,databaseclass,ObjCount,objectname,TxtObjNoWhiteSpace,
		row_number() over ( partition by P.objectName order by P.objectname, P.objcount desc) as VCount
		from P)

select PP.EnvironmentId ,PP.DatabaseClass ,PP.objectname, P1.databasename,ObjectType, PP.TxtObjNoWhiteSpace, ObjCount,VCount
from PP inner join LO P1 on PP.objectname=P1.objectname and PP.TxtObjNoWhiteSpace=P1.TxtObjNoWhiteSpace
)
GO
/****** Object:  UserDefinedFunction [dbo].[GetLatestOjectVersionsCleanClass]    Script Date: 06/02/2016 18:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 5/1/2012
-- Description:	Returns versioning distribution for object definition w/out whitespace and comments 
-- =============================================
CREATE FUNCTION [dbo].[GetLatestOjectVersionsCleanClass] 
(	
)
RETURNS TABLE 
AS
RETURN 
(
	with LO as (
		select ServerName,	DatabaseName, ObjectName, txtObj, txtObjNoWhiteSpace, ObjectType 
		from dbo.LastVersionObjects()), 
	P as (
		select environmentid,databaseclass,objectname, TxtObjNoWhiteSpace, count(*) as 'ObjCount'
		from LO l inner join ServerDatabases sd on l.DatabaseName=sd.DatabaseName
		inner join dbservers ds  on l.servername=ds.ServerName 
		where   sd.ServerId=ds.ServerId 
		group by environmentid,databaseclass,objectname, TxtObjNoWhiteSpace
		),
	PP as (select environmentid,databaseclass,ObjCount,objectname,TxtObjNoWhiteSpace,
		row_number() over ( partition by P.objectName order by P.objectname, P.objcount desc) as VCount
		from P)

select PP.EnvironmentId ,PP.DatabaseClass ,PP.objectname, P1.databasename,ObjectType, PP.TxtObjNoWhiteSpace, ObjCount,VCount
from PP inner join LO P1 on PP.objectname=P1.objectname and PP.TxtObjNoWhiteSpace=P1.TxtObjNoWhiteSpace
)
GO
/****** Object:  UserDefinedFunction [dbo].[GetLatestObjectListForDbSourceLite]    Script Date: 06/02/2016 18:52:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from GetLatestObjectListForDbSourceLite() order by ObjectName asc
CREATE FUNCTION [dbo].[GetLatestObjectListForDbSourceLite]
(	
)
RETURNS TABLE 
AS
RETURN 
(
	WITH LatestTables  AS 
(
 SELECT l.*,d.DatabaseClass
	FROM dbo.Lastversiontables() l INNER JOIN serverdatabases d ON l.DatabaseName=d.DatabaseName
),
LT1 AS 
(SELECT DISTINCT r.ObjectName,
                 r.ObjectType,
                 SelectFrom=(SELECT DISTINCT TOP 1 databasename
                             FROM   LatestTables R2
                             WHERE  R.Objectname = r2.ObjectName
                                    AND R.tblsortbycolumnname = r2.tblsortbycolumnname
                                    AND r.DatabaseClass = r2.DatabaseClass
                             ORDER  BY 1 DESC),
                 DatabaseList = Replace((SELECT DISTINCT databasename AS [data()]
                                         FROM   LatestTables R2
                                         WHERE  R.Objectname = r2.ObjectName
                                                AND R.tblsortbycolumnname = r2.tblsortbycolumnname
                                                AND r.DatabaseClass = r2.DatabaseClass
                                         ORDER  BY 1 DESC
                                         FOR XML PATH ('')), ' ', ','),
                 TotalCount=(SELECT Count(*)
                             FROM   LatestTables Z
                             WHERE  R.Objectname = z.ObjectName
                                    AND R.tblsortbycolumnname = z.tblsortbycolumnname
                                    AND r.DatabaseClass = z.DatabaseClass),
                 DatabaseClass,
                 ServerName = (SELECT DISTINCT TOP 1 ServerName
                               FROM   LatestTables R2
                               WHERE  R.Objectname = r2.ObjectName
                                      AND R.tblsortbycolumnname = r2.tblsortbycolumnname
                                      AND r.DatabaseClass = r2.DatabaseClass
                                      and r.DatabaseName=r2.DatabaseName
                               ORDER  BY 1 DESC)
 FROM   LatestTables R 
 	),
Latestobjects AS ( SELECT *
                   FROM   dbo.Lastversionobjects() 
                    ), 

LO1 AS ( SELECT DISTINCT r.ObjectName,
                         r.ObjectType,
                         SelectFrom=(SELECT DISTINCT TOP 1 databasename
                                     FROM   LatestObjects R2
                                     WHERE  R.Objectname = r2.ObjectName
                                            AND R.txtobjnowhitespace = r2.txtobjnowhitespace
                                     ORDER  BY 1 DESC),
                         DatabaseList = Replace((SELECT DISTINCT databasename AS [data()]
                                                 FROM   LatestObjects R2
                                                 WHERE  R.Objectname = r2.ObjectName
                                                        AND R.txtobjnowhitespace = r2.txtobjnowhitespace
                                                 ORDER  BY 1 DESC
                                                 FOR XML PATH ('')), ' ', ','),
                         TotalCount=(SELECT Count(*)
                                     FROM   LatestObjects Z
                                     WHERE  R.Objectname = z.ObjectName
                                            AND R.txtobjnowhitespace = z.txtobjnowhitespace),
                         ServerName = (SELECT DISTINCT TOP 1 ServerName
                                       FROM   LatestObjects R2
                                       WHERE  R.Objectname = r2.ObjectName
                                              AND R.txtobjnowhitespace = r2.txtobjnowhitespace and r.DatabaseName=r2.DatabaseName 
                                       ORDER  BY 1 DESC)
         FROM   LatestObjects R 
         ) 

SELECT row_number() OVER (PARTITION BY a.ObjectName,databaseclass ORDER BY TotalCount desc) as rank, a.ObjectName,a.ObjectType, SelectFrom, DatabaseList,TotalCount,a.ServerName  FROM LT1 as a
UNION
SELECT row_number() OVER (PARTITION BY a.ObjectName ORDER BY TotalCount desc) as rank, a.ObjectName,a.ObjectType, SelectFrom, DatabaseList,TotalCount,a.ServerName FROM LO1 as a
--ORDER BY ObjectName	
)
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetObjectFacilityList]    Script Date: 06/02/2016 18:52:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_GetObjectFacilityList]
(	
	@ObjectName Varchar(200),
	@Tbl int,
	@dbClass int
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @FacilityList as varchar(max)

	
	select  @FacilityList = COALESCE(@FacilityList+',','') + lvt.databasename  from dbo.LastVersionTables() as LVT
	inner join dbo.ServerDatabases sd on sd.DatabaseName=LVT.DatabaseName
	where  
	ObjectName =@ObjectName
	and TblSortByColumnname=@Tbl
	and sd.databaseClass= @dbClass
	--and Databasename='TranWBMI'
	--ObjectName ='Charges'
	--and tbl=1393173935
	--and sd.databaseClass=1
	order by lvt.databasename asc

	--select @FacilityList
		
	RETURN @FacilityList		
END
GO
/****** Object:  UserDefinedFunction [dbo].[DatabaseWithSameHashAsDeletedObject]    Script Date: 06/02/2016 18:52:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 10/3/2012
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[DatabaseWithSameHashAsDeletedObject]
(
	@objectname sysname
)
RETURNS varchar(1000)
AS
BEGIN

declare @list varchar(1000);

with tmpvariance   (ObjectName, DatabaseName, TxtObj, TxtObjNoWhiteSpace,ObjectType,ObjectDefination ) as 
(select l.ObjectName, l.DatabaseName, l.TxtObj, l.TxtObjNoWhiteSpace,l.ObjectType,l.ObjectDefination 
from dbo.GetLatestOjectVersionsCleanClass() c  
inner join dbo.LastVersionofanObject(@objectname,'tran') l on l.ObjectName=c.objectname and c.databasename=l.DatabaseName and l.TxtObjNoWhiteSpace=c.TxtObjNoWhiteSpace  
where c.[ObjectName] = @objectname
and  c.databasename like 'Tran%'  
and l.TxtObjNoWhiteSpace=dbo.GetDeletedHashObject(@objectname)
)

SELECT @list =COALESCE(@list + ', ', '') + s1.DatabaseName 
         FROM tmpvariance s1 
      
return @list
END
GO
/****** Object:  StoredProcedure [dbo].[ObjectsCompareGroupedByDatabases]    Script Date: 06/02/2016 18:52:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		shiva maduru
-- Create date: 5/22/2012
-- Description:	Script for getting object definitions across DB class
-- =============================================
CREATE PROCEDURE [dbo].[ObjectsCompareGroupedByDatabases] 
	@objName nvarchar(128),
	@dbname nvarchar(128)
AS
BEGIN
	SET NOCOUNT ON;

select l.ObjectName, l.DatabaseName, l.TxtObj, l.TxtObjNoWhiteSpace,l.ObjectType,l.ObjectDefination 
into #tmpvariance
from dbo.GetLatestOjectVersionsCleanClass() c  
inner join dbo.LastVersionObjects() l on l.ObjectName=c.objectname and c.databasename=l.DatabaseName and l.TxtObjNoWhiteSpace=c.TxtObjNoWhiteSpace  

where c.[ObjectName] = @objName 
and  c.databasename like @dbname + '%'  

order by 1,4  

select m.ObjectName,m.TxtObjNoWhiteSpace,(SELECT CAST(s1.DatabaseName + ', ' AS VARCHAR(MAX))   
         FROM #tmpvariance s1   
         Where s1.TxtObjNoWhiteSpace=m.TxtObjNoWhiteSpace for xml path('')  
      ) AS databaseswithsamehash
      from #tmpvariance m
      group by m.ObjectName,m.TxtObjNoWhiteSpace
      Order by m.ObjectName
      
Drop table #tmpvariance


END
GO
/****** Object:  StoredProcedure [dbo].[ObjectsCompare]    Script Date: 06/02/2016 18:52:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 5/22/2012
-- Description:	Script for getting object definitions across DB class
-- =============================================
CREATE PROCEDURE [dbo].[ObjectsCompare] 
	@objName nvarchar(128),
	@dbname nvarchar(128)
AS
BEGIN
	SET NOCOUNT ON;

select l.ObjectName, l.DatabaseName, l.TxtObj, l.TxtObjNoWhiteSpace,l.ObjectType,l.ObjectDefination from dbo.GetLatestOjectVersionsCleanClassSingle(@objName,@dbname) c
inner join dbo.LastVersionOfAnObject(@objName,@dbname) l on l.ObjectName=c.objectname and c.databasename=l.DatabaseName and l.TxtObjNoWhiteSpace=c.TxtObjNoWhiteSpace
where c.[ObjectName] like @objName +'%'
and  c.databasename like @dbname + '%'
order by 1,4

END
GO
/****** Object:  StoredProcedure [dbo].[GetVariances1]    Script Date: 06/02/2016 18:52:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  shiva maduru  
-- Create date: 5/22/2012  
-- Description: Script for getting object definitions across DB class  
-- =============================================  
CREATE PROCEDURE [dbo].[GetVariances1]   
 @objName nvarchar(128),  
 @dbname nvarchar(128)  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
select l.ObjectName, l.DatabaseName, l.TxtObj, l.TxtObjNoWhiteSpace,l.ObjectType,l.ObjectDefination   
into #tmpvariance  
from dbo.GetLatestOjectVersionsCleanClass() c    
inner join dbo.LastVersionObjects() l on l.ObjectName=c.objectname and c.databasename=l.DatabaseName and l.TxtObjNoWhiteSpace=c.TxtObjNoWhiteSpace    
  
where c.[ObjectName] like @objName +'%'  
and  c.databasename like @dbname + '%'    
  
order by 1,4    
  
select m.ObjectDefination, m.ObjectName,m.TxtObjNoWhiteSpace,(SELECT CAST(s1.DatabaseName + ', ' AS VARCHAR(MAX))     
         FROM #tmpvariance s1     
         Where s1.TxtObjNoWhiteSpace=m.TxtObjNoWhiteSpace for xml path('')    
      ) AS DatabasesWithSameHash  
      from #tmpvariance m  
      group by m.ObjectName,m.TxtObjNoWhiteSpace  
      Order by m.ObjectName  
        
Drop table #tmpvariance  
  
  
END
GO
/****** Object:  StoredProcedure [dbo].[GetVariances]    Script Date: 06/02/2016 18:52:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		shiva maduru
-- Create date: 5/22/2012
-- Description:	Script for getting object definitions across DB class
-- =============================================
CREATE PROCEDURE [dbo].[GetVariances] 
	@objName nvarchar(128),
	@dbname nvarchar(128)
AS
BEGIN
	SET NOCOUNT ON;

select l.ObjectName, l.DatabaseName, l.TxtObj, l.TxtObjNoWhiteSpace,l.ObjectType,l.ObjectDefination 
into #tmpvariance
from dbo.GetLatestOjectVersionsCleanClass() c  
inner join dbo.LastVersionObjects() l on l.ObjectName=c.objectname and c.databasename=l.DatabaseName and l.TxtObjNoWhiteSpace=c.TxtObjNoWhiteSpace  

where c.[ObjectName] like @objName +'%'
and  c.databasename like @dbname + '%'  

order by 1,4  

select m.ObjectName,m.TxtObjNoWhiteSpace,(SELECT CAST(s1.DatabaseName + ', ' AS VARCHAR(MAX))   
         FROM #tmpvariance s1   
         Where s1.TxtObjNoWhiteSpace=m.TxtObjNoWhiteSpace for xml path('')  
      ) AS DatabasesWithSameHash
      from #tmpvariance m
      group by m.ObjectName,m.TxtObjNoWhiteSpace
      Order by m.ObjectName
      
Drop table #tmpvariance


END
GO
/****** Object:  UserDefinedFunction [dbo].[GetUniformObjectforDBClassClean]    Script Date: 06/02/2016 18:52:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 5/3/2012
-- Description:	Returns objects that exist in single form across all databases of a particular class (Cleaned definition)
-- =============================================
CREATE FUNCTION [dbo].[GetUniformObjectforDBClassClean] 
(	
	@DBClass int
)
RETURNS TABLE 
AS
RETURN 
(
select distinct objectname, ObjectType, ObjCount, VCount   
from [dbo].[GetLatestOjectVersionsCleanClass] () o inner join dbo.DatabaseClass c with (nolock) on o.DatabaseClass=c.ClassId
where DatabaseClass=@DBClass and ObjCount=c.TotalCount 
union
select distinct objectname, ObjectType, ObjCount, VCount   
from [dbo].[GetLatestTableVersionsCleanClass] () o inner join dbo.DatabaseClass c on o.DatabaseClass=c.ClassId
where DatabaseClass=@DBClass and ObjCount=c.TotalCount 
)
GO
/****** Object:  StoredProcedure [dbo].[usp_BadTableSummery]    Script Date: 06/02/2016 18:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Umesh Kumar
-- Create date: 8/20/2012
-- Description:	Get summery list of bed tables
-- exec usp_BadTableSummery 'Tran' 
-- =============================================
CREATE PROC [dbo].[usp_BadTableSummery] @DbClassName varchar(10) 
AS 
BEGIN

	select distinct GLT.ObjectName,GGLT.NoOfV   
	from dbo.GetLatestTableVersionsCleanClass1() as GLT
		left outer join 
		(select ObjectName,COUNT(distinct TblSortByColumnname)as NoOfV from dbo.GetLatestTableVersionsCleanClass1()
		where DatabaseClass=(select Classid from DatabaseClass where DBClass=@DbClassName) 
		and REPLACE(databasename,right(databasename,4),'')=@DbClassName
		group by ObjectName) as GGLT on GLT.ObjectName =GGLT.objectName
	where GLT.DatabaseClass=(select Classid from DatabaseClass where DBClass=@DbClassName)
	--and GLT.ObjectName='Charges'
	and REPLACE(GLT.databasename,right(GLT.databasename,4),'')=@DbClassName
	and GGLT.NoOfV >1
	group by GLT.ObjectName,TblSortByColumnname,GGLT.NoOfV
	order by GLT.ObjectName
	
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_BadTableDetails]    Script Date: 06/02/2016 18:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Umesh Kumar
-- Create date: 8/20/2012
-- Description:	Get detail list of bed tables
-- exec [usp_BadTableDetails] 'Tran' 
-- =============================================
CREATE PROC [dbo].[usp_BadTableDetails] @DbClassName varchar(10) 
AS 
BEGIN

	select GLT.ObjectName,GGLT.NoOfV,GLT.TblSortByColumnname as 'Table_CheckSum',COUNT(*) as Object_Exist_In_NoOfFacility,MAX(GLT.databasename)ExampleFacilityName
,dbo.[fn_GetObjectFacilityList](GLT.ObjectName,GLT.TblSortByColumnname,1) as FacilityList   
from dbo.GetLatestTableVersionsCleanClass1() as GLT
	left outer join 
	(select ObjectName,COUNT(distinct TblSortByColumnname)as NoOfV from dbo.GetLatestTableVersionsCleanClass1()
	where DatabaseClass=(select Classid from DatabaseClass where DBClass=@DbClassName) 
	and REPLACE(databasename,right(databasename,4),'')=@DbClassName
	group by ObjectName) as GGLT on GLT.ObjectName =GGLT.objectName
where 
GLT.DatabaseClass=(select Classid from DatabaseClass where DBClass=@DbClassName)
--and 
--GLT.ObjectName='Charges'
and REPLACE(GLT.databasename,right(GLT.databasename,4),'')=@DbClassName
and GGLT.NoOfV >1
group by GLT.ObjectName,TblSortByColumnname,GGLT.NoOfV
order by GLT.ObjectName
	
END;
GO
/****** Object:  StoredProcedure [dbo].[StartAnalysis]    Script Date: 06/02/2016 18:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 5/2/2012
-- Description:	Starts data analysys for an Environment
-- =============================================
CREATE PROCEDURE [dbo].[StartAnalysis] 
	@EnvId int = 1
AS
BEGIN
	SET NOCOUNT ON;
Declare @AnalysisId int

	insert into dbo.Analysis (EnvironmentId, StartTime)
	values (@EnvId, CURRENT_TIMESTAMP);
	set @AnalysisId=SCOPE_IDENTITY()	
	--Get the latest object versions
	exec dbo.PopulateMasterDataForAnalysis @AnalysisId;
	
	update dbo.Analysis
		Set EndTime=CURRENT_TIMESTAMP
	where Id=@AnalysisId
END
GO
/****** Object:  StoredProcedure [dbo].[TablesCompare]    Script Date: 06/02/2016 18:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 8/14/2012
-- Description:	Script for getting object definitions across DB class
-- =============================================
CREATE PROCEDURE [dbo].[TablesCompare] 
	@objName nvarchar(128),
	@dbname nvarchar(128)
AS
BEGIN
	SET NOCOUNT ON;

select l.ObjectName, l.DatabaseName, l.tbl, l.TblSortByColumnName,l.ObjectType,l.ObjectDefination 
from dbo.GetLatestTableVersionsCleanClass1() c
inner join dbo.LastVersionTables() l on l.ObjectName=c.objectname and c.databasename=l.DatabaseName and l.TblSortByColumnName=c.TblSortByColumnName
where 
--c.[ObjectName] like @objName +'%'
 c.[ObjectName] = @objName 
and  c.databasename like @dbname + '%'
order by 1,4

END
GO
/****** Object:  StoredProcedure [dbo].[populatecategoryC]    Script Date: 06/02/2016 18:52:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[populatecategoryC]
as 
create table #tmp (otype char(4), oname nvarchar(128), txtobj varbinary(16), dname nvarchar(128))

insert into #tmp exec dbo.GetObjectsCategoryC 1
insert into #tmp exec dbo.GetObjectsCategoryC 2
insert into #tmp exec dbo.GetObjectsCategoryC 3
insert into #tmp exec dbo.GetObjectsCategoryC 4

insert into resultscategory 
( [DBClassId],[objectName],[DatabaseID],[CategoryID]	)
select distinct  databaseclass, objectname, null, 3 from vwResults where objectname in (select oname from  #tmp)


 
create table #tbl (otype char(4), oname nvarchar(128), def varchar(max))

insert into #tbl exec dbo.GetTablesCategoryC 1
insert into #tbl exec GetTablesCategoryC 2
insert into #tbl exec GetTablesCategoryC 3
insert into #tbl exec GetTablesCategoryC 4

insert into resultscategory 
( [DBClassId],[objectName],[DatabaseID],[CategoryID]	)
select distinct  databaseclass, objectname, null, 3 from vwResults where objectname in (select oname from  #tbl)


drop table #tmp
drop table #tbl
GO
/****** Object:  StoredProcedure [dbo].[populatecategoryb]    Script Date: 06/02/2016 18:52:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[populatecategoryb]
as 
create table #tmp (otype char(4), oname nvarchar(128), txtobj varbinary(16), dname nvarchar(128))

insert into #tmp exec dbo.GetObjectsCategoryB 1
insert into #tmp exec dbo.GetObjectsCategoryB 2
insert into #tmp exec dbo.GetObjectsCategoryB 3
insert into #tmp exec dbo.GetObjectsCategoryB 4

insert into resultscategory 
( [DBClassId],[objectName],[DatabaseID],[CategoryID]	)
select distinct  databaseclass, objectname, null, 2 from vwResults where objectname in (select oname from  #tmp)


 
create table #tbl (otype char(4), oname nvarchar(128), def varchar(max))

insert into #tbl exec dbo.GetTablesCategoryB 1
insert into #tbl exec GetTablesCategoryB 2
insert into #tbl exec GetTablesCategoryB 3
insert into #tbl exec GetTablesCategoryB 4

insert into resultscategory 
( [DBClassId],[objectName],[DatabaseID],[CategoryID]	)
select distinct  databaseclass, objectname, null, 2 from vwResults where objectname in (select oname from  #tbl)


select * from resultscategory
drop table #tmp
drop table #tbl
GO
/****** Object:  StoredProcedure [dbo].[populatecategoryA]    Script Date: 06/02/2016 18:52:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[populatecategoryA]
as 
create table #tmp (otype char(4), oname nvarchar(128), txtobj varbinary(16), dname nvarchar(128))

insert into #tmp exec GetObjectsCategoryA 1
insert into #tmp exec GetObjectsCategoryA 2
insert into #tmp exec GetObjectsCategoryA 3
insert into #tmp exec GetObjectsCategoryA 4

insert into resultscategory 
( [DBClassId],[objectName],[DatabaseID],[CategoryID]	)
select distinct  databaseclass, objectname, null, 1 from vwResults where objectname in (select oname from  #tmp)


 
create table #tbl (otype char(4), oname nvarchar(128), def varchar(max))

insert into #tbl exec GetTablesCategoryA 1
insert into #tbl exec GetTablesCategoryA 2
insert into #tbl exec GetTablesCategoryA 3
insert into #tbl exec GetTablesCategoryA 4

insert into resultscategory 
( [DBClassId],[objectName],[DatabaseID],[CategoryID]	)
select distinct  databaseclass, objectname, null, 1 from vwResults where objectname in (select oname from  #tbl)


select * from resultscategory
drop table #tmp
drop table #tbl
GO
/****** Object:  StoredProcedure [dbo].[usp_RequestDbObjectInsert]    Script Date: 06/02/2016 18:52:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================            
-- Author:  Umesh Kumar            
-- Create date: 4/12/2012            
-- Description: Inserting database objects like (SP,View,Function etc.) and there analysis results into request table.            
-- =============================================            
ALTER PROCEDURE [dbo].[usp_RequestDbObjectInsert]            
     @RunId AS INT,            
     @ServerName AS VARCHAR(100),            
     @DbName VARCHAR(50),            
     @LinkedServerPrefix nchar(3)=N'VDT'            
 AS            
 --execute [usp_RequestDbObjectInsert] 37909,'AHS-CARE05','TranSJMC'   
-- TranSJMA  
--TranSJMC           
 BEGIN     
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED             
 CREATE TABLE #DbObjects  (RunId INT, SERVERNAME VARCHAR(100),DatabaseName VARCHAR(100),ObjectName VARCHAR(200),ObjectType VARCHAR(5),TxtObj VARBINARY(50),TxtObjNoWhiteSpace VARBINARY(50),ObjectDefinition VARCHAR(MAX))            
  
  BEGIN TRY            
      DECLARE @str NVARCHAR(MAX)          
--   set @str = ''          
--SET @str = N' insert into #DbObjects (Runid,ServerName,DatabaseName,ObjectName,ObjectType,TxtObj,TxtObjNoWhiteSpace,ObjectDefinition) '            
   SET @str = N' insert into #DbObjects (Runid,ServerName,DatabaseName,ObjectName,ObjectType,ObjectDefinition) '            
   SET @str = @str + ' select ' + CONVERT(VARCHAR(10),@RunId) + ' as RunId,''' + @ServerName + ''' as ServerName,''' + @DbName + ''' as DbName, scm.name+''.''+o.name, o.Type,            
    c.Definition            
   from ['+@ServerName+'].[' +  @DbName + '].dbo.sysobjects o (nolock)            
   inner join ['+@ServerName+'].[' + @DbName + '].sys.sql_modules c (nolock) on c.object_id = o.id             
   inner join ['+@ServerName+'].[' + @DbName + '].sys.objects obj (nolock) on  obj.object_id = o.id   
   inner join ['+@ServerName+'].[' + @DbName + '].sys.schemas scm (nolock)on obj.schema_id = scm.schema_id            
   where o.type in (''P'',''V'',''FN'',''IF'',''TF'',''U'',''TR'')            
   and obj.is_ms_shipped = 0            
   and o.[name] not like ''sp[_]%diagram%''            
   and o.[name] not like ''fn[_]%diagram%''            
   and o.name not in (select ObjectName from IntermediateResults (Nolock) where RunId='+ CONVERT(NVARCHAR(11),@RunId ) +' and DatabaseName ='''+@DbName+''')             
   and o.name not in (Select [Name] from ExcludedDbObject (Nolock) )'   
              
  -- PRINT @str            
   --insert into #DbObjects          
   EXEC sp_ExecuteSql @str            
   Print 1         
  -- select '#DbObjects',* from #DbObjects
               
   INSERT INTO IntermediateResults (Runid,SERVERNAME,DatabaseName,ObjectName,ObjectType,TxtObj,TxtObjNoWhiteSpace,ObjectDefination)            
   SELECT RunId, REPLACE(@ServerName,@LinkedServerPrefix,''), DatabaseName, ObjectName, ObjectType, dbo.MakeMD5Hash(Upper(REPLACE(ObjectDefinition,';',''))) as 'hashbytes',            
   dbo.MakeMD5Hash(dbo.RemoveWhiteSpace(dbo.RemoveComments(ObjectDefinition))) 'hashbytesRemoveAll',ObjectDefinition  
   FROM #DbObjects ;           
   SELECT SERVERNAME,DatabaseName,ObjectType, COUNT(1) AS ObjCount FROM #DbObjects GROUP BY SERVERNAME,DatabaseName,ObjectType            
  END TRY            
  BEGIN CATCH            
   DECLARE @ErrorMessage NVARCHAR(4000);            
   DECLARE @ErrorSeverity INT;            
   DECLARE @ErrorState INT;            
            
   SELECT             
    @ErrorMessage = ERROR_MESSAGE(),            
    @ErrorSeverity = ERROR_SEVERITY(),            
    @ErrorState = ERROR_STATE();            
            
   -- Use RAISERROR inside the CATCH block to return error            
   -- information about the original error that caused            
   -- execution to jump to the CATCH block.  
     DECLARE @Output VARCHAR(2500)      
			   SET @Output = 'Inner Catch Error usp_RequestDbObjectInsert :' + CHAR(13)      
			  SET @Output = @Output + 'ErrorProcedure: ' + ISNULL(CONVERT(VARCHAR(126),ERROR_PROCEDURE()), '') + CHAR(13)            
			   SET @Output = @Output + 'ErrorLine:      ' + ISNULL(CONVERT(VARCHAR(11), ERROR_LINE()), '') + CHAR(13)            
			   SET @Output = @Output + 'ErrorMessage:   ' + ISNULL(CONVERT(VARCHAR(2048),ERROR_MESSAGE()), '') + CHAR(13)            
			   SET @Output = @Output + 'ErrorNumber:    ' + ISNULL(CONVERT(VARCHAR(11), ERROR_NUMBER()), '') + CHAR(13)            
			   SET @Output = @Output + 'ErrorSeverity:  ' + ISNULL(CONVERT(VARCHAR(11), ERROR_SEVERITY()), '') + CHAR(13)            
			   SET @Output = @Output + 'ErrorState:     ' + ISNULL(CONVERT(VARCHAR(11), ERROR_STATE()), '') + CHAR(13)  
	         
			  INSERT INTO [LOG](RunId,[LogDetail],[LogDateTime])      
			  VALUES (@RunId,@Output,CURRENT_TIMESTAMP)              
   RAISERROR (@ErrorMessage, -- Message text.            
        @ErrorSeverity, -- Severity.            
        @ErrorState -- State.            
        );            
  END CATCH;            
            
                 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_PopulateDbObjects]    Script Date: 06/02/2016 18:52:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================      
-- Author:  Umesh Kumar      
-- Create date: 4/16/2012      
-- Description: Populating database objects into request table.      
-- =============================================      
CREATE PROCEDURE [dbo].[usp_PopulateDbObjects]      
  @AnalysisID int,      
        @pServerName AS VARCHAR(100),      
        @pDbName VARCHAR(50),      
        @pRunId INT =0,      
        @LinkedServerPrefix NCHAR(3)=N'VDT'      
 AS      
 -- execute [usp_PopulateDbObjects] 100,'AHS-Care05','TranSJMC',37909      
  --execute [usp_PopulateDbObjects] 'AHV-DevTran02','TranF%'      
BEGIN      
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
       
 DECLARE @DbName VARCHAR(50)      
 DECLARE @ServerName AS VARCHAR(100)      
 DECLARE @RunId AS INT      
 --set @serverName= 'AHV-DevTran03'      
 SET @ServerName= @pServerName      
 DECLARE @sqlStatement NVARCHAR(4000)      
 DECLARE @dbDetail TABLE(name VARCHAR(100))      
 declare @SN nvarchar(128)      
 DECLARE @MaxCount INT       
 SET @MaxCount=4      
 DECLARE @Counter INT       
 SET @Counter =1      
 DECLARE @DelayLength_hh_mm_ss CHAR(8)      
 SET @DelayLength_hh_mm_ss ='00:00:02';  
 
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ObjectCounts]') AND type in (N'U'))
	begin    
	DROP TABLE [dbo].[ObjectCounts]    
	end
   Create TABLE [dbo].[ObjectCounts](SERVERNAME VARCHAR(100), DatabaseName VARCHAR(100),ObjectType CHAR(10), ObjCount INT)      
 
 IF (@pRunId >0 )      
  BEGIN      
   SELECT  @RunId = @pRunId      
  END      
 ELSE      
  ----Insert value into Run Table      
  BEGIN      
   INSERT INTO Run(SERVERNAME,StartTime) SELECT @ServerName,GETDATE()       
   SELECT  @RunId = IDENT_CURRENT('Run')      
  END      
   
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IntermediateResults]') AND type in (N'U'))
begin    
DROP TABLE [dbo].[IntermediateResults]    
end

CREATE TABLE [dbo].[IntermediateResults](    
 [RunId] [int] NOT NULL,    
 [ServerName] [varchar](100) NOT NULL,    
 [DatabaseName] [varchar](100) NOT NULL,    
 [ObjectName] [varchar](200) NOT NULL,    
 [ObjectType] [varchar](5) NOT NULL,    
 [TxtObj] [varbinary](50) NULL,    
 [TxtObjNoWhiteSpace] [varbinary](50) NULL,    
 [Tbl] [varbinary](50) NULL,    
 [TblSortbyColumnName] [varbinary](50) NULL,    
 [ObjectDefination] [varchar](max) NULL    
) ON [PRIMARY]    
    
  BEGIN TRY      
   SET @sqlStatement = 'select  name from ['+@ServerName+'].master.sys.databases where name like '''+@pDbName+'''       
         and name not in (select distinct DatabaseName from IntermediateResults where RunID='+ CONVERT(NVARCHAR(11),@RunId ) +' )      
         and name not in (Select Name from ExcludedDatabase )'      
   --print @sqlStatement      
   INSERT INTO @dbDetail EXECUTE  sp_executesql @sqlStatement      
         
StartProcess: -- Go to Statement Label      
------/** Declare Cursur(1) here**/------------      
   DECLARE C_DBName CURSOR Local fast_forward FOR SELECT name FROM @dbDetail      
   OPEN C_DBName      
   FETCH NEXT from C_DBName INTO @DbName      
    WHILE @@FETCH_STATUS = 0      
       BEGIN      
       EXEC CheckLinkedServer @ServerName;      
        --Log -Starting new database      
        --Print 'Starting DB:'+@DbName      
        INSERT INTO [LOG](RunId,[LogDetail],[LogDateTime])      
         VALUES (@RunId,'Log - Starting new database Name : '+ @DbName,GETDATE())      
        BEGIN TRAN       
              
         BEGIN TRY      
          --Get Table details      
          INSERT INTO IntermediateResults (RunId,SERVERNAME,DatabaseName,ObjectName,ObjectType,tbl,TblSortbyColumnName,ObjectDefination)      
          EXEC dbo.usp_TableChecksum @RunId,@serverName,@DbName      

          print 'Step# 0'  
           --Get other objects details (SP,FN,VW)      
          INSERT INTO ObjectCounts VALUES (@ServerName,@DbName,'U',@@ROWCOUNT)  
          print 'Step# 1'   
           
          INSERT INTO ObjectCounts (SERVERNAME, DatabaseName,ObjectType, ObjCount)      
          EXEC dbo.[usp_RequestDbObjectInsert] @RunId,@serverName,@DbName  
              
          print 'Step# 2' 
          select case when ObjectType ='U' then 'Table' else 'Other Then Tables' end, * from IntermediateResults
          
          SET @SN=REPLACE(@ServerName,@LinkedServerPrefix,'')      
          
          update R  set ObjCountActual= C.ObjCount      
          from  dbo.ObjectCountReport R       
          inner join ObjectCounts C on C.databaseName=R.DatabaseName and C.ObjectType=R.ObjectType      
          where R.AnalysisId=@AnalysisID and R.Servername=@SN      
          print 'Step# 3 @SN, @DbName,@RunId '+ +convert(varchar(25),@SN)+'|'+ @DbName +'|'+convert(varchar(25),@RunId)       
          exec usp_ApplyDeltas @SN, @DbName,@RunId       
          -- Delete facility name record from variable table.      
          DELETE FROM   @dbDetail WHERE name = @DbName      
          --select * from @dbDetail   
          print 'Step# 4'     
         END TRY       
               
         BEGIN CATCH      
			  DECLARE @Output VARCHAR(2500)      
			   SET @Output = 'Inner Catch Error:' + CHAR(13)      
			   SET @Output = @Output + 'ErrorProcedure: ' + ISNULL(CONVERT(VARCHAR(126),ERROR_PROCEDURE()), '') + CHAR(13)            
			   SET @Output = @Output + 'ErrorLine:      ' + ISNULL(CONVERT(VARCHAR(11), ERROR_LINE()), '') + CHAR(13)            
			   SET @Output = @Output + 'ErrorMessage:   ' + ISNULL(CONVERT(VARCHAR(2048),ERROR_MESSAGE()), '') + CHAR(13)            
			   SET @Output = @Output + 'ErrorNumber:    ' + ISNULL(CONVERT(VARCHAR(11), ERROR_NUMBER()), '') + CHAR(13)            
			   SET @Output = @Output + 'ErrorSeverity:  ' + ISNULL(CONVERT(VARCHAR(11), ERROR_SEVERITY()), '') + CHAR(13)            
			   SET @Output = @Output + 'ErrorState:     ' + ISNULL(CONVERT(VARCHAR(11), ERROR_STATE()), '') + CHAR(13)            
	         
			  IF @@TRANCOUNT > 0      
			  ROLLBACK TRANSACTION;      
	                
			  INSERT INTO [LOG](RunId,[LogDetail],[LogDateTime])      
			  VALUES (@RunId,@Output,CURRENT_TIMESTAMP)      
                
         END CATCH      
               
         IF @@TRANCOUNT > 0      
         BEGIN      
          COMMIT TRANSACTION;      
         END      
              
        --Log -Starting new database      
        --Print 'End DB:'+@DbName      
        INSERT INTO [LOG]([RunId],[LogDetail],[LogDateTime])      
         VALUES (@RunId,'Log -Ending database Name : '+ @DbName,CURRENT_TIMESTAMP)       
                
        FETCH NEXT FROM C_DBName INTO @DbName      
       END      
   CLOSE C_DBName      
   DEALLOCATE C_DBName      
         
   -- Validate no of facility is not processed and Re run the process again.       
   IF (SELECT COUNT (name) FROM @dbDetail) >0      
   BEGIN      
         
    IF (@Counter < @MaxCount)      
     BEGIN      
      --Print 'Count: '+ convert(varchar,@Counter);      
      SET @Counter = @Counter +1;      
      
      --Log -Waiting for spacefic amount of time for recall the process.       
      INSERT INTO [LOG]([RunId],[LogDetail],[LogDateTime])      
         VALUES (@RunId,'Log -Waiting for Time : '+ @DelayLength_hh_mm_ss,CURRENT_TIMESTAMP)       
            
      -- Waiting for spavefic amount of time.         
      --select Getdate();          
      WAITFOR Delay @DelayLength_hh_mm_ss;      
      --select Getdate();      
        
      GOTO StartProcess;      
     END       
   END      
        
   -- Update Run Table for End Time      
   UPDATE Run SET EndTime =GETDATE() WHERE id=@RunId      
        
  END TRY      
  BEGIN CATCH      
  DECLARE @OutputOut VARCHAR(2500)      
           SET @OutputOut = 'Outer Catch Error:' + CHAR(13)      
           SET @OutputOut = @OutputOut + 'ErrorProcedure: ' + ISNULL(CONVERT(VARCHAR(126),ERROR_PROCEDURE()), '') + CHAR(13)            
           SET @OutputOut = @OutputOut + 'ErrorLine:      ' + ISNULL(CONVERT(VARCHAR(11), ERROR_LINE()), '') + CHAR(13)            
           SET @OutputOut = @OutputOut + 'ErrorMessage:   ' + ISNULL(CONVERT(VARCHAR(2048),ERROR_MESSAGE()), '') + CHAR(13)            
    SET @OutputOut = @OutputOut + 'ErrorNumber:    ' + ISNULL(CONVERT(VARCHAR(11), ERROR_NUMBER()), '') + CHAR(13)            
           SET @OutputOut = @OutputOut + 'ErrorSeverity:  ' + ISNULL(CONVERT(VARCHAR(11), ERROR_SEVERITY()), '') + CHAR(13)            
           SET @OutputOut = @OutputOut + 'ErrorState:     ' + ISNULL(CONVERT(VARCHAR(11), ERROR_STATE()), '') + CHAR(13)            
         
    INSERT INTO [LOG]([RunId],[LogDetail],[LogDateTime])      
    VALUES (@RunId,@OutputOut,CURRENT_TIMESTAMP)      
  END CATCH      
-- SELECT @RunId AS 'Run ID'      
 --Drop TABLE #ObjectCounts      
 --Drop TABLE  ##IntermediateResults    
   select  * from LOG with(nolock)  WHERE RunId  = @RunId 
END
GO
/****** Object:  StoredProcedure [Analysis].[usp_PopulateDbObjects]    Script Date: 06/02/2016 18:51:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Umesh Kumar
-- Create date: 4/16/2012
-- Description:	Populating database objects into request table.
-- =============================================
Create procedure [Analysis].[usp_PopulateDbObjects]
        @pServerName as varchar(100),
        @pDbName varchar(50),
        @pRunId int =0
 As
 -- execute [usp_PopulateDbObjects] 'AHS-Care03','TranDHPS',4
  --execute [usp_PopulateDbObjects] 'AHV-DevTran02','TranF%'
Begin
 
	Declare @DbName varchar(50)
	Declare @ServerName as varchar(100)
	Declare @RunId as int
	--set @serverName= 'AHV-DevTran03'
	set @ServerName= @pServerName
	declare @sqlStatement nvarchar(4000)
	declare @dbDetail table(name varchar(100))
	declare @MaxCount int 
	set @MaxCount=4
	declare @Counter int 
	set @Counter =1
	declare @DelayLength_hh_mm_ss char(8)
	set @DelayLength_hh_mm_ss ='00:00:02';
	
	if (@pRunId >0 )
		Begin
			select  @RunId = @pRunId
		End
	Else
		----Insert value into Run Table
		Begin
			Insert into Run(ServerName,StartTime) select @ServerName,GETDATE() 
			select  @RunId = ident_current('Run')
		End
	

		Begin Try
			set @sqlStatement = 'select  name from ['+@ServerName+'].master.sys.databases where name like '''+@pDbName+''' 
									and name not in (select distinct DatabaseName from Results where RunID='+ convert(nvarchar(11),@RunId ) +' )
									and name not in (Select Name from ExcludedDatabase )'
			--print @sqlStatement
			INSERT into @dbDetail EXECUTE  sp_executesql @sqlStatement
			
			
StartProcess: -- Go to Statement Label
------/** Declare Cursur(1) here**/------------
			Declare C_DBName cursor for select name from @dbDetail
			Open C_DBName
			Fetch C_DBName into @DbName
				While @@FETCH_STATUS = 0
							BEGIN
								
								--Log -Starting new database
								--Print 'Starting DB:'+@DbName
								INSERT INTO [Log](RunId,[LogDetail],[LogDateTime])
									VALUES (@RunId,'Log -Starting new database Name : '+ @DbName,Getdate())
								Begin Tran	
								
									Begin Try
										--select @DbName
										insert into dbo.results (RunId,ServerName,DatabaseName,ObjectName,ObjectType,tbl,TblSortbyColumnName,ObjectDefination)
										exec dbo.usp_TableChecksum @RunId,@serverName,@DbName;

										execute [usp_RequestDbObjectInsert] @RunId,@serverName,@DbName
										
										-- Delete facility name record from variable table.
										Delete from   @dbDetail where name = @DbName
										--select * from @dbDetail
									End Try	
									
									Begin Catch
										DECLARE @Output varchar(2500)
										 SET @Output = 'Inner Catch Error:' + CHAR(13)
										 SET @Output = @Output + 'ErrorProcedure: ' + ISNULL(CONVERT(varchar(126),ERROR_PROCEDURE()), '') + CHAR(13)      
										 SET @Output = @Output + 'ErrorLine:      ' + ISNULL(CONVERT(varchar(11), ERROR_LINE()), '') + CHAR(13)      
										 SET @Output = @Output + 'ErrorMessage:   ' + ISNULL(CONVERT(varchar(2048),ERROR_MESSAGE()), '') + CHAR(13)      
										 SET @Output = @Output + 'ErrorNumber:    ' + ISNULL(CONVERT(varchar(11), ERROR_NUMBER()), '') + CHAR(13)      
										 SET @Output = @Output + 'ErrorSeverity:  ' + ISNULL(CONVERT(varchar(11), ERROR_SEVERITY()), '') + CHAR(13)      
										 SET @Output = @Output + 'ErrorState:     ' + ISNULL(CONVERT(varchar(11), ERROR_STATE()), '') + CHAR(13)      
   
										IF @@TRANCOUNT > 0
										ROLLBACK TRANSACTION;
										
										INSERT INTO [Log](RunId,[LogDetail],[LogDateTime])
										VALUES (@RunId,@Output,Current_Timestamp)
										
									End Catch
									
									IF @@TRANCOUNT > 0
									BEGIN
										COMMIT TRANSACTION;
									END
								
								--Log -Starting new database
								--Print 'End DB:'+@DbName
								INSERT INTO [Log]([RunId],[LogDetail],[LogDateTime])
									VALUES (@RunId,'Log -Ending database Name : '+ @DbName,Current_Timestamp) 
									 
								Fetch Next From C_DBName into @DbName
							END
			close C_DBName
			deallocate C_DBName
			
			-- Validate no of facility is not processed and Re run the process again.	
			if (select count (name) from @dbDetail) >0
			Begin
			
				if (@Counter < @MaxCount)
					Begin
						--Print 'Count: '+ convert(varchar,@Counter);
						set @Counter = @Counter +1;

						--Log -Waiting for spacefic amount of time for recall the process. 
						INSERT INTO [Log]([RunId],[LogDetail],[LogDateTime])
									VALUES (@RunId,'Log -Waiting for Time : '+ @DelayLength_hh_mm_ss,Current_Timestamp) 
						
						-- Waiting for spavefic amount of time.			
						--select Getdate();				
						WAITFOR Delay @DelayLength_hh_mm_ss;
						--select Getdate();
		
						goto StartProcess;
					End 
			End
		
			-- Update Run Table for End Time
			Update Run Set EndTime =Getdate() where id=@RunId
		
		End Try
		Begin Catch
		DECLARE @OutputOut varchar(2500)
										 SET @OutputOut = 'Outer Catch Error:' + CHAR(13)
										 SET @OutputOut = @OutputOut + 'ErrorProcedure: ' + ISNULL(CONVERT(varchar(126),ERROR_PROCEDURE()), '') + CHAR(13)      
										 SET @OutputOut = @OutputOut + 'ErrorLine:      ' + ISNULL(CONVERT(varchar(11), ERROR_LINE()), '') + CHAR(13)      
										 SET @OutputOut = @OutputOut + 'ErrorMessage:   ' + ISNULL(CONVERT(varchar(2048),ERROR_MESSAGE()), '') + CHAR(13)      
										 SET @OutputOut = @OutputOut + 'ErrorNumber:    ' + ISNULL(CONVERT(varchar(11), ERROR_NUMBER()), '') + CHAR(13)      
										 SET @OutputOut = @OutputOut + 'ErrorSeverity:  ' + ISNULL(CONVERT(varchar(11), ERROR_SEVERITY()), '') + CHAR(13)      
										 SET @OutputOut = @OutputOut + 'ErrorState:     ' + ISNULL(CONVERT(varchar(11), ERROR_STATE()), '') + CHAR(13)      
   
			 INSERT INTO [Log]([RunId],[LogDetail],[LogDateTime])
			 VALUES (@RunId,@OutputOut,Current_Timestamp)
		End Catch
	Select @RunId as 'Run ID'
End
GO
/****** Object:  StoredProcedure [dbo].[ReportDeletedObjectsTran]    Script Date: 06/02/2016 18:52:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viktor Misyutin
-- Create date: 10/3/2012
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[ReportDeletedObjectsTran] 
	
AS
BEGIN
set transaction isolation level read uncommitted

	select l.objectname, l.objecttype, count(1) as counts,
	(select count(*) from (
	select ServerName, DatabaseName, ObjectName,  MAX(runid) MaxRunId
	from Results with (NOLOCK) 
	where objecttype<>'U' and RunId in ( select ID from Run with (NOLOCK) where EndTime is not null)
	and DatabaseName not in (Select [name] from dbo.excludeddatabase)
	and l.objectname=objectname
	group by ServerName, DatabaseName, ObjectName) a) as TotalCount
into #123
from lastversionobjects() l
where l.objectdefination='deleted'
 and l.DatabaseName=DatabaseName
group by objectname, objecttype
order by 3 desc,2,1
select * from #123
where counts=TotalCount

select z.*,dbo.DatabaseWithSameHashAsDeletedObject(z.objectname) from #123 z
where counts<>TotalCount
drop table #123

END
GO
/****** Object:  StoredProcedure [dbo].[LoopThroughDatabasesAH]    Script Date: 06/02/2016 18:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--dbo.LoopThroughDatabasesAH                              
CREATE PROCEDURE [dbo].[LoopThroughDatabasesAH] @ConnectionTestOnly BIT =1,                                                        
                                                @EnvironmentId      INT=1                                                        
AS                                                        
    SET NOCOUNT ON   
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                                                             
    DECLARE @NextDb             INT,                                                        
            @iCurrentRowId      INT,                                                        
            @DatabaseName       NVARCHAR(128),                                                        
            @ServerName         NVARCHAR(128),                                                        
            @ParamDef           NVARCHAR(100),                                                        
            @Result             VARCHAR(500),                                                        
            @ExecResult         INT,                                                        
            @Action             VARCHAR(2048),                                                        
            @ErrorCount         INT,                                                        
            @PreviousServerName NVARCHAR(128),                                                        
            @DBCount            INT,                                                        
            @LinkedServerPrefix NCHAR(3),                                                        
            @isError            BIT                                                        
    DECLARE @DatabaseList TABLE                                                        
      (                                                        
         RowId        INT,                                                        
         SERVERNAME   NVARCHAR(128),                                                        
         DatabaseName NVARCHAR(128)                                                        
      );                                                        
    DECLARE @DatabaseProcessingLog TABLE                                                        
      (                                                        
         id               INT IDENTITY(1, 1),                                                        
         SERVERNAME       NVARCHAR(128),                                                        
         DatabaseName     NVARCHAR(128),                                                        
         EventDescription VARCHAR(2048),                                                        
         EventDateTime    DATETIME                                                        
      );                                                        
    DECLARE @errorLog TABLE                                                        
      (                                                        
         id               INT IDENTITY(1, 1),                                                        
         ErrorDescription VARCHAR(2048)                                                        
      )                                                        
    --DECLARE  @ObjectCount TABLE (SERVERNAME NVARCHAR(128), DatabaseName NVARCHAR(128), ObjectType NCHAR(3), ObjCount INT, ObjCountActual INT,  PRIMARY KEY CLUSTERED(SERVERNAME,DatabaseName,ObjectType) );                                                  
  
                             
    DECLARE @AnalysisID INT                                                        
    INSERT INTO dbo.Analysis                                                        
                (EnvironmentId)                                                        
VALUES      (@EnvironmentId)                                                        
    SET @AnalysisID= Scope_identity()                                                        
    INSERT INTO @DatabaseList                             
    SELECT Rank()                                                        
             OVER (                                                 
               ORDER BY SERVERNAME, DatabaseName) AS RowId,                                        
           SERVERNAME,                                                        
           DatabaseName                                                        
    FROM   [dbo].[ServerDatabases] sd                      
           INNER JOIN dbo.DBServers ds                                                        
                   ON sd.serverid = ds.Serverid                                                        
    WHERE ds.environmentid=@EnvironmentId                                
    -- SERVERNAME NOT LIKE '%A2A%'                                        
    and DatabaseName not in (Select Name from ExcludedDatabase )                               
   -- AND   DatabaseName IN ('TranMAMI','TranMMME','TranWYMI')     
--and DatabaseName like 'Tran%'                                                                                 
    ORDER  BY SERVERNAME,                                                        
              DatabaseName                                                        
    INSERT INTO ProgressReportAH                                                        
                (AnalysisId,                                                        
     SERVERNAME,                                                        
                 DatabaseName)                                                        
    SELECT @AnalysisID,                                                        
           SERVERNAME,                                                        
           DatabaseName                                                        
    FROM   @DatabaseList                                                  
    ORDER  BY SERVERNAME,                                                        
              DatabaseName                                                        
    SELECT @ErrorCount = 0,                                              
           @PreviousServerName = '',                                                        
           @DBCount = 0,                                                        
           @ParamDef = N'@ResultOut varchar(500) OUTPUT',                                                        
           @LinkedServerPrefix = N'VDT',                                                        
           @isError = 0;                                                        
    SELECT @NextDb = Min(RowId)                                                        
    FROM   @DatabaseList                                                        
    IF Isnull(@NextDb, 0) = 0                                                        
      BEGIN                                                        
          SELECT 'NO DATA IS FOUND IN TABLE!'                                                        
          RETURN                                                        
      END                                                        
    SELECT @iCurrentRowId = RowId,                           @DatabaseName = DatabaseName,                                                        
           @ServerName = @LinkedServerPrefix + SERVERNAME                                                        
    FROM   @DatabaseList                                                 
    WHERE  RowId = @NextDb                                                        
    WHILE 1 = 1                                                        
      BEGIN                                                        
          BEGIN TRY                                                        
              SET @DBCount=@DBCount + 1                                                        
              IF ( @PreviousServerName <> @ServerName )                                                        
                BEGIN                                                        
                    EXEC @ExecResult=Drop_createlinkedserver                                       
                      @ServerName,                                                        
                      1                                   
                    SET @Action='Creating Linked Server ' + @ServerName                                                        
                    INSERT INTO @DatabaseProcessingLog                                                 
                                (SERVERNAME,                                                        
                                 DatabaseName,                                                        
         EventDescription,                                                        
                                 EventDateTime)                                                        
                    VALUES      (@ServerName,                                      
                                 @DatabaseName,                                                        
                                 @Action + ' for '                                     
                                 + Replace(@ServerName, @LinkedServerPrefix, ''),                                                        
                                 CURRENT_TIMESTAMP )                            
                END                                                        
              UPDATE ProgressReportAH                                                        
              SET    StartDateTime = CURRENT_TIMESTAMP                            
              WHERE  AnalysisId = @AnalysisID                                                        
                     AND SERVERNAME = Replace(@ServerName, @LinkedServerPrefix, '')                         
                     AND DatabaseName = @DatabaseName                                                        
              SET @Action='Processing Started for ' + @DatabaseName                                                        
              INSERT INTO @DatabaseProcessingLog                                                        
                          (SERVERNAME,                                                        
                           DatabaseName,                                                        
                           EventDescription,                                                 
                           EventDateTime)                                                        
              VALUES      (@ServerName,                                                        
                           @DatabaseName,                                         
                           @Action,                                                        
                           CURRENT_TIMESTAMP )                                                        
              SET @Action='Obtaining Definition for an object: '                                                        
             EXEC Connectiontest_readobjectdef                                                        
                @ServerName,                                                        
                @DatabaseName,                                                        
                @Result OUTPUT                                                        
              INSERT INTO @DatabaseProcessingLog                                                        
                          (SERVERNAME,                                                        
                           DatabaseName,                                                        
                           EventDescription,                                                        
                           EventDateTime)                           
              VALUES      (@ServerName,                
                           @DatabaseName,                                                        
                           @Action + @Result,                                                        
                           CURRENT_TIMESTAMP )                        
              SET @Action='Obtaining Definition for a Table: '                                                        
              EXEC Connectiontest_readtabledef                                                        
               @ServerName,                                                        
                @DatabaseName,                                                      
                @Result OUTPUT                                                        
              INSERT INTO @DatabaseProcessingLog                                              
                          (SERVERNAME,                                                        
                           DatabaseName,                                                        
                           EventDescription,                                                        
            EventDateTime)                                                        
              VALUES      (@ServerName,                                                        
                           @DatabaseName,                                                        
                           @Action + @Result,                                                
                           CURRENT_TIMESTAMP )                                                        
              SET @Action='Connectivity test successful.'                                                        
              INSERT INTO @DatabaseProcessingLog                                                        
                          (SERVERNAME,                                                        
                           DatabaseName,                                                        
                           EventDescription,                    
              EventDateTime)                                                        
              VALUES      (@ServerName,                                                        
                           @DatabaseName,                                                        
                           @Action,                     
                           CURRENT_TIMESTAMP )                                                        
              IF ( @ConnectionTestOnly <> 1 )                                               
                BEGIN                                                        
                    INSERT INTO dbo.ObjectCountReport                                                 
                                (AnalysisId,                                                        
                                 SERVERNAME,                                                        
                                 DatabaseName,                                                        
                                 ObjectType,                                                  
                                 ObjCount)                                                        
                    EXEC Getobjectscount                                                        
                      @AnalysisID,                                                        
                      @ServerName,                                                        
                      @DatabaseName                                   
                    EXEC [Usp_populatedbobjects]                                                        
                      @AnalysisID,                                                        
                      @ServerName,                                                        
                      @DatabaseName                                                        
                END                                       
              UPDATE ProgressReportAH                                                        
              SET    CompleteDateTime = CURRENT_TIMESTAMP                                                        
              WHERE  AnalysisId = @AnalysisID                                                        
                     AND SERVERNAME = Replace(@ServerName, @LinkedServerPrefix, '')                                                        
          AND DatabaseName = @DatabaseName                                                        
          END TRY                                                        
          BEGIN CATCH                                                        
              SET @Action='ERROR:'                                                        
                          + Isnull(CONVERT(NVARCHAR(11), Error_number()), '')                                                        
                          + ' - ' + Error_message()                                              
              SET @ErrorCount=@ErrorCount + 1                                                        
    IF ( Error_number() = 18452 )                                                        
                SET @isError=1                                                        
              INSERT INTO @DatabaseProcessingLog                                                        
                          (SERVERNAME,                                                        
                           DatabaseName,                                   
                           EventDescription,                                                        
                           EventDateTime)                                                        
              VALUES      (@ServerName,                                                        
                           @DatabaseName,                                                        
  @Action + 'Processing aborted.',                                                        
                           CURRENT_TIMESTAMP)                                                        
              INSERT INTO @errorLog                                                        
                          (ErrorDescription)                                                        
              VALUES      (Replace(@ServerName, @LinkedServerPrefix, '')                                                        
                           + N': ' + Error_message())                                                        
          END CATCH                                                        
          SET @Action='Processing Completed for ' + @DatabaseName                                                        
          INSERT INTO @DatabaseProcessingLog                                                        
                      (SERVERNAME,                                                        
                       DatabaseName,                                                        
                       EventDescription,                                                        
                       EventDateTime)                         
          VALUES      (@ServerName,                                                        
                       @DatabaseName,                                                        
                       @Action,                                                        
                       CURRENT_TIMESTAMP )                                                        
          IF ( @isError = 0 )                                                        
   BEGIN                                                        
                SELECT @NextDb = Min(RowId)                                                        
                FROM   @DatabaseList                                         
                WHERE  RowId > @iCurrentRowId                                                        
            END                                                        
          ELSE                                         
            BEGIN                                                        
              SELECT @NextDb = Min(RowId)                                                        
                FROM   @DatabaseList                                                        
                WHERE  RowId > @iCurrentRowId                                                        
                       AND SERVERNAME <> Replace(@ServerName, @LinkedServerPrefix, '')                                                        
            END                                                        
          IF Isnull(@NextDb, 0) = 0 -- End of processing - nothing else to analyze                                                                                    
           BEGIN                                                        
                SET @Action='Dropping Linked Server '                                                        
                EXEC @ExecResult=Drop_createlinkedserver                                                        
                  @ServerName,                                                        
                  0                                                        
      INSERT INTO @DatabaseProcessingLog                                                        
                            (SERVERNAME,                                                        
                             DatabaseName,                                                        
                             EventDescription,                                                        
                             EventDateTime)                                                        
                VALUES      (@ServerName,                                                        
                             @DatabaseName,                                           
                             @Action + 'for ' + @ServerName,                                                        
                             CURRENT_TIMESTAMP )                                                        
                BREAK                                                        
            END                                                        
          SET @PreviousServerName=@ServerName                                                        
          SELECT @iCurrentRowId = RowId,                                                       
                 @DatabaseName = DatabaseName,                                                        
               @ServerName = @LinkedServerPrefix + SERVERNAME                                                        
          FROM   @DatabaseList                                                        
          WHERE  RowId = @NextDb                                                        
          IF ( @PreviousServerName <> @ServerName )                                                        
            BEGIN                                                        
                SET @Action='Dropping Linked Server '                                                        
                SET @isError=0                                                        
                EXEC @ExecResult=Drop_createlinkedserver                                                       
                  @PreviousServerName,                                                        
                  0                                                        
                INSERT INTO @DatabaseProcessingLog                                                        
                            (SERVERNAME,                                                        
                             DatabaseName,                                                  
                             EventDescription,                                                        
                             EventDateTime)                                    
                VALUES      (@PreviousServerName,                         
                             '',                                                        
                             @Action + 'for ' + @PreviousServerName,                                                        
                             CURRENT_TIMESTAMP )                                                        
            END                                                        
      END                                                        
    IF ( @ErrorCount > 0 )                         
      BEGIN                                                        
          SELECT 'Errors occured. Error count:'                                                        
                 + CONVERT(VARCHAR(20), @ErrorCount)                                                        
   SELECT *                                                        
      FROM   @errorLog                                                        
      END                                                        
    SELECT id,                                                    
           SERVERNAME,                                                        
           DatabaseName,                                               
           EventDescription,                                                        
           EventDateTime                                                        
    FROM   @DatabaseProcessingLog       
      
       
    PRINT CONVERT(VARCHAR(20), @DBCount)                                                        
          + ' databases were processed.'                                                
    --SELECT SERVERNAME, DatabaseName, ObjectType, ObjCount, ObjCountActual FROM @ObjectCount                                                                                    
    UPDATE dbo.Analysis                                              
    SET    EndTime = CURRENT_TIMESTAMP                                                        
    WHERE  Id = @AnalysisID                                                        
    SELECT *                                                        
    FROM   ProgressReportAH             
    WHERE  AnalysisId = @AnalysisID                                                        
    RETURN
GO
/****** Object:  StoredProcedure [dbo].[LoopThroughDatabases]    Script Date: 06/02/2016 18:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LoopThroughDatabases] @ConnectionTestOnly BIT =1,      
                                             @EnvironmentId      INT=1      
AS      
    SET NOCOUNT ON      
    DECLARE @NextDb             INT,      
            @iCurrentRowId      INT,      
            @DatabaseName       NVARCHAR(128),      
            @ServerName         NVARCHAR(128),      
            @ParamDef           NVARCHAR(100),      
            @Result             VARCHAR(500),      
            @ExecResult         INT,      
            @Action             VARCHAR(2048),      
            @ErrorCount         INT,      
            @PreviousServerName NVARCHAR(128),      
            @DBCount            INT,      
            @LinkedServerPrefix NCHAR(3),      
            @isError            BIT      
    DECLARE @DatabaseList TABLE      
      (      
         RowId        INT,      
         SERVERNAME   NVARCHAR(128),      
         DatabaseName NVARCHAR(128)      
      );      
    DECLARE @DatabaseProcessingLog TABLE      
      (      
         id               INT IDENTITY(1, 1),      
         SERVERNAME       NVARCHAR(128),      
         DatabaseName     NVARCHAR(128),      
         EventDescription VARCHAR(2048),      
         EventDateTime    DATETIME      
      );      
    DECLARE @errorLog TABLE      
      (      
         id               INT IDENTITY(1, 1),      
         ErrorDescription VARCHAR(2048)      
      )      
    DECLARE @AnalysisID INT      
    INSERT INTO dbo.Analysis      
                (EnvironmentId)      
    VALUES      (@EnvironmentId)      
    SET @AnalysisID= Scope_identity()      
    INSERT INTO @DatabaseList      
    SELECT Rank()      
             OVER (      
               ORDER BY SERVERNAME, DatabaseName) AS RowId,      
           SERVERNAME,      
           DatabaseName      
    FROM   [dbo].[ServerDatabases] sd      
           INNER JOIN dbo.DBServers ds      
                   ON sd.serverid = ds.Serverid      
    WHERE  environmentid = 2      
           -- SERVERNAME LIKE '%A2A%'      
           AND DatabaseName NOT IN (SELECT Name      
                                    FROM   ExcludedDatabase)      
    --AND DatabaseName IN ('FinTranA144')            
    ORDER  BY SERVERNAME,      
              DatabaseName      
    INSERT INTO ProgressReport      
                (AnalysisId,      
                 SERVERNAME,      
                 DatabaseName)      
    SELECT @AnalysisID,      
           SERVERNAME,      
           DatabaseName      
    FROM   @DatabaseList      
    ORDER  BY SERVERNAME,      
              DatabaseName      
    SELECT @ErrorCount = 0,      
           @PreviousServerName = '',      
           @DBCount = 0,      
           @ParamDef = N'@ResultOut varchar(500) OUTPUT',      
           @LinkedServerPrefix = N'VDT',      
           @isError = 0;      
    SELECT @NextDb = Min(RowId)      
    FROM   @DatabaseList      
    IF Isnull(@NextDb, 0) = 0      
      BEGIN      
          SELECT 'NO DATA IS FOUND IN TABLE!'      
          RETURN      
      END      
    SELECT @iCurrentRowId = RowId,      
           @DatabaseName = DatabaseName,      
           @ServerName = @LinkedServerPrefix + SERVERNAME      
    FROM   @DatabaseList      
    WHERE  RowId = @NextDb      
    WHILE 1 = 1      
      BEGIN      
          BEGIN TRY      
              SET @DBCount=@DBCount + 1      
              IF ( @PreviousServerName <> @ServerName )      
                BEGIN      
                    EXEC @ExecResult=Drop_createlinkedserver      
                      @ServerName,      
                      1;      
                    SET @Action='Creating Linked Server ' + @ServerName;      
                    INSERT INTO @DatabaseProcessingLog      
                                (SERVERNAME,      
                              DatabaseName,      
                                 EventDescription,      
                                 EventDateTime)      
                    VALUES      (@ServerName,      
                 @DatabaseName,      
                                 @Action + ' for '      
                                 + Replace(@ServerName, @LinkedServerPrefix, ''),      
                                 CURRENT_TIMESTAMP );      
                END;      
              UPDATE ProgressReport      
              SET    StartDateTime = CURRENT_TIMESTAMP      
              WHERE  AnalysisId = @AnalysisID      
                     AND SERVERNAME = Replace(@ServerName, @LinkedServerPrefix, '')      
                     AND DatabaseName = @DatabaseName      
              SET @Action='Processing Started for ' + @DatabaseName      
              INSERT INTO @DatabaseProcessingLog      
                          (SERVERNAME,      
                           DatabaseName,      
                           EventDescription,      
                           EventDateTime)      
              VALUES      (@ServerName,      
                           @DatabaseName,      
                           @Action,      
                           CURRENT_TIMESTAMP )      
              SET @Action='Obtaining Definition for an object: '      
              EXEC Connectiontest_readobjectdef      
                @ServerName,      
                @DatabaseName,      
                @Result OUTPUT      
              INSERT INTO @DatabaseProcessingLog      
                          (SERVERNAME,      
                           DatabaseName,      
                           EventDescription,      
                           EventDateTime)      
              VALUES      (@ServerName,      
                           @DatabaseName,      
                           @Action + @Result,      
                           CURRENT_TIMESTAMP )      
              SET @Action='Obtaining Definition for a Table: '      
              EXEC Connectiontest_readtabledef      
                @ServerName,      
                @DatabaseName,      
                @Result OUTPUT      
              INSERT INTO @DatabaseProcessingLog      
                          (SERVERNAME,      
                           DatabaseName,      
                           EventDescription,      
                           EventDateTime)      
              VALUES      (@ServerName,      
                           @DatabaseName,      
                           @Action + @Result,      
                           CURRENT_TIMESTAMP )      
              SET @Action='Connectivity test successful.'      
              INSERT INTO @DatabaseProcessingLog      
                          (SERVERNAME,      
                           DatabaseName,      
                           EventDescription,      
                           EventDateTime)      
              VALUES      (@ServerName,      
                           @DatabaseName,      
                           @Action,      
                           CURRENT_TIMESTAMP )      
              IF ( @ConnectionTestOnly <> 1 )      
                BEGIN      
                    INSERT INTO dbo.ObjectCountReport      
                                (AnalysisId,      
                                 SERVERNAME,      
                                 DatabaseName,      
                                 ObjectType,      
                                 ObjCount)      
                    EXEC Getobjectscount      
                      @AnalysisID,      
                      @ServerName,      
                      @DatabaseName      
                    EXEC [Usp_populatedbobjects]      
                      @AnalysisID,      
                      @ServerName,      
                      @DatabaseName      
                END      
              UPDATE ProgressReport      
              SET    CompleteDateTime = CURRENT_TIMESTAMP      
              WHERE  AnalysisId = @AnalysisID      
                     AND SERVERNAME = Replace(@ServerName, @LinkedServerPrefix, '')      
                     AND DatabaseName = @DatabaseName      
    END TRY      
          BEGIN CATCH      
              SET @Action='ERROR:'      
                          + Isnull(CONVERT(NVARCHAR(11), Error_number()), '')      
                          + ' - ' + Error_message()      
              SET @ErrorCount=@ErrorCount + 1      
              IF ( Error_number() = 18452 )      
                SET @isError=1      
              INSERT INTO @DatabaseProcessingLog      
                          (SERVERNAME,      
                           DatabaseName,      
                           EventDescription,      
                           EventDateTime)      
              VALUES      (@ServerName,      
                           @DatabaseName,      
                  @Action + 'Processing aborted.',      
                           CURRENT_TIMESTAMP)      
              INSERT INTO @errorLog      
                          (ErrorDescription)      
              VALUES      (Replace(@ServerName, @LinkedServerPrefix, '')      
                           + N': ' + Error_message())      
          END CATCH      
          SET @Action='Processing Completed for ' + @DatabaseName      
          INSERT INTO @DatabaseProcessingLog      
                      (SERVERNAME,      
                       DatabaseName,      
                       EventDescription,      
                       EventDateTime)      
          VALUES      (@ServerName,      
                       @DatabaseName,      
                       @Action,      
                       CURRENT_TIMESTAMP )      
          IF ( @isError = 0 )      
            BEGIN      
                SELECT @NextDb = Min(RowId)      
                FROM   @DatabaseList      
                WHERE  RowId > @iCurrentRowId      
            END      
          ELSE      
            BEGIN      
                SELECT @NextDb = Min(RowId)      
                FROM   @DatabaseList      
                WHERE  RowId > @iCurrentRowId      
                       AND SERVERNAME <> Replace(@ServerName, @LinkedServerPrefix, '')      
            END      
          IF Isnull(@NextDb, 0) = 0 -- End of processing - nothing else to analyze              
            BEGIN      
                SET @Action='Dropping Linked Server '      
                EXEC @ExecResult=Drop_createlinkedserver      
                  @ServerName,      
                  0      
                INSERT INTO @DatabaseProcessingLog      
                            (SERVERNAME,      
                             DatabaseName,      
                             EventDescription,      
                             EventDateTime)      
                VALUES      (@ServerName,      
                             @DatabaseName,      
                             @Action + 'for ' + @ServerName,      
                             CURRENT_TIMESTAMP )      
                BREAK      
            END      
          SET @PreviousServerName=@ServerName      
          SELECT @iCurrentRowId = RowId,      
                 @DatabaseName = DatabaseName,      
                 @ServerName = @LinkedServerPrefix + SERVERNAME      
          FROM   @DatabaseList      
          WHERE  RowId = @NextDb      
          IF ( @PreviousServerName <> @ServerName )      
            BEGIN      
                SET @Action='Dropping Linked Server '      
                SET @isError=0      
                EXEC @ExecResult=Drop_createlinkedserver      
                  @PreviousServerName,      
                  0      
                INSERT INTO @DatabaseProcessingLog      
                            (SERVERNAME,      
                             DatabaseName,      
                             EventDescription,      
                             EventDateTime)      
                VALUES      (@PreviousServerName,      
                             '',      
                             @Action + 'for ' + @PreviousServerName,      
                             CURRENT_TIMESTAMP )      
            END      
      END      
    IF ( @ErrorCount > 0 )      
      BEGIN      
          SELECT 'Errors occured. Error count:'      
           + CONVERT(VARCHAR(20), @ErrorCount)      
          SELECT *      
          FROM   @errorLog      
      END      
    SELECT id,      
           SERVERNAME,      
           DatabaseName,      
           EventDescription,      
           EventDateTime      
    FROM   @DatabaseProcessingLog      
    PRINT CONVERT(VARCHAR(20), @DBCount)      
          + ' databases were processed.'      
    --SELECT SERVERNAME, DatabaseName, ObjectType, ObjCount, ObjCountActual FROM @ObjectCount              
    UPDATE dbo.Analysis      
    SET    EndTime = CURRENT_TIMESTAMP      
    WHERE  Id = @AnalysisID      
    SELECT *      
    FROM   ProgressReport      
    WHERE  AnalysisId = @AnalysisID      
    RETURN
GO
/****** Object:  Default [DF_Analysis_StartTime]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [Analysis].[Analysis] ADD  CONSTRAINT [DF_Analysis_StartTime]  DEFAULT (getdate()) FOR [StartTime]
GO
/****** Object:  Default [DF_Analysis_Status]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [Analysis].[Analysis] ADD  CONSTRAINT [DF_Analysis_Status]  DEFAULT ((1)) FOR [Status]
GO
/****** Object:  Default [DF_Analysis_CreatedBy]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [Analysis].[Analysis] ADD  CONSTRAINT [DF_Analysis_CreatedBy]  DEFAULT (suser_sname()) FOR [CreatedBy]
GO
/****** Object:  Default [DF_AnalysisLog_LogDateTime]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [Analysis].[AnalysisLog] ADD  CONSTRAINT [DF_AnalysisLog_LogDateTime]  DEFAULT (getdate()) FOR [LogDateTime]
GO
/****** Object:  Default [DF_ActiveFacilities_Active]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [dbo].[ActiveFacilities] ADD  CONSTRAINT [DF_ActiveFacilities_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [DF_Analysis_StartTime]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [dbo].[Analysis] ADD  CONSTRAINT [DF_Analysis_StartTime]  DEFAULT (getdate()) FOR [StartTime]
GO
/****** Object:  Default [DF_Analysis_CreatedBy]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [dbo].[Analysis] ADD  CONSTRAINT [DF_Analysis_CreatedBy]  DEFAULT (suser_sname()) FOR [CreatedBy]
GO
/****** Object:  Default [DF__Evnironme__Inser__662B2B3B]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [dbo].[EvnironmentConfig] ADD  DEFAULT (getdate()) FOR [InsertedDate]
GO
/****** Object:  Default [DF_GOLDDbObjectsList_BaseObject]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [dbo].[GOLDDbObjectsList] ADD  CONSTRAINT [DF_GOLDDbObjectsList_BaseObject]  DEFAULT ('N') FOR [BaseObject]
GO
/****** Object:  Default [DF__HL7_Error__LoadS__681373AD]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [dbo].[HL7_Errors] ADD  DEFAULT ((0)) FOR [LoadStatus]
GO
/****** Object:  Default [DF__HL7_Error__Creat__690797E6]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [dbo].[HL7_Errors] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
/****** Object:  Default [DF_ObjectsListForDbSourceLite_BaseObject]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [dbo].[ObjectsListForDbSourceLite] ADD  CONSTRAINT [DF_ObjectsListForDbSourceLite_BaseObject]  DEFAULT ('N') FOR [BaseObject]
GO
/****** Object:  Default [DF_ServerDatabases_IsGold]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [dbo].[ServerDatabases] ADD  CONSTRAINT [DF_ServerDatabases_IsGold]  DEFAULT ((0)) FOR [IsGold]
GO
/****** Object:  Default [DF_TranObjectsCountOctober_Active]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [dbo].[TranObjectsCountOctober] ADD  CONSTRAINT [DF_TranObjectsCountOctober_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  ForeignKey [FK_Analysis_Environments]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [dbo].[Analysis]  WITH CHECK ADD  CONSTRAINT [FK_Analysis_Environments] FOREIGN KEY([EnvironmentId])
REFERENCES [dbo].[Environments] ([EnvironmentId])
GO
ALTER TABLE [dbo].[Analysis] CHECK CONSTRAINT [FK_Analysis_Environments]
GO
/****** Object:  ForeignKey [FK_BuildExeRunlog_BuildExeRun1]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [dbo].[BuildExeRunlog]  WITH CHECK ADD  CONSTRAINT [FK_BuildExeRunlog_BuildExeRun1] FOREIGN KEY([BuildExeRunID])
REFERENCES [dbo].[BuildExeRun] ([BuildExeRunID])
GO
ALTER TABLE [dbo].[BuildExeRunlog] CHECK CONSTRAINT [FK_BuildExeRunlog_BuildExeRun1]
GO
/****** Object:  ForeignKey [FK_DBServers_Environments]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [dbo].[DBServersCare05]  WITH CHECK ADD  CONSTRAINT [FK_DBServers_Environments] FOREIGN KEY([EnvironmentId])
REFERENCES [dbo].[Environments] ([EnvironmentId])
GO
ALTER TABLE [dbo].[DBServersCare05] CHECK CONSTRAINT [FK_DBServers_Environments]
GO
/****** Object:  ForeignKey [FK_MasterObjectList_Run]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [dbo].[MasterObjectList]  WITH CHECK ADD  CONSTRAINT [FK_MasterObjectList_Run] FOREIGN KEY([FromRunId])
REFERENCES [dbo].[Run] ([Id])
GO
ALTER TABLE [dbo].[MasterObjectList] CHECK CONSTRAINT [FK_MasterObjectList_Run]
GO
/****** Object:  ForeignKey [FK_ObjectCategory_Category]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [dbo].[ObjectCategory]  WITH CHECK ADD  CONSTRAINT [FK_ObjectCategory_Category] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Category] ([Id])
GO
ALTER TABLE [dbo].[ObjectCategory] CHECK CONSTRAINT [FK_ObjectCategory_Category]
GO
/****** Object:  ForeignKey [FK_ObjectCategory_MasterObjectList]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [dbo].[ObjectCategory]  WITH CHECK ADD  CONSTRAINT [FK_ObjectCategory_MasterObjectList] FOREIGN KEY([Id])
REFERENCES [dbo].[MasterObjectList] ([ObjectId])
GO
ALTER TABLE [dbo].[ObjectCategory] CHECK CONSTRAINT [FK_ObjectCategory_MasterObjectList]
GO
/****** Object:  ForeignKey [FK_ServerDatabases_DatabaseClass]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [dbo].[ServerDatabasesCare05]  WITH CHECK ADD  CONSTRAINT [FK_ServerDatabases_DatabaseClass] FOREIGN KEY([DatabaseClass])
REFERENCES [dbo].[DatabaseClass] ([ClassId])
GO
ALTER TABLE [dbo].[ServerDatabasesCare05] CHECK CONSTRAINT [FK_ServerDatabases_DatabaseClass]
GO
/****** Object:  ForeignKey [FK_ServerDatabases_DBServers]    Script Date: 06/02/2016 18:50:42 ******/
ALTER TABLE [dbo].[ServerDatabasesCare05]  WITH CHECK ADD  CONSTRAINT [FK_ServerDatabases_DBServers] FOREIGN KEY([ServerId])
REFERENCES [dbo].[DBServersCare05] ([ServerId])
GO
ALTER TABLE [dbo].[ServerDatabasesCare05] CHECK CONSTRAINT [FK_ServerDatabases_DBServers]
GO
