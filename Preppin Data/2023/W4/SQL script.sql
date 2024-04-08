--We want to stack the tables on top of one another, since they have the same fields in each sheet.
--Make a Joining Date field based on the Joining Day, Table Names and the year 2023
--Now we want to reshape our data so we have a field for each demographic, for each new customer
--If a customer appears multiple times take their earliest joining date
WITH stacked_table AS (
SELECT *, 'April' AS table_name
FROM PD2023_WK04_APRIL
UNION ALL

SELECT *, 'August' AS table_name
FROM PD2023_WK04_AUGUST
UNION ALL

SELECT *, 'December' AS table_name
FROM PD2023_WK04_DECEMBER
UNION ALL

SELECT *, 'February' AS table_name
FROM PD2023_WK04_FEBRUARY
UNION ALL

SELECT *, 'January' AS table_name
FROM PD2023_WK04_JANUARY
UNION ALL

SELECT *, 'July' AS table_name
FROM PD2023_WK04_JULY
UNION ALL

SELECT *, 'June' AS table_name
FROM PD2023_WK04_JUNE
UNION ALL

SELECT *, 'March' AS table_name
FROM PD2023_WK04_MARCH
UNION ALL

SELECT *, 'May' AS table_name
FROM PD2023_WK04_MAY
UNION ALL

SELECT *, 'November' AS table_name
FROM PD2023_WK04_NOVEMBER
UNION ALL

SELECT *, 'October' AS table_name
FROM PD2023_WK04_OCTOBER
UNION ALL

SELECT *, 'September' AS table_name
FROM PD2023_WK04_SEPTEMBER),

PREPIVOT AS (SELECT 
    id,
    TO_DATE(
        CONCAT(
            '2023',
            CASE
                WHEN table_name='January' THEN '01'
                WHEN table_name='February' THEN '02'
                WHEN table_name='March' THEN '03'
                WHEN table_name='April' THEN '04'
                WHEN table_name='May' THEN '05'
                WHEN table_name='June' THEN '06'
                WHEN table_name='July' THEN '07'
                WHEN table_name='August' THEN '08'
                WHEN table_name='September' THEN '09'
                WHEN table_name='October' THEN '10'
                WHEN table_name='November' THEN '11'
                WHEN table_name='December' THEN '12'
                END,
            LPAD(joining_day, 2, '0')),
        'YYYYMMDD') AS joining_date,
        demographic,
        value
FROM stacked_table),

POSTPIVOT AS(
SELECT
    id::STRING AS id,
    joining_date,
    account_type,
    date_of_birth::DATE AS date_of_birth,
    ethnicity,
    ROW_NUMBER() OVER(PARTITION BY id ORDER BY joining_date ASC) as joining_date_index
FROM PREPIVOT
PIVOT(MIN(value) FOR demographic IN ('Ethnicity', 'Date of Birth', 'Account Type')) AS P
    (id,
    joining_date,
    ethnicity,
    date_of_birth,
    account_type)
)


SELECT
  id,
  joining_date,
  account_type,
  date_of_birth,
  ethnicity
FROM POSTPIVOT
WHERE joining_date_index=1
;
