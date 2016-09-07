sp_helptext USP_EmployeeWeekOffReport
sp_helptext USP_EDB_UpdateAutomaticWeekOff
sp_helptext USP_EDB_InsertWeekoff


select * from LeaveDetails where EmployeeID=101209 and DateApplied='12/9/2012'
select * from LeaveSummary where LeaveSummaryID in(218938)
select * from LeaveSummary 
where  AppliedBy in(101122123,101122124,101122125) and LeaveTypeID=22 and Status=1


SELECT AppliedFor,StartDate,COUNT(LeaveID)
FROM dbo.LeaveDetails inner join dbo.LeaveSummary                                                                            
     ON dbo.LeaveDetails.LeaveSummaryID=dbo.LeaveSummary.LeaveSummaryID                                                                                WHERE dbo.LeaveDetails.LeaveStatusID in (1,12,16) AND LeaveTypeID=22 AND Status=1  
group by AppliedFor,StartDate
having COUNT(LeaveID) >1


--update LeaveSummary set Status=0,UpdatedBy=1011660 where AppliedFor='' and StartDate='' and AppliedBy in(101122123,101122124,101122125) and LeaveTypeID=22 and Status=1


     