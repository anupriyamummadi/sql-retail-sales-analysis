--Importing data from csv file using import feature 
--Checking the imported data 
select top 10 * from retail_sales_data
select count(*) from retail_sales_data

--checking for duplicates and delete the duplicate records 
with cte as (
select *, row_number() over (partition by order_id, sales, product_name order by order_id) as rn
from retail_sales_data
)
delete from cte 
where rn > 1

--Fixing Null values 
select * 
from retail_sales_data
where postal_code is null
-- only postal_code column has null values 
update retail_sales_data
set postal_code = 
    case 
        when customer_id in ('QJ-19255','SV-20785') then 95401
        when customer_id in ('CB-12535','RM-19375') then 95405
        else 94504
    end
where postal_code is null 

select * from retail_sales_data
where postal_code is null

---- Data cleaning End---------

-- Data Analysis--
--find total sales 
select round(sum(Sales),2) as total_sales 
from retail_sales_data

--find monthly sales 
select format(order_date,'MMM-yyyy') as month, round(sum(sales),2) as monthly_sales 
from retail_sales_data
group by format(order_date,'MMM-yyyy')
order by monthly_sales  asc

--Highest sale in - November 2018 with total monthly sales of 117938.15$
--Lowest sale in- February 2015 with total monthly sales of 4519.89$

--find yearly sales trend 
select year(order_date) as year, round(sum(sales),2) as yearly_sales 
from retail_sales_data
group by year(order_date)
order by yearly_sales desc 
--Highest sales in year 2018 with total yearly sales of 722052.02$
--Lowest sales in the year 2016 with total yearly sales of 459436.01$

--Top performing products 

select top 10 product_name, round(sum(sales),2) as total_sales_by_product
from retail_sales_data
group by product_name
order by total_sales_by_product desc

--Top products by category 

select category, round(sum(sales),2) as total_sales_by_category
from retail_sales_data
group by category
order by total_sales_by_category desc 

--Technology category is high selling category

--Region wise performance 
select region, round(sum(Sales),2) as total_sales_by_region 
from retail_sales_data
group by region 
order by total_sales_by_region desc

--Highest sales are from West Region 

---Advanced Data Analytics--
-- Running totals 
select order_date, round(sales,2), round(sum(Sales) over (order by order_date),2) as running_total
from retail_sales_data

--Ranking Product category with high sales 
select *, rank() over (order by total_sales_by_category desc) as ranking
from (
select product_name, sum(Sales) as total_sales_by_category
from retail_sales_data
group by product_name
) t 
