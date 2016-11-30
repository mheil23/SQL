use ScriptureAnalytics;



---for whatever reason can see the file
select *
from openrowset('MSDASQL'
,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; DefaultDir=C:\Users\mheil\Desktop\testa;Extended properties="FORMAT=Delimited(|);ColNameHeader=True;"'
,'select * from testa.csv')


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
Exec master.dbo.xp_cmdshell 'BCP ScriptureAnalytics.dbo.Events in "C:\Events_20160914.csv" -S ABS-HEIL\SQLEXPRESS2014 -q -c -t"|" -T'

--requires table exist
BULK INSERT [Events] FROM 'C:\Events20160914.csv'  
   WITH (  
      DATAFILETYPE = 'char',  
      FIELDTERMINATOR = '|',  
      ROWTERMINATOR = '\n'  
);  
GO  



/*
Criteria:
US only

fields in question:
abs_fums_username (email),

fields not used:
user_ipaddress, geo_latitude, geo_longitude, 

*/

