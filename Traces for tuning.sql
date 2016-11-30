SELECT *
 	--status, 
 	--path, 
 	--max_size, 
 	--buffer_count, 
 	--buffer_size, 
 	--event_count, 
 	--dropped_event_count 
FROM sys.traces 
WHERE id = 2 --this is our trace id that we get from the create script

DECLARE @tid INT
SET @tid = --whatever your traceid is

--stops the trace (id, status)
EXEC sp_trace_setstatus @tid, 0

--removes the trace at the next sql server service restart (id, status)
EXEC sp_trace_setstatus @tid, 2


--dump trace into a table for instpection if you want
SELECT *
INTO inside_sql_trace
FROM fn_trace_gettable('k:\Traces\ABS_Tuning.trc', 1) --this is j



/****************************************************/
/* Created by: SQL Server 2008 R2 Profiler          */
/* Date: 10/05/2016  10:49:41 AM         */
/****************************************************/
--this is create from setting up the trace, starting and stopping and then exporting from the file menu.

-- Create a Queue
declare @rc int
declare @TraceID int
declare @maxfilesize bigint
set @maxfilesize = 500

-- Please replace the text InsertFileNameHere, with an appropriate
-- filename prefixed by a path, e.g., c:\MyFolder\MyTrace. The .trc extension
-- will be appended to the filename automatically. If you are writing from
-- remote server to local drive, please use UNC path and make sure server has
-- write access to your network share
--(traceid output, rollover files 0 means no rollover, file location/name, max file size, stop date)
exec @rc = sp_trace_create @TraceID output, 0, N'K:\Traces\ABS_Tuning', @maxfilesize, NULL 
if (@rc != 0) goto error

-- Client side File and Table cannot be scripted

-- Set the events
declare @on bit
set @on = 1
exec sp_trace_setevent @TraceID, 10, 1, @on
exec sp_trace_setevent @TraceID, 10, 3, @on
exec sp_trace_setevent @TraceID, 10, 11, @on
exec sp_trace_setevent @TraceID, 10, 35, @on
exec sp_trace_setevent @TraceID, 10, 12, @on
exec sp_trace_setevent @TraceID, 10, 13, @on
exec sp_trace_setevent @TraceID, 45, 1, @on
exec sp_trace_setevent @TraceID, 45, 3, @on
exec sp_trace_setevent @TraceID, 45, 11, @on
exec sp_trace_setevent @TraceID, 45, 35, @on
exec sp_trace_setevent @TraceID, 45, 12, @on
exec sp_trace_setevent @TraceID, 45, 28, @on
exec sp_trace_setevent @TraceID, 45, 13, @on
exec sp_trace_setevent @TraceID, 12, 1, @on
exec sp_trace_setevent @TraceID, 12, 3, @on
exec sp_trace_setevent @TraceID, 12, 11, @on
exec sp_trace_setevent @TraceID, 12, 35, @on
exec sp_trace_setevent @TraceID, 12, 12, @on
exec sp_trace_setevent @TraceID, 12, 13, @on


-- Set the Filters
declare @intfilter int
declare @bigintfilter bigint

exec sp_trace_setfilter @TraceID, 35, 0, 6, N'ABS'
-- Set the trace status to start
exec sp_trace_setstatus @TraceID, 1

-- display trace id for future references
select TraceID=@TraceID
goto finish

error: 
select ErrorCode=@rc

finish: 
go

use master;
SELECT servicename, service_account
FROM   sys.dm_server_services