select * from BandMaster where Active=1
SELECT *  FROM NoticePeriodMatrix where BandID in (select BandID from BandMaster where Active=1 and BandName in ('Level1','Level2'))
SELECT *  FROM NoticePeriodMatrix where BandID in (select BandID from BandMaster where Active=1 and BandName in ('Level3','Level4'))
SELECT *  FROM NoticePeriodMatrix where BandID in (select BandID from BandMaster where Active=1 and BandName in ('Level5','Level6'))

update NoticePeriodMatrix set NoticePeriodID=1 where BandID in (select BandID from BandMaster where Active=1 and BandName in ('Level1','Level2'))
update NoticePeriodMatrix set NoticePeriodID=2 where BandID in (select BandID from BandMaster where Active=1 and BandName in ('Level3','Level4'))
update NoticePeriodMatrix set NoticePeriodID=3 where BandID in (select BandID from BandMaster where Active=1 and BandName in ('Level5','Level6'))

select * from NoticePeriodMaster
GO

