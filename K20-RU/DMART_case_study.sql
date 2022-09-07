# DDL Statements : CREATE, ALTER, DROP
# DML Statement : Select, Insert, Update, Delete

# Creating the DMART Models and identifying the consumer patterns
# 1. Implement the Desgin
# 2. Manipulation
# 3. Analysis - Finding patterns

-- creating the schema
create schema DMART;

-- use schema
use DMART;

-- creating the dimensional table customer_info
create table customer_info (
customer_id varchar(12) not null,
first_name varchar(20) not null,
last_name varchar(20),
gender char(1) not null,
email varchar(50) not null,
primary key(customer_id),
UNIQUE(email)
);

-- create the dimensional table branch_details
create table branch_details (
store_id varchar(12) not null,
store_name varchar(30) not null,
area varchar(30) not null,
city varchar(20) not null,
state varchar(25) not null,
primary key (store_id)
);

-- create the dimensional table order_product_mapping
create table order_product_mapping (
order_id varchar(12) not null,
product_id varchar(12) not null,
quantity_ordered int8 not null,
primary key(order_id, product_id),
CHECK(quantity_ordered >0)
);

-- create the dimensional table product_info
create table product_info(
product_id varchar(12) not null,
product_name varchar(30) not null,
product_category varchar(30) not null,
list_price decimal(12,2) not null,
sale_price decimal(12,2),
primary key (product_id),
CHECK(list_price>0),
CHECK(sale_price>0)
);

-- creating the fact table sales_fact
create table sales_fact (
order_id varchar(12) not null,
customer_id varchar(12) not null,
order_date date not null,
store_id varchar(12) not null,
primary key (order_id),
constraint fk_customer_id foreign key(customer_id) references customer_info(customer_id),
constraint fk_store_id foreign key(store_id) references branch_details(store_id)
);

-- query/select the table
select * from customer_info; 

# 2. Manipulation
insert into customer_info (customer_id,first_name, last_name, gender, email) 
VALUES ('C1','Parmeet','Singh','M','p@gmail.com');

-- check
select * from customer_info;

-- Another way of inserting records
insert into customer_info (last_name, customer_id, email,first_name,gender) 
VALUES ('Gupta','C2','sg@gmail.com','Shikha','F');

-- check 
select * from customer_info;

-- Third way
insert into customer_info 
VALUES ('C3','Mahendra','Reddy','M','mr@gmail.com');

-- check
select * from customer_info;

-- inserting mutiple values at the same time
insert into customer_info
VALUES('C4','Sai','Bargav','M','sb@gmail.com'),('C5','Chanda','Harshita','F','ch@gmail.com');

-- check
select * from customer_info;

-- delete all the rows or clear the table
SET SQL_SAFE_UPDATES=0;
delete from customer_info;
SET SQL_SAFE_UPDATES=1;

-- check
select * from customer_info;

-- Drop table sales_fact
drop table sales_fact;

-- creating the fact table sales_fact and mising one column intentionally and missing one constraint intentionally 
create table sales_fact (
order_id varchar(12) not null,
customer_id varchar(12) not null,
store_id varchar(12) not null,
constraint fk_customer_id foreign key(customer_id) references customer_info(customer_id),
constraint fk_store_id foreign key(store_id) references branch_details(store_id)
);

-- Adding the column in above table "order_date"
alter table sales_fact
add column order_date date not null;

-- Adding Primary key constraint to the sales_fact table
alter table sales_fact
add constraint 
primary key (order_id);

-- modify the columns list_price and sale_price in product_info table
alter table product_info
modify column sale_price decimal(10,2);

alter table product_info
modify column list_price decimal(10,2);

# Step-2 : Manipulation
-- inserting the records in customer information table
-- insert records in customer_info
insert into customer_info VALUES ('C1','Parmeet','Singh','M','p@gmail.com'),
('C2','Pavan','Kumar','M','pa@gmail.com'),('C3','Shikha','Gupta','F','s@gmail.com'),('C4','Madhu','Mogulla','M','m@gmail.com'),
('C5','Mansi','Singh','F','ma@gmail.com'),('C6','Mukesh','Sure','M','mu@gmail.com'),('C7','Aniket','Singh','M','a@gmail.com'),
('C8','Chanda','Agrawal','F','c@gmail.com'),('C9','Shruti','Yadav','F','sh@gmail.com'),('C10','Trsihaan','Singh','M','t@gmail.com');

