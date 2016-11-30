
/*
This script creates a file and fills it with the content of the @Text string.

You need to ensure OLE Automation is enabled for this to work (command to turn OLE Automation is at the top of the script).

Ensure that the SQL Server Service user is granted rights to create files and write in the directory where you wish to output the file. 
NT SERVICE\MSSQL$InstanceName or NT SERVICE\MSSQLSERVER for default mode.

Set @File = full path of output file

Set @Text = desired content for the file.

Note: if you use

EXECUTE sp_OAMethod @FileID,'WriteLine',NULL,@Text

in a loop you can add as many lines to the file as you need to add (just keep updating @Text to the content for the next line)
*/




sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'Ole Automation Procedures', 1;
GO
RECONFIGURE;
GO

DECLARE @File VARCHAR(2000) = '<filepath>\myfile.txt'
	,@Text VARCHAR(2000) = 'This is the file content. Fill it as you wish'

DECLARE @OLE INT
DECLARE @FileID INT

	EXECUTE sp_OACreate 'Scripting.FileSystemObject',@OLE OUTPUT

	EXECUTE sp_OAMethod @OLE,'OpenTextFile',@FileID OUTPUT,@File,8,1

	EXECUTE sp_OAMethod @FileID,'WriteLine',NULL,@Text

	EXECUTE sp_OADestroy @FileID

	EXECUTE sp_OADestroy @OLE
GO
