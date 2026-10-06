-- Task 1: Which product categories sold over 1,400 units in 2025?
select p.category, 
sum(si.quantity) as total_units_sold
from salesitems si
join sales s on si.sale_id = s.sale_id
join products p on si.product_id = p.product_id
where year(s.sale_date) = 2025
group by p.category
having sum(si.quantity) > 1400
order by total_units_sold desc;

-- Task 2: Which countries earned over 60,000 in any quarter of 2025?
select c.country, 
quarter(s.sale_date) as sale_quarter, 
round(sum(si.item_total), 2) as revenue
from salesitems si
join sales s on si.sale_id = s.sale_id
join customers c on s.customer_id = c.customer_id
where year(s.sale_date) = 2025
group by c.country, quarter(s.sale_date)
having sum(si.item_total) > 60000
order by c.country, sale_quarter;

-- Task 3: List the product sizes that sold at least 400 units and were in at 
-- least 120 orders in April
select p.size, 
sum(si.quantity) as total_units, 
count(distinct si.sale_id) as distinct_orders
from salesitems si
join sales s on si.sale_id = s.sale_id
join products p on si.product_id = p.product_id
where monthname(s.sale_date) = 'April'
group by p.size
having sum(si.quantity) >= 400 and count(distinct si.sale_id) >= 120
order by total_units desc;

-- Task 4: Compare units sold and revenue on each channel type by product size
select 
trim(ch.description) as channel_type,
upper(trim(p.size)) as product_size,
sum(si.quantity) as units_sold,
round(sum(si.item_total), 2) as revenue
from salesitems si
join products p on si.product_id = p.product_id
join channels ch on si.channel = ch.channel
group by trim(ch.description), upper(trim(p.size))
order by field(product_size, '35', '36', '38', '40', 'XS', 'S', 'M', 'L', 'XL'), channel_type;

-- Task 5: Show the signup date, first order date and days between them for
-- each customer who made an order within 30 days of signing up
select c.customer_id, 
c.signup_date, 
min(s.sale_date) as first_order_date,
datediff(min(s.sale_date), c.signup_date) as days_to_first_order
from customers c
join sales s on c.customer_id = s.customer_id
group by c.customer_id, c.signup_date
having datediff(min(s.sale_date), c.signup_date) between 0 and 30
order by days_to_first_order;