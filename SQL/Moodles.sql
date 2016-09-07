SELECT *  FROM Consolidated 
SELECT *  FROM mdl_user where email not in (select [E-Mail ID]  from Consolidated )
order by username



SELECT     Consolidated.[Emp ID], Consolidated.Name, Consolidated.Location, Consolidated.Process, Consolidated.Designation, Consolidated.Manager, 
                      Consolidated.[COE Leader], Consolidated.[E-Mail ID], mdl_user.grade, mdl_user.[Completed date]
FROM         Consolidated RIGHT OUTER JOIN
                      mdl_user ON Consolidated.[E-Mail ID] = mdl_user.email
ORDER BY Consolidated.[Emp ID]


--delete from mdl_user

GO


