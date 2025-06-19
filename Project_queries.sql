-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;


-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM sales
LIMIT 10


    

SELECT 
    COUNT(*) 
FROM sales

-- Data Cleaning
SELECT * FROM sales
WHERE transactions_id IS NULL

SELECT * FROM sales
WHERE sale_date IS NULL

SELECT * FROM sales
WHERE sale_time IS NULL

SELECT * FROM sales
WHERE 
    transaction_id IS NULL
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
    
-- 
DELETE FROM sales
WHERE 
    transaction_id IS NULL
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
    
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM sales

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM sales



SELECT DISTINCT category FROM sales


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM sales
WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT 
  *
FROM sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM sales
GROUP BY 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM sales
WHERE category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM sales 
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT  category , gender , COUNT(*) AS total_transaction FROM sales
GROUP BY 1 ,2
ORDER BY 1; 


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
	   EXTRACT(YEAR FROM sale_date ) AS Yearly_sale ,
	   EXTRACT(MONTH FROM sale_date) AS Monthly_sale,
	   ROUND(AVG(total_sale),2)
FROM sales
GROUP BY EXTRACT(YEAR FROM sale_date ) ,
	   EXTRACT(MONTH FROM sale_date)
ORDER BY 1 DESC LIMIT 5;

SELECT 
	   EXTRACT(YEAR FROM sale_date ) AS Yearly_sale ,
	   EXTRACT(MONTH FROM sale_date) AS Monthly_sale,
	   ROUND(AVG(total_sale),2) AS avg_sale,
	   DENSE_RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date )  ORDER BY total_sale DESC )   
FROM sales
GROUP BY 1 ,2 , total_sale;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT year, month, monthly_total
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        SUM(total_sale) AS monthly_total,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY SUM(total_sale) DESC) AS rank_in_year
    FROM sales
    GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
) ranked_months
WHERE rank_in_year = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT * FROM sales;
SELECT customer_id , SUM(total_sale)  FROM SALES
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category , COUNT(DISTINCT customer_id) AS unique FROM sales
GROUP BY category
ORDER BY COUNT(DISTINCT customer_id) DESC;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)


 WITH hourely_sale AS (
 	SELECT * , 
	 CASE
	 	WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Moring'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 	THEN 'Afternoon'
		WHEN EXTRACT(HOUR FROM sale_time) > 17 THEN 'Evening' ELSE 'ERROR TIME'
	 END AS shift
	 FROM sales
 ) SELECT shift , COUNT(*) AS total_order FROM hourely_sale
 GROUP BY shift;