-- check
select * from customer_info;

-- insert the records into branch_details

insert into branch_details VALUES ('S1','DMART-I1','Indore-1','Indore','MP'),('S2','DMART-I2','Indore-2','Indore','MP'),('S3','DMART-I3','Indore-3','Indore','MP'),
('S4','DMART-B1','Bhopal-1','Bhopal','MP'),('S5','DMART-B2','Bhopal-2','Bhopal','MP'),('S6','DMART-B3','Bhopal-3','Bhopal','MP'),('S7','DMART-B4','Bhopal-4','Bhopal','MP'),
('S8','DMART-P1','Pune-1','Pune','MH'),('S9','DMART-P2','Pune-2','Pune','MH'),('S10','DMART-P3','Pune-3','Pune','MH'),('S11','DMART-P4','Pune-4','Pune','MH'),
('S12','DMART-M1','Mumbai-1','Mumbai','MH'),('S13','DMART-M2','Mumbai-2','Mumbai','MH'),('S14','DMART-M3','Mumbai-3','Mumbai','MH'),('S15','DMART-M4','Mumbai-4','Mumbai','MH');

-- check
select * from branch_details;

-- insert the records into order_product_mapping
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

-- check 
select * from order_product_mapping;

-- insert the records into sales_fact
insert into sales_fact(order_id,customer_id,order_date,store_id) VALUES ('O1','C1','2020-01-15','S1'),('O2','C1','2020-01-16','S2'),('O3','C1','2020-02-15','S3'),('O4','C1','2020-02-28','S1'),
('O5','C2','2020-11-16','S5'),('O6','C2','2020-05-6','S3'),('O7','C2','2020-01-28','S4'),('O8','C2','2020-10-16','S4'),('O9','C2','2020-04-30','S4'),('O10','C2','2020-06-28','S3'),
('O11','C3','2020-11-16','S9'),('O12','C3','2020-05-6','S10'),('O13','C3','2020-01-28','S11'),('O14','C3','2020-10-16','S10'),('O15','C3','2020-04-30','S10'),('O16','C3','2020-06-28','S11'),
('O17','C4','2020-11-16','S4'),('O18','C4','2020-05-6','S14'),('O19','C4','2020-01-28','S12'),('O20','C4','2020-10-16','S10'),('O28','C4','2020-04-30','S13'),('O21','C3','2020-06-28','S9'),
('O22','C5','2020-11-16','S5'),('O23','C5','2020-05-6','S3'),('O24','C5','2020-01-28','S4'),('O25','C5','2020-10-16','S4'),('O26','C5','2020-04-30','S4'),('O27','C5','2020-06-28','S3');

-- check
select * from sales_fact;

-- insert into product information table
insert into product_info VALUES ('P1','Laptops','Gadgets',50500,80000),('P2','Wheat','Grains',100,120),
('P3','Train','Toys',1000,2000),('P4','Bed','Furniture',38000,60000);

-- check
select * from product_info;

# Analysis
-- find the total consumers in DMART
select count(customer_id) total_consumers from customer_info;

-- find the number of stores in each state
select state, count(store_id) as total_stores from branch_details group by state;

-- find the premium customers who are ordering more
select customer_id, count(order_id) as total_orders from sales_fact group by customer_id order by total_orders desc;

-- which store has more number of footfall
select store_id,count(customer_id) as total_customers from sales_fact group by store_id order by total_customers desc;

-- refining above query ( we need city and store name)
select b.store_id,b.store_name,city,state,count(s.customer_id) total_customers from branch_details b 
inner join sales_fact s 
on b.store_id = s.store_id 
group by b.store_id
order by total_customers desc;

-- DMART wants to run a campaign and they want to find out most preferable day
-- They will check on which day we have more number of customers coming in
select order_date,day(order_date), dayname(order_date),month(order_date), monthname(order_date), week(order_date) from sales_fact;

select monthname(order_date) as month_name, count(customer_id) customer_footfall from sales_fact 
group by month_name
order by customer_footfall desc;

