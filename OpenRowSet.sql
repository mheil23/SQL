use ScriptureAnalytics;



---for whatever reason can see the file
select *
from openrowset('MSDASQL'
,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; DefaultDir=C:\<mydirectory>;Extended properties="FORMAT=Delimited(|);ColNameHeader=True;"'
,'select * from <filename>.csv')


 -- To allow advanced options to be changed.  
EXEC sp_configure 'show advanced options', 1;  
GO  
-- To update the currently configured value for advanced options.  
RECONFIGURE;  
GO  
-- To enable the feature.  
EXEC sp_configure 'xp_cmdshell', 1;  
GO  
-- To update the currently configured value for this feature.  
RECONFIGURE;  
GO  

--requires table exists
Exec master.dbo.xp_cmdshell 'BCP <existing.schema.table> in "C:\<filename>.csv" -S <MACHINE NAME>\<NAMED INSTANCE> -q -c -t"|" -T'

--requires table exist
BULK INSERT [Events] FROM 'C:\<filename>.csv'  
   WITH (  
      DATAFILETYPE = 'char',  
      FIELDTERMINATOR = '|',  
      ROWTERMINATOR = '\n'  
);  
GO  


