--A. CUSTOMER JOURNEY

--Briefly describe the first 8 customers’ onboarding journey.
SELECT *
FROM SUBSCRIPTIONS AS S
INNER JOIN PLANS AS P ON S.plan_id=P.plan_id
WHERE customer_id<=8;
--Customer ID:1 after their trial used basic monthly subscription
--Customer ID:2 after their trial they moved onto pro annual subscription
--Customer ID:3 same as Customer ID:1
--Customer ID:4 after the trial used basic monthly subscription, but after around 3 months they decided to end their service
--Customer ID:5 same as Customer ID:1
--Customer ID:6 after the trial used basic monthly subscription, but after around 2 months they decided to end their service
--Customer ID:7 after the trial used basic monthly subscription and after 3,5 months decided to change to pro monthly
--Customer ID:8 after the trial used basic monthly subscription and after 1,5 months decided to change to pro monthly



--B. DATA ANALYSIS

-- 1. How many customers has Foodie-Fi ever had?
SELECT COUNT(DISTINCT customer_id) AS "Total Customers Ever"
FROM SUBSCRIPTIONS
;

-- 2. What is our dataset's monthly distribution of trial plan start_date values?
SELECT 
    DATE_TRUNC('month', start_date) AS "Start of the Month",
    COUNT(S.plan_id) AS "Distribution of Trial Plans"
FROM SUBSCRIPTIONS AS S
INNER JOIN PLANS AS P ON S.plan_id=P.plan_id
WHERE plan_name='trial'
GROUP BY "Start of the Month"
;

-- 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
SELECT P.plan_name, COUNT(start_date) AS "Number of events" 
FROM subscriptions AS S
INNER JOIN plans AS P ON S.plan_id=P.plan_id
WHERE DATE_PART('year', start_date)>2020
GROUP BY plan_name
;

-- 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
SELECT COUNT(customer_id) AS "Total Number of Customers",
    (SELECT COUNT(customer_id) AS "Total Number of Customers"
    FROM subscriptions AS S
    INNER JOIN plans AS P ON S.plan_id=P.plan_id
    WHERE P.plan_name='churn') AS "Number of Churned Customers",
    CONCAT(ROUND("Number of Churned Customers"/"Total Number of Customers"*100,1), '%') AS "Percentage of Customers who have Churned"
FROM subscriptions AS S
;

-- 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
WITH PLANS AS(
    SELECT customer_id, COUNT(plan_id) AS "Number of plans"
    FROM SUBSCRIPTIONS
    GROUP BY customer_id),
    
CHURNED AS(
SELECT S.customer_id,
    "Number of plans",
    "Max Plan ID"
FROM SUBSCRIPTIONS AS S
INNER JOIN PLANS AS P ON S.customer_id=P.customer_id
JOIN (
    SELECT customer_id, MAX(plan_id) AS "Max Plan ID"
    FROM SUBSCRIPTIONS
    GROUP BY customer_id
) AS Mx ON Mx.customer_id=S.customer_id
WHERE "Number of plans"=2 AND "Max Plan ID"=4)

SELECT COUNT(DISTINCT customer_id) AS "Number of Customers Churned",
    (SELECT COUNT(DISTINCT customer_id)
    FROM SUBSCRIPTIONS) AS "Total Number of Customers",
    CONCAT(ROUND("Number of Customers Churned"/"Total Number of Customers"*100,0), '%') AS "Percentage of Customers who have Churned after Trial"
FROM CHURNED AS C
;

-- 6. What is the number and percentage of customer plans after their initial free trial?
SELECT COUNT(S.plan_id) AS "Number of Customer Plans",
    (SELECT COUNT(S.plan_id)
    FROM SUBSCRIPTIONS AS S
    INNER JOIN PLANS AS P ON S.plan_id=P.plan_id
    WHERE plan_name<>'churn') AS "Total Number of Customer Plans",
    CONCAT(ROUND("Number of Customer Plans"/"Total Number of Customer Plans"*100,1), '%') AS "Percentage of Plans after Trial"
FROM SUBSCRIPTIONS AS S
INNER JOIN PLANS AS P ON S.plan_id=P.plan_id
WHERE plan_name<>'trial' AND plan_name<>'churn'
;

-- 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
WITH LIST AS (
SELECT 
    S.customer_id,
    S.plan_id,
    S.start_date,
    "Max Plan ID"
FROM SUBSCRIPTIONS AS S
INNER JOIN 
    (SELECT customer_id, MAX(plan_id) AS "Max Plan ID"
    FROM SUBSCRIPTIONS
    GROUP BY customer_id
) AS Mx ON Mx.customer_id=S.customer_id
WHERE start_date<='2020-12-31' AND "Max Plan ID"<>4),

PLAN_COUNT AS (
SELECT 
    P.plan_name,
    COUNT(DISTINCT L.customer_id) AS "Count"
FROM PLANS AS P
INNER JOIN LIST AS L ON L.plan_id=P.plan_id
GROUP BY  P.plan_name
),

