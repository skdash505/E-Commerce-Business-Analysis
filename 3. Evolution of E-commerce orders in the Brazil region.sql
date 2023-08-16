-- todo test Area
select * from geolocations;
select * from customers;
select * from orders;

select customer_id, count(*) from orders
group by customer_id
having count(*)>1
order by count(*);


-- ?* 1. Get month on month orders by states

with order_updated as(
    select *,
        TO_CHAR(
            DATE_TRUNC('month', o.order_purchase_timestamp),
            'Month'
        ) as opt_month,
        extract(
            month
            from o.order_purchase_timestamp
        ) as opt_month_id
    from orders o
        join customers c using(customer_id)
        join payments p using(order_id)
    order by o.order_purchase_timestamp
),
grouped_sate_details as(
    select customer_state as state,
        opt_month as month,
        count(distinct order_id) as order_quantity,
        sum(payment_value) as order_price,
        opt_month_id
    from order_updated
    group by customer_state,
        opt_month,
        opt_month_id
    order by customer_state,
        opt_month_id
)
select gsd1.state,
    gsd1.month,
    gsd1.order_quantity,
    gsd1.order_price,
    case
        when gsd2.order_quantity is not null then (
            (gsd1.order_quantity - gsd2.order_quantity) * 100 / gsd2.order_quantity
        )
        else 0
    end as qnantity_mom,
    case
        when gsd2.order_price is not null then round(
            (gsd1.order_price - gsd2.order_price) * 100 / gsd2.order_price,
            2
        )
        else 0
    end as price_mom
from grouped_sate_details gsd1
    left join grouped_sate_details gsd2 on gsd1.state = gsd2.state
    and gsd1.opt_month_id = gsd2.opt_month_id + 1
order by gsd1.state, gsd1.opt_month_id;


-- ?* 2. Distribution of customers across the states in Brazil
select customer_state as state,
    count(*) as no_of_customers
from customers
group by customer_state
order by count(*) desc;