use test;

select * from employee;

SET SQL_SAFE_UPDATES=0;
delete from employee where name='Trishaan';

select * from employee;

-- avg salary
select name,age,department,salary,
avg(salary) OVER(partition by department) as avg_salary
from employee;

-- rank of each employees withi department
insert into employee VALUES('Trishaan',23,'Finance',10000);

select name, age , department, salary, 
rank() OVER(partition by department order by salary desc) as `rank`
from employee;

-- dense_rank
select name, age , department, salary, 
rank() OVER(partition by department order by salary desc) as `rank`,
dense_rank() OVER(partition by department order by salary desc) as `dense_rank`
from employee;

-- find row number without partition
select name, age , department, salary, 
rank() OVER(partition by department order by salary desc) as `rank`,
dense_rank() OVER(partition by department order by salary desc) as `dense_rank`,
row_number() OVER() as row_number_without_partition
from employee;

-- find row number with partition
select name, age , department, salary, 
rank() OVER(partition by department order by salary desc) as `rank`,
dense_rank() OVER(partition by department order by salary desc) as `dense_rank`,
row_number() OVER() as row_number_without_partition,
row_number() OVER(partition by department) as row_number_with_partition
from employee;

-- percent_rank
select name, age , department, salary, 
rank() OVER(partition by department order by salary desc) as `rank`,
percent_rank() OVER(partition by department order by salary desc) as `percentile_rank`,
dense_rank() OVER(partition by department order by salary desc) as `dense_rank`,
row_number() OVER() as row_number_without_partition,
row_number() OVER(partition by department) as row_number_with_partition
from employee;

-- create sales table
create table sales (
month varchar(05),
Sales_value decimal(12,2)
);

insert into sales values('Jan',10000),('Feb',11000),('Mar',13750),('Apr',13200),('May',19800),('June',14850),
('July',17077.5),('Aug',25616.25),('Sep',22029.975),('Oct',24232.9725),('Nov',26656.26975),('Dec',29321.89673);

select * from sales;

-- lag(1) - default offset
select month, sales_value, lag(sales_value) OVER() as previous_sales from sales;

-- lag(2) with offset
select month, sales_value, lag(sales_value) OVER() as previous_sales_lag1,
lag(sales_value,2) OVER() as previous_sales_lag2
from sales;

-- lag(3) with default as 0
select month, sales_value, lag(sales_value) OVER() as previous_sales_lag1,
lag(sales_value,2) OVER() as previous_sales_lag2,
lag(sales_value,3,0) OVER() as previous_sales_lag3
from sales;

-- lead(1) - default offset
select month, sales_value, lead(sales_value) OVER() as next_month_sales from sales;

-- lead(2) with offset
select month, sales_value, lead(sales_value) OVER() as next_month_sales_lead1,
lead(sales_value,2) OVER() as next_month_sales_lead2
from sales;

-- lead(3) with default as 0
select month, sales_value, lead(sales_value) OVER() as next_month_sales_lead1,
lead(sales_value,2) OVER() as next_month_sales_lead2,
lead(sales_value,3,0) OVER() as next_month_sales_lead3
from sales;

select name, age , department, salary, 
avg(salary) OVER(partition by department) as avg_salary,
max(salary) OVER(partition by department) as max_salary,
min(salary) OVER(partition by department) as min_salary,
rank() OVER(partition by department order by salary desc) as `rank`,
percent_rank() OVER(partition by department order by salary desc) as `percentile_rank`,
dense_rank() OVER(partition by department order by salary desc) as `dense_rank`,
row_number() OVER() as row_number_without_partition,
row_number() OVER(partition by department) as row_number_with_partition
from employee where age>23;

-- case statements
use DMART;
select * from customer_info;

select c.*,
(case c.gender
when 'M' Then '1'
when 'F' Then '0'
else '2' 
end) as sex 
from customer_info c;

-- update gender to M where value is 1 and 'F' where value is 0
set SQL_safe_updates =0;

update customer_info set gender = 
(case gender 
when '1' Then 'M'
when '0' Then 'F'
else 'O'
end);

select * from customer_info;

use test;

select * from employee;

select e.*, 
(case e.department
when 'Finance' Then 'F'
when 'Sales' Then 'S'
end) as short_dept
from employee e;

-- Frames
create table city_sales (
city varchar(20),
sold int8,
month int2
); 

insert into city_sales values('Pune',300,1),('Raipur',200,1),('Pune',500,2),('Raipur',100,4),
('Pune',200,4),('Pune',300,5),('Raipur',200,5);

select * from city_sales;

select city, sold,month, sum(sold) OVER(partition by month order by sold rows unbounded preceding) as running_total
from city_sales;

