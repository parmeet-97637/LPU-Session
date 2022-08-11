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


