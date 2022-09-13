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
