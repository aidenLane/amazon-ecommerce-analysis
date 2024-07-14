/*
Data Exploration for Amazon Sales Data
Aiden Lane
July 2024
*/

-- Goal: Find direction for further analysis, as well as discover any 
-- issues (dirty data) that should be dealt with.

-- Peek at top 5 rows from dataset
SELECT * FROM amazon_sales ORDER BY index ASC LIMIT 5;

-- Range of Dates
SELECT MIN(sale_date), MAX(sale_date) FROM amazon_sales;

-- Now, finding counts for categorical variables that may be relevant.

-- Find frequency of different sales channels
SELECT sales_channel, COUNT(sales_channel),
	ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER()::numeric,2) AS percentage
FROM amazon_sales
GROUP BY sales_channel;

-- Find frequency of each order status
SELECT status, COUNT(status),
	ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER()::numeric,2) AS percentage
FROM amazon_sales
GROUP BY status;

-- Find frequency of each order status by status category
SELECT status_category, COUNT(status_category),
	ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER()::numeric,2) AS percentage
FROM amazon_sales
GROUP BY status_category;

-- Find distribution of product categories
SELECT category, COUNT(category), 
	ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER()::numeric,2) AS percentage
FROM amazon_sales
GROUP BY category;

SELECT category, COUNT(category), 
	ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER()::numeric,2) AS percentage
FROM amazon_sales
GROUP BY category
ORDER BY COUNT(category) DESC
LIMIT 5;
-- From this its very apparent the two most ordered product categories
-- are 'Set' and 'Kurta' which each share large portion of total sales for 
-- this time period (Roughly 77-78% of all sales).

-- Find which currencies are used (In case more cleaning must 
-- be done to convert currencies)
SELECT currency, count(currency),
	ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER()::numeric,2) AS percentage
FROM amazon_sales
GROUP BY currency;
-- Some currencies are left null

SELECT COUNT(*)
FROM amazon_sales
WHERE amount is NOT NULL;
-- So, where currency is null, amount is null as well. Must be cancelled order.

-- Now, lets look at number of sales by geographical region. In this case, 
-- the data has the state/union territory information so it will be used. Note 
-- this data has already been cleaned.
SELECT ship_state, COUNT(index),
	ROUND(COUNT(index)*100.0/SUM(COUNT(index)) OVER()::numeric,2) AS percentage 
FROM amazon_sales
GROUP BY ship_state;

-- Now lets just see the top 10 states/union territories from above query
SELECT ship_state, COUNT(index),
	ROUND(COUNT(index)*100.0/SUM(COUNT(index)) OVER()::numeric,2) AS percentage 
FROM amazon_sales
GROUP BY ship_state
ORDER BY SUM(index) DESC
LIMIT 10;

-- Revenue and Sales over month
SELECT to_char(date_trunc('month',sale_date),'YYYY-MM') AS month, COUNT(index) as Sales,
	ROUND(SUM(amount)::numeric,2) as Revenue
FROM amazon_sales
GROUP BY month
ORDER BY revenue DESC;
-- Note that march's data is based on just one day (March 31) that was present in 
-- dataset. It seems that April was the most profitable month, but each month had 
-- somewhat similar revenue share, however June had less sales.

-- Examine relevant numerical data
SELECT ROUND(AVG(amount)::numeric,2) AS "Average Order Amount (INR)",
	ROUND(STDDEV(amount)::numeric,2) AS "Standard Deviation for Order Amount",
	MIN(amount),
	MAX(amount)
FROM amazon_sales;

/*
Examine odd case when the courier status is left blank, 
but the order was not cancelled by customer.
*/
SELECT * 
FROM amazon_sales 
WHERE courier_status IS NULL 
AND status!='Cancelled';
-- Seems that these cases each have been shipped to either the buyer or 
-- returned to the seller. However, the quantity of product ordered is 0 in all
-- of these rows. 

-- Examine this case further
SELECT * 
FROM amazon_sales
WHERE quantity=0;
-- Many courier statuses are stated as cancelled, lets find the non-cancelled cases

SELECT * 
FROM amazon_sales
WHERE quantity=0 
	AND status!='Cancelled';
-- There seems to be 106 rows where the quantity column is left blank but the order was
-- not cancelled. However it is apparent that in each of these rows, the amount column
-- is left null, so it can be left as is.

