
# 📊 SQL Retail Sales Analysis Project

**Database Name**: `sql_project_p2`  
**Table Name**: `sales`  
**Objective**: Perform data cleaning, exploration, and analysis to extract key business insights from retail sales data using SQL.

---

## 🛠️ 1. Database and Table Creation

```sql
CREATE DATABASE sql_project_p2;

DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
    transaction_id     INT PRIMARY KEY,
    sale_date          DATE,
    sale_time          TIME,
    customer_id        INT,
    gender             VARCHAR(15),
    age                INT,
    category           VARCHAR(15),
    quantity           INT,
    price_per_unit     FLOAT,
    cogs               FLOAT,
    total_sale         FLOAT
);
```

---

## 🔍 2. Data Preview and Record Count

```sql
-- View Sample Records
SELECT * FROM sales
LIMIT 10;

-- Count Total Records
SELECT COUNT(*) FROM sales;
```

---

## 🧼 3. Data Cleaning – Handling NULLs

```sql
-- Find Rows with NULLs in Important Columns
SELECT * FROM sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- Delete NULL Records
DELETE FROM sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
```

---

## 📊 4. Data Exploration

```sql
-- Total Transactions
SELECT COUNT(*) AS total_sale FROM sales;

-- Unique Customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM sales;

-- Product Categories
SELECT DISTINCT category FROM sales;
```

---

## 🔎 5. Business Questions & Analysis

### Q1. Sales on '2022-11-05'
```sql
SELECT * FROM sales
WHERE sale_date = '2022-11-05';
```

### Q2. Clothing Sales > 4 Qty in Nov-2022
```sql
SELECT * FROM sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity >= 4;
```

### Q3. Total Sales by Category
```sql
SELECT category, SUM(total_sale) AS net_sale, COUNT(*) AS total_orders
FROM sales
GROUP BY category;
```

### Q4. Average Age of Beauty Buyers
```sql
SELECT ROUND(AVG(age), 2) AS avg_age
FROM sales
WHERE category = 'Beauty';
```

### Q5. Transactions With Total Sale > 1000
```sql
SELECT * FROM sales
WHERE total_sale > 1000;
```

### Q6. Transactions by Gender & Category
```sql
SELECT category, gender, COUNT(*) AS total_transaction
FROM sales
GROUP BY category, gender
ORDER BY category;
```

### Q7. Best Selling Month Each Year
```sql
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
```

### Q8. Top 5 Customers by Total Sales
```sql
SELECT customer_id, SUM(total_sale) AS total_spent
FROM sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;
```

### Q9. Unique Customers per Category
```sql
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM sales
GROUP BY category
ORDER BY unique_customers DESC;
```

### Q10. Number of Orders by Time Shift
```sql
WITH hourly_sales AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            WHEN EXTRACT(HOUR FROM sale_time) > 17 THEN 'Evening'
            ELSE 'Unknown'
        END AS shift
    FROM sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift;
```

---

## ✅ Summary

This project shows how to:
- Perform SQL-based **data cleaning**
- Explore and aggregate large datasets
- Answer **business-driven** analytical questions
- Use **window functions**, **grouping**, and **case logic**

Ideal for building a **data analyst portfolio project** or presenting in interviews.

---

## ✍️ Author

**Subhan Rahimoon**  
*Aspiring Data Analyst | Excel • SQL • Power BI • Python Learner*
