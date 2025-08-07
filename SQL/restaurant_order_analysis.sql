use restaurant_db;

SELECT * FROM restaurant_db.menu_items;

SELECT 
count(*) as total_items 
FROM menu_items;

SELECT 
item_name, 
price 
from menu_items 
Order by price;

SELECT 
item_name, 
price 
from menu_items 
Order by price desc;

SELECT 
count(*) as number_of_italian_dishes 
from menu_items 
where category = "italian";

SELECT 
item_name, 
price 
FROM menu_items 
WHERE category = "italian" 
ORDER BY price 
LIMIT 5;

SELECT 
item_name, 
price 
FROM menu_items 
WHERE category = "italian" 
ORDER BY price DESC 
LIMIT 5;

SELECT 
category, 
count(*) as total_dishes, 
round(avg(price), 2) as average_price 
FROM menu_items 
GROUP BY category;

-- 1. View the order_details table
SELECT * FROM order_details;

-- 2. What is the date range of the table?
SELECT 
MIN(order_date) AS min_order_date, 
MAX(order_date) AS max_order_date 
FROM order_details;

-- 3. How many orders were made within this date range?
SELECT 
count(distinct order_id) as total_orders 
FROM order_details;

-- 4. How many items were ordered within this date range?
SELECT 
count(*) as total_items_ordered 
FROM order_details;

-- 5. Which orders had the most number of items?
SELECT 
order_id, 
count(item_id) as items 
FROM order_details 
GROUP BY order_id 
order by items desc;

-- 6. How many orders had more than 12 items?
SELECT 
count(*) as orders_with_more_than_12_items 
FROM (
SELECT order_id,
count(item_id) AS items
FROM
order_details 
GROUP BY order_id
HAVING items > 12
ORDER BY items desc) as orders;

-- 1. Combie the menu_items and order_details tables into a single table.
SELECT * FROM
order_details as od
JOIN
menu_items as mi
ON
od.item_id = mi.menu_item_id;

-- 2. What are the least and most ordered items? What categories were they in?
SELECT mi.item_name, 
mi.category,
count(*) AS times_ordered
FROM
order_details AS od
JOIN
menu_items as mi
ON
od.item_id = mi.menu_item_id
GROUP BY mi.item_name, mi.category
ORDER BY times_ordered DESC;

SELECT mi.item_name, 
mi.category,
count(*) AS times_ordered
FROM
order_details AS od
JOIN
menu_items as mi
ON
od.item_id = mi.menu_item_id
GROUP BY mi.item_name, mi.category
ORDER BY times_ordered ASC;

-- 3. What are the top 5 orders that spent the most money

SELECT order_id,
SUM(mi.price) as total_order_value
FROM
order_details AS od
JOIN
menu_items as mi
ON
od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY total_order_value desc
LIMIT 5;

-- 4. View the details of the highest spend order? What insight are gathered from the result?
SELECT order_id, category, count(*) as items_count FROM 
order_details AS od
JOIN
menu_items as mi
ON
od.item_id = mi.menu_item_id
WHERE od.order_id = (SELECT order_id
FROM
order_details AS od
JOIN
menu_items as mi
ON
od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY SUM(mi.price) DESC
LIMIT 1)
GROUP BY order_id, category
ORDER BY items_count DESC;

-- 5. View the details of the 5 highest spend order? What insights are gathered from the results?
SELECT od.order_id, mi.category, count(*) as items_count
FROM order_details od
LEFT JOIN
menu_items mi
ON
od.item_id = mi.menu_item_id
JOIN (
SELECT order_id
FROM order_details od
LEFT JOIN
menu_items mi
ON
mi.menu_item_id = od.item_id
GROUP BY order_id
ORDER BY sum(price) DESC
LIMIT 5) top5_orders ON od.order_id = top5_orders.order_id
Group BY od.order_id, mi.category
ORDER BY od.order_id, items_count DESC;

