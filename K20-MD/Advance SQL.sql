create schema test;

use test;

create table employee (
Name varchar(20),
Age int2,
Department varchar(30),
salary decimal(8,2)
);

insert into employee VALUES('Ramesh',20,'Finance',50000),('Deepesh',25,'Sales',30000),('Suresh',22,'Finance',20000),
('Ram',28,'Finance',20000),('Pradeep',22,'Sales',20000);

insert into employee VALUES('Trishaan',20,'Finance',10000);
select * from employee;
use test;
-- Window functions
-- find the average salary of employees within each deaprtment

select name, age, department, salary, avg(salary)
OVER (partition by department) as average_salary
from employee;

-- find the average salary of employees within each deaprtment

select name, age, department, salary, avg(salary)
OVER (partition by department order by age) as average_salary
from employee ;

-- apply ranking to each employees based on the salary 
select e.*,rank() OVER (partition by department order by salary desc) as `rank`
from employee e;

-- apply percent ranking to each employees based on the salary 
select e.*,percent_rank() OVER (partition by department order by salary desc) as `rank`
from employee e;


-- apply and dense_rank ranking to each employees based on the salary 
select e.*,
rank() OVER (partition by department order by salary desc) as `rank`,
dense_rank() OVER (partition by department order by salary desc) as `dense_rank`
from employee e;

-- row_number() without partiton
select e.*,
rank() OVER (partition by department order by salary desc) as `rank`,
dense_rank() OVER (partition by department order by salary desc) as `dense_rank`,
row_number() OVER() as 'row_number'
from employee e;

-- row number with partition
select e.*,
rank() OVER (partition by department order by salary desc) as `rank`,
dense_rank() OVER (partition by department order by salary desc) as `dense_rank`,
row_number() OVER() as 'row_number_without_partition',
row_number() OVER(partition by department) as 'row_number_with_partition'
from employee e;

-- aggregate functions
select e.*,
avg(salary) OVER (partition by department order by salary) as average_salary,
max(salary) OVER (partition by department) as max_salary,
count(Name) over(partition by department) as 'no_of_employees',
rank() OVER (partition by department order by salary desc) as `rank`,
dense_rank() OVER (partition by department order by salary desc) as `dense_rank`,
row_number() OVER() as 'row_number_without_partition',
row_number() OVER(partition by department) as 'row_number_with_partition'
from employee e;

-- LAG with offset and default
select e.*, lag(e.salary) OVER() as lag_1, 
lag(e.salary,2) OVER() as lag_2,
lag(e.salary,3,0) OVER() as lag_3
 from employee e;
 
-- LEAD with offset and default
select e.*, lead(e.salary) OVER() as lead_1, 
lead(e.salary,2) OVER() as lead_2,
lead(e.salary,3,0) OVER() as lead_3
 from employee e;

-- CASE statements : finance -10% hike and for sales -5%

select Name, salary, department,
(case department
when 'Finance' Then 
salary +salary*.1
else
salary +salary*.05
end) as New_salary
from employee;

 select Name, department,
 (case department
 when 'Finance' Then 'F'
 when 'Sales' Then 'S'
 Else 'O' 
 end) 
 as short_form_dept
 from employee;
 

use dmart;
SET SQL_SAFE_UPDATES=0;

update customer_info set gender =  
(case gender
when 'M' Then  '1'
when 'F' Then '0'
else '2'
end 
);

-- check table
select * from customer_info;

-- Pivots, CTEs, Stored_procedures, Functions,Frames

 --------------------------------------------------------------------------------------------------------------
select * from city_sales;

-- running total (frames) with partition
select city, sold, month, sum(sold) OVER(partition by month order by city desc rows unbounded preceding) as 'running_total'
from city_sales;

-- running total without partition
select city, sold, month, sum(sold) OVER(partition by month order by city desc rows unbounded preceding) as 'running_total'
from city_sales;

select name, yearmonth,round(close,2),
avg(round(close,2)) OVER(partition by name order by yearmonth asc 
rows between 19 preceding and current row) as moving_avg_20 
from pivot_stock_data;

-- calculating moving average withour current row
select name, yearmonth,round(close,2),
avg(round(close,2)) 
OVER(partition by name order by yearmonth asc rows 2 preceding) as moving_avg_2
from pivot_stock_data;

-- CTEs - Common Table Expressions
-- syntax : 
--		With temporary_table_name AS
--			(query)
--		query;

-- calculate the percentage sale increase/decrease month by month
-- new columns : percentage : ((sales_value - previous_month_sale)/previous_month_sale)*100
		
