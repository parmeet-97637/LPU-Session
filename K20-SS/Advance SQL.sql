use test;
select * from employee;

-- find the avg salary of employees within each department
select Name,Age,Department, Salary,
avg(Salary) OVER(partition by department) as avg_salary
from employee;

-- find the min, max salary and count the number of employees within each department
select Name, Age, Department, Salary,
min(salary) OVER(partition by department) as min_salary,
max(salary) OVER(partition by department) as max_salary,
count(Name) OVER(partition by department) as no_of_employees
from employee;

-- Find the rank of employees within each department on the basis of salary
select Name, Age,department, Salary,
rank() OVER(partition by department order by salary desc) as `rank`
from employee;

-- dense rank
select Name, Age,department, Salary,
rank() OVER(partition by department order by salary desc) as `rank`,
dense_rank() OVER(partition by department order by salary desc) as `dense_rank`
from employee;

-- row_number without partition
select Name, age, Department, salary,
row_number() OVER() as `row_number`
from employee; 

-- row_number with and without partition
select Name, age, Department, salary,
row_number() OVER() as `row_number_without_partition`,
row_number() OVER(partition by department) as `row_number_with_partition`
from employee; 

-- percent_rank : It will give the percentiles
select Name, Age,department, Salary,
percent_rank() OVER(partition by department order by salary desc) as `percent_rank`,
dense_rank() OVER(partition by department order by salary desc) as `dense_rank`
from employee;

-- find the employee within each department with highest salary
select Name, age,department, Salary,
dense_rank() OVER(partition by department order by salary desc) as `Rank`
from employee where `rank`=1;

-- The above query will yiled errro because you are creating run time column and on the same column you are trying to apply some operations.
-- to overcome the above error we would use the concepts of CTEs.
-- CTEs are the temporary/virtual tables whose life is within the query

-- Syntax :
--		WITH temp_table_name AS
--				(query)
--				query;
---------------------------------------------------------------------------------------------------------------

WITH temp_emp AS
	(select Name, age,department, Salary,
dense_rank() OVER(partition by department order by salary desc) as `Rank`
from employee)
select * from temp_emp where `rank`=1;

select * from temp_emp;
-- The above query will give you error as the life of CTE is within the query
-- CTEs and Views
-- CTEs are views both are temporary tables
-- CTEs existince is within the query where as views existence is until we explicitylt drop it.

-- Lag function
select * from sales;

-- Lag(1), Lag(2)
select *, 
LAG(sales_value) OVER() as previous_month_sale_lag1,
LAG(sales_value,2) OVER() as previous_month_sale_lag2,
LAG(sales_value,3,0) OVER() as previous_month_sale_lag3
from sales; 

-- Lead function
select *, 
LEAD(sales_value) OVER() as next_month_sale_lead1,
LEAD(sales_value,2) OVER() as next_month_sale_lead2,
LEAD(sales_value,3,0) OVER() as next_month_sale_lead3
from sales; 

-- Month by month increase in sales
with temp_sales as 
(select *, LAG(sales_value) OVER() as previous_month_sale
 from sales)
 select *,round(((sales_value-previous_month_sale)/sales_value)*100,2) as percent_inc_dec from temp_sales;

-- Frames
select city,sold from city_sales;

-- Frames without partiton : ROWS UNBOUNDED PRECEDING
select city,sold,
sum(sold) OVER(order by sold desc ROWS UNBOUNDED PRECEDING) as running_total
from city_sales;

-- calculate the running total for each month
select city,sold,month,
sum(sold) OVER(partition by month order by city ROWS unbounded preceding) as running_total
from city_sales; 

-- Moving Average in stock market 
select name,yearmonth,close from pivot_stock_data;
-- moving avergae of 3 days colsing price (current row is included)
select name, yearmonth, close,
avg(close) OVER(partition by `name` order by yearmonth ROWS between 2 PRECEDING and current row) as `ma(3)`
from pivot_stock_data;

-- moving avergae of 5 days colsing price (excluding current row)
select name, yearmonth, close,
avg(close) OVER(partition by `name` order by yearmonth ROWS 5 PRECEDING) as `ma(5)`
from pivot_stock_data;

-- case statement
select * from employee;

-- Where the department is finance , create a shortform as "F", where dept is slaes "S" and "O" : abbreviation columns
select *,
(case Department
when "Finance" Then "F"
when "sales" then "S"
Else "O"
END) as abbreviation
from employee;

-- We want to give salary hike of 10% to the Finance department and 15% to Sales Department

select *,
(case Department
when "Finance" Then salary+salary*.1
when "Sales" Then salary +salary*.15
else salary
end) as new_salary
from employee; 

-- we want to update the original column using case statement
SET SQL_SAFE_UPDATES=0;
update employee set salary = 
(case Department
when "Finance" Then salary+salary*.1
when "Sales" Then salary +salary*.15
else salary
end);

-- check table
select * from employee;

SET SQL_SAFE_UPDATES=1;


-- Functions
select * from employee1;

-- calculate the age of the employees
select *, year(current_date()) - year(dob) as age from employee1;

-- Syntax: 
--	DELIMITER $$
-- 	CREATE FUNCTION function_name(paramters_name data_type) returns data_type DETERMINISTIC
-- 			BEGIN
--					LOGIC
--			END $$
-- DELIMITER ;

select current_date();
----------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE FUNCTION cal_age(date_of_birth date) returns int deterministic 
	BEGIN
		declare todaydate date;
        select current_date() into todaydate;
        return year(todaydate) -year(date_of_birth);
	END $$
DELIMITER ;

-- calculate the age of the employees
select *, cal_age(dob) as age from employee1;   



