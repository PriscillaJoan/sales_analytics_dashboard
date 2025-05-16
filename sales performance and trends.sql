 -- Sales Performance & Trends

-- 1. What are the top-performing products and categories by total revenue and quantity sold over the year?"
select * from sales;
select * from product;

-- a. Top performing products by total revenue"
select p.product_name,ROUND(SUM(s.total_amount::numeric),2) AS total_amount
from sales s
join product p on p.product_id = s.product_id
where s.status = 'Delivered'
group by p.product_name
order by total_amount desc
limit 10

-- b.Top performing products by volume"
select p.product_name, sum(s.quantity) as total_volume
from sales s
join product p on p.product_id = s.product_id
where s.status = 'Delivered'
group by p.product_name
order by total_volume desc
limit 10

-- c. Top performing category by volume"
select p.category,sum(s.quantity) AS total_quantity
from sales s
join product p on p.product_id = s.product_id
where s.status = 'Delivered'
group by p.category
order by total_quantity DESC
limit 10;

-- d.Top performing category by revenue"
select p.category, round(sum(s.total_amount:: numeric),2) as total_revenue
from sales s
join product p on p.product_id = s.product_id
where s.status = 'Delivered'
group by p.category
order by total_revenue DESC
LIMIT 10

-- 2. How do monthly sales trends compare over the past 12 months?"
alter table sales
alter column order_date type date
using order_date::date;

select
trim(to_char(order_date, 'Month')) as month,
round(SUM(total_amount::numeric), 2) as total_amount
from sales
where status = 'Delivered'
group by trim(to_char(order_date,'Month'))
order by min(order_date);

-- 3. Which day of the week generates the highest average sales volume?"
select 
TO_CHAR(order_date, 'Day') as day_of_week,
ROUND(avg(quantity), 2) as avg_sales_volume
from sales
where status = 'Delivered'
group by TO_CHAR(order_date, 'Day')
order by avg_sales_volume desc;

-- 4. How do discounts impact total revenue across different products? Are discounts helping or hurting sales?
select 
sum(quantity*unit_price) as gross_revenue,
round(sum(total_amount::numeric),2) as net_revenue,
round(100 - (100 *sum(total_amount::numeric)/sum(quantity*unit_price)),2) as percentage_discount_impact
from sales
where status = 'Delivered'
