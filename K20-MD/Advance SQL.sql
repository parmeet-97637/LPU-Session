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
 
-- LAG with offset and default
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

 


