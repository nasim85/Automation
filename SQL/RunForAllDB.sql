/*
-- role management
exec sp_MSforeachdb ' 
use [?]; 
IF(DB_NAME() NOT IN (''master'',''tempdb'',''model'',''msdb'') ) 
BEGIN 
CREATE USER [India\300915] FOR LOGIN [India\300915] ; 
EXEC SP_ADDROLEMEMBER N''DB_DATAREADER'' ,N''India\300915''; 
EXEC SP_ADDROLEMEMBER N''DB_DATAwriter'' ,N''India\300915''; 
GRANT EXECUTE to [India\300915]; 
GRANT VIEW DEFINITION to [India\300915];
--print [?];
END 
'

*/



-- Synonyms 
exec sp_MSforeachdb ' 
use [?]; 
IF(DB_NAME() IN (''TranMAMI'',''TranMPME'',''TranSCFL'',''TranSJPK'',''TranWYMI'') ) 
BEGIN 


drop synonym [Accretive_CrossFacilityGroup]
CREATE SYNONYM [dbo].[Accretive_CrossFacilityGroup] FOR [AHVA2APL5COR01].[Accretive].[dbo].[CrossFacilityGroup];

drop synonym Accretive_FacilityPayerPlan
CREATE SYNONYM [dbo].[Accretive_FacilityPayerPlan] FOR [AHVA2APL5COR01].[Accretive].[dbo].[FacilityPayerPlan];



drop synonym Accretive_FacilityGroup
CREATE SYNONYM [dbo].[Accretive_FacilityGroup] FOR [AHVA2APL5COR01].[Accretive].[dbo].[FacilityGroup];

END 
'


