# SQL Assignment
-- IMDB Assignment
-- They have provided you the ERD diagrams

-- DDL Statements
-- 1. Create the database or Schema
-- 2. Alter Database/Tables
-- 3. Drop Database/schema/Tables

-- DML Statements
-- 1.  Select
-- 2. Insert
-- 3. Update
-- 4. Delete

-- Inspection
use IMDB;
-- fact table 
select * from movie;
select * from genre;
select * from ratings;
select * from role_mapping;
select * from names;
select * from director_mapping;
select * from names where id ='nm0003836';

-- How many unique movies are present
select count(distinct(id)) no_of_movies from movie;

-- Get count of movies country wise
select country, count(distinct(id)) no_of_movies from movie group by country order by no_of_movies desc;

-- How many countries are present in the dataset
select count(distinct(country)) from movie;

-- which year has the highest number of movies launched
select year,count(id) no_of_movies  from movie group by year order by no_of_movies desc;

-- Top 3 language in which most movies are launched
select languages, count(id) no_of_movies from movie group by languages order by no_of_movies desc limit 3;

-- Which the most preferable month where most movies are launched
select monthname(date_published) as `month`, count(id) no_of_movies from movie group by `month` order by no_of_movies desc;

-- yearly gross income
-- select year, sum(worlwide_gross_income) as total_gross from movie where worlwide_gross_income is not null group by year;

-- SQL internally handling typecasting
select year, sum(replace(worlwide_gross_income,'$ ','')) from movie group by year;

-- You can explicitly define the casting by using cast function
select year,sum(cast(replace(worlwide_gross_income,'$ ','') as float)) gross_income from movie group by year;

create view names_view 
as
select id,name,height,date_of_birth, coalesce(known_for_movies,'-') as known_for_movies from names;

select * from names_view;

-- gross income yearly across languages
select year,languages, sum(replace(worlwide_gross_income,'$ ',''))/1000000 as gross_income_millions from movie group by year,languages 
order by year, gross_income_millions desc;

-- find null values 
select * from movie where id is null or title is null or year is null or 
date_published is null or duration is null or country is null or languages is null or production_company is null;

select * from movie where languages is null;

select * from movie where worlwide_gross_income is null;

-- ratings
select * from ratings;

-- Top 10 outperforming movies
select m.title,r.avg_rating from movie m 
inner join ratings r
on m.id = r.movie_id order by r.avg_rating desc limit 10;

-- Top 3 most voted movies
select m.title,r.avg_rating, r.total_votes from movie m 
inner join ratings r
on m.id = r.movie_id order by r.total_votes desc limit 3;

-- genre
select genre, count(genre) as no_of_movies from genre group by genre order by no_of_movies desc;

-- year wise analysis with genre
select m.year, g.genre, count(m.id) no_of_movies from movie m 
inner join genre g
on m.id = g.movie_id group by m.year,g.genre order by no_of_movies desc;

-- role_mapping
-- How many actor and actress were there in each movie
select m.title,r.category, count(r.category) as roles from movie m
inner join role_mapping r 
on m.id = r.movie_id  group by m.title, r.category ;

-- count total number of actor and actress
select m.title,count(r.category) as roles from movie m
inner join role_mapping r 
on m.id = r.movie_id group by m.title order by roles desc;
 
-- count total number of actor and actress
select count(category) as roles from role_mapping;

-- find the age of the actors and actress
select n.*, year(current_date()) - year(n.date_of_birth) as age from names n;

-- % increase in gross income year by year where language is hindi (Advance question)
select year, sum(replace(worlwide_gross_income,'$ ','')) as total_gross_income from movie 
where languages='Hindi' group by year order by year asc;

-- window function - 1hr topic
create  view year_on_year_language_view 
as
select year, sum(replace(worlwide_gross_income,'$ ','')) as total_gross_income, 
lag(sum(replace(worlwide_gross_income,'$ ',''))) OVER( order by year asc)  as previous_year_income from movie 
where languages='Hindi' group by year order by year asc;

select yy.*, round(((yy.total_gross_income - yy.previous_year_income)/yy.previous_year_income) *100,2)  as percent_increase 
from year_on_year_language_view yy;

-- find the production company having highest gross income
select production_company, sum(replace(worlwide_gross_income,'$ ','')) as total_gross from movie 
group by production_company order by total_gross desc limit 1; 

-- -- find the production company having second highest gross income
select production_company, sum(replace(worlwide_gross_income,'$ ','')) as total_gross from movie 
group by production_company order by total_gross desc limit 1,1; 

-- find the names of actor and actress for cargo movie released in 2018
select m.title, m.year, m.country, r.category, n.name from movie  m 
inner join role_mapping r
inner join names n
on m.id = r.movie_id and
r.name_id = n.id
where m. title='Cargo' and m.year=2017;

-- If you want to filter the table on basis of columns which are present in table then use where clause
-- If you want to filter the table on basis of aggregated functions then use having clause. 
-- Having will always be applied on aggregated functions
 
-- where and having both example
 -- select all the movies form India where characters(Actors& actress) are greater than 5
 
  select m.title,m.country, count(r.category) as roles from movie m 
 inner join role_mapping r
 on m.id = r.movie_id
 where m.country ='India'
 group by m.id  having roles >5 order by roles desc;
 
 select m.year,g.genre, count(m.id) as no_of_movies from movie m
 inner join genre g 
 on m.id = g.movie_id group by m.year, g.genre;
 
 -- CTEs and windows
 WITH temp_table as 
 (select m.year,m.title,r.avg_rating, 
 dense_rank() OVER(partition by year order by r.avg_rating desc) as `rank` from movie m
 inner join ratings r 
 on m.id = r.movie_id group by m.year,m.title 
 order by m.year, r.avg_rating desc)
 select * from temp_table where `rank`<=5;
 
 
 select substring_index(worlwide_gross_income,' ',1) from movie;
 
 -- replace(worlwide_gross_income,substring_index(worlwide_gross_income,' ',1), '')
 
 -- simplify above query
select replace(worlwide_gross_income, substring_index(worlwide_gross_income,' ',1),'')/75 as total_gross from movie  
where substring_index(worlwide_gross_income,' ',1) != '$';

-- case condition
select m.*, 
(case m.worlwide_gross_income
when substring_index(m.worlwide_gross_income,' ',1) != '$' Then replace(m.worlwide_gross_income, substring_index(m.worlwide_gross_income,' ',1),'')
else replace(m.worlwide_gross_income, substring_index(m.worlwide_gross_income,' ',1),'')/75
end) as total_gross
from movie m;
 
