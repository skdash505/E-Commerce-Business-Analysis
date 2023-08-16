-- todo test Area
select * from payments;

-- *# Consolidated 



-- ?*todo CTEs to simplify the existing records



--  ?* 1. Month over Month count of orders for different payment types

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
        join payments p using(order_id)
        where p.payment_type not like 'not_defined'
    order by o.order_purchase_timestamp
),
grouped_payment_details as(
    select payment_type,
        opt_month as month,
        count(distinct order_id) as order_quantity,
        sum(payment_value) as order_price,
        opt_month_id as rn
    from order_updated
    group by payment_type,
        opt_month,
        opt_month_id
    order by payment_type,
        opt_month_id
)
select gsd1.payment_type,
    gsd1.month,
    gsd1.order_quantity,
    gsd1.order_price,
    case
        when gsd2.order_quantity is not null
        and gsd2.order_quantity not in (0) then (
            (gsd1.order_quantity - gsd2.order_quantity) * 100 / gsd2.order_quantity
        )
        else 0
    end as qnantity_mom,
    case
        when gsd2.order_price is not null
        and gsd2.order_price not in (0) then round(
            (gsd1.order_price - gsd2.order_price) * 100 / gsd2.order_price,
            2
        )
        else 0
    end as price_mom
from grouped_payment_details gsd1
    left join grouped_payment_details gsd2 on gsd1.payment_type = gsd2.payment_type
    and gsd1.rn = gsd2.rn + 1
order by gsd1.payment_type, gsd1.rn;



--  ?* 2. Count of orders based on the no. of payment installments

select payment_installments,
    count(order_id) as total_orders,
    count(distinct order_id) as distinct_orders
from payments
group by payment_installments
order by count(distinct order_id) desc;


