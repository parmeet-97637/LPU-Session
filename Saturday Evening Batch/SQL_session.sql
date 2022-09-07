# 1. DDL Statements
-- Create, Alter and Drop

 # 2. DML Statements
 -- Select, Inser, Update and Delete
 
 # Problem Statement : DMART want to create the Data Models and want to undertand the consumer patterns
 # 1. Desgin : ERD
 # 2. Implement : We create the schemas
 # 3. Manipulation : We insert the records
 # 4. Analysis : Identify the consumer patterns.
 
 -- Create the schema
 create schema DMART;
 
 -- use the schema
 use dmart;
 
 -- Create the dimensional table customer_info
 create table customer_info (
 customer_id varchar(12) not null,
 first_name varchar(20) not null,
 last_name varchar(20) default null,
 gender char(1) not null,
 email varchar(50),
 primary key (customer_id),
 UNIQUE(email)
 );
 
 -- Create the dimensional table branch_details
 create table branch_details (
 store_id varchar(12) not null,
 store_name varchar(25) not null,
 area varchar(30) not null,
 city varchar(30) not null,
 state varchar(30) not null,
 primary key (store_id)
 );
 
 -- create the dimensional table oder_product_mapping
 create table order_product_mapping (
 order_id varchar(12) not null,
 product_id varchar(12) not null,
 quantity_ordered int8 not null,
 primary key (order_id, product_id),
 CHECK (quantity_ordered>0)
 );
 
 -- create the dimensional table product_info
 create table product_info (
 product_id varchar(12) not null,
 product_name varchar(30) not null,
 product_category varchar(30) not null,
 list_price decimal(8,2) not null,
 sale_price decimal (10,2) not null,
 primary key (product_id),
 CHECK (list_price>0),
 CHECK (sale_price>0)
 );
 
 -- creating the fact table sales_fact
 create table sales_fact (
 order_id varchar(12) not null,
 customer_id varchar(12) not null,
 order_date date not null,
 store_id varchar(12) not null,
 constraint customer_id foreign key (customer_id) references customer_info(customer_id),
 constraint store_id foreign key (store_id) references branch_details(store_id)
 );
 
 -- In above table I forgot to make order_id as primary key, adding the constraint
 Alter table sales_fact
 add constraint
 primary key (order_id);
 
 -- Insert the records in customer table
 insert into customer_info (Customer_id, first_name, last_name, gender, email) VALUES ('C1','Parmeet','Singh','M','p@gmail.com');
 
 -- check
 select * from customer_info;
 
 insert into customer_info (first_name, last_name, customer_id,email,gender) VALUES ('Jatin','Kalra','C2','jk@gmail.com','M');
 
 -- check
 select * from customer_info;
 
 insert into customer_info VALUES('C3','Mansi','Singh','F','ms@gmail.com');
 
 -- check
 select * from customer_info;
 
 insert into customer_info VALUES ('C4','Aniket', 'Kumar','M','ak@gmail.com'),('C5','Shikha','Sharma','F','ss@gmail.com');
 
 -- check 
 select * from customer_info;
 
 -- inserting the records in customer information table
-- insert records in customer_info
insert into customer_info VALUES 
('C13','Pavan','Kumar','M','pa@gmail.com'),('C12','Shikha','Gupta','F','s@gmail.com'),('C11','Madhu','Mogulla','M','m@gmail.com'),
('C6','Mukesh','Sure','M','mu@gmail.com'),('C7','Aniket','Singh','M','a@gmail.com'),
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

## Analsyis
-- DMART want to analyse the consumer behavior
-- 1. Fetch the list of male consumers
-- applying filters on the table : where and followed by condition
select * from customer_info where gender='M';
-- 2. How many stores DMART have in MP and only in Indore
-- fetch the list of stores which are in Indore and state is MP
-- applying the filters on two columns ( combining the condition : using and operator)
select * from branch_details where state='MP' and city='Indore';
 
 -- 3. How many orders were placed in month of January
 select month(order_date) as `month`,monthname(order_date) as `month_name`,order_date from sales_fact;

 select month(order_date) as `month`,monthname(order_date) as `month_name`,order_date from sales_fact
 where month(order_date)=1;
 
 -- select all the cols
 select * from sales_fact where month(order_date)=1;
 
 -- Fetch the orders placed by customers
 select * from customer_info as c 
 inner join sales_fact s
 on c.customer_id = s.customer_id;
 
 -- selcting columns 
 -- inner join is selecting all the matching records from both the tables
 select c.customer_id, c.first_name, c.gender,s.order_id, s.order_date from customer_info as c 
 inner join sales_fact s
 on c.customer_id = s.customer_id;
 
 -- Left join Demo 
  -- selecting all the columns from the left table irrespective of the matching keys in the right table
 select c.customer_id, c.first_name, c.gender,s.order_id, s.order_date from customer_info as c 
 left join sales_fact s
 on c.customer_id = s.customer_id;
 
 -- Right join Demo 
  -- selecting all the records from the right table irrespective of the matching keys in the left table
 select c.customer_id, c.first_name, c.gender,s.order_id, s.order_date from customer_info as c 
 right join sales_fact s
 on c.customer_id = s.customer_id;
 
 -- Recap 
 -- select : used to fetch the table
 -- * : used to select all columns
 -- from : keyword
 -- table_name 
 -- where clause : apply filtering on th rows/records
 
