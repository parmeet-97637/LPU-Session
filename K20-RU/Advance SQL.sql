use test;

select * from employee;
set sql_safe_updates=0;
delete from employee where name ='Trishaan';
select * from employee;

-- find the avg salary of employee within each department
select name, age, department, salary, avg(salary) OVER(partition by department) as avg_salary from employee;

-- Ranking function
insert into employee VALUES('Parmeet',23,'Finance',15000),('Trishaan',21,'Finance',15000),('Mansi',21,'Finance',14500);

select * from employee;

-- find the rank of employees within each department on basis of salary
select name,age,department,salary, rank() OVER(partition by department order by salary desc) as `rank` from employee;

-- dense rank 
select name,age,department,salary, 
rank() OVER(partition by department order by salary desc) as `rank`, 
dense_rank() OVER(partition by department order by salary desc) as `dense_rank` 
from employee;

-- dense rank 
select name,age,department,salary, 
rank() OVER(partition by department order by salary asc) as `rank`, 
dense_rank() OVER(partition by department order by salary asc) as `dense_rank` 
from employee;

-- percent_rank

select name,age,department,salary, 
rank() OVER(partition by department order by salary desc) as `rank`, 
dense_rank() OVER(partition by department order by salary desc) as `dense_rank`,
percent_rank() OVER(partition by department order by salary desc) as `percent_rank` 
from employee;

-- find the row number for each rows in the table
-- row number without partition

select name,age,department,salary, 
rank() OVER(partition by department order by salary desc) as `rank`, 
dense_rank() OVER(partition by department order by salary desc) as `dense_rank`,
percent_rank() OVER(partition by department order by salary desc) as `percent_rank`,
row_number() OVER() as `row_number`
from employee;

-- row number withing each department (row number with partition)
select name,age,department,salary, 
rank() OVER(partition by department order by salary desc) as `rank`, 
dense_rank() OVER(partition by department order by salary desc) as `dense_rank`,
percent_rank() OVER(partition by department order by salary desc) as `percent_rank`,
row_number() OVER() as `row_number_without_parition`,
row_number() OVER(partition by department) as `row_number_with_parition`
from employee;

-- using sales table for lead and lag
select * from sales;

select month,sales_value, lag(sales_value) OVER() as 'previous_month_sale' from sales;

select month,sales_value, lag(sales_value) OVER() as 'previous_month_sale_lag1',
lag(sales_value,2) OVER() as 'previous_month_sale_lag2'
 from sales;
 
 select month,sales_value, lag(sales_value) OVER() as 'previous_month_sale_lag1',
lag(sales_value,2) OVER() as 'previous_month_sale_lag2',
lag(sales_value,3,0) OVER() as 'previous_month_sale_lag3'
 from sales;
 
 -- lead function
 select month,sales_value, lead(sales_value) OVER() as next_month from sales;
 
 select month,sales_value, lead(sales_value) OVER() as next_month_lead1,
 lead(sales_value,2) OVER() as next_month_lead2 from sales;
 
  select month,sales_value, lead(sales_value) OVER() as next_month_lead1,
 lead(sales_value,2) OVER() as next_month_lead2,
 lead(sales_value,3,0) OVER() as next_month_lead3 from sales;
 
 
 select name,age,department,salary, 
 min(salary) OVER(partition by department) as min_salary,
 max(salary) OVER(partition by department) as max_salary,
rank() OVER(partition by department order by salary desc) as `rank`, 
dense_rank() OVER(partition by department order by salary desc) as `dense_rank`,
percent_rank() OVER(partition by department order by salary desc) as `percent_rank`,
row_number() OVER() as `row_number_without_parition`,
row_number() OVER(partition by department) as `row_number_with_parition`
from employee;

-- Case condition/statements
use DMART;

select * from customer_info;

select c.*,
(case c.gender 
when 'M' Then 'Male'
when 'F' Then 'Female'
else 'Other'
end) as sex
from customer_info c;

use test;
select * from employee;

select e.*, 
(case e.Department
when 'Finance' Then 'F'
when 'Sales' Then 'S'
end) as short_dept
from employee e;

-- Yearly hike : Finance: 10% and Sales 5%
select e.*,
( case e. Department
when 'Finance' Then Salary+Salary*.10
when 'Sales' Then Salary +Salary*.05
end) as new_salary
from employee e;

-- conditional update

use DMART;
update customer_info set gender =
(case gender
when 'M' Then '1'
when 'F' Then '0'
else '2'
end);

select * from customer_info;

-- CTE's: common table expressions 
-- Temporary table

use test;
select * from sales;

-- Below statement would give error as we are peforming run time calculation on the run time created columns
select month,sales_value, 
lag(sales_value) OVER() as 'previous_month_sale',
((sales_value-previous_month_sale)/sales_value *100) as percentage
from sales;

-- To solve the above problem we need CTE's
-- WITH table_name AS (query) 
-- (query)

select month,sales_value, 
lag(sales_value) OVER() as 'previous_month_sale'
from sales;

WITH prev_sales 
AS
(select month,sales_value, 
lag(sales_value) OVER() as 'previous_month_sale'
from sales)
select p.*, ((p.sales_value-p.previous_month_sale)/p.sales_value *100) as percentage from prev_sales p;


-- Functions
-- python : def function_name(paramater):
--               logic

-- DELIMITER $$
-- CREATE FUNCTION function_name(parameters) returns datatype
-- BEGIN
-- logic 
-- END 
-- DELIMITER ;

DELIMITER $$
CREATE FUNCTION Func_calculate_Age(Age date) returns int deterministic
BEGIN
	DECLARE TodayDate date;
    select current_date() into TodayDate;
    return Year(TodayDate) - year(Age);
END$$

DELIMITER ;

create table employee1 (
employeeId int primary key,
name varchar(50),
salary int,
DOb date
);

insert into employee1 VALUES(1,'Parmeet',50000,'1988-02-29'),(2,'Trsihaan',57000,'2019-01-01'),(3,'Shikha',45000,'2014-05-08');

select * from employee1;

select e1.*,func_calculate_Age(e1.DOB) as Age from employee1 e1;

create table employee_demo (
Name varchar(30),
Age int,
dept varchar(40),
salary decimal(10,2)
);

insert into employee_demo
select * from employee;

select * from employee_demo;


-- Pivots, store_procedures, cursors, frames, indexes 