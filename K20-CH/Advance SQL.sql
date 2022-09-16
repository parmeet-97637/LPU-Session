use test;
select * from employee;

SET SQL_SAFE_UPDATES=0;
delete from employee where name in ('Parmeet','Trishaan','Ayushi');

select * from employee;

-- find the avg salary within each department
select name,age,department,salary,
avg(salary) OVER(partition by department) as avg_salary
from employee;

-- find the maximum salary withing each department
select name,age,department,salary,
max(salary) OVER(partition by department) as max_salary
from employee;

-- find the rank within each department on the basis of salary
insert into employee VALUES('Parmeet',27,'Finance',15000),('Ayushi',21,'Finance',15000),('Trishaan',22,'Finance',14500);
select * from employee;

select e.*,
rank() OVER(partition by e.department order by e.salary desc) as `Rank`
from employee e;

select e.*,
rank() OVER(partition by e.department order by e.salary asc) as `Rank`
from employee e;

-- dense rank
select e.*,
rank() OVER(partition by e.department order by e.salary desc) as `Rank`,
dense_rank() OVER(partition by e.department order by e.salary desc) as `dense_Rank`
from employee e;

-- percent rank
select e.*,
rank() OVER(partition by e.department order by e.salary desc) as `Rank`,
dense_rank() OVER(partition by e.department order by e.salary desc) as `dense_Rank`,
percent_rank() OVER(partition by e.department order by e.salary desc) as `percent_Rank`
from employee e;

-- row_number without partition
select e.*,
rank() OVER(partition by e.department order by e.salary desc) as `Rank`,
dense_rank() OVER(partition by e.department order by e.salary desc) as `dense_Rank`,
percent_rank() OVER(partition by e.department order by e.salary desc) as `percent_Rank`,
row_number() OVER() as 'Row_number'
from employee e;

-- row_number with partition
select e.*,
rank() OVER(partition by e.department order by e.salary desc) as `Rank`,
dense_rank() OVER(partition by e.department order by e.salary desc) as `dense_Rank`,
percent_rank() OVER(partition by e.department order by e.salary desc) as `percent_Rank`,
row_number() OVER() as 'Row_number_without_Partition',
row_number() OVER(partition by department) as 'Row_number_with_partition'
from employee e;

use imdb;
create view movie_view as 
select m.year,m.title,r.avg_rating from movie m 
inner join ratings r 
on m.id = r.movie_id;

-- find top 3 movies each year on basis of rating
-- table_name : movie_views
select * from movie_view;

create view temp_table as 
select year, title, avg_rating,
dense_rank() OVER(partition by year order by avg_rating desc) as `Rank` 
from movie_view;

select * from temp_table where `Rank`<=3;

use test;

select * from sales;

-- lag by 1
select month,sales_value,
lag(sales_value) OVER() as previous_month_sale 
from sales;

-- lag by 2
select month,sales_value,
lag(sales_value) OVER() as previous_month_sale_lag1,
lag(sales_value,2) OVER() as previous_month_sale_lag2
from sales;

-- lag by 3 and default 0
select month,sales_value,
lag(sales_value) OVER() as previous_month_sale_lag1,
lag(sales_value,2) OVER() as previous_month_sale_lag2,
lag(sales_value,3,0) OVER() as previous_month_sale_lag3
from sales;

-- lead by 1
select month,sales_value,
lead(sales_value) OVER() as next_month_sale 
from sales;

-- lead by 2
select month,sales_value,
lead(sales_value,2) OVER() as next_month_sale 
from sales;

-- lead by 3
select month,sales_value,
lead(sales_value,3,0) OVER() as next_month_sale 
from sales;

-- case condition
select * from employee;

select e.*,
(case e.Department
when 'Finance' Then 'F'
when 'Sales' Then 'S'
else 'O'
end) as short_dept 
from employee e;

use DMART;

select * from customer_info;
-- update gender with 'M' where value is 1 and update gender with 'F' where value is 0

update customer_info set gender = 
(case gender 
when '1' Then 'M'
when '0' Then 'F'
else 'O'
end);

select * from customer_info;

use test;
select * from city_sales;

-- frames
-- we need running total month wise

select city,sold,month,
sum(sold) OVER(partition by month order by city ROWS UNBOUNDED PRECEDING) as running_total
from city_sales;