-- sorting 
 select * from sales_fact order by customer_id asc;
 
 select * from sales_fact order by order_id desc;
 
 # IN SQL default sorting is ascending
 select * from sales_fact order by store_id;
 
 -- Order of writing query
 -- select, from, where, order by
 
 -- Aggregtion in SQL
 -- aggregation function : max, min, count, avg 
 -- They will return the single value
 
 -- count the number of consumers that DMART own 
 select count(customer_id) 'total_consumers' from customer_info;
 
 -- Demonstrate the total value of the products : total list price
 select sum(list_price) from product_info;
 
 -- product which has maximum sale price
 select max(sale_price) from product_info;
 
 -- prodcut which has minimum list_price
 select min(list_price) from product_info;
 
 -- Grouping : group by clause
 -- Find the male and the female customers
 select gender, count(customer_id) total_count from customer_info group by gender;
 
 -- find the premium customers who has placed more orders
 select customer_id, count(order_id) total_orders from sales_fact group by customer_id order by total_orders desc;
 
 -- Find the top 3 customers who has placed more orders
 select customer_id, count(order_id) total_orders from sales_fact group by customer_id order by total_orders desc limit 3;
 
 -- find the customer who has placed most orders
 select customer_id, count(order_id) total_orders from sales_fact group by customer_id order by total_orders desc limit 1;
 
 -- find the second highest customer on basis of order
 select customer_id, count(order_id) total_orders from sales_fact group by customer_id order by total_orders desc limit 1,1;
 
 -- find the second highest and third highest customer on basis of order
 select customer_id, count(order_id) total_orders from sales_fact group by customer_id order by total_orders desc limit 1,2;
 
 -- find the third highest customer on basis of order
 select customer_id, count(order_id) total_orders from sales_fact group by customer_id order by total_orders desc limit 2,1;

-- find the most ordered product
 select p.product_name, count(o.order_id) total_orders from order_product_mapping o 
 inner join product_info p 
 on o.product_id = p.product_id group by p.product_name;
 
 -- find the profit for each product
 select  p.*,(sale_price-list_price) profit from product_info p ;
 
 -- find the overall profit for products on basis of orders
 select o.*,p.*,(sale_price-list_price) profit from order_product_mapping o 
 inner join product_info p 
 on o.product_id = p.product_id;
 
 -- refining above query to get the proper output
 select p.product_name,count(order_id) total_orders,sum(p.sale_price-p.list_price) total_profit from order_product_mapping o 
 inner join product_info p 
 on o.product_id = p.product_id group by p.product_name order by total_profit Desc;
 
 -- margin ratio
 select  p.*, (sale_price-list_price)/list_price *100 margin_ratio from product_info p ;
 
 -- refining above query to add the margin ratio
 
 select p.product_name,count(order_id) total_orders,sum(p.sale_price-p.list_price) total_profit, 
 sum(p.sale_price-p.list_price)/sum(list_price)*100 margin_ratio from order_product_mapping o 
 inner join product_info p 
 on o.product_id = p.product_id group by p.product_name order by margin_ratio Desc;
 
 -- apply the filters on the aggregated functions :
 -- select only those customers who have ordered with DMART more than 5 times (total_order>5)
 -- whenever you need to apply filter on aggregated functions use having clause
 -- having clause is always used by group by fucntion
 select customer_id, count(order_id) total_orders from sales_fact
 group by customer_id having total_orders>5 order by total_orders desc;
 
 -- Recap the orders
 -- select
 -- column_name (*)
 -- from (keyword)
 -- table_name
 -- where clause followed by condition (non aggregated columns)
 -- group by 
 -- having (aggregated columns)
 -- order by