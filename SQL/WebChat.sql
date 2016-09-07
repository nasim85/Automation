select * from SL_Chat
select * from SL_ChatOwner where ChatID=8
select * from DNN_Users where DisplayName like '%badri%'
select * from SL_Question  where ChatID=12 and AskedBy='Guest-162'
select EnteredBy, COUNT(QuestionID) from SL_Question  where ChatID=12 group by EnteredBy
select * from SL_Answer where QuestionID in(select QuestionID from SL_Question  where ChatID=12)

--update SL_Question set EnteredBy='10.240.152.23' where QuestionID=555555555
--INSERT INTO SL_ChatOwner
--                      (ChatID, Owner, userType, EntryDate, EnteredBy, visible)
--VALUES     (8,'Sumit Sabarwal','M',GETDATE(),0,0)

--delete from SL_Question where ChatID=12
update SL_Chat set StartTime='2013-01-04 20:00:00.000' ,EndTime='2013-01-04 21:30:00.000' where ChatID=12
--update SL_Chat set UserCount=0 where ChatID=12
--update SL_Chat set ChatName='Web chat – All Unit' where ChatID=8
--update SL_Question set ChatID=6 where ChatID=8


--INSERT INTO SL_Chat (ChatName, StartTime, EndTime, Active, ChatKey, EntryDate, UserCount, isPublic)
--VALUES     ('Web chat Morning– All Unit','1/4/2013 14:00:00','1/4/2013 15:00:00',1,'ahwcm06',GETDATE(),0,1),
--			('Web chat Evening– All Unit','1/4/2013 20:30:00','1/4/2013 21:30:00',1,'ahwce06',GETDATE(),0,1)


INSERT INTO SL_ChatOwner (ChatID, Owner, userType, EntryDate, visible)
		VALUES      (9,'Asheesh Khare','O',GETDATE(),1),
					(9,'Ashish Kumar Aggarwal','O',GETDATE(),1),
					(9,'Dhyan Chauhan','O',GETDATE(),1),
					(9,'Kuljit Hooda','O',GETDATE(),1),
					(9,'Anil Choudhary','O',GETDATE(),1),
					(9,'Jai Prakash Tondak','O',GETDATE(),1),
					(9,'Amit Kalra AK','O',GETDATE(),1),
					(9,'Anamika Singh','M',GETDATE(),1),
					(9,'Pritish','M',GETDATE(),0),
					(9,'Sumit Sabarwal','M',GETDATE(),0),
					(9,'Badri Narayan Srinivasan','O',GETDATE(),0)
					




--Delete from sl_Question

sp_helptext SL_InsertQuestion
sp_helptext SL_InsertAnswer
sp_helptext SL_GetQuestion
SP_Helptext SL_RejectQuestion --'5','Nasimuddin'
SP_Helptext SL_GetChatID