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
-- with group by you would have aggregate function

-- select average age of male and female
select gender, avg(age) as avg_age from employee group by gender order by avg_age;

-- select avg salary of employee under each age
select age, avg(salary) from employee group by age;

-- find the count of male and female employees
select gender,count(name) as count_of_employee from employee group by gender;

-- select the average salary of male employees for each age group
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

-- select all the employee where we donot have any null values
select * from employee where age is not null;

-- select all employees where age is missing
select * from employee where age is null;

-- Views
-- 1. Views are read only
-- 2. Views are the virtual tables created from a single or multiple tables
-- 3. Advanctages : Data Security as it is read only

create view employee_view
as
select * from employee where gender='M';

-- check
select * from employee_view;

-- drop the view
drop view employee_view;

-- Nested queries or sub queries
create table personal_details (
Sno integer,
bank_balance decimal(12,2),
city varchar(20),
address_type varchar(20),
constraint Sno foreign key(Sno) references employee(ID)
);

-- insert the records
insert into personal_details VALUES(1,4567,'Indore','Permanent'),(1,1200,'Pune','Current'),(2,6789,'Pune','Permaenent'),(3,8900,'Bengaluru','Current');
insert into personal_details VALUES(4,45607,'Bhopal','Permanent'),(1,12000,'Chennai','Current'),(5,6789,'Mumbai','Current');
insert into personal_details VALUES(6,4560907,'Bhopal','Permanent');
-- check
select * from personal_detail;
select avg(bank_balance) from personal_details;
-- select the employees whose salary is greater than avg(bank_balance) of all employees
select * from employee where salary > (select avg(bank_balance) from personal_details);

-- Joins
-- Inner join
-- Outer Join
-- Right Join
-- Left Join
-- Cross Join

-- Inner join
-- select the employees whose personal details are present
select * from employee e inner join personal_details p  on e.ID = p.Sno;

-- select the employees with their total bank balance
select e.Name, e.Salary, e.Age, e.Joining_date, sum(p.bank_balance) as total_balance
from employee e inner join personal_details p on e.Id=p.Sno
group by p.Sno;

-- right join
select * from employee e right join personal_details p on e.Id=p.Sno;

-- left join
select * from employee e left join personal_details p on e.Id=p.Sno;

-- union
create table details (
s_no integer,
bank_balance decimal(12,2),
city varchar(20),
address_type varchar(20),
constraint s_no foreign key(s_no) references employee(ID)
);

-- insert the record
insert into details values(7,123459,'Pune','Current'), (6,4560907,'Bhopal','Permanent');

-- check
select * from details;

-- union
-- 1. Structure of the tables to combine should be same
-- 2. It will remove/exclude duplicate records
select * from personal_details
union
select * from details;

-- union ALL
-- 1. It will include the duplicate records

select * from personal_details
union ALL
select * from details;

-- create a view for above table
create view personal_details_view
as
select * from personal_details
union ALL
select * from details;

-- check
select * from personal_details_View;

-- select the duplicate Ids
select sno,count(sno)from personal_details_view group by sno having count(sno)>1;

-- duplicate records
select sno, count(sno) from personal_details_view 
group by sno, bank_balance, city, address_type having count(sno)>1;

-- outer join
-- 1. It is the combination/union of left and right join

select * from employee e right join personal_details p on e.Id = p.Sno
union
select * from employee e left join personal_details p on e.Id = p.Sno;

-- cross join
select count(*) from employee e cross join personal_details p;

-- update function
 -- updating the Sno from 1 to 2 where city is chennai
 
 select * from personal_details where Sno=1 and city='chennai';

-- syntax : update table_name set column_name=value where condition

-- trun on safe sql updates
SET SQL_SAFE_UPDATES =0;

update personal_details set Sno =2 where Sno=1 and city='chennai';

-- check 
select * from personal_details where Sno=1 and city='chennai';
select * from personal_details where Sno=2 and city='chennai';
-- trun off safe sql updates
SET SQL_SAFE_UPDATES =1;

-- update the age of missing employees to 21
select * from employee where age is NULL;

# turn on sql safe updates
SET SQL_SAFE_UPDATES =0;

# update
update employee set Age=21  where age is NULL;

# check table
select * from employee where age is NULL;
select * from employee where age =21;

-- Alter function
-- 1. It is used to alter the table
-- changing the data type of age from smallint to int
alter table employee
modify column Age integer;

-- add a new column in personal details : emailid
alter table personal_details
ADD column emailid varchar(25);

-- check
select * from personal_details;

-- update
update personal_details set emailid ='p@gmail.com' where Sno=1;
update personal_details set emailid ='s@gmail.com' where Sno=2;
update personal_details set emailid ='k@gmail.com' where Sno=3;
update personal_details set emailid ='l@gmail.com' where Sno=4;
update personal_details set emailid ='m@gmail.com' where Sno=5;

-- limit
-- sleect first 5 records from employee
select * from employee limit 5;

-- select the employee with second highest salary
select * from employee order by salary desc limit 2;

# add offset to limit
select * from employee order by salary desc limit 1,1;

-- sleect the third highest salary
select * from employee order by salary desc limit 2,1;

-- exists
# syntax : select * from table_name where exists (select coumn_name from table_name where condition)

-- select all the employees personal details where ID =1
select * from employee where exists (select bank_balance from personal_details where id=1);

-- select all the employees personal details where sum of bank_balance is greaer than 50K
select * from employee where exists(select sum(bank_balance) from personal_details where city ='Chennai' group by sno having sum(bank_balance)>5000);

-- Any operator
-- getting employees Id where bank_balance is greater than 50K
select * from employee where ID = ANY (select Sno from personal_details where bank_balance>50000);
select * from employee where ID = ANY (select Sno from personal_details where address_type='Permanent');

-- ALL
select * from employee where ID = ALL (select Sno from personal_details where address_type='Permanent');

