SELECT    DNN_ONYAK_SIGMAPRO_Issues.issueID, DNN_Users.FirstName, DNN_Users.LastName, 
						DNN_ONYAK_SIGMAPRO_IssueComments.comment,
                      DNN_ONYAK_SIGMAPRO_IssueComments.Hours,
					 convert(varchar,DNN_ONYAK_SIGMAPRO_IssueComments.CommentDate,101) 'Comment Date', 
                      DNN_ONYAK_SIGMAPRO_Projects.ProjectName,
					 DNN_ONYAK_SIGMAPRO_Issues.issueTitle
FROM         DNN_ONYAK_SIGMAPRO_Projects INNER JOIN
                      DNN_ONYAK_SIGMAPRO_Issues ON DNN_ONYAK_SIGMAPRO_Projects.ProjectId = DNN_ONYAK_SIGMAPRO_Issues.ProjectId INNER JOIN
                      DNN_ONYAK_SIGMAPRO_IssueComments INNER JOIN
                      DNN_Users ON DNN_ONYAK_SIGMAPRO_IssueComments.UserId = DNN_Users.UserID ON 
                      DNN_ONYAK_SIGMAPRO_Issues.IssueId = DNN_ONYAK_SIGMAPRO_IssueComments.IssueId
WHERE DNN_Users.FirstName like '%nasim%' 
			and DNN_ONYAK_SIGMAPRO_IssueComments.CommentDate >=cast('9/12/2012' as datetime)
			and DNN_ONYAK_SIGMAPRO_IssueComments.Hours<>0
ORDER BY DNN_ONYAK_SIGMAPRO_IssueComments.CommentDate






--
--SELECT     DNN_ONYAK_SIGMAPRO_Issues.IssueTitle, DNN_ONYAK_SIGMAPRO_ProjectStatus.StatusName, DNN_ONYAK_SIGMAPRO_Projects.ProjectName, 
--                      SUM(DNN_ONYAK_SIGMAPRO_IssueComments.Hours) AS Hours
--FROM         DNN_ONYAK_SIGMAPRO_Projects INNER JOIN
--                      DNN_ONYAK_SIGMAPRO_Issues ON DNN_ONYAK_SIGMAPRO_Projects.ProjectId = DNN_ONYAK_SIGMAPRO_Issues.ProjectId INNER JOIN
--                      DNN_ONYAK_SIGMAPRO_ProjectStatus ON 
--                      DNN_ONYAK_SIGMAPRO_Issues.IssueStatusId = DNN_ONYAK_SIGMAPRO_ProjectStatus.StatusId INNER JOIN
--                      DNN_ONYAK_SIGMAPRO_IssueComments ON DNN_ONYAK_SIGMAPRO_Issues.IssueId = DNN_ONYAK_SIGMAPRO_IssueComments.IssueId
--where DNN_ONYAK_SIGMAPRO_IssueComments.CommentDate >=cast('07/01/2011' as datetime)
--GROUP BY DNN_ONYAK_SIGMAPRO_Issues.IssueTitle, DNN_ONYAK_SIGMAPRO_ProjectStatus.StatusName, DNN_ONYAK_SIGMAPRO_Projects.ProjectName



--SELECT     DNN_ONYAK_SIGMAPRO_Issues.IssueId, DNN_ONYAK_SIGMAPRO_Projects.ProjectName, DNN_ONYAK_SIGMAPRO_Issues.IssueTitle, 
--                      DNN_ONYAK_SIGMAPRO_ProjectStatus.StatusName
--FROM         DNN_ONYAK_SIGMAPRO_Projects INNER JOIN
--                      DNN_ONYAK_SIGMAPRO_Issues ON DNN_ONYAK_SIGMAPRO_Projects.ProjectId = DNN_ONYAK_SIGMAPRO_Issues.ProjectId INNER JOIN
--                      DNN_ONYAK_SIGMAPRO_ProjectStatus ON DNN_ONYAK_SIGMAPRO_Issues.IssueStatusId = DNN_ONYAK_SIGMAPRO_ProjectStatus.StatusId
--WHERE     (DNN_ONYAK_SIGMAPRO_ProjectStatus.StatusName NOT IN ('Closed','Completed'))