select city, sold,month, sum(sold) OVER(partition by month order by sold rows unbounded preceding) as running_total,
avg(sold) OVER(partition by month order by sold rows unbounded preceding) as running_avg
from city_sales;


-- UDF
drop function if exists CalculateSalary;

Delimiter $$
create Function CalculateSalary(dept varchar(30)) 
	returns decimal(10,2)
Deterministic
BEGIN
	declare total_salary decimal(10,2);
	select sum(salary) into total_salary from employee where department = dept;
    return total_salary;
END$$

delimiter ;

select e.*,Calculatesalary(department) as total_salary from employee e;

-- Create Employee Table
CREATE TABLE Employees
(
  EmployeeId INT PRIMARY KEY,
  Name VARCHAR(50),
  Salary INT,
  DOB Date
);
-- Populate Employee table
INSERT INTO Employees(EmployeeId, Name, Salary, DOB) VALUES(1001, 'Pranaya', 10000, '1988-02-29');
INSERT INTO Employees(EmployeeId, Name, Salary, DOB) VALUES(1002, 'Anurag', 20000, '1992-06-22');
INSERT INTO Employees(EmployeeId, Name, Salary, DOB) VALUES(1003, 'Sambit', 30000, '1978-04-12');

DELIMITER $$
CREATE FUNCTION Func_Calculate_Age
(
 Age date
)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE TodayDate DATE;
    SELECT CURRENT_DATE() INTO TodayDate;
    RETURN YEAR(TodayDate) - YEAR(Age);
END$$
DELIMITER ;

SELECT Func_Calculate_Age("1988-02-29");
SELECT Func_Calculate_Age("1988-02-29") AS AGE;

SELECT EmployeeId, Name, Salary, DOB, Func_Calculate_Age(DOB) AS Age 
FROM Employees
WHERE Func_Calculate_Age(DOB) > 30;

--------------------------------------------------------------------------------------
-- PIVOTS, CTEs, Stored Procedures, Functions, Frames, Indexes
use test;
select * from city_sales;

-- Frames "rows unbounded preceding"
-- with parition
select city,sold, month, 
sum(sold) OVER(partition by month Order by City desc rows unbounded preceding) as running_total 
from city_sales;

-- without partition
select city,sold, month, 
sum(sold) OVER(Order by month desc rows unbounded preceding) as running_total 
from city_sales;

-- Moving averages or rolling averages 
-- calculatng the average of past 3 days (moving avreage of 3)
select name,yearmonth,close from pivot_stock_data;

select name, yearmonth, round(close,2),
avg(round(close,2)) 
OVER(partition by name order by yearmonth rows between 2 preceding and current row) 
as 'moving_average_3days' 
from pivot_stock_data;

-- Moving average of 20 days
select name, yearmonth, round(close,2),
avg(round(close,2)) 
OVER(partition by name order by yearmonth rows between 19 preceding and current row) 
as 'moving_average_20days' 
from pivot_stock_data;

-- unbounded preceding
-- avg(close) with rows unbounded preceding :  it will calculate the running _avg for all preceding rows
select name, yearmonth, round(close,2),
avg(round(close,2)) 
OVER(partition by name order by yearmonth rows unbounded preceding) 
as 'running _avg' 
from pivot_stock_data;

-- Moving average of 3 days - excluding current row
select name, yearmonth, round(close,2),
avg(round(close,2)) 
OVER(partition by name order by yearmonth rows 3 preceding) 
as 'moving_average_20days' 
from pivot_stock_data;

-------------------------------------------------------------------------------------------
-- Functions Vs Stored Procedure
-- 1. Function supports input parameter, where as SP supports i/p, o/p and i/p-o/p parameters
-- 2. Functions cannot call SP whereas SP can call Functions.
-- 3. Function can be called using select statement whereas SP can be called using CALL statement
-- 4. Function must return a value whereas SP need to return a value. 
-- 5. Function can only use select operation whereas SP can use any databae operation.

-- Create funtion
-- syntax :
-- 		DELIMETER $$
--		CREATE FUNCTION function_name(paramter_name data_type) returns data_type deterministic
--				BEGIN
--					LOGIC
--				END$$
--		DELIMITER ;

-- calculate the age of the employees

select *, year(current_date())-year(dob) as age  from employee1;

-- create a function to calculate the age
drop function if exists calc_emp_age;
DELIMITER $$
CREATE FUNCTION calc_emp_age(date_of_birth date) returns int deterministic
	BEGIN
		declare todaydate date;
        select current_date() into todaydate;
        return year(todaydate)-year(date_of_birth);
	END$$
DELIMITER ;


-- execute the fucntion
select *, calc_emp_age(dob) as age from employee1;