-- create the functions
use test;
select * from employee1;
-- calculate the age of the employees
select  e.*, year(current_date()) - year(DOB) age from employee1 e;

-- create the reusable function
delimiter $$
create FUNCTION CalculateAge(dob date) returns int deterministic
BEGIN 
	declare todaydate date;
    select current_date() into todaydate;
    return year(todaydate) - year(dob);
END$$

delimiter ;
    
select  e.*, CalculateAge(dob) age from employee1 e;

-- Pivots, Index, Frames, CTES, Stored Procedure
--------------------------------------------------------------------------------------
-- Frames
use test;
select * from city_sales;

-- Rows unbounded preceding  (running total for each month)
select city, sold, month, 
sum(sold) OVER(partition by month order by city desc ROWS UNBOUNDED PRECEDING) as running_total
from city_sales;

-- Rows unbounded preceding (running total for whole dataset)
select city, sold, month, 
sum(sold) OVER(order by city desc ROWS UNBOUNDED PRECEDING) as running_total
from city_sales;

select * from pivot_stock_data;

select name, yearmonth, close from pivot_stock_data;

-- calculate the moving average of the stocks (moving average of 3 rows)
select name, yearmonth, close, 
avg(close) OVER(partition by name order by yearmonth rows between 2 preceding and current row) as 'moving_avg_3'
from pivot_stock_data;

-- moving average of 20
select name, yearmonth, close, 
avg(close) OVER(partition by name order by yearmonth rows between 19 preceding and current row) as 'moving_avg_20'
from pivot_stock_data;

-- moving average of 10 without current row
select name, yearmonth, close, 
avg(close) OVER(partition by name order by yearmonth rows 10 preceding) as 'moving_avg_20'
from pivot_stock_data;
----------------------------------------------------------------------------------------------------------------------
-- CTEs

select month,sales_value,
lag(sales_value) OVER() as 'previous_month_sale' 
from sales;

-- In above query we want to calculate the month on month increase or decrease of percentage in sales
-- ((sales_value -previous_month_sale)/previous_month_sale)*100
-- ((11000-10000)/10000)*100
select month,sales_value,
lag(sales_value) OVER() as 'previous_month_sale',
((sales_value - previous_month_sale)/previous_month_sale)*100 as percent
from sales;

-- In the above query you would get an error because
-- you are creating the run time column "previous_month_sale" and on these run time column you are again
-- deriving/calculating a new column.

-- To solve above error we would use the CTEs
-- Synatx : 
--			with temp_table_name as
--          (query)
--            query will beling to temp_table_name;

with sales_temp as
(select month,sales_value,
lag(sales_value) OVER() as 'previous_month_sale' 
from sales)
select *,((sales_value - previous_month_sale)/previous_month_sale)*100 as percent from sales_temp;

-- CTEs Vs Views
-- 1. The life cycle of CTE is within the query where as life cycle of view is till we explicitly drop views
-- 2. Both CTEs and views are temporary table/virtual tables
-- 3. When we need a query only once then use CTEs when we need a same query multiple times then use Views.

---------------------------------------------------------------------------------------------------------
-- Functions Vs Stored Procedure
-- Function support only i/p paramater, whereas SP support i/p, o/p and ip-o/p parameters
-- functions cannot call SP where as SP can call functions
-- Functions can be called using select statements where as SP is called use CALL statement
-- functions to return a value, whereas for SP it is not necessary to return a value
-- functions, only select operation is allowed, wehreas in SP all the database operations are allowed.

-----------------------------------------------------------------------------------------------------------
-- syntax of function : 
--				DELIMITER $$
--				create function function_name(paramaters data_type) returns data_type deterministic
--						BEGIN
--							LOGIC
--						END$$
--				DELIMITER;

select * from employee1;

-- calculate the age of the employees
select  *, (year(current_date()) - year(dob)) age from employee1;

-- write a function to calcualte the age of employees
drop function if exists calc_emp_age;
DELIMITER $$
CREATE FUNCTION calc_emp_age(date_of_birth date) returns int deterministic
	BEGIN
		DECLARE todaydate date;
        select current_date() into todaydate;
        return year(todaydate) - year(date_of_birth);
	END$$
DELIMITER ;