select monthname(order_date) as month_name, week(order_date) as `week of year`, count(customer_id) customer_footfall from sales_fact 
group by month_name, `week of year`
order by customer_footfall desc, `week of year` asc;

-- DMART want to undertsand the consumer pattern on the basis of gender
select gender, count(customer_id) as total_consumers from customer_info group by gender order by total_consumers desc;

select b.state, c.gender, count(c.customer_id) as total_consumers from customer_info c 
inner join sales_fact s 
inner join branch_details b 
on c.customer_id = s.customer_id and
s.store_id = b.store_id
group by state, gender
order by state, total_consumers desc;

-- which is the most preferable product
select product_id, sum(quantity_ordered) most_ordered_product from order_product_mapping group by product_id
order by most_ordered_product desc;

-- fetch the name of the product in above query
select o.product_id, p.product_name, sum(quantity_ordered) most_ordered_product from order_product_mapping o
inner join product_info p 
on o.product_id = p.product_id 
group by product_id
order by most_ordered_product desc;

-- find the most profitable product
select p.*, (sale_price-list_price) profit from product_info p order by profit desc;

-- find the most profitable product on basis of orders
select o.*,p.*,(sale_price-list_price) profit from order_product_mapping o 
inner join product_info  p
on o.product_id = p.product_id;

-- refine above query 
select p.product_name, sum(sale_price-list_price) profit from order_product_mapping o 
inner join product_info  p
on o.product_id = p.product_id group by p.product_name order by profit desc;

-- margin ratio
select p.*, (sale_price-list_price)/list_price*100 margin_ratio from product_info p;

-- refine above query 
select p.product_name, sum(sale_price-list_price) profit, sum(sale_price-list_price)/sum(list_price)*100 margin_ratio from order_product_mapping o 
inner join product_info  p
on o.product_id = p.product_id group by p.product_name order by profit desc;

-- Let us find month on month revenue
select monthname(order_date) `month_name`, sum(sale_price) revenue from sales_fact s 
inner join order_product_mapping  o
inner join product_info p
on s.order_id = o.order_id and 
o.product_id = p.product_id 
group by `month_name` order by month(order_date);

-- find weekly revenue
select week(order_date) `week_no`, sum(sale_price) revenue from sales_fact s 
inner join order_product_mapping  o
inner join product_info p
on s.order_id = o.order_id and 
o.product_id = p.product_id 
group by `week_no` order by week(order_date);

-- combining month and week revenue
select monthname(order_date) `month_name`,week(order_date) `week_no`, sum(sale_price) revenue from sales_fact s 
inner join order_product_mapping  o
inner join product_info p
on s.order_id = o.order_id and 
o.product_id = p.product_id 
group by `month_name`,`week_no` order by month(order_date), week(order_date);

-- Add the dates
select order_date, date_add(order_date,INTERVAL 5 day) as invoice_date from sales_fact;

-- subtract the dates
select date_sub(order_date, INTERVAL 5 day) as shipping_date, order_date from sales_fact;

-- IF condition in mysql
select order_date,
date_add( 
order_date, 
INTERVAL 5 + 
if ((week(order_date) <> week(date_add(order_date, INTERVAL 5 day)))
or
(weekday(date_add(order_date, interval 5 day)) IN (5,6)),
2,
0
) Day
) as finalDate from sales_fact;

-- let us find the top 3 customers on basis of orders places
select customer_id, count(order_id) total_orders from sales_fact group by customer_id order by total_orders desc limit 3;

-- find the top customer on basis of orders
select customer_id, count(order_id) total_orders from sales_fact group by customer_id order by total_orders desc limit 1;

-- find the second highest customer
select customer_id, count(order_id) total_orders from sales_fact group by customer_id order by total_orders desc limit 1,1;

-- find the second highest and third highest customer
select customer_id, count(order_id) total_orders from sales_fact group by customer_id order by total_orders desc limit 1,2;

-- find the third highest customer
select customer_id, count(order_id) total_orders from sales_fact group by customer_id order by total_orders desc limit 2,1;

-- find the third highest and forth customer
select customer_id, count(order_id) total_orders from sales_fact group by customer_id order by total_orders desc limit 2,2;
