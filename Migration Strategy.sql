



/*
	MIGRATION STRATEGY

	1. Use upgrade advisor
	2. Backup/Restore or Detach Attach OR Copy Database Wizard
		Backup/Restore can minimize downtime utilizing transaction logs, but dettach, move, attach is going to be faster. Might be able to just copy MDF and attach?
	3. Objects to migrate
		Database, Security (script out logins and passwords using KB article), Systems (like jobs etc..)
	4. You can additionally Use a contained database, so that you don't have to migrate the users. You have to use sql server logins however.


*/

--Upgrade Advisor (for in-place upgrade)
--Located at Start->All Programs->Microsoft SQL Server <version>->Configuration Tools->SQL Server Installation Center
--First thing you need to do is install the upgrade advisor on the machine where the in-place upgrade is happening. Then you can evaluate the old SQL Server.




/*
	Copy Database Wizard is the way to go. But if the databases are large you might have some issues, especially if you are going over the network.
		Can reuse the integration package that is created for a database copy and iterate through each database
		see if it can be done in t-SQL
	During Migration to a completely separate instance, you have to make sure that you migrate the Server Logins
		USE KB arcticle https://support.microsoft.com/en-us/kb/918992
*/