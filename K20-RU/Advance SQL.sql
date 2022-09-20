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
-- WITH table_name AS 
--	(query) 
-- query;

select month,sales_value, 
lag(sales_value) OVER() as 'previous_month_sale'
from sales;

WITH prev_sales 
AS
(select month,sales_value, 
lag(sales_value) OVER() as 'previous_month_sale'
from sales)
select p.*, ((p.sales_value-p.previous_month_sale)/p.sales_value *100) as percentage from prev_sales p;

select * from prev_sales;

-- CTEs Vs Views (Both are temporary tables)
-- Life of CTEs is within the query whereas the life of view is till we explicitly drop it.
-- CTEs are used when we need a query only once, whereas Views are used when we need a same query mutiple times


-- Functions
-- python : def function_name(paramater):
--               logic

-- DELIMITER $$
-- CREATE FUNCTION function_name(parameters) returns datatype deterministic
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
------------------------------------------------------------------------------------------------------
-- Frames :
-- Rows unbounded preceding 
use test;
select city,sold from city_sales;

-- running total
select city, sold, sum(sold) OVER(order by city ROWS UNBOUNDED preceding) as running_total
from city_sales;

-- running total based on the city
select city, sold, sum(sold) OVER(partition by city order by city ROWS unbounded preceding) as running_total
from city_sales;

-- stock Market : Famouse concept of moving averages
select name,yearmonth,close from pivot_stock_data;
-- Moving average(5)
select name,yearmonth,close,
avg(close) OVER(partition by name ROWS between 4 preceding and current row) as `ma(5)` 
from pivot_stock_data;
---------------------------------------------------------------------------------------------------
-- Stored Procedure Vs Functions
-- Syantax of Functions :
--			DELIMITER $$
--			CREATE FUNCTION function_name(parameter_name datatype) returns data_type deterministic
--					BEGIN
--						LOGIC
--					END$$
--			DELIMITER ;

-- Syntax of SP:
--			DELIITER $$
--			CREATE PROCEDURE procedure_name(parameter_name datatype)
--					BEGIN
--						LOGIC
--					END$$
--			DELIMITER ;

-------------------------------------------------------------
-- 1. Functions can handle only i/p paramaters whereas SP can handle i/p, o/p, or i/p-o/p paramaters
-- 2. Functions(UDFs) can be called using select statement whereas SP can be called using CALL statement
-- 3. Functions must return a value whereas for SP it need not to return any value.
-- 4. Functions support only select statement, whereas SP can support all the database ooperations
-- 5. Functions cannot call SP, whereas SP can call functions
-----------------------------------------------------------------
-- create a function
select * from employee1;
select *, year(current_date()) - year(dob) as age from employee1;
drop function if exists cal_emp_age;
DELIMITER $$
create function cal_emp_age(date_of_birth date) returns int deterministic
BEGIN
	declare todaydate date;
	select current_date() into todaydate;
    return year(todaydate) - year(date_of_birth);
END $$
DELIMITER ;

-- Exectue the function
select *, cal_emp_age(dob) as age from employee1;

-------------------------------------------------------------------
-- Stored procedure
drop table if exists e4;
create table e4 (
empno int8,
empname varchar(30),
dept varchar(20),
ss_no int8,
acc_no int8,
empsal int8); 

-- We will use SP to insert the records in the table
drop procedure if exists insert_emp_table;
DELIMITER $$
create procedure insert_emp_table(empno_ int8, empname_ varchar(30), dept_ varchar(20),
									ss_no_ int8, acc_no_ int8, empsal_ int8)
BEGIN
	insert into e4 VALUES(empno_,empname_,dept_,ss_no_,acc_no_,empsal_);
    commit;
END $$
DELIMITER ;

-- check e4
select * from e4;

-- execute SP
CALL insert_emp_table(1,"Parmeet","IT",12345,54321,123);

-- check e4
select * from e4;

-- update the table e4 using stored procedure
drop procedure if exists update_emp_dept;
DELIMITER $$
create procedure update_emp_dept(employee_no int8, new_dept varchar(20))
BEGIN
	SET SQL_SAFE_UPDATES=0;
    update e4 set dept=new_dept where empno= employee_no;
    SeT SQL_SAFE_UPDATES=1;
END$$
DELIMITER ;
select * from e4;
-- execute the procedure
CALL update_emp_dept(1,"Finance");

-- check e4
select * from e4;
-------------------------------------------------------------------------------------------------------------
-- PIVOTS
-- It is the chnage in a view from rows to columns and unpivots are vice versa of that
-------------------------------------------------------------------------------------------
select * from pivot_stock_data;
---------------------------------------------------------------
-- Name 	2013-02		2013-03		2013-04		2013-05..........................
-- AAPL		-6.88%		1.06%		0.2%		1.19% ...........................
-- AMD		-3.49%		2%			11.02%		42.35%..........................
-- .
-- .
-- .
--------------------------------------------------------------------------------------------
-- IN my sql we donot have a direct function to find pivots
-- whereas in sql/ other languages we have PIVOT and UNPIVOT
-- 1. we will use case statement to achieve this
-- 2. Dynamic Programming
-------------------------------------------------------------------------------------------
select name, 
max(case when formatted_date ='2013-02' Then delta_pct ELSE null END ) as '2013-02',
max(case when formatted_date ='2013-03' Then delta_pct ELSE null END ) as '2013-03',
max(case when formatted_date ='2013-04' Then delta_pct ELSE null END ) as '2013-04'
from pivot_stock_data group by name; 

