




--Large data import preparation
--disable constraints and triggers/switch to bulk recovery model / drop indexes

ALTER DATABASE AdventureWorks2014 SET RECOVERY BULK_LOGGED WITH NO_WAIT
GO

ALTER TABLE dbo.tablename NOCHECK CONSTRaiNT ALL
GO

DISABLE TRIGGER ALL ON dbo.tablename

DROP INDEX indexname ON dbo.tablename

----------------------------------------------------------------------------------
--Then turn everything back on 

ALTER DATABASE AdventureWorks2014 SET RECOVERY FULL WITH NO_WAIT
GO

ALTER TABLE dbo.tablename CHECK CONSTRAINT ALL

ENABLE TRIGGER ALL ON dbo.tablename

--create nonclustered indexes as needed


--If data coming in is sorted by the key (clustered primary index) then there won't be an issue when the data
--get's inserted into the data pages.