-- call the function
select *, calc_emp_age(dob) as age from employee1;		
        
-------------------------------------------------------------------
-- SP 
-- Syntax : 
--		DELIMITER $$
--		CREATE PROCEDURE procedure_name(paramaters data_type)
--			BEGIN
--				LOGIC
--			END$$

drop table if exists e3;
create table e3 (
empno  int8,
empname varchar(30),
dept varchar(20),
ss_no int8,
acc_no int8,
empsal int8
); 

-- We will insert the records into the e3 table using stored procedures
drop procedure if exists insert_emp_table;
DELIMITER $$
CREATE PROCEDURE insert_emp_table(
empno_ int8, 
empname_ varchar(30),
dept_ varchar(20),
ss_no_ int8,
ac_no_ int8,
empsal_ int8)
	BEGIN
		insert into e3 VALUES(empno_,empname_,dept_,ss_no_,ac_no_,empsal_);
        commit;
	END$$
DELIMITER ;
    
-- check table e3
select * from e3;

-- CALL procedure
CALL insert_emp_table('1','Parmeet','IT',12345,54321,123);

select * from e3;

--------------------------------------------------------------------------------
-- let us update the department number using SP
drop procedure if exists update_emp_table;

DELIMITER $$
CREATE procedure udate_emp_tableudate_emp_table(employee_number int8, new_dept varchar(20))
	BEGIN
		SET SQL_SAFE_UPDATES=0;
        UPDATE e3 set dept = new_dept where empno = employee_number;
        SET SQL_SAFE_UPDATES=1;
	END$$
DELIMITER ;

-- check table
select * from e3;

-- call procedure udate
CALL udate_emp_table(1,'Finance');

-- check the table
select * from e3;

----------------------------------------------------------------------------
-- Pivots
-- We are transforming the view of the table, changing from rows to columns
-------------------------------------------------------------------
-- Name 	'2013-02'	'2013-03'	'2013-04'.........................
-- AAPL		 -6.88%		1.06%		0.2%...............
-- AMD		 -3.49%     2%          11.02%....
-- .
-- .
-- .

--------------------------------------------------------------------
-- we will do it using case statements
-- In Mysql there is not direct function PIVOTS and UNPIVOTS -> in sql it is present

select name,
max(case when formatted_date ='2013-02' Then delta_pct else NULL END) as '2013-02',
max(case when formatted_date ='2013-03' Then delta_pct else NULL END) as '2013-03',
max(case When formatted_date ='2013-04' Then delta_pct else NULL END) as '2013-04'
from pivot_stock_data group by name;
        
select count(distinct formatted_date) from pivot_stock_data;
select * from pivot_stock_data;
-- since we donot have PIVOT and unpivot funciton in mysql 
-- we will achieve it using dynamic programming

SET 
	@sql = (
			select
				group_concat(
				concat("max(case when formatted_date ='",formatted_date,
						"' Then delta_pct else NULL END) as '",formatted_date,"'")
						)
				from pivot_stock_data
            );
-- In above query you would get warning on group_concat because the total length 
-- of group_concat is 1024 and we are trying to save more characters inside that
-- so to avoid the warning we will change the length of group_concat

SET group_concat_max_len =100000;

SET 
	@sql = (
			select
				group_concat(
				distinct concat("max(case when formatted_date ='",formatted_date,
						"' Then delta_pct else NULL END) as '",formatted_date,"'")
						)
				from pivot_stock_data
            );
select @sql;

SET @pivot_statement = 
concat("select name,",@sql,"from pivot_stock_data group by name");

select @pivot_statement;

-- Execute the above query
prepare complete_pivot_statement
from @pivot_statement;

EXECUTE complete_pivot_statement;

-- 1. We started with case statement
-- 2. We found that it would be tedious to write the case statement again and again for 61 times.
-- 3. We went to concept of dynamic programming
-- 4. we separated status part and dyanamic part from th query and concatenated the query using concat function.
-- 5. we used group_concat over the concat function to accommodate all the max statements.
-- 6. We save this whole statement inside @sql variable.
-- 7. we have increased the length of group concat using group_concat_max_len 
-- 8. we preapred whole select statement adn saved it under pivot_statement variable
-- 9. To execute the preapred statement we first used prepare keyword
-- 10. Then we used executre statement to run the prepared query.











	







