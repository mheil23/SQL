




--Pull metadata on databases
;WITH cte_files AS 
(
	SELECT 
		database_id
		,CASE 
			WHEN type = 0 THEN 'Data' 
			WHEN type = 1 THEN 'Log' 
			ELSE 'Other' END AS file_type
		,CAST(ROUND(size * 8.0 /1024/1024, 2) AS NUMERIC(10, 2)) AS size 
	FROM sys.master_files
), cte_files_data AS 
(
	SELECT 
		database_id
		,file_type
		,SUM(size) AS size 
	FROM cte_files 
	WHERE file_type = 'Data' 
	GROUP BY database_id, file_type
), cte_files_log AS 
(
	SELECT 
		database_id
		,file_type
		,SUM(size) AS size 
	FROM cte_files 
	WHERE file_type = 'Log' 
	GROUP BY database_id, file_type
), cte_files_other AS 
(
	SELECT 
		database_id
		,file_type
		,SUM(size) AS size 
	FROM cte_files 
	WHERE file_type = 'Other' 
	GROUP BY database_id, file_type
), cte_db_total AS 
(
	SELECT 
		database_id
		,SUM(size) AS size 
	FROM cte_files 
	GROUP BY database_id
), cte_database_size AS 
(
	SELECT 
		fd.database_id
		,ISNULL(dt.size, 0.0) as db_size
		,ISNULL(fd.size, 0.0) as data_size
		,ISNULL(fl.size, 0.0) AS log_size
		,ISNULL(fo.size, 0.0) AS other_size
	FROM cte_db_total dt 
	LEFT OUTER JOIN cte_files_data fd ON dt.database_id = fd.database_id
	LEFT OUTER JOIN cte_files_log fl ON fd.database_id = fl.database_id
	LEFT OUTER JOIN cte_files_other fo ON fd.database_id = fo.database_id
)
SELECT 
	'' AS location
	,'' AS host
	,d.name
	,d.compatibility_level
	,d.recovery_model_desc
	,d.is_trustworthy_on
	,d.state_desc
	,d.is_read_only
	,(CASE WHEN d.database_id < 5 THEN 1 ELSE 0 END) AS is_system
	,ds.db_size, ds.data_size, ds.log_size, ds.other_size
FROM sys.databases d
INNER JOIN cte_database_size ds ON d.database_id = ds.database_id
ORDER BY is_system DESC, d.name ASC;


