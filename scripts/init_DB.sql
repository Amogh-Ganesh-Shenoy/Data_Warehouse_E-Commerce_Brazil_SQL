/*
--------------------------------------
Create DB and Schema
--------------------------------------
Purpose: 
-> To create DB and Schema; 
->  

Schema Structure: 
-> Within the 'Brazil_E_Commerce_DataWarehouse' DB, the script creates schemas bronze, silver and gold layers. 

Note:
-> Script will drop the DB if it already exixts.
-> Thesefore, all data stored in the DB will be erased.
-------------------------------------------------------------
*/


USE master;
GO

--Checks if DB is existing -> drops and creates required DB
IF EXSISTS(SELECT 1 FROM sys.databases WHERE name = 'Brazil_E_Commerce_DataWarehouse')
BEGIN
  ALTER DATABASE Brazil_E_Commerce_DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE Brazil_E_Commerce_DataWarehouse
END;
GO

--DB Creation
CREATE DATABASE Brazil_E_Commerce_DataWarehouse;
GO


USE Brazil_E_Commerce_DataWarehouse;
GO

--Schema Creation: Medallion Schema, Bronze-> Silver ->Gold
CREATE SCHEMA bronze;
GO 
CREATE SCHEMA silver;
GO 
CREATE SCHEMA gold;


