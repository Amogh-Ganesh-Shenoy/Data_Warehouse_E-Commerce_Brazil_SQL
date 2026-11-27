/*
----------------------------------------
Procedure Load Bronze Layer
----------------------------------------
Purpose:
    Loads the raw Olist CSV files into the bronze schema tables using
    BULK INSERT. No transformations are applied; data lands as it appears in
    the source files.

Load pattern:
    Full load. Each table is truncated, then reloaded from its CSV file.

Tables loaded (9):
    bronze.olist_customers_dataset
    bronze.olist_geolocation_dataset
    bronze.olist_order_items_dataset
    bronze.olist_order_payments_dataset
    bronze.olist_order_reviews_dataset
    bronze.olist_orders_dataset
    bronze.olist_products_dataset
    bronze.olist_sellers_dataset
    bronze.product_category_name_translation

Pre-processing (reviews only):
    olist_order_reviews_dataset.csv has line breaks inside quoted comment
    fields, which BULK INSERT reads as new rows. Run the cleaning script
    before this procedure:

        Script:  scripts/preprocessing/clean_reviews.py
        Input:   olist_order_reviews_dataset.csv (original, left untouched)
        Output:  reviews_clean.csv (loaded by this procedure)

    The cleaned file uses CRLF line endings (0x0d0a) and UTF-8 encoding
    (CODEPAGE 65001), so the Portuguese accents are preserved. All other
    files use LF line endings (0x0a).

Prerequisites:
    - The bronze tables already exist (run the bronze DDL script first).
    - CSV files are in C:\SQL_Data_Warehouse_Project_2\archive\
      (paths are hard-coded; update to required path).

Parameters:
    None.

Output:
    PRINT messages with the load duration per table and for the whole layer.

Usage:
    EXEC bronze.load_bronze;
===============================================================================
*/



CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    
    DECLARE @start_time AS DATETIME,
            @end_time AS DATETIME,
            @batch_start_time AS DATETIME,
            @batch_end_time AS DATETIME;
    BEGIN TRY 
            SET @batch_start_time = GETDATE();

            PRINT '------------------------';
            PRINT 'Build Table Insert'
            PRINT '------------------------';
            
            --Loading data into the tables;
            SET @start_time = GETDATE();
            PRINT 'Truncating table: olist_customers_dataset';
            TRUNCATE TABLE bronze.olist_customers_dataset;
            PRINT 'Loading table: olist_customers_dataset';
            BULK INSERT bronze.olist_customers_dataset
            FROM 'C:\SQL_Data_Warehouse_Project_2\archive\olist_customers_dataset.csv'
            WITH
            (
                FORMAT = 'CSV', -- Treats the file as a proper CSV (handles quoted fields)
                FIELDQUOTE = '"', -- Quote character wrapped around values; stripped on load
                FIRSTROW = 2, -- Skip the header row
                FIELDTERMINATOR = ',',-- Columns are separated by commas
                ROWTERMINATOR = '0x0a',-- Rows end with LF (Unix); use '0x0d0a' for CRLF (Windows)
                TABLOCK
            );   
            SET @end_time = GETDATE();
            PRINT 'Load Duration: olist_customers_dataset ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR(10)) + ' seconds.'
            PRINT '------------------------';


            SET @start_time = GETDATE();
            PRINT 'Truncating table: olist_geolocation_dataset';
            TRUNCATE TABLE bronze.olist_geolocation_dataset;
            PRINT 'Loading table: olist_geolocation_dataset';
            BULK INSERT bronze.olist_geolocation_dataset
            FROM 'C:\SQL_Data_Warehouse_Project_2\archive\olist_geolocation_dataset.csv'
            WITH
            (
                FORMAT = 'CSV', -- Treats the file as a proper CSV (handles quoted fields)
                FIELDQUOTE = '"', -- Quote character wrapped around values; stripped on load
                FIRSTROW = 2, -- Skip the header row
                FIELDTERMINATOR = ',',-- Columns are separated by commas
                ROWTERMINATOR = '0x0a',-- Rows end with LF (Unix); use '0x0d0a' for CRLF (Windows)
                TABLOCK
            );   
            SET @end_time = GETDATE();
            PRINT 'Load Duration: olist_geolocation_dataset ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR(10)) + ' seconds.'
            PRINT '------------------------';


            SET @start_time = GETDATE();
            PRINT 'Truncating table: olist_order_items_dataset';
            TRUNCATE TABLE bronze.olist_order_items_dataset;
            PRINT 'Loading table: olist_order_items_dataset';
            BULK INSERT bronze.olist_order_items_dataset
            FROM 'C:\SQL_Data_Warehouse_Project_2\archive\olist_order_items_dataset.csv'
            WITH 
            (
                FORMAT = 'CSV',
                FIELDQUOTE ='"',
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '0x0a',
                TABLOCK
            );
            SET @end_time = GETDATE();
            PRINT 'Load Duration: olist_order_items_dataset ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR(10)) + ' seconds.'
            PRINT '------------------------';


            SET @start_time = GETDATE();
            PRINT 'Truncating table: olist_order_payments_dataset';
            TRUNCATE TABLE bronze.olist_order_payments_dataset;
            PRINT 'Loading table: olist_order_payments_dataset';
            BULK INSERT bronze.olist_order_payments_dataset
            FROM 'C:\SQL_Data_Warehouse_Project_2\archive\olist_order_payments_dataset.csv'
            WITH 
            (
                FORMAT = 'CSV',
                FIELDQUOTE ='"',
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '0x0a',
                TABLOCK
            );
            SET @end_time = GETDATE();
            PRINT 'Load Duration: olist_order_payments_dataset ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR(10)) + ' seconds.'
            PRINT '------------------------';


            SET @start_time = GETDATE();
            PRINT 'Truncating table: olist_order_reviews_dataset';
            TRUNCATE TABLE bronze.olist_order_reviews_dataset;
            PRINT 'Loading table: olist_order_reviews_dataset';
            BULK INSERT bronze.olist_order_reviews_dataset
            FROM 'C:\SQL_Data_Warehouse_Project_2\archive\reviews_clean.csv' --Loading New Cleaned data from reveiws.clean 
            WITH 
            (
                FORMAT = 'CSV',
                FIELDQUOTE ='"',
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '0x0d0a',
                CODEPAGE = '65001', --Keeps portugese accents. 
                TABLOCK
            );
            SET @end_time = GETDATE();
            PRINT 'Load Duration: olist_order_reviews_dataset ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR(10)) + ' seconds.'
            PRINT '------------------------';


            SET @start_time = GETDATE();
            PRINT 'Truncating table: olist_orders_dataset';
            TRUNCATE TABLE bronze.olist_orders_dataset;
            PRINT 'Loading table: olist_orders_dataset';
            BULK INSERT bronze.olist_orders_dataset
            FROM 'C:\SQL_Data_Warehouse_Project_2\archive\olist_orders_dataset.csv'
            WITH 
            (
                FORMAT = 'CSV',
                FIELDQUOTE ='"',
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '0x0a',
                TABLOCK
            );
            SET @end_time = GETDATE();
            PRINT 'Load Duration: olist_orders_dataset ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR(10)) + ' seconds.'
            PRINT '------------------------';


            SET @start_time = GETDATE();
            PRINT 'Truncating table: olist_products_dataset';
            TRUNCATE TABLE bronze.olist_products_dataset;
            PRINT 'Loading table: olist_products_dataset';
            BULK INSERT bronze.olist_products_dataset
            FROM 'C:\SQL_Data_Warehouse_Project_2\archive\olist_products_dataset.csv'
            WITH 
            (
                FORMAT = 'CSV',
                FIELDQUOTE ='"',
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '0x0a',
                TABLOCK
            );
            SET @end_time = GETDATE();
            PRINT 'Load Duration: olist_products_dataset ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR(10)) + ' seconds.'
            PRINT '------------------------';


            SET @start_time = GETDATE();
            PRINT 'Truncating table: olist_sellers_dataset';
            TRUNCATE TABLE bronze.olist_sellers_dataset;
            PRINT 'Loading table: olist_sellers_dataset';
            BULK INSERT bronze.olist_sellers_dataset
            FROM 'C:\SQL_Data_Warehouse_Project_2\archive\olist_sellers_dataset.csv'
            WITH 
            (
                FORMAT = 'CSV',
                FIELDQUOTE ='"',
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '0x0a',
                TABLOCK
            );
            SET @end_time = GETDATE();
            PRINT 'Load Duration: olist_sellers_dataset ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR(10)) + ' seconds.'
            PRINT '------------------------';


            SET @start_time = GETDATE();
            PRINT 'Truncating table: product_category_name_translation';
            TRUNCATE TABLE bronze.product_category_name_translation;
            PRINT 'Loading table: product_category_name_translation';
            BULK INSERT bronze.product_category_name_translation
            FROM 'C:\SQL_Data_Warehouse_Project_2\archive\product_category_name_translation.csv'
            WITH 
            (
                FORMAT = 'CSV',
                FIELDQUOTE ='"',
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '0x0a',
                TABLOCK
            );
            SET @end_time = GETDATE();
            PRINT 'Load Duration: product_category_name_translation ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR(10)) + ' seconds.'
            PRINT '------------------------';

            SET @batch_end_time = GETDATE();
		    PRINT 'Load Duration:Bronze Layer ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR(50)) + ' seconds.';
		    PRINT '------------------------------------';
    END TRY

    BEGIN CATCH 
        PRINT '=============================';
		PRINT 'Error Occured During Loading';
		PRINT '=============================';
		PRINT 'Error Message' + CAST(ERROR_MESSAGE() AS NVARCHAR(50));
		PRINT 'Error Number' + CAST(ERROR_NUMBER() AS NVARCHAR(50));
    END CATCH

END;

