-- selecting all the columns
select * from cust_dimen;

-- select only few columns or filter columns
select cust_id, customer_name,customer_segment from cust_dimen;

-- select distinct city from cust_dimen
select distinct city from cust_dimen;

-- filter the rows (select customers who are into small business)
-- we will use "WHERE" clause to filter the rows
select * from cust_dimen where Customer_segment ="SMALL BUSINESS";

-- apply mutliple filters : using "AND" operator
-- select customers who has small business and who belongs to Mysore
-- for AND operator : BOTH THE CONDITIONS SHOULD BE TRUE
select * from cust_dimen where customer_segment ="SMALL BUSINESS" and City ="Mysore";

-- apply multiple filters :"OR" Operator
-- select customers who has small business or who resides in Karnataka
-- Now the output will be based on either customer belongs to Karnataka or he/she has small business
-- For or operator : either of the condition will be true
select * from cust_dimen where Customer_segment ="SMALL BUSINESS" or State ="Karanataka";

-- we can also select multiple values in one go
-- select customers who belongs to westbengal, karnataka and maharashtra
-- using "IN"operator
select * from cust_dimen where State in ('WEST Bengal','Karnataka','Maharashtra');

-- "between operator"
-- select the customer_id whose order shipping cost is between 5 and 10 (both inclusive)
select * from market_fact_full where shipping_cost between 5 and 10;

-- select the customers whose order_id ends with "_5"
-- "LIKE" operator
-- % means any number of characters
-- _ means any single character
-- \ means escape character
select * from market_fact_full where ord_id LIKE '%\_5';
-- without escape character
select * from market_fact_full where ord_id LIKE '%_5';

-- select customer names starting with CLA
select * from cust_dimen where customer_name like 'CLA%';

-- select the customer names which contains 'IRE'
select * from cust_dimen where customer_name like '%IRE%';

-- Aggregate Functions in SQL 
-- they would return the single value
-- sum
-- count
-- avg
-- min
-- max

-- select maximum sales value from market_fact_full table
select max(sales) from market_fact_full;

-- select the minimum sales
select min(sales) from market_fact_full;

-- find the average sales
select avg(sales) from market_fact_full;

-- count the number of customers in cust_dimen table
select count(cust_id) from cust_dimen;

-- count the number of unique customer
select count(distinct cust_id) from cust_dimen;

-- let us sort the rows on basis of sales values in descending order
select * from market_fact_full order by sales desc;

-- sort the table on basis of discount in ascending order
select * from market_fact_full order by Discount asc;









