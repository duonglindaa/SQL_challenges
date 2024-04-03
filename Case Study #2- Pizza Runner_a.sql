--A.PIZZA METRICS
--How many pizzas were ordered?
SELECT COUNT(*) as "Number of orders"
FROM CUSTOMER_ORDERS;


--How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) as "Number of orders"
FROM CUSTOMER_ORDERS;


--How many successful orders were delivered by each runner?
SELECT COUNT(*) as "Number of successful orders", runner_id
FROM RUNNER_ORDERS
WHERE pickup_time<>'null'
GROUP BY runner_id;


--How many of each type of pizza was delivered?
SELECT COUNT(*) as "Number of successful orders", pizza_id
FROM RUNNER_ORDERS AS R
INNER JOIN CUSTOMER_ORDERS AS C ON C.order_id=R.order_id
WHERE R.pickup_time<>'null'
GROUP BY  pizza_id;


--How many Vegetarian and Meatlovers were ordered by each customer?
WITH CTE AS (SELECT customer_id, pizza_name, COUNT (*) AS "Number of orders"
FROM CUSTOMER_ORDERS AS C
INNER JOIN PIZZA_NAMES AS P ON P.pizza_id=C.pizza_id
GROUP BY  customer_id, pizza_name)
SELECT customer_id, COALESCE("'Meatlovers'",0) AS "Number of Meatlovers", COALESCE("'Vegetarian'",0) AS "Number of Vegetarian"
FROM CTE
PIVOT (SUM("Number of orders") FOR pizza_name IN ('Meatlovers', 'Vegetarian'));


--What was the maximum number of pizzas delivered in a single order?
SELECT COUNT(*) as "Number of successful orders", R.order_id
FROM RUNNER_ORDERS AS R
INNER JOIN CUSTOMER_ORDERS AS C ON C.order_id=R.order_id
WHERE R.pickup_time<>'null'
GROUP BY R.order_id
ORDER BY COUNT (*) DESC
LIMIT 1;


--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
WITH CHANGES AS (
SELECT *,
(CASE 
    WHEN exclusions='' THEN 0
    WHEN exclusions='null' THEN 0
    WHEN exclusions='NaN' THEN 0
    WHEN exclusions IS NULL THEN 0
    ELSE 1
END)+
(CASE 
    WHEN extras='' THEN 0
    WHEN extras='null' THEN 0
    WHEN extras='NaN' THEN 0
    WHEN extras IS NULL THEN 0
    ELSE 1
END) AS changes
FROM CUSTOMER_ORDERS),

CHANGED AS(
SELECT C.*,
CASE
    WHEN changes=0 then 'changed'
    ELSE 'no change'
    END AS "Changed?"
FROM CHANGES AS C
INNER JOIN RUNNER_ORDERS AS R ON R.order_id=C.order_id
WHERE pickup_time<>'null')

SELECT customer_id, "Changed?", COUNT ("Changed?") AS "Number of orders"
FROM CHANGED
GROUP BY customer_id, "Changed?";


--How many pizzas were delivered that had both exclusions and extras?
WITH CHANGES AS (SELECT *,
(CASE 
    WHEN exclusions='' THEN 0
    WHEN exclusions='null' THEN 0
    WHEN exclusions='NaN' THEN 0
    WHEN exclusions IS NULL THEN 0
    ELSE 1
END)+
(CASE 
    WHEN extras='' THEN 0
    WHEN extras='null' THEN 0
    WHEN extras='NaN' THEN 0
    WHEN extras IS NULL THEN 0
    ELSE 1
END) AS changes
FROM CUSTOMER_ORDERS)

SELECT COUNT(*) AS "Number of pizzas with both exclusions and extras"
FROM CHANGES
WHERE changes>=2;


--What was the total volume of pizzas ordered for each hour of the day?
SELECT
    DATE_PART('hour', order_time) as hour, COUNT(*) AS "Total volume of pizzas"
FROM customer_orders
GROUP BY hour;


--What was the volume of orders for each day of the week?
SELECT
    DAYNAME(order_time) as day, COUNT(*) AS "Total volume of pizzas"
FROM customer_orders
GROUP BY day;





