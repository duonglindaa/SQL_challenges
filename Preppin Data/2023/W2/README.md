## Outcomes 🟰
[SQL script](https://github.com/duonglindaa/SQL_challenges/blob/main/Preppin%20Data/2023/W2/SQL%20script.sql)

<a name="learnings"></a>
## Learnings 🧠
Used CONCAT for the first time:
```
SELECT 
    t.transaction_id,
    CONCAT('GB',s.check_digits, s.swift_code, REPLACE(t.sort_code, '-', ''), t.account_number) AS IBAN
FROM PD2023_WK02_TRANSACTIONS as t
LEFT JOIN PD2023_WK02_SWIFT_CODES AS s ON s.bank=t.bank;
```


