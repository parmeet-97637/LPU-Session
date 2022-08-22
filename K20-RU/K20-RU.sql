-- selecting all the columns
select * from cust_dimen;

-- select only few columns or filter columns
select cust_id, customer_name,customer_segment from cust_dimen;

-- select distinct city from cust_dimen
select distinct city from cust_dimen;

-- filter the rows (select customers who are into small business)
-- we will use "WHERE" clause to filter the rows
select * from cust_dimen where Customer_segment ="SMALL BUSINESS";

-- apply mutliple filters : using "AND" operator
-- select customers who has small business and who belongs to Mysore
-- for AND operator : BOTH THE CONDITIONS SHOULD BE TRUE
select * from cust_dimen where customer_segment ="SMALL BUSINESS" and City ="Mysore";

-- apply multiple filters :"OR" Operator
-- select customers who has small business or who resides in Karnataka
-- Now the output will be based on either customer belongs to Karnataka or he/she has small business
-- For or operator : either of the condition will be true
select * from cust_dimen where Customer_segment ="SMALL BUSINESS" or State ="Karanataka";

-- we can also select multiple values in one go
-- select customers who belongs to westbengal, karnataka and maharashtra
-- using "IN"operator
select * from cust_dimen where State in ('WEST Bengal','Karnataka','Maharashtra');

-- "between operator"
-- select the customer_id whose order shipping cost is between 5 and 10 (both inclusive)
select * from market_fact_full where shipping_cost between 5 and 10;

-- select the customers whose order_id ends with "_5"
-- "LIKE" operator
-- % means any number of characters
-- _ means any single character
-- \ means escape character
select * from market_fact_full where ord_id LIKE '%\_5';
-- without escape character
select * from market_fact_full where ord_id LIKE '%_5';

-- select customer names starting with CLA
select * from cust_dimen where customer_name like 'CLA%';

-- select the customer names which contains 'IRE'
select * from cust_dimen where customer_name like '%IRE%';

-- Aggregate Functions in SQL 
-- they would return the single value
-- sum
-- count
-- avg
-- min
-- max

-- select maximum sales value from market_fact_full table
select max(sales) from market_fact_full;

-- select the minimum sales
select min(sales) from market_fact_full;

-- find the average sales
select avg(sales) from market_fact_full;

-- count the number of customers in cust_dimen table
select count(cust_id) from cust_dimen;

-- count the number of unique customer
select count(distinct cust_id) from cust_dimen;

-- let us sort the rows on basis of sales values in descending order
select * from market_fact_full order by sales desc;

-- sort the table on basis of discount in ascending order
select * from market_fact_full order by Discount asc;

-- group by
-- count the number of customers from each state
-- order : select, from, where, group by
select state, count(cust_id) from cust_dimen group by state;

-- count the number of customers from Delhi, Bihar, maharashtra and Karnataka
select state, count(cust_id) from cust_dimen where state in ('Delhi','Bihar','Maharashtra','Karnataka') group by State;


-- find the states which have more than 200 customers
-- filter on aggregate functions then use having clause
select state, count(cust_id) from cust_dimen group by state having count(cust_id)>200;

-- count the number of customers from Delhi, Bihar, maharashtra and Karnataka  and the count should be greater than 200
select state, count(cust_id) from cust_dimen where state in ('Delhi','Bihar','Maharashtra','Karnataka') group by State having count(cust_id)>200;


-- Views
-- 1. Views are the virtual table that can be created from single or multiple tables
-- 2. Views are readable only
-- 3. Advantage is : Data Security

-- create view
create view cust_dimen_view
as
select * from cust_dimen where state in ('Delhi','Bihar','Maharashtra','Karnataka');

-- check
select * from cust_dimen_view;

-- delete the view
drop view cust_dimen_view;

-- Joins
-- Inner Join
-- Right Join
-- Left Join
-- Full Outer Join / Outer Join
-- Cross Join

-- inner join cust_dimen with market_fact_full
select * from cust_dimen c inner join market_fact_full m on c.Cust_id = m.Cust_id;
-- filtering the columns on joins
select c.Cust_id,c.City,c.Customer_segment,m.ord_id,m.prod_id,m.Profit,m.Shipping_cost from cust_dimen c inner join market_fact_full m on c.Cust_id = m.Cust_id;

