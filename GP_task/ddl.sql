-- Table Creation Requirements

-- Customers Table: 
-- Create a table named "customers" with columns for customer ID, customer 
-- name, email address, country, and any other relevant information.

-- Products Table: 
-- Create a table named "products" with columns for product ID, product name, 
-- price, category, and any other relevant information.

-- Sales Transactions Table: 
-- Create a table named "sales_transactions" with columns for transaction 
-- ID, customer ID (foreign key referencing the customers table), product ID (foreign key referencing 
-- the products table), purchase date, quantity purchased, and any other relevant information.

-- Shipping Details Table: 
-- Create a table named "shipping_details" with columns for transaction ID 
-- (foreign key referencing the sales_transactions table), shipping date, shipping address, city, 
-- country, and any other relevant information.

-- Ensure that tables are created in an optimized manner, utilizing data distribution and appropriate 
-- data types and constraints for each column. Establish proper relationships between the tables 
-- using foreign key constraints.

-------------------------------------------------------------------------------------

-- we use the simpliest way for make this task, so...
-- let's mark some important points:
--   1. we don't store change history
--   2. we build schema more based of requirements then concepts
--   3. generaly, we create tables not for production hi-load use
-- we can disscuss other ways additionaly

-- first, i think we need to create schema

create schema dds;

-- then create tables what we need


create table dds.customers (
    customer_id int8 -- if we don't have a lot of clients it could be int4 or even int2
    ,first_name varchar(255) not null
    ,last_name varchar(255) not null
    ,email varchar(255) not null
    ,country varchar(255) not null
    ,city varchar(255) not null
    ,phone varchar(255) not null
    ,primary key (customer_id)
)
WITH (
	orientation=column
)
DISTRIBUTED BY (customer_id)
; 

create  table dds.products (
    product_id int8 -- if we don't have a lot of product it could be int4 or even int2
    ,name varchar(255) not null
    ,price numeric(10,2) not null
    ,category varchar(255) not null
    ,description text null
    ,primary key (product_id)
)
WITH (
	orientation=column
)
DISTRIBUTED BY (product_id)
;

create table dds.sales_transactions (
    sales_transaction_id int8 -- if we don't have a lot of transactions it could be int4
    ,customer_id int8 not null
    ,product_id int8 not null
    ,purchase_date date not null
    ,purchase_quantity int2 not null
    ,primary key (sales_transactions_id)
    ,foreign key (customer_id) references dds.customers (customer_id)
    ,foreign key (product_id) references dds.products (product_id)
)
WITH (
	orientation=column
)
DISTRIBUTED BY (sales_transactions_id, purchase_date)
;

create table dds.shipping_details (
    shipping_details_id int8 -- if we don't have a lot of shipping it could be int4
    ,sales_transaction_id int8
    ,shipping_date date 
    ,shipping_address varchar(2000) not null
    ,city varchar(255) not null
    ,country varchar(255) not null
    ,primary key (shipping_details_id)
    ,foreign key (sales_transaction_id) references dds.sales_transactions (sales_transaction_id)
)
WITH (
	orientation=column
)
DISTRIBUTED BY (shipping_details_id)
;