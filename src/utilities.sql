--Clear tables----------------------------
TRUNCATE TABLE call_center ;
TRUNCATE TABLE catalog_page;
TRUNCATE TABLE catalog_returns;
TRUNCATE TABLE catalog_sales;
TRUNCATE TABLE customer;
TRUNCATE TABLE customer_address;
TRUNCATE TABLE customer_demographics;
TRUNCATE TABLE date_dim;
TRUNCATE TABLE dbgen_version;
TRUNCATE TABLE household_demographics;
TRUNCATE TABLE income_band;
TRUNCATE TABLE inventory;
TRUNCATE TABLE item;
TRUNCATE TABLE promotion;
TRUNCATE TABLE reason;
TRUNCATE TABLE ship_mode;
TRUNCATE TABLE store;
TRUNCATE TABLE store_returns;
TRUNCATE TABLE store_sales;
TRUNCATE TABLE time_dim;
TRUNCATE TABLE warehouse;
TRUNCATE TABLE web_page;
TRUNCATE TABLE web_returns;
TRUNCATE TABLE web_sales;
TRUNCATE TABLE web_site;
--------------------------------------------

--Get count(*) for every table--------------
SELECT schemaname,relname,n_live_tup 
FROM pg_stat_user_tables 
ORDER BY n_live_tup DESC;
--------------------------------------------

