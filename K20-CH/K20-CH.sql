select current_date();
select current_time();

-- creating the schema
create schema market_star_schema;

-- Drop the schema
drop schema market_star_schema;

-- creating the schema
create schema market_star_schema;

-- which schema to use
use market_star_schema;

-- create the tables
create table employee (
ID integer not null,
Name varchar(20) default null,
Gender char(1) default null,
Salary decimal(12,2) default null,
Age int2 default null,
Joining_date date default null,
CHECK(Salary>0),
Primary key (ID)
);

-- delete the table
drop table employee;

-- create the tables
create table employee (
ID integer not null,
Name varchar(20) default null,
Gender char(1) default null,
Salary decimal(12,2) default null,
Age int2 default null,
Joining_date date default null,
CHECK(Salary>0),
Primary key (ID)
);
-- check
select * from employee;

-- insert the records 
insert into employee VALUES(1,'Parmeet','M',2567932,27,'2017-01-01');
-- check
select * from employee;

-- inserting another record
insert into employee (ID,Name,Gender,Salary,Age, Joining_date) VALUES(2,'Taniee','F',4356798,24,'2019-05-05');
-- check
select * from employee;

-- inserting another record
insert into employee (Name, salary, Age, ID, joining_date,Gender) Values('Trishaan',120000,21,3,'2021-12-31','M');
-- check
select * from employee;

-- insert multiple records at a same time
insert into employee values(4,'Anit','M',32000,30,'2022-02-02'),(5,'Shikha','F',52900,25,'2022-05-19'),(6,'Trisha','F',45690,25,'2020-06-04');
-- check
select * from employee;

-- insert another record with missing column
insert into employee VAlUES(7, 'Mansi','F',539900,NULL,'2022-08-01');
-- check 
select * from employee;

-- insert a new record with salary <0 
-- check constraint
insert into employee values (8,'Mohan','M',-678888,22,'2022-08-01');

-- filter the columns
-- selecting only few columns
-- select Name and joining_date of the employees
select Name,joining_date from employee;

-- filter the rows
-- where clause followed by a condition would filter the rows
-- order : select, from, where
-- select the employees whose age is greater than 25
select * from employee where Age>25;

-- select all the male employees whose salary is greater than 50000
-- two conditions demonstration using and operator
-- And operator : both the conditions should be true then only records will be fetched
select * from employee where (gender='M') and (salary>50000);

-- select all the employee whose age is either greater than 27 or having salary greater than 60K.
-- or operator : either of the condition should be true
select * from employee where (age>27) or (salary>60000);

-- select the employee whose age is between 25 and 30
-- between operator includes the extreme values
select * from employee where age between 25 and 30;

-- select the following employee details : parmeet, taniee and shikha
-- in operator : to select multiple values in one go
select * from employee where name in('Parmeet','Taniee','Shikha');

-- select all the employees whose name starts with "T"
-- Trish, Tina,Taniee, T + followed by any number of characters
-- Like operator
-- % : any number of characters
-- _ : any single character
select * from employee where name like 'T%';

-- select all the employee whose name ends with "T"
-- parmeet, anit
select * from employee where name like '%T';

-- select all the employees whose name contains "ee"
-- eeshan, parmeet, taniee
select * from employee where name like'%ee%';

-- sorting
-- sort the employees on the basis of salary in descending order
-- order : select, from, where, order by
select * from employee order by salary desc;

-- sort the employee on the basis of age in ascending order
select * from employee order by age asc;

-- sort all the female employees on basis of age in ascending order
select * from employee where gender='F' order by age asc;

-- select the employee who has "a" at the second position
select * from employee where name like '_a%';

-- Aggregate function
-- They would always return the single value
-- max, min, count, avg
-- select maximum salary of the employee
select max(salary) from employee;

-- select minimum age of the employee
select min(age) from employee;

-- select the count of employees
select count(name) from employee;

-- select the average salary fo the employee
select avg(salary) from employee;

--  alias
select avg(salary) as "Avg_sal" from employee;

-- select the distinct age
select distinct age from employee;

-- count the distinct age
select count(distinct age) from employee;

-- group by
-- pandas : pd.groupby, pd.pivot_table
-- excel : pivot_table
-- order : select, from, where, group by,order by
-- withe group by you would have aggregate function

-- select average age of male and female
select gender, avg(age) as avg_age from employee group by gender order by avg_age;

-- select avg salary of employee under each age
select age, avg(salary) from employee group by age;

-- find the count of male and female employees
select gender,count(name) as count_of_employee from employee group by gender;

-- select the average salary of male employees for each group
select avg(salary), age from employee where gender='M' group by age;

-- Having clause
-- This is always used with group by function
-- Having clause is used to filter the aggregate functions
-- order : select, from, where, group by, having

-- select avg salary greater than 50k of all employees by age
select age, avg(salary) from employee group by age having avg(salary)>50000;

-- select avg salary greater than 50k of all male employees by age
select age, avg(salary),gender from employee where gender='M' group by age having avg(salary)>50000;

-- Functions
-- names to be in upper case
select upper(name)  as Name from employee;

-- lower case
select lower(name) as Name from employee;

-- substring
select substring(name,1,3) as first_3_letter, name from employee;

-- index of any character
-- substring_index(text_name, delimiter, string)
select substring_index("www.upgrad.com",'.',1);
select substring_index("www.upgrad.com",'.',2);

-- length
-- select the length of names of all employees
select name, length(name) as size from employee;

-- reverse a string
select name, reverse(name) from employee;

-- extract the month from the date
select month(current_date());

-- extract month name 
select monthname(current_date());

-- extract curent year
select year(current_date());

-- extract dayname
select dayname(current_date());

-- select day of month
select dayofmonth(current_date());

-- convert string date to date type
select str_to_date('10,03,2022','%d,%m,%Y');
select str_to_date('10,03,22','%d,%m,%y');

-- select all the employee where we donot have any null values
select * from employee where age is not null;

-- select all employees where age is missing
select * from employee where age is null;