select * from pivot_stock_data;
select count(distinct formatted_date) from pivot_stock_data;

-- step :1 encapsulated all the statis max statements inside double quotes
-- step :2 - replacing the dynamic part with column name

SET @sql =  
		(SELECT 
			group_concat(
					concat("max(case when formatted_date ='",formatted_date,"' Then delta_pct ELSE null END ) as '",formatted_date,"'")
					)
		 from pivot_stock_data
         );

-- If you run aboe statement you will get the warning over group_concat
-- The maximum length of group_concat is 1024
-- so to overcome the warning we will change the maximum length of group concat

SET group_concat_max_len = 100000;
SET @sql =  
		(SELECT 
			group_concat(
					distinct concat("max(case when formatted_date ='",formatted_date,"' Then delta_pct ELSE null END ) as '",formatted_date,"'")
					)
		 from pivot_stock_data
         );
		
-- check the varible @sql 
select @sql;

SET @pivot_statement = concat("select name,",@sql,"from pivot_stock_data group by name");

select @pivot_statement;

-- Prepare the statement
prepare complete_pivot_statement
from @pivot_statement;

-- Execute the prepared statement
execute complete_pivot_statement;

-- 1. We used case condition to creata and alternative for pivots 
-- 2. If there are many rows and we want to explicitly write the conditions for pivots then it would be a tedious task as there is no keyword in
--    mysql to acomodate PVIOTS & UNPIVOTS
-- 3. We approached using dynamic programming
--		a. We bifuracated the static and dynamic statements
--		b. we joined that statements using concat function
--		c. we did a group join using group_concat statement(before that we set the length of group concat to avoid the warning)
--		d. we prepared whole query in a variable @pivot_statement
--		e. we use prepare statement to prepare the query for execution
--		f. we used execute statemtn to execute the query dynamically.

-------------------------------------------------------------------------------------------------------------------------------------------------
-- CURSORS
-- let us consider the loops in general programming.
-- They help us to execute the a specific sequence of instructions repeatedly unitil a particular condition breaks the loop.
-- MYSQL also provides a way to execute instructions on individual rows using cursors.
-- Cursors will execute the set of instrcutions on rows returned from sql queries
----------------------------------------------------------------------------------------------------------------------------
-- Properties of cursors
-- 1. Non-Scrollable : you can iterate through rows in one direction. (you cannot skip a row, you cannot jump a row or you cannot go back to a row)

-- 2. read only : you cannot update or delete rows using cursors

-- 3. Asensitive : MYSQL cusrsors points to the underlying data. It runs faster than a insensitive cursor.
--					(Insesitive cursors are basically a snapshot of the underlyin data)

-------------------------------------------------------------------------------------------------------------------------------
-- Create a MYSQL cursors
-- To create mysql cursors there are 4 statements : DECLARE, OPEN, FETCH and CLOSE
--	a. DECLARE:
--			It is a place where we can declare variables, cursors or any handlers.
--			Note: There is a sequence of declarations that needs to be followed to variables, cusors and handlers.
--	you must first delcare atleaste one variables before you use fetch statement.
-- synatx : declare variable_name dataype
-- when you declare a cusror then you must attach a select statement to it.
-- delcare a cursor :  Declare cursor_name CURSOR FOR <select_statement>
-- you need to also declare not found handler 
-- when the cursor iterated and it reaches last row , it raises a condition and that condition would be handled by not found handler
-- sytanx : Declare continute handler for not found set finished =1;

-- b. OPEN : it initializes the result from declare statement
-- syantx : OPEN cursor_name

-- c. FETCH : It works as a iterator
--	syantx : FETCH cursor_name into <variable_list>
	
-- D. Close : close the opened cursor
-- syntax : close cursor_name

--------------------------------------------------------------------------------------------------------------------------
use window_functions;
select * from football;

-- problme statement : 
-- create the cursor such that
--	a. It will loop through the football table
--	b. calculate the average goal a home team made 
DROP PROCEDURE IF EXISTS cursordemo;
DELIMITER $$ 
CREATE PROCEDURE cursordemo(INOUT average_goals FLOAT)
	BEGIN
		DECLARE done int DEFAULT FALSE;
		DECLARE matches int DEFAULT(0);
		DECLARE goals int DEFAULT(0);
		DECLARE half_time_goals decimal(12,6);

-- Declaring Cursor		
        DECLARE team_cursor CURSOR FOR
		SELECT FTHG FROM football WHERE (FTR = "H");

-- Declaring cursor handle    
		DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

-- opening the cursor
		OPEN team_cursor;

	teams_loop:
		LOOP
			FETCH team_cursor INTO half_time_goals;
			IF done THEN LEAVE teams_loop;
			END IF;
			SET goals = goals + half_time_goals;
			SET matches = matches + 1;
		END LOOP
	teams_loop;

	SET	average_goals = goals / matches;

-- close the cursor

	CLOSE team_cursor;
	END $$ 
DELIMITER ;

SET @average_goals = 0.0;
CALL cursordemo(@average_goals);
SELECT @average_goals;














