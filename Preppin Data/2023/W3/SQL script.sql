--Filter the transactions to just look at DSB
--Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values
--Change the date to be the quarter 
--Sum the transaction values for each quarter and for each Type of Transaction (Online or In-Person)
SELECT 
    SPLIT_PART(transaction_code, '-', 1) AS Bank,
    CASE
    WHEN online_or_in_person=1 THEN 'Online'
    WHEN online_or_in_person=2 THEN 'In-Person'
    ELSE NULL
    END AS online_or_in_person,
    DATE_PART('quarter', TO_DATE(LEFT(transaction_date, 10), 'DD/MM/YYYY')) AS Quarters,
    SUM(PD2023_WK01.value) AS "Total Value"
FROM PD2023_WK01
WHERE Bank='DSB'
GROUP BY Bank, online_or_in_person, Quarters;


--Pivot the quarterly targets so we have a row for each Type of Transaction and each Quarter
--Rename fields
--Remove the 'Q' from the quarter field and make the data type numeric
SELECT 
    online_or_in_person,
    (REPLACE(Quarters, 'Q', '')::INT) AS Quarters,
    Target
FROM PD2023_WK03_TARGETS
UNPIVOT (Target FOR Quarters IN (Q1, Q2, Q3, Q4))
;


--Join the two datasets together
--Calculate the Variance to Target for each row
--Remove unnecessary fields
WITH Target AS (
SELECT 
    online_or_in_person,
    (REPLACE(Quarters, 'Q', '')::INT) AS Quarters,
    Target
FROM PD2023_WK03_TARGETS
UNPIVOT (Target FOR Quarters IN (Q1, Q2, Q3, Q4))
),
Actual AS (
SELECT 
    SPLIT_PART(transaction_code, '-', 1) AS Bank,
    CASE
    WHEN online_or_in_person=1 THEN 'Online'
    WHEN online_or_in_person=2 THEN 'In-Person'
    ELSE NULL
    END AS online_or_in_person,
    DATE_PART('quarter', TO_DATE(LEFT(transaction_date, 10), 'DD/MM/YYYY')) AS Quarters,
    SUM(PD2023_WK01.value) AS Value
FROM PD2023_WK01
WHERE Bank='DSB'
GROUP BY Bank, online_or_in_person, Quarters
)

SELECT 
    A.online_or_in_person,
    A.Quarters,
    A.Value,
    T.Target,
    (A.Value - T.Target) AS "Variance to Target"
FROM Actual AS A
INNER JOIN Target AS T ON T.online_or_in_person=A.online_or_in_person AND A.Quarters=T.Quarters;