-- create stored procedure
-- syntax : 
--		DELIMITER$$
--		CREATE PROCEDURE procedure_name(paramaters data_type)
--		BEGIN
--			LOGIC
--		END$$
--		DELIMITER;
-- ----------------------------------------------------------------------------------------------
create table emp_2 (
empno int8,
empname varchar(30),
dept varchar(20),
ss_no int8,
acc_no int8,
empsal int8
);

-- insert the records in the above table using stored procedure
DELIMITER $$
CREATE procedure insert_emp_table(
empno_ int8,
empname_ varchar(30),
dept_ varchar(20),
ss_no_ int8,
acc_no_ int8,
empsal int8)
	BEGIN
		insert into emp_2 VALUES(empno_,empname_,dept_,ss_no_,acc_no_,empsal);
		commit;
	END$$
DELIMITER ;
       
-- check the table
select * from emp_2;

-- EXECUTE SP 
CALL insert_emp_table(1,'Parmeet','IT',12345,54321,123);

-- check
select * from emp_2;

-- create a procedur to updte the department of any given employee
DELIMITER $$
CREATE procedure update_emp_table(empno_ int8, new_dept varchar(20))
BEGIN
	SET SQL_SAFE_UPDATES=0;
    UPDATE emp_2 set dept=new_dept where empno = empno_;
    SET SQL_SAFE_UPDATES=1;
END$$
DELIMITER ;

-- EXECUTE the procedure
select * from emp_2;
CALL update_emp_table(1,"Finance");

-- check
select * from emp_2;

----------------------------------------------------------------------------------------------------------------------
-- CTEs - Common table expressions
-- They are the virtual table and the life of CTEs is within the query.
-- Syntax :
--		With temp_table AS
--			(query)
--			query;

-- percent : ((curent_sales_value -previous_sales_value)/previous_sales_value)*100
select *,lag(sales_value) OVER() as previous_month_sale,
((sales_value - previous_month_sale)/previous_month_sale)*100 as percent
from sales;

-- The above query will yeield an error
-- We are already creating a run_time column : previous_month_sale and on the same column we are trying to perform operation
-- to create another column.
-- to solve above error we would use CTEs
with sales_temp AS
	(select *,lag(sales_value) OVER() as previous_month_sale from sales)
    select *,((sales_value - previous_month_sale)/previous_month_sale)*100 as percent from sales_temp;
    
select * from sales_temp; 
-- The above query wuld give an error

-- CTEs and Views
-- 1. The life of CTE is within the query
-- 2. The life of view is till we explicity drop it. (Read only)
-- 3. When we need to run a query only once then use CTEs and when the query is needed multiple times then use Views.
-------------------------------------------------------------------------------------------------------------------------
-- PIVOTS
-- Transformation from rows to columns
select * from pivot_stock_data;

------------------------------------------------
-- Name  '2013-02'  2013-03'    2013-04'..........
-- AAPL   -6.88%    1.06%        0.2%...............
-- pd.pivot_table() in pandas
------------------------------------------------------------

select name,
max(case when formatted_date ='2013-02' Then delta_pct else NULL END) as '2013-02',
max(case when formatted_date ='2013-03' Then delta_pct else NULL END) as '2013-03',
max(case when formatted_date ='2013-04' Then delta_pct else NULL END) as '2013-04'
from pivot_stock_data group by name;

select distinct formatted_date from pivot_stock_data;
-------------------------------------------------
-- Dynamic programmingas Pivots are not available in MYSQL


SET @sql
		=	(
        select group_concat(
			concat (
            "max(case when formatted_date ='",formatted_date,"' Then delta_pct else NULL END) as '", formatted_date,"'"
            )
            )
            from pivot_stock_data
            );

-- The above query yiedl a warning on group_concat
-- The group concat maxium length is 1024 s we will change the length of group_concat
SET group_concat_max_len =100000;
SET @sql
		=	(
        select group_concat(
			distinct concat (
            "max(case when formatted_date ='",formatted_date,"' Then delta_pct else NULL END) as '", formatted_date,"'"
            )
            )
            from pivot_stock_data
            );
            
select @sql;

select name, @sql from pivot_stock_data group by name;

-- Trigeer the above query
SET @pivot_statement = 
			CONCAT("select name,",@sql,"from pivot_stock_data group by name;");

select @pivot_statement;

-- Execute the above statement
prepare	complete_pivot_statement
from @pivot_statement;

execute complete_pivot_statement;


-- Dynamic Programming steps

-- 1. Create the dynamic part of the sql 
-- 2. we used concat to join the statement
-- 3. we used group concat to join multple statements/strings
-- 4. we also set the group_concat_max_len to avoid the warnings
-- 5. we preapred the whole sql statement adn save it under variable pivot_statement.
-- 6. we prepared the complete_pivot_statament using prepare keyword.
-- 7. we execute the prepared statement "complete_pivot_statement" using execute command/keyword.
-----------------

