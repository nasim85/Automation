Select * from login where  roleID=2 and  employeeid in (300692,300692,300692,300692,300692,100774,300420,100774,300468,300692,300694,100224,300477,300477,300477,300477,300477,100224,100224,100952,100952,100952,100952,100952,100952,100952,100952,300468,100224,300913,300913,300694,300913,300694,300468,300913,300913,100952,300401,300468,100774,300834,100774,300468,300934,100774,100774,100774,300474,300474,100774,300401,100774,300401,300468,300468,300468,300468,300468,100774,300474,300001,300468,300535,300474,300535,300535,300535,300535,300535,300114,300535,300535,300114,300535)
--update login set roleID=3 where roleID=2 and  employeeid in (300692,300692,300692,300692,300692,100774,300420,100774,300468,300692,300694,100224,300477,300477,300477,300477,300477,100224,100224,100952,100952,100952,100952,100952,100952,100952,100952,300468,100224,300913,300913,300694,300913,300694,300468,300913,300913,100952,300401,300468,100774,300834,100774,300468,300934,100774,100774,100774,300474,300474,100774,300401,100774,300401,300468,300468,300468,300468,300468,100774,300474,300001,300468,300535,300474,300535,300535,300535,300535,300535,300114,300535,300535,300114,300535)

select * from RoleMaster
select * from ModuleMatrix where Active=1 and ParentNode=122
update ModuleMatrix set Active=0 where PageID  in (111,113,129,171,178)
select * from roleMatrix where PageID in (select PageID from ModuleMatrix where Active=1 and ParentNode=92)

update RoleMatrix set Active=0 where  PageID in (select PageID from ModuleMatrix where Active=1 and ParentNode=92) and Active=0

select * from ProductMaster
--update ProductMaster set Active=0 where ProductID <>1

select * from ProductUserMatrix
--Update ProductUserMatrix set Active=0,UpdatedOn=getdate() where Active=1

SELECT     RoleMatrix.ID, RoleMatrix.RoleID, RoleMatrix.PageID, RoleMatrix.ReadOnly, ModuleMatrix.PageID AS Expr1, ModuleMatrix.PageName, 
                      ModuleMatrix.ParentNode, ModuleMatrix.ControlKey
FROM         RoleMatrix INNER JOIN
                      ModuleMatrix ON RoleMatrix.PageID = ModuleMatrix.PageID
WHERE     (RoleMatrix.RoleID = 4) AND (RoleMatrix.Active = 1) AND (RoleMatrix.PageID NOT IN
                          (SELECT     PageID
                            FROM          RoleMatrix AS RoleMatrix_1
                            WHERE      (RoleID = 10) AND (Active = 1)))
                            order by ModuleMatrix.ParentNode

select * from SpecialRights  where EmployeeID=100014 and PageID in(145,120,109,107,102,93,73,72,63,57,56,55,28)

--INSERT INTO SpecialRights
--                      (EmployeeID, PageID, ReadOnly, Active, CreatedDate, CreatedBy)
--VALUES 

--(100014,56,1,1,GETDATE(),1),
--(100014,72,1,1,GETDATE(),1),
--(100014,145,1,1,GETDATE(),1),
--(100014,132,1,1,GETDATE(),1),
--(100014,41,1,1,GETDATE(),1),
--(100014,92,1,1,GETDATE(),1),
--(100014,87,1,1,GETDATE(),1),
--(100014,22,1,1,GETDATE(),1),
--(100014,23,1,1,GETDATE(),1),
--(100014,24,1,1,GETDATE(),1),
--(100014,25,1,1,GETDATE(),1),
--(100014,20,1,1,GETDATE(),1),
--(100014,39,1,1,GETDATE(),1),
--(100014,36,1,1,GETDATE(),1),
--(100014,34,1,1,GETDATE(),1),
--(100014,37,1,1,GETDATE(),1),
--(100014,38,1,1,GETDATE(),1),
--(100014,71,1,1,GETDATE(),1),
--(100014,91,1,1,GETDATE(),1),
--(100014,21,1,1,GETDATE(),1),
--(100014,19,1,1,GETDATE(),1),
--(100014,18,1,1,GETDATE(),1),
--(100014,131,1,1,GETDATE(),1),
--(100014,147,1,1,GETDATE(),1),
--(100014,129,1,1,GETDATE(),1),
--(100014,130,1,1,GETDATE(),1),
--(100014,106,1,1,GETDATE(),1),
--(100014,150,1,1,GETDATE(),1),
--(100014,152,1,1,GETDATE(),1),
--(100014,151,1,1,GETDATE(),1),
--(100014,149,1,1,GETDATE(),1)


--update SpecialRights set Active=0 where ID=941


select * from ProductMaster

select * from ProductUserMatrix where LanID=201870


--INSERT INTO ModuleMatrix
--                      (PageName, ParentNode, ControlKey, PageDescription, ModuleID, Active, CreatedDate, CreatedBy)
--VALUES     ('pageName',,'~/modules/attendance/AttendanceRemark.aspx','Desc',,1,GETDATE(),0)

--INSERT INTO RoleMatrix
--                      (RoleID, PageID, ReadOnly, Active, CreatedDate, CreatedBy)
--select    12,169,0,1,GETDATE(),0
--union
--select    10,169,0,1,GETDATE(),0
--union
--select    14,169,0,1,GETDATE(),0

141,133,139,141,138,136,137

select * from EmployeeMaster where EmployeeID=300393
select * from Login where EmployeeID=101166
--update Login set RoleID=4 where EmployeeID=101166
--update Login set active=1 where EmployeeID=101166
--update Login set StandardLogin=1 where EmployeeID=100409



select * from ProductMaster
--SELECT * FROM ProductUserMatrix 
select * from ModuleMatrix where PageName in('idmgt','eProcurement')

--INSERT INTO ProductPageMatrix
--                      (ProductID, PageID, Active)
--select 27,PageID,1 from ModuleMatrix where ParentNode=122 or PageName in('idmgt')

--INSERT INTO ProductPageMatrix
--                      (ProductID, PageID, Active)
--select 26,PageID,1 from ModuleMatrix where ParentNode=92 or PageName in('eProcurement')



---------Attendnace view role for anil chaudhary's process-------------------------
Select * from EmployeeAttendanceProcessMatrix where ProcessID=357

--INSERT INTO EmployeeAttendanceProcessMatrix
--                      (EmployeeID, ProcessID)
--                    values( 201778,357)
--SELECT '100409' as EmployeeID
--      ,[ProcessID]
--  FROM [ARMS].[dbo].[EmployeeAttendanceProcessMatrix]
--  where EmployeeID=201778
--delete from EmployeeAttendanceProcessMatrix where EmployeeID=100409
