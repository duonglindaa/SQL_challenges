--Split the Transaction Code to extract the letters at the start of the transaction code. These identify the bank who processes the transaction. Rename the new field with the Bank code 'Bank'.
--Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values.
--Change the date to be the day of the week.
SELECT 
    SPLIT_PART(transaction_code, '-', 1) AS Bank,
    transaction_code,
    value,
    customer_code,
    CASE
    WHEN online_or_in_person=1 THEN 'Online'
    WHEN online_or_in_person=2 THEN 'In-Person'
    ELSE NULL
    END AS online_or_in_person,
    DAYNAME(TO_DATE(LEFT(transaction_date, 10), 'DD/MM/YYYY')) AS transaction_date
FROM PD2023_WK01;


--Total Values of Transactions by each bank.
SELECT 
    SPLIT_PART(transaction_code, '-', 1) AS Bank,
    SUM(value) AS "Total value"
FROM PD2023_WK01
GROUP BY Bank;


--Total Values by Bank, Day of the Week and Type of Transaction (Online or In-Person)
SELECT 
    SPLIT_PART(transaction_code, '-', 1) AS Bank,
    CASE
    WHEN online_or_in_person=1 THEN 'Online'
    WHEN online_or_in_person=2 THEN 'In-Person'
    ELSE NULL
    END AS online_or_in_person,
    DAYNAME(TO_DATE(LEFT(transaction_date, 10), 'DD/MM/YYYY')) AS transaction_date,
    SUM(value) AS "Total value"
FROM PD2023_WK01
GROUP BY Bank, online_or_in_person, transaction_date;


--Total Values by Bank and Customer Code
SELECT 
    SPLIT_PART(transaction_code, '-', 1) AS Bank,
    customer_code,
    SUM(value) AS "Total value"
FROM PD2023_WK01
GROUP BY Bank, customer_code;
