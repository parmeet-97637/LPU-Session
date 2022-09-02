## 1. Implement the Design for DMART and analyse the consumer patterns.

-- creating schema (DDL statement)
create schema DMART;

-- use scehma
use DMART;

-- create the dimension table customer information
create table customer_info (
customer_id varchar(12) not null,
first_name varchar(25) not null,
last_name varchar(25) default null,
gender char(1) not null,
email varchar(50),
primary key (customer_id),
UNIQUE (email)
);

-- create the dimension table branch_details
create table branch_details (
store_id varchar(12) not null,
store_name varchar(25) not null,
area varchar(25) not null,
city varchar(30) not null,
state varchar(30) not null,
primary key(store_id)
);

-- create the dimension table order_product_mapping
create table order_product_mapping(
order_id varchar(12) not null,
product_id varchar(12) not null,
quantity_ordered int8,
primary key (order_id,product_id),
CHECK(quantity_ordered>0)
);

-- create the dimension table product_info
create table product_info (
product_id varchar(12) not null,
product_name varchar(30) not null,
product_category varchar(30) not null,
list_price decimal(8,2),
sale_price decimal(8,2),
primary key(product_id),
CHECK(list_price>0),
CHECK(sale_price>0)
);

-- create the fact table sales_fact
create table sales_fact(
order_id varchar(12) not null,
customer_id varchar(12) not null,
order_date date not null,
store_id varchar(12) not null,
primary key(order_id),
constraint customer_id foreign key (customer_id) references customer_info(customer_id),
constraint store_id foreign key (store_id) references branch_details(store_id)
);

# Step2 : Manipulation (inserting the records)
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
insert into sales_fact VALUES ('O1','C1','2020-01-15','S1'),('O2','C1','2020-01-16','S2'),('O3','C1','2020-02-15','S3'),('O4','C1','2020-02-28','S1'),
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

# Analysis - Finding Insights from Dataset

# 1. Find the number of stores in each state
select state, count(store_id) as total_store from branch_details group by state order by total_store desc;

# 2. Customer footfall in each state
select state, count(c.customer_id) customer_footfall from customer_info c
inner join sales_fact s 
inner join branch_details b
on c.customer_id = s.customer_id and 
s.store_id = b.store_id
group by state order by customer_footfall desc;

# 2. Which store has more customer footfall
select store_name,city,state,count(c.customer_id) total_footfall from customer_info c
inner join sales_fact s
inner join branch_details b
on c.customer_id = s.customer_id and
s.store_id = b.store_id group by store_name order by total_footfall desc;

# which type of consumers are coming more to the store - female or males

select b.store_name,c.gender,count(c.customer_id) total_footfall from customer_info c
inner join sales_fact s
inner join branch_details b
on c.customer_id = s.customer_id and
s.store_id = b.store_id group by b.store_name,c.gender order by b.store_name;

# what is the most preferable product or bought prduct
select product_id, count(order_id) 'most preferable product' from order_product_mapping
group by product_id order by 'most preferable product' desc;

-- fetching the product name for most preferable product
select p.product_id,p.product_name, count(o.order_id) 'most preferable product' from order_product_mapping o 
inner join product_info p 
on o.product_id = p.product_id
group by p.product_id, p.product_name order by 'most preferable product' desc;

-- which product is more profitable
select product_name, (sum(sale_price)-sum(list_price)) profit from product_info
group by product_name order by profit desc;

-- number of order for each product and their total profit
create view most_profitable_product as 
select p.product_name, count(o.order_id) 'Total orders',(sum(sale_price)-sum(list_price)) profit 
from order_product_mapping o 
inner join product_info p 
on o.product_id = p.product_id
group by p.product_name order by profit desc;

-- checking views
SELECT * FROM dmart.most_profitable_product;

-- which store is more profitable
select s.store_id,(sum(sale_price)-sum(list_price)) profit from branch_details b 
inner join sales_fact s 
inner join order_product_mapping o 
inner join product_info p 
on b.store_id = s.store_id and
s.order_id = o.order_id and 
o.product_id = p.product_id 
group by store_id order by profit desc;

-- which day is most preferable
select dayname(order_date) day_name,count(order_id) total_orders from sales_fact
group by day_name order by total_orders desc, day_name;

-- which month is most preferable
select monthname(order_date) month_name,count(order_id) total_orders from sales_fact
group by month_name order by total_orders desc;

-- which month is most preferable
select week(order_date) `week`,count(order_id) total_orders from sales_fact
group by `week` order by  total_orders desc,`week` asc;

-- Which month is most profitable

select monthname(order_date) Month_name,sum((sale_price-list_price)) profit from sales_fact s 
inner join order_product_mapping o 
inner join product_info p 
on s.order_id = o.order_id and
o.product_id = p.product_id
group by Month_name order by profit desc;

-- Top 3 profitable months
select monthname(order_date) Month_name,sum((sale_price-list_price)) profit from sales_fact s 
inner join order_product_mapping o 
inner join product_info p 
on s.order_id = o.order_id and
o.product_id = p.product_id
group by Month_name order by profit desc limit 3;

-- Second highest profitable product
select product_name, sum(sale_price-list_price) profit from order_product_mapping o 
inner join product_info  p 
on o.product_id = p.product_id
group by product_name order by profit desc limit 1, 1;

-- top 3 consumers
select c.customer_id, sum(p.sale_price) revenue,sum(p.sale_price-p.list_price) profit from customer_info c 
inner join sales_fact s 
inner join order_product_mapping o 
inner join product_info p 
on c.customer_id = s.customer_id and
s.order_id = o.order_id and 
o.product_id = p.product_id
group by c.customer_id order by revenue desc limit 3;

-- top 3 consumers are male or females
select c.customer_id,c.gender, sum(p.sale_price) revenue,sum(p.sale_price-p.list_price) profit from customer_info c 
inner join sales_fact s 
inner join order_product_mapping o 
inner join product_info p 
on c.customer_id = s.customer_id and
s.order_id = o.order_id and 
o.product_id = p.product_id
group by c.customer_id order by revenue desc limit 3;

-- Most Marginable prduct
select product_name, round((sale_price-list_price)/list_price *100,2) Margin_Ratio from product_info
order by Margin_ratio desc;

-- Total revenue generated month by month
select monthname(s.order_date)month_name ,sum(sale_price) as revenue from sales_fact s 
inner join order_product_mapping o 
inner join product_info p 
on s.order_id = o.order_id and 
o.product_id = p.product_id group by month_name order by month(s.order_date) asc;

-- which product is ordered more
select p.product_name,sum(o.quantity_ordered) total_quantity from order_product_mapping o 
inner join product_info p 
on o.product_id = p.product_id group by p.product_name order by total_quantity desc;

