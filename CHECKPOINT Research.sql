

--Auditing


USE recoverytest;
GO

CREATE SERVER AUDIT





select * from test

INSERT INTO test values(getdate());

CHECKPOINT;

SELECT [Current LSN], [Operation] FROM fn_dblog (NULL, NULL); 
--https://blogs.msdn.microsoft.com/dfurman/2009/11/05/reading-database-transaction-log-with-fn_dump_dblog/


LOP_BEGIN_XACT
LOP_INSERT_ROWS
LOP_COMMIT_XACT
LOP_COUNT_DELTA
LOP_COUNT_DELTA
LOP_COUNT_DELTA
LOP_BEGIN_CKPT
LOP_END_CKPT



