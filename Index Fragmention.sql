--use AdventureWorks2014;
--index fragmentation trouble shooting

--the following will return all indexes in a database
--we can filter by the avg_fragmentation_in_percent to identify indexes that need to be rebuilt or reorganized
--general rule of thumb -  10% > avg frag < 40% then reorganize, avg frag > 40% rebuild

--!!!  Reorganizing an index will require updating the statistics

--there are also standard reports on the database around index physical stats and usage

--index fragmentation
select 
	OBJECT_SCHEMA_NAME(i.object_id) as 'schema',
	OBJECT_NAME(i.object_id) as 'table',
	index_type_desc,
	name,
	avg_fragmentation_in_percent,
	CASE  WHEN avg_fragmentation_in_percent > 40 THEN 'REBUILD'
		  WHEN avg_fragmentation_in_percent >= 10 and avg_fragmentation_in_percent <= 40 THEN 'REORGANIZE'
	END AS 'Action'
FROM sys.dm_db_index_physical_stats(NULL,NULL,NULL,NULL,NULL) ips
INNER JOIN sys.indexes i on ips.OBJECT_ID = i.object_id AND ips.index_id = i.index_id
WHERE avg_fragmentation_in_percent >= 10
ORDER BY [Action] DESC, avg_fragmentation_in_percent DESC

--unused nonclustered indexes
select 
	OBJECT_SCHEMA_NAME(i.object_id) as 'schema',
	OBJECT_NAME(i.object_id) as 'table',
	*
FROM sys.dm_db_index_usage_stats ius
inner join sys.indexes i ON ius.OBJECT_ID = i.object_id and ius.index_id = i.index_id
WHERE type_desc <> 'CLUSTERED' AND user_seeks = 0 and user_scans = 0