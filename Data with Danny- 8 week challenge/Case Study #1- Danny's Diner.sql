--What is the total amount each customer spent at the restaurant?
SELECT CUSTOMER_ID, SUM(PRICE) AS "Total Price"
FROM SALES AS S
INNER JOIN MENU AS M ON S.PRODUCT_ID=M.PRODUCT_ID
GROUP BY S.CUSTOMER_ID;


--How many days has each customer visited the restaurant?
SELECT CUSTOMER_ID, COUNT(DISTINCT ORDER_DATE) AS "Number of days visited"
FROM SALES
GROUP BY CUSTOMER_ID;


---What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT
    PRODUCT_NAME,
    COUNT(ORDER_DATE) AS "Number of purchases"
FROM MENU AS M
LEFT JOIN SALES AS S ON M.PRODUCT_ID=S.PRODUCT_ID
GROUP BY PRODUCT_NAME
ORDER BY "Number of purchases" DESC
LIMIT 1;


--Which item was purchased first by customer A after they became a member?
SELECT
    Mu.PRODUCT_NAME AS "Product first purchased after joining",
    S.CUSTOMER_ID
FROM SALES AS S
INNER JOIN MEMBERS AS Me ON Me.CUSTOMER_ID=S.CUSTOMER_ID
INNER JOIN MENU AS Mu ON Mu.PRODUCT_ID=S.PRODUCT_ID
WHERE S.CUSTOMER_ID='A' and S.ORDER_DATE>=Me.JOIN_DATE
ORDER BY S.ORDER_DATE
LIMIT 1;


--Convert join date to date rather than timestamp
SELECT CAST(JOIN_DATE AS DATE)
FROM MEMBERS;


