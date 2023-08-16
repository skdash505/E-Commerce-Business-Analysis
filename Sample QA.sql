SELECT *
from INFORMATION_SCHEMA.COLUMNS;

SELECT *
from INFORMATION_SCHEMA.COLUMNS
where table_catalog = 'target'  and table_schema = 'public';

SELECT *
from INFORMATION_SCHEMA.COLUMNS
where table_catalog = 'target'  and table_schema = 'public'
    and table_name = 'geolocations';

    -- For PostgreSQL Start -- 
SELECT table_name, column_name, data_type, is_nullable
from INFORMATION_SCHEMA.COLUMNS
where table_catalog = 'target'  and table_schema = 'public'
    and table_name = 'geolocations';

SELECT table_name, column_name, data_type, is_nullable
from INFORMATION_SCHEMA.COLUMNS
where table_catalog = 'target'  and table_schema = 'public'
    and table_name = 'customers';

SELECT table_name, column_name, data_type, is_nullable
from INFORMATION_SCHEMA.COLUMNS
where table_catalog = 'target'  and table_schema = 'public'
    and table_name = 'sellers';

SELECT table_name, column_name, data_type, is_nullable
from INFORMATION_SCHEMA.COLUMNS
where table_catalog = 'target'  and table_schema = 'public'
    and table_name = 'products';

SELECT table_name, column_name, data_type, is_nullable
from INFORMATION_SCHEMA.COLUMNS
where table_catalog = 'target'  and table_schema = 'public'
    and table_name = 'orders';

SELECT table_name, column_name, data_type, is_nullable
from INFORMATION_SCHEMA.COLUMNS
where table_catalog = 'target'  and table_schema = 'public'
    and table_name = 'reviews';

SELECT table_name, column_name, data_type, is_nullable
from INFORMATION_SCHEMA.COLUMNS
where table_catalog = 'target'  and table_schema = 'public'
    and table_name = 'payments';

SELECT table_name, column_name, data_type, is_nullable
from INFORMATION_SCHEMA.COLUMNS
where table_catalog = 'target'  and table_schema = 'public'
    and table_name = 'order_items';
    -- For PostgreSQL END -- 

    -- For MySQL Start -- 
SELECT table_name, column_name, data_type, is_nullable
from INFORMATION_SCHEMA.COLUMNS
where table_schema = 'target'
    and table_name = 'geolocations';

SELECT table_name, column_name, data_type, is_nullable
from INFORMATION_SCHEMA.COLUMNS
where table_schema = 'target'
    and table_name = 'customers';

SELECT table_name, column_name, data_type, is_nullable
from INFORMATION_SCHEMA.COLUMNS
where table_schema = 'target'
    and table_name = 'sellers';

SELECT table_name, column_name, data_type, is_nullable
from INFORMATION_SCHEMA.COLUMNS
where table_schema = 'target'
    and table_name = 'products';

SELECT table_name, column_name, data_type, is_nullable
from INFORMATION_SCHEMA.COLUMNS
where table_schema = 'target'
    and table_name = 'orders';

SELECT table_name, column_name, data_type, is_nullable
from INFORMATION_SCHEMA.COLUMNS
where table_schema = 'target'
    and table_name = 'reviews';

SELECT table_name, column_name, data_type, is_nullable
from INFORMATION_SCHEMA.COLUMNS
where table_schema = 'target'
    and table_name = 'payments';

SELECT table_name, column_name, data_type, is_nullable
from INFORMATION_SCHEMA.COLUMNS
where table_schema = 'target'
    and table_name = 'order_items';
    -- For MySQL END -- 

select min(order_purchase_timestamp) as start_date, max(order_purchase_timestamp) as end_date
from orders;

select count(*) from geolocations;
select count(*) from customers;