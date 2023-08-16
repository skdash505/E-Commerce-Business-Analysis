-- todo test Area
select * from customers;
select * from payments;
select * from orders;
select * from order_items;

select order_id, count(distinct customer_id) 
from orders
group by order_id
order by count(distinct customer_id) desc;

select order_id, count(*) 
from payments
group by order_id
order by count(*) desc;

select order_id, count(*) 
from order_items
group by order_id
order by count(*) desc;

select order_id, customer_id, count(distinct customer_id) 
from customers c 
join orders o using(customer_id)
join payments p using(order_id)
group by order_id, customer_id
-- having count(distinct customer_id)>1
order by  count(distinct customer_id) desc, order_id, customer_id;

select order_id, customer_id, count(*) 
,sum(oi.freight_value) as fright_value
,sum(p.payment_value) as fright_value
from customers c 
join orders o using(customer_id)
join payments p using(order_id)
join order_items oi using(order_id)
group by order_id, customer_id
-- having count(*)>1
order by  count(*) desc, order_id, customer_id;

select *
from customers c 
join orders o using(customer_id)
join payments p using(order_id)
order by order_id, customer_id;


-- ?* 1. Get % increase in cost of orders from 2017 to 2018 (include months between Jan to Aug only) - You can use “payment_value” column in payments table

with order_updated as(
    select *
    from (
            select *,
                EXTRACT(
                    YEAR
                    FROM order_purchase_timestamp
                ) as opt_year,
                EXTRACT(
                    Month
                    FROM order_purchase_timestamp
                ) as opt_month_id,
                TO_CHAR(
                    DATE_TRUNC('month', order_purchase_timestamp),
                    'Month'
                ) as opt_month
            from orders
        ) x
    where opt_year in (2017, 2018)
        and opt_month_id between 1 and 8
),
filtered_order_detail as(
    select opt_year,
        opt_month,
        count(distinct order_purchase_timestamp) as total_opt_quantity,
        sum(payment_value) as total_opt_cost,
        opt_month_id
    from order_updated ou
        join payments p on ou.order_id = p.order_id
    group by opt_year,
        opt_month,
        opt_month_id
    order by opt_year,
        opt_month_id
) 
select opt_month
    , round(((current_year_cost-previous_year_cost)/previous_year_cost)*100,2) as cost_perc_increase
    , current_year_cost
    , previous_year_cost
    -- , cast(((cur_q-per_q)/per_q)*100 as decimal(5,2)) as quantity_perc_increase
    -- , current_year_quantity
    -- , previous_year_quantity
from (
    select fod1.opt_month
        ,fod1.opt_month_id
        ,fod1.opt_year as current_year
        ,fod2.opt_year as previous_year
        ,fod1.total_opt_cost as current_year_cost
        ,fod2.total_opt_cost as previous_year_cost
        -- ,cast(fod1.total_opt_quantity as decimal(12,2)) as cur_q
        -- ,cast(fod2.total_opt_quantity as decimal(12,2)) as per_q
        -- ,fod1.total_opt_quantity as current_year_quantity
        -- ,fod2.total_opt_quantity as previous_year_quantity
    from filtered_order_detail fod1
        join filtered_order_detail fod2 on fod1.opt_month = fod2.opt_month
        and fod1.opt_year > fod2.opt_year
) x




-- ?* 2. Mean & Sum of price and freight value by customer state

with consolidated_sales as(
    select c.customer_state as state,
        p.payment_value as price,
        oi.freight_value,
        customer_id,
        order_id
    from customers c
        join orders o using(customer_id)
        join payments p using(order_id)
        join order_items oi using(order_id)
    order by order_id
)
select * from
(select state,
    sum(price) as total_price,
    round(avg(price), 2) as mean_price,
    sum(freight_value) as total_freight_value,
    round(avg(freight_value), 2) as mean_freight_value,
    count(distinct order_id) as total_sales_count 
    -- ,count(*) as total_count
from consolidated_sales
group by state)x
order by mean_freight_value


