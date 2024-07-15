# Amazon India Sales Analysis

## Table of Contents
[1. Project Overview](#project-overview)

[2. Setting up Database](#setting-up-database)

[3. Data Cleaning](#data-cleaning)

[4. Exploring the Data](#exploring-the-data)

[5. Data Visualization](#data-visualization)

[6. Conclusion](#conclusion)

[7. References](#references)


### Project Overview
This project aims to analyze data gathered from Amazon India from March 31 to June 29, 2022 to gain insights into sales performance, order statuses, and geographical distribution of customers. SQL is employed to both explore and clean the data, ensuring the data is prepared and accurate for analysis. Then, to visualize the most important insights, PowerBI is used to make a simple yet effective dashboard. From these findings, it is hoped that more action can be taken to optimize sales for the future by closely examining relevant factors.

### Setting up Database

Similar to my past work, I made use of SQLAlchemy and psycopg2 to transfer the contents from the CSV file to a local PostgreSQL server. This method of moving data is much more efficient as the columns are quickly made and can be re-run to load new data to the database. Please find the [Python notebook](https://github.com/aidenLane/amazon-ecommerce-analysis/blob/main/load_to_sql.ipynb) that I created for this purpose.

### Data Cleaning

First of all, when examining the names given to the columns in the original CSV, I noticed they were not very SQL-friendly. So, I prioritized reconfiguring those before even thinking about cleaning the data itself. Most of these cases were just removing capital lettering, however some required more care (For example, the sales channel column originally had a space at the end of the name as well as a space between the words). Also, dashes were converted to underscores as SQL does not allow column names to have special characters.

Next, the date formatting was addressed. Originally, the dataset had date in format 'MM-DD-YY' so it was changed to 'YYYY-MM-DD' to be more compatible with SQL/PowerBI. 

Next, I checked for duplicate row values by examining if any index occured more than once. Fortunately, there were none. Also, removed some unnecessary columns (for our analysis).

Upon examining the status field, I found that there were many different variations of status that were perhaps unnecessary. 

![image](https://github.com/aidenLane/amazon-ecommerce-analysis/assets/55153752/85c96573-7472-45a2-abd2-1a904d338036)

So, to make things more efficient moving forward for the purpose of analysis, a new column was created, called 'status_category', to better classify each row's status. Used values 'Cancelled', 'Pending', 'Shipping Error', and 'Shipped' for this column.

After moving to the data exploration step, I noticed that the ship_state names were very poorly formatted and required a lot of cleaning. For example, see the image of a part of a query below.

![image](https://github.com/user-attachments/assets/4288f735-b7c6-4c65-8fc0-c6b208e0813c)

From the bottom few rows, it is apparent there are many values for 'Delhi' and also, from the top few rows there are some abbreviations. These values had to be cleaned.

I used the formatting for each state/union territory as it stated is in the India States JSON file which I was using to display data geographically in PowerBI. Then, changed each variant of ship_state name to it's proper equivalent to get a total of 36 states and union territories.

Finally, simply properly capitalized 'Kurta' in the category column.

[Data cleaning file](https://github.com/aidenLane/amazon-ecommerce-analysis/blob/main/cleaning.sql)


### Exploring the Data

To get a better understanding of the data, as well as find direction for further analysis, there is an extra SQL step for exploring the data. Also, when querying data, ensure the data is clean and ready for visualization in PowerBI. So, this file includes many queries for relevant columns that will not all be mentioned here.

Queries for distribution of relevant categorical variables are present toward the beginning of the file. At first, this was to gather information on how many different values each of these columns may have in order to know if more data cleaning had to be done. As mentioned earlier, both status category and ship state were found to need additional manipulation of some sort at this step. 

Some other useful queries after include finding revenue and sales over time (months), and finding average order amount as well as it's standard deviation.

[Data exploration file](https://github.com/aidenLane/amazon-ecommerce-analysis/blob/main/data_exploration.sql)

### Data Visualization
![image](https://github.com/user-attachments/assets/b8c935f6-9555-4653-ab50-bd2b0ec821dd)

Above is a simple PowerBI dashboard made to make some important information easily attainable at a glance. I chose to use revenue and number of sales (not orders) as the most important metrics of business performance over this nearly three month period.

First, a large line graph is used to show amount of revenue made each day over the time period. A slicer below the graph is used to easily filter with respect to time, in order to see any specific ongoing time period that may be significant. 

Then, a donut chart is used to show the distribution of order status category from the column that was made in the data cleaning step.

To show the distribution of all product categories' sales, a bar chart is used as a donut chart would not be clear enough, and individual data labels are used instead of having an axis. 

Then, to know where the most sales are coming from, a map of India's states and union territories is used. The lighter coloured states have had less sales, where the darker coloured states have more sales. 

[PBIx file](https://github.com/aidenLane/amazon-ecommerce-analysis/blob/main/AmazonSalesAnalysis.pbix)

### Conclusion

From analyzing this dataset, it seems that the number of sales is heavily indicative of the revenue for some time. This may seem obvious, but I believe that since almost 78% of all orders are one of the "Set" or "Kurta" product categories, then most orders will have very similar amount in Indian Rupees as their prices are going to be similar. Over this time period, the average order value(AOV) was 661.35 Indian Rupees (when not including cancelled orders)

As far as order shipping status, the vast majority of orders are properly shipped as anticipated, with a pre-shipping cancellation rate of 14.2% and a shipping error rate of only 1.6%. Meaning there is roughly 84% chance that an order made on the website will be properly shipped to the customer (based on information in these months). The states with the most sales were Maharasthtra followed by Karnataka with Gujarat and Andhra Pradesh being the states with the least amount of sales over this time period. 

In the future, gaining more information for new sales would be very beneficial to understand more about customer behaviour. Gathering new information relevant to certain important e-commerce centric KPIs would help the marketing team and eventually increasing conversion rate of customers to raise revenue. Additionally, if some unique customer ID was attached to each sale, measuring customer lifetime value and finding repeat customers for certain products would be advantageous. Also, since Amazon does not manufacture most of their products, finding actual profit margins is difficult. Factoring in shipping costs and other relevant product-specific expenses would give more information on monthly profit. 

In short, having more data kept about products and customers across more time would give a better picture on how Amazon India's performance changes depending on pertinent factors.

**Thank you so much for reading!**

### References
- https://www.kaggle.com/datasets/thedevastator/unlock-profits-with-e-commerce-sales-data?select=Amazon+Sale+Report.csv