select month,sales_value,lag(sales_value) OVER() as previous_month_sale,
((sales_value-previous_month_sale)/previous_month_sale)*100 as percentage
from sales;

-- The above query will yield an error, we are run time creating previous_month_sale column and on that run time column
-- we are performing calculation to create a new column
-- To solve above problem we would create temporary tables using CTEs

with sales_temp as
(select month,sales_value,lag(sales_value) OVER() as previous_month_sale
from sales)
select *, ((sales_value-previous_month_sale)/previous_month_sale)*100 as percentage
from sales_temp;


-- diff between CTEs and Views
--  Life of CTEs is within the query , you caanot access it once the query is ended
-- Views but they can be accessed anywhere in the script until and unless you explicitly drop it.
-- CTEs are preferred when we want to accss only one time
-- wheras, Views are preferred when we cant to access a query multiple times

----------------------------------------------------------------------------------------------------------
-- Functions
-- Syntax :
-- 		delimiter $$
--		create function function_name(parameter data_type) returns data_type deterministic
--				BEGIN
--					Logic
--				END$$
--		delimiter ;

-- calculate the age of each employee
select *, (year(current_date()) - year(dob)) as age  from employee1;

-- create a function to calculate the age
delimiter $$
create function calc_age(date_of_birth date) returns int deterministic
BEGIN
	declare todaydate date;
    select current_date() into todaydate;
    return (year(todaydate) - year(date_of_birth));
END$$
delimiter ;

-- call function
select *, calc_age(dob) as age from employee1;

--------------------------------------------------------------------------------------------
-- Stored Procedures
-- input.ouput and input-ouput paramaters
-- They can call any functions
-- they can only be called using call statement
-- SP all the database operations are allowed

-- syntax : 
--		Delimiter $$
-- 		create procedure procedure_name(paramaters data_type)
--		BEGIN
--		logic
--		END $$
--		delimiter ;

create table e1 (
empno int,
empname varchar(30),
dept varchar(20),
ss_no int,
acc_no int,
sal int8
);

-- insert the records in above table using stored procedures
drop procedure if exists insert_emp_table;
delimiter $$
create procedure insert_emp_table (
empno_ int,
empname_ varchar(30),
dept_ varchar(20),
ss_no_ int,
acc_no_ int,
sal_ int8
)
Begin
	insert into e1 Values(empno_,empname_,dept_,ss_no_,acc_no_,sal_);
	commit; 
END $$
delimiter ;

-- execute
call insert_emp_table(1,'Parmeet','IT',12345,54321,123);

-- check
select * from e1;

Delimiter $$
create procedure update_emp_dept (empno_ int, dept_ varchar(20))
	BEGIN
		SET SQL_SAFE_UPDATES =0;
		update e1 set dept=dept_ where empno = empno_;
		SET SQL_SAFE_UPDATES =1;
	END $$
Delimiter ;

-- call update_emp_dept stored procedure
call update_emp_dept(1,'Finance');

-- check
select * from e1;

-----------------------------------------------------------------------------------------
select * from pivot_stock_data;

-- Name '2013-02'  '2013-03' '2013-04' '2013-05'.......
-- AAPL   -6.88%     1.06%     0.2%

------------------------------------------------------------
-- we will create using case statement
select count(distinct formatted_date) from pivot_stock_data;

select name, 
max(case  when formatted_date = '2013-02' Then delta_pct else NULL end) as '2013-02',
max(case when formatted_date = '2013-03' Then delta_pct else NULL end) as '2013-03',
max(case when formatted_date = '2013-04' Then delta_pct else NULL end) as '2013-04'
from pivot_stock_data group by name order by name asc;

-- Two ways to create above statement
-- Pivots -> we donot have this keyword in mysql
-- Dynamic Programming ->

-- using dynamic programming
-- concat and group_concat method/functions

-- create a group_concat statement
SET 
	@sql = 
		(
		SELECT
			group_concat(
					concat(
						"max(case  when formatted_date = '",formatted_date, 
                        "' Then delta_pct else NULL end) as '",
						formatted_date,"'"
                        )
                        )
			from pivot_stock_data
		);
select @sql;

-- You got warning in above statement because group_concat has maximum length of 1024 so 
-- let us change that maximum length

-- SET  group_concat maximum length
SET SESSION group_concat_max_len =100000;

SET 
	@sql = 
		(
		SELECT
			group_concat(
					concat(
						"max(case  when formatted_date = '",formatted_date, 
                        "' Then delta_pct else NULL end) as '",
						formatted_date,"'"
                        )
                        )
			from pivot_stock_data
		);

-- Execute the above queries : prepare and exectue


