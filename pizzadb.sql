create database pizza_db;
show databases;
use pizza_db;
select * from pizza_sales;

/*KPI:              */
/*TOTAL REVENUE*/ 
Select sum(total_price) as total_revenue 
from pizza_sales;

/*Average Order Value */
Select (sum(total_price)/count( distinct order_id)) as avg_order_value from pizza_sales;

/* Total Pizzas Sold*/
Select sum(quantity) as Total_Pizza_Sold from pizza_sales;

/*Total Orders*/
select count(distinct order_id) as total_orders from pizza_sales;

/*Average Pizzas Per order*/
select cast(cast(sum(quantity) as decimal (10,2)) /
cast(count(distinct order_id) as decimal (10,2)) As decimal (10,2)) 
as avg_pizza_per_order 
from pizza_sales;

/*Daily Trends for Total Orders*/
SELECT 
    DAYNAME(STR_TO_DATE(order_date, '%d-%m-%Y')) AS order_day, 
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
WHERE order_date IS NOT NULL
GROUP BY DAYNAME(STR_TO_DATE(order_date, '%d-%m-%Y'));
 
/* Hourly Trend for total orders*/
Select time(hour (order_time)), count(distinct order_id) as total_orders from pizza_sales group by time(hour(order_time));

/*percentage of sales by pizza category*/

select pizza_category, cast(sum(total_price) as decimal(10,2)) as total_revenue,
cast(sum(total_price) * 100 / (Select sum(total_price) from pizza_sales) as decimal(10,2)) AS pct from pizza_sales group by pizza_category;

/*Percentage of sales by pizza size*/
select pizza_size, 
cast(sum(total_price) as decimal(10,2)) as total_revenue, 
cast(sum(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS PCT FROM pizza_sales GROUP BY pizza_size ORDER BY pizza_size;

/* Total Pizza SOld by pizza categor*/
SELECT pizza_category, 
SUM(quantity) AS total_pizza_sold FROM pizza_sales GROUP BY pizza_category;

/* TOP 5 BEST SELLERS BY TOTAL PIZZA SOLD*/
SELECT pizza_name,
SUM(quantity) AS total_pizza_sold 
FROM pizza_sales 
GROUP BY pizza_name 
ORDER BY total_pizza_sold 
DESC LIMIT 5;


SELECT ROW_NUMBER() OVER( ORDER BY sum(quantity) DESC) AS srno,
pizza_name,
SUM(quantity) AS total_pizza_sold
FROM pizza_sales 
GROUP BY pizza_name 
ORDER BY total_pizza_sold DESC
LIMIT 5;

/* BOTTOM 5 WORST SELLER by total pizza sold*/
SELECT ROW_NUMBER() OVER( ORDER BY sum(quantity)) AS srno,
pizza_name,
SUM(quantity) AS total_pizza_sold
FROM pizza_sales 
GROUP BY pizza_name 
ORDER BY total_pizza_sold ASC
LIMIT 5;
