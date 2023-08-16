-- todo test Area
select *
from orders;

select order_id, count(*), sum(payment_value)
from payments
group by order_id
order by count(*) desc;


-- ?*todo CTEs to simplify the existing records
with order_updated as(
    select *,
        concat(opt_year, '-', opt_month) as opt_month_year,
        case
            when opt_month_id in (12, 1, 2) then 'Summer'
            when opt_month_id in (3, 4, 5) then 'Autumn'
            when opt_month_id in (6, 7, 8) then 'Winter'
            when opt_month_id in (9, 10, 11) then 'Spring'
        end as seasons
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
),
filtered_order_detail as(
    select opt_month_year,
        seasons,
        count(distinct order_purchase_timestamp) as total_opt_quantity,
        sum(payment_value) as total_opt_price,
        round(avg(payment_value),2) as avg_sales,
        opt_year,
        opt_month,
        opt_month_id
    from order_updated ou
        join payments p on ou.order_id = p.order_id
    group by opt_month_year,
        seasons,
        opt_year,
        opt_month,
        opt_month_id
    order by opt_year,
        opt_month_id,
        opt_month_year
)

-- ? to find trend on e-commerce in Brazil
select opt_month_year as year_month,
    total_opt_quantity as qunatity,
    total_opt_price as sales,
    rank() over(
        order by total_opt_price desc
    ) as sales_rank,
    avg_sales,
    rank() over(
        order by avg_sales desc
    ) as avg_sales_rank,
    opt_year, opt_month_id
from filtered_order_detail
order by opt_year,
    opt_month_id;

-- ? With Seasonal Sales By year
select opt_year as year, seasons,
    sum(total_opt_quantity) as qunatity,
    sum(total_opt_price) as sales,
    rank() over(
        partition by opt_year order by sum(total_opt_price) desc
    ) as sales_rank,
    round(avg(total_opt_price), 2) as avg_sales,
    rank() over(
        partition by opt_year order by avg(total_opt_price) desc
    ) as avg_sales_rank
from filtered_order_detail
group by opt_year, seasons
order by opt_year, seasons;

-- ? With Seasonal Sales Only
select * from
(select seasons,
    sum(total_opt_quantity) as qunatity,
    sum(total_opt_price) as sales,
    rank() over(
        order by sum(total_opt_price) desc
    ) as sales_rank,
    round(avg(total_opt_price), 2) as avg_sales,
    rank() over(
         order by avg(total_opt_price) desc
    ) as avg_sales_rank
from filtered_order_detail
group by seasons)y
order by sales_rank;



-- ?* 1.1. Is there a growing trend on e-commerce in Brazil? 
with order_updated as(
    select *,
        concat(opt_year, '-', opt_month) as opt_month_year
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
)
select opt_month_year,
    count(distinct order_purchase_timestamp) as total_opt_quantity,
    sum(payment_value) as total_opt_price,
    round(avg(payment_value), 2) as avg_sales,
    opt_year,
    opt_month_id
from order_updated ou
    join payments p on ou.order_id = p.order_id
group by opt_month_year,
    opt_year,
    opt_month_id
order by opt_year,
    opt_month_id,
    opt_month_year;


-- ?* 1.2. Can we see some seasonality with peaks at specific months?
with order_updated as(
    select *,
        case
            when opt_month_id in (12, 1, 2) then 'Summer'
            when opt_month_id in (3, 4, 5) then 'Autumn'
            when opt_month_id in (6, 7, 8) then 'Winter'
            when opt_month_id in (9, 10, 11) then 'Spring'
        end as seasons
    from (
            select *,
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
)
select seasons,
    opt_month,
    count(distinct order_purchase_timestamp) as total_opt_quantity,
    sum(payment_value) as total_opt_price,
    round(avg(payment_value), 2) as avg_sales,
    opt_month_id
from order_updated ou
    join payments p on ou.order_id = p.order_id
group by seasons,
    opt_month,
    opt_month_id
order by total_opt_price




-- ?* 2. What time do Brazilian customers tend to buy (Dawn, Morning, Afternoon or Night)?
with order_updated as(
    select *,
        case
            when opt_hour in (3, 4, 5) then 'Dawn'
            when opt_hour in (6, 7, 8, 9, 10, 11) then 'Morning'
            when opt_hour in (12, 13, 14, 15, 16, 17, 18, 19) then 'Afternoon'
            when opt_hour in (20, 21, 22, 23, 0, 1, 2) then 'Night'
        end as sales_time
    from (
            select *,
                EXTRACT(
                    HOUR
                    FROM order_purchase_timestamp
                ) as opt_hour
            from orders
        ) x
)
select sales_time,
    count(distinct order_purchase_timestamp) as total_opt_quantity,
    sum(payment_value) as total_opt_price,
    round(avg(payment_value), 2) as avg_sales,
    rank() over(
        order by sum(payment_value)
    ) as sales_rank
from order_updated ou
    join payments p on ou.order_id = p.order_id
group by sales_time;

