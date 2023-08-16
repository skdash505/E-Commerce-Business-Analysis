-- todo test Area
select * from customers;
select * from payments;
select * from orders;
select * from order_items;

select * from orders
where order_status in ('created');

select order_id, count(distinct customer_id) 
from orders
group by order_id
order by count(distinct customer_id) desc;

-- *# Consolidated 
select order_id,
    abs(EXTRACT(day FROM (order_purchase_timestamp - order_delivered_customer_date))) as day_to_deliver,
    EXTRACT(day FROM (order_estimated_delivery_date - order_purchase_timestamp)) as estimated_day_to_deliver, 
    EXTRACT(day FROM (order_estimated_delivery_date - order_delivered_customer_date)) as diff_estimated_delivery,
    EXTRACT(day FROM (order_delivered_customer_date - order_delivered_carrier_date)) as day_to_ship
from orders
-- where order_status in ('approved','created','delivered','processing','shipped')
order by order_id;

-- ?* 1. Calculate days between purchasing, delivering and estimated delivery

select order_id,
    abs(EXTRACT(day FROM (order_purchase_timestamp - order_delivered_customer_date))) as day_to_deliver,
    EXTRACT(day FROM (order_estimated_delivery_date - order_purchase_timestamp)) as estimated_day_to_deliver
from orders
order by order_id;

-- ?* 2. Find time_to_delivery & diff_estimated_delivery. Formula for the same given below:

select order_id,
    abs(EXTRACT(day FROM (order_purchase_timestamp - order_delivered_customer_date))) as time_to_deliver,
    EXTRACT(day FROM (order_estimated_delivery_date - order_delivered_customer_date)) as diff_estimated_delivery
from orders
order by order_id;


-- ?* 3. Group data by state, take mean of freight_value, time_to_delivery, diff_estimated_delivery:

select
    customer_state as state
    ,round(avg(oi.freight_value), 2) as mean_freight_value
    ,round(avg(abs(EXTRACT(day FROM (o.order_purchase_timestamp - o.order_delivered_customer_date)))), 2) as mean_time_to_deliver
    ,round(avg(EXTRACT(day FROM (o.order_estimated_delivery_date - o.order_delivered_customer_date))), 2) as mean_diff_estimated_delivery
    -- ,count(distinct order_id) as total
from orders o 
join customers c using(customer_id)
join order_items oi using(order_id)
group by customer_state
order by mean_freight_value;


-- ?*todo 4. Sort the data to get the following (using CTE)
with consolidated_sales as (select
    customer_state as state
    -- ,count(distinct order_id) as total
    ,round(avg(oi.freight_value), 2) as avg_freight_value
    ,round(avg(abs(EXTRACT(day FROM (o.order_purchase_timestamp - o.order_delivered_customer_date)))), 2) as avg_time_to_deliver
    ,round(avg(EXTRACT(day FROM (o.order_estimated_delivery_date - o.order_delivered_customer_date))), 2) as avg_diff_estimated_delivery
from orders o 
join customers c using(customer_id)
join order_items oi using(order_id)
group by customer_state
order by customer_state)


-- ?* 5. Top 5 states with highest/lowest average freight value - sort in desc/asc limit 5:

-- ? Cheapest
select state, avg_freight_value
from consolidated_sales
order by avg_freight_value asc limit 5;

-- ? Not so Cheap
select state, avg_freight_value
from consolidated_sales
order by avg_freight_value desc limit 5;


-- ?* 6. Top 5 states with highest/lowest average time to delivery:

-- ? Fastest
select state, avg_time_to_deliver
from consolidated_sales
order by avg_time_to_deliver asc limit 5;

-- ? Slowest
select state, avg_time_to_deliver
from consolidated_sales
order by avg_time_to_deliver desc limit 5;


-- ?* 7. TTop 5 states where delivery is really fast/ not so fast compared to estimated date:

-- ? really fast
select state, avg_diff_estimated_delivery
from consolidated_sales
order by avg_diff_estimated_delivery desc limit 5;

-- ? Not so fast
select state, avg_diff_estimated_delivery
from consolidated_sales
order by avg_diff_estimated_delivery asc limit 5;