-- find the profit and shipping_cost of customers on the basis of order_id
select c.Cust_id,m.ord_id,sum(m.Profit) total_profit,sum(m.Shipping_cost) total_shipping_cost 
from cust_dimen c inner join market_fact_full m 
on c.Cust_id = m.Cust_id
group by m.ord_id;

-- create table
create table employee (
ID integer not null,
Name varchar(20) default null,
Age int2 default null,
Gender char(1) not null,
salary decimal(12,2) default null,
check(salary>0),
primary key(ID)
);

-- insert the records
insert into employee values(1,'Parmeet',27,'M',1234567),(2,'Shivashish',NULL,'M',546778),(3,'Shikha',21,'F',987678);
-- check
select * from employee;

-- create another table
create table personal_details(
sno integer not null,
city varchar(20) not null,
bank_balance decimal(12,2) not null,
address_type varchar(20) not null,
constraint sno foreign key(sno) references employee(ID)
);

-- inserting records
insert into personal_details VALUES(1,'Indore',1200,'Permanent'),(1,'Pune',3200,'Current'),(2,'Mumbai',3000,'Permanent');

# Remove the contraint
drop table personal_details;
create table personal_details(
sno integer not null,
city varchar(20) not null,
bank_balance decimal(12,2) not null,
address_type varchar(20) not null
);
insert into personal_details VALUES(1,'Indore',1200,'Permanent'),(1,'Pune',3200,'Current'),(2,'Mumbai',3000,'Permanent'),
(5,'Indore',1200,'Current');

-- check 
select * from personal_details;

-- inner join
select * from employee e inner join personal_details p on e.ID =p.sno;

-- right join
select * from employee e right join personal_details p on e.ID = p.sno;

-- left join
select * from employee e left join personal_details p on e.Id=p.Sno;

-- union 
-- create table
create table details (
Sno integer not null,
city varchar(20),
bank_balance decimal(12,2),
address_type varchar(20)
);

-- inserting record
insert into details VALUES(3,'delhi',15000,'Permanent'),(1,'Indore',1200,'Permanent');

-- check 
select * from personal_details;
select * from details;

-- union of above two table
-- 1. The table structure should be same
-- 2. Exclude the duplicate the records
select * from personal_details
union
select * from details;

-- union all
-- 1. It will include duplicate records
select * from personal_details
union all
select * from details;

-- outer join
-- it is combination of right join and left join
select * from employee e right join personal_details p on e.id =p.sno
union
select * from employee e left join personal_details p on e.id=p.sno;

-- change the data type of  age from smallint to int in employees table
alter table employee
modify column Age integer;

-- add a new column "email_id" to personal_detail
alter table personal_details
add column email_id varchar(50);

-- check
select * from personal_details;

-- filter the table based on null and not null values
select * from employee where age is not null;

select * from employee where age is null;

-- update the records
-- syantax : update table_name set column_name = value where condition
-- update the missing age to 21 in employee table
select * from employee where age is null;

# turn on sqlsafe updates
SET SQL_SAFE_UPDATES =0;

# update command
update employee set age=21 where age is null;

#check
select * from employee where age is null;
select * from employee where age=21;

# turn off
SET SQL_SAFE_UPDATES =1;


# update email id in personal_details
select * from personal_details where sno=1 and email_id is null;

# turn on safe update mode
SET SQL_SAFE_UPDATES=0;

# update
update personal_details set email_id ='p@gmail.com' where sno=1 and email_id is null;

# check
select * from personal_details where sno=1 and email_id is null;
select * from personal_details where sno=1 and email_id ='p@gmail.com';

# subqueries or nested queries
-- select employees where salary is less than bank balance
select * from employee where salary<(select sum(bank_balance)*100 from personal_details);

-- round function
select round(1234.56789,2);

## EXISTS operator
-- It is used for checking existence of the record in a sub query
-- It will return true when subquery returns one or more records


select sum(bank_balance)*100 from personal_details where sno=10;

select ID from employee where exists (select sno from personal_details where sno=10);

select ID from employee where exists (select sno from personal_details where sno=1) and id=1;
