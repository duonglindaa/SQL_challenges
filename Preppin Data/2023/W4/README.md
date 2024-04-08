## Outcomes 🟰
[SQL script](https://github.com/duonglindaa/SQL_challenges/blob/main/Preppin%20Data/2023/W4/SQL%20script.sql)

<a name="learnings"></a>
## Learnings 🧠
LPAD:
```
SELECT 
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
FROM stacked_table;
```

Index LOD grouped by a field (in Tableau terms):
```
SELECT
    id::STRING AS id,
    joining_date,
    account_type,
    date_of_birth::DATE AS date_of_birth,
    ethnicity,
    ROW_NUMBER() OVER(PARTITION BY id ORDER BY joining_date ASC) as joining_date_index
FROM PREPIVOT;
```


