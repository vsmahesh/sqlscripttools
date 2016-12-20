-- FIND INDEX FRAGMENTATION AND PROVIDES REBUILD STATEMENT
SELECT 
 OBJECT_NAME(ips.object_id) AS tblName
 , i.name
,avg_fragmentation_in_percent
, 'ALTER INDEX ['+ i.name + '] ON [dbo].[' + OBJECT_NAME(ips.object_id) + '] REBUILD PARTITION = ALL' rebuild_stmt
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) ips
INNER JOIN sys.indexes i
    ON i.object_id=ips.object_id
	AND i.index_id = ips.index_id
WHERE avg_fragmentation_in_percent > 20
AND index_type_desc IN('CLUSTERED INDEX', 'NONCLUSTERED INDEX')
ORDER BY avg_fragmentation_in_percent DESC