select current_date();
select current_time();

-- create the schema
create schema market_star_schema;

-- use schema
use market_star_schema;

-- create a table
create table employee (
ID integer NOT NULL,
`Name` varchar(20) default NULL,
Gender char(1) default NULL,
salary decimal(12,2) default NULL,
joining_date date default NULL,
Age int2 default NULL,
primary key (ID)
);

-- delete the table
Drop table employee;

-- delete the schema
Drop schema market_star_schema;
----------------------------------------------------------------
-- create the schema
create schema market_star_schema;

-- use schema
use market_star_schema;

-- create a table
create table employee (
ID integer NOT NULL,
`Name` varchar(20) default NULL,
Gender char(1) default NULL,
salary decimal(12,2) default NULL,
joining_date date default NULL,
Age int2 default NULL,
primary key (ID)
);

-- insert the records or rows in the employee
insert into employee VALUES(1, "Parmeet", 'M', 567890,'2020-01-01',27);
-- check
select * from employee;

-- inserting another record
insert into employee (ID, Name, Gender, salary, joining_date, Age) VALUES(2,'Taniee','F',34567,'2022-02-02',24);
-- check
select * from employee;

-- inerting another record
insert into employee (Name, salary, joining_date, ID, Age) VALUES('Trishaan',150000,'2018-01-01',3,25);
-- check 
select * from employee;

-- insert multiple records 
insert into employee VALUES(4,'Shikha','F',345621,'2014-12-12',30),(5,'Anit','M',75900,'2019-05-05',25);
-- check
select * from employee;

-- select only Name and gender column 
-- filter the columns
select `Name`,Gender from employee; 

-- filter the rows
-- order : select, from, where
-- select the employees whose age is greater than 25
select * from employee where age>25;

-- select the Name and joining_date of employee whose age is less than 25
select name,joining_date,age from employee where age<25;

-- select the employees whose age is greater than 25 and who are males
-- And condition : both the conditions should be true
select * from employee where (age>25) and (gender='M');

-- select the employee whose salary is greater than 50K or who are feamles
-- or condition : only one condition can be true
select * from employee where (salary>50000) or (gender='F');

-- In operator : used to select the multiple values
-- select employeee whose age is 25,27,and 30
select * from employee where age in (25,27,30);

-- Between operator : it will include all the extreme values
-- select all the employee whose age falls between 21 and 25
select * from employee where age between 21 and 25;

-- Like operator : 
-- % : select any number of characters
-- _ : select any single character

-- select the employees whose name startes with "T".
select * from employee where name like 'T%';

-- select the employees whose name ends with "T".
select * from employee where name like '%T';

-- select the employee whose name contains "ee".
-- eeshan, Taniee, parmeet
select * from employee where name like '%ee%';

-- select the employee whose name has "a" at the third position
-- CBA, zeanab
select * from employee where name like '__a%';

-- select the employee whose name has "a" at the second position 
select * from employee where name like '_a%';

-- sorting the table
-- orders : select, from, where, order by
-- select the employee based on age in ascending order
select * from employee order by age asc;

-- select all the male employees and sort them in descending order of their age
select * from employee where gender='M' order by age desc;

-- select all the employees and sort them on basis of salary in desc order
select * from employee order by salary desc;

-- Aggregate Functions : Numerical columns, 
-- Will return single values
-- max, min, count, avg

-- select the maximum salary of the employees
select max(salary) from employee;

-- select minimum age of the employee
select min(age) from employee;

-- select avg salary of employee
select avg(salary) from employee;

-- count the number of employees working in an organization
select count(ID) as no_of_employee from employee;

-- find the unique age 
select distinct(age) from employee;

-- count the employees with unique age
select count(distinct(age)) from employee;

-- Group By Clause
-- Pandas : pd.pivot_table, pd.groupby
-- excel : pivots
-- sql : group by
-- order : select, from, where, group by

-- select maximum salary for male and female employee
select max(salary),Gender from employee group by Gender;
-- excluding NULL
select max(salary),Gender from employee where Gender is not null group by Gender;
-- include only NULL
select max(salary),Gender from employee where Gender is null group by Gender;

-- select average salary of employees in each age group
select age,avg(salary) as average_salary from employee group by age;

-- select average salary of employees in each age group only for males
select age, avg(salary) as avg_sal from employee where Gender='M' group by age;

-- select average salary of employees in each age group only for males who are having avg salary greater than 85K
-- Having clause : 
--              1. It is used with group by
--              2. It is used to apply filters on the aggregate functions

-- order: select, from, where, group by, having
select age, avg(salary) as avg_sal from employee where Gender='M' group by age having avg(salary)>85000;

-- Views 
-- 1. They are read only. You cannot update views
-- 2. View is a virtual table created as  a result of operations on a single or multiple tables
-- 3. Advantage of view: Data security as it is read only mode

-- create view for all the male employees
create view employee_view 
as 
select * from employee where Gender='M';

-- check : All male records are created in employee_view
select * from employee_view;

-- delete the view
drop view employee_view;

-- Nested Queries or Sub queries
-- Applying referential contraint to the below table
create table personal_details (
SNo integer,
mob_no int8,
bank_balance decimal(12,2),
city varchar(20),
address_type varchar(20),
constraint Sno foreign key(Sno) references employee(ID)
);


-- insert the records
insert into personal_details 
VALUES(1,9999999999,6000,'Indore','Permanent'),(1,9989898988,700000,'Pune','Current'),
(2,9999888876,650,'Bhopal','Permanent'),
(5,1234567890,1200,'Pune','Permanent'),
(4,9876543234,45000,'Bengaluru','Current');

-- select the employees where salary is greater than avg bank_balance
select * from employee where salary>
(select avg(bank_balance) from personal_details);

-- joins
-- Inner Join
-- Left join
-- Right Join
-- Outer join or Full outer join
-- Cross Join

-- inner join on employee and personal_details
select * from employee e inner join personal_details p on e.Id=p.Sno; 

select e.ID,e.Name,e.Gender,e.salary,sum(p.bank_balance)  as total_balance from employee e inner join personal_details p on e.Id=p.Sno group by Sno; 

-- right join
select * from employee e right join personal_details p on e.Id = p.Sno;

-- left join
select * from employee e left join personal_details p on e.Id = p.Sno;

-- union
create table details (
ID integer,
mob_no int8,
bank_balance decimal(12,2),
city varchar(20),
address_type varchar(20),
constraint ID foreign key(ID) references employee(ID)
);

insert into details 
VALUES(3,9999999999,6000,'Patna','Permanent'),(3,9989898988,700000,'Pune','Current');

insert into details VALUES(2,9999888876,650,'Bhopal','Permanent');

-- union
-- exclude the duplicate values
select * from personal_details
union
select * from details;
 
 -- union all
 -- it will include the duplicate values
 select * from personal_details
union all
select * from details;

 
 -- view for above tables
 create view personal_details_view
 as
 
select * from personal_details
union
select * from details;

-- check
select * from personal_details_view;
 
-- outer  join
select * from employee e right join personal_details p on e.Id = p.Sno
union
select * from employee e left join personal_details p on e.Id = p.Sno;

-- cross join
select count(*) from employee e cross join personal_details p;
