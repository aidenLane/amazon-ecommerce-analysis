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
In progress


### Setting up Database

Similar to my past work, I used SQLAlchemy and psycopg2 to transfer the contents from the CSV file to a local PostgreSQL server. This method is much more efficient as in 

In progress

### Data Cleaning

First of all, when examining the names given to the columns in the original CSV, I noticed they were not very SQL-friendly. So, I prioritized reconfiguring those before even thinking about cleaning the data itself. Most of these cases were just removing capital lettering, however some required more care (For example, the sales channel column originally had a space at the end of the name as well as a space between the words). Also, dashes were converted to underscores as SQL does not allow column names to have special characters.

Next, the date formatting was addressed. Originally, the dataset had date in format 'MM-DD-YY' so it was changed to 'YYYY-MM-DD' to be more compatible with SQL/PowerBI. 

Next, I checked for duplicate row values by examining if any index occured more than once. Fortunately, there were none. Also, removed some unnecessary columns (for our analysis).

Upon examining the status field, I found that there were many different variations of status that were perhaps unnecessary. 

![image](https://github.com/aidenLane/amazon-ecommerce-analysis/assets/55153752/85c96573-7472-45a2-abd2-1a904d338036)

So, to make things more efficient moving forward for the purpose of analysis, a new column was created, called 'status_category', to better classify each row's status. Used values 'Cancelled', 'Pending', 'Shipping Error', and 'Shipped' for this column.

After moving to the PowerBI step, I noticed that the ship_state names were very poorly formatted and required a lot of cleaning. For example, see the image of a part of a query below.

![image](https://github.com/user-attachments/assets/4288f735-b7c6-4c65-8fc0-c6b208e0813c)

From the bottom few rows, it is apparent there are many values for 'Delhi' and also, from the top few rows there are some abbreviations. These values had to be cleaned.

I used the formatting for each state/union territory as it stated is in the India States JSON file which I was using to display data geographically in PowerBI. Then, changed each variant of ship_state name to it's proper equivalent to get a total of 36 states and union territories.

Finally, simply properly capitalized 'Kurta' in the category column.


### Exploring the Data
In progress

### Data Visualization
![image](https://github.com/user-attachments/assets/b8c935f6-9555-4653-ab50-bd2b0ec821dd)

Above is a very simple PowerBI dashboard made to make some important information easily attainable at a glance. I chose to use revenue and number of sales (not orders) as the most important metrics of business performance over this nearly three month period.

First, a large line graph is used to show amount of revenue made each day over the time period. A slicer below the graph is used to easily filter with respect to time, in order to see any specific ongoing time period that may be significant. 

Then, a donut chart is used to show the distribution of order status category from the column that was made in the data cleaning step.

To show the distribution of all product categories' sales, a bar chart is used as a donut chart would not be clear enough, and individual data labels are used instead of having an axis. 

Then, to know where the most sales are coming froml, a map of India's states and union territories is used. The lighter coloured states have had less sales, where the darker coloured states have more sales. 

### Conclusion
In progress

Thank you for reading!

### References
- https://www.kaggle.com/datasets/thedevastator/unlock-profits-with-e-commerce-sales-data?select=Amazon+Sale+Report.csv
