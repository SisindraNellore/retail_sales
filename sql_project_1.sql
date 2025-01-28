create table retail_sales
(
		transactions_id	int primary key,
		sale_date DATE,
		sale_time time,
		customer_id int,
		gender varchar(15),
		age	int,
		category varchar(15),	
		quantiy	int,
		price_per_unit float,	
		cogs float,
		total_sale float
)

select *
from retail_sales;

#------------Data_Cleaning-----------------

select *
from retail_sales
where 
	transactions_id is null or
	sale_date is null or	
	sale_time is null or
	customer_id	is null or
	gender is null or
	category is null or
	quantiy is null or
	price_per_unit is null or
	cogs is null or
	total_sale is null


delete from retail_sales
where
	transactions_id is null or
	sale_date is null or	
	sale_time is null or
	customer_id	is null or
	gender is null or
	category is null or
	quantiy is null or
	price_per_unit is null or
	cogs is null or
	total_sale is null

select count(*)
from retail_sales

#--------Data_Exploration------------

#How many sales has taken place

select count(*) as total_sales
from retail_sales

#How many customers do we have

select count(distinct customer_id)
from retail_sales;

#--------Data Analysis & Findings---------

#1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05'**:

select *
from retail_sales
where sale_date = '2022-11-05'

#2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
the quantity sold is more than 4 in the month of Nov-2022**:

SELECT *
FROM retail_sales
WHERE category = 'Clothing' AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' AND quantiy >= 4

#3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:

select category, sum(total_sale) as total_sales
from retail_sales
group by category

#4. **Write a SQL query to find the average age of customers who purchased items from 
the 'Beauty' category.**:

SELECT ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

#5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:

select *
from retail_sales
where total_sale > 1000

#6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:

select category,gender,count(transactions_id) as total_transactions
from retail_sales
group by category,gender
order by category

#7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:

with cte as
(
select extract(year from sale_date) as sale_year,
extract(month from sale_date) as sale_month,
avg(total_sale) as avg_sales
from retail_sales
group by sale_year,sale_month
),cte_2 as
(
select *, rank() over(partition by sale_year order by avg_sales desc) as rn
from cte
)
select sale_year,sale_month,avg_sales
from cte_2
where rn = 1

#8. **Write a SQL query to find the top 5 customers based on the highest total sales **:

select customer_id, sum(total_sale) as sum_sales
from retail_sales
group by customer_id
order by sum_sales desc
limit 5

#9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:

select category,count(distinct customer_id)
from retail_sales
group by category

#10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:

select
case
	when extract(hour from sale_time) < 12 then 'Morning'
	when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
	else 'Evening'
end as timings,
count(quantiy)
from retail_sales
group by timings