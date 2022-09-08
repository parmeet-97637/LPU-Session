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
when '1' Then 'M'
when '0' Then 'F'
else 'O' 
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
