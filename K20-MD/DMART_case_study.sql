-- DDL Statement
-- Problem Statement : DMART wants to create the Data Models and want to find the consumer behaviour/patterns
 # Steps:
 -- 1. Design
 -- 2. Implementation
 -- 3. Manipulation
 
create schema DMART;

-- use the schema
use DMART;

-- Customer_info Dimension table
create table customer_info (
customer_id varchar(12) not null,
firt_name varchar(20) default null,
last_name varchar(20) default null,
gender char(1) default null,
email varchar(50) default null,
primary key(customer_id),
UNIQUE(email)
);

-- order_product_mapping dimension table
create table order_product_mapping(
order_id varchar(12) not null,
product_id varchar(12) not null,
quantity_ordered int8,
primary key(order_id, product_id),
CHECK(quantity_ordered>0)
);

-- branch_details dimension table
create table branch_details (
store_id varchar(12) not null,
store_name varchar(50) not null,
area varchar(20),
city varchar(20),
state varchar(25) not null,
primary key (store_id)
);

-- product_info dimension table
create table product_info (
product_id varchar(12) not null,
product_name varchar(50) not null,
product_category varchar(50),
list_price decimal(8,2),
sale_price decimal(8,2),
primary key (product_id),
CHECK(list_price>0),
CHECK(sale_price>0)
);

-- creating the fact table sales_fact
create table sales_fact(
order_id varchar(12) not null,
customer_id varchar(12),
order_date date not null,
store_id varchar(12),
primary key(order_id),
constraint foreign key(customer_id) references customer_info(customer_id),
constraint foreign key(store_id) references branch_details(store_id)
);

--- Maniplation
insert into branch_details VALUES ('S1','DMART-I1','Indore-1','Indore','MP'),('S2','DMART-I2','Indore-2','Indore','MP'),('S3','DMART-I3','Indore-3','Indore','MP'),
('S4','DMART-B1','Bhopal-1','Bhopal','MP'),('S5','DMART-B2','Bhopal-2','Bhopal','MP'),('S6','DMART-B3','Bhopal-3','Bhopal','MP'),('S7','DMART-B4','Bhopal-4','Bhopal','MP'),
('S8','DMART-P1','Pune-1','Pune','MH'),('S9','DMART-P2','Pune-2','Pune','MH'),('S10','DMART-P3','Pune-3','Pune','MH'),('S11','DMART-P4','Pune-4','Pune','MH'),
('S12','DMART-M1','Mumbai-1','Mumbai','MH'),('S13','DMART-M2','Mumbai-2','Mumbai','MH'),('S14','DMART-M3','Mumbai-3','Mumbai','MH'),('S15','DMART-M4','Mumbai-4','Mumbai','MH');

-- check 
select * from branch_details;

-- insert records in customer_info
insert into customer_info VALUES ('C1','Parmeet','Singh','M','p@gmail.com'),
('C2','Pavan','Kumar','M','pa@gmail.com'),('C3','Shikha','Gupta','F','s@gmail.com'),('C4','Madhu','Mogulla','M','m@gmail.com'),
('C5','Mansi','Singh','F','ma@gmail.com'),('C6','Mukesh','Sure','M','mu@gmail.com'),('C7','Aniket','Singh','M','a@gmail.com'),
('C8','Chanda','Agrawal','F','c@gmail.com'),('C9','Shruti','Yadav','F','sh@gmail.com'),('C10','Trsihaan','Singh','M','t@gmail.com');

-- check
select * from customer_info;

-- inserting records in sales_fact
insert into sales_fact VALUES ('O1','C1','2020-01-15','S1');
insert into sales_fact VALUES ('O2','C1','2020-01-16','S2'),('O3','C1','2020-02-15','S3'),('O4','C1','2020-02-28','S1'),
('O5','C2','2020-11-16','S5'),('O6','C2','2020-05-6','S3'),('O7','C2','2020-01-28','S4'),('O8','C2','2020-10-16','S4'),('O9','C2','2020-04-30','S4'),('O10','C2','2020-06-28','S3'),
('O11','C3','2020-11-16','S9'),('O12','C3','2020-05-6','S10'),('O13','C3','2020-01-28','S11'),('O14','C3','2020-10-16','S10'),('O15','C3','2020-04-30','S10'),('O16','C3','2020-06-28','S11'),
('O17','C4','2020-11-16','S4'),('O18','C4','2020-05-6','S14'),('O19','C4','2020-01-28','S12'),('O20','C4','2020-10-16','S10'),('O28','C4','2020-04-30','S13'),('O21','C3','2020-06-28','S9'),
('O22','C5','2020-11-16','S5'),('O23','C5','2020-05-6','S3'),('O24','C5','2020-01-28','S4'),('O25','C5','2020-10-16','S4'),('O26','C5','2020-04-30','S4'),('O27','C5','2020-06-28','S3');

-- check
select * from sales_fact;

-- inserting records into order product mapping table
insert into order_product_mapping VALUES ('O1','P1',1),('O1','P2',2),('O1','P3',3),
 ('O2','P1',2),('O2','P2',2),('O2','P4',30), 
 ('O3','P1',12),('O3','P2',2),
 ('O4','P1',12),('O4','P2',2),('O5','P3',300), ('O5','P4',1),
 ('O6','P1',1),('O6','P2',2),('O6','P3',3),
 ('O7','P1',2),('O7','P2',2),('O7','P3',30), 
 ('O8','P1',12),
 ('O9','P1',12),('O9','P2',2),('O9','P3',300),
 ('O10','P1',1000),
 ('O11','P1',12),
 ('O12','P1',100),('O13','P2',100),
 ('O14','P1',100),('O15','P2',100),
 ('O16','P1',100),('O17','P2',100),
 ('O17','P1',1),
 ('O18','P2',1),('O19','P1',1),('O20','P3',11),('O21','P3',1),('O22','P2',11),('O23','P1',111),
 ('O24','P1',1),('O25','P3',1),
 ('O26','P1',1),('O25','P2',1),('O24','P3',100),
 ('O27','P2',1000);

-- check table
select * from order_product_mapping;

-- insert records into product tables
insert into product_info VALUES ('P1','Laptops','Gadgets',50500,80000),('P2','Wheat','Grains',100,120),
('P3','Train','Toys',1000,2000);

-- Problem statemt : Find the Most Crucial customer who is giving more business
-- a. find out the orders placed by each customer
select c.customer_id,count(s.order_id) order_count from 
customer_info as c inner join sales_fact s 
where c.customer_id = s.customer_id
group by c.customer_id order by order_count desc; 

-- b. the price of orders placed by each customer
select c.customer_id,sum(p.list_price) total_list_price, sum(p.sale_price) total_sale_price,
(sum(p.sale_price) - sum(p.list_price)) as Profit
 from 
customer_info c inner join sales_fact s
inner join order_product_mapping o 
inner join product_info p 
on c.customer_id = s.customer_id and
s. order_id = o.order_id and
o.product_id = p.product_id group by c.customer_id order by Profit desc limit 5;

-- which store is more profitable
select  b.store_name,b.area, (sum(p.sale_price) - sum(p.list_price)) as store_profit from branch_details b 
inner join sales_fact s 
inner join order_product_mapping o
inner join product_info p
on b.store_id=s.store_id and 
s.order_id = o.order_id and 
o.product_id = p.product_id group by b.store_id order by store_profit desc;

-- which store is having more footfall of customers
-- which product is sold more
-- from which state I am getting more business (sale price)/revenue
-- which month is having the highest revenue
-- 
