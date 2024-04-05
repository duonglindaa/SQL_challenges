## Outcomes 🟰
[SQL script](https://github.com/duonglindaa/SQL_challenges/blob/main/Preppin%20Data/2023/W1/SQL%20script.sql)

<a name="learnings"></a>
## Learnings 🧠
Used SPLIT_PART for the first time:
```
SELECT 
    SPLIT_PART(transaction_code, '-', 1) AS Bank,
    SUM(value) AS "Total value"
FROM PD2023_WK01
GROUP BY Bank;
```

