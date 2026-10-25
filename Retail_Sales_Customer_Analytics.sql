
CREATE DATABASE retail_analytics;

USE retail_analytics;

SELECT DATABASE();
CREATE TABLE customers(
	customer_Id INT,
    customer_name varchar(100),
    city varchar(100),
    sighnup_date date
    );
    ALTER table customers
    add primary key (customer_id);
    describe customers;
    alter table customers
    modify customer_id INT auto_increment;
    describe customers;
    alter table customers
    modify customer_name varchar(100) not null;
    describe customers;
insert into customers (customer_name,city,signup_date)
values
('Arun', 'Erode', '2026-10-01'),
('Priya', 'Chennai', '2026-10-05'),
('Divya', 'Coimbatore', '2026-10-10');
SELECT * FROM customers;
delete from customers
where customer_id >0;
select * from customers;
INSERT INTO customers (customer_name, city, signup_date)
VALUES
('Arun', 'Erode', '2026-10-01'),
('Priya', 'Chennai', '2026-10-05'),
('Divya', 'Coimbatore', '2026-10-10');
select * from customers;
select *
from customers 
where city = 'chennai';
select *
from customers
order by customer_name desc;
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2)
);
describe customers;
INSERT INTO products (product_name, category, price)
VALUES
('Laptop', 'Electronics', 45000.00),
('Mouse', 'Accessories', 500.00),
('Keyboard', 'Accessories', 1200.00),
('Headphones', 'Electronics', 2500.00),
('Office Chair', 'Furniture', 6500.00);
select * from products;
describe products;
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(30),
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);
describe orders;
INSERT INTO orders (customer_id, order_date, order_status)
VALUES
(7, '2026-10-12', 'Completed'),
(8, '2026-10-13', 'Completed'),
(9, '2026-10-14', 'Pending'),
(7, '2026-10-15', 'Completed'),
(8, '2026-10-16', 'Cancelled');
SELECT * FROM orders;
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
DESCRIBE order_items;
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 45000.00),
(1, 2, 2, 500.00),
(2, 3, 1, 1200.00),
(3, 4, 1, 2500.00),
(4, 5, 2, 6500.00),
(5, 2, 1, 500.00);
SELECT
    c.customer_name,
    o.order_date,
    p.product_name,
    oi.quantity,
    oi.unit_price
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id;
    SELECT
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price AS total_amount
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id;
    SELECT
    SUM(quantity * unit_price) AS total_sales
FROM order_items;
SELECT
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC;
SELECT
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status;
SELECT
    SUM(oi.quantity * oi.unit_price) AS completed_sales
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed';
SELECT
    SUM(oi.quantity * oi.unit_price) AS cancelled_amount
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Cancelled';
SELECT
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales,
    CASE
        WHEN SUM(oi.quantity * oi.unit_price) >= 10000
            THEN 'High Sales'
        ELSE 'Low Sales'
    END AS sales_category
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sales DESC;
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;