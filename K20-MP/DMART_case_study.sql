# Steps
-- 1. Implementation Step

create schema DMART;

-- using schema
use DMART;

-- creating the customer information dimension table
create table customer_info(
customer_id varchar(12) not null,
first_name varchar(20) not null,
last_Name varchar(20) default null,
gender char(1) not null,
email varchar(50) default null,
primary key (customer_id),
UNIQUE (email)
);

-- create brach_details dimension table
create table branch_details(
store_id varchar(12) not null,
store_name varchar(30),
area varchar(30),
city varchar(30),
state varchar(30),
primary key (store_id)
);

-- creating order_product mapping information dimension table
create table order_product_mapping(
order_id varchar(12) not null,
product_id varchar(12) not null,
quantity_ordered int8,
primary key(order_id, product_id),
CHECK (quantity_ordered>0)
);

-- creating product_information dimension table
create table product_info (
product_id varchar(12) not null,
product_name varchar(50) not null,
product_category varchar(50),
list_price decimal(8,2) not null,
sale_price decimal(8,2) not null,
primary key(product_id),
CHECK(list_price>0),
CHECK(sale_price>0)
);

-- create sales_fact fact table
create table sales_fact (
order_id varchar(12) not null,
customer_id varchar(12) not null,
order_date date not null,
store_id varchar(12) not null,
primary key(order_id),
constraint customer_id foreign key (customer_id) references customer_info(customer_id),
constraint store_id foreign key(store_id) references branch_details(store_id)
);

# Step-3 : Manipulation
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

## Step-4 : DMART wants to understand the consumer patterns

-- 1. How many consumers are registered with DMART
select count(customer_id) as total_consumers from customer_info;

-- 2. How many stores DMART has.?
select count(store_id) total_stores from branch_details;

-- 3. Find the footall of male and female consumers
select gender, count(customer_id) 'total_count' from customer_info group by gender; 

-- 4. find the store which has more number of conusmers
select s.store_id,count(c.customer_id) 'total_consumers' from customer_info c 
inner join sales_fact s 
on c.customer_id = s.customer_id group by s.store_id order by total_consumers desc;

-- 5. How many products the company is running
select count(product_id) total_products from product_info;

-- 6. what is my yearly profit 
select (sum(sale_price)-sum(list_price)) profit from product_info;

-- 7. DMART want to find how many stores are there in each state
select state, count(store_id) total_stores from branch_details group by state;

-- 8. Which customer is purchasing more products
select c.customer_id,count(o.product_id) 'total_products' from customer_info c 
inner join sales_fact s
inner join order_product_mapping o
on c.customer_id = s.customer_id and s.order_id = o.order_id group by c.customer_id order by total_products desc;

-- 9.Which product is consumed more by customers
select o.product_id,count(c.customer_id) 'total_consumers' from customer_info c 
inner join sales_fact s
inner join order_product_mapping o
on c.customer_id = s.customer_id and s.order_id = o.order_id group by o.product_id order by total_consumers desc;

-- 10. which store is more profitable
select b.store_id, (sum(sale_price)-sum(list_price)) profit from branch_details b
inner join sales_fact s 
inner join order_product_mapping o
inner join product_info p
on b.store_id = s.store_id and
s.order_id = o.order_id and 
o.product_id = p.product_id
group by store_id order by profit desc;

-- 11. which store is more profitable and whether it is becaus of males or females
select b.store_id, c.gender,(sum(sale_price)-sum(list_price)) profit from branch_details b
inner join sales_fact s 
inner join order_product_mapping o
inner join product_info p
inner join customer_info c
on b.store_id = s.store_id and
s.order_id = o.order_id and 
o.product_id = p.product_id and
s.customer_id = c.customer_id
group by b.store_id,c.gender order by b.store_id, profit desc;

-- 12. which product is ordered more
select p.product_name,sum(o.quantity_ordered) total_qty from order_product_mapping o
inner join product_info p 
on o.product_id = p.product_id
group by p.product_name order by total_qty desc;

-- 13. which product is more profitable
select p.product_name,sum(o.quantity_ordered) total_qty, (sum(sale_price)-sum(list_price)) profit  from order_product_mapping o
inner join product_info p 
on o.product_id = p.product_id
group by p.product_name order by total_qty desc;

-- 14. which state is more profitable
create view profitable_view as
select b.state,b.city,p.product_name, (sum(p.sale_price)-sum(p.list_price)) profit from branch_details b 
inner join sales_fact s
inner join order_product_mapping o
inner join product_info p 
on b.store_id = s.store_id and
s.order_id = o.order_id and 
o.product_id = p.product_id
group by b.state,b.city,p.product_name order by profit desc;

-- check
select * from profitable_view;


-- on which day customer consumer foot fall was more
select dayname(order_date) day_name, count(c.customer_id) total_count from customer_info c 
inner join sales_fact s 
on c.customer_id=s.customer_id 
group by day_name order by total_count desc; 

-- on which day more number of orders were consumed
select dayname(order_date) day_name, count(s.order_id) total_count from customer_info c 
inner join sales_fact s 
on c.customer_id=s.customer_id 
group by day_name order by total_count desc; 

-- which month is more profitable
select monthname(s.order_date) month_name,(sum(sale_price)-sum(list_price)) profit  from sales_fact s 
inner join order_product_mapping o 
inner join product_info p 
on s.order_id = o.order_id and
o.product_id = p.product_id 
group by month_name order by profit desc;
 
# -------------------------
-- working with dates
select * from sales_fact where order_date ='2020-01-15';

select order_date,month(order_date),year(order_date),day(order_date),dayname(order_date),dayofyear(order_date),
monthname(order_date),week(order_date),weekday(order_date) from sales_fact;

-- adding 10 days
select date_add('2020-01-15', INTERVAL 10 DAY);

-- adding minutes
select date_add('2020-01-15 09:30:21', INTERVAL 15 MINUTE);

-- subract hours
select date_add('2020-01-15 09:30:21', INTERVAL -3 HOUR);