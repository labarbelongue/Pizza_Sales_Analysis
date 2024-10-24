
--Total Sales: 

select round(sum(p.price*od.quantity),0) as total_sales
from order_details od
join pizzas p
on od.pizza_id = p.pizza_id

--Total Quantity:

select sum(quantity) as total_quantity
from order_details

--Average Order Value:

select round(sum(p.price*od.quantity)*1.0 / count(distinct od.order_id),2) as average_order_value
from order_details od
join pizzas p
on od.pizza_id = p.pizza_id

--Total Order Count

select count(distinct order_id) as total_order_count
from order_details

--Average Daily Order
select count(distinct order_id) / count(distinct date) as average_daily_order
from orders

--Daily Sales and Order Trend

select 
	datename(weekday, o.date) as days, 
	round(sum(p.price*od.quantity),2) as sales_by_day, 
	count(distinct o.order_id) as order_by_day
from orders o
join order_details od
on o.order_id = od.order_id
join pizzas p
on od.pizza_id = p.pizza_id
group by datename(weekday, o.date)
order by sum(p.price*od.quantity) desc 

--Monthly Sales and Order Trend

select 
	datename(month, o.date) as days, 
	round(sum(p.price*od.quantity),2) as sales_by_month, 
	count(distinct o.order_id) as order_by_month
from orders o
join order_details od
on o.order_id = od.order_id
join pizzas p
on od.pizza_id = p.pizza_id
group by datename(month, o.date)
order by sum(p.price*od.quantity) desc 

--Hourly Sales and Order Trend

select 
	datepart(hour, o.time) as days, 
	round(sum(p.price*od.quantity),2) as sales_by_month, 
	count(distinct o.order_id) as order_by_month
from orders o
join order_details od
on o.order_id = od.order_id
join pizzas p
on od.pizza_id = p.pizza_id
group by datepart(hour, o.time)
order by datepart(hour, o.time)


--Pizza Quantity and Sales by Category

select 
	pt.category,
	sum(od.quantity) as quantity_by_category,
	round(sum(od.quantity*p.price),2) as sales_by_category,
	round(sum(od.quantity*p.price)*100.0 / 
									(select round(sum(p.price*od.quantity),0) as total_sales
									from order_details od
									join pizzas p
									on od.pizza_id = p.pizza_id),2) as percentage_by_category
from pizza_types pt
join pizzas p
on pt.pizza_type_id = p.pizza_type_id
join order_details od
on p.pizza_id = od.pizza_id
group by pt.category
order by sum(od.quantity*p.price) desc

--Pizza Quantity and Sales by Size

select 
	p.size,
	sum(od.quantity) as quantity_by_size,
	round(sum(od.quantity*p.price),2) as sales_by_size,
	round(sum(od.quantity*p.price)*100.0 / 
									(select round(sum(p.price*od.quantity),0) as total_sales
									from order_details od
									join pizzas p
									on od.pizza_id = p.pizza_id),2) as percentage_by_size
from pizzas p
join order_details od
on p.pizza_id = od.pizza_id
group by p.size
order by sum(od.quantity*p.price) desc


--Top 5 Products

select top 5 
	pt.name,
	sum(od.quantity) as quantity_by_product,
	round(sum(od.quantity*p.price),2) as sales_by_product
from pizza_types pt
join pizzas p
on pt.pizza_type_id = p.pizza_type_id
join order_details od
on p.pizza_id = od.pizza_id
group by pt.name
order by sum(od.quantity*p.price) desc

--Bottom 5 Products

select top 5 
	pt.name,
	sum(od.quantity) as quantity_by_product,
	round(sum(od.quantity*p.price),2) as sales_by_product
from pizza_types pt
join pizzas p
on pt.pizza_type_id = p.pizza_type_id
join order_details od
on p.pizza_id = od.pizza_id
group by pt.name
order by sum(od.quantity*p.price)