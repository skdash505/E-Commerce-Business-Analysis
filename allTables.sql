select * from geolocations limit 10;
select * from customers  limit 10;
select * from sellers limit 10;
select * from products limit 10;
select * from orders limit 10;
select * from order_reviews limit 10;
select * from payments limit 10;
select * from order_items limit 10;

select count(*) from geolocations;
select count(*) from customers;
select count(*) from sellers;
select count(*) from products;
select count(*) from orders;
select count(*) from reviews;
select count(*) from payments;
select count(*) from order_items;



CREATE TABLE geolocations (
    geolocation_zip_code_prefix VARCHAR(8) NOT NULL,
    geolocation_lat DECIMAL(20, 15) NOT NULL,
    geolocation_lng DECIMAL(20, 15) NOT NULL,
    geolocation_city VARCHAR(255) NOT NULL,
    geolocation_state CHAR(2) NOT NULL
);

CREATE TABLE customers (
    customer_id varchar(32) NOT NULL PRIMARY KEY,
    customer_unique_id varchar(32) NOT NULL,
    customer_zip_code_prefix VARCHAR(8) NOT NULL,
    customer_city varchar(255) NOT NULL,
    customer_state varchar(5) NOT NULL
);

CREATE TABLE sellers (
    seller_id varchar(45) NOT NULL PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(8) NOT NULL,
    seller_city varchar(255) NOT NULL,
    seller_state varchar(5) NOT NULL
);

CREATE TABLE products (
    product_id VARCHAR(32) NOT NULL PRIMARY KEY,
    product_category_name VARCHAR(64),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

CREATE TYPE orderState AS ENUM ('approved','canceled','created','delivered','invoiced','processing','shipped','unavailable');
CREATE TABLE orders (
    order_id VARCHAR(32) NOT NULL PRIMARY KEY,
    customer_id VARCHAR(32) NOT NULL,
    order_status orderState NOT NULL,
    order_purchase_timestamp timestamp NOT NULL, 
    order_approved_at timestamp, --! data available in csv but not shown in site
    order_delivered_carrier_date timestamp, 
    order_delivered_customer_date timestamp, 
    order_estimated_delivery_date timestamp, 
    CONSTRAINT fk_customer_id FOREIGN KEY (customer_id) REFERENCES customers (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE order_reviews (
    review_id VARCHAR(32) NOT NULL,
    order_id VARCHAR(32) NOT NULL,
    review_score INT NOT NULL,
    review_comment_title VARCHAR(256),
    -- review_comment_message VARCHAR(256), --! data not available in csv but  shown in site
    review_creation_date timestamp NOT NULL,
    review_answer_timestamp timestamp,
    CONSTRAINT fk_reviews_order_id FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
ALTER TABLE order_reviews
ADD CONSTRAINT check_review_score CHECK (review_score >= 1 AND review_score <= 5);

CREATE TABLE payments (
    order_id VARCHAR(32) NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type VARCHAR(20)NOT NULL,
    payment_installments INT NOT NULL,
    payment_value DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_payments_order_id FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE order_items (
    order_id VARCHAR(32) NOT NULL,
    order_item_id INT NOT NULL,
    product_id VARCHAR(32) NOT NULL,
    seller_id VARCHAR(32) NOT NULL,
    shipping_limit_date timestamp NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    freight_value DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_order_items_seller_id FOREIGN KEY (seller_id) REFERENCES sellers (seller_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_order_items_product_id FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_order_items_order_id FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE RESTRICT ON UPDATE CASCADE
);