TOTAL AS(
SELECT SUM("Count") AS Total_Count
FROM PLAN_COUNT)

SELECT 
    P.plan_name,
    P."Count",
    CONCAT(ROUND(P."Count"/T.Total_Count*100, 1), '%') AS "% of Total "
FROM PLAN_COUNT AS P
CROSS JOIN TOTAL AS T
;

-- 8. How many customers have upgraded to an annual plan in 2020?
SELECT COUNT(DISTINCT customer_id) AS "Number of Customers Upgrading to Annual Plan"
FROM SUBSCRIPTIONS AS S
INNER JOIN PLANS AS P ON S.plan_id=P.plan_id
WHERE DATE_PART('year', start_date)=2020
    AND CONTAINS(plan_name, 'annual')
;

--9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
WITH ANNUAL_CUSTOMERS AS(
SELECT customer_id
FROM SUBSCRIPTIONS AS S
INNER JOIN PLANS AS P ON S.plan_id=P.plan_id
WHERE CONTAINS(plan_name, 'annual')),

CUSTOMERS AS (
SELECT 
    S.customer_id,
    S.start_date,
    P.plan_name
FROM SUBSCRIPTIONS AS S
INNER JOIN ANNUAL_CUSTOMERS AS A ON A.customer_id=S.customer_id
INNER JOIN PLANS AS P ON S.plan_id=P.plan_id
WHERE S.plan_id=0 OR S.plan_id=3),

DAYS AS(
SELECT  
    *,
    DATEDIFF('DAY', "'trial'", "'pro annual'") AS "Number of days til annual upgrade"
FROM CUSTOMERS
PIVOT (
    MIN(start_date) FOR plan_name IN ('trial' , 'pro annual' )
) AS PivotTable)

SELECT ROUND(AVG("Number of days til annual upgrade"),0) AS "Average days to upgrade to annual plan"
FROM DAYS
;

-- 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
WITH ANNUAL_CUSTOMERS AS(
SELECT customer_id
FROM SUBSCRIPTIONS AS S
INNER JOIN PLANS AS P ON S.plan_id=P.plan_id
WHERE CONTAINS(plan_name, 'annual')),

CUSTOMERS AS (
SELECT 
    S.customer_id,
    S.start_date,
    P.plan_name
FROM SUBSCRIPTIONS AS S
INNER JOIN ANNUAL_CUSTOMERS AS A ON A.customer_id=S.customer_id
INNER JOIN PLANS AS P ON S.plan_id=P.plan_id
WHERE S.plan_id=0 OR S.plan_id=3),

DAYS AS (
SELECT  
    *,
    DATEDIFF('DAY', "'trial'", "'pro annual'") AS "Number of days til annual upgrade"
FROM CUSTOMERS
PIVOT (
    MIN(start_date) FOR plan_name IN ('trial', 'pro annual' )
) AS PivotTable)

SELECT
    CASE
        WHEN "Number of days til annual upgrade" <= 30 THEN '0-30'
        WHEN "Number of days til annual upgrade" <= 60 THEN '31-60'
        WHEN "Number of days til annual upgrade" <= 90 THEN '61-90'
        WHEN "Number of days til annual upgrade" <= 120 THEN '91-120'
        WHEN "Number of days til annual upgrade" <= 150 THEN '121-150'
        WHEN "Number of days til annual upgrade" <= 180 THEN '151-180'
        WHEN "Number of days til annual upgrade" <= 210 THEN '181-210'
        WHEN "Number of days til annual upgrade" <= 240 THEN '211-240'
        WHEN "Number of days til annual upgrade" <= 270 THEN '241-270'
        WHEN "Number of days til annual upgrade" <= 300 THEN '271-300'
        WHEN "Number of days til annual upgrade" <= 330 THEN '301-330'
        WHEN "Number of days til annual upgrade" <= 360 THEN '331-360'
    END AS "Bin",
    COUNT(customer_id) AS "Number of Customers"
FROM DAYS
GROUP BY "Bin"
;

-- 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
WITH BASIC AS(
SELECT *
FROM SUBSCRIPTIONS AS S
INNER JOIN PLANS AS P ON S.plan_id=P.plan_id
WHERE plan_name='basic monthly' AND YEAR(start_date)=2020),

PRO AS(
SELECT *
FROM SUBSCRIPTIONS AS S
INNER JOIN PLANS AS P ON S.plan_id=P.plan_id
WHERE plan_name='pro monthly' AND YEAR(start_date)=2020),

STARTS AS(
SELECT 
    P.customer_id,
    B.start_date AS basic_start,
    P.start_date AS pro_start,
    basic_start > pro_start AS "Downgraded?"
FROM PRO AS P
INNER JOIN BASIC AS B ON B.customer_id=P.customer_id)

SELECT COUNT("Downgraded?") AS "Number of customers downgraded"
FROM STARTS
WHERE "Downgraded?"=TRUE
;
