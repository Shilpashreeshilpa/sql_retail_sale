-- SQL rETAIL SALES ANALYSIS-P1
CREATE DATABASE sql_project_p2;

-- CREATE TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
( 				
				transactions_id	INT PRIMARY KEY,
				sale_date  DATE,
				sale_time  TIME,	
				customer_id	INT,
				gender	VARCHAR(15),
				age	  INT,
				category VARCHAR(15),	
				quantity	INT,
				price_per_unit	FLOAT,
				cogs	FLOAT,
				total_sale FLOAT
);
SELECT * FROM retail_sales
LIMIT 10


SELECT  COUNT (*) FROM retail_sales

SELECT * FROM retail_sales
WHERE sale_time is NULL

SELECT * FROM retail_sales
WHERE 
	transactions_id is null
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- delete rows (null)
DELETE FROM retail_sales
WHERE 
	transactions_id is null
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--data exploration
--HOW MANY SALES--
SELECT COUNT(*) AS total_sale FROM retail_sales
--HOW MANY  unique customers
SELECT COUNT( DISTINCT customer_id) AS total_sale FROM retail_sales
--HOW MANY  unique customers

SELECT DISTINCT category FROM retail_sales



--data analysis

-- sql query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
where sale_date = '2022-11-05';

--sql query  to retrieve all transactions where the category is Clothing and quantity sold is  more than 10 in month of nov-2022

SELECT * 
FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR (sale_date ,'YYYY-MM') = '2022-11' 
	AND
	quantity >= 4


-- sql query to calculate the total sales for each category

SELECT 
	category,
	sum(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1


--sql query to find the average age of customers who puchased items from beauty category

SELECT 
ROUND(AVG (age),2) as average_age
FROM retail_sales
where category= 'Beauty'


--sql query to find all transactions where the total_sale is greater than 1000
select * FROM retail_sales
where
total_sale > 1000;

--sql query to find total number of transactions (trabsaction_id) made by each gender n eanch catgeory

SELECT
 category,
 gender,
 count(*) as total_trad
 FROM retail_sales
 group by category,
 gender
 order by 1
 
--sql query to calculate the average sale for each month .finf out best selling month in each year
SELECT
year,
month,
avg_sale
FROM 
(
SELECT 
	EXTRACT (YEAR FROM sale_date) as year,
	
	EXTRACT (MONTH FROM sale_date) as month,
	AVG(total_sale) AS avg_sale,
	RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
FROM retail_sales
group by 1, 2
) as t1
where rank = 1

--sql query to find top 5 customers based on highest total sales

SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- SQL QUERY TO  FIND UNIQUE CUSTOMERS WHO PURCHASED ITEMS FORM EACH CATEGORY

SELECT
category,
count( DISTINCT customer_id) as uniquecustomers

FROM retail_sales
group by category

--sql query to creat each shift and number of orders ( ex morning <=12,afternoon between 12 & 17,evenning >17)
 
 WITH hourly_sale
 AS
 (
 SELECT *,
 case
	 when  EXTRACT(HOUR FROM sale_time) < 12 then 'Morning'
 	when  EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 then 'Afternoon'
 	else 'Evening'
 	end as shift 
 FROM retail_sales
 )
Select 
shift,
count(*)as total_orders
from hourly_sale
group by shift
