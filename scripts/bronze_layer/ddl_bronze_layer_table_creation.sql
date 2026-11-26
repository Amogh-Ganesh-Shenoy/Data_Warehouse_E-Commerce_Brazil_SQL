/*
------------------------------------
Bronze Layer- Table Creation
-----------------------------------
Purpose:
-> To create the appropriate tables for the DB 'Brazil_E_Commerce_DataWarehouse'.
-> This script Drops the table if it already exisits and then Creates the appropriate tables. 

Data types used:
-> INT, FLOAT, DATETIME2, NVARCHAR

Please note: 
-> Since this script drops the table data already present in these tables will be deleted. 
-> If tables exsist, be sure to ignore the 
      IF OBJECT_ID ('table_name', 'U') IS NOT NULL
	        DROP TABLE table_name
*/


USE Brazil_E_Commerce_DataWarehouse

--Table Creation
IF OBJECT_ID ('bronze.olist_customer_dataset', 'U') IS NOT NULL
	DROP TABLE bronze.olist_customer_dataset
CREATE TABLE bronze.olist_customer_dataset
(
  customer_id NVARCHAR(100),
  customer_unique_id NVARCHAR(100),
  customer_zip_code_prefix NVARCHAR(50),
  customer_city NVARCHAR(50),
  customer_state NVARCHAR(50)
)

IF OBJECT_ID ('bronze.olist_grolocation_dataset', 'U') IS NOT NULL
	DROP TABLE bronze.olist_grolocation_dataset
CREATE TABLE bronze.olist_grolocation_dataset
(
  geolocation_zip_code_prefix NVARCHAR(50),
  geolocation_lat FLOAT,
  geolocation_lng FLOAT,
  geolocation_city NVARCHAR(50),
  geolocation_state NVARCHAR(50)
)

IF OBJECT_ID ('bronze.olist_order_items_dataset', 'U') IS NOT NULL
	DROP TABLE bronze.olist_order_items_dataset
CREATE TABLE bronze.olist_order_items_dataset
(
  order_id NVARCHAR(50),
  order_item_id INT,
  product_id NVARCHAR(50),
  seller_id NVARCHAR(50),
  shipping_limit_date DATETIME2,
  price FLOAT,
  freight_value FLOAT
)

IF OBJECT_ID ('bronze.olist_order_payments_dataset', 'U') IS NOT NULL
	DROP TABLE bronze.olist_order_payments_dataset
CREATE TABLE bronze.olist_order_payments_dataset
(
  order_id NVARCHAR(50),
  payment_sequential INT,
  payment_type NVARCHAR(50),
  payment_installments INT,
  payment_value FLOAT
)

IF OBJECT_ID ('bronze.olist_order_reviews_dataset', 'U') IS NOT NULL
	DROP TABLE bronze.olist_order_reviews_dataset
CREATE TABLE bronze.olist_order_reviews_dataset
(
  review_id NVARCHAR(50),
  order_id NVARCHAR(50),
  review_score INT,
  review_comment_title NVARCHAR(200),
  review_comment_message NVARCHAR(250),
  review_creation_date DATETIME2,
  review_answer_timestamp DATETIME2
)

IF OBJECT_ID ('bronze.olist_orders_dataset', 'U') IS NOT NULL
	DROP TABLE bronze.olist_orders_dataset
CREATE TABLE bronze.olist_orders_dataset
(
  order_id NVARCHAR(50),
  customer_id NVARCHAR(50),
  order_status NVARCHAR(50),
  order_purchase_timestamp DATETIME2,
  order_approved_at DATETIME2,
  order_delivered_carrier_date DATETIME2,
  order_delivered_customer_date DATETIME2,
  order_estimated_delivery_date DATETIME2
)

IF OBJECT_ID ('bronze.olist_products_dataset', 'U') IS NOT NULL
	DROP TABLE bronze.olist_products_dataset
CREATE TABLE bronze.olist_products_dataset
(
  product_id NVARCHAR(50),
  product_category_name NVARCHAR(50),
  product_name_lenght INT,
  product_description_lenght INT,
  product_photos_qty INT,
  product_weight_g INT,
  product_length_cm INT,
  product_height_cm INT,
  product_width_cm INT
)

IF OBJECT_ID ('bronze.olist_sellers_dataset', 'U') IS NOT NULL
	DROP TABLE bronze.olist_sellers_dataset
CREATE TABLE bronze.olist_sellers_dataset
(
  seller_id NVARCHAR(50),
  seller_zip_code_prefix NVARCHAR(50),
  seller_city NVARCHAR(50),
  seller_state NVARCHAR(50)
)

IF OBJECT_ID ('bronze.product_category_name_translation', 'U') IS NOT NULL
	DROP TABLE bronze.product_category_name_translation
CREATE TABLE bronze.product_category_name_translation
(
  product_category_name NVARCHAR(50),
  product_category_name_english NVARCHAR(50)
)
