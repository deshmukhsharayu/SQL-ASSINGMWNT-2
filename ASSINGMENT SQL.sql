#Assingment SQL

CREATE DATABASE pizaa_db;

USE pizaa_db;

SELECT * FROM pizzas;

SELECT * FROM orders;

SELECT * FROM pizza_types;

SELECT * FROM order_details;


#BASIC LEVEL

#1Retrieve the total number of orders placed.
SELECT COUNT(*) AS total_orders
FROM orders;

#2Calculate the total revenue generated from pizza sales.
SELECT round(SUM(order_details.quantity * pizzas.price),2)
"Total Revenue"
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id;

#2Calculate the total revenue generated from pizza sales.
SELECT round(SUM(od.quantity * p.price),2)
"Total Revenue"
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;


#3.Identify the highest-priced pizza.
SELECT pizza_id, price
FROM pizzas
ORDER BY price DESC;

#4. Identify the most common pizza size ordered.
SELECT size, COUNT(*) 
FROM pizzas
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY size
ORDER BY COUNT(*) DESC
LIMIT 1;

#5.Find cheese pizza
SELECT *
FROM pizza_types
WHERE ingredients LIKE '%Cheese%';

#6. most ordered pizzas
SELECT SUM(od.quantity)  total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity DESC
LIMIT 5;

#INTERMIDATE LEVEL
#1. Total quantity of each pizza category ordered
SELECT pt.category, 
       SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity DESC;

##2. Distribution of orders by hour of the day
SELECT hour(o.order_time) AS order_hour, COUNT(o.order_id) AS total_orders
FROM orders o
GROUP BY HOUR(o.order_time)
ORDER BY order_hour;

#3. Category-wise distribution of pizzas
SELECT pt.category, COUNT(DISTINCT p.pizza_id) AS total_pizzas
FROM pizzas p
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_pizzas DESC;

##4. Average number of pizzas ordered per day
SELECT o.order_date, SUM(od.quantity) AS total_pizzas,
AVG(SUM(od.quantity)) OVER () AS avg_pizzas_per_day
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_date
ORDER BY o.order_date;

#5. Determine the top 3 most ordered pizza types based on revenue.
SELECT pt.name AS pizza_type,
       SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 3;

#ADVANCE LEVEL

#1. Percentage contribution of each pizza type to total revenue
SELECT pt.name AS pizza_type,
       SUM(od.quantity * p.price) AS revenue,
       (SUM(od.quantity * p.price) * 100) / 
       (SELECT SUM(od2.quantity * p2.price)
        FROM order_details od2
        JOIN pizzas p2 ON od2.pizza_id = p2.pizza_id) AS percentage
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue DESC;

#2. Cumulative revenue generated over time
SELECT o.order_date,
       SUM(od.quantity * p.price) AS daily_revenue,
       SUM(SUM(od.quantity * p.price)) 
           OVER (ORDER BY o.order_date) AS cumulative_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY o.order_date
ORDER BY o.order_date;

#3. Top 3 pizzas by revenue in each category
SELECT pt.category, pt.name AS pizza_type,
       SUM(od.quantity * p.price) AS revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category, pt.name
ORDER BY pt.category, revenue DESC
LIMIT 3;