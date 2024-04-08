## Outcomes 🟰
[SQL script](https://github.com/duonglindaa/SQL_challenges/blob/main/Preppin%20Data/2023/W3/SQL%20script.sql)

<a name="learnings"></a>
## Learnings 🧠
UNPIVOT:
```
SELECT 
    online_or_in_person,
    (REPLACE(Quarters, 'Q', '')::INT) AS Quarters,
    Target
FROM PD2023_WK03_TARGETS
UNPIVOT (Target FOR Quarters IN (Q1, Q2, Q3, Q4))
)
```

Multiple joins:
```
SELECT 
    A.online_or_in_person,
    A.Quarters,
    A.Value,
    T.Target,
    (A.Value - T.Target) AS "Variance to Target"
FROM Actual AS A
INNER JOIN Target AS T ON T.online_or_in_person=A.online_or_in_person AND A.Quarters=T.Quarters;
```


