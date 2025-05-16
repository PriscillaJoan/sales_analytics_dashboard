	-- Product and supplier performance
	
-- Update suppliers table to match product table format
UPDATE suppliers
SET supplier_id = 'S' || SUBSTRING(supplier_id FROM 2)::integer::text
WHERE supplier_id LIKE 'S%';

-- Which products have the highest return/cancellation rates and what could be the cause?
select 
p.product_id,
p.product_name,
count(s.order_id) AS total_orders,
sum(case when s.status = 'Canceled' then 1 else 0 end) as cancelled_orders,
round(sum(case when s.status  = 'Canceled' then 1 else 0 end) * 100.0 / count(s.order_id), 2 ) as cancellation_rate_percent
from sales s
join product p on s.product_id = p.product_id
group by p.product_id, p.product_name
order by cancellation_rate_percent desc
limit 10;

-- Which suppliers provide the most revenue-generating products?
select p.supplier_id,
p.product_id,
sum(s.total_amount::numeric) as product_revenue
from sales s
join product p on p.product_id = s.product_id
where s.status = 'Delivered'
group by p.supplier_id,p.product_id
order by product_revenue desc
limit 10

-- supplies with the lowest relaibiliy scores vs their revenue
select sp.reliability_score,
sp.supplier_name,
sum(s.total_amount::numeric) as total_revenue
from suppliers sp
join product p on sp.supplier_id = p.supplier_id
join sales s on s.product_id = p.product_id
where s.status = 'Delivered'
group by sp.supplier_name,sp.reliability_score
order by sp.reliability_score asc


-- suppliers with the most canceled orders
select sp.supplier_name, count(s.order_id) as total_canceled_orders
from sales s
join product p on s.product_id = p.product_id
join suppliers sp on sp.supplier_id = p.supplier_id
where s.status = 'Canceled'
group by sp.supplier_name
order by total_canceled_orders desc
