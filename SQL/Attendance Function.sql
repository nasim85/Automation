USE [ARMS]
GO
/****** Object:  UserDefinedFunction [dbo].[USP_EDB_GetDatesForAttendnace]    Script Date: 10/05/2012 15:41:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--ALTER FUNCTION [dbo].[USP_EDB_GetDatesForAttendnace] --'10/01/2011'  
--(
--@DATEFROM DATETIME,
--@DATETO DATETIME ,
--@EmpID varchar(50) 
--)  
--    RETURNS  @HOLDER_DATE table(DATE DATETIME,InDateTime datetime,OutDatetime datetime)  

--AS  
BEGIN  


Declare
@DATEFROM DATETIME,
@DATETO DATETIME ,
@EmpID varchar(50) 

    DECLARE @HOLDER_DATE table(DATE DATETIME,InDateTime datetime,OutDatetime datetime)  	
	
	set @DATEFROM='9/28/2012'--'9/27/2012'
	set @DATETO	='10/6/2012'--'10/3/2012'
	set @EmpID='300762'--'201905'
	
	
	Declare 
	@ShiftStartTime varchar(50),
	 @PunchStart datetime,
	 @PunchEnd datetime,
	 @DATE datetime,
	 @TimeInMinute int
	 
	 set @DATE=@DATEFROM
	
	
--Getting shift start time-----------
			SELECT  @ShiftStartTime= isnull(SMC.StartTime,SH.StartTime)
		
				 FROM 
				 EmployeeMaster EM Inner join
				  ShiftMaster SH on (EM.shiftID=SH.shiftID) 
				   LEFT OUTER JOIN ShiftChangeRequest SCH  ON SCH.EmployeeID=@EmpID AND SCH.active=1 
									AND SCH.AdminStatus=1 
									--AND (SCH.FromDate between @DATEFROM and @DATETO or SCH.TillDate between @DATEFROM and @DATETO)
									AND @DATE BETWEEN SCH.FromDate AND SCH.TillDate  and SCH.ChangeType='T' 
				LEFT OUTER JOIN ShiftMaster SMC on (SCH.shiftID=SMC.shiftID)
				LEFT OUTER JOIN ShiftMaster SMCO on (SCH.OldShiftID=SMCO.shiftID)
				 WHERE EM.employeeID=@EmpID
				order by SCH.EntryDate 
				
				if not exists(select shiftID from ShiftChangeRequest where EmployeeID=@EmpID AND active=1 AND AdminStatus=1 
									AND  @DATE BETWEEN FromDate AND TillDate and ChangeType='T' )
				 Begin
				SELECT top 1 @ShiftStartTime=isnull(SMCO.StartTime,@ShiftStartTime)
				 FROM 
				   ShiftChangeRequest SCH  
					LEFT OUTER JOIN ShiftMaster SMC on (SCH.shiftID=SMC.shiftID)
					LEFT OUTER JOIN ShiftMaster SMCO on (SCH.OldShiftID=SMCO.shiftID)   
				   Where SCH.EmployeeID=@EmpID AND SCH.active=1 AND SCH.AdminStatus=1 
										AND SCH.FromDate> @DATE and SCH.ChangeType='P' 
					 order by SCH.EntryDate 
					 
				 SELECT top 1 @ShiftStartTime=isnull(SMC.StartTime,@ShiftStartTime)
				 FROM 
				   ShiftChangeRequest SCH  
					LEFT OUTER JOIN ShiftMaster SMC on (SCH.shiftID=SMC.shiftID)
					LEFT OUTER JOIN ShiftMaster SMCO on (SCH.OldShiftID=SMCO.shiftID)   
				   Where SCH.EmployeeID=@EmpID AND SCH.active=1 AND SCH.AdminStatus=1 
										AND SCH.FromDate <= @DATE and SCH.ChangeType='P' 
					 order by SCH.EntryDate desc
					 
					 
				End	 
				 
					 
					 

 ----IN punch Start date time----------------
--     SELECT @PunchStart=Cast(@Date+ DATEADD(HH,-1,CAST(@ShiftStartTime AS TIME))AS DATETIME)  
     SELECT @PunchStart=DATEADD(HH,-1,Cast(@Date+ CAST(@ShiftStartTime AS TIME)AS DATETIME))
     
         SELECT @TimeInMinute=TimeInMinute     
         FROM EmployeeAttendanceTime     
         WHERE EmployeeID=@EmpId AND [Date]=@Date AND [Type]=3 AND ACTIVE=1  
          
         IF(@TimeInMinute IS NOT NULL OR @TimeInMinute>0) 
         BEGIN
           SELECT @PunchStart=DATEADD(MINUTE,-@TimeInMinute, @PunchStart)
         END  
         
  ----Out punch end date time---------------------      
        SELECT @PunchEnd=DATEADD(HH,12,Cast(@Date+ CAST(@ShiftStartTime AS TIME)AS DATETIME))
		set @TimeInMinute=null    
         SELECT @TimeInMinute=TimeInMinute     
         FROM EmployeeAttendanceTime     
         WHERE EmployeeID=@EmpId AND [Date]=@Date AND [Type]=2 AND ACTIVE=1  
          
         IF(@TimeInMinute IS NOT NULL OR @TimeInMinute>0) 
         BEGIN
           SELECT @PunchEnd=DATEADD(MINUTE,@TimeInMinute, @PunchEnd)
         END  
         
         
         INSERT INTO  
		@HOLDER_DATE(DATE,InDateTime,OutDatetime)  
		VALUES(@DATEFROM,@PunchStart,@PunchEnd)
		
	--select @DATEFROM,@PunchStart,@PunchEnd	
	
	
  
WHILE @DATEFROM < @DATETO  
BEGIN  
    SELECT @DATEFROM = DATEADD(D, 1, @DATEFROM)  
    	 set @DATE=@DATEFROM
    
    
    --Getting shift start time-----------
	
				 
	 		--SELECT SMC.StartTime,SH.StartTime
				-- FROM 
				-- EmployeeMaster EM Inner join
				--  ShiftMaster SH on (EM.shiftID=SH.shiftID) 
				--   LEFT OUTER JOIN ShiftChangeRequest SCH  ON SCH.EmployeeID=@EmpID AND SCH.active=1 
				--					AND SCH.AdminStatus=1 
				--					--AND (SCH.FromDate between @DATEFROM and @DATETO or SCH.TillDate between @DATEFROM and @DATETO)
				--					AND @DATE BETWEEN SCH.FromDate AND SCH.TillDate
				--LEFT OUTER JOIN ShiftMaster SMC on (SCH.shiftID=SMC.shiftID)
				--LEFT OUTER JOIN ShiftMaster SMCO on (SCH.OldShiftID=SMCO.shiftID)
				-- WHERE EM.employeeID=@EmpID
				
			SELECT @ShiftStartTime= isnull(SMC.StartTime,SH.StartTime)
				 FROM 
				 EmployeeMaster EM Inner join
				  ShiftMaster SH on (EM.shiftID=SH.shiftID) 
				   LEFT OUTER JOIN ShiftChangeRequest SCH  ON SCH.EmployeeID=@EmpID AND SCH.active=1 
									AND SCH.AdminStatus=1 
									--AND (SCH.FromDate between @DATEFROM and @DATETO or SCH.TillDate between @DATEFROM and @DATETO)
									AND @DATE BETWEEN SCH.FromDate AND SCH.TillDate and SCH.ChangeType='T' 
				LEFT OUTER JOIN ShiftMaster SMC on (SCH.shiftID=SMC.shiftID)
				LEFT OUTER JOIN ShiftMaster SMCO on (SCH.OldShiftID=SMCO.shiftID)
				 WHERE EM.employeeID=@EmpID
				
				 if not exists(select shiftID from ShiftChangeRequest where EmployeeID=@EmpID AND active=1 AND AdminStatus=1 
									AND  @DATE BETWEEN FromDate AND TillDate and ChangeType='T' )
				 Begin
				SELECT top 1 @ShiftStartTime=isnull(SMCO.StartTime,@ShiftStartTime)
				 FROM 
				   ShiftChangeRequest SCH  
					LEFT OUTER JOIN ShiftMaster SMC on (SCH.shiftID=SMC.shiftID)
					LEFT OUTER JOIN ShiftMaster SMCO on (SCH.OldShiftID=SMCO.shiftID)   
				   Where SCH.EmployeeID=@EmpID AND SCH.active=1 AND SCH.AdminStatus=1 
									AND SCH.FromDate>@DATE and SCH.ChangeType='P'
					 order by SCH.EntryDate 
					 
 				 SELECT top 1 @ShiftStartTime=isnull(SMC.StartTime,@ShiftStartTime)
				 FROM 
				   ShiftChangeRequest SCH  
					LEFT OUTER JOIN ShiftMaster SMC on (SCH.shiftID=SMC.shiftID)
					LEFT OUTER JOIN ShiftMaster SMCO on (SCH.OldShiftID=SMCO.shiftID)   
				   Where SCH.EmployeeID=@EmpID AND SCH.active=1 AND SCH.AdminStatus=1 
										AND SCH.FromDate <= @DATE and SCH.ChangeType='P' 
					 order by SCH.EntryDate desc

					 
				End					 


					 
					 
			
				 
 ----IN punch Start date time----------------
--     SELECT @PunchStart=Cast(@Date+ DATEADD(HH,-1,CAST(@ShiftStartTime AS TIME))AS DATETIME)  
     SELECT @PunchStart=DATEADD(HH,-1,Cast(@Date+ CAST(@ShiftStartTime AS TIME)AS DATETIME))
     
         SELECT @TimeInMinute=TimeInMinute     
         FROM EmployeeAttendanceTime     
         WHERE EmployeeID=@EmpId AND [Date]=@Date AND [Type]=3 AND ACTIVE=1  
          
         IF(@TimeInMinute IS NOT NULL OR @TimeInMinute>0) 
         BEGIN
           SELECT @PunchStart=DATEADD(MINUTE,-@TimeInMinute, @PunchStart)
         END  
         
  ----Out punch end date time---------------------      
        SELECT @PunchEnd=DATEADD(HH,12,Cast(@Date+ CAST(@ShiftStartTime AS TIME)AS DATETIME))
		set @TimeInMinute=null    
         SELECT @TimeInMinute=TimeInMinute     
         FROM EmployeeAttendanceTime     
         WHERE EmployeeID=@EmpId AND [Date]=@Date AND [Type]=2 AND ACTIVE=1  
          
         IF(@TimeInMinute IS NOT NULL OR @TimeInMinute>0) 
         BEGIN
           SELECT @PunchEnd=DATEADD(MINUTE,@TimeInMinute, @PunchEnd)
         END  
         
         
         INSERT INTO  @HOLDER_DATE(DATE,InDateTime,OutDatetime)  
					VALUES(@DATEFROM,@PunchStart,@PunchEnd)

	--	select @DATEFROM,@PunchStart,@PunchEnd					
 
END  
  
select * from  @HOLDER_DATE
return  
END  
