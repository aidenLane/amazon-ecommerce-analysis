/*
Data Cleaning for Amazon Sales Data
Aiden Lane
July 2024
*/

-- First, have a peek at top five rows

SELECT * FROM amazon_sales ORDER BY index ASC LIMIT 5;

/*
First, want to reconfigure these poorly formatted column names
for the ease of SQL and PowerBI analysis. More SQL friendly column names

*/

--Rename 'Date' column to simplify upcoming queries
ALTER TABLE amazon_sales
RENAME COLUMN "Date" TO sale_date;

--Hidden space after column name
ALTER TABLE amazon_sales
RENAME COLUMN "Sales Channel " TO sales_channel;

ALTER TABLE amazon_sales
RENAME COLUMN "Courier Status" TO courier_status;

ALTER TABLE amazon_sales
RENAME COLUMN "Order ID" TO order_id;

ALTER TABLE amazon_sales
RENAME COLUMN "Status" TO status;

ALTER TABLE amazon_sales
RENAME COLUMN "Fulfilment" TO fulfilment;

ALTER TABLE amazon_sales
RENAME COLUMN "ship-service-level" TO ship_service_level;

ALTER TABLE amazon_sales
RENAME COLUMN "Style" TO style;

ALTER TABLE amazon_sales
RENAME COLUMN "SKU" TO SKU;

ALTER TABLE amazon_sales
RENAME COLUMN "Category" TO category;

ALTER TABLE amazon_sales
RENAME COLUMN "ASIN" TO ASIN;

ALTER TABLE amazon_sales
RENAME COLUMN "Qty" TO quantity;

ALTER TABLE amazon_sales
RENAME COLUMN "Amount" TO amount;

ALTER TABLE amazon_sales
RENAME COLUMN "ship-city" TO ship_city;

ALTER TABLE amazon_sales
RENAME COLUMN "ship-state" TO ship_state;

ALTER TABLE amazon_sales
RENAME COLUMN "ship-postal-code" TO ship_postal;

ALTER TABLE amazon_sales
RENAME COLUMN "B2B" TO b2b;

ALTER TABLE amazon_sales
RENAME COLUMN "fulfilled-by" TO fulfilled_by;

/*
Change date formatting for sale_date column from MM-DD-YY to 
standard date format of YYYY-MM-DD (in sql/pbi?)
*/

UPDATE amazon_sales SET sale_date = TO_DATE(sale_date, 'MM-DD-YY');

ALTER TABLE amazon_sales
ALTER COLUMN sale_date TYPE DATE
USING sale_date::date;

/*
Check for null or duplicate values
*/

-- Check if any rows are exact duplicates
SELECT index, count(index)
FROM amazon_sales
GROUP BY index
HAVING count(index) > 1;

/*
Remove unnecessary columns that may not be needed for the purposes 
of our analysis.
*/
ALTER TABLE amazon_sales
DROP COLUMN "ship-country", 
DROP COLUMN "promotion-ids", 
DROP COLUMN	"Unnamed: 22";

/*
Create new column to better categorize each status type
*/
ALTER TABLE amazon_sales 
ADD COLUMN status_category TEXT;

UPDATE amazon_sales
SET status_category = CASE
	WHEN status = 'Cancelled' 
		THEN 'Cancelled'      
	WHEN status IN ('Pending', 'Pending - Waiting for Pick Up') 
		THEN 'Pending'
	WHEN status IN ('Shipped - Damaged', 'Shipped - Lost in Transit',
	'Shipped - Rejected by Buyer', 'Shipped - Returned to Seller', 
	'Shipped - Returning to Seller') 
		THEN 'Shipping Error'
	WHEN status IN ('Shipped', 'Shipped - Delivered to Buyer', 
	'Shipped - Out for Delivery', 'Shipped - Picked Up', 'Shipping')
		THEN 'Shipped'
	ELSE NULL
END;

-- Verify that there are no nulls
SELECT * FROM amazon_sales WHERE status_category IS NULL;
-- So, there is no real need for an else case