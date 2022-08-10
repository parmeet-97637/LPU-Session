-- DDL : Create, Alter, Drop
create schema market_star_schema;

use market_star_schema;

create table test (
ID integer,
`Name` varchar(20),
Age int2,
salary decimal(12,2),
primary key (ID) 
);

-- select the table
select * from test;

-- delete the table
Drop table test;

-- drop the schema
drop schema market_star_schema;

create schema market_star_schema;

use market_star_schema;

-- apply constraints

create table test (
ID integer NOT NULL,
`Name` varchar(20) default NULL,
Age int2 default NULL,
salary decimal(12,2),
Gender varchar(1) Not NULL,
Joining_date date,
CHECK(salary>0),
primary key (ID) 
);

-- insert the values or rows in test table
insert into test VALUES(1, "Parmeet",27,50000,'M','2020-01-01');
-- check 
select * from test;

-- insert another record
insert into test (ID,`Name`,Age,Salary,Gender, Joining_date) VALUES(2,"Pavan",23,60000,'M','2019-05-01');
-- check
select * from test;

-- insert another record
insert into test (ID,Age,`Name`,joining_date,Salary,Gender) VALUES(3,27,'Shikha','2017-12-31',150000,'F');
-- check
select * from test;

-- insert multiple records
insert into test VALUES(4,'Madhukumar',21,40000,'M','2022-01-01'),(5,'Anit',18,750000,'M','2022-04-04');
-- check
select * from test;

-- select Name and Age of the employees
select name, age from test;

-- select the name of the employees whose age is greater than 25
-- we will use where clause to filter the rows or apply the condition
-- order of writing query - select, from, where
select name,age from test where age>25;

-- select employees where age is greater than 25 or salary is greater than 50000
-- or condition : either of the condition should be true 
select * from test where (age>25) or (salary>50000);

-- select  employees where age is greater than 21 and salary is greater than 50000
-- AND condition : both the conditions should be true
select * from test where (age>21) and (salary>50000);

-- insert few more records
insert into test  VALUES(6,'Vashishtha',26,470000,'M','2022-07-07'),(7,'Trishaan',31,167893,'M','2017-01-01'),(8,'Taniee',20,32000,'F','2021-09-06');
-- check 
select * from test;

-- select the employees whose age is between 23 and 27
-- between operator : include the extreme values
select * from test where age between 23 and 27;

-- select specific employees - Parmeet, Anit, Trishaan
-- In operator : to select multiple values
select * from test where name in ('Parmeet','Anit','Trishaan');

-- select all the employees whose name ends with "an".
-- 1an,paran,trishaan,aman
-- Like operator :
-- % : select any number of characters
-- _ : select only one character
select * from test where name like '%an';

-- select all the employees whose name starts with "pa"
select * from test where name like 'pa%';

-- select all the employess whose name contains "ee"
-- eeshan, taniee, parmeet
select * from test where name like '%ee%';

-- select all the employees who have character "a" at second position
select * from test where name like '_a%';

-- sorting 
-- orders : select, from, where, order by
-- sort all employees based on salary in descending order
select * from test order by salary desc;

-- select all employees based on age in ascending order
select * from test order by age asc;

-- select all employees whose age is greater than 21 and sort them on basis of their salary
select * from test where age>21 order by salary desc;

-- Aggregate functions : it will return only single value
-- select maximum salary
select max(salary) from test;

-- select minimum salary
select min(salary) from test;

-- select avg salary of employees
select avg(salary) from test;

-- select count of employees
select count(name) from test;

-- rename the column 
-- alias : as
select count(name) as employee_count from test;

-- Distinct keyword
-- select unique age from test table
select distinct(age) from test; 

-- count test table on basis of age
select count(age) from test;

-- count test table on basis of unique age
select count(distinct age) as distinct_employee_count from test;

-- Grouping
-- order : select from where group by order by

-- find the average salary of employees on basis of age
select name,age,avg(salary) from test group by age;

-- find the number of employees falling in same age
select age, count(name) as "employee_count" from test group by age;

-- find the average salary for male and females
select avg(salary),gender from test group by gender;

-- Aplying conditions to grouped objects
-- select avg salary of employees whose age is greater than 21
-- order : select from where group by 
select avg(salary),age from test where age>21 group by age;

-- find all the age where avg salary is greater than 100000
-- when ever you are applying filters on aggregate function using group by then you have to apply filter usinghaving condition
-- order  : select from where order by group by having
select avg(salary), age from test group by age having avg(salary)>100000;

-- select employes whose age is greater than 21 and avg salary is greater than 100000
select age,avg(salary) from test where age>21 group by age having avg(salary)>100000;

-- select employes whose age is greater than 21 and avg salary is greater than 100000 order on basis of salary in ascending order
select age,avg(salary) from test where age>21 group by age having avg(salary)>100000 order by avg(salary) asc;


