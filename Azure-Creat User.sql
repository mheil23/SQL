


--CREATE USER IN AZURE-------------------------------------------------------------------------------------------------------------------------------
--To Create a user for an Azure DB, you have to first create the login on the master database (by right clicking master db and selecting new query)
CREATE LOGIN <loginname> WITH PASSWORD= <'password'> --make sure password is text
--Then create the user in the User DB on the Azure instance
CREATE USER <username> FROM LOGIN <loginname>
--Then you can grant access to the user, to a schema for instance, like this
GRANT ALTER ON SCHEMA::<schemaname> TO <username>
--Add security role to the user, this HAS TO BE DONE ON THE MASTER DATABASE. Logins and roles are handled there. Right click new query
--https://msdn.microsoft.com/library/ms189775.aspx.
ALTER ROLE dbmanager ADD MEMBER <member>
-----------------------------------------------------------------------------------------------------------------------------------------------------
