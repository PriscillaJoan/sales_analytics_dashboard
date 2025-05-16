-- Customer Analysis

--Who are the top 15 customers revenue
select c.customer_name,sum(s.total_amount::numeric) as revenue,s.payment_method
from sales s
join customers c on c.customer_id = s.customer_id
group by c.customer_name,s.payment_method
order by revenue asc
limit 15

--Which customers are at risk of churn 
select 
c.customer_id,
c.customer_name,
max(s.order_date) as last_purchase_date,
count(s.order_id) as total_orders,
sum(s.total_amount::numeric) as total_spent
from sales s
join customers c on s.customer_id = c.customer_id
where s.status = 'Delivered'
group by c.customer_id, c.customer_name
having max(s.order_date) < (select max(order_date) from sales) - interval '60 days'
order by last_purchase_date desc;

--Average customer order value
select customer_id, round(avg(total_amount::numeric),2) as avg_order_value
from sales
where status = 'Delivered'
group by customer_id
order by avg_order_value desc
limit 15;

-- Customer order Frequency
select customer_id, count(order_id) as order_count
from sales
where status = 'Delivered'
group by customer_id
order by order_count desc
limit 15;

-- Customer revenue by neighbourhood groups
select c.neighbourhood_group, sum(s.total_amount::numeric) as total_revenue
from sales s
join customers c on s.customer_id = c.customer_id
where s.status = 'Delivered'
group by c.neighbourhood_group;

--Prefered payment methods
select s.payment_method, count(distinct s.customer_id) as customer_count
from sales s
where s.status = 'Delivered'
group by s.payment_method
order by customer_count desc;